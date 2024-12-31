DROP DATABASE erp_db;
CREATE DATABASE erp_db;
USE erp_db;

CREATE TABLE Country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_code VARCHAR(3) UNIQUE NOT NULL,  -- ISO 3166-1 alpha-3 code (e.g., "USA", "IND")
    country_name VARCHAR(255) NOT NULL,       -- Full country name (e.g., "United States of America", "India")
    country_code_iso2 VARCHAR(2) UNIQUE,     -- ISO 3166-1 alpha-2 code (e.g., "US", "IN")
    country_phone_code VARCHAR(10),           -- Country dialing code (e.g., "+1" for USA, "+91" for India)
    continent VARCHAR(100),                   -- Continent (e.g., "North America", "Asia")
    currency_code VARCHAR(3),                 -- Currency code (e.g., "USD", "INR")
    currency_name VARCHAR(100),               -- Currency name (e.g., "US Dollar", "Indian Rupee")
    tax_rate DECIMAL(5, 2),                   -- Default tax rate for the country, if applicable
    status ENUM('active', 'inactive') DEFAULT 'active',
    timezone VARCHAR(50),                     -- Timezone of the country
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


-- Roles
CREATE TABLE Roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(255) NOT NULL,
    role_description TEXT,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
CREATE TABLE City (
    city_id INT AUTO_INCREMENT PRIMARY KEY,
    city_name VARCHAR(255) NOT NULL,
    country_id INT,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (country_id) REFERENCES Country(country_id)
);

CREATE TABLE Operation_type (
    operation_type_id INT AUTO_INCREMENT PRIMARY KEY,
    operation_type_name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);



CREATE TABLE Company (
    company_id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL,
    company_address TEXT,
    city_id INT,
    company_state VARCHAR(100),
    company_zip_code VARCHAR(20),
    country_id INT,
    company_phone VARCHAR(20),
    company_fax VARCHAR(20),
    company_website VARCHAR(255),
    company_email VARCHAR(255),
    company_logo VARCHAR(255),
    company_registration_number VARCHAR(50),
    company_tax_number VARCHAR(50),
    company_vat_number VARCHAR(50),
    company_currency VARCHAR(3),
    company_language VARCHAR(10),
    company_date_format VARCHAR(20),
    company_time_format VARCHAR(20),
    company_fiscal_year_start DATE,
    company_fiscal_year_end DATE,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    Foreign Key (city_id) REFERENCES City(city_id),
    Foreign Key (country_id) REFERENCES Country(country_id)
);



CREATE TABLE Company_Unit ( 
    unit_id INT AUTO_INCREMENT PRIMARY KEY,
    unit_name VARCHAR(255) NOT NULL,
    company_id INT,
    operation_type_id INT,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES Company(company_id),
    FOREIGN KEY (operation_type_id) REFERENCES Operation_type(operation_type_id)
);



CREATE TABLE Division (
    division_id INT AUTO_INCREMENT PRIMARY KEY,
    unit_id INT,
    division_name VARCHAR(255) NOT NULL,    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    Foreign Key (unit_id) REFERENCES Company_Unit(unit_id)
);

-- Department Table
CREATE TABLE Department (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    division_id INT,
    department_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    Foreign Key (division_id) REFERENCES Division(division_id)
);

CREATE TABLE Section (
    section_id INT AUTO_INCREMENT PRIMARY KEY,
    department_id INT,
    section_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    Foreign Key (department_id) REFERENCES Department(department_id)
);
CREATE TABLE Measurement_Units (
    unit_id INT AUTO_INCREMENT PRIMARY KEY,
    unit_code VARCHAR(10) UNIQUE NOT NULL,   -- Unique unit code (e.g., "KG", "LTR", "PCS")
    unit_name VARCHAR(100) NOT NULL,          -- Full name of the unit (e.g., "Kilogram", "Liter", "Piece")
    unit_description TEXT,                   -- Optional: Detailed description of the unit
    unit_type ENUM('weight', 'volume', 'quantity', 'length', 'area', 'time') NOT NULL,  -- Type of unit
    unit_symbol VARCHAR(10),                  -- Symbol for the unit (e.g., "kg", "l", "pcs")
    base_unit_id INT,                         -- Reference to base unit for conversions (e.g., 1 kilogram = 1000 grams)
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (base_unit_id) REFERENCES Measurement_Units(unit_id) -- Self-referencing for unit conversions
);
CREATE TABLE Designations (
    designation_id INT AUTO_INCREMENT PRIMARY KEY,
    designation_code VARCHAR(10) UNIQUE NOT NULL,  -- Unique code for the designation (e.g., "MGR", "ENG", "HR")
    designation_name VARCHAR(100) NOT NULL,         -- Full name of the designation (e.g., "Manager", "Engineer", "Human Resources")
    department_id INT,                              -- Reference to department if applicable (e.g., 1 for Sales, 2 for IT)
    responsibilities TEXT,                          -- Optional: Detailed list of responsibilities associated with the designation
    reporting_to INT,                               -- Reference to another designation if this role reports to someone (e.g., "Manager" reports to "Director")
    status ENUM('active', 'inactive') DEFAULT 'active',  -- Designation status (active or inactive)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Timestamp for when the record is created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- Timestamp for when the record is updated
    FOREIGN KEY (department_id) REFERENCES Department(department_id),  -- Assuming a Departments table exists
    FOREIGN KEY (reporting_to) REFERENCES Designations(designation_id) -- Self-referencing if a designation reports to another designation
);
CREATE TABLE Employee_Types (
    employee_type_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_type_code VARCHAR(10) UNIQUE NOT NULL,  -- Unique code for the employee type (e.g., "FT", "PT", "CONTRACT")
    employee_type_name VARCHAR(100) NOT NULL,        -- Full name of the employee type (e.g., "Full-Time", "Part-Time", "Contract")
    description TEXT,                                -- Optional: Detailed description of the employee type
    status ENUM('active', 'inactive') DEFAULT 'active',  -- Employee type status (active or inactive)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Timestamp for when the record is created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  -- Timestamp for when the record is updated
);
CREATE TABLE Employee_Grades (
    employee_grade_id INT AUTO_INCREMENT PRIMARY KEY,
    grade_code VARCHAR(10) UNIQUE NOT NULL,   -- Unique code for the employee grade (e.g., "A1", "B2", "C3")
    grade_name VARCHAR(100) NOT NULL,          -- Full name of the employee grade (e.g., "Junior", "Mid-Level", "Senior")
    description TEXT,                          -- Optional: Detailed description of the grade (e.g., required experience, responsibilities)
    salary_range_min DECIMAL(10, 2),           -- Minimum salary for this grade (in the organization's currency)
    salary_range_max DECIMAL(10, 2),           -- Maximum salary for this grade (in the organization's currency)
    status ENUM('active', 'inactive') DEFAULT 'active',  -- Grade status (active or inactive)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Timestamp for when the record is created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  -- Timestamp for when the record is updated
);

CREATE TABLE Employee (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_code VARCHAR(10) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100),
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone_number VARCHAR(15),
    hire_date DATE NOT NULL,
    job_title VARCHAR(50),
    compaany_id INT,
    unit_id INT,
    division_id INT,
        department_id INT,
        section_id INT,
    status ENUM('On Job', 'Resigned') DEFAULT 'On Job',
    designation_id INT,
    grade_id INT,
    role_id INT,
country_id INT,
city_id INT,
date_of_birth DATE,
blood_group ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    salary DECIMAL(10, 2),
    supervisor_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES Department(department_id),
    FOREIGN KEY (supervisor_id) REFERENCES Employee(employee_id),
    Foreign Key (country_id) REFERENCES Country(country_id),
    Foreign Key (city_id) REFERENCES City(city_id),
    Foreign Key (compaany_id) REFERENCES Company(company_id),
    Foreign Key (unit_id) REFERENCES Company_Unit(unit_id),
    Foreign Key (division_id) REFERENCES Division(division_id),
    Foreign Key (section_id) REFERENCES Section(section_id),
    Foreign Key (designation_id) REFERENCES Designations(designation_id),
    Foreign Key (grade_id) REFERENCES Employee_Grades(employee_grade_id),
    Foreign Key (role_id) REFERENCES Roles(role_id)
);



CREATE TABLE Location_Type (
    location_type_id INT AUTO_INCREMENT PRIMARY KEY,
    location_type_name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE Process (
    process_id INT AUTO_INCREMENT PRIMARY KEY,
    process_name VARCHAR(255) NOT NULL,
    description TEXT,
    owner INT,
    Shared ENUM('Yes', 'No') DEFAULT 'No',
    other_stakeholders VARCHAR(255),
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    Foreign Key (owner) REFERENCES Department(department_id)
);


CREATE TABLE Location (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    unit_id INT,
    location_name VARCHAR(255) NOT NULL,
    location_code VARCHAR(100) UNIQUE NOT NULL,  -- Unique code for the location
    location_type INT, -- Linked to the Location Type table
    status ENUM('active', 'inactive') DEFAULT 'active',  -- Location status
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Record creation date
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- Last updated date
    Foreign Key (location_type) REFERENCES Location_Type(location_type_id),
    Foreign Key (unit_id) REFERENCES Company_Unit(unit_id)
);



CREATE TABLE Currencies (
    currency_id INT AUTO_INCREMENT PRIMARY KEY,
    currency_code VARCHAR(10) UNIQUE NOT NULL,  -- e.g., USD, EUR, GBP
    currency_name VARCHAR(255) NOT NULL,  -- Full name of the currency
    symbol VARCHAR(10),  -- Currency symbol (e.g., $, €, £)
    exchange_rate DECIMAL(10, 4),  -- Exchange rate to base currency
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE Supplier (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_code VARCHAR(100) UNIQUE NOT NULL,  -- Unique code for the supplier
    supplier_name VARCHAR(255) NOT NULL,  -- Name of the supplier
    contact_info TEXT,  -- Contact information (address, phone, email, etc.)
    contact_person VARCHAR(255),
    email VARCHAR(255),
    phone_number VARCHAR(20),
    address TEXT,
    payment_terms VARCHAR(255),
    city_id INT,
    country_id INT,
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active', -- Supplier status
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Record creation date
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- Last updated date
    Foreign Key (city_id) REFERENCES City(city_id),
    Foreign Key (country_id) REFERENCES Country(country_id)
);

CREATE TABLE Supplier_Quality_Issue (
    quality_issue_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id INT,  -- Linked to the Supplier table
    issue_description TEXT NOT NULL,  -- Description of the quality issue
    issue_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Date when the issue was reported
    issue_status ENUM('open', 'in_progress', 'resolved', 'closed') DEFAULT 'open',  -- Current status of the issue
    severity ENUM('low', 'medium', 'high') DEFAULT 'medium', -- Severity of the quality issue
    root_cause_analysis TEXT,  -- Root cause analysis (if conducted)
    corrective_action TEXT,  -- Corrective action taken to resolve the issue
    preventive_action TEXT,  -- Preventive action to prevent recurrence
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Record creation date
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- Last updated date
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id)
);

-- Supplier Performance Table (Tracks performance evaluations of suppliers)
CREATE TABLE Supplier_Performance (
    performance_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id INT,  -- Linked to the Supplier table
    evaluation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Date of the evaluation
    performance_score INT,  -- Performance score (e.g., quality rating, delivery rating)
    evaluation_comments TEXT,  -- Comments on the supplier's performance
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Record creation date
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- Last updated date
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id)
);
-- Supplier Quality Audit Table (Tracks audits performed on suppliers)
CREATE TABLE Supplier_Quality_Audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id INT,  -- Linked to the Supplier table
    audit_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Date of the audit
    audit_result ENUM('passed', 'failed', 'pending') DEFAULT 'pending',  -- Result of the audit
    audit_score INT,  -- Audit score (if applicable)
    audit_findings TEXT,  -- Findings of the audit
    audit_recommendations TEXT,  -- Recommendations from the audit
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Record creation date
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- Last updated date
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id)
);

