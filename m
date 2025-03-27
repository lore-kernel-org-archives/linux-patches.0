Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD3E218AB4
	for <patches@lists.linux.dev>; Thu, 27 Mar 2025 14:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743085993; cv=fail; b=imTRPwkCvrdPeHGuznmLAfoydt5yFUiqjxXOqK4l4fWP4lxcQuVjE22zuM4xGcOVNok2v0WHEO+guW9+hIzEhhMMtphcEHfRuhCjgIE7BW7tUfvJ9msxa5Fa5AsIyQ7Xq8aJ6e4J4GTleBxpbHlOQ1By81xMxouXq7x0FwiJ2xE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743085993; c=relaxed/simple;
	bh=TgHau44HkalLsXDfy8Zhs/AmI68+1s2/WRenOx5O1ew=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=KPw+y8UgVW99xKKUb+d0U/5GmtyCPS6OVuGChi6bEXSb4RJpc6AnKFJ1oNNlzFZVfhf9nXKljEhcvVkZAiijgZ/m0ZOjbIQUWT59Z1fSCc+RSV2Xw4FAPWq34vZYkNGYOQtwsud/bWtlWwVuYAM6H1LNAzn/6kOzkQiqIcbHbyg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=f0ECJSzM; arc=fail smtp.client-ip=40.107.244.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="f0ECJSzM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nfPOFSqMLdVfLeMoY6D6xUc3vIzdLCORMT9YSEJwLybUBPeMgasrfoLpm6cqPe21cy5BSEd2yBs1PK/fSHf+e5j4s+s8VIZV0sIm6h+J30x3o48KOKJdzXpaKo35sg9vY498O8qdo3H3LaJVFwP615MkMt9p0yH/VsTAIp9VsklSEm2i+S8cO/ekgJD1QwHBN9jUZsXRkrEhj/+znuF+0VCTEUzHYELbwyhPpISH517QkDUBFAQhlHHFOFLD/hQadvEmESLH9pCinDjqQUiuFrWPEcP4XYxKoLzyukj9RiazRmv1XDbHKFzAUJ5/6MnFpB7exwo0C7fXmRuIpx5DBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ifClPF5g29Ea2EutpxDK4iW3O5sSHILXeLj7H0FM0/A=;
 b=Lib/VchTXM04KmddbMCJGhfsJ7jG5K+DmQKTDLBHDOC2CGioyueYME3K535bLsnFErTqNpBXn71xZJjDlOe4z+sUA9VaMA7WtJbHSd/cEmughs3fmvmNhcn9wS0vxd7t88RjuU731ua2lD4fTuV5faGPtnE9sVDFLHcHHm1WgZQbsvJQ7+2xLouSX0r6L55L+DNW/HKvv2aJOzF6RxSMklnBubYXf4jW3nyNUrm1JztTJ/niXAyeiwjJSXB5Hxje6CcEqD7EQ5Rfq9hKM/xHhHqkR++sSbSDN3nuI84ySXgOynP9lBAHqTZiLSEcjd1r6+6fn2YpYFNaP8/CzDzh9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ifClPF5g29Ea2EutpxDK4iW3O5sSHILXeLj7H0FM0/A=;
 b=f0ECJSzMqigSML2TtlX7GDLEpt1wqssVlzVia7n9qXb5IgJXLFOHF++I3x0uw2wkBQ/Isw/A9OMIGjaompCSEeDvrkE2AH8NQlxTNpQ/iKx0PFgNmbiCQYnLveK4zJXxTf4mzFNByB0lJVxwp7jhfgQvWURVsXUMgxOi9pj6KTD9CmeAC8KQoY8cY91Zv83RsMo1RipeY7hX6UA5DT7s9vgmU6wFIOVPJc7wz8YaRVaK0CQGxpPIcJgpYAUhkRQYTDCWLk1UoaJpGgavnPw7jcIMFu0b2j/6G7LyHABYOBRFzvuDhgI0CthsjGWu4FRp+MiS28qyXqOyvNTacn6XRg==
