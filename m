Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8991E25EF
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 15:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757343738; cv=fail; b=DBjdkM8574gx8jX1FxLYAdjDEdLTzT7ZxZrS3BdBBtSdI0gJLFG5WVTBSgegJIMEpHRlF2pa0E8bwErlHSBdY5kiGXnjOmmlxefg7ZJT/btSOEbRBdf1IyHpzUYW3N2YkBHsXZ+y+0zsMuPTZyQvtw73TSEfgWsEpGSkPd2OJvQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757343738; c=relaxed/simple;
	bh=VBh1MVuwOvrzYcJkVAdDFX1PW/2oLuToOilhP5xGHoQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=EkMt1G+gSaB5KdLMtgoDwT6xdNg1eX9XCbaivEYKVzZiC4WxF1/iUaGvzHoLP3sW4zmICi0onf2PUEz37NtwLo28W3G6u6QClLyMCiJ37M5c4y5O89Z6khIx1Jw8S8Ptv97vV9SnhKn/cVOf0mnqsQyDN8dyBcXr2B8aP3Om0YI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OKSIP+Wt; arc=fail smtp.client-ip=40.107.93.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OKSIP+Wt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WhNOCgrpCVjJ18zbE+Dh95LiFN1BhWQ9sN4QUc0KVhB/msJOpn70wHaWYFFUNX5GgCZkVuaJsvSWSOxu7Fpum/AlCPqUPVM6hqbtvMb/5t3QwZg3cecZpNiZPtFnhpws3a+YwOLnqaZBfn5zbqOl5GAvcRXE0xOVpS/TBsf4saV7HDs80cSVy/RoE8fgMQylafJ5/u+6ssa2fTm3q4SLe6a6DFHOCMp+SgTUgdhAwt25jJFoYgkVKqAJGh9lkCT+0vCsRIQvSVdop2vf/1PgVHSBi1twZCOt02oTzPc3FiqyBV4VnRoN8PQWNSji0TnokQEkLvqiKXIBX5FbTyoCPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NxJLCyaUCc+tfPMznmnuH5SbyCjMyEnRfuKhMDRM+z4=;
 b=TX3sNy84qd7mvqZU2G4WT6oe2GpQTxiwvVX0QijC8sEJMY7iwojlhtq83Lrki0sJwSyqf9PMkg7B1t0DE78liCCqpWKNDM/TMeIlRrKYIj61SMU7Emz3gExcpxt2j8LbJLoc+COd1g7l1uB/rnEtG0VGayMq9Eo2Y6i0AIhmjwGgMPgYSUXR5Uoa2TXP3Un63okrytoch4Z5zW+eC70jsvylrJIu1FSmLRhjlAA9cVO9ItE+wmCC07Ni2zmPitXcpXOcda0YFQYNxwAkAVzE0CqSzkKEMlCWoL+Awq5C8BAGHthhL9GK00AWg7dyHcbjsJdoHMFKPxjEY8L5exwDBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NxJLCyaUCc+tfPMznmnuH5SbyCjMyEnRfuKhMDRM+z4=;
 b=OKSIP+WtLq32PwsDwB+2en2q6GqgOrpu+cXCmr9Gag9cJAQjq5WMhTZGejws2h9NM8v6aVsaGpEA/rRHLURMHHhyoSu8esGhOIx+o+SsZiT51H+AqpXELaKm9tWrG12Ug8RsaNyuBvqRXUw+lDzQwNVdCtA0USbPJ6+77kzigJZoJpCRXsDBGHoUE/JDVOrzN39evexQBbqTrfxU+leE3iRnaYT/nLzSu8oGmKt/QJ8f4lNBY86CgGaQYTJeHSvy/XwURQeH7w4FTZ5DHqUYQ7hx2Iu4lpmL7RMeOSCFUSqTzAp1HjqJDRJ54N9CKRbgqQLMKccf1IXXDhaNLzXLug==
