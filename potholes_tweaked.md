
## R "magic"

- extension to the jupyter notebook
- defines "magic": `%%R` and `%R`


<dl>
<dt>In [1]:</dt>
<dd>
<pre><code data-trim class="python">
%load_ext rpy2.ipython
</code></pre>
</dd>
</dl>

---

- R code can be mixed with Python code
- Cells with R code are prefixed with `%%R`
- The R output is returned


<dl>
<dt>In [2]:</dt>
<dd>
<pre><code data-trim class="python">
%%R

R.version

</code></pre>
</dd>
</dl>


                   _                                          
    platform       x86_64-pc-linux-gnu                        
    arch           x86_64                                     
    os             linux-gnu                                  
    system         x86_64, linux-gnu                          
    status         Patched                                    
    major          3                                          
    minor          2.3                                        
    year           2015                                       
    month          12                                         
    day            22                                         
    svn rev        69809                                      
    language       R                                          
    version.string R version 3.2.3 Patched (2015-12-22 r69809)
    nickname       Wooden Christmas-Tree                      



---


<dl>
<dt>In [3]:</dt>
<dd>
<pre><code data-trim class="python">
%%R
## Dobson (1990) Page 93: Randomized Controlled Trial :
counts <- c(18,17,15,20,10,20,25,13,12)
outcome <- gl(3,1,9)
treatment <- gl(3,3)
print(d.AD <- data.frame(treatment, outcome, counts))
glm.D93 <- glm(counts ~ outcome + treatment, family = poisson())
anova(glm.D93)
</code></pre>
</dd>
</dl>


      treatment outcome counts
    1         1       1     18
    2         1       2     17
    3         1       3     15
    4         2       1     20
    5         2       2     10
    6         2       3     20
    7         3       1     25
    8         3       2     13
    9         3       3     12
    Analysis of Deviance Table
    
    Model: poisson, link: log
    
    Response: counts
    
    Terms added sequentially (first to last)
    
    
              Df Deviance Resid. Df Resid. Dev
    NULL                          8    10.5814
    outcome    2   5.4523         6     5.1291
    treatment  2   0.0000         4     5.1291



---

### Communicating with the outside world (Python)


<dl>
<dt>In [4]:</dt>
<dd>
<pre><code data-trim class="python">
FILENAME = "Pothole_Repair_Requests.csv"
</code></pre>
</dd>
</dl>

- "`-i`": into R
- "`-o`": out of R


<dl>
<dt>In [5]:</dt>
<dd>
<pre><code data-trim class="python">
%%R -i FILENAME -o result
print(FILENAME)
result <- 2*pi
</code></pre>
</dd>
</dl>


    [1] "Pothole_Repair_Requests.csv"




<dl>
<dt>In [6]:</dt>
<dd>
<pre><code data-trim class="python">
print(result)
</code></pre>
</dd>
</dl>

    [ 6.28318531]


---

# Data table

- Running code in 2 languages is nice...
- ...but code objects should be passed back and forth
- The "data table" is:
  * a high-level data structure
  * common (in concept) across Python, R (and SQL, etc...)

---

## Dataset