CREATE TABLE Supplier_Corrective_Action (
    corrective_action_id INT AUTO_INCREMENT PRIMARY KEY,
    quality_issue_id INT,  -- Linked to the Supplier Quality Issue table
    corrective_action_description TEXT,  -- Description of the corrective action taken
    action_owner INT,  -- User responsible for implementing the corrective action (could be linked to Users table)
    due_date DATE,  -- Due date for corrective action completion
    action_status ENUM('pending', 'in_progress', 'completed', 'closed') DEFAULT 'pending',  -- Action status
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Record creation date
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- Last updated date
    FOREIGN KEY (quality_issue_id) REFERENCES Supplier_Quality_Issue(quality_issue_id)
);

-- Supplier Preventive Action Table (Stores preventive actions taken for suppliers)
CREATE TABLE Supplier_Preventive_Action (
    preventive_action_id INT AUTO_INCREMENT PRIMARY KEY,
    quality_issue_id INT,  -- Linked to the Supplier Quality Issue table
    preventive_action_description TEXT,  -- Description of the preventive action taken
    action_owner INT,  -- User responsible for implementing the preventive action (could be linked to Users table)
    due_date DATE,  -- Due date for preventive action completion
    action_status ENUM('pending', 'in_progress', 'completed', 'closed') DEFAULT 'pending',  -- Action status
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Record creation date
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- Last updated date
    FOREIGN KEY (quality_issue_id) REFERENCES Supplier_Quality_Issue(quality_issue_id)
);

-- Supplier Quality Report Table (Stores reports generated for supplier quality issues)
CREATE TABLE Supplier_Quality_Report (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    report_name VARCHAR(255) NOT NULL,  -- Name of the report
    report_description TEXT,  -- Description of the report
    generated_by INT,  -- User who generated the report (could be linked to Users table)
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Date when the report was generated
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Record creation date
);