Received: from BLAPR03CA0133.namprd03.prod.outlook.com (2603:10b6:208:32e::18)
 by IA1PR12MB7615.namprd12.prod.outlook.com (2603:10b6:208:428::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Mon, 8 Sep
 2025 15:01:47 +0000
Received: from BL6PEPF0001AB57.namprd02.prod.outlook.com
 (2603:10b6:208:32e:cafe::3e) by BLAPR03CA0133.outlook.office365.com
 (2603:10b6:208:32e::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.22 via Frontend Transport; Mon,
 8 Sep 2025 15:01:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB57.mail.protection.outlook.com (10.167.241.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 8 Sep 2025 15:01:46 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 8 Sep
 2025 08:01:08 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 8 Sep
 2025 08:01:07 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Mon, 8 Sep 2025 08:01:07 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/45] 5.4.299-rc1 review
In-Reply-To: <20250907195600.953058118@linuxfoundation.org>
References: <20250907195600.953058118@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <0ddc28dc-7757-47a8-ab6e-405d6b99f53a@rnnvmail202.nvidia.com>
Date: Mon, 8 Sep 2025 08:01:07 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB57:EE_|IA1PR12MB7615:EE_
X-MS-Office365-Filtering-Correlation-Id: f9daeac7-6d72-498f-44e3-08ddeee8a1b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QklLSXQ1VHlQU3EzZlczMGVCODIyclJjRjgrVklzOXkwQm83eWtoVXVOcmpT?=
 =?utf-8?B?enAxYnl2cTM1Uk5MbzlmYXozbTk2Umpod3BCNndqNFkvUlFITVA5dlVrQ29S?=
 =?utf-8?B?Nml4VzhaUWZnOHhGay83MGhLZWlJWGF4SlZxbFNnbDJjTlFMazRwM2dIemV6?=
 =?utf-8?B?Y25IejRMMmxEaExwSGJISi9ZN3pOeG9mS3hLdVdEWU1qUUVCdXc0SWRmYjN2?=
 =?utf-8?B?aC9rdWM0U3k4Znl3cHlYaWNicUs5Ym1RQmdiQkpYL1pZdlhqRHpDZi96c2Qx?=
 =?utf-8?B?L0NWMGVmSkJvUFM2MllDQi9kUnI3b2V5emVxRnFkM1RvY05Lb0REamlKejE5?=
 =?utf-8?B?Q05mRmUyQW9tSkRCUVlZRFhpU3gyNWtWMWUvMGhvR1o2U1hmaDBWTkFlZkVu?=
 =?utf-8?B?Nmc0R2t5Mmt1WHAvdjJxVVQwRG92NWFxQm9RQ0ZNN1EwQTYzYUFTS2ZVVkh3?=
 =?utf-8?B?UUQ2ZXhNU3FMZGpwRXRmVjl0Y09TU3FTZXRuRXhNOVJpN2l6UGV5eGVTbUZX?=
 =?utf-8?B?U051bnZvOHJhNndRNmhLRktnbVdYNFpiK3F2MnpwY2U4ZlVRSGswWkxDZm40?=
 =?utf-8?B?SU13T0pKNElXcWNHRzgrdVd2aWNFdURscWp3WTZqQ3loRDBHSTNCSmIrU3By?=
 =?utf-8?B?cmV0dUwvNUw1a0tQd0FoRDBjTnlQcEJaUlQ2U29nY3p6RDRoSEZmVFZiUDJT?=
 =?utf-8?B?MGppdVhVWm16bDZDMGxEUmtIWjZvemxBakRxaTVwT0J0VGRYN3o1K3c3cnZs?=
 =?utf-8?B?bE1JbFlYUHBQL1lQcmdzUGZQY29CRFBjVExPMnB2d3ZlaWthNWw1NENad1A4?=
 =?utf-8?B?Y3Fpek80SWJ1dDJGWG5LbUxiVTZrczIvZVdLcnBMUktEVjE4b084LzhCNmJp?=
 =?utf-8?B?STh0OEQyQnF3R0RUNWdCb0xRMTRQRW4vRWZoRGpMN2JTM3hzL1kwaE0rTU91?=
 =?utf-8?B?M1BUUEFlWjVqVVIxekRqMzB5THhNUnBkbk9WWkc4bVJmSUJmZXk2MVpibVNl?=
 =?utf-8?B?T0FvS1NmRkg5aFZGTTRoN2ppSDBRYzVUb3Fua2lYNHJybVZYbzZiTDR2MXZr?=
 =?utf-8?B?WlJwNXl0Q0VFVGtJVFhiVXhDZ2NLbG44TDFPU2lCb0NCL3ZLMGd3S05wQ0Yr?=
 =?utf-8?B?ME5IWjNIN1NZVDdCdXlBenpMNGZKeGt3ZkVhTDVjWDhSRWlTZUtDNllDV3dH?=
 =?utf-8?B?aityTHhBa2RWMGw5SkVZUm5BdTArVFJ6dCtOd2J2TEE5QngrNXVtcldmc2Jv?=
 =?utf-8?B?RWpNaWhMYVZjT3ZpbmIwZXFrR29GdzcyN1NpTUpLdXdRaGM5ZmlQWFo0Uk9O?=
 =?utf-8?B?cVhQbFpQQVpJeWlZb1d1RzY5WTMwMlFxU002L3g2QVJhM2dUZlhFeFMzWUdK?=
 =?utf-8?B?ZEVIcmVmdkF0M0pQbWVDTFFVOHo4MjhNeEZabGh5cnVucTQvTjd0Y3ZrR2dC?=
 =?utf-8?B?endxNmw3MDhSU3VKQTdQSGF5dVhSZ0MveW5yWWNURzhwdStZTFpnb3Jsd1Fp?=
 =?utf-8?B?c3d3SlRDeUdvaGdBTUNzNXh4QmhZUDdaaEdxU0J0UjVqVVFqVnVjSUM4WEhP?=
 =?utf-8?B?eUVNQmp3SndHVjJUMjhEUDRXcDZkbSsrV2JETFk4L0IrbWIrSTdvQTZBd24z?=
 =?utf-8?B?alZ5QmxuMy83QWt5UFNnZDVCbkxIeTVkMUlrMTdZaVdQNFV5dURYOUQzSWVW?=
 =?utf-8?B?cWQzVEtYNnBoK0Izb3Vya2l3V2JvSVlVOWIxRWRWOXlRdTlKNlpyUDFRaDNM?=
 =?utf-8?B?cVVhOEljR29sY2xZZkpYdmRDVXZRdm9rTERPdmRWRTQ1aHBBTUZaeERBVDNh?=
 =?utf-8?B?S2pCbzlIUUhCTkw5N1V1U0pLMHE5VXA5cHFGTGtidDhHckNIcldkd251RUZF?=
 =?utf-8?B?dnZVaDYxMm1WMzA2NXBleFBrOGQ0YytKQmxmZ1RMUE1SNjdvb09MU3VtU3hT?=
 =?utf-8?B?YzV6VHg1eGJnRjkwbVZ3bmozMHkzVFhqdlAxVHZveGswaHc0NWlKNEppMjFS?=
 =?utf-8?B?bnBvZXZaR01mYTZlNElkWmpxQnJuYmdwak1USlIyT0pkUWp1aC9Ed2RIejdz?=
 =?utf-8?B?ZTdTTFFSV3Y2OFhhYkhUaTFRSGpHVXBNVzMyQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 15:01:46.6259
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9daeac7-6d72-498f-44e3-08ddeee8a1b9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB57.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7615

On Sun, 07 Sep 2025 21:57:46 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.299 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.299-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    24 boots:	24 pass, 0 fail
    54 tests:	54 pass, 0 fail

Linux version:	5.4.299-rc1-gf858bf548429
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
