Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072.outbound.protection.outlook.com [40.107.223.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6BE17993
	for <patches@lists.linux.dev>; Fri,  9 Aug 2024 10:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723200925; cv=fail; b=VIBo8Ea5Lx+/La9J2tgekokhv/0mqplNoWdjOYqrs6KrR6tXNOkzheDGU07yTMkB5+I2VOk7pvRp0k2jtmzWrLeOwnMgbFSQMtpFByIkQyUAg9X6o3hF81oKYpalZ+WI0M+ClI5LxOblH7omPIHG91fhgHTYDVvIdgKVI5KlSss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723200925; c=relaxed/simple;
	bh=Cl3hfDDjseXtCdeBzGpNrBHD48dILcTmmLjWSXN9vnA=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=GfKD5I0o1r3vbgADwj6G1jiIUDkXFrYxaKh2AHqi4+EMZjKVV14evuXRYGVORnLCohN+BqSj/781RhfmpTxgP13X2PZSwsWm9h/SMQr0bUeaUes8fnafPyd/crzo9BzmsydqbzxVeWfsRlSc4ylPRRcsj8egcjyX4idtL58MvXY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rEInskcO; arc=fail smtp.client-ip=40.107.223.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rEInskcO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SV1NZFDocFrZDJhvMV9UrJJETNuZaXtg+KGdX1xbL0XCed4TVq9d6ktjl//z+NqobKnJmwjRqgschSL6GrwPbwH4O12Qx2//QCggpMhaEbJmcET7kPvzNDxvbJkY3E1JQHurDlucasCo0Kt1b2qtDL2xQwchD9n87/GBxFsQM6gs+kHiI/WonH2wAP/bN8LbAIxuS3ieONUZ22m6+TGAyt0Gxvz57FLlfGi6k/4K7yQhQr0O67dAPDi59wkXCu/5Evn3nLPwk87A6gyX0CvH4xietozMpTpmcgP3prB/96QK5v82bcqjDAx5jtmZs80OCqapA+Yo/AY+TM0J1G4gIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7eagEu2s77FqqT4z29Kc+wAdFq3cvX0PMgQrvZROyqc=;
 b=ZP/+OjqZN+I54Tze04xbPCu1moUayagGwQ8RABO45GiKz1Gkq8NaK8OfWRycebyjexE2jul4tsCGMJpGqDMPQyGzqxSNg528KKxJx1V+NS4oPw9xRVPdCacNYnttASDXSRB1kV1bKdGaokma8bpHM/w7o/I2+0+XUbBuaHbs1oMRB54/PwND74i14GOzkKlvY/9mGHDHNb2WFaHPC5NBQOEYuTWYyMdo+zbly1aZ3GrFhHW9ELieOA38JCnMhiq2zaBIAh5YweLnvBPBGJtG5OXq1YBLns7vCtnIllGpNAi9cDzHcG1gWREcIFI+dZuwMhurriIhW+UnYUM53o3d9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7eagEu2s77FqqT4z29Kc+wAdFq3cvX0PMgQrvZROyqc=;
 b=rEInskcOwvRDgaCG6p2GHYlTvrPWsEIct2Usl5eSvrVHXryFuFwC0KXIm3Stt/ORY2jPlnqQR36Yfhdis6x1O9++MCTT6Spbnn0cG3jMWi2bsPdSHQdbGP+eSp51i5Y7uiJ2IPUtT0vaYeiNIQYWtANRb/BENpMQe98omVjV8wb3dFRbYDNoKu/5WZqTjwlBzCQ+QNQw66U2xQguoLTu614pLJsWOfw3fS852jb0h3S/YJdZZOzmZ3B39adg/N0JrksT0DlRikot886QDLSmAtqM7oD5NH+SgdpG9inALEuErVBqEvX7pWs+pNL7E6snUZonv8CP2sy6rxabNYlf4w==
Received: from CH0PR03CA0005.namprd03.prod.outlook.com (2603:10b6:610:b0::10)
 by CH3PR12MB8756.namprd12.prod.outlook.com (2603:10b6:610:17f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.32; Fri, 9 Aug
 2024 10:55:20 +0000
Received: from CH1PEPF0000A347.namprd04.prod.outlook.com
 (2603:10b6:610:b0:cafe::59) by CH0PR03CA0005.outlook.office365.com
 (2603:10b6:610:b0::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.32 via Frontend
 Transport; Fri, 9 Aug 2024 10:55:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH1PEPF0000A347.mail.protection.outlook.com (10.167.244.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7849.8 via Frontend Transport; Fri, 9 Aug 2024 10:55:20 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 9 Aug 2024
 03:55:13 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 9 Aug 2024 03:55:13 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 9 Aug 2024 03:55:13 -0700
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
Subject: Re: [PATCH 6.10 000/123] 6.10.4-rc1 review
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <74c468ad-a7ce-4209-ad79-685f9c849b57@drhqmail202.nvidia.com>
Date: Fri, 9 Aug 2024 03:55:13 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A347:EE_|CH3PR12MB8756:EE_
X-MS-Office365-Filtering-Correlation-Id: 00e8b3c5-e6cf-4f5c-3efb-08dcb861c33a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dXlVTDduTnVBZkVJeEViQjhzSTF6cGZEVjNRWkxURGk3cnpQUWpJU0ZBM2Vo?=
 =?utf-8?B?RnJwRmNMT2dONVhGNGY5MGpWYVZPbjBsWkJKS2tsbTVGTmRzVEpBYmFvOW4r?=
 =?utf-8?B?QmtxSUZmdm4xSEkzSjFSLytzc0dBQ1I2aVNHNHp6WnF5NTQvQUVEUm5BS0N1?=
 =?utf-8?B?N1BLb3hUcEN6TlFZTk1jT2xvZVdoWG85U3M5WkZtdE9IcllYbVY5dzlSVlFw?=
 =?utf-8?B?OHlhVnVLeUxSZnhnZnJjeHdkQTQyak10UWppelRPQmV1ME8rMGtkYVpOVE5U?=
 =?utf-8?B?OW4vWmwxYWFOQWZqMjBOek8zWE5CN3VpZGtQdFNyZDVGcWN4UzNzUDh6TVFv?=
 =?utf-8?B?b0xOTUhTNmtucktUUWQvUk5sV0dqUVRtU1REUXBxTG5kN1BWTTdjUDl3UzBO?=
 =?utf-8?B?NEg3aHhSbW44Q1p0QUE0TFZYVEtGcmlkRDdRd0xIMGVDa1MyQTJYTFk1bHg1?=
 =?utf-8?B?WmdBaEs3OUhDOGpHS2RONjhEMyttZStTOWRkYnQwN20vd0p0S29kYlJtVnNr?=
 =?utf-8?B?cmFIRGp1Q3FwQnJDbTBJTG13K052WGxuZ1lReHBjcDc0ZWkyOE5vRGswTm9O?=
 =?utf-8?B?S1hKYWtQd3pxVWFXOHRUU1d0MVo3UFd0VFZRNG1vTi9OVXlxbnFJSmFtNEpY?=
 =?utf-8?B?cnh6b2tOZVU0SFBna0ZzUGRoTGVyT0xXR09mWGxBSXpFdEEzbHdpYzRrRHBX?=
 =?utf-8?B?SldVRVVMSHNyVjEzbDRxR3RVZWthR0JwQVlYYWxTSm0wMnVGOVduYStDbkp0?=
 =?utf-8?B?Rm9uN1hHL1pDQzlDNVZlQm9pc3N3bktMalQ5TFg3bEREUlphZXVsbWxVMFlM?=
 =?utf-8?B?T25MVDlXRVNOOUxobE9lT3NTYTA2TSt5MC95KzdSTmU2dmtHQlMxMXN5NnZT?=
 =?utf-8?B?TlRqUnd1OGVVblZuY3gwZ0RoZldEbkpFRERIeTlnS29MdDVQTGcvS2l5YUlv?=
 =?utf-8?B?eTJBQzFta0plbnhXRkthUmMrcUtuZkhFNXNsOXRKZ2Q2YlpubzdySURwRWI1?=
 =?utf-8?B?UXpOamV0ZVdhVTJrZ08zRkcvUExDQ1plSVEzcUpHUDYydlRYY1IvRkU0NXU0?=
 =?utf-8?B?VnVKUjU1bjRRbzFaWk41eHdMK1pZdm91SUl4UW9PYlZrYWFDa205VkRZb2kr?=
 =?utf-8?B?NHY1MVAzWm8reGM2TlVPa0FGbnd5Z2wxSThvYjA3MC9adXRPVDBzNEV0aDNp?=
 =?utf-8?B?dU5WZG9RUEg5Wmd0alFqdVNHa3lUc2pNdGI4QlpVT1FGREt6dmpSSnNUUCtj?=
 =?utf-8?B?L2FDbDk4RXlkcS9hd2JNTytrMFFJRklVZTlaRnJqeDlEMzZ0UXdjd0N1Vis2?=
 =?utf-8?B?YkMrVTRURWhuTjc2d1pyeVdyZ0tVcWsrZzZGY3U2cFQxcnFnM1JUY0ZveGVZ?=
 =?utf-8?B?elRwNHZwVmFBT0RFWVBsZkZnNURod0s0YTJhdDUzWkgrZERjUVVMdkRQaTBu?=
 =?utf-8?B?RitIYllla3UwL01JaWlxbFBnNURORWVvdFpCQ1JsZ3pHNmpLZk1FeGdwY3FY?=
 =?utf-8?B?SnRWcFV4RXZMQlY2d1duV1hzVTdNaGl5SkZ5TTFvKytocGIxdlNyY1JwMDJz?=
 =?utf-8?B?cGxEU2U1ZTgwdmFUbDNKKzU2RnRjdkJzcXJFVHM0Q2puL2U0elBkc0pOeWpl?=
 =?utf-8?B?bWRJOW1LeWZRRTBUc2I1Nm5ZdGU2OVVHd3ZTNldlNUNEM3NRdFMwQUltWUJz?=
 =?utf-8?B?VkxNVlVaSGdWRzJjcWx0U0UrdFJPeXRna3lBK3lGelAwL1d6OWFrUVBYMnU3?=
 =?utf-8?B?N0RoWWNWZ2NmSGJPRXVxWVBsYXlvdUxOOEdpZEw1OXJ2UWN6clIvQUNjR3d6?=
 =?utf-8?B?aFNpUlc0N0tFUzNRSnJIeTZIVjRtQVNjZFFtYWdPU1VMaWJRNDZOdm5LZ0JW?=
 =?utf-8?B?am1VQnRScjdGcmdVNmRvMm40QU56QXdqRjEzMWFkRWYyWVlRTUthVFFtUXUy?=
 =?utf-8?Q?Ii3yPcvYzz/La7SfqKF1emxW+KSGA6ch?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2024 10:55:20.4918
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 00e8b3c5-e6cf-4f5c-3efb-08dcb861c33a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A347.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8756

On Wed, 07 Aug 2024 16:58:39 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.4 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 Aug 2024 14:59:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.10.4-rc1-gea130d3ae10d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
