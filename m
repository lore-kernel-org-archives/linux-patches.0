Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B132DE702
	for <patches@lists.linux.dev>; Wed, 23 Jul 2025 11:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753270559; cv=fail; b=mMehJuISlXCmfHIqxUAMNGGVNT+38PJoN4nbFkJltZhuI/y+s3YfqB2qZffHvzWSoI+sKdoW/zoUp8DToH6H30mKVh6Zs9oZXGwwPP09Dr3/vK6df4lCZttj1lkkpKeaOarU6rliTv54JhmLdBwzb/pUDs8tr9vMTslI1eSch7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753270559; c=relaxed/simple;
	bh=LN+zddUuOruDJfCrOZP3Gk2B0qpzFryY6PtfY6ZXCi0=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=DKc9Mf2ryTkzB8wKJWgPGTy9ln5Jrey9rmk5AgCpoksQBgpXn3W47JJ2bFT/P0UoJxq7ruxEVImcgSspfD8GjGhxQvQH0Gm+LSjq39hyEMghxswLrQebi2V2HEpQWM1NgALYhnXAb/OEnrOp6hQ5vmGoZGr4uPDDYTpzs+njvtU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=exLbzBBm; arc=fail smtp.client-ip=40.107.94.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="exLbzBBm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xn2FSRNU5MGtKrJrK1HUjKIduGJVrnK90h/Qkw8eHgx7tCXa1fsMryg94u8m3+i/UJhd5yQjJvgZB6VRsbST8N05ohPqAf1wZXQEf14HHodA3GW9h06WIBv9+ryjmMnX0oD0AhBu3um2KOSafVibxCRMpkd0obO5YWtu9DKZqKbtBaAkgAsobYRbK3eq6PGSoT1WULlr52nX+H2I5TQC0tVlThsVArNskptt+u94wtECLwwFucCB9bl6ErencqjNLXW9SiqUAz70eFwmzBWcq/6l0G56OEt6Q9reRuYo//tu3enrpeuBA3itd+7WsI7Phvuwm8I/+PXvARdZHLg0iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vNzLLZcv+AKYe9VKW5ssewJ5XWv/5UTv4YAwOLD1DP4=;
 b=HvAS5asQ4wVqCGbhmfApCeefru9zku2P+uuAHKOILcqSScnKbN2+VJjE6HQXH6HH6Q8GbySFo3TvHgDCoL7fDQotX1fpZX9TXp+HKdAhRhjof7W1GzkQC4vn5PCYjOeGNxS65jB3H6EFJGYym0bCCJ/vKdrNkp5ndZVLi9Pu/G6bBdXwD9Jgpph04ecy4JvNLwY4R0I/XPxX0nrt2WZtrfgHya1gS0WfM8qDmMmgQZ5B7x1k2JuWk9Sf/UsAYZPtiRKaadpH3Z8BygCb1J6XcRFMfdES3LqKaCtnUtqWU1JQFpycbt+WuIFjaCcVJtZbLJBW2ZgDvHpFSKRFVKf0Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vNzLLZcv+AKYe9VKW5ssewJ5XWv/5UTv4YAwOLD1DP4=;
 b=exLbzBBmDMyJlEANkWJinx1exOqIje+EEGYssLdq3ZJsd+ZxA8fvp0T79Y9pm8xcuvnvNlkDTbaQztDrAyXAxCFaB74Eq+gtf6OLbddAlj8AIaLelQVj2sWIZhvE7h2H6fz0WlobYsa5hzWvdIZnSWfJIVhAfVVvkqhlaT+IlwLFQ7SpwokGxDKekL+q/7yzyTOVsWW9h2wVBeTylPhWtMEZM8t3QyuDOl3yOmvU42r9BpOARY2IAGI1ROez3GyU3WNf+OBFx6quiqNNogAOev6M/zQasQIeBUTmnKzyNTWcoOztegnvo4FJR1XzS+gTh5i+8lENbvd6AeKOWWxeRQ==
