Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2061.outbound.protection.outlook.com [40.107.100.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C904719F410
	for <patches@lists.linux.dev>; Tue,  3 Sep 2024 08:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725353156; cv=fail; b=B0UISUVHLQJzUmdpA06OM3gQ+hYWDoumEFl6Uj1wabaojQayoguysGQkchFmY5k9BKNnrrO+Yc4Vhc/G+l0NyNy7bP2eOH7u1qvPVYcizb7gTI/ciepPyZbgLAGoAG+QJSlw8BYKm3/uc8w57TOR1LlvQvwMED1lMwefEuYKfow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725353156; c=relaxed/simple;
	bh=0NZDhOCjp0UTHoGl6e5WsJ0rziIc9AGDo1MmWQYXEkA=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=LKf7g2lcTpv35ka/ribuaM6EeHbiIUhB7lHgm7N+mqd10lLdqS46el1u1xWkPdsriWBMmUramFJGh8XSq3CFXQ4FhVSgJsCjWiM6BF/UHZWQBsfOeZWCLTaOInAocceq8QQoKZ3vzYWtXN/GZ4LdjFRvczW8HjnYxbJm3b13CYo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JDSQ5Msg; arc=fail smtp.client-ip=40.107.100.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JDSQ5Msg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=szOAo+1qzvEKszOwgmDMn5Q8wiscu6gfQRBViBfKHGZth70RbO4q2c/rFb0z+xEmEssP8ttkl0+qh8TsoROOGhEVW5YI/gCiJdmaMmWVKvYzn3jriBckAg6GdNknd2PIot/cr2YbC2+qjAUeWFz30o/FmOFC/z3T1SWX7xnEmFWpTvRpmnLa0jkIZrc48uqcolFh44HjV8PMmhBuzgxjKMGz7/NjIczf4WfPJ1y15lYuXOPqSr1BZr8d1l5UB+wv1aUC7FWxE5vZfGxh8pP4P/w93HmJl6us9Dskd0Z+6r1zCdSpK4WziuC8hhd4OkUqt917gnJlkkr27GwAtrhEYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BYeyUv9zfkfq9kEHpsrdE1peGe/RwVpPFhUtdUmxd2Q=;
 b=LwzQowdVPSQrzLdHqKkeNOL8Ni+S0N+S6fbQkFSqGxbIYCAQ5txuhVWoORRQbMgcCcJDpdu7P2fMRFIth0KGluvut2Lfm76LjTu8q5C1KGuGAhGaRhT2BMrME7D1ZeL7YVDHgloWT2rcGx8qrwoSIYH83wLF0A6+s8+0QnJ2ubpqQOa+mBm3eJKdEH2v3i2z5CZsLq8lw00zPnZNrr6h/V2wfQTrwmIYfPt/I9Xx+fHqGSOf1gvxwd1YTrIlOo1EhTG/MmNj6qX9EZAhAbH7HPukbdVmMCih5/1ou7PTnBh0DZY6ep+54pzztxvwVFEt7fOqrG30SOm+2u3RSNhIKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BYeyUv9zfkfq9kEHpsrdE1peGe/RwVpPFhUtdUmxd2Q=;
 b=JDSQ5Msg8iT8O75XC2b8Hpfzssuz9NA0A/r2n/laePe4yIHhJuykA3jVmtH8iIW4udZKtKwa8TpZZMhp+km0V5qqcgHJQ+csWtaqXy3n3oMxIsHc/YE051rFWakhglziYv6T3Ft/rmstaR66BppyGxjdjfC/Fol1I7DDsQokh7MnJZCfcamsuHYLB/xjdCaXGIRxHi7K7cc39mcSV5xTfgxJjKAP49HWjWLjLByHY2s6gqzz0O/R+h2KgzM8yjRRAT8o0OEEM3lG81PsjycOQe9d37YpO4ChWh6jyv7EPPezQkD/GTI4d/5JHXgVD1YfqMwOr/MmH9xykLy1DQ3ZHA==
Received: from SA1PR03CA0018.namprd03.prod.outlook.com (2603:10b6:806:2d3::29)
 by SN7PR12MB6910.namprd12.prod.outlook.com (2603:10b6:806:262::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Tue, 3 Sep
 2024 08:45:48 +0000
Received: from SN1PEPF000397B1.namprd05.prod.outlook.com
 (2603:10b6:806:2d3:cafe::97) by SA1PR03CA0018.outlook.office365.com
 (2603:10b6:806:2d3::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.26 via Frontend
 Transport; Tue, 3 Sep 2024 08:45:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF000397B1.mail.protection.outlook.com (10.167.248.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Tue, 3 Sep 2024 08:45:47 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 3 Sep 2024
 01:45:31 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 3 Sep 2024
 01:45:30 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 3 Sep 2024 01:45:30 -0700
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
Subject: Re: [PATCH 6.6 00/93] 6.6.49-rc1 review
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <f95bd711-c21d-4575-a2db-bf1ec019962d@rnnvmail204.nvidia.com>
Date: Tue, 3 Sep 2024 01:45:30 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B1:EE_|SN7PR12MB6910:EE_
X-MS-Office365-Filtering-Correlation-Id: 23c6fe73-b88c-454c-ff09-08dccbf4cebf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NzV5N3F6WmRMcWx1aVEydlBIQzlXOThraThBNlBQTGNXc3NjV3U3RG84b0l2?=
 =?utf-8?B?MlRkbzNRSGFDVkZVZXdUOUpTNlo1L01PNk9KeFFqSUV3U1lMVUlTQW5Dbmsr?=
 =?utf-8?B?YlJoeFdLakRKMmtZd01BUGRTVWdFeDF4S0ZRVkZPQzh6UW9jNy9UQ0dQRWpZ?=
 =?utf-8?B?cXNCZEZEY1dwZ1JnaWU3OTk4V1VCdmRTYW9RWE4xUE5jems4VFBJbEkzQk1y?=
 =?utf-8?B?UDRrYk85SkZXVVcra0YrWnY2ZE1GVmxEWlgrbThHaW9GRzRvanI0Rm5EMlNC?=
 =?utf-8?B?UUppU3pyVW1jaHNoNWpKRFc5Q2ZwN3RHVDk0a2RETkIyMTdjVEhpcnpWNU9S?=
 =?utf-8?B?QXNFS2F0dGNuSGQzYlJWZW83VWRRZnZ1NjcwdlRaam9HeE1GVE9teTEwMmJC?=
 =?utf-8?B?dkNsS0pnUUFPYzhyL1U0R05HNFI0NFdROHB4TFI5SzA1bXp6allOMlVFa2Ry?=
 =?utf-8?B?cXR3RXpLU3JOMzRqR2xjdGltaGg2ckFkNy9jUW1RdFVwU1VJQlVBT3pGVVc1?=
 =?utf-8?B?ZnBkS3JlZHhBOHltQzVkR3pDcE5FWkx2ZEJYTnY5eXFhSDVOZW9iRmJIZEZC?=
 =?utf-8?B?eW83L3hKLys2cko3QzlhbjRvZS9CNUM3dGlmWVYxaW0xYWZmYVgyNC9tVmhw?=
 =?utf-8?B?bXZrb29MQjAxY043b3prL21jK29nbE5TTVE2VTJPdnpjV211NWtoRTlzbmtY?=
 =?utf-8?B?OGl3YXFGQXk1VDBFT1d6c2tKQVowZ1ZZM0pWdHRCZExOWXBqVDlCbTBaaU5K?=
 =?utf-8?B?TXduWDY5NU1HeUJ3MVlPOGliOXVQWk9nMlV1ZFlCWWtLdDd6cUFQMWRkSFZR?=
 =?utf-8?B?eVhpL2J6QTRXWG9IL0F3SFppU1pPRTBGSXZldHlZWThwSVZVR2pXekxPNW5T?=
 =?utf-8?B?azFYSFFrblZmczFUODhCUFE3eGVzL3pxNVR6a245U1VqaytlWXJkSGttbEpy?=
 =?utf-8?B?anVSdlhPdUduQkUxNnZpcTJ4VmxKbURwaTR0cmU5T3dmb2laNUk4TUh3Y1Bn?=
 =?utf-8?B?QkZaaVFoczVwZ2FYNjR2NTYzZ0ZObDNlMDRkUWFydCs0WjQ4Z0FJWW04Qmhu?=
 =?utf-8?B?dDkrKzhuK0RKbkYrU0lJTEZ1SG12TWh6cFpCd3cvWWlwajRoa1IvZ1Q1UW9K?=
 =?utf-8?B?Yy9rRVZzRENzbnVrdmZ5MmZiWW5IOGFJN3l0NVVkNkovdjMxQnNzcU40ZGVL?=
 =?utf-8?B?bkNQQzRvc1VtcE93MzBWd2NURENPT2JvNjVwUXNaSVpVbWNTUUFRdVpLWUZz?=
 =?utf-8?B?M1ZDNHErVmVMK2J0NWUwYXJHSWo3OGdhaE1QWXBIeGpVUG0waXRpTTl5RkR1?=
 =?utf-8?B?U1FWT1MzYXplSEVyamh6WVg3RDN6OGY5MENOUHVNLzhoazlGTW4zczNRelBO?=
 =?utf-8?B?d1RNczNyd0ZpcjFjSXdNOFZkaENlTFBMcmdiMVg3VE1jUUxMelN4TjRvOVlU?=
 =?utf-8?B?dFFxQlQ5UGxwMzN0N2FiU2ZCMXBXWjBpZzRLY2dUTkpaK1g2TlVUTHRYKzN0?=
 =?utf-8?B?SHNvRi8renpYNWJOK1BxbCs0Y0ZEK2RPRERtMXhMOGdXSjc5QllsVmYzekJ2?=
 =?utf-8?B?dXpCZDdBMndpZDBJQUtXMmdzMWxVZ1NBN0VuMFVVcU5pMDJPdFdLQ3RIMG5H?=
 =?utf-8?B?dDVlNTI5a2k0ZWVjQXltR1ZzSDhOM1JaM0x4SW1QbXJlSGR3b1NNTFY3dUt1?=
 =?utf-8?B?dmY5UUFkS01rSkNxdVVac2NvT2RGb2pUUzZ4WVJYWHFMb2hka0NZbm1XQ1Z4?=
 =?utf-8?B?eVdscWtKQy9mWDdMQm40RU5ib0lkQ1A3UFlzOVYwc1BRZlFXQ2phRnRoVXZn?=
 =?utf-8?B?ZWhrMDVJczU2TDNhSWo0Sndzd0dqU2Ixdkc4S2VNc1RUNW9kSnRnaDhWYzBj?=
 =?utf-8?B?NkluNGEvWGQxSUxRNG5IckljWmxrcENuUEZqWjUrNzBQYytVdmFxbHpSYWc4?=
 =?utf-8?Q?lJuwtOBVTtZtFrSYodsZaxWSVBvtV96t?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 08:45:47.9353
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 23c6fe73-b88c-454c-ff09-08dccbf4cebf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6910

On Sun, 01 Sep 2024 18:15:47 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.49 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.49-rc1.gz
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
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.6.49-rc1-g8723d70ba720
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