Received: from SJ0PR05CA0064.namprd05.prod.outlook.com (2603:10b6:a03:332::9)
 by PH0PR12MB8774.namprd12.prod.outlook.com (2603:10b6:510:28e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Thu, 27 Mar
 2025 14:33:08 +0000
Received: from MWH0EPF000A6730.namprd04.prod.outlook.com
 (2603:10b6:a03:332:cafe::8b) by SJ0PR05CA0064.outlook.office365.com
 (2603:10b6:a03:332::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.43 via Frontend Transport; Thu,
 27 Mar 2025 14:33:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MWH0EPF000A6730.mail.protection.outlook.com (10.167.249.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Thu, 27 Mar 2025 14:33:07 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 27 Mar
 2025 07:32:53 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 27 Mar 2025 07:32:53 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 27 Mar 2025 07:32:53 -0700
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
Subject: Re: [PATCH 6.6 00/76] 6.6.85-rc2 review
In-Reply-To: <20250326154346.820929475@linuxfoundation.org>
References: <20250326154346.820929475@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <2ee0a8e7-8945-48e2-9c11-28710708f029@drhqmail202.nvidia.com>
Date: Thu, 27 Mar 2025 07:32:53 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6730:EE_|PH0PR12MB8774:EE_
X-MS-Office365-Filtering-Correlation-Id: 055cfa22-a012-4e7e-ea83-08dd6d3c4ae7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ejJoSTBGYzBlbkkva0FDeWxUSldEeWk4WFkveVdyZDN5cWRKaDZoSXFPUnF5?=
 =?utf-8?B?WXZaY2szT2tKSGlRYlkwcnhzL1RRQVFtdkl4a1NaUEFjUXJSQUxiUHlnaEp0?=
 =?utf-8?B?NXNadkNONE5zM1RwQ0IwWFo1WWN4SU9oUXFMZEtwdGppRjgvd2wvZmprMlJE?=
 =?utf-8?B?YmZCV2hNZjZsdWNBU1FIOThDYjZFUmlRL3Q3cC92NTlGS2VVQWVQR0FPZUMw?=
 =?utf-8?B?Zk9LTllkb1pWR1ZtOStjSCtobCtFSmVBQVh3WVNXNStRM1RsYk51Q0VmTWFV?=
 =?utf-8?B?bmNnUXJOTytDTGs3Rk50K1JWSTJ0NGtXa3loc2x6eUJyRmZveG1KeFZsN0N3?=
 =?utf-8?B?SEttNlFDcmp0MzUxNTdjeXJJMUhnMkk2QXEyRGs1eFBpUFJJVVJEMHFpOE9i?=
 =?utf-8?B?bUF3aHhvMUcwT1NHSEdZOUNSRS9qM0FKRkFXNmxQSnAzblZHN0pJMFNTVTlH?=
 =?utf-8?B?dFJCVUswaEltcXYwRU4vZDNybElHT2JGWmVkd1Y2RlpaWTcwUENKdU94THdR?=
 =?utf-8?B?Q202a0llSUhCU1NlN3Z2dlRYWlhtNGtvajNLaW9EanRZQ2NueCtST0lkYWFZ?=
 =?utf-8?B?MFhvTGRVZmVKcVlDVFgyM1k3SG8rOHVNalB4YTZBaHBhTWtsQXZra1lOVXZS?=
 =?utf-8?B?dXVVdC9Oa3EySXlSWXZqNE5YLzdlNzc2NFRuQmU2YjAwcFNkZjJxRitiV0ZY?=
 =?utf-8?B?MEt5TlptYng0blRtNlgyV0lMSVNITHNrd0hGRnJrSTNOYVBHbHFzYUk4c1F4?=
 =?utf-8?B?TW4zRWFOZlhONXovRmZTRkRiTGY1Ni9mQ1R3RzlBbk5xVktVVWhzZ3NOUXBB?=
 =?utf-8?B?dHA1Q1F0ejNma05kaFF3TmZmdHpMK3hqaFhHRlZzRnQ4OU5QOWR1SUhRd1hw?=
 =?utf-8?B?U0NQMnRhRGRwTkgzUmdzbGpmL2QrNGRYb1Q2Q3piZGVHZ3dZTkM5eG0vYzdB?=
 =?utf-8?B?a2YrelM4Vkw3MjV6WFRQOFJ6aHBucWtvUitUdllhR2g0TXpxenBsSEE3Z0E0?=
 =?utf-8?B?R1B2VnhDWElxSG5rd1p3MlJUQjdSUktMd3dCUk9sclJQbVR4bjVqZVUzcTF1?=
 =?utf-8?B?VXhhL1RLcTBnVTlCY2pzMzdwQ3BQcHgrR0hXYVU0SFk1V2U2UXJ3WXBEb3V1?=
 =?utf-8?B?MGl2b2djdHp6dUJtSmQ1c3JBekp2TnowUFowTUNqV25HRU5mSU5WMVlzb2p3?=
 =?utf-8?B?UWtHa205RTIvbkdlcXJqV29lM3lRcGx0WjhTQ1RoRWtmTEN1TlJ0OEF0RUpj?=
 =?utf-8?B?UG5mc1RqNEZkdHU5VHBFRnlEL05xTkp4ajJjS3NiWERXRzFoV2M5dHRlTkFx?=
 =?utf-8?B?YWE3TU9wR2lrNWozYndSZmFxbEdCOWFZZTdFZElUNXJQbHc2QzZOSzRKRjNF?=
 =?utf-8?B?YlR2OGpRM09oWHZJUTJ3U250NXBVT1I3MTNVd09HaW92ZjFsRHRXRllNM2Vk?=
 =?utf-8?B?UURoaWt6a3U0aCt0QzQzZ3k0WStTOGlXcFpVelRyNFZvRk5saW5mSjlqb0Ns?=
 =?utf-8?B?cmxBQ0tWeENRWExvV211b2RwaUt1WVkrMVBEdHg5aEJPdi9Pb2FZTkdtbU5s?=
 =?utf-8?B?RWt6SWdwaFR3a2pNOWJjMUIrYXowY0VKNmZibFV6T2w5RkN1YUdEMEVCZEFG?=
 =?utf-8?B?RmpDTCt6VnFuUGord2M4M3pxT2VjMU9uUCtvODU5WnhpY2FyNTlFcGpWUnRY?=
 =?utf-8?B?dER2aTBjeWNJMDZUa2xYMm1vWXdvQ2c4NG5jL1pkcFQ5WDI2czZjYy81NTcx?=
 =?utf-8?B?azA3UjdGSUZacWhWVjFjaXhraTZ0R3Rmd0NZUnVHeVlMTThDZmxQM3JYSmNz?=
 =?utf-8?B?YWZ6SlU3MFhibWwxVGpXeURyQ2ZyQUYvTEhxMEczMEN3Q2FjbFhzSHlVZTVQ?=
 =?utf-8?B?QlVTbXIrZ3BWcnNubWdyaERIOEdlM3hBQTVIcHBJdlhrSnBHTUUwRDExTm0w?=
 =?utf-8?B?UzFsYzk1azZGdWI0Z1NMT1lDeXhVWUluZ3RkenE4VldoUXdoZXBKOVB6V3pm?=
 =?utf-8?B?OStLL0lTL3p4QVhsa252bzIyWEV1SW1iZERIbWV4UURJZzEwZFJRTjZCRmpu?=
 =?utf-8?B?dWhJTXpFM0FiV3NjZms1TWFPZkpQU1RHMk5Edz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2025 14:33:07.7562
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 055cfa22-a012-4e7e-ea83-08dd6d3c4ae7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6730.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8774

On Wed, 26 Mar 2025 11:44:35 -0400, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.85 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 28 Mar 2025 15:43:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.85-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    116 tests:	109 pass, 7 fail

Linux version:	6.6.85-rc2-g0bf29b955eac
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Test failures:	tegra186-p2771-0000: cpu-hotplug
                tegra186-p2771-0000: pm-system-suspend.sh
                tegra194-p2972-0000: pm-system-suspend.sh
                tegra210-p2371-2180: cpu-hotplug
                tegra210-p3450-0000: cpu-hotplug


Jon