CREATE TABLE CAPA_Source (
    source_id INT AUTO_INCREMENT PRIMARY KEY,
    source_name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- CAPA Table (Stores details of corrective and preventive actions)
CREATE TABLE CAPA (
    capa_id INT AUTO_INCREMENT PRIMARY KEY,
    capa_reference_number VARCHAR(30) UNIQUE NOT NULL,  -- Unique code for the CAPA
    capa_type ENUM('corrective', 'preventive') NOT NULL, -- Type of CAPA (corrective or preventive)
    source_id INT,  -- Linked to the CAPA Source table
    description TEXT NOT NULL,  -- Detailed description of the CAPA
    timeline DATE,  -- Timeline for implementing the CAPA
    priority ENUM('low', 'medium', 'high') DEFAULT 'medium',  -- Priority level of the CAPA
    responsible_department INT,  -- Department responsible for the CAPA
    responsible_person INT,  -- Person responsible for the CAPA
    extension_request BOOLEAN DEFAULT FALSE,  -- Indicates if an extension request is made
    extension_reason TEXT,  -- Reason for extension request
    extension_approved BOOLEAN DEFAULT FALSE,  -- Indicates if the extension request is approved
    extension_approved_by INT,  -- User who approved the extension request (could be linked to a Users table)
    extension_approved_date TIMESTAMP,  -- Date when the extension request was approved
    raised_by INT,  -- User who identified the CAPA (could be linked to a Users table)
    raised_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Date when CAPA was identified
    approved_by INT,  -- User who approved the CAPA (could be linked to a Users table)
    approved_date TIMESTAMP,  -- Date when CAPA was approved
    2nd_time_extension_request BOOLEAN DEFAULT FALSE,  -- Indicates if an extension request is made
    2nd_time_extension_reason TEXT,  -- Reason for extension request
    2nd_time_extension_approved BOOLEAN DEFAULT FALSE,  -- Indicates if the extension request is approved
    2nd_time_extension_approved_by INT,  -- User who approved the extension request (could be linked to a Users table)
    2nd_time_extension_approved_date TIMESTAMP,  -- Date when the extension request was approved
    action_plan TEXT,  -- Action plan to implement the CAPA
    action_takend TEXT,  -- Action taken to implement the CAPA
    action_date DATE,  -- Date when the action was taken
    verification_date DATE,  -- Date of verification
    effectiveness_verification_date DATE,  -- Date of effectiveness verification
    verification_comments TEXT,  -- Comments about the verification
    mode_of_verification ENUM('periodic check', 'internal', 'external', 'supplier','audit', 'inspection', 'record', 'trend analysis', 'other') DEFAULT 'internal',  -- Mode of verification
    verification_status ENUM('not_verified', 'verified', 'rejected') DEFAULT 'not_verified',  -- Verification status
    verified_by INT,  -- User who performed the verification (could be linked to a Users table)
    closed_date TIMESTAMP,  -- Date when the CAPA was closed
    status ENUM('open', 'in_progress', 'closed') DEFAULT 'open', -- Current status of the CAPA
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- Record last updated date
    Foreign Key (source_id) REFERENCES CAPA_Source(source_id),
    Foreign Key (raised_by) REFERENCES Employee(employee_id),
    Foreign Key (approved_by) REFERENCES Employee(employee_id),
    Foreign Key (responsible_department) REFERENCES Department(department_id),
    Foreign Key (responsible_person) REFERENCES Employee(employee_id),
    Foreign Key (extension_approved_by) REFERENCES Employee(employee_id),
    Foreign Key (2nd_time_extension_approved_by) REFERENCES Employee(employee_id)

);

CREATE TABLE Packing_Mode (
    packing_mode_id INT AUTO_INCREMENT PRIMARY KEY,
    packing_mode_name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE Pack_Size (
    pack_size_id INT AUTO_INCREMENT PRIMARY KEY,
    pack_size_name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
CREATE TABLE Dosage_Form (
    dosage_form_id INT AUTO_INCREMENT PRIMARY KEY,
    dosage_form_name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
CREATE TABLE Item_Type (
    item_type_id INT AUTO_INCREMENT PRIMARY KEY,
    item_type_name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
CREATE TABLE Item (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(255) NOT NULL,
    item_code VARCHAR(100) UNIQUE NOT NULL,  -- Unique code for the item
    item_type_id INT,
    description TEXT,
    unit_of_measure VARCHAR(50),
    price DECIMAL(10, 2) DEFAULT NULL,
    stock_quantity INT DEFAULT 0,
    reorder_level INT DEFAULT 0,  -- Level at which the product should be reordered
    packing_mode_id INT DEFAULT NULL,
    pack_size_id INT DEFAULT NULL,
    dosage_form_id INT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (item_type_id) REFERENCES Item_Type(item_type_id),
    FOREIGN KEY (packing_mode_id) REFERENCES Packing_Mode(packing_mode_id),
    FOREIGN KEY (pack_size_id) REFERENCES Pack_Size(pack_size_id),
    FOREIGN KEY (dosage_form_id) REFERENCES Dosage_Form(dosage_form_id)
);



-- Non-Conformance Table (Stores details of non-conformances)
CREATE TABLE Non_Conformance (
    non_conformance_id INT AUTO_INCREMENT PRIMARY KEY,
    non_conformance_code VARCHAR(100) UNIQUE NOT NULL,  -- Unique code for the non-conformance
    description TEXT NOT NULL,  -- Description of the non-conformance
    severity ENUM('low', 'medium', 'high') DEFAULT 'medium', -- Severity level
    detected_by INT,  -- User who detected the non-conformance (could be linked to a Users table)
    detection_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Date when the non-conformance was detected
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Record creation date
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  -- Record last updated date
);

-- Non-Conformance Action Table (Tracks actions taken to resolve non-conformances)
CREATE TABLE Non_Conformance_Action (
    action_id INT AUTO_INCREMENT PRIMARY KEY,
    non_conformance_id INT,  -- Linked to the Non-Conformance table
    action_description TEXT,  -- Description of the corrective action taken
    action_owner INT,  -- User responsible for taking the action (could be linked to a Users table)
    due_date DATE,  -- Due date for action completion
    status ENUM('pending', 'in_progress', 'completed', 'closed') DEFAULT 'pending',  -- Action status
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Action creation date
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- Action last updated date
    FOREIGN KEY (non_conformance_id) REFERENCES Non_Conformance(non_conformance_id)
);

-- Non-Conformance Root Cause Analysis Table (Stores details of root cause analysis)
CREATE TABLE Non_Conformance_Root_Cause (
    root_cause_id INT AUTO_INCREMENT PRIMARY KEY,
    non_conformance_id INT,  -- Linked to the Non-Conformance table
    root_cause_description TEXT,  -- Description of the root cause identified
    analysis_method VARCHAR(100),  -- Method used for root cause analysis (e.g., 5 Whys, Fishbone Diagram)
    responsible_department VARCHAR(100),  -- Department responsible for analysis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Root cause analysis date
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- Root cause last updated date
    FOREIGN KEY (non_conformance_id) REFERENCES Non_Conformance(non_conformance_id)
);

-- Non-Conformance Verification Table (Tracks the verification of corrective actions)
CREATE TABLE Non_Conformance_Verification (
    verification_id INT AUTO_INCREMENT PRIMARY KEY,
    non_conformance_id INT,  -- Linked to the Non-Conformance table
    verification_status ENUM('not_verified', 'verified', 'rejected') DEFAULT 'not_verified',  -- Verification status
    verification_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Date of verification
    verification_comments TEXT,  -- Additional comments about verification
    verified_by INT,  -- User who performed the verification (could be linked to a Users table)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Verification record creation date
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- Verification last updated date
    FOREIGN KEY (non_conformance_id) REFERENCES Non_Conformance(non_conformance_id)
);

-- Non-Conformance Closure Table (Stores information when non-conformance is closed)
CREATE TABLE Non_Conformance_Closure (
    closure_id INT AUTO_INCREMENT PRIMARY KEY,
    non_conformance_id INT,  -- Linked to the Non-Conformance table
    closure_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Date when the non-conformance was closed
    closure_reason TEXT,  -- Reason for closure
    closed_by INT,  -- User who closed the non-conformance (could be linked to a Users table)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Record creation date
    FOREIGN KEY (non_conformance_id) REFERENCES Non_Conformance(non_conformance_id)
);

-- Non-Conformance Reporting Table (Stores reports generated for non-conformances)
CREATE TABLE Non_Conformance_Report (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    report_name VARCHAR(255) NOT NULL,  -- Name of the report
    report_description TEXT,  -- Description of the report
    generated_by INT,  -- User who generated the report (could be linked to a Users table)
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Date when the report was generated
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Record creation date
);

CREATE TABLE Document_Type (
    document_type_id INT AUTO_INCREMENT PRIMARY KEY,
    document_type_name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE Document_Format_Number (
    format_number_id INT AUTO_INCREMENT PRIMARY KEY,
    document_type_id INT,  -- Linked to the Document Type table
    format_part_number INT DEFAULT 4,  -- Name of the format
    format_number_prefix VARCHAR(10),  -- Prefix for the format number
    format_number_suffix VARCHAR(10),  -- Suffix for the format number
    format_number_length INT,  -- Length of the format number
    format_effective_date DATE,  -- Date when the format becomes effective
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Record creation date
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- Record last updated date
    FOREIGN KEY (document_type_id) REFERENCES Document_Type(document_type_id)
);
-- Document Table (Stores basic document details)
CREATE TABLE Document (
    document_id INT AUTO_INCREMENT PRIMARY KEY,
    document_name VARCHAR(255) NOT NULL,
    document_type VARCHAR(100), -- e.g., PDF, DOCX, XLSX, etc.
    document_description TEXT,
    created_by INT, -- User who created the document (could be linked to a Users table)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Document Version Table (Stores versions of a document)
CREATE TABLE Document_Version (
    version_id INT AUTO_INCREMENT PRIMARY KEY,
    document_id INT,
    version_number INT NOT NULL,
    version_name VARCHAR(255), -- e.g., v1.0, v1.1, etc.
    version_description TEXT,
    file_path VARCHAR(255), -- Path or URL to the document file
    file_size INT, -- Size of the document file in bytes
    created_by INT, -- User who uploaded the version (could be linked to a Users table)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (document_id) REFERENCES Document(document_id)
);

-- Document Access Control Table (Stores access control information for documents)
CREATE TABLE Document_Access (
    access_id INT AUTO_INCREMENT PRIMARY KEY,
    document_id INT,
    user_id INT, -- User who has access (could be linked to a Users table)
    access_type ENUM('view', 'edit', 'delete') DEFAULT 'view', -- Type of access
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (document_id) REFERENCES Document(document_id)
);

-- Document Review Table (Tracks review process for documents)
CREATE TABLE Document_Review (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    document_id INT,
    reviewer_id INT, -- User who is reviewing the document (could be linked to a Users table)
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    review_status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending', -- Status of review
    review_comments TEXT, -- Comments from the reviewer
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (document_id) REFERENCES Document(document_id)
);

-- Document History Table (Logs changes and activities on documents)
CREATE TABLE Document_History (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    document_id INT,
    action_type ENUM('create', 'update', 'delete', 'review', 'version_upload') NOT NULL, -- Action performed
    action_description TEXT, -- Description of the action
    action_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT, -- User who performed the action (could be linked to a Users table)
    FOREIGN KEY (document_id) REFERENCES Document(document_id)
);

-- Document Status Table (Tracks status of documents, e.g., Draft, Final, Archived)
CREATE TABLE Document_Status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    document_id INT,
    status ENUM('draft', 'final', 'archived') DEFAULT 'draft',
    status_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by INT, -- User who updated the status (could be linked to a Users table)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (document_id) REFERENCES Document(document_id)
);



-- Vendor Table
CREATE TABLE Vendor (
    vendor_id INT AUTO_INCREMENT PRIMARY KEY,
    vendor_name VARCHAR(255) NOT NULL,
    contact_name VARCHAR(100),
    contact_email VARCHAR(150),
    contact_phone VARCHAR(15),
    address VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);




CREATE TABLE Storage_Condition (
    condition_id INT AUTO_INCREMENT PRIMARY KEY,
    condition_name VARCHAR(100) NOT NULL,
    condition_description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Inventory Transaction Table (Tracking Movements of Products)
create table warehouse(
    warehouse_id int auto_increment primary key,
    unit_id int,
    location_id int,
    warehouse_name varchar(255) not null,
    warehouse_code varchar(50) unique not null,
    dimesion varchar(50),
    storage_condition INT,
    total_rack_number int not null,
    capacity_pallet int not null,
    status enum('active', 'inactive') default 'active',
    created_at timestamp default current_timestamp,
    updated_at timestamp default current_timestamp on update current_timestamp,
    Foreign Key (unit_id) REFERENCES Company_Unit(unit_id),
    Foreign Key (location_id) REFERENCES Location(location_id),
    Foreign Key (storage_condition) REFERENCES Storage_Condition(condition_id)
);
-- Warehouse Location Table (Specific Locations within a Warehouse)
CREATE TABLE Warehouse_Location (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    warehouse_id INT,
    location_name VARCHAR(255) NOT NULL, -- Name of the location within the warehouse
    location_code VARCHAR(50) NOT NULL, -- e.g., A1, B2, C3, etc.
    max_capacity INT NOT NULL, -- Capacity of this specific location
    current_stock INT DEFAULT 0, -- Current stock in this location
    item_id INT, -- Item stored in this location
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id),
    Foreign KEY (item_id) REFERENCES Item(item_id)
);


CREATE TABLE Stock_Movement_Rules (
    rule_id INT AUTO_INCREMENT PRIMARY KEY,
    rule_code VARCHAR(10) UNIQUE NOT NULL,
    rule_name VARCHAR(50) NOT NULL,
    rule_condition TEXT,
    reversible ENUM('Yes', 'No') DEFAULT 'No',
    rule_description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE Stock_Movement (
    movement_id INT AUTO_INCREMENT PRIMARY KEY,
    from_location_id INT,
    to_location_id INT,  -- Changed to a single location and made it a foreign key
    item_id INT,
    quantity INT NOT NULL,
    movement_date DATE NOT NULL,
    status ENUM('pending', 'completed', 'cancelled') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (from_location_id) REFERENCES Warehouse_Location(location_id),
    FOREIGN KEY (to_location_id) REFERENCES Warehouse_Location(location_id),
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);



-- Purchase Order Table
CREATE TABLE Purchase_Order (
    purchase_order_id INT AUTO_INCREMENT PRIMARY KEY,
    vendor_id INT,
    order_date DATE NOT NULL,
    delivery_date DATE NOT NULL,
    status ENUM('pending', 'approved', 'shipped', 'delivered', 'canceled') DEFAULT 'pending',
    total_amount DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (vendor_id) REFERENCES Vendor(vendor_id)
);

-- Purchase Order Item Table
CREATE TABLE Purchase_Order_Item (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    purchase_order_id INT,
    item_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) AS (quantity * unit_price) STORED,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (purchase_order_id) REFERENCES Purchase_Order(purchase_order_id),
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);



-- Bill of Materials (BOM) Table
CREATE TABLE Bill_of_Materials (
    bom_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT,
    quantity_required INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

-- Production Order Table
CREATE TABLE Production_Order (
    production_order_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT,
    order_date DATE NOT NULL,
    due_date DATE NOT NULL,
    status ENUM('pending', 'in_progress', 'completed', 'canceled') DEFAULT 'pending',
    planned_quantity INT NOT NULL,
    produced_quantity INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

-- Work Order Table
CREATE TABLE Work_Order (
    work_order_id INT AUTO_INCREMENT PRIMARY KEY,
    production_order_id INT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('not_started', 'in_progress', 'completed') DEFAULT 'not_started',
    work_center VARCHAR(100),
    planned_time INT NOT NULL,  -- Time in hours
    actual_time INT DEFAULT 0,  -- Time in hours
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (production_order_id) REFERENCES Production_Order(production_order_id)
);



CREATE TABLE Stock_Status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL,
    applicable_item_type INT,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (applicable_item_type) REFERENCES Item_Type(item_type_id)
);

CREATE TABLE Current_Stock (
    stock_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT,
    batch_number VARCHAR(50),
    warehouse_id INT,
    location_id INT,
    warehouse_location_code VARCHAR(50),
    stock_quantity INT DEFAULT 0,
    alert_stock_level INT DEFAULT 0,
    stock_status INT,
    manufacturing_date DATE,
    expiry_date DATE,
    retest_date DATE,
    manufacturer VARCHAR(100),
    country_of_origin INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES Item(item_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (location_id) REFERENCES Warehouse_Location(location_id),
    FOREIGN KEY (stock_status) REFERENCES Stock_Status(status_id),
    Foreign Key (country_of_origin) REFERENCES Country(country_id)
);



-- Inventory Transactions Table
CREATE TABLE Inventory_Transaction (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    inventory_id INT,
    item_id INT,
    transaction_type ENUM('purchase', 'sale', 'adjustment', 'return', 'transfer', 'consumption', 'rejection') NOT NULL,
    quantity INT NOT NULL,
    transaction_date DATE NOT NULL,
    movement_id INT,  -- Added a foreign key to the Stock Movement table
    from_location_id INT,  -- Added a foreign key to the Warehouse Location table
    to_location_id INT,  -- Added a foreign key to the Warehouse Location table
    where_used_item_id INT,  -- Added a foreign key to the Item table for where-used transactions
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (item_id) REFERENCES Item(item_id),
    FOREIGN KEY (movement_id) REFERENCES Stock_Movement(movement_id),
    FOREIGN KEY (from_location_id) REFERENCES Location(location_id),
    FOREIGN KEY (to_location_id) REFERENCES Warehouse_Location(location_id),
    FOREIGN KEY (where_used_item_id) REFERENCES Item(item_id)
);
-- Production Planning Table
CREATE TABLE Production_Planning (
    planning_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT,
    planned_start_date DATE NOT NULL,
    planned_end_date DATE NOT NULL,
    planned_quantity INT NOT NULL,
    status ENUM('planned', 'released', 'completed') DEFAULT 'planned',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);
-- Removed duplicate Invoice table definition



-- Goods Receipt Table
CREATE TABLE Goods_Receipt (
    goods_receipt_id INT AUTO_INCREMENT PRIMARY KEY,
    purchase_order_id INT,
    receipt_date DATE NOT NULL,
    received_by VARCHAR(100),
    quantity_received INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (purchase_order_id) REFERENCES Purchase_Order(purchase_order_id)
);


-- 1. General Ledger (GL) Table
CREATE TABLE general_ledger (
    ledger_id INT AUTO_INCREMENT PRIMARY KEY,
    account_code VARCHAR(20) NOT NULL,
    account_name VARCHAR(100) NOT NULL,
    account_type ENUM('asset', 'liability', 'equity', 'income', 'expense') NOT NULL,
    balance DECIMAL(15, 2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. Accounts Payable (AP) Table
CREATE TABLE accounts_payable (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id INT NOT NULL,
    invoice_number VARCHAR(50) NOT NULL,
    invoice_date DATE NOT NULL,
    due_date DATE NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    paid_amount DECIMAL(15, 2) DEFAULT 0.00,
    payment_status ENUM('pending', 'paid', 'overdue') NOT NULL,
    payment_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
);


-- 4. Financial Reporting Tables

-- Income Statement
CREATE TABLE income_statement (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    total_revenue DECIMAL(15, 2) NOT NULL,
    total_expenses DECIMAL(15, 2) NOT NULL,
    net_profit DECIMAL(15, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Balance Sheet
CREATE TABLE balance_sheet (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    total_assets DECIMAL(15, 2) NOT NULL,
    total_liabilities DECIMAL(15, 2) NOT NULL,
    equity DECIMAL(15, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Cash Flow Statement
CREATE TABLE cash_flow_statement (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    operating_cash_flow DECIMAL(15, 2) NOT NULL,
    investing_cash_flow DECIMAL(15, 2) NOT NULL,
    financing_cash_flow DECIMAL(15, 2) NOT NULL,
    net_cash_flow DECIMAL(15, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Financial Transactions Table
CREATE TABLE financial_transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    ledger_id INT NOT NULL,
    transaction_date DATE NOT NULL,
    transaction_amount DECIMAL(15, 2) NOT NULL,
    transaction_type ENUM('debit', 'credit') NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ledger_id) REFERENCES general_ledger(ledger_id)
);
-- Master Data Table (Stores all master data entities)
CREATE TABLE Master_Data (
    master_data_id INT AUTO_INCREMENT PRIMARY KEY,
    entity_type ENUM('user', 'product', 'customer', 'supplier', 'location', 'department', 'role', 'document_type', 'status', 'currency', 'tax_code', 'payment_method', 'category', 'measurement_unit', 'vendor', 'contract_type', 'risk_level') NOT NULL,  -- Type of master data
    entity_code VARCHAR(100) UNIQUE NOT NULL,  -- Unique code for the entity
    entity_name VARCHAR(255) NOT NULL,  -- Name of the entity
    entity_description TEXT,  -- Detailed description of the entity
    parent_id INT DEFAULT NULL,  -- Parent entity ID (for hierarchical relationships)
    status ENUM('active', 'inactive', 'archived') DEFAULT 'active',  -- Status of the entity
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Record creation date
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  -- Last updated date
);

-- Example of master data for different entities
-- Users
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    user_code VARCHAR(100) UNIQUE NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    role_id INT,  -- Link to Master Data for roles
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES Master_Data(master_data_id)
);



-- Locations
CREATE TABLE Locations (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    location_code VARCHAR(100) UNIQUE NOT NULL,
    location_name VARCHAR(255) NOT NULL,
    address TEXT,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);



-- Document Types
CREATE TABLE Document_Types (
    document_type_id INT AUTO_INCREMENT PRIMARY KEY,
    document_type_name VARCHAR(255) NOT NULL,
    document_type_description TEXT,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Status Codes (Common status for entities across modules)
-- Removed duplicate Document_Types table definition


-- Employee Table


-- Salary Table
CREATE TABLE Salary (
    salary_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    salary_amount DECIMAL(10, 2) NOT NULL,
    pay_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);

-- Leave Table
CREATE TABLE Employee_Leave (
    leave_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    leave_type VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('approved', 'pending', 'rejected') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);

-- Performance Evaluation Table
CREATE TABLE Performance_Evaluation (
    evaluation_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    evaluation_date DATE NOT NULL,
    score DECIMAL(5, 2),
    comments TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);

-- Attendance Table
CREATE TABLE Attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    date DATE NOT NULL,
    status ENUM('present', 'absent', 'late') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);
-- Tax Codes
CREATE TABLE Tax_Codes (
    tax_code_id INT AUTO_INCREMENT PRIMARY KEY,
    tax_code VARCHAR(20) UNIQUE NOT NULL,  -- e.g., GST, VAT
    tax_percentage DECIMAL(5, 2),  -- Tax percentage
    description TEXT,  -- Description of the tax
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE Customer_Groups (
    group_id INT AUTO_INCREMENT PRIMARY KEY,
    group_name VARCHAR(255) NOT NULL,
    description TEXT,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE Customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_code VARCHAR(100) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    customer_name VARCHAR(255),
    email VARCHAR(150) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    phone VARCHAR(50),
    address TEXT,
    billing_address TEXT,
    shipping_address TEXT,
    city INT,
    state VARCHAR(100),
    zip_code VARCHAR(20),
    country_id INT,
    industry VARCHAR(100),
    customer_group_id INT,  -- Link to customer group
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_group_id) REFERENCES Customer_Groups(group_id),
    Foreign Key (city) references City(city_id),
    Foreign Key (country_id) references Country(country_id)
);


CREATE TABLE Bank_Accounts (
    bank_account_id INT AUTO_INCREMENT PRIMARY KEY,
    bank_account_code VARCHAR(100) UNIQUE NOT NULL,
    bank_name VARCHAR(255) NOT NULL,
    branch_name VARCHAR(255),
    account_type ENUM('savings', 'current', 'loan') NOT NULL,
    account_number VARCHAR(50) NOT NULL,
    currency_id INT,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (currency_id) REFERENCES Currencies(currency_id)
);

CREATE TABLE Lead_customer (
    lead_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,    -- Linked to the Customer table
    lead_source VARCHAR(100),  -- e.g., Web, Referral, Trade Show
    lead_status ENUM('new', 'contacted', 'qualified', 'converted', 'disqualified') DEFAULT 'new',
    lead_value DECIMAL(10, 2),  -- Potential value of the lead
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Record creation date
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Last updated date    
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);
CREATE TABLE Opportunity (
    opportunity_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    opportunity_name VARCHAR(255) NOT NULL,
    opportunity_stage ENUM('qualification', 'needs_analysis', 'proposal', 'negotiation', 'closed_won', 'closed_lost') DEFAULT 'qualification',
    opportunity_value DECIMAL(10, 2) NOT NULL,
    expected_close_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);
CREATE TABLE Communication_History (
    communication_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    communication_type ENUM('email', 'phone', 'meeting', 'call', 'chat') NOT NULL,
    communication_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    communication_subject VARCHAR(255),
    communication_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE Task (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    task_name VARCHAR(255) NOT NULL,
    task_description TEXT,
    due_date DATE,
    status ENUM('pending', 'in_progress', 'completed', 'cancelled') DEFAULT 'pending',
    assigned_to VARCHAR(255),  -- Person assigned to the task
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);
-- Sales Order Table (Records sales orders made by customers)
CREATE TABLE Sales_Order (
    sales_order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    delivery_date DATE NOT NULL,
    order_status ENUM('pending', 'processed', 'shipped', 'delivered', 'canceled') DEFAULT 'pending',
    total_amount DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- Sales Order Item Table
CREATE TABLE Sales_Order_Item (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    sales_order_id INT,
    item_id INT,  -- Referencing the product being sold
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) AS (quantity * unit_price) STORED,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sales_order_id) REFERENCES Sales_Order(sales_order_id),
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

-- Invoice Table (Invoices related to sales orders)
CREATE TABLE Invoice (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    sales_order_id INT,
    invoice_date DATE NOT NULL,
    due_date DATE,
    amount_due DECIMAL(10, 2) NOT NULL,
    amount_paid DECIMAL(10, 2) DEFAULT 0,
    status ENUM('pending', 'paid', 'overdue', 'canceled') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (sales_order_id) REFERENCES Sales_Order(sales_order_id)
);


-- Payment Table (Records payments made by customers)
CREATE TABLE Payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_amount DECIMAL(10, 2) NOT NULL,
    payment_method ENUM('credit_card', 'bank_transfer', 'check', 'cash', 'paypal', 'credit', 'debit') NOT NULL,
    payment_status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id)
);

-- Shipment Table
CREATE TABLE Shipment (
    shipment_id INT AUTO_INCREMENT PRIMARY KEY,
    sales_order_id INT,
    shipment_date DATE NOT NULL,
    tracking_number VARCHAR(100),
    shipping_method VARCHAR(50),
    shipping_address VARCHAR(255),
    delivery_date DATE,
    shipment_status ENUM('pending', 'shipped', 'delivered', 'returned') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (sales_order_id) REFERENCES Sales_Order(sales_order_id)
);
-- 3. Accounts Receivable (AR) Table
-- 3. Accounts Receivable (AR) Table
CREATE TABLE accounts_receivable (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    invoice_number VARCHAR(50) NOT NULL,
    invoice_date DATE NOT NULL,
    due_date DATE NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    paid_amount DECIMAL(15, 2) DEFAULT 0.00,
    payment_status ENUM('pending', 'paid', 'overdue') NOT NULL,
    payment_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE Shipping_Methods (
    shipping_method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(255) NOT NULL,
    cost DECIMAL(10, 2),
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
CREATE TABLE Warehouse_Locations (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    location_code VARCHAR(100) UNIQUE NOT NULL,
    location_name VARCHAR(255) NOT NULL,
    warehouse_id INT,  -- Foreign key linking to Warehouse table
    capacity INT,  -- Capacity of the location in terms of items
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (warehouse_id) REFERENCES Master_Data(master_data_id)
);
CREATE TABLE Departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(255) NOT NULL,
    department_head INT,  -- Foreign key linking to Users (e.g., HR manager)
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (department_head) REFERENCES Users(user_id)
);
CREATE TABLE Procurement_Methods (
    method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(255) NOT NULL,
    description TEXT,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE Customer_Complaints (
    complaint_id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_code VARCHAR(20) UNIQUE NOT NULL,   -- Unique code for the complaint (e.g., "CMP-001")
    customer_id INT NOT NULL,                      -- Reference to the customer (e.g., foreign key to the Customers table)
    complaint_type VARCHAR(100),                   -- Type of complaint (e.g., "Product Issue", "Delivery Delay", "Customer Service")
    complaint_description TEXT,                    -- Detailed description of the complaint made by the customer
    complaint_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Date when the complaint was registered
    status ENUM('open', 'in-progress', 'resolved', 'closed') DEFAULT 'open',  -- Complaint status (open, in-progress, resolved, or closed)
    resolution_description TEXT,                   -- Optional: Detailed description of how the complaint was resolved
    resolved_by INT,                               -- Reference to the employee/agent who resolved the complaint (e.g., foreign key to Employees table)
    resolution_date TIMESTAMP,                     -- Date when the complaint was resolved (only relevant if the status is 'resolved')
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Timestamp for when the record is created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- Timestamp for when the record is updated
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),   -- Assuming a Customers table exists
    FOREIGN KEY (resolved_by) REFERENCES Employee(employee_id)    -- Assuming an Employees table exists
);
CREATE TABLE Investigations (
    investigation_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for the investigation
    investigation_code VARCHAR(20) UNIQUE NOT NULL,   -- Unique code for the investigation (e.g., "INV-001")
    complaint_id INT,                                -- Reference to the complaint being investigated (foreign key to Customer_Complaints)
    non_conformance_id INT,                          -- Reference to non-conformance record (foreign key to Non_Conformance)
    investigation_type VARCHAR(100),                  -- Type of investigation (e.g., "Root Cause Analysis", "Audit", "Incident Investigation")
    investigation_description TEXT,                   -- Detailed description of the investigation
    assigned_to INT,                                  -- Reference to the employee or team assigned to the investigation (foreign key to Employee)
    status ENUM('open', 'in-progress', 'closed') DEFAULT 'open',  -- Investigation status (open, in-progress, closed)
    investigation_outcome TEXT,                       -- Outcome or findings of the investigation (to be filled when investigation is complete)
    resolution_action TEXT,                           -- Actions taken or recommended after the investigation (e.g., corrective actions)
    start_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Date when the investigation started
    end_date TIMESTAMP,                              -- Date when the investigation was completed (if applicable)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Timestamp when the record was created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- Timestamp when the record was updated
    FOREIGN KEY (complaint_id) REFERENCES Customer_Complaints(complaint_id),  -- Foreign key to Customer_Complaints table (if applicable)
    FOREIGN KEY (non_conformance_id) REFERENCES Non_Conformance(non_conformance_id),  -- Foreign key to Non_Conformance table (if applicable)
    FOREIGN KEY (assigned_to) REFERENCES Employee(employee_id)  -- Foreign key to Employee table (e.g., who is handling the investigation)
);
CREATE TABLE Deviations (
    deviation_id INT AUTO_INCREMENT PRIMARY KEY,   -- Unique identifier for the deviation record
    deviation_code VARCHAR(20) UNIQUE NOT NULL,    -- Unique code for the deviation (e.g., "DEV-001")
    deviation_type VARCHAR(100),                    -- Type of deviation (e.g., "Process Deviation", "Product Deviation", "Service Deviation")
    deviation_description TEXT,                     -- Detailed description of the deviation
    deviation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Date when the deviation was first identified
    cause_of_deviation TEXT,                        -- Detailed description of the cause of the deviation
    corrective_action TEXT,                          -- Actions taken to correct the deviation
    preventive_action TEXT,                         -- Preventive actions to avoid recurrence of the deviation
    status ENUM('open', 'in-progress', 'closed') DEFAULT 'open', -- Deviation status (open, in-progress, closed)
    affected_process VARCHAR(100),                  -- Process or system affected by the deviation
    affected_product VARCHAR(100),                  -- Product or service affected by the deviation
    impact_assessment TEXT,                         -- Impact assessment of the deviation (e.g., financial, operational, customer impact)
    assigned_to INT,                                -- Reference to the employee or team handling the deviation (foreign key to Employees)
    resolution_date TIMESTAMP,                      -- Date when the deviation was resolved
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Timestamp when the record was created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Timestamp when the record was last updated
    FOREIGN KEY (assigned_to) REFERENCES Employee(employee_id) -- Foreign key to Employees table (assigned team member)
);


CREATE TABLE Samples (
    sample_id INT AUTO_INCREMENT PRIMARY KEY,            -- Unique identifier for the sample
    sample_code VARCHAR(20) UNIQUE NOT NULL,             -- Unique code for the sample (e.g., "SMP-001")
    sample_name VARCHAR(100),                            -- Name or description of the sample
    sample_description TEXT,                             -- Detailed description of the sample
    sample_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,     -- Date when the sample was collected or tested
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,      -- Timestamp when the record was created    
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- Timestamp when the record was last updated    
    
);  


CREATE TABLE Parameters (
    parameter_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique identifier for the parameter
    parameter_code VARCHAR(20) UNIQUE NOT NULL,  -- Unique code for the parameter (e.g., "PAR-001")
    parameter_name VARCHAR(100),                 -- Name or description of the parameter
    parameter_description TEXT,                  -- Detailed description of the parameter
    parameter_type ENUM('qualitative', 'quantitative') NOT NULL, -- Type of parameter
    qc_microparam ENUM('qc', 'micro') NOT NULL,  -- Quality Control or Microbiological parameter
    
    item_id INT,                       -- Foreign key to item code
    parameter_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Date when the parameter was created or updated
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Timestamp when the record was created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Timestamp when the record was last updated    
  
    FOREIGN KEY (item_id) REFERENCES Item(item_id) -- Foreign key to Items table (if applicable)
);

CREATE TABLE specification_header (
    specification_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique identifier for the specification
    specification_description TEXT,                  -- Detailed description of the specification
    specification_number VARCHAR(20),                -- Specification number
    specification_version VARCHAR(20),               -- Specification version
    issue_date DATE,                                 -- Date when the specification was issued
    review_due DATE,                                 -- Review due date
    effective_date DATE,                             -- Effective date of the specification
    item_id INT,                        -- Foreign key to product code
    
    specification_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Date when the specification was created or updated
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Timestamp when the record was created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Timestamp when the record was last updated    
  
    FOREIGN KEY (item_id) REFERENCES Item(item_id) -- Foreign key to Items table (if applicable)
);

CREATE TABLE specification_details (
    detail_id INT AUTO_INCREMENT PRIMARY KEY,        -- Unique identifier for the specification detail
    specification_id INT,                            -- Foreign key to specification_header
    parameter_id INT,                                -- Foreign key to Parameters
    specification_description TEXT,                  -- Detailed description of the specification detail

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Timestamp when the record was created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Timestamp when the record was last updated
    FOREIGN KEY (specification_id) REFERENCES specification_header(specification_id) -- Foreign key to specification_header table
);


CREATE TABLE Test_Results (
    result_id INT AUTO_INCREMENT PRIMARY KEY,         -- Unique identifier for the test result
    specification_id INT,                            -- Reference to the specification being tested (foreign key to Specifications)
    sample_id INT,                                   -- Reference to the sample being tested (foreign key to Samples)
    item_id INT ,                        -- Reference to the product being tested (foreign key to Products)
    parameter_id INT,                                -- Reference to the parameter being tested (foreign key to Parameters)
    test_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    -- Date when the test was conducted
    test_result DECIMAL(10, 2),                       -- The actual test result value
    test_compliance ENUM('pass', 'fail', 'inconclusive'), -- Compliance status of the test result
    tested_by INT,                                   -- Reference to the employee who conducted the test (foreign key to Employees)
    checked_by INT,                                  -- Reference to the employee who checked the test result (foreign key to Employees)
    checked_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Date when the test result was checked
    approved_by INT,                                 -- Reference to the employee who approved the test result (foreign key to Employees)
    approved_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Date when the test result was approved
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Timestamp when the record was created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Timestamp when the record was last updated
    FOREIGN KEY (sample_id) REFERENCES Samples(sample_id), -- Foreign key to the Samples table
    FOREIGN KEY (parameter_id) REFERENCES Parameters(parameter_id), -- Foreign key to the Parameters table
    Foreign key (item_id) references Item(item_id),
    Foreign key (specification_id) references Specification_header(specification_id),
    Foreign key (tested_by) references Employee(employee_id),
    Foreign key (checked_by) references Employee(employee_id),
    Foreign key (approved_by) references Employee(employee_id)
);
CREATE TABLE OOS_Events (
    oos_id INT AUTO_INCREMENT PRIMARY KEY,                 -- Unique identifier for the OOS event
    department_id INT,                                     -- Reference to the department responsible for the OOS (foreign key to Departments)
    oos_reference_number VARCHAR(20) UNIQUE NOT NULL,                   -- Unique code for the OOS event (e.g., "OOS-001")
    sample_id INT,                                         -- Reference to the sample related to the OOS (foreign key to Samples)
    item_id INT,                                        -- Reference to the product being tested (foreign key to Products)
    specification_id INT,                                  -- Reference to the specification or test procedure (foreign key to Specifications)
    oos_description TEXT,                                  -- Description of the OOS event (e.g., which test did not meet specifications)
    oos_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,          -- Date when the OOS event was identified
    test_result DECIMAL(10, 2),                             -- The test result that failed the specification
    specification_value DECIMAL(10, 2),                     -- The specification value the product should meet
    investigation_status ENUM('not-started', 'in-progress', 'completed', 'closed') DEFAULT 'not-started', -- Status of the OOS investigation
    phase_1a_investigation TEXT,                           -- Phase 1A investigation details
    phase_1a_investigation_commnets TEXT,                  -- Phase 1A investigation comments
    phase_1a_investigation_commented_by INT,                                     -- Reference to the employee who commented on the Phase 1A investigation (foreign key to Employees)
    phase_1a_investigation_date TIMESTAMP,                 -- Phase 1A investigation date
    phase_1a_investigation_status ENUM('open', 'closed'),  -- Phase 1A investigation status
    phase_1a_investigation_approved_by INT,               -- Reference to the employee who approved the Phase 1A investigation (foreign key to Employees)
    phase_1a_investigation_approved_date TIMESTAMP,        -- Date when the Phase 1A investigation was approved
    phase_1b_investigation TEXT,                           -- Phase 1B investigation details
    phase_1b_investigation_comments TEXT,                  -- Phase 1B investigation comments
    phase_1b_investigation_comments_by INT,                -- Reference to the employee who commented on the Phase 1B investigation (foreign key to Employees)
    phase_1b_investigation_date TIMESTAMP,                 -- Phase 1B investigation date
    phase_1b_investigation_status ENUM('open', 'closed'),  -- Phase 1B investigation status
    phase_1b_investigation_approved_by INT,               -- Reference to the employee who approved the Phase 1B investigation (foreign key to Employees)
    phase_1b_investigation_approved_date TIMESTAMP,        -- Date when the Phase 1B investigation was approved
    phase_2_investigation TEXT,                            -- Phase 2 investigation details
    phase_2_investigation_comments TEXT,                   -- Phase 2 investigation comments
    phase_2_investigation_comments_by INT,                 -- Reference to the employee who commented on the Phase 2 investigation (foreign key to Employees)
    phase_2_investigation_date TIMESTAMP,                  -- Phase 2 investigation date
    phase_2_investigation_status ENUM('open', 'closed'),   -- Phase 2 investigation status
    phase_2_investigation_approved_by INT,                -- Reference to the employee who approved the Phase 2 investigation (foreign key to Employees)
    phase_2_investigation_approved_date TIMESTAMP,         -- Date when the Phase 2 investigation was approved
    phase_3_investigation TEXT,                            -- Phase 3 investigation details
    phase_3_investigation_comments TEXT,                   -- Phase 3 investigation comments
    phase_3_investigation_comments_by INT,                 -- Reference to the employee who commented on the Phase 3 investigation (foreign key to Employees)
    phase_3_investigation_date TIMESTAMP,                  -- Phase 3 investigation date
    phase_3_investigation_status ENUM('open', 'closed'),   -- Phase 3 investigation status
    phase_3_investigation_approved_by INT,                -- Reference to the employee who approved the Phase 3 investigation (foreign key to Employees)
    phase_3_investigation_approved_date TIMESTAMP,         -- Date when the Phase 3 investigation was approved
    final_root_cause TEXT,                                       -- Root cause of the OOS, as identified through investigation
    corrective_action TEXT,                                 -- Corrective actions taken to address the OOS
    preventive_action TEXT,                                 -- Preventive actions to avoid recurrence of the OOS
    close_out_date TIMESTAMP,                              -- Date when the OOS was resolved (only filled when investigation is closed)
    verification_status ENUM('verified', 'not-verified') DEFAULT 'not-verified', -- Status of the OOS verification
    closure_status ENUM('open', 'resolved', 'rejected', 'withdrawn') DEFAULT 'open',  -- Current status of the OOS event
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,         -- Timestamp when the record was created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Timestamp for when the record was last updated
    FOREIGN KEY (sample_id) REFERENCES Samples(sample_id), -- Foreign key to the Samples table (if applicable)
    FOREIGN KEY (item_id) REFERENCES Item(item_id), -- Foreign key to the Products table
    FOREIGN KEY (specification_id) REFERENCES Specification_header(specification_id), -- Foreign key to the Specifications table
    Foreign key (phase_1a_investigation_commented_by) references Employee(employee_id),
    Foreign key (phase_1a_investigation_approved_by) references Employee(employee_id),
    Foreign key (phase_1b_investigation_comments_by) references Employee(employee_id),
    Foreign key (phase_1b_investigation_approved_by) references Employee(employee_id),
    Foreign key (phase_2_investigation_comments_by) references Employee(employee_id),
    Foreign key (phase_2_investigation_approved_by) references Employee(employee_id),
    Foreign key (phase_3_investigation_comments_by) references Employee(employee_id),
    Foreign key (phase_3_investigation_approved_by) references Employee(employee_id),
    Foreign key (department_id) references Departments(department_id)
);
CREATE TABLE OOT_Events (
    oot_id INT AUTO_INCREMENT PRIMARY KEY,                  -- Unique identifier for the OOT event
    department_id INT,                                      -- Reference to the department responsible for the OOT (foreign key to Departments)
    oot_reference_number VARCHAR(20) UNIQUE NOT NULL,                   -- Unique code for the OOT event (e.g., "OOT-001")
    parameter_id INT,                                       -- Reference to the parameter related to the OOT (foreign key to Parameters)
    item_id INT,                                         -- Reference to the product being tested (foreign key to Products)
    specification_id INT,                                   -- Reference to the specification or test procedure (foreign key to Specifications)
    oot_description TEXT,                                   -- Description of the OOT event (e.g., which parameter was out of trend)
    oot_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,           -- Date when the OOT event was identified
    trend_result DECIMAL(10, 2),                            -- The trend result that was out of specification
    specification_value DECIMAL(10, 2),                     -- The specification value the parameter should meet
    investigation_status ENUM('not-started', 'in-progress', 'closed') DEFAULT 'not-started', -- Status of the OOT investigation
    root_cause TEXT,                                        -- Root cause of the OOT, as identified through investigation
    corrective_action TEXT,                                 -- Corrective actions taken to address the OOT
    preventive_action TEXT,                                 -- Preventive actions to avoid recurrence of the OOT
    resolution_date TIMESTAMP,                              -- Date when the OOT was resolved (only filled when investigation is closed)
    status ENUM('open', 'resolved', 'rejected') DEFAULT 'open',  -- Current status of the OOT event
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,         -- Timestamp when the record was created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Timestamp for when the record was last updated
    FOREIGN KEY (parameter_id) REFERENCES Parameters(parameter_id), -- Foreign key to the Parameters table
    FOREIGN KEY (item_id) REFERENCES Item(item_id), -- Foreign key to the Products table
    FOREIGN KEY (specification_id) REFERENCES Specification_header(specification_id), -- Foreign key to the Specifications table
    Foreign key (department_id) references Departments(department_id)
);

CREATE TABLE Risk_Management (
    risk_id INT AUTO_INCREMENT PRIMARY KEY,
    risk_reference_number VARCHAR(20)  UNIQUE NOT NULL,
    department_id INT,  -- Reference to the department responsible for the risk (foreign key to Departments)
    risk_event TEXT,
    risk_category ENUM('operational', 'financial', 'strategic'),  -- e.g., "Operational", "Financial", "Strategic"
    risk_probability DECIMAL(5, 2),  -- Probability of the risk occurring (0-100%)
    risk_impact DECIMAL(10, 2),  -- Impact of the risk if it occurs (e.g., financial impact)
    risk_impact_description TEXT,  -- Description of the impact of the risk
    risk_status ENUM('open', 'mitigated', 'closed') DEFAULT 'open',  -- Current status of the risk
    fmea_code VARCHAR(20),
    process_id INT,  -- Reference to the process being analyzed (foreign key to Processes)
    failure_mode TEXT,  -- Description of the failure mode
    failure_effect TEXT,  -- Description of the effect of the failure on the process
    detection_method VARCHAR(255),  -- Method used to detect the failure mode
    detection_rating DECIMAL(5, 2),  -- Rating of the detection method (0-10)
    RPN DECIMAL(10, 2),  -- Risk priority number (severity x occurrence x detection)
    recommended_action TEXT,
    action_status ENUM('not-started', 'in-progress', 'completed') DEFAULT 'not-started',
    risk_management_team_id INT,  -- Reference to the team responsible for risk management (foreign key to Teams)
    team_sign_off ENUM('approved', 'rejected') DEFAULT 'rejected',
    team_sign_off_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (process_id) REFERENCES Process(process_id),

    Foreign key (department_id) references Departments(department_id)
);

CREATE TABLE Risk_Management_Teams (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    risk_id INT,  -- Reference to the risk being managed (foreign key to Risk_Management)
    team_leader INT,  -- Reference to the team leader (foreign key to Employees)
    team_member_1 INT,  -- Reference to team member 1 (foreign key to Employees)
    team_member_2 INT,  -- Reference to team member 2 (foreign key to Employees)
    team_member_3 INT,  -- Reference to team member 3 (foreign key to Employees)
    team_member_4 INT,  -- Reference to team member 4 (foreign key to Employees)
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (team_leader) REFERENCES Employee(employee_id),
    Foreign key (team_member_1) references Employee(employee_id),
    Foreign key (team_member_2) references Employee(employee_id),
    Foreign key (team_member_3) references Employee(employee_id),
    Foreign key (team_member_4) references Employee(employee_id)
);

CREATE TABLE Risk_Reduction (
    reduction_id INT AUTO_INCREMENT PRIMARY KEY,
    risk_id INT,  -- Reference to the risk being reduced (foreign key to Risk_Management)
    severity DECIMAL(5, 2),  -- New severity rating after risk reduction measures
    probability DECIMAL(5, 2),  -- New probability rating after risk reduction measures
    detection DECIMAL(5, 2),  -- New detection rating after risk reduction measures
    RPN DECIMAL(10, 2),  -- New risk priority number after risk reduction measures
    reduction_measures TEXT,  -- Description of the risk reduction measures taken
    reduction_effectiveness ENUM('high', 'medium', 'low'),  -- Effectiveness of the reduction measures
    status ENUM('planned', 'implemented', 'verified') DEFAULT 'planned',  -- Current status of the reduction plan
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (risk_id) REFERENCES Risk_Management(risk_id)
);

-- Removed duplicate Warehouse_Locations table definition
CREATE TABLE Warehouses (
    warehouse_id INT AUTO_INCREMENT PRIMARY KEY,
    warehouse_code VARCHAR(100) UNIQUE NOT NULL,
    warehouse_name VARCHAR(255) NOT NULL,
    warehouse_address TEXT,
    warehouse_contact_phone VARCHAR(20),
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE Tax_Types (
    tax_type_id INT AUTO_INCREMENT PRIMARY KEY,
    tax_name VARCHAR(255) NOT NULL,
    tax_rate DECIMAL(5, 2),  -- Percentage tax rate
    tax_description TEXT,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
CREATE TABLE Payment_Terms (
    payment_term_id INT AUTO_INCREMENT PRIMARY KEY,
    term_name VARCHAR(255) NOT NULL,
    description TEXT,
    days INT,  -- Number of days for payment
    discount_percentage DECIMAL(5, 2),  -- Discount if paid early
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
CREATE TABLE Inventory_Locations (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    location_code VARCHAR(100) UNIQUE NOT NULL,
    location_name VARCHAR(255) NOT NULL,
    warehouse_id INT,  -- Link to warehouse
    aisle VARCHAR(50),
    shelf VARCHAR(50),
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id)
);








CREATE TABLE Document_Numbering_Format (
    format_id INT AUTO_INCREMENT PRIMARY KEY,
    document_type_id INT NOT NULL,  -- Reference to the document type (foreign key to Document_Types)
    format_pattern VARCHAR(255) NOT NULL,  -- Pattern for document numbering (e.g., "INV-{year}-{sequence}")
    sequence_start INT DEFAULT 1,  -- Starting number for the sequence
    sequence_increment INT DEFAULT 1,  -- Increment for each new document
    description TEXT,  -- Optional: Detailed description of the numbering format
    status ENUM('active', 'inactive') DEFAULT 'active',  -- Status of the numbering format
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Timestamp for when the record is created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- Timestamp for when the record is updated
    FOREIGN KEY (document_type_id) REFERENCES Document_Types(document_type_id)  -- Foreign key to Document_Types table
);
-- Change Request Table (Stores details of change requests)
CREATE TABLE Change_Request (
    change_request_id INT AUTO_INCREMENT PRIMARY KEY,
    change_request_code VARCHAR(100) UNIQUE NOT NULL,  -- Unique code for the change request
    change_request_title VARCHAR(255) NOT NULL,  -- Title of the change request
    change_request_description TEXT NOT NULL,  -- Detailed description of the change request
    change_request_type ENUM('product', 'process', 'system', 'documentation') NOT NULL,  -- Type of change
    requested_by INT,  -- User who requested the change (could be linked to Users table)
    requested_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Date when the request was made
    status ENUM('new', 'in_review', 'approved', 'rejected', 'implemented', 'closed') DEFAULT 'new',  -- Status of the change request
    priority ENUM('low', 'medium', 'high') DEFAULT 'medium',  -- Priority of the change request
    reason_for_change TEXT,  -- Reason for the requested change
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Record creation date
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  -- Last updated date
);

-- Change Evaluation Table (Tracks evaluations of the change requests)
CREATE TABLE Change_Evaluation (
    evaluation_id INT AUTO_INCREMENT PRIMARY KEY,
    change_request_id INT,  -- Linked to the Change_Request table
    evaluator INT,  -- User who evaluated the change (could be linked to Users table)
    evaluation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Date when the evaluation was conducted
    evaluation_status ENUM('approved', 'rejected', 'pending') DEFAULT 'pending',  -- Evaluation status
    evaluation_comments TEXT,  -- Comments on the evaluation
    impact_analysis TEXT,  -- Impact analysis of the proposed change
    risk_assessment TEXT,  -- Risk assessment related to the change
    cost_estimation DECIMAL(10, 2),  -- Estimated cost for implementing the change
    FOREIGN KEY (change_request_id) REFERENCES Change_Request(change_request_id)
);

-- Change Approval Table (Tracks approvals for the change requests)
CREATE TABLE Change_Approval (
    approval_id INT AUTO_INCREMENT PRIMARY KEY,
    change_request_id INT,  -- Linked to the Change_Request table
    approver INT,  -- User who approved or rejected the change (could be linked to Users table)
    approval_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Date when the change was approved or rejected
    approval_status ENUM('approved', 'rejected') NOT NULL,  -- Status of the approval
    approval_comments TEXT,  -- Comments on the approval decision
    FOREIGN KEY (change_request_id) REFERENCES Change_Request(change_request_id)
);

-- Change Implementation Table (Stores details about the implementation of the change)
CREATE TABLE Change_Implementation (
    implementation_id INT AUTO_INCREMENT PRIMARY KEY,
    change_request_id INT,  -- Linked to the Change_Request table
    implementation_start_date TIMESTAMP,  -- Start date of the implementation
    implementation_end_date TIMESTAMP,  -- End date of the implementation
    implementation_status ENUM('not_started', 'in_progress', 'completed', 'closed') DEFAULT 'not_started',  -- Current status of the implementation
    implementation_notes TEXT,  -- Any notes related to the implementation
    implemented_by INT,  -- User who implemented the change (could be linked to Users table)
    FOREIGN KEY (change_request_id) REFERENCES Change_Request(change_request_id)
);

-- Change Documentation Table (Stores documentation related to the changes)
CREATE TABLE Change_Documentation (
    documentation_id INT AUTO_INCREMENT PRIMARY KEY,
    change_request_id INT,  -- Linked to the Change_Request table
    document_title VARCHAR(255) NOT NULL,  -- Title of the document
    document_type ENUM('plan', 'report', 'manual', 'specification') NOT NULL,  -- Type of document
    document_description TEXT,  -- Description of the document
    document_link VARCHAR(255),  -- Link to the document (could be a URL or file path)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Record creation date
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- Last updated date
    FOREIGN KEY (change_request_id) REFERENCES Change_Request(change_request_id)
);

-- Change History Table (Stores history of changes made to the change requests)
CREATE TABLE Change_History (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    change_request_id INT,  -- Linked to the Change_Request table
    changed_by INT,  -- User who made the change (could be linked to Users table)
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Date when the change was made
    change_description TEXT,  -- Description of the change made to the request
    FOREIGN KEY (change_request_id) REFERENCES Change_Request(change_request_id)
);

-- Change Closure Table (Stores details when the change request is closed)
CREATE TABLE Change_Closure (
    closure_id INT AUTO_INCREMENT PRIMARY KEY,
    change_request_id INT,  -- Linked to the Change_Request table
    closed_by INT,  -- User who closed the change request (could be linked to Users table)
    closure_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Date when the change was closed
    closure_comments TEXT,  -- Comments on the closure of the change request
    FOREIGN KEY (change_request_id) REFERENCES Change_Request(change_request_id)
);

-- Audit Table (Stores details of audits conducted within the organization)
CREATE TABLE Audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    audit_code VARCHAR(100) UNIQUE NOT NULL,  -- Unique code for the audit
    audit_name VARCHAR(255) NOT NULL,  -- Name of the audit
    audit_type ENUM('internal', 'external', 'supplier', 'compliance') NOT NULL,  -- Type of audit
    audit_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Date when the audit was conducted
    audit_status ENUM('scheduled', 'in_progress', 'completed', 'closed') DEFAULT 'scheduled',  -- Current status of the audit
    audit_scope TEXT,  -- Scope of the audit (areas to be audited)
    audit_criteria TEXT,  -- Criteria or standards against which the audit is conducted
    audit_objective TEXT,  -- Objective of the audit
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Record creation date
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  -- Last updated date
);

-- Audit Findings Table (Stores findings from the audit)
CREATE TABLE Audit_Finding (
    finding_id INT AUTO_INCREMENT PRIMARY KEY,
    audit_id INT,  -- Linked to the Audit table
    finding_description TEXT NOT NULL,  -- Description of the audit finding
    severity ENUM('low', 'medium', 'high') DEFAULT 'medium',  -- Severity of the finding
    corrective_action_required BOOLEAN DEFAULT TRUE,  -- Whether corrective action is required
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Record creation date
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- Last updated date
    FOREIGN KEY (audit_id) REFERENCES Audit(audit_id)
);

-- Audit Action Plan Table (Tracks action plans for addressing audit findings)
CREATE TABLE Audit_Action_Plan (
    action_plan_id INT AUTO_INCREMENT PRIMARY KEY,
    finding_id INT,  -- Linked to the Audit_Finding table
    action_plan_description TEXT,  -- Description of the corrective action plan
    action_owner INT,  -- User responsible for implementing the action (could be linked to Users table)
    due_date DATE,  -- Due date for the completion of the action plan
    action_status ENUM('pending', 'in_progress', 'completed', 'closed') DEFAULT 'pending',  -- Status of the action plan
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Record creation date
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- Last updated date
    FOREIGN KEY (finding_id) REFERENCES Audit_Finding(finding_id)
);

-- Inspection Table (Stores details of inspections conducted within the organization)
CREATE TABLE Inspection (
    inspection_id INT AUTO_INCREMENT PRIMARY KEY,
    inspection_code VARCHAR(100) UNIQUE NOT NULL,  -- Unique code for the inspection
    inspection_name VARCHAR(255) NOT NULL,  -- Name of the inspection
    inspection_type ENUM('internal', 'external', 'supplier', 'regulatory') NOT NULL,  -- Type of inspection
    inspection_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Date when the inspection was conducted
    inspection_status ENUM('scheduled', 'in_progress', 'completed', 'closed') DEFAULT 'scheduled',  -- Current status of the inspection
    inspection_scope TEXT,  -- Scope of the inspection (areas to be inspected)
    inspection_criteria TEXT,  -- Criteria or standards against which the inspection is conducted
    inspection_objective TEXT,  -- Objective of the inspection
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Record creation date
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  -- Last updated date
);

-- Inspection Findings Table (Stores findings from the inspection)
CREATE TABLE Inspection_Finding (
    finding_id INT AUTO_INCREMENT PRIMARY KEY,
    inspection_id INT,  -- Linked to the Inspection table
    finding_description TEXT NOT NULL,  -- Description of the inspection finding
    severity ENUM('low', 'medium', 'high') DEFAULT 'medium',  -- Severity of the finding
    corrective_action_required BOOLEAN DEFAULT TRUE,  -- Whether corrective action is required
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Record creation date
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- Last updated date
    FOREIGN KEY (inspection_id) REFERENCES Inspection(inspection_id)
);

-- Inspection Action Plan Table (Tracks action plans for addressing inspection findings)
CREATE TABLE Inspection_Action_Plan (
    action_plan_id INT AUTO_INCREMENT PRIMARY KEY,
    finding_id INT,  -- Linked to the Inspection_Finding table
    action_plan_description TEXT,  -- Description of the corrective action plan
    action_owner INT,  -- User responsible for implementing the action (could be linked to Users table)
    due_date DATE,  -- Due date for the completion of the action plan
    action_status ENUM('pending', 'in_progress', 'completed', 'closed') DEFAULT 'pending',  -- Status of the action plan
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Record creation date
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- Last updated date
    FOREIGN KEY (finding_id) REFERENCES Inspection_Finding(finding_id)
);

-- Audit and Inspection Reports Table (Stores reports generated from audits and inspections)
CREATE TABLE Audit_Inspection_Report (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    report_name VARCHAR(255) NOT NULL,  -- Name of the report
    report_type ENUM('audit', 'inspection') NOT NULL,  -- Type of report (audit or inspection)
    report_description TEXT,  -- Description of the report
    generated_by INT,  -- User who generated the report (could be linked to Users table)
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Date when the report was generated
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Record creation date
);
