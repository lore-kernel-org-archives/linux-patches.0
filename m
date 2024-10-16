Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2057.outbound.protection.outlook.com [40.107.220.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDE11B0F29
	for <patches@lists.linux.dev>; Wed, 16 Oct 2024 10:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729072907; cv=fail; b=Y+XyImeFIqg4ohiqetm64RoSUFV9BSTMOjm92zKXjPT1eexRar3J7XWrUBixHTgr/ou4tWhbdpJSxCUo99lOhwC4kJtf4aqiXV9VVqRH3LmTpRmqn2Z3gMuXDVNlVYhpULuuXWqQp+TCsU7b8SgQ9+yOI1MQ7YE2rfyN8vqCNGo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729072907; c=relaxed/simple;
	bh=bOvuz6/Va4yYxkEyzks4husv66CG5TxcthutL27BeAk=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=CtSq+YBFYeORG2Z3vYghVvPAufsPA2fNfGicU3MrxTBFNDFet9lUu4e+mGmRtcwe6VnFf8XqBOmQNGMYwtYRe2M03fS4iSfzUzxVrjVmN62F2uuJacRzJXszOsNwigizcLdacv7RU8Ah3yc8kXTERG8gxPoR6KsdIb1M6rzrIL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DMx5R6xN; arc=fail smtp.client-ip=40.107.220.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DMx5R6xN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PyrOGaoKOIGcEnGQhxMxz3jbeMGY4E116PPqxsqla8ajBgdjNDGcibofIgNkNsEwGxuRZJ4Rz/Vjnu+uny/mAC+Mk60D5uEg7cYw7ANfyKfTCaLlw9QwQHHg8VhSJ524xzKr92PQWJ3yGcYXRztqw1mh05umvf+6K6tjPigXQzX+F+ZFSJs5i4+kfzwgfYDbmTdj9fLXqrvNSSeR2utjanqjZhUUzkUiBGenwQd7JSHth1LoE+DDnHmzcZBBCwDwXklADNAcPK4sYvyKY3Hb4ELW7+NqMH1ap/fZeLUWieRMIjcdnSExtebqNidZCTxsccSOa32lMCkbmGeSCZrylA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ZCE0O7PuCrVQrbB52odH3d3m5ScnPxMtk50T1w0KDw=;
 b=xbPg37pE6o7m7FTz/cT9vGInEFGxWfM3chqX/DlsB6TFMF0Szp6neXxsT8wkjnoa8CkK1aqahs9tRMYC2QUySNsDPwdWAejB1mYuwsbpYHy9YqOf2vIS55O6NsmteRNN/hzDXhKmB6VsS1kOkYPk/LccUdXuO/S8EhSGuBXjCt8E7eZOhpCiPgtfTW2/leunjcWWsWd/P5dYEV9hUa4Nt6NXkgcFcziGcXKa9lMxqgQqHpXigNWp/fpfeMoE6LUTW92Z2+TcKaVSeJxmQDezGc7wcKOWmszTi66R2WEoieCi3VQvxdQ40anNDKF4SD5MKXZqPrLYXhBzb7wkVwzlfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ZCE0O7PuCrVQrbB52odH3d3m5ScnPxMtk50T1w0KDw=;
 b=DMx5R6xNoRNjugIVoB//Hkja1iWJsLHTHfemHvGeiftA5HbTSpT94ZhclL98PmJ6XUi7PiXGwm0QfCzLhUqrUpWFvzMHqN4JsDmp9bvzDD6u/mQJ2iL2BkZ62xoc2Gau1kFFpThX5yfSV/MYFToge3JbgNj7MO8G+zjnjT8vKZYiqPhcV6HjagmCVg2KOnuJZtf1o8uZCfNVeSZ5hfkcgjVbIn+wpJBXKhJMIY6X/L9gPGdVogyu19hWkv+LZjF1YHZRD4Wo26IYm+8oyl+mHXEu4xR17wYAhe/mfg6S1qyl4+6SCnqXXz2WAuPLR+wOLm2PV1bH/SaYp7290OooKQ==
Received: from BY3PR10CA0027.namprd10.prod.outlook.com (2603:10b6:a03:255::32)
 by IA1PR12MB6483.namprd12.prod.outlook.com (2603:10b6:208:3a8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18; Wed, 16 Oct
 2024 10:01:40 +0000
Received: from SJ5PEPF000001D3.namprd05.prod.outlook.com
 (2603:10b6:a03:255:cafe::2a) by BY3PR10CA0027.outlook.office365.com
 (2603:10b6:a03:255::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27 via Frontend
 Transport; Wed, 16 Oct 2024 10:01:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ5PEPF000001D3.mail.protection.outlook.com (10.167.242.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.17 via Frontend Transport; Wed, 16 Oct 2024 10:01:40 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 16 Oct
 2024 03:01:34 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 16 Oct 2024 03:01:33 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 16 Oct 2024 03:01:33 -0700
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
Subject: Re: [PATCH 5.15 000/691] 5.15.168-rc1 review
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <2eabce00-b244-4dc7-8dc6-53531526420b@drhqmail202.nvidia.com>
Date: Wed, 16 Oct 2024 03:01:33 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D3:EE_|IA1PR12MB6483:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cc87685-e3f3-4978-7f6f-08dcedc987e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OWtvMDFhTDA2UHBZT1dQa2pnaVVoZ2ZxNWpyRHgwTEh4MUdXVVdSZHlIdUJP?=
 =?utf-8?B?ZndVOFFMZFo1Y1dpTnV3cVRvcXJZb1g4Q3lKajFYSW9RMlFSUE93TXVaZ0FW?=
 =?utf-8?B?ZEFJcDhOUzErUThabElNbDFzTG56ZnZiTndqcFovNG52cEcrQWNxYUl2RzVO?=
 =?utf-8?B?NExkeFIrM3ZubGdEbzVIUmVYVGtGRS9FcnRxQ21RYU13UE9Sc2ZwcnhLQ21W?=
 =?utf-8?B?SmE1c3FhTkY3RlRxeW1TNTN6OTFFbTU1NVNVVHB4M2dFN0IrbUp6YTFUSFNS?=
 =?utf-8?B?UUk5TzlMM3Jyd3cxYU1tNFJQRlBodnJGbytMdWtMWCtZejByWkx0aDY2Z2pq?=
 =?utf-8?B?VlR0em1MdC93S0dZK0lsL1BZUVMwZElnazk2WUpKRUJxcFBGV3p0b29UbTVF?=
 =?utf-8?B?NHRUQjZ0NC9oaUNaa3NiYjFabFNMMEljMDlLb2ZTdjBmeldHUG0wWTdQVXl5?=
 =?utf-8?B?UVo5UlNFcUsyR3ZWdUhOUnJpb2lrYVZYY29kdmFqSkZldDJKZ1p3VVhMTzJK?=
 =?utf-8?B?aVRRNGdDZDU3Z2NTd0NVMWN1WC9uTzVxU0tRSmlsTHlFVEZ0QnRYUDQ2ak9P?=
 =?utf-8?B?ZFpsRkltTm44U0RBdlBiZTVpSnRRMHFySWJ2L3VyTm1EUGdMWEpVTGVlSWVR?=
 =?utf-8?B?WlF2Q0dzazlMRDVTVHdEaHFFODgwcVRibDJnbzcwcFlCbUR4Wm4wZkRMNGx6?=
 =?utf-8?B?NzdsTUNURFZMdnhOcHJNOGx2MG16VU1UUHlNNUlZNC9Mb1pLbDJXTkl6dEtF?=
 =?utf-8?B?cURHV01rRjJQNU9lc0JwbjR1S1FmaW5Ea2tlNjVlTmExNTF0VGF4QXZ4dzVp?=
 =?utf-8?B?RytubVFyKzJ5ZWtWS0l2ZXVYK0M4TW85TWFPNC9pR29rUXEvUTE3OTZZUTlo?=
 =?utf-8?B?VlFOYUpNRE1LeE9QNitKVDhIdHc5WEh0UFZxdWxQdkgydnVxUXFUajIwOWVU?=
 =?utf-8?B?REx0dENtVnR4aUcwaExIdGRrTlUreThxemZITHpiYkFVSVhrQU9jcWhVRVpT?=
 =?utf-8?B?NVVTODYzeTlNek52aFBJcnJWbWN2SElncStZTXNRbW91dmVFUFdtUXlHSGI2?=
 =?utf-8?B?am1GWkI0aU0xTnkxYWhXdlBqYkxZbk53b2JaazN0eDNVSm8zYlFzRGJzRW1n?=
 =?utf-8?B?WFQ2WFd6SzB3WmRaV2Vkc2V4SFQ2Z1BmV1Y0eVNmck9hZkh2YklXK3VFM094?=
 =?utf-8?B?eDVTTmEzcUFQOHo2RFI2R2NlaWNXbURiazZmQndhYi9KUW9XNGtQOWVEZzIz?=
 =?utf-8?B?YVZ4M2tuU2hzSHdzZk9BRWo5c2F3MFhOM2RKN0Z4V090YmdQSDdUUllwRC9L?=
 =?utf-8?B?OTFpTVB0MnRPd3F0RGJFV3ZFUU51cHg5dkg2Zll5ano1UWNrVlM1bUE2NGE5?=
 =?utf-8?B?SkdiVlFlZXpjRFFYNlFBWU9LcHNtNk5icmwwTktJWmhCWC9uRG1qUWRUVHFn?=
 =?utf-8?B?VnR2cDdFV0g0eG9pemtpNUF4ZkZpRFY1STl2emoyWDFOaytLd1I5MmFFTnBh?=
 =?utf-8?B?U2F2akZmZHlhM1ZvMkhiYUppUGJ5UGNrcXhGVWx6QzkveUlYaHNmUnVBRDdu?=
 =?utf-8?B?V2g3MlREQVU5TDdvRzh6MEo2cjZJcTJWdjMzWkVZTzgvSEpSS01JeGZYVDRH?=
 =?utf-8?B?TWZ2bndCOEVWQ0FaMEVBQlZ1ZnhpTkRaaTZ2bUY4dWxBYjlzT0Q0TUhhSksw?=
 =?utf-8?B?d2ljc2ZNc01tUk5iUTRpLzdMUVpQTmU0VjlpNkswVnhCaXJIbmNuaUdIS3dt?=
 =?utf-8?B?WUhTRnh1bXRMU0xsNldRcWw2VFpDUlE1NlJYOUVzQWMzTXJpa2pROFZVVDEv?=
 =?utf-8?B?ODh5aDBPODlGNHBQUnlLYVlZaWZRM3pmWm9PWmhHVlhmOGdsaEZiaGFzMHJm?=
 =?utf-8?Q?VKkl5rSGcFNYt?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 10:01:40.3982
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cc87685-e3f3-4978-7f6f-08dcedc987e8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6483

On Tue, 15 Oct 2024 13:19:08 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.168 release.
> There are 691 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Oct 2024 11:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.168-rc1.gz
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

Linux version:	5.15.168-rc1-g63cec7aeaef7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
