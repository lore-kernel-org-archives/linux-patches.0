Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755538565E
	for <patches@lists.linux.dev>; Thu, 18 Jul 2024 09:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721296350; cv=fail; b=O7vmggWQOW+69iLSy41lFGsSArPldq8F2OruxJbbWt0FFITP1KpctL/w1UBNm+/pROmb2IJTqLg6B78lWzMjO5m/Mwh9fNza/fThR4+UdejtF7CSg8uzdQQUYXJbhFfIDlrUHAl7BeajGYEMn2VmnmYv8cHsSZ6WqZ0KESa4HFA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721296350; c=relaxed/simple;
	bh=7DaPoqEACS9wy7S4H5b4KMSD5sBvFpAP3suynL9+DoA=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=F1C551CbwSae0R9Ywp1TJOGLYBMgVXmBLsyDxMAN3sN+9CmNdh/h4HTRlwCF3euvwa1CKSs+sUe4ILPBPixLID+m3zU/cPdx7Tt1NKD7UWtN/Kx6kPGlylskJ4VARTnKAVly0gofF11YHs1Edk8oYVBejWZyyjDrEaefjHsr/Hk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=D5sMfaoi; arc=fail smtp.client-ip=40.107.243.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="D5sMfaoi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vX7YBNjqcDYdpSYuse1xBvrH62JYEoH8ggu5Iq1y+Ab1blHjmqNNli/6Isrz39R4JXUi4uP8Q9aKZqYXOkcVQtPeeicXaqlJlvSBV/OIW6vFOEV+BZkYbd707RVZeZ2lV5K6oYzbhIEdv28H62MIIqXXfzXNVNyvjVAredAoLiDTjOvkl+dlVWXu9qkp0Ypb6jNDUXV0lljOg1xaWPCNLaPF8UCGKp6FrPn62/UGR8huUK8RI83e866X43HwFMiH5oC7lx4jhGHveicVr8H4htXJqaOPreHPnuS1Yddg+vzK5GioSZZrqm2/qHPeBfhR4n+O4PjUXaCVTniHMWDG+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qb0fcp3v7+EnvtFkMDFo8ueglLbxDybqv6jQpqlL8D8=;
 b=ehNmm+K+33eiukMKBqUwiPTrHXPkpyfHjIRIzaPgh9YuPsC6769O3J+7oyXjnOG2Kdh1Kr0a8oOy7AALmfQ9wPyJzxPZwG3GZeT68Mh+3uMh9DL9Zc0t8zHwth+Lg/J9jZlu0uY86/UJODMGKFL3A7/49LShwDcr+U7nAC8LBL6QXZ4c7D7ypmdVM2XSC6HyHrOUv1a+aoYLgN1LxYF+QqKiD4WrMbZ/u1KQGBePF0afHGxOlC4ZDv9WHayEf6E+pd5uLfV0IBQT4b+CsoN90/cGxuUnWle5JBPtXqMmXJRQ/qN6/pv+4dZkzni3tEKrVo1mdvJg9ovqRQ9QXUkkLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qb0fcp3v7+EnvtFkMDFo8ueglLbxDybqv6jQpqlL8D8=;
 b=D5sMfaoiaJ6Q1lnLbtTOngWqEjsaMvAAxFzuAc8CQVieXY9vyAvuF4ydklJ/R4TOOwvVwSUkORwtMV+QuEG1B6jQDUbRvZ0whxATGqvMDnfxLxHXKxK15XYch1GSi7wNe+xw8oJHUhEZQfqQst5XRAqBhkjGojtM5JrBf3ZUy5W7ClLfeg5vnapNB8WyrubciYgLqnNwL9RMe2qRFX2MidEIvnwKLg+dhndsogc6h+s27Myrx+PwONeofQCS24Tblg+PbTM42BeLEzYtLzxn8IHo5DBW/qHxGDiNAI/OBFHlIdsJ7uiU1teClwxfhJatV90kzFx195mr6C0ezJflWQ==
