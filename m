Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2041.outbound.protection.outlook.com [40.107.223.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A309717A5A3
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 13:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720013248; cv=fail; b=I79H16L+uBtP/wfZF+m+LFBryzG3OR/7ZX2rTLGDH5MO//0tAR48PGYO5sVkrNW+DlQrLN1u5oQCpbyTEddjtQKXtgJ0Z7eNHipugs34rWEtMoTzT5r+Z+7PczcuVSy971O0/aBocNGuTDRKhRQ1gAyyqT+cK1pQT0WwcH1Yimo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720013248; c=relaxed/simple;
	bh=mETBorHfKcdKbgDKWJDO8aFJ27ye31u//2VxARenHPQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=kXNiQdOlWVkqZxlK3WBXmQkFZbiL/mHlYxndjWTpxz3Q/aa4ICPOTnH+g245YQaVbHFAXF5LZFwGLVa29/RketEtOiTFbq5JkkRD0AhuueyLTsKXx3c8+2Z1mQqqbiJ35N7Yj7RZ8m3d2gXWgt6P1KgUOann3RoTYZpNr+u+0Xs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XnbONYND; arc=fail smtp.client-ip=40.107.223.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XnbONYND"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RALhFkxRqSe1s7128N1vBrc3fphPZOiWKGK+1KHR+xJSPlYeIDSIfVV1a05tS56DZ6tO4y0GhsIRBjTatl83iNsKd8m7+22yxetY6IRV57pscuQYL5D9YCgip2QUY7r1ju1F9rjGTroF0g7V5q1Z8JWibhUjacHTca1vM+mx7VZic4J5jk8xDQGWqrbOlBr6ZHg3g/jbVf3WpKTe8Z7Hmjem89t1Kn+SUGnxkSecfL7BZsDSeNixDcHy6t/alhRHB7DdrtNZeIQoUAcPV6EfNNfPsYK6pk6VIu0vuAjO7vTg9wDeVXoyR45s3WKmOqW3Ua4FVideWUlMaLx1cF3Fgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bWf/+1E1CBMWzXARf1QIAaVSQkCcDPr7IfGOW6HG2oI=;
 b=G4HPfj3PCL1RZx7oTebwlky6xd9O+iG14xIgP69+8po9607x3VxrNc0JNB0fYBIKIYZyD+tyxejhJezWTgg8+0fgHe17a7OBlBWPHs4P0fr2XQemD7mUzHRG8W5WNeEmI6CRLDhPpkcFaHi4D7krEYjt012A6p12ESSZZmU4j0TEPZSxybhaVMUHR8vEZYRYHh5LR8If7q7ieJRM1PC5t/7DRoTIilySx3DdGVce092onbuaLFsVb7hI3PC69eyKSlftytj3HYlMedibOtKYfhB0zeDljNfMrDU8701yqMDf24wfDFqfBisovoyohNGbb7PSdgeb7L+WSHM5BpBjTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bWf/+1E1CBMWzXARf1QIAaVSQkCcDPr7IfGOW6HG2oI=;
 b=XnbONYNDJ5p4cfuvqKaITmLerlBQdQhmzNuAsSzkpe+HXYH6TNo0547jXrVNAwTBH79gixtdGYHs93Jqqm4CDlzkXlUbBeEBrg+572wUu7xZF4M9uJDzNaeBnk5lKY3b0l57ITPGtotbASS0L6WIc1OhM/Pa7RKwQsDBoAuwEeJwa0KtVYhY06X3v8t9z74Ks5QbiezH1EhrOrVnEfc/Z1qOEJDm/mAFCIvuZ7yGlMKNnf2wJ8rKQLRXDXYCV3wk3j6z+jC9DKahnIAzEgXut/7GnifIDlgvTop3CfhcvicGmcwRX0dCIfJ2P8Z37vRAVQ8zQM+YoH/tG4Co5sN5ZA==
Received: from BLAPR03CA0133.namprd03.prod.outlook.com (2603:10b6:208:32e::18)
 by CY8PR12MB7492.namprd12.prod.outlook.com (2603:10b6:930:93::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.29; Wed, 3 Jul
 2024 13:27:22 +0000
Received: from BL6PEPF0001AB57.namprd02.prod.outlook.com
 (2603:10b6:208:32e:cafe::44) by BLAPR03CA0133.outlook.office365.com
 (2603:10b6:208:32e::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.25 via Frontend
 Transport; Wed, 3 Jul 2024 13:27:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB57.mail.protection.outlook.com (10.167.241.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.18 via Frontend Transport; Wed, 3 Jul 2024 13:27:21 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 3 Jul 2024
 06:27:04 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 3 Jul 2024
 06:27:03 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 3 Jul 2024 06:27:03 -0700
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
Subject: Re: [PATCH 5.15 000/356] 5.15.162-rc1 review
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <947a524d-3968-4aca-9333-97866b0fcaea@rnnvmail203.nvidia.com>
Date: Wed, 3 Jul 2024 06:27:03 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB57:EE_|CY8PR12MB7492:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dd0cb78-8aea-46d5-aaf5-08dc9b63de60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?em83eW1kSDVyYXA4QThCTFprRzRIMi9haEVCYXZzUFQvMUV5UGMvQllNQ1NL?=
 =?utf-8?B?K0dpSlZsNktkT3JOMDlFd3BWOEY0NHk3bmUyb0ZVL2Vqd01VdmI4THI2VFRx?=
 =?utf-8?B?MHc2TXlUdXlkczErQ1kxdW0zMnZzd0xCMVpycWhhQ0daaWVEVkZUMUgzQ3c1?=
 =?utf-8?B?dmFyYkV5MXgxUHF3SHVtV3Zqb21BSDY3L0orcVoyOEp6Q2ZHbVZUOGI1VDZw?=
 =?utf-8?B?RmxtWENGMjJ2c2NXMW1ibEVEYmJIbExHZmZ1MGd2RVpZeGs2VHdHOTFGa3V2?=
 =?utf-8?B?YlRxYWh6dFlkdmN5bUlwRDArdnppYlpSdkJVOXZ2MXY0dnlTcmpad3JxbS8r?=
 =?utf-8?B?OThyY0QrRUFMNmtUREtNNGpuV0YxdEs1bjlWR3BXU2dBR0VNcXJQQm5qTCtv?=
 =?utf-8?B?VDJpdWhtcklsSi9UNkdnT2crek1zdFJUcnpPQWFVZWRrM3c0cm5NQmpKNXhD?=
 =?utf-8?B?SlFSdlJvc213NXJ6Zlo3cmVhbWJtYW82cXRFOWZyTDZMWEx5ZnJINkpJTFhV?=
 =?utf-8?B?YlBNdzFyWHFqdEpyNnArR2F4ZzRNMEg3NSt0RUpyWlFZVnpkZzVSaEc0N3pa?=
 =?utf-8?B?RUZXY3pwd2s1Z29uRnFmYW1aVHBSTXZyMEVDTXBBalNzZ1BIWllpclVQT08w?=
 =?utf-8?B?QVRvVVMrcGRGU2puOVBML0VNM1pBbFhHZDIxTGJXUHZBaldGYzFnNG4rR3hh?=
 =?utf-8?B?c2daRmhpSFNvN1lWTEd0dnBQUUIrNm5wS1hMYm5JZk91dmlENnFORDFsUG9o?=
 =?utf-8?B?ZlF3Uzh0UkZrZER3bUg5czhiRGR5YjFkRVVSbGdCR1B4dUhxRVUydUxKcERh?=
 =?utf-8?B?aXdsQjM2TEs4Z1ZiNzdPUk5EbERzZ012ZUdRSjVGTjk0dCtxbllXQWtPOTZz?=
 =?utf-8?B?L2QyZU1mdlNZQ1lTR2VmTkZua2hRcDB3SlpPYUUvOWlaYkorZ01DeGNTVlpP?=
 =?utf-8?B?dlM3aHA2eHVvYWJFV3pDQkFZdG9taDlkaW9BVWVZcHBUQTBLc3pXbEVYZzhk?=
 =?utf-8?B?ekNRKzc1eWQyeFR5S1dWNHVBYXp4WXhoRnk1U205RTIydDJBVkszRG1raFox?=
 =?utf-8?B?Y2hielZFY1Q3a3UyQTN3b3c2WnNpZ3dHU2J1V1krZmpLMEFFdmt4M3hyVytO?=
 =?utf-8?B?Sko0MFJYZzVReFFObDZHMG1ONEwvSDlNUENPNmxYNkZBQ3FodDVzNXI5bERp?=
 =?utf-8?B?NlRMNS9NV1EvZ01ST3Y1aVNuditoU2E5UXNMM1Blb1NINDBhNmFabklqNXRW?=
 =?utf-8?B?SWFjTWUrTTNYczFHMUdXdDNhVm1kUXZlZHdlWld6YkdsUmRIK2ZWZTU1WllV?=
 =?utf-8?B?cWF3WFc5eWJrZGNIZ2N3S2UwSE0xMkh5Vi83a2dhWWJKY3htVWQyeEY4N29i?=
 =?utf-8?B?Y2kyeXhIZzdEejFPbTNFcWNhalRZRmJaSDREWjc2MnVhb1g0ZEhUS1g3NjFD?=
 =?utf-8?B?bTg1SEo5MHBlamtMNWZ0MWpWWmlDMVhJWFlGa2lrZk1ta1l6UE13NzF6WitU?=
 =?utf-8?B?TXl1cWIzMWtFOEttOVZ1aTdDdVE5VE1hdzMxUHE0eVZlQmttc2dSd25jMjlK?=
 =?utf-8?B?bWNBT2NpOWxGczY5SU84Z1ZzQnhscTAwWS96MUJwSlhmTnAvMCtEVTZZVVAw?=
 =?utf-8?B?dmNLM3lrOTU3Vmhldmd1d3gvYVdEb0VJK3M4aHJVR21RalJLNDIzRnN5Z2hu?=
 =?utf-8?B?dlhOa3lOanBVdXpZSE5rZGhya0NmbTBwWmUvWktHczg5OWo4QWttNVhXMWNs?=
 =?utf-8?B?b0tGM2RkMWVIS05LWkdkdEJvRHJjc3owR09tbEhqbkhIRS8ycFBRK0kyZlI4?=
 =?utf-8?B?b2NySUhnbUlVdE5sVEZyNkdZSzUzelN3dEcxUnhlNU9HaVdEL1NLclcrRUEv?=
 =?utf-8?B?SVJFWFY4QUZqVjRITEFhVHpUUmFOOGJJUTF5SVYvczJoUnc4U0ZoVTRUYVRS?=
 =?utf-8?Q?3sDdUmy6DB7Monobhb8ODZv7uCcy+g0s?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2024 13:27:21.3306
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dd0cb78-8aea-46d5-aaf5-08dc9b63de60
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB57.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7492

On Wed, 03 Jul 2024 12:35:36 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.162 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Jul 2024 10:28:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.162-rc1.gz
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
    102 tests:	102 pass, 0 fail

Linux version:	5.15.162-rc1-gba1631e1a5cc
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
