Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2077.outbound.protection.outlook.com [40.107.243.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C1725F798
	for <patches@lists.linux.dev>; Wed, 20 Aug 2025 14:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755698874; cv=fail; b=dL7JuuKXNnPnoLVB25/J68VMUvTAzYwGWwJyLB8MigfhAQFpRpjQ275OjIAvZatjWOc9EsqrzQbe01mYKWDLlCufc2CiQqU+MGEw9wvgKApxjGzQ9rvXMa5mUUp3H5MWguspVwVUlC9IGBoL5jq5UbyStIpAEh4QaZq7TJdrliI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755698874; c=relaxed/simple;
	bh=bI3z357y3xESLFcRJvMlwoBYUvN16CcxUo4LSp76wfA=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=ZXw+G3/BUSRfw1xFG3KnqJ9YUZXdlM/DpicUvObP7thVQIGMEQ7PPTTsI/ASD/v6ChGsr7ZEIArMtap2yoFIRBwNcFXjHe1i0uBxF8F59MbKtv8yNn2uUL0hO/h4Yliayrx27JSKKX2LhuQCZ7GihGSLoSTxWOjaeFcrUu4J5i4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iIPwQ3T/; arc=fail smtp.client-ip=40.107.243.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iIPwQ3T/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YD76WovGbwrHyVlc+XvwDmyG4DscXc/T70CIAHlmarMpAyvW8ELKQxEFhOx3JV/L8QZjzjhmjRTvgXZB38EvNRV8DCpIofb0IwWDX++YoJkwWKQD56x1cKNAvb0SNuiVcbW90MrRfX0UM/X4c76vmS8bsMq1fnfh5vn3AjPdKoBSeU8aXBPAR0/2gNxp21GxYMiT1KdcdN0f8Yy3aBnn3zBPfKwrrlD07nMLK5IvGPi/r0cjX/3QZjRZ28e+jT+HmvE0jrrc0jJ5e1dlQIZ4NDqNljGay8qyPVxak66IWWL7ibb2HxYCnP0FCjGlXun2qK71K05W1ZPbAtMPKHvegA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zWv9xBRfZaFsc6kqYyc/Z3s6mq9Nln3MfXKtSoR6bUs=;
 b=KHiInwdZQ711h7AbKHdFlnSShI5bn2vaj9AQ975D5DF/ks6bAozt2yFprOFMix/QqV20uJ7QpH1mqOSzi0YahYZhDpq2l91vcOhZi2xtZhsnkH10M1XUxxv7WEDQYu+GyanLOeQhbsVDoNhzw9Zyr3wQv5Qd2Z8XWUbIddPM/2Av40S3n+Qm1sFRtTsoDSsujqg0DrxpuxSVEPplDRPiXSBC7V37kr+7/4IS1UGrNlJgyR0lyId9825TOOsmfFzYF/IO03b3rYStrW50nNE2To6JtfHwxouWwi/9uu5Vmc6R0MGwL02mEhro3U9Lu7PQjSt1NReNNJ1mgQqJKT3ZBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zWv9xBRfZaFsc6kqYyc/Z3s6mq9Nln3MfXKtSoR6bUs=;
 b=iIPwQ3T/R4Hboo3gJYmu20u5rrqW8u06eJ+TnTzXSKSH/d6xbItZOIFq9DBtQoGk2Z1TCsR7gahoVmS/mwgotbO5iCyykl2qY1a3y7vfNQ4k89s34ikFtyR8imTj6nImWO5dE3xPsyowqXgPkfDUs6gbCXTSdDxnxmY6HtnATQW1mhV+3xBCGVaWLzcA2E2HWsBDY/5Gfov5m8WuypLbpFIB5zDwwNoGmJ/+0+csQH8t5UfEkwpnOpj7ODXnWN6bSBwEZNp72/oy2/SNhg14x/yV2bSQ9cu4ePk0Ot75jUW1c35R1x92pESEaYU4EBBvRsrW2RLi9bDkwdUCLBGflA==
Received: from MW4P220CA0018.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::23)
 by IA1PR12MB8288.namprd12.prod.outlook.com (2603:10b6:208:3fe::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 20 Aug
 2025 14:07:50 +0000
Received: from SJ1PEPF00002326.namprd03.prod.outlook.com
 (2603:10b6:303:115:cafe::da) by MW4P220CA0018.outlook.office365.com
 (2603:10b6:303:115::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.20 via Frontend Transport; Wed,
 20 Aug 2025 14:07:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00002326.mail.protection.outlook.com (10.167.242.89) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.8 via Frontend Transport; Wed, 20 Aug 2025 14:07:49 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 20 Aug
 2025 07:07:37 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 20 Aug 2025 07:07:37 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 20 Aug 2025 07:07:37 -0700
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
Subject: Re: [PATCH 6.16 000/564] 6.16.2-rc2 review
In-Reply-To: <20250819122844.483737955@linuxfoundation.org>
References: <20250819122844.483737955@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <bcb88f84-4578-4e33-838a-40f0f5c2d60f@drhqmail202.nvidia.com>
Date: Wed, 20 Aug 2025 07:07:37 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002326:EE_|IA1PR12MB8288:EE_
X-MS-Office365-Filtering-Correlation-Id: 322a99d7-b5d9-4d39-aa39-08dddff2f225
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Unp3dTcwUHRVa1pyMTVkc1lxQmp1RGNsTjBPcFYzMEFZSDYvcWNhZ2twU05R?=
 =?utf-8?B?bVY1ZjltbFZvWjkxYWZ2eCs2VnRPd3B2SDdDN0xWMThkL000VU5hdlVXNjd5?=
 =?utf-8?B?NWZ4eDBkb2lpQjRLSzgwWnJtSUtsV1dURXl0ckZoN2pKaGI3RTZQdzBMQktC?=
 =?utf-8?B?TUlpeUtaVm1FSFN3ajRlUXRJYWgwMEkzckVpbzI2djFwS2c4cWtOODdtaFJJ?=
 =?utf-8?B?eHY2K1gvR3ZHRUNHUzlUMDVvbUtWcVVSTHRkQmZSQ1FxVGJQK0grVHhkUkZS?=
 =?utf-8?B?c3BZSmovV0Z5Vnp6d0ZPR1BRYWN4NHV3QXgyNEFSM3owdTVxMS81ZU1weDhs?=
 =?utf-8?B?WHNkVjhmUVQyY3NBYms2Sk5WK01kWS9rV2NEZkFaTk9jaC9ZOVMvRlBhSnd1?=
 =?utf-8?B?TlpMOWFoVzdJSjYra09WUjJJeHF1K3UxOE43eStaclBUKzBCaFNaSmpIZ2xU?=
 =?utf-8?B?SkdBSmRlcGh4b0pLcDhiOUtpdW1IWEZJU3dpUUhkN3k3bSt2Y245M2p4YVQ1?=
 =?utf-8?B?eDk3OXpTL1NmQnpVbEJFcWxZZmZmVysrT3FPZm11VldsVzNCUE14dFpiYjN4?=
 =?utf-8?B?WUdlMWI4elFhbnQ4bFZFdi81SUdKcS9JVFhyb2srZ0U5dmFtZ1Ura1NoSEUv?=
 =?utf-8?B?bTFXUU5oSXd2a2RCaC9GSEpXazU5RE10d0lTeU1hVytxOS9Bc1owNDRLaVlo?=
 =?utf-8?B?bXkyNWZKNXF4NmN4WHZWNHkzZVA0MVk2MWNEN0lRb1IrVURXV1ZCT0lmcWF1?=
 =?utf-8?B?WXI2bTVCNG5FandKRDNramZNdkVHbFczUzgrNkV0WEdVOFl2aDJ5dk9xOUFw?=
 =?utf-8?B?M1pMbnZUWEdtbEdPWGhtMmlqSDJ1eTIzVnZXNjYwMlg2OXBtTjN5b2ZTNlli?=
 =?utf-8?B?bVVoaE12RUIyNXhZQTd1ZFFaR2RLSDRkVzFGMjlDb0NtZW9WN09YSnlSMWNt?=
 =?utf-8?B?aVJTNWR0U1draVEzbXlSMDRGY3ZGV2FrQzNTM3NYTFdmTlJlYzZKRmZ1bVY4?=
 =?utf-8?B?YnFWNXlXbzR1ZnFqM3dQcmdYdVRMOEdsdGV5Z24yTkl6STM2Nm9pR3JsMUF5?=
 =?utf-8?B?djJCK3dsWFFkaGZRbHJTS2x6dUJQV3NtSDRpNGs2K2Fxc2E5amZKWGFMcDlH?=
 =?utf-8?B?cHpMUzRMVjE1VE92UHdzdUhmOW5MUys5TDN5YWRibkk2WTB5SWNCQ1Q1Q09G?=
 =?utf-8?B?OGJPaTlXNElyMm1JenZOT0EyV0U4a2I4ZGR1NW1QTUpJdEd4WVdhUHhKK3U2?=
 =?utf-8?B?amxXdEtQMVJTWTU1YnB2L0JsOEhRS2FQTTNBUlZDeUEycndWcHBGaW1HeVl5?=
 =?utf-8?B?Z3VRN0toQ0l3QkU3R1MrR0dneTdzb3BkME5RMnBkVEUyMnpWQm8xbzhkOXJI?=
 =?utf-8?B?UWFPOG5NSEdra1dlanBpOXdwYTV1Q09FZ1Y0UkszQ1JKZTRLNEZkbE9FaXJo?=
 =?utf-8?B?bVVqcm5qa0FuOXlMbTBnb2l0b0dHcTk3K0Npc05KckI4NUNKUWpLcytqRWdT?=
 =?utf-8?B?TSttWG51ZVA0R1BseEdONGJZbm56RCt3bHpuNHMyc0VqQ2k1NzdjWkFWdXpH?=
 =?utf-8?B?cXNwaHhDTjg0QXNIeVkyeWc2YXduR1h3MXkzNm5QS3hwUHJnNmdVZEpmaWxZ?=
 =?utf-8?B?SnN2ZzFHMndIaDlDS21kaUV3dEFobEkzSGxZZFphREVOZ3Budk56ZmlWaFlI?=
 =?utf-8?B?U2t3dk5OYzhqcVkxQ2ZCY3lSM0d3T3R4TGM2cU5tS1NLNFhpUUFRMy9WTldy?=
 =?utf-8?B?WStrRENzWERhNXl2aHUzNnZ2OURNNE9qWC9TVEErM0tSbHpybmI3azloVzRX?=
 =?utf-8?B?U2ppdVZsNWRVSHRwSVZIZWVDa2lWLzBNMXR3M2dKL29hNTdVYk9jRGxHZXBV?=
 =?utf-8?B?d2p1MU13aHVLYkI3cFVVSVFkdVhhZXhjSFQ0UGxUVm1GUG9ZYUFoek1TN1dz?=
 =?utf-8?B?THczcHBTNkhTN2ErTmlKbjdwSVRpeEkrcVFMMnNULzNhVFhEMlNQZDAzZkND?=
 =?utf-8?B?NzYrUmZTcUhMeXVUVi9kZUw1SXdSZ0NYNWRDU3ArUmVKakE4QU5SZENSYVU3?=
 =?utf-8?B?NGlIWER2dzBhdjRzZmd6eHUxT2hUOFNUMW1zQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 14:07:49.3491
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 322a99d7-b5d9-4d39-aa39-08dddff2f225
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002326.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8288

On Tue, 19 Aug 2025 14:31:49 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.2 release.
> There are 564 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Aug 2025 12:27:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.2-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.16:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.16.2-rc2-gb81166f7d590
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
