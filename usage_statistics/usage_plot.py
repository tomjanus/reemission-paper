"""
plot_timeseries_publication.py

Publication-quality bar figure for a short time series.
Saves both PDF (vector) and PNG (300 dpi).
"""

from datetime import datetime
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from matplotlib.ticker import ScalarFormatter

# ----- Data -----
time_strings = [
    "Mon Dec 08 2025 13:05:00 GMT+0100",
    "Mon Dec 08 2025 13:10:00 GMT+0100",
    "Mon Dec 08 2025 13:20:00 GMT+0100",
    "Mon Dec 08 2025 13:25:00 GMT+0100",
    "Mon Dec 08 2025 13:30:00 GMT+0100",
    "Mon Dec 08 2025 13:35:00 GMT+0100",
    "Mon Dec 08 2025 13:40:00 GMT+0100",
    "Mon Dec 08 2025 13:45:00 GMT+0100",
]

values = [
    0.000172353130008211,
    0.000233514492070496,
    0.117286116768452,
    0.255874212851575,
    0.06944357088681,
    0.0440177520990876,
    0.0377089471190238,
    0.000153143869855684,
]

# Parse times into datetime objects (strip timezone text)
times = [datetime.strptime(t[:24], "%a %b %d %Y %H:%M:%S") for t in time_strings]

# ----- Figure style settings (publication-ready) -----
plt.rcParams.update({
    "font.family": "serif",          # serif font for publication look
    "font.size": 10,                 # base font size
    "axes.labelsize": 11,
    "axes.titlesize": 12,
    "xtick.labelsize": 9,
    "ytick.labelsize": 9,
    "legend.fontsize": 9,
    "figure.dpi": 300,
})

fig, ax = plt.subplots(figsize=(6.0, 3.6))  # width x height in inches

# ----- Plot -----
# Use datetime values on x-axis: convert to matplotlib float dates
x = mdates.date2num(times)
width = 0.006  # width in days (~minutes). adjust if needed
width = 0.003

bars = ax.bar(x, values, width=width, align="center", edgecolor="black", linewidth=0.4)

# ----- Axes formatting -----
# X-axis: show hours and minutes
ax.xaxis.set_major_locator(mdates.MinuteLocator(byminute=[5,10,20,25,30,35,40,45]))
ax.xaxis.set_major_formatter(mdates.DateFormatter("%H:%M"))
plt.setp(ax.get_xticklabels(), rotation=45, ha="right")

# Y-axis: use scientific notation when needed
sf = ScalarFormatter(useMathText=True)
sf.set_powerlimits((-3, 3))  # show scientific notation outside these limits
ax.yaxis.set_major_formatter(sf)
ax.ticklabel_format(axis="y", style="sci", scilimits=(-3,3))  # complementary

# Gridlines (subtle)
ax.grid(axis="y", linestyle="--", linewidth=0.5, alpha=0.6)
ax.set_axisbelow(True)

# Remove top and right spines; thicken remaining spines slightly
ax.spines["top"].set_visible(False)
ax.spines["right"].set_visible(False)
for spine in ("left", "bottom"):
    ax.spines[spine].set_linewidth(0.8)

# Axis labels and title
ax.set_xlabel("Time (HH:MM)")
ax.set_ylabel("Value")
ax.set_title("Time series (short) — publication style")

# ----- Annotate bars with values (compact formatting) -----
def format_annotation(v):
    # show small values in scientific notation and larger values with 2 significant digits
    if abs(v) < 1e-3:
        return f"{v:.2e}"
    elif v < 0.01:
        return f"{v:.3f}"
    else:
        return f"{v:.3g}"

for rect, v in zip(bars, values):
    height = rect.get_height()
    ax.annotate(
        format_annotation(v),
        xy=(rect.get_x() + rect.get_width() / 2, height),
        xytext=(0, 3),  # 3 points vertical offset
        textcoords="offset points",
        ha="center",
        va="bottom",
        fontsize=8,
    )

# Tight layout and save
fig.tight_layout()
fig.savefig("timeseries_publication.pdf")      # vector for journal submission

# Also display
plt.show()

