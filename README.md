Okta + Active Directory IAM Home Lab

Project Overview

This project demonstrates a hybrid Identity and Access Management (IAM) environment integrating Microsoft Active Directory with Okta.

The goal of this lab is to simulate real-world enterprise IAM operations, including user provisioning, access management, authentication, and automated Joiner-Mover-Leaver (JML) processes.

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
- Created and organized users, organizational units, and security groups.
- Integrated Active Directory with Okta.
- Configured identity synchronization.

2. Role-Based Access Control (RBAC)
- Implemented role-based access controls.
- Assigned permissions based on user roles and group membership.
- Tested authorized and unauthorized access.

3. Authentication and Security
- Configured SAML and OIDC authentication.
- Implemented MFA.
- Tested authentication and access restrictions.

4. Identity Lifecycle Automation
Developed PowerShell scripts to automate:

- **Joiner:** Creating and provisioning new users.
- **Mover:** Updating user access when roles or departments change.
- **Leaver:** Disabling accounts and removing access when users leave the organization.

5. IAM Reporting
- Generated access reports.
- Tracked account compliance.
- Reviewed failed sign-in activity.

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

Screenshots and Demonstrations

Screenshots documenting the lab configuration, authentication tests, automation workflows, and reporting will be included in the `docs/screenshots/` directory.

Skills Demonstrated

- Identity and Access Management (IAM)
- Active Directory Administration
- Okta Administration
- PowerShell Automation
- Role-Based Access Control (RBAC)
- Identity Lifecycle Management
- SAML and OIDC Authentication
- Multi-Factor Authentication
- Access Governance and Reporting

Future Improvements

- Integrate additional enterprise applications.
- Expand automated access reviews.
- Implement more advanced conditional access policies.
- Improve logging and monitoring.
- Explore additional identity governance capabilities.

---