Received: from PH7PR17CA0064.namprd17.prod.outlook.com (2603:10b6:510:325::21)
 by BL1PR12MB5922.namprd12.prod.outlook.com (2603:10b6:208:399::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.17; Thu, 18 Jul
 2024 09:52:24 +0000
Received: from CY4PEPF0000FCC0.namprd03.prod.outlook.com
 (2603:10b6:510:325:cafe::61) by PH7PR17CA0064.outlook.office365.com
 (2603:10b6:510:325::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.17 via Frontend
 Transport; Thu, 18 Jul 2024 09:52:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000FCC0.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7784.11 via Frontend Transport; Thu, 18 Jul 2024 09:52:23 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 18 Jul
 2024 02:52:14 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 18 Jul 2024 02:52:13 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 18 Jul 2024 02:52:13 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <allen.lkml@gmail.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 5.15 000/145] 5.15.163-rc2 review
In-Reply-To: <20240717063804.076815489@linuxfoundation.org>
References: <20240717063804.076815489@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <fd7b88ab-08af-401f-b529-726168210358@drhqmail201.nvidia.com>
Date: Thu, 18 Jul 2024 02:52:13 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC0:EE_|BL1PR12MB5922:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a04f056-d78f-43ed-86ea-08dca70f52dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aVJ5RlJ0ODM2MTY0S1dKWkI2UkVXZ0dEV0tyQmoxR3hMU1paVllRZnlYRjFu?=
 =?utf-8?B?am92b01yK3Z0VkVKUnBKeFhRWDBaL1J0RFg1RklaNTRqeFlsU3hNa3VIdkJ4?=
 =?utf-8?B?UTBJWFJLeWtCMjV2RFg2MTY0d0lsY3g0L1hBcEVkaEh1ZG1xc0RuZ3JlcFRD?=
 =?utf-8?B?N3lrL1hFbHR4clZ2TDJLUVd2OWg4OWlEM1NmUmMzM2ZFWUc0aU5WMFVCQVo3?=
 =?utf-8?B?a1F3RHdyNlV4Ly9jQ1BrZ2xJSDdaK0lOK2pjRlVHUVZjSjRwMDQ4eDROR2tR?=
 =?utf-8?B?bWhNR2N2eGk2cGpVOUFXbFVkWjEvODliSlZSNy8yOExMaDNMWDhTMU9JMmR0?=
 =?utf-8?B?dGx4cktTNDlOK1UrdWZya0ZSaDFzTSsrV1hQK1J1b0hZQlRrOSs0WHJINkxN?=
 =?utf-8?B?SFFldXZtYVljYXJrdFdENXoyVUpvQjNSUmlJeGtGS1BhM1hjaEd5azZYOUxa?=
 =?utf-8?B?ME80ZDA4VkI5b2Y5SnRTMDlMVzBUU0NqNWdmSlB0NWUrdlRqcEhKYmg0VWVr?=
 =?utf-8?B?VTlYeTlkTnRlbGo0a1plNUhrQzJjdzYyclRUeFZreElmTjd2TTNJOWRycURk?=
 =?utf-8?B?WmxkbnhWQ0ZtUDNubEFyVHhBdFRsWlZKNXQ5UXBsVDllcm0vblNaalZiN0la?=
 =?utf-8?B?dTRTOXdONkVRR3hWTlRaTHd5L0FRa0FmUkRnRDQ5SDk1U3h3TGdnTk1IdGNi?=
 =?utf-8?B?WEtxcTRFeEdFV0JnN20vZy9hWGN0c2dmNStpMVdQdks1MW1aVjFOdStzdDli?=
 =?utf-8?B?VTRkd3daczRUNG0vVTZJVFN0VlJ2eHNoM0RzUWZRRzdGNzhSNDQwZEN3ZXdq?=
 =?utf-8?B?OWx5UUY2My9SR0pNb3prWnM0OXQvTmg3M1dmOUpvc2c1OEVVVEF4dktMbWp1?=
 =?utf-8?B?L0FlQUkwQm1hNnZoMzNGRDNYZkRCMFV3UE9obUhhVU9tZ2JxVU5NUllKY3RJ?=
 =?utf-8?B?cDJzcmI0a0V3MWlVa1MyamhYM0NqUDM1VzNZNzVyTFZoYjBYYy9ZNXBiWnFX?=
 =?utf-8?B?K3Q5WUtoS2dkZS9ZaGV1VVF4K0plK0ZwcnR4aEVuc1UyU3BzMHZZd1NUTll1?=
 =?utf-8?B?dnNJbVZzZWZpeTM0bEJLS1poZmlBVXN5ZjJxU2dXVEVrczYxRDhZUFVMTXNz?=
 =?utf-8?B?SldtVXNLZUNqODJaOEZFelVHUUlmMTJ1RnpBcFhXRURtSWllTHU3Zit4K3ht?=
 =?utf-8?B?WkJrd21DcmhSaS94U2xsUVZYVW1yWVBtYldnenZ4N3VEOVQwWFFOMHU4aFZB?=
 =?utf-8?B?NWtPbWNobUYrVGRmTkdMODNQY1Z3TXdQRzVtbWJ5aVlTSGRWcDdBMlpkSTVU?=
 =?utf-8?B?MXd3MlIvS1crRllHZ3F3QnQ4Z2VYa2ZVbFhxME5YMG1MaEtHWDhhckhFOE1K?=
 =?utf-8?B?dnVKa1lueXUyeXJzZ2g5VkFlNjBrY1hsczUxbEROM203Y2N1RmpSMzNXbDA2?=
 =?utf-8?B?MHRyTUNRMzlOVG9pTExwby9kM1k2dzJOUzNJbmdqdUYraHdod29GaWcraExW?=
 =?utf-8?B?VzlwNXRMS245YVk5OTh6Yzl0WGZYQk1QMnZiNU9vdWczbW0wWDJiUHVhd05z?=
 =?utf-8?B?Tk9NUlY5Z1psWlVHYXl6cEd6Ukp2cGpHbGJtdjJxL1VWUSthT05uV1BMcm1l?=
 =?utf-8?B?cUE5UnFVbC9iYXl6MnVocVhvSEFwNlNJdDFHN1NHanhvaWVSR0kycXhyS3kv?=
 =?utf-8?B?bzhYdlVDd0VUaFkyUnNsSWlkK200YXFzU1dsMEZNdGo4V3prTXd1cjZ4V3Rp?=
 =?utf-8?B?NENiandtMTlrTER4WVpVbGtmVEFyVTQxUndoVGRRbWloMVpkWkFPMDY5bnJK?=
 =?utf-8?B?MnNxNHNZSDZESWt6RExYcnVIMklQTWs2TVp2d3hyQW1vZ2EzUjJPaGdMTlpS?=
 =?utf-8?B?Z0xCdlU5Q2VBTjVRY2VsRVRVWmFsNEhUZ1lkYVZnVlBaSm83T3hQU2NJMUJz?=
 =?utf-8?Q?gOhaJTYeffh6zr3MKL6AwzpsNrvPzqEv?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 09:52:23.5271
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a04f056-d78f-43ed-86ea-08dca70f52dd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5922

On Wed, 17 Jul 2024 08:39:16 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.163 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.163-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    90 tests:	90 pass, 0 fail

Linux version:	5.15.163-rc2-gb84034c8f228
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