<table>
<tbody>
<tr>
  <td>
  <ul>
   <li>Cambridge nice for cyclists (picture's from NYC)</li>
   <li class="fragment">winter can be harsh</li>
   <li class="fragment">Cambridge is awesome, the city has an "Open Data" portal.</li>
   <li class="fragment">Today we shall obsess over potholes.</li>
  </ul>
  </td>
  <td>
     <a title="By David Shankbone (David Shankbone) [CC BY-SA 3.0 (http://creativecommons.org/licenses/by-sa/3.0) or GFDL (http://www.gnu.org/copyleft/fdl.html)], via Wikimedia Commons" href="https://commons.wikimedia.org/wiki/File%3ALarge_pot_hole_on_2nd_Avenue_in_New_York_City.JPG"><img width="512" alt="Large pot hole on 2nd Avenue in New York City" src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/Large_pot_hole_on_2nd_Avenue_in_New_York_City.JPG/512px-Large_pot_hole_on_2nd_Avenue_in_New_York_City.JPG"/></a>
  </td>
  </tr>
  </tbody>
  </table>
<small><a href="https://data.cambridgema.gov/Public-Works/Pothole-Repair-Requests/h2y4-rf5c">https://data.cambridgema.gov/Public-Works/Pothole-Repair-Requests/h2y4-rf5c</a></small>

---

## Reading from a CSV file

### Pandas


<dl>
<dt>In [7]:</dt>
<dd>
<pre><code data-trim class="python">
# FILENAME = "Pothole_Repair_Requests.csv"
import pandas
pdataf = pandas.read_csv(FILENAME)
</code></pre>
</dd>
</dl>

---

### R "magic"


<dl>
<dt>In [8]:</dt>
<dd>
<pre><code data-trim class="python">
%%R -i FILENAME
dataf <- read.csv(FILENAME)
str(dataf)
</code></pre>
</dd>
</dl>


    'data.frame':	6161 obs. of  8 variables:
     $ Request.ID    : Factor w/ 6160 levels "","REQ194189",..: 2 3 4 5 6 7 8 9 10 11 ...
     $ Status        : Factor w/ 5 levels "","Assigned",..: 3 3 3 3 3 3 3 3 3 3 ...
     $ Action.Type   : Factor w/ 2 levels "","Repair Pothole in Street": 2 2 2 2 2 2 2 2 2 2 ...
     $ Date.Submitted: Factor w/ 2670 levels "","01/01/2013 12:00:00 AM",..: 69 69 69 69 69 69 69 69 81 81 ...
     $ Date.Completed: Factor w/ 1922 levels "","01/02/2012 12:00:00 AM",..: 55 55 55 55 55 55 55 55 74 74 ...
     $ Address       : Factor w/ 3558 levels "","1 Aberdeen Ave\nCambridge, MA\n(42.37734449700048, -71.14744958699964)",..: 3154 3500 3094 3448 2247 3398 2571 3451 3197 3400 ...
     $ Platform      : Factor w/ 8 levels "","0","Android",..: 1 1 1 1 1 1 1 1 1 1 ...
     $ Submitted.By  : Factor w/ 48 levels "","anagle","apedro",..: 7 7 7 7 7 7 7 7 7 7 ...



---

#### R has namespaces


<dl>
<dt>In [9]:</dt>
<dd>
<pre><code data-trim class="python">
%%R -i FILENAME
dataf <- utils::read.csv(FILENAME)
str(dataf)
</code></pre>
</dd>
</dl>


    'data.frame':	6161 obs. of  8 variables:
     $ Request.ID    : Factor w/ 6160 levels "","REQ194189",..: 2 3 4 5 6 7 8 9 10 11 ...
     $ Status        : Factor w/ 5 levels "","Assigned",..: 3 3 3 3 3 3 3 3 3 3 ...
     $ Action.Type   : Factor w/ 2 levels "","Repair Pothole in Street": 2 2 2 2 2 2 2 2 2 2 ...
     $ Date.Submitted: Factor w/ 2670 levels "","01/01/2013 12:00:00 AM",..: 69 69 69 69 69 69 69 69 81 81 ...
     $ Date.Completed: Factor w/ 1922 levels "","01/02/2012 12:00:00 AM",..: 55 55 55 55 55 55 55 55 74 74 ...
     $ Address       : Factor w/ 3558 levels "","1 Aberdeen Ave\nCambridge, MA\n(42.37734449700048, -71.14744958699964)",..: 3154 3500 3094 3448 2247 3398 2571 3451 3197 3400 ...
     $ Platform      : Factor w/ 8 levels "","0","Android",..: 1 1 1 1 1 1 1 1 1 1 ...
     $ Submitted.By  : Factor w/ 48 levels "","anagle","apedro",..: 7 7 7 7 7 7 7 7 7 7 ...



---

### R from Python

#### R packages in Python namespaces


<dl>
<dt>In [10]:</dt>
<dd>
<pre><code data-trim class="python">
from rpy2.robjects.packages import importr
utils = importr('utils')
</code></pre>
</dd>
</dl>

The Python object "`utils`" is a namespace.

Write `utils.` in a cell and hit <kbd>tab</kbd>.

---


<dl>
<dt>In [11]:</dt>
<dd>
<pre><code data-trim class="python">
dataf = utils.read_csv(FILENAME)
</code></pre>
</dd>
</dl>


<dl>
<dt>In [12]:</dt>
<dd>
<pre><code data-trim class="python">
print(dataf.colnames)
</code></pre>
</dd>
</dl>

    [1] "Request.ID"     "Status"         "Action.Type"    "Date.Submitted"
    [5] "Date.Completed" "Address"        "Platform"       "Submitted.By"  
    


---

# GGplot2 graphics

Build graphics with:
- "mappings": associate "columns" with visual dimensions
- "layers"  : additive declarations to build a figure

<hr>


<dl>
<dt>In [13]:</dt>
<dd>
<pre><code data-trim class="python">
%%R
# makes graphics prettier on my Linux system.
default_bitmapType <- getOption("bitmapType")
options(bitmapType="cairo")
# if issues with graphics, revert with
# options(bitmapType=default_bitmapType)
</code></pre>
</dd>
</dl>

---

### First in R:

Map the column `Status` to the visual dimension `x`.


<dl>
<dt>In [14]:</dt>
<dd>
<pre><code data-trim class="python">
%%R -i dataf -h 300
#The height of the figure is specified with "-h 300"
library(ggplot2)

p = ggplot(dataf) +
    geom_bar(aes(x=Status))
print(p)
</code></pre>
</dd>
</dl>


![png](potholes_files/potholes_25_0.png)


---

### Map:
- column `Status` to visual dimension `x`.
- column `Platform` to visual dimension `y`.


<dl>
<dt>In [15]:</dt>
<dd>
<pre><code data-trim class="python">
%%R -i dataf -h 300
p = ggplot(dataf) +
    geom_jitter(aes(x=Status, y=Platform))
print(p)
</code></pre>
</dd>
</dl>


![png](potholes_files/potholes_27_0.png)


---

### Map:
- column `Status` to visual dimension `x`.
- column `Platform` to visual dimension `y`.
- column `Action.Type` to visual dimension `color`.


<dl>
<dt>In [16]:</dt>
<dd>
<pre><code data-trim class="python">
%%R -i dataf -h 300
p = ggplot(dataf) +
    geom_jitter(aes(x=Status, y=Platform, color=Action.Type))
print(p)
</code></pre>
</dd>
</dl>


![png](potholes_files/potholes_29_0.png)


---

## Interlude: namespaces in R


<dl>
<dt>In [17]:</dt>
<dd>
<pre><code data-trim class="python">
%%R -i dataf -h 300
library(ggplot2)

p = ggplot2::ggplot(dataf) +
    ggplot2::geom_bar(ggplot2::aes(x=Status))
print(p)
</code></pre>
</dd>
</dl>


![png](potholes_files/potholes_31_0.png)


---

## R from Python


<dl>
<dt>In [18]:</dt>
<dd>
<pre><code data-trim class="python">
%%R
p = ggplot2::ggplot(dataf) +
    ggplot2::geom_bar(ggplot2::aes(x=Status))
</code></pre>
</dd>
</dl>

<hr>


<dl>
<dt>In [19]:</dt>
<dd>
<pre><code data-trim class="python">
from rpy2.robjects.lib import ggplot2
import rpy2.ipython.ggplot as igp
</code></pre>
</dd>
</dl>


<dl>
<dt>In [20]:</dt>
<dd>
<pre><code data-trim class="python">
gp = ggplot2
p = (gp.ggplot(dataf) +
     gp.geom_bar(gp.aes_string(x='Status')))
type(p)
</code></pre>
</dd>
</dl>




    rpy2.robjects.lib.ggplot2.GGPlot



---


<dl>
<dt>In [21]:</dt>
<dd>
<pre><code data-trim class="python">
from rpy2.ipython.ggplot import display_png
# register display func with PNG formatter:
png_formatter = get_ipython().display_formatter.formatters['image/png']
dpi = png_formatter.for_type(ggplot2.GGPlot, display_png)
</code></pre>
</dd>
</dl>

---


<dl>
<dt>In [22]:</dt>
<dd>
<pre><code data-trim class="python">
p
</code></pre>
</dd>
</dl>




![png](potholes_files/potholes_40_0.png)



---


<dl>
<dt>In [23]:</dt>
<dd>
<pre><code data-trim class="python">
p + gp.theme_gray(base_size=20)
</code></pre>
</dd>
</dl>




![png](potholes_files/potholes_42_0.png)



---


<dl>
<dt>In [24]:</dt>
<dd>
<pre><code data-trim class="python">
p = (gp.ggplot(dataf) +
     gp.geom_bar(gp.aes_string(x='Platform')) +
     gp.theme_gray(base_size=20))
p
</code></pre>
</dd>
</dl>




![png](potholes_files/potholes_44_0.png)



---


<dl>
<dt>In [25]:</dt>
<dd>
<pre><code data-trim class="python">
p = (gp.ggplot(dataf) +
     gp.geom_bar(gp.aes_string(x='Platform')) +
     gp.facet_grid('~Status') +
     gp.theme_gray(base_size=20) +
     gp.theme(**{'axis.text.x': gp.element_text(angle = 90, hjust = 1)}))
p
</code></pre>
</dd>
</dl>




![png](potholes_files/potholes_46_0.png)



---


<dl>
<dt>In [26]:</dt>
<dd>
<pre><code data-trim class="python">
p + gp.scale_y_sqrt()
</code></pre>
</dd>
</dl>




![png](potholes_files/potholes_48_0.png)



---

# dplyr

Manipulate data tables with (among others):

- mutate
- filter
- group_by # compute weekly statistics
- summarize

---


<dl>
<dt>In [27]:</dt>
<dd>
<pre><code data-trim class="python">
from rpy2.robjects.lib import dplyr
ddataf = dplyr.DataFrame(dataf)
</code></pre>
</dd>
</dl>

---

## Column "Address"


<dl>
<dt>In [28]:</dt>
<dd>
<pre><code data-trim class="python">
col_i = ddataf.colnames.index('Address')
first_address = next(ddataf[col_i].iter_labels())
first_address
</code></pre>
</dd>
</dl>




    'Concord Ave\nCambridge, MA\n(42.38675507400046, -71.14068255199965)'




<dl>
<dt>In [29]:</dt>
<dd>
<pre><code data-trim class="python">
s_pat_float = '[+-]?[0-9.]+'
s_pat_coords = '.+\((%s), (%s)\)$' % (s_pat_float, s_pat_float)
import re
pat_coords = re.compile(s_pat_coords,
                        flags=re.DOTALL)
pat_coords.match(first_address).groups()
</code></pre>
</dd>
</dl>




    ('42.38675507400046', '-71.14068255199965')



---


<dl>
<dt>In [30]:</dt>
<dd>
<pre><code data-trim class="python">
from rpy2.robjects import NA_Real
def extract_coords(address):
    m = pat_coords.match(address)
    if m is None:
        return (NA_Real, NA_Real)
    else:
        return tuple(float(x) for x in m.groups())

extract_coords(next(ddataf[col_i].iter_labels()))
</code></pre>
</dd>
</dl>




    (42.38675507400046, -71.14068255199965)



---

## Python and R entwinned


<dl>
<dt>In [31]:</dt>
<dd>
<pre><code data-trim class="python">
from rpy2.robjects.vectors import FloatVector
from rpy2.robjects import globalenv

globalenv['extract_lat'] = \
    lambda v: FloatVector(tuple(extract_coords(x)[0] for x in v))

globalenv['extract_long'] = \
    lambda v: FloatVector(tuple(extract_coords(x)[1] for x in v))

ddataf = \
    (ddataf.
     mutate(lat='extract_lat(as.character(Address))',
            long='extract_long(as.character(Address))',
            date_submit='as.POSIXct(Date.Submitted, ' + \
	                '           format="%m/%d/%Y %H:%M:%S")',
            date_complete='as.POSIXct(Date.Completed, ' + \
	                '           format="%m/%d/%Y %H:%M:%S")').
     mutate(days_to_fix='as.numeric(date_complete - date_submit, ' +\
                                    'unit="days")'))
</code></pre>
</dd>
</dl>

---


<dl>
<dt>In [32]:</dt>
<dd>
<pre><code data-trim class="python">
p = (gp.ggplot(ddataf) +
     gp.geom_hex(gp.aes_string(x='lat', y='long'), bins=50) +
     gp.scale_fill_continuous(trans="sqrt") +
     gp.theme_gray(base_size=15) +
     gp.facet_grid('~Status'))
p
</code></pre>
</dd>
</dl>




![png](potholes_files/potholes_59_0.png)



---


<dl>
<dt>In [33]:</dt>
<dd>
<pre><code data-trim class="python">
p = (gp.ggplot(ddataf.filter('Status == "Closed"')) +
     gp.geom_density(gp.aes_string(x='days_to_fix')) +
     gp.facet_grid('~Status') +
     gp.scale_x_sqrt() +
     gp.theme_gray(base_size=15) +
     gp.theme(**{'legend.position': 'top'}))
p
</code></pre>
</dd>
</dl>




![png](potholes_files/potholes_61_0.png)



---


<dl>
<dt>In [34]:</dt>
<dd>
<pre><code data-trim class="python">
p = (gp.ggplot(ddataf.filter('Status == "Closed"',
                             'days_to_fix < 100')) +
     gp.geom_histogram(gp.aes_string(x='days_to_fix'), bins=100) +
     gp.facet_grid('~Status') +
     gp.theme_gray(base_size=15) +
     gp.theme(**{'legend.position': 'top'}))
p
</code></pre>
</dd>
</dl>




![png](potholes_files/potholes_63_0.png)



---


<dl>
<dt>In [35]:</dt>
<dd>
<pre><code data-trim class="python">
dtf_grp_r = 'cut(days_to_fix, c(0,1,5,30,60,1500))'
p = (gp.ggplot(ddataf.filter('Status == "Closed"')) +
     gp.geom_point(gp.aes_string(x='lat', y='long',
                                 color=dtf_grp_r),
                  size=1) +
     gp.facet_grid('~Status') +
     gp.theme_dark(base_size=15) +
     gp.scale_color_brewer("Days to fix"))
p
</code></pre>
</dd>
</dl>




![png](potholes_files/potholes_65_0.png)



---


<dl>
<dt>In [36]:</dt>
<dd>
<pre><code data-trim class="python">
p = (gp.ggplot(ddataf.filter('Status == "Closed"')) +
     gp.geom_histogram(gp.aes_string(x='date_complete'), bins=30) +
     gp.facet_grid('~Status') +
     gp.theme_gray(base_size=15) +
     gp.theme(**{'legend.position': 'top'}))
p
</code></pre>
</dd>
</dl>




![png](potholes_files/potholes_67_0.png)



---


<dl>
<dt>In [37]:</dt>
<dd>
<pre><code data-trim class="python">
p = (gp.ggplot(ddataf.filter('Status %in% c("Closed", "Resolved")')) +
     gp.geom_hex(gp.aes_string(x='date_submit', y='date_complete')) +
     gp.facet_grid('~Status') +
     gp.scale_fill_continuous(trans="log") +
     gp.theme(**{'legend.position': 'top',
                 'axis.text.x': gp.element_text(angle=45, hjust=.5)}))
p
</code></pre>
</dd>
</dl>




![png](potholes_files/potholes_69_0.png)



---


<dl>
<dt>In [38]:</dt>
<dd>
<pre><code data-trim class="python">
extract_weekday = """
factor(weekdays(date_submit),
       levels=c("Sunday", "Monday",
                "Tuesday", "Wednesday", "Thursday",
                "Friday", "Saturday"))
"""
# transition iPhone / iOS
ddataf = (ddataf.
          mutate(year_submit='format(date_submit, format="%Y")',
                 month_submit='format(date_submit, format="%m")',
                 weeknum_submit='as.numeric(format(date_submit+3, "%U"))',
                 weekday_submit=(extract_weekday)).
	  filter('year_submit >= 2012',
                 'Platform != ""'))
</code></pre>
</dd>
</dl>

---


<dl>
<dt>In [39]:</dt>
<dd>
<pre><code data-trim class="python">
from IPython.core import display
p = (gp.ggplot(ddataf) +
     gp.geom_bar(gp.aes_string(x='(weekday_submit)', fill='Platform')) +
     gp.scale_fill_brewer(palette = 'Set1') +
     gp.scale_y_sqrt() +
     gp.theme(**{'axis.text.x': gp.element_text(angle = 90, hjust = 1)}) +
     gp.facet_grid('month_submit ~ year_submit'))
display.Image(display_png(p, height=700))
</code></pre>
</dd>
</dl>




![png](potholes_files/potholes_73_0.png)


