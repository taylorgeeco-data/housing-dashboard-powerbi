-- =========================
-- CITY AFFORDABILITY ANALYSIS
-- =========================
CREATE OR REPLACE VIEW public.city_affordability_analysis
 AS
 WITH affordability AS (
         SELECT city_economic_data.city,
            city_economic_data.state_code,
            city_economic_data.household_income,
            city_economic_data.all_homes AS median_home_price
           FROM city_economic_data
        )
 SELECT city,
    state_code,
    median_home_price,
    household_income,
    round(median_home_price / household_income, 2) AS affordability_ratio,
    rank() OVER (ORDER BY (median_home_price / household_income) DESC) AS affordability_rank
   FROM affordability;

-- =========================
-- CITY INCOME VS PRICE
-- =========================
CREATE OR REPLACE VIEW public.city_income_vs_price
 AS
 SELECT city,
    household_income,
    all_homes AS median_home_price
   FROM city_economic_data;
Housing affordability

-- =========================
-- HOUSING AFFORDABILITY
-- =========================
CREATE OR REPLACE VIEW public.housing_affordability
 AS
 SELECT c.city,
    c.household_income,
    r.listing_price,
    round(r.listing_price / c.household_income, 2) AS affordability_ratio
   FROM city_economic_data c
     JOIN regional_housing_data r ON c.state_code = r.state;

-- =========================
-- PRICE PER SQFT
-- =========================
CREATE OR REPLACE VIEW public.price_per_square_foot_analysis
 AS
 SELECT region,
    state,
    avg(cost_per_square_foot) AS avg_price_per_sqft,
    avg(listing_price) AS avg_listing_price,
    avg(square_feet) AS avg_home_size
   FROM regional_housing_data
  GROUP BY region, state
  ORDER BY (avg(cost_per_square_foot)) DESC;

