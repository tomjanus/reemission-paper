# Notebook imports
import pathlib
import importlib
import pickle
from functools import partial
import matplotlib.pyplot as plt
from rich import print as rprint
from reemission.salib.runners import SALibProblem, SobolAnalyser
from reemission.salib.wrappers import TestModelSALibWrapper, ReEmissionSALibWrapper
from reemission.salib.visualize import SobolResultVisualizer, SobolScenarioResultsVisualizer
from reemission.salib.specloaders import (
    ReEmissionSALibSpecLoader,
    set_unit_input_distribution_using_rel_diffrence)
from reemission.input import Inputs

# Constants
REL_DIFF = 0.1

if __name__ == "__main__":
    # Run SOBOL analysis for a subset of UK reservoirs - can take a long time
    uk_input_file = pathlib.Path("../data/uk_inputs.json").resolve()
    spec_file = "params_reemission_reg_diff_only.yaml"
    inputs = Inputs.fromfile(uk_input_file)

    reservoirs_list_uk = list(inputs.inputs.keys())
    rprint(f"Number of reservoirs: {len(reservoirs_list_uk)}")
    selected_reservoirs = reservoirs_list_uk[:]
    
    for res_no, reservoir in enumerate(selected_reservoirs):
        print(f"Running SOBOL analysis for reservoir: {reservoir} - {res_no + 1} out of {len(selected_reservoirs)}")
        selected_input = inputs.get_input(reservoir) # Use a single reservoir
        # Set the relative +/- difference for the inputs with missing distributions
        rel_difference: float = 0.1
        # Load the SALib specification for the re-emission model
        reemission_salib_spec = ReEmissionSALibSpecLoader(
            spec_file=spec_file,
            input=selected_input,
            missing_input_dist_handler = 
                partial(
                    set_unit_input_distribution_using_rel_diffrence,
                    rel_difference=rel_difference)
        )
        # Var names for visualization
        var_names = reemission_salib_spec.var_name_map
        # Create a list of variables from the SALib specification
        reemission_variables = reemission_salib_spec.list_of_variables
        # Create a list of accessors from the SALib specification
        accessors = reemission_salib_spec.accessors
        reemission_salib_problem = SALibProblem.from_variables(
            reemission_variables
        )
        reemission_salib_model = ReEmissionSALibWrapper.from_variables(
            variables = reemission_variables,
            input = selected_input,
            emission = 'total_net',
            accessors = accessors
        )
        analyser = SobolAnalyser(
            problem = reemission_salib_problem,
            variables = reemission_variables,
            model = reemission_salib_model,
            num_samples = 4096
        )
        results = analyser.run_sobol()

        # Save results
        file_name = pathlib.Path("../outputs_and_intermediate/sobol_outputs_uk_diff_only") / f"{reservoir}.pkl"
        with open(file_name, 'wb') as handle:
            pickle.dump(results, handle, protocol=pickle.HIGHEST_PROTOCOL)