Received: from BN9PR03CA0212.namprd03.prod.outlook.com (2603:10b6:408:f8::7)
 by MW4PR12MB7262.namprd12.prod.outlook.com (2603:10b6:303:228::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Wed, 23 Jul
 2025 11:35:53 +0000
Received: from BN1PEPF00005FFE.namprd05.prod.outlook.com
 (2603:10b6:408:f8:cafe::ed) by BN9PR03CA0212.outlook.office365.com
 (2603:10b6:408:f8::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.21 via Frontend Transport; Wed,
 23 Jul 2025 11:35:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN1PEPF00005FFE.mail.protection.outlook.com (10.167.243.230) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8964.20 via Frontend Transport; Wed, 23 Jul 2025 11:35:52 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 23 Jul
 2025 04:34:48 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 23 Jul 2025 04:34:48 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 23 Jul 2025 04:34:48 -0700
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
Subject: Re: [PATCH 6.6 000/111] 6.6.100-rc1 review
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <83d9fc7a-197a-4e8f-872a-f27fb0cc6d2d@drhqmail202.nvidia.com>
Date: Wed, 23 Jul 2025 04:34:48 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00005FFE:EE_|MW4PR12MB7262:EE_
X-MS-Office365-Filtering-Correlation-Id: f6ea9b3e-58ba-4fda-cd60-08ddc9dd1454
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VjJlTzk4U0xmNnBDSzYyRVFzSWdoMEFiekgySXdtQXRzZjBhUUhIOEhmVTFi?=
 =?utf-8?B?VHJYUGpCc01QQlFlT2lrUWhwb3RyYS8yQ1k2d2U0c3ZhWjk4MU9WNndBUXlz?=
 =?utf-8?B?VWxmSGxjSVNmY3BDdDB6UUNKZXJ5YkNBcVROUU5PcVd2cjBkQnZVRW9rb0Fz?=
 =?utf-8?B?WE1VeW83T2ZVMWdUWWlBNjFDVkkxaUV3eWVYamFIc2pITHdEWjRLVjNmRmxx?=
 =?utf-8?B?K3Q4NlhsNFN6S0hSTUR3OWJiUHc4Z3JNMXYyMEM1M0dSNXpSY1huMU9sbVNK?=
 =?utf-8?B?RUxxTW1LL1pmeXdGZXhIeUZJbW11VDRFTzZXYzBsRDVBdjZsVU1NMkFmdWNi?=
 =?utf-8?B?ZzdvUkVVMCtxY2xRNXBnUEh2Q1g5QlJGckhuVllrbmxnN0ZOeGZCQWsxSWpV?=
 =?utf-8?B?VjFUT1dSNkU3dG1yRlVPTzVBdmJIMFV4ZGxkdFNtVGxLN2dCVmR4cCtGenBq?=
 =?utf-8?B?VUwyQlZBSFBla0cvRXJ0dEx2M2Q4U0FYVnRNb3lCcnY4SDloWHR1V0greTZo?=
 =?utf-8?B?T1FSOStjbTRITC90cW5mMnhWbWJkbUlGUUJ0aVQyRVdrYTR5S3BkMDRxUnd6?=
 =?utf-8?B?WVplbjNpNmlzTy9mcUg4cUpyeW5KSEN2RFJEUkF5UCtETmxtWFp1Y0g2QlZn?=
 =?utf-8?B?VjI3c0J0eXR5aUd2cmRUMGQzbnVVdE5XOFRBTnRlT0xyajlNY2xXNGVzcGg3?=
 =?utf-8?B?MVEybHBSL2V1TlRWRk9tQi9wSkFlK2V6OUZnSnhhS3VndHFoYkg2UG4wN0I3?=
 =?utf-8?B?VGMxVktXeGdUc3N3eUhpWjJpemdIYTE4L3h3bnhrTk92YUVpM2srT1Y0ZDRa?=
 =?utf-8?B?cjJjTmpyaGpzSHBmNFZNd29KWWZKd3NiUFlJbG5lcmJQdU15dGNkSWY4Tk5w?=
 =?utf-8?B?empiVnJvRnVNK2hTRFdtMlpsbjEyWlJVOHE0NTJabXlKc1NhbSsyVWhNSkFI?=
 =?utf-8?B?dTIwbXRHRmVvdDNpUTVZZTZUQnNJZ25HalhBVUN5YVdUTzd3dWpjS2owSFU2?=
 =?utf-8?B?NEppQkFEaWtFaGNRdTJzSmJBeVdrSUhKUzg4K3kyQ0FGZzFSUVFwZUhIQ2lH?=
 =?utf-8?B?TjFqSjlMQml0aGd5TUUvK2EydmwrdExic2FsOVdFU3pBS0JxTjJOL2h6TnZJ?=
 =?utf-8?B?dFE3V1paZG15ZStrczRwdWNwR1VWaTVPQi9QdEVLRzh4WUR0eEhuOWNrSWFa?=
 =?utf-8?B?NjdsaW9yTHp6NUQ3Y0ltN0diZ1B1S2R0RVZtK0xkNkhhcHRSTWhHc2lkM0Fp?=
 =?utf-8?B?QWM3QnF0NmhjeElCSkFDQk5jV2FIUm5IQjkvSkVQN0MzMUZlNjUyV3lZMEtI?=
 =?utf-8?B?ZUxYdkJTNFdvN0h5K2xvbElHNTI3ZktDOFduRGdwd0U5TE5nMTFhd2V5NUpi?=
 =?utf-8?B?SnBGY0RuRGRlYWpWcVFvTHdGZjhhcWxHckViNmtDUlozSGVmdFpTdmpGYk1I?=
 =?utf-8?B?S3c3MXhtZEFkRE1jLzhuUFVDUFltVEFwMGdBOFZXTmxhc3JJbWNjR0FSbE1a?=
 =?utf-8?B?RjBBRWpBTTN4dVJyWTFWMHNCUE9hcU5WR0greW1jYmFINUpxQnNJOW9tc0xN?=
 =?utf-8?B?cEtlYnZGSE1ZaFl4MlNYd0RjaEpzUjk1dDZLWTZTT0IveVc4cU5JRUg0UVps?=
 =?utf-8?B?NHpKNVRva2dHV1hMai9JSURmaVoybk84YUdYZndXZEtGaW1vU1gyVHRtcGI0?=
 =?utf-8?B?V1JuUkpzSGMvYXR1d3ZOdVczUC8vVmFrRUpZem1ONk92aXQxdmhIdEVRdXY2?=
 =?utf-8?B?QXRVSTFzelpzVGlXWGVBQk5qZ0g5OGpNeTdXYmlYckZJcDkvaHZZWit0MDZH?=
 =?utf-8?B?UDllb3AwdFp6WmozNGJmTUMwL1FXVjN4VkhuMG52eXRBeVd0eDFaR1I0Smdw?=
 =?utf-8?B?eDR5dUhkYllKY1VLaVQ3T04yaC9yR3pHZys4YlY2b2YrQ29nSEloQXV1d052?=
 =?utf-8?B?NCtsZDl6TWFGV0x6QXBuR1RNSkRlOThjcTFMSTZGZGU2RjdwckpodXlYSjMw?=
 =?utf-8?B?ME1GM0J4Q0tINUFOZU9VajNJMHdWdGhOSHh4MjRVTWJLYnZYRUR2aEY4eDBk?=
 =?utf-8?B?L2RWL3YveEhBVkY2NXdFSURScnlFcm12OUdGdz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 11:35:52.0715
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6ea9b3e-58ba-4fda-cd60-08ddc9dd1454
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00005FFE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7262

On Tue, 22 Jul 2025 15:43:35 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.100 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 24 Jul 2025 13:43:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.100-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.6.100-rc1-gb00c1c600f8c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
