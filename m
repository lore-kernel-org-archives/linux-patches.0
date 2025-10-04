Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011020.outbound.protection.outlook.com [52.101.62.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6781726A1B9
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 13:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759583167; cv=fail; b=Zc8TWUVYvFZ0DWWaEddUTnSA30EcwVPw+p4EhSfwSjQi9+1m0O0OaVhJcCNtGxobpi/TG/3uLSSBpuDdZweQS9l2RlX97BoFe2F8natqPMc2N5sWq6aPzecqbJi8u/Ee3+7IghAkK08Zrd7ZnIWwoHGu3mgvHhQk79rlbfAJQk8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759583167; c=relaxed/simple;
	bh=CP3PJkGm1oAsUo/AnnWZyEvJIFiqA5I0YAFam97rhyA=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=HmIz0atcXV+SUfEULA8JyhteX8mVZmN0UMURbwoWhT3FB5KWPBuU+chuNOkIXwS7NnfQPtoy5ymPqkxcr9YwiggzaDCb2wmr5LS9Ye4+XFjmRiIfqpOc4e8jWVCAvypaVvGi80/mZJNG8MWA3TuVcVjJ9xtzYyO3igodoXjhW44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Lpik9a02; arc=fail smtp.client-ip=52.101.62.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Lpik9a02"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MaothF2YHhLPzNlEDhiC3Ppvbfb06UwXJsuSP7aDCqrJ/qSa5FPg44MhJLwYibLdxjIypca5O5wUuxL5s/pUPSTrZc65dkSwAX/GtSYHUOKl6l6VuhlaKql9wJkrl7tqYQDIj9dqbpT0RAowEWzOMDbgvDbgJahyQfFj2mPumU34XDhJHY8v4+7HUhPUBtRaQ0BN880M4qhnrNAMBdN2dBbJJOHxg4tnfLZk1tz37l3CxFWZBjEv8WPXEhQ6Kz9ySMmC8Uo9sDbD2JssMBS9xwpKaVHK1Jdw5rWT5Qug0LeBsPBCjXRleJvdmPt6Cuuy6N66PcHzdk9mK4FUAGFNvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RQJ8q4iazfh5WBEypW0ttjndtI4gSSNrnj0Dk3DLWbk=;
 b=VSNVIc4rVRUsjYUGgYYHN6ady+lfynAueCPEuilgPhTgs/mAtqwmMT39lS37RUa2rzEcj1g6lEHFtw9Pv2nMs4GglAQmiFcvHh+hgPQVxjZeMrV61mw9hwd8cw1mbEaLrJHbxfELVK3VEzIEQ9YACwjuUfq9/cHeVDcVT9D5KY88d+sytix6KIHhhoKWfI5UtTv1pNkqVWtnbJzI9spGimgnVxQzfvFflFnK2lfy5b5hLsbBSUnFPwxhb3mzaxuHS4N7+gK31yKGEZeIn68QiqDoUPl1Jqs5D85mjja4mRmxHXkyeOmB3D24MKNKjsAm0hBoelOloFBic6dfLsx+ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQJ8q4iazfh5WBEypW0ttjndtI4gSSNrnj0Dk3DLWbk=;
 b=Lpik9a02lVNrYNFa0cMpE385iq8/Evdvo4pUu7BDkJ3c5WZPWnX4KU0JLewUp4iPI0iJLubGxWBQEvI0rXPnXsDgxzY5hOzKae0CL3+oIqckVXgVWH4A7foRusNdsgsKaDvWnv3oKjF55ypXTnR0y01eOnEZuiGtzXcnudRyW3sjkWe7GWFpdSvvz7IUJ0Q12d82hp2eAuiqiCH/Hrv/vwFDPT1XbnAErgK2DDHORDdLvf0zfMHvypk+MMOuCLopffFbNIL+3F9tH9+FdBLTvbAg1IgVTwwkeHJkJ7JAN0pJxpDfzDK7FtWFVWxE1Ba4VdYktdiGE26eP6lLdKzg2A==
Received: from MN2PR11CA0027.namprd11.prod.outlook.com (2603:10b6:208:23b::32)
 by DS4PR12MB9659.namprd12.prod.outlook.com (2603:10b6:8:27f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.15; Sat, 4 Oct
 2025 13:05:55 +0000
Received: from BL6PEPF0001AB78.namprd02.prod.outlook.com
 (2603:10b6:208:23b:cafe::11) by MN2PR11CA0027.outlook.office365.com
 (2603:10b6:208:23b::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.18 via Frontend Transport; Sat,
 4 Oct 2025 13:05:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB78.mail.protection.outlook.com (10.167.242.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9 via Frontend Transport; Sat, 4 Oct 2025 13:05:55 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 4 Oct
 2025 06:05:45 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sat, 4 Oct
 2025 06:05:44 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Sat, 4 Oct 2025 06:05:44 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.6 0/7] 6.6.110-rc1 review
In-Reply-To: <20251003160331.487313415@linuxfoundation.org>
References: <20251003160331.487313415@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <6d54112f-ba99-4c02-a139-7a670533aba9@rnnvmail205.nvidia.com>
Date: Sat, 4 Oct 2025 06:05:44 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB78:EE_|DS4PR12MB9659:EE_
X-MS-Office365-Filtering-Correlation-Id: 31d4e3ca-8306-4e0e-5cbb-08de0346c130
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S0t0VlJVRWVvUk4zOTFzMGxpK2hRakI2VHJFR3dZSklKQjVhbm5BTi8rak1i?=
 =?utf-8?B?ZlNzTmZLT3NmeXhpSloycTFYWEoxWkIyV0FQelJjMWxGbjFFdWlGcmgzUHZH?=
 =?utf-8?B?NFBUVjI1T3NVZ3IvT2hBaG1keW9LSlZadVY1L1NQRHRFcXV1eThyRFlITGZo?=
 =?utf-8?B?eU1NTmNKNjFPQmw3OGpyQjJCSTA2a3NkamlCTWkvT1pwZHhvMlVFUDJVNFFK?=
 =?utf-8?B?Umx4RXNhWFVzdlhSY04rYmNBWjJFUmt0dGxFOVBSdm9MZnEzT0x4aHFuNEVR?=
 =?utf-8?B?Y25CM0RlVllLT0lOaWdVTWd0Q0ErRWl5c3A5Sk9laTRQQ0k2dm9GM0FJbnJl?=
 =?utf-8?B?WDJlVmdiajhJVWdmY2FwL1JqbElQd0VQWFgvMzVERS8rdW1MVXZnS0xtdWpi?=
 =?utf-8?B?TTRadTI5TG9yOUI1aG84MDJwM3B1N2ZFRlZEbk04TXdMaUptNFVueVVxQTln?=
 =?utf-8?B?REUzeUF0UEtYeUgxR0lCWTBLSHQvOFhZNjhXenNhUE4yQ1ZkejhpN3c2cldz?=
 =?utf-8?B?WWJFWUIxTjF4YXhhTkpRRDg3TkhlRjc5bHFpRDdJZ28zVW9jVWxRYXV2d3Fx?=
 =?utf-8?B?THl2MUYxd0NoZ1BYNGNvMnBqRDV1bGxrMEk0L1o1WThhVDJZNlFLc2huenUw?=
 =?utf-8?B?cmtEVFY4K3ZJSVVNQm1Nd2xsa1oxQ20rM25iK1JKN2RxaTZBS2lEUjZOREdX?=
 =?utf-8?B?ZXJhcHp6d1Q5eXVDSHB5TXVURURHRFZjUHNhb3hPaWJQbitoekhYdE1OOG1S?=
 =?utf-8?B?Rm12M1doZHpBdUN1N3BsWER6by9QbzBvUk9MQ2Z1ajJCMUhCVEZyUzRJSUQw?=
 =?utf-8?B?UW1kYll2VU93NUM5VmFaemZsWWQ2Zkd5Ni9ZT01KMng0UjFhZzY2TDdJMkZl?=
 =?utf-8?B?UEliUjhKejRQTURibkVPTXREOWJtU1VMeVdYb3dyU3U1Z09TQVl4QUh6dlVJ?=
 =?utf-8?B?Tml1WHlIdE5mM0hva3FJelZoL2N1a0gxNEJ6RlZzM3FkS3d4ZDlrSzlxUVhw?=
 =?utf-8?B?bDlGU1hQUkdUcTRTeTIyQlJ4b1gwMy9kRWxjMmVyd3F5c3F6V2cxU3U5Ym9E?=
 =?utf-8?B?ODFYRWFuSWpBRDVybFhwUG5mdG14bmdFN1l3S01QRDkzNGNHcm9WTzlzVUVo?=
 =?utf-8?B?cGhRRzA4eU1GSlRsQnliWWtZQjY5VUUzTzlaSTdrVmlNUGNYOTM0L1VnSFEw?=
 =?utf-8?B?eFRlRWtwR0RKWnQ2Nk5WMFRqVHNmb3kwV1dPYVdaeHRYUGdndHZna01TS1cx?=
 =?utf-8?B?bDcrTEVJcEVkT2pFckVLcGovcVo3Skh6UkdSNERyUEliWE83S2Z1SHdoMDJj?=
 =?utf-8?B?NGxCNVFVTDd3OEx0U0creHlXNWZRSUNQcXZHSTlUV0F6bVR4UnhsV3BxYWxt?=
 =?utf-8?B?OXRLMmZXdHJSWEVQOVlnczFERU1kTGxQNG83em1HSzhaMExvMmVoRm42NHJv?=
 =?utf-8?B?dm9qMlRFMkpUbTd1d2twelFMVGliMytSajJoU04zZzFFRE11a2lGcTA4QzUx?=
 =?utf-8?B?Qm83alNmWmpyU0Vub0VjVS9BajRheU8rYzN2d2FPUmVHRlllb0Q5SW9hcDZ5?=
 =?utf-8?B?YnpHdE8yQnlBa3I3SE9WZTNJWnlTVW5RRFBYMExqOXJhYXRrSDNJS1Awa1pL?=
 =?utf-8?B?Zm9FemtnSjBnb3F4L1ptVXVSRGYyZEc4d1U2OUp1ZVhxK1dydGduVTJwMkZv?=
 =?utf-8?B?d3ZzQndkaXNUeXRrZi9nbmNGT0laRzZXWEIraVlrSVR6SWFwdGc0K3ZoR0tJ?=
 =?utf-8?B?M2VjK1RIMmxEbW9qOVR1YnFNeHdKN1BWcytXdU5RUDYycklTVUpWU1RyUWN5?=
 =?utf-8?B?YnNidUdVU3J1d2VRWXNUdHd2clViVkNtK3h4OCtDc3o1S1F4aEtlVU5vaXVE?=
 =?utf-8?B?R0V3Tm9VdjdpMENoMURkK2E0SXJYT3FNN3ZaNTJkYXRuSThyNFliaFBKd09G?=
 =?utf-8?B?cHB3blVVUDlGZjlWN2luODUrRmNLM1ZUUnJHeDQ1bkJZcUpiUEpOYnZydTEx?=
 =?utf-8?B?WW9CeTYzMVVrbitGNUNkWjNlQTBPbWdXRm9SOEpBTTRScTZLNGVkSEd3djQ2?=
 =?utf-8?B?VHAxMmtzamR2dUZyVnZHQ2dGaU1TY2xPRWVTNlQxVFFlalZRb3ZUU2VOQm54?=
 =?utf-8?Q?VmOg=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2025 13:05:55.5049
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31d4e3ca-8306-4e0e-5cbb-08de0346c130
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB78.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9659

On Fri, 03 Oct 2025 18:06:08 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.110 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Oct 2025 16:02:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.110-rc1.gz
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

Linux version:	6.6.110-rc1-gc901132c8088
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
