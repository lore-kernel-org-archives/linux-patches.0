Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2049.outbound.protection.outlook.com [40.107.92.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F3A1FA8EA
	for <patches@lists.linux.dev>; Wed, 18 Dec 2024 17:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734542474; cv=fail; b=RTV5drZjJ8dMRVi07K0XUfnDxHpb8MVQ4gUc5i2ONQDutJh6zcIvdXWRX0unmCRdj4clw3lo92UXfZA/kD3t8Mu1mblHOnJc/0qKakv7h2eVrxUD30saWWplHmV40UHOduCbc0gllQtQ/qk0i2io3/GLkioynzcnahwEeiuinnM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734542474; c=relaxed/simple;
	bh=4bqACG4bbvT0+iVdo1+ElPcJYuYSFLRHII4v/Tc6qkY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=nAOxlFoPHGmNJCUEk6MDJ1EM3H3GfzwetSuUXiXp/0kHOqdvzloKoWBhY2NutI1jABEI4STv1vwCVHJGzyNw1t/3h7tWbWIMiMNZr4+mUHqS7tvBh2R9U/a4lMfbx8smKOV67mINEfD/Jc0libJLElOQbfQMqIN4OeXctoRSQqM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HrCUdZ03; arc=fail smtp.client-ip=40.107.92.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HrCUdZ03"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fGtVnzppnGfwja1sCpFwj6XUPgTMCM+hmQEtc+ZMM4I/unM8PHIFF1PWM7gWm5Nc3laQp4pY4LzvTCD35fo9d5L/VR22VDfXf2EawXG97n7e+B9rfPL7DAKRZA8svzg8Jng4gbDLW7ApuWNnnDJb+JpKEh3ENLEv5elhtYxZJv3aKCVAOISFH0F0mTqnCUn5243tVrpq16MPuIMnHYv65Wd8G9GMFiInrnDO67W0kCTwhoSh+SdBx9+UHL9xpDTXKm5h/JZXjXzFLybxyjQDlDGzmqEnKHwCzBom70+vf6Cz3SFg5bqyq9sUk2kokOyxdhGdDf9WM7hNwmjxqMj1hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2vxoxx9M+HWsY5IUvIQ2hNH13mfNCf+js++wgyJZnr0=;
 b=Dsp/0MbBKk5WU3e0TEcMzYxGRNTbDhTqctniqfi1Hvnt0Jk5URF5AtIGFK+npTiaeWAYlsIKbBheOId+OydnBzKUVfumgbBR2nKo/P0gRlOkI3/uc9accHpxG6USq23yu2agC7C3/rSu57DAzhdp6sJpp8nCTb0BxiomClG//cHiaTmXL9YfFDN/dmRKb/0Yuu10UfZO8U4OAuaEmIPTul58wCLkzzCiXFlrW+0h3RF2jydiw9qQEeRoya2daZRRSKXFQjbhbcpjBmThqHytl5k42KZ33QWYflD8Eagi5Xfa8g75JBl5JTxO026+Fo/EB0aQOpsHCmSkOmEn+4UIiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2vxoxx9M+HWsY5IUvIQ2hNH13mfNCf+js++wgyJZnr0=;
 b=HrCUdZ03NyDSjVnhKy/EZJXbffVEdSnEDVbEFuXrisMTpZYsPuw5Fqrusq6nr0sbL5YCto1GNB4ZuFerlcIWMIcnrF1HxMs6pogGYayJGk6aAIg+v8X9ifSWFbg3KjkGN17ab9rDVxp2FQB2rDOosr7hkg3Ylr+cozDl8+sP4Qkf8NINdDwTOn84ksNBT28nxTKWY+bbPkR4Dun2g4PaRSvBqNve1MWFWl3Q4QQ437rK9yD/9oHZ9qJYSnbd4bY+R9ie6+JYZhH3FDoYN6KnZNpQ1nNL+GpYKuZkI8Jv81Rg/eGmVojf6VW2Lw05OiP7FcYiNWmKWsyCiZU9VUz++g==
Received: from MN2PR05CA0037.namprd05.prod.outlook.com (2603:10b6:208:236::6)
 by BY5PR12MB4292.namprd12.prod.outlook.com (2603:10b6:a03:212::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29; Wed, 18 Dec
 2024 17:21:05 +0000
Received: from BN3PEPF0000B370.namprd21.prod.outlook.com
 (2603:10b6:208:236:cafe::9a) by MN2PR05CA0037.outlook.office365.com
 (2603:10b6:208:236::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8272.9 via Frontend Transport; Wed,
 18 Dec 2024 17:21:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF0000B370.mail.protection.outlook.com (10.167.243.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8293.6 via Frontend Transport; Wed, 18 Dec 2024 17:21:05 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 18 Dec
 2024 09:20:47 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 18 Dec
 2024 09:20:47 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 18 Dec 2024 09:20:46 -0800
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
Subject: Re: [PATCH 5.15 00/51] 5.15.175-rc1 review
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <a8aaae7b-4063-4b0b-83cf-28eb53669db5@rnnvmail201.nvidia.com>
Date: Wed, 18 Dec 2024 09:20:46 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B370:EE_|BY5PR12MB4292:EE_
X-MS-Office365-Filtering-Correlation-Id: aba5dbb7-771f-47f4-b3a6-08dd1f885a9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?REV1bXB3a3A4VWxqcktRZE81ZnROYmtwbzhzdEcrMVRyWDdvQU9OLzhET1pX?=
 =?utf-8?B?OS9lTUhGWnNNbDVFYVlWeXd4YUdFMThsclByUXJJMkpQckcxbGJIUU9yNlYw?=
 =?utf-8?B?cW9vb2Z0aE9TN3Jidkx1dUZEUmZ6YzliUCtXRmVrS0M4WlN0S2hNQzVERzFV?=
 =?utf-8?B?UTRSZm5SMTBIZHVnMDdlUW5oeEVKNDFUTzJ3WkdmTmtROVZmZ2VaSDFlQ0lK?=
 =?utf-8?B?cXFLMmpOKzl5YnVFTkxaVDRiZWk1UjA2dnF4ZDExcWxMdGRuaE9IcXJQSXpz?=
 =?utf-8?B?ZlVFZGNmb21mZGpPK0VNdlgweUtLblc0THdrampYQlRZQkE3WDYxS3Y5MEd0?=
 =?utf-8?B?ZUxLN1dCdFQrRkVOQ0FITzRwd0VNbFZnSlFxMTVHZVkveVFZS3c1MmFjN1RB?=
 =?utf-8?B?TmFLY25uU2ljYWJHc1dmTUdWRC8rLzVKd0xvYmlSZ2YrM3UzV3NRZFU3L2dJ?=
 =?utf-8?B?YU11RzZtVUN4UFozdWJVR05KSzlFS1hFZ1BEdU8zN0RjaGdRVnVpcUxQRnhj?=
 =?utf-8?B?b1lrL1ZqZUtvZ0xLY3Vnak15T0VjRUNnd2xIelhxM2hxWXdUemZjMVMvVHpI?=
 =?utf-8?B?dklMZkZXMERISzRPK3YrSHVJWjkzOUNLM3ZRSzVtUVVjZGs5V1VJZjVOUWZF?=
 =?utf-8?B?YmF1TGlxUHBSOFZXUGJjRk5NMlJvQzVvVi9abGVmUGlBMFBMcmhpclZudzRC?=
 =?utf-8?B?d2loM0dUU0VHSkc3aXNmVlhaUlRWTXpOVUpoNm02R3pNc0xld3BHc0g5Qzlx?=
 =?utf-8?B?K3VQU3haVlhSbnpYclJtK0ZkUDd1bi9NVm95MVpyamdaUVJvMWNLUGNsaWh3?=
 =?utf-8?B?N2Y0MTluWVYxcVk2VnRFTTF2cTl0VWFIMEtCWHBHRlo3ZDdCb2N6NE8rWWJ5?=
 =?utf-8?B?RTM5ek1mT1AyVFJINmpEdWtYWThVeThTdVZhZ0pHRFRDSEp4ekx0a3hJd3Bs?=
 =?utf-8?B?VGUrSWpGSkhsUldlSDZ6QU0vdUxvUHoyMjl1alVLNXQwa0ZVenB5MXRvNytK?=
 =?utf-8?B?SVpIa255MUtrZUl2Q2VmRGZTMUtVamg5aVlzdDhQb3R4Z0VqcHlMV2c2ekc3?=
 =?utf-8?B?K0pHMVRRYjkrTm9saFpxaGxodHBjcDlYb2R2ZERMb3lPYXYydXpXQ1lSVlVw?=
 =?utf-8?B?Y1ZyWUxSaUxVbzA3dEV6OERkT2lWT0pvT2NLNzVCYTJNNU9lQUgrME9SdXJV?=
 =?utf-8?B?K2xnbjBoN2ZXNGNsVjk4dVN4eWY2RE5xT0htVDBUSzRibG9FQ0ZkSDBtVjhl?=
 =?utf-8?B?Z0M1Wks3K2pia05aU1R4SnBUZXNCZ2RWRG9hQlF6TVVuQ0ovTVVuZS9RRzY5?=
 =?utf-8?B?eEhoc29tR3BiTzBBZFZEOE55cnlCRG5ZT3I0bFUzanVIWE4rcy9PQ2ZWNlVU?=
 =?utf-8?B?eTUvamtJOXpRNXd2YWdzR0RUYW5CSlJ2dGNuTzMreUU0MEVHTE9ESGFSVWxH?=
 =?utf-8?B?Q3V3ZDV2OENPVUMya0I5RlQ4MmdscVQ1UXYwS2VNR2owTTVQRlJrbGhsS0M2?=
 =?utf-8?B?N29lYkRhVnR0NTVsT1dJTXpjdXJGVno2N0hXQXUyVXMxSFhGaWNwSUtzMllK?=
 =?utf-8?B?SXFVNDFXaTBDOStZb2tVazB6T3hDMW1sMUJ4cSs0Zkl3Ti90U0ZyZ1VjbU1n?=
 =?utf-8?B?YnU1TEx3OXFGUXZXYzJLanVSVC9sK0E3WFEvNW1tbFZncnBOdU9tZXZjZWc5?=
 =?utf-8?B?MVhpTFhEWDU3R0x6cng5SXAycG0rM095UGpvVitPM3pQeVZ4R2x5VG1UeUdL?=
 =?utf-8?B?eVlibDNwcW1icjgrSjBNMVBzNGtLQXprVC92d0lvUGdBektBaVV1dUpydjZo?=
 =?utf-8?B?dEo5TUc1N2NGMWRFYlFKMHlZQUVRWXIycC83K1dZTlQ4RWpDOC9RcCsxb3Y3?=
 =?utf-8?B?R3UzdmZyN3MwSWRYT3psb0RrTEcwZ0VLZkxlZE9OM1BXVzMvRm1mT0hHelJC?=
 =?utf-8?B?WDdwcWZ4UjB0elJOYmpJTWVocHdsdXF5OW83b08yOUxUVlo5eGJzaHl0S05q?=
 =?utf-8?Q?c/v+hnHKG1X3k788WNzAxIXYLhkc2g=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 17:21:05.0810
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aba5dbb7-771f-47f4-b3a6-08dd1f885a9e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4292

On Tue, 17 Dec 2024 18:06:53 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.175 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.175-rc1.gz
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
    101 tests:	101 pass, 0 fail

Linux version:	5.15.175-rc1-g11de5dde6ebe
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
