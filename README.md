Okta + Active Directory IAM Home Lab

Project Overview

This project demonstrates a hybrid Identity and Access Management (IAM) environment integrating Microsoft Active Directory with Okta.

The lab simulates enterprise IAM operations, including user provisioning, identity synchronization, role-based access control, authentication, multi-factor authentication, and automated Joiner-Mover-Leaver (JML) processes.

Technologies Used

- Microsoft Active Directory
- Okta
- PowerShell
- LDAP
- SAML
- OpenID Connect (OIDC)
- Multi-Factor Authentication (MFA)
- Windows Server

Key Features

1. Active Directory Integration
- Created and organized user accounts, organizational units (OUs), and security groups.
- Integrated Active Directory with Okta.
- Configured identity synchronization between environments.

2. Role-Based Access Control (RBAC)
- Implemented role-based access controls using security groups.
- Organized users according to departments and job roles.
- Tested authorized and unauthorized application access.

3. Authentication and Security
- Configured SAML and OIDC authentication.
- Implemented multi-factor authentication (MFA).
- Tested authentication workflows and access restrictions.

4. Identity Lifecycle Automation

Developed PowerShell scripts to automate Joiner-Mover-Leaver processes:

- **Joiner:** Creates and provisions new user accounts.
- **Mover:** Updates user information, group membership, and organizational placement when employees change departments.
- **Leaver:** Disables accounts, removes group memberships, and revokes active Okta sessions.

5. IAM Reporting and Monitoring
- Generated reports identifying users, group memberships, and assigned applications.
- Flagged inactive accounts and administrative access.
- Reviewed failed sign-in activity through Okta System Log events.
- Exported reports for access monitoring and compliance review.

Repository Structure

```text
okta-ad-iam-lab/
│
├── scripts/
│   ├── create_users.ps1
│   ├── jml.ps1
│   └── access_report.ps1
│
├── sample-data/
│   ├── users.csv
│   └── hr_feed.csv
│
├── docs/
│   ├── architecture.png
│   └── screenshots/
│
├── README.md
└── .gitignore
```

Screenshots and Documentation

Screenshots documenting the lab environment, identity synchronization, user and group configurations, authentication workflows, and automation results are available in:

`docs/screenshots/`

Skills Demonstrated

- Identity and Access Management (IAM)
- Active Directory Administration
- Okta Administration
- PowerShell Automation
- Role-Based Access Control (RBAC)
- Identity Lifecycle Management
- SAML and OIDC Authentication
- Multi-Factor Authentication
- Access Governance
- Account Provisioning and Deprovisioning
- Security Monitoring and Reporting

Future Improvements

- Integrate additional enterprise applications.
- Expand automated access reviews.
- Implement more advanced conditional access policies.
- Improve centralized logging and monitoring.
- Explore additional identity governance and administration (IGA) capabilities.

Disclaimer

This project was developed in a controlled home lab environment for educational purposes. All users and sample data are fictional. No production credentials, API tokens, or sensitive organizational information should be included in this repository.
