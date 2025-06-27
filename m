Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2080.outbound.protection.outlook.com [40.107.93.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60F621D3CA
	for <patches@lists.linux.dev>; Fri, 27 Jun 2025 07:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751009968; cv=fail; b=d0p034Vj6iNgMj6xNAr0Y7THLqfRRQbC9xgdm0/WmU1iZTXDn0bGOs875DplSHWlfU4MyN9zUcpxn3qCjs9ZVEok32eWD6nXKNY22llYvMeyFNzQEP5MakXvcIw0OMrSIljQ/RNb5jV0qJd95rMqr9NQTGtKQVRQ2lmjO6gz00c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751009968; c=relaxed/simple;
	bh=MnLpXZJJTeC5HvYAiuZanNhdmzOajEIOTShdYX4E2Q0=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=BeysHZe/Dfkf8sPcnwUyBw9znJskaRwHma8cTAYzH6UuppaxpN1sujQgUtXZghQrTWVnVn3ScTIN8q26s7ttNoVoiAm35io+D4v9frN9bcmJWnwd9LmvFtibmDGhyyDCde8UepzWuWXA6YA/jyb6SJvmrWo5/mwDA/gF3IzBVEY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VPsU048T; arc=fail smtp.client-ip=40.107.93.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VPsU048T"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rSTkOS0ctXrASVhvt4GCL5sG1vDkezUQQXmc9Siacf5vcHxQNnapOTPyTE2cKItAnvB/7SdFw0F2JWEF1VjbRUJhAPsZ/7OoLyRx8TnUG7Py1swSQw2GWN9rmrZenYHnAAuzzNw2GFXp1lBJO8jpKeP/G5x4S/9QUCMvUcxMxSdm3QQHWHrOpoY/n/zezlQWV2QKxvXZP9aDK68jqAu412MF3x7Uw0LLHG1d9Dd2L4WzLmSeWbQvWRdrFHj6w/cKSBW36qYmZ3U1/oLlS9iqIIOOpBe1nBRoYtan2NjAUGTZGIiTVDpg3S8NDtE66gKMS53stT+rz8AAXkeC+A+PWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XsHjoU7/xrGPUcQINGEXMTs3tSYKTUB9tIMgYSymhik=;
 b=WiQe4IAM0+6ebc+LfVq1dC69pLujfx7jvBIHMpCckwJ1vNY4mbiBhUPQvZ+mKmgUEBqO2K9PmFX1WreA02g2Xzio0tc/zmlFDn9KpU3sE0tAMGn6Xw5fRUmkBejbr9I65PuJq9Zea68/wdnrHD5PL3LvgFEHUCpkkAtsza39mwNkey/OnMTrCBpzH5hII68e+NMcmAp+aM5iY7hTDl6i6n32EGd84yUrACE3QBazbgip+Iz0dE12rgLbqm1oBe/pK5T2+2MagUTNJ5HmhmKbMinsCVpI/JSeZr9IWD7yyp4drH7RTbKTSe+syJfrUK+ESzLIUQTZyiImdNCUQsWDtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XsHjoU7/xrGPUcQINGEXMTs3tSYKTUB9tIMgYSymhik=;
 b=VPsU048TP1NuCzXZADvKxfC/TEFVYDwNSmspmySvEVcmmBSDNxO2B9rryw7OOVvSEo+2VVfsAnQDG69n+qsV7NQHt8fg9Mz1+tVnf947JM5Wvt5ztcKakl8sAoGAXBqRSH4JLltdNNglGO7tGpl+5Z/MTROPDFcM/18qyT39HWoDDvuK5RAbO0IaPjDQytcz53Y9NitelHe5f1s2X1Qpg4M4/7TItBjMU/vLjh7vHAhePiyw/OtLDkzvWLlOgNqed/hEX35EnBPUWRHG00FR3rWMRdve7FtnBBLwkEz+yq4qTnFHbxWtmPeAlvgOXwfwYMz5lasFSQeT6e7vk6JcwA==
Received: from MN0P223CA0020.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:52b::11)
 by MN0PR12MB5785.namprd12.prod.outlook.com (2603:10b6:208:374::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Fri, 27 Jun
 2025 07:39:23 +0000
Received: from MN1PEPF0000ECDA.namprd02.prod.outlook.com
 (2603:10b6:208:52b:cafe::e7) by MN0P223CA0020.outlook.office365.com
 (2603:10b6:208:52b::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.20 via Frontend Transport; Fri,
 27 Jun 2025 07:39:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000ECDA.mail.protection.outlook.com (10.167.242.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8880.14 via Frontend Transport; Fri, 27 Jun 2025 07:39:23 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 27 Jun
 2025 00:39:08 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 27 Jun
 2025 00:39:07 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 27 Jun 2025 00:39:07 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.15 000/589] 6.15.4-rc3 review
In-Reply-To: <20250626105243.160967269@linuxfoundation.org>
References: <20250626105243.160967269@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <6ab4bdea-8f6a-405d-8c34-fba225220b55@rnnvmail204.nvidia.com>
Date: Fri, 27 Jun 2025 00:39:07 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDA:EE_|MN0PR12MB5785:EE_
X-MS-Office365-Filtering-Correlation-Id: 7890453f-3e3d-4638-cc08-08ddb54dbc9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q3N0VVlPTWRLZVk3b0xLVy9XdllWVmU3Vk1YNEdzekJzVStETmszZVA3Mmp2?=
 =?utf-8?B?U2lPaFphNTlTQlplZ2VIZklRNUZYWGJrNFRnSVNyMTFZTTJpbG8xTjduSk9m?=
 =?utf-8?B?alJSZVpUT2p0eEluRXE3dDkvTklSWllZckU0amhqcVVxUDBMb2xnL2NOYTNy?=
 =?utf-8?B?WUZUUHIwdEtReHl0dWlKMTIvQi94cHpEK3UzRTlsOE04QjUrbW1qOFZXQTNB?=
 =?utf-8?B?VkFjbkRsQzh1OUY3NGFMWW16RzBYbzVJclkvY0oyOWYvNHRsRUtHMk01WXRK?=
 =?utf-8?B?L1Y1c2hCb2xGeXdVN0VKSDlvcXZ3TldYL3AwMlA4ZzJHVmVPZVNHMG5uU3d6?=
 =?utf-8?B?RGdIaVpzSFBmRmM0ZUgxYVUwZkxLZ0pqMFM2S1Fvd3p1b29sa21LQnFoT0J5?=
 =?utf-8?B?RE1LdjFoNnNxT1ZpRHhnL1VTUmMwK0Fka202ZXhSLzJ1NTNvUDhTYjl0MXVR?=
 =?utf-8?B?bmU2TEFBQ3ozbG8vR0FSRUNVRHd1VE42eHFTOW9KbmxoVFpJZUdwem12ODJt?=
 =?utf-8?B?aDg3dWIySGd5SWMreGUwNFBmQUxyNi9QYjMyM3N2NjFpZldEM1AxTjZVQnFr?=
 =?utf-8?B?WFVEL2RHbWZNSlRpa0NrVmZpYTJ4ei9OUTloWHZLeXZpM2RBZ3BqMTB6aFJE?=
 =?utf-8?B?ZTVuMEFiWlNKR2x1cHdRVzU5NGhBd25uSFY1QjZkS0ljWmh0bzV1bGF5dWo3?=
 =?utf-8?B?MTV5L1NIZWlKOGlNZ0NFZ1Y0NkFaT2JVQjBjRDNBaXV5eEVhQ002ZlNHMW44?=
 =?utf-8?B?alZCZ3lLSlZ1NnQ2NVpaY2VXQ20wNmgvYWRGQW9VVGJBblU3cGxIalJiWVc5?=
 =?utf-8?B?K0xQbTZaWGxYeXFvaE1OZmRZR3hqQ2dSR3pUbFJ1cUVyTkZhRUZNeFVuY1M1?=
 =?utf-8?B?VURVSkplcG1Nd3hBd3FIRnVEZnkrWWFuSVM2aXd0T3hDU292QzVvRzRrN2sr?=
 =?utf-8?B?QXJGRzVrRDFHemQvODNjOG8vd1RBeUErOXJyTG1kYkF5cGpCa1FlUFlqdEdu?=
 =?utf-8?B?OHJmVzFPZmYyUWpmcjdhbzd3cU5HU0FnbFVpU2JzK2JYaHlhQW44YlNOYzI4?=
 =?utf-8?B?dDZZWFNFSnlGY0dpK3RDU3RmYkFOdnBUdFFyZCtHMmV6TmRjNnZ2d2ZrSDJT?=
 =?utf-8?B?bFpCL2pTZzZQMzlzZWZoZ2MvY2g2REh4NXFZOSs3MUFoS1ZvM2Z6R1pveFhW?=
 =?utf-8?B?MUdPL3FrcU94RDMzUlcrcnRBdVgxRDQvVVRGWEdneU1FaFFwR2hYTzZmQk91?=
 =?utf-8?B?Qi9JeWIza1d2VEtkUnhOTlZuc01vRHcwcFUwUHNiR3pOQnhDenlMRHZVaGtj?=
 =?utf-8?B?ekcrb3hiY094QmtxQ3l1aE5sTHNRY29wMU0vVjlHQlR1VjJlZUhDYnhtMVR5?=
 =?utf-8?B?SUpRamF3WmNIK1hmeUwzN1cxQU1tZUpZQWthNW83aktIdzA2TWxHdm5aZVNr?=
 =?utf-8?B?eVdwRW8rSFFWNzhQRWZ0ek5PMmU4NDFXWE1Xd0VDZ1I2RFVvM1ZYY3M1SWVz?=
 =?utf-8?B?dE9pQUhvSnlrdzBndU9iVFVFRXIwbTRaV0VvblduUU5HU3ZYUW1EVGxGRTFH?=
 =?utf-8?B?WXFHUXNZK3VVZFpPbE9FbW0xVDVzajRIVmVrK3kvQUVWZWRPcFpBN2hYK0xs?=
 =?utf-8?B?Y3laWjZQeURTN1Q5cHg4eWVhaGtkUllsdklhY28rU0xuRWhvVXlDd3phOWJP?=
 =?utf-8?B?THhBS0Z5bGVIcDdqcmUxbHFwVk9ha0JHSG95RG8xM1JPY05RSkwwUTZlS3Nr?=
 =?utf-8?B?bUVuNFhzT3JiZWdjQytGMWptS01FVE9jSnVSZjdCNnNCOU5TVkFzdlV1V3Rh?=
 =?utf-8?B?TmFjeUtub2ZZazdzVlZBRC92emYwdEp1T2RtWkxrb1c4TkZVU1FMUkc4QU1v?=
 =?utf-8?B?R3VMcmZkQnh2YkFOb29DWUlnamx4Q3diczhMWXNOYTZvdHZ1ZFQzaVhxR1pY?=
 =?utf-8?B?bHVHZjZZYXUvcTRxNDduZ3RIWFFsd1A4Z1prWjdaZFZRZXErSnVFVlhjVk9j?=
 =?utf-8?B?ajBHQUFwSjZmM0dBNStlVll5WUdiKzkyclNNOVFjRDVzMjVlaHNBb1NydVlO?=
 =?utf-8?B?aFQ5dFV0azFwTU9hNlBTOVdSZkV2K3d1T0REdz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 07:39:23.6023
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7890453f-3e3d-4638-cc08-08ddb54dbc9c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5785

On Thu, 26 Jun 2025 11:55:53 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.4 release.
> There are 589 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 28 Jun 2025 10:51:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.4-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.15.4-rc3-gd93bc5feded1
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
