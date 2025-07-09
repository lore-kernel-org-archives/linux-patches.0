Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770822DD61E
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 13:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752068453; cv=fail; b=jYDLdJ2f830raDsgmdYnxb0ZmWDNUsxUqluZSfVdwcY6y4qZuI3uHpHOsYukogMt8B39QYAuNTlj1EO1bQtBIPmwY838Z/Ecc+8RS1kLzcNRE9ge5Q3AiBpj3msS5SsxW7kBd9vd+I2osdpxlrGObZn/XdwisYnizHqK8+E1KxY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752068453; c=relaxed/simple;
	bh=6fznZ0XtOgemC0TAhoKZZGZMscCvxfogSca4GvaNRRY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=I7ukzdwrBRtV77Sustc3wWBLAQqfFztUCX4DBDWYESH/70+WsdK81DlGOGKNn66TFI/rt30AjuVdRzO41/uk7G7sVutc6ON3h5uqxeQDAvWcEjm5L4U4J3mC8tokRUuMXNCh0QhCMMPzaGMaq2NDxghs+QIeKsZrLkuPv6ksM8k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DXANZFZz; arc=fail smtp.client-ip=40.107.93.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DXANZFZz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dsFpibo8tHCXLi0TaPMT3G+klhWHHlqbFxGDwzLNUyCSPxvNe7hqZX5PQC7Ul6SmpdaVBxng6tPy/0dign0cCSlrH/RbiQvx8soMjetPBYHrrmcCohJyfpsB1KQ6zyZOqMMWVeZyhl4PC3683XTv1LYvRgn360o4wsu2+eCnqUntGQBzRQEGDP0lXhs4p3OTaMl5zEHnyDOYchkoDt0+2xPOAuREg4y3xUFHGgdV5CAlCQDK5Do8PAIWlXFZqIi7CjeeNUWUUWdcrvEsw2CS26Y7BADq663AG4CbZ4g2Bc8L3pGeIA6ulxZisQgjcLvWEbi9NyyD8Ykt3Q22xK56vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jK6c0URmfyYob7mKURvuH6WPQbse1ekf14WzClqC1MM=;
 b=TaOgSVarCbKisfdnhFKK4GmH1f3j9jGZFgZ8oUkGxQRELn10nLHwcCzeWuzI+Doykg2ePSSFgYnJDme3DpLHc05taeS1KU4WUii2ZbXXVz4f/90yDpDcQHykyOYYw3eUxgy1JsmSXeEoNKnDDBvdOmpDhYqcXtcmNIbF2EzGnt+Nd9I4kMBBeWd2NyXO+g5Epz3jyweW9snTB9tr/s7ORC7InJ3bAp2Th357YUT0Npd7SjLxsYbeSeco3VEGSZtd7H1lzOJ9bSHUJGdp4fognO5ydDNbu0UnlEdCYTGwRR32V/gWJyombaEkatziQJ4365uMfQaEmuETQmgDvAG3gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jK6c0URmfyYob7mKURvuH6WPQbse1ekf14WzClqC1MM=;
 b=DXANZFZzvaiQyQJJoZAy+lwF00TeWdtc8AOPiGPHZb/gmXeyhL+QITa2Sz6Ep/nsBNjVq5LNvIoQd2Bn0xdZA01+n5q/kvYFKFD+exQRpkzhkEqEs7wFE5dAypbKRaFGoo51d0yUN996M8/o+FESbAwm6RHTtSbniwimneWIjpdMXt8hXvKWJUxlnJuGJ4/Uk0i1gnl9dYIw1ul42zxQcopxAUcanfS9LKjQ8O5Rv6Z/42ImROdN3U1kUcmT7L70bVsYHQy9a/QbtBySHXejb7KTILbCPTvgf0RbCeSqXVOCtsRpNf+iz8Ewmonz2ss6WFEtYChUzusxYileLNZ50A==
Received: from CY8PR10CA0009.namprd10.prod.outlook.com (2603:10b6:930:4f::20)
 by MN0PR12MB6003.namprd12.prod.outlook.com (2603:10b6:208:37f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Wed, 9 Jul
 2025 13:40:47 +0000
Received: from CY4PEPF0000E9D4.namprd03.prod.outlook.com
 (2603:10b6:930:4f:cafe::b2) by CY8PR10CA0009.outlook.office365.com
 (2603:10b6:930:4f::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.22 via Frontend Transport; Wed,
 9 Jul 2025 13:40:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9D4.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8922.22 via Frontend Transport; Wed, 9 Jul 2025 13:40:47 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 9 Jul 2025
 06:40:25 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 9 Jul
 2025 06:40:25 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 9 Jul 2025 06:40:25 -0700
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
Subject: Re: [PATCH 6.12 000/232] 6.12.37-rc1 review
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <43abbd8c-821a-4b84-95a5-35699a35e142@rnnvmail205.nvidia.com>
Date: Wed, 9 Jul 2025 06:40:25 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D4:EE_|MN0PR12MB6003:EE_
X-MS-Office365-Filtering-Correlation-Id: e60939d0-79b5-4f52-9f8a-08ddbeee360b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cGhuZUd1NEViWGREMk5sYzcxSTZLd05EYkgwc2RqZ2dwanV2Yy8wSkhNaHFa?=
 =?utf-8?B?Ty9iYUxEaFRHcndkRjlDVmhDS09JK1NLWTlDR2Nlb0w3MW96SExPYXp6UGVq?=
 =?utf-8?B?VUlVK0Ryd3BMMGFjblpHUFVBYW9vaFJOMHlFUkhJRWlPWUZKMDFKU1NUai9E?=
 =?utf-8?B?MWdud2FCU2M4NnlSTVA2eGJXdmJtd2hBeVgrSVk1U1dTbk1zU3A3NDc1aHJT?=
 =?utf-8?B?RnRvbHdrSDEveWVXaGlWcHFCcTAxbFdnSFN1YWJvYi9objFVcnkwamVhZCtX?=
 =?utf-8?B?UGRRWGEyMU1laUtjWmRQeDVKT09mZFNMdmdLYWk0aURaRmYxNzA5OUM3d093?=
 =?utf-8?B?eWZvUldyNk9qZytFU2ZFajRtVjkxOFBlOFRQQ3ZGQWVTeUtNazlzR3I3RWF2?=
 =?utf-8?B?OExTWHoyazRuaUpmalRMQ24yK3hiL3RNcUlITEo1Qzd3TGlGblFZSW9ibGx0?=
 =?utf-8?B?eUxjaTNoKysxd1JUTk5HZTQyc0tmZlF2R2NyZlpmcGZJL3N6ZXQzaHFsSjZK?=
 =?utf-8?B?SWtDVFFkUVgwMDc4SkIvdWdhOW5vU21OMzRCZjBmUnArUUFmeHFUekd5U3lS?=
 =?utf-8?B?ak9CM2VGNDJ6aGc2TjFxV3BGUjV4NUNQbkUrZFVRalFwSkY2V2pGbFhKbW84?=
 =?utf-8?B?ZWdDVXpaQ2ZxUmhac3dTNGtzcEdYaG1hcUx4UWpxQjVXSkpsL1VwKzl1Q2ZJ?=
 =?utf-8?B?Z2lVQmUrUldNcEwyTnVmNlQrdXlJK2p5MU9NYlYvZzdVbW1OYU9NSW9BcHJJ?=
 =?utf-8?B?eFlCdTNsNURyYy82MW1Qc1A3bnduay9HZWFDeUF1WUJzMlZ6bkVtdUlmbFRl?=
 =?utf-8?B?SFExOWdrdUtTRStXdklUNzFBa2d4Z3g2bk9nM2xsZTJ2MHA2SFY1T2l4aDB0?=
 =?utf-8?B?bGxBWmRsWWliWFBzSlRPS04wRjNZK0pKdTdYSGhkQ0toZFZKZXE5cFRGa0Q3?=
 =?utf-8?B?NkYvRkRGbUUrK3Bwei9xZlgzUUpiazB5cUQ2NWpySDRySlo3dHlBMG5ZeGhB?=
 =?utf-8?B?dzVkaFJoRDVEelcvTkZMY1ZZcDBhenEybEF3OUFQV2xwOEdodnlNU3k3ZXlF?=
 =?utf-8?B?cnBHZ0lheGdzUHdmeXZ0MVZ5VXNLSFl2SXUrbDBqSGpQcTM2MU1PWmRvcHoy?=
 =?utf-8?B?MlkrSFN6RGMvc1dVR1F0ZVFRL1FwcjFuYW1QS0FSRm1KTk5abTEzandSYmpk?=
 =?utf-8?B?MWhxN0d0OHFpcTJOdnRTRG8rQ0Q0YlJWWWlIZ2ZBRzJWZU9OakxBOGpGbEtr?=
 =?utf-8?B?WjJEN1UrdFRMUU1RS1JNQlJmN2xRaUtIZjdlM0VmbTR2TFJaN1BVNnhhSXpm?=
 =?utf-8?B?NE85c1dlcjZsZTlZY1c5ZSsxSlF0dDZEOVpGMjR2RVlXSnF4MUZXNDhWREVj?=
 =?utf-8?B?aWY0NDhuaVhISWgzUVBpd2w0OFFrMVdlNlNFZHFPNkd5ODVLVjB1b2FvcGg3?=
 =?utf-8?B?MGdOQjNBVFkycytPUGVtcSsyY1BsVW9YVGZmY0dlOVpZMzU3cEVHb0pCdUVJ?=
 =?utf-8?B?OFU5azNtb3Eya0RUMzFybzRBN2lGZ29QVmFVNVpHSndMN0pkRGVrblV3WDhp?=
 =?utf-8?B?Tk1ROUlDUldtMERhTHQ4NEtjcFkrN2ZwMTV6aEF1cWVkMTE3V25iSHNHMXpJ?=
 =?utf-8?B?cUxFMTV5a1dYTC9zc1NUUWxyUnZhR1RydGRDeVlZN0xkRHVUL0JqQmtmczhY?=
 =?utf-8?B?T3lNOWZ2bXRnbVVmbndjWDBraXJuOTFHc3hZZjZQQkhqbERxc1Y5SkQ2aEgz?=
 =?utf-8?B?U2JKRlJoV1Vnd21WQ3c5UDYyOUJRUVZFK0dQQkNLcW1vMTFjZEdHazJnN0tm?=
 =?utf-8?B?eGROUE03aXRqR0I3VmU4SUpmU1JXalA5K1Q5Q05TRTFxSGZOM3I3cXZSK0JN?=
 =?utf-8?B?NG5nMEZHZ2N3Qk0rdWZsM3JIMEtnSnV4VFFVc1JnbzVZY3FnR3puK094VmZZ?=
 =?utf-8?B?UlFxOC9qMGhFY3UzMTBsVDJSa01pNk9vYnJOdXBtbHJ5ekhRTlNvTW9sS2M5?=
 =?utf-8?B?TkxWeDhQQUVHbWt3anRBdG1BOW1zU2tKTVhFK2xpcERmR2pxNlJ6amhZZTln?=
 =?utf-8?B?QmJPV0VGRWFrL0R6Y2tKWW5sWXRxZXEvYzRLQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 13:40:47.3374
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e60939d0-79b5-4f52-9f8a-08ddbeee360b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6003

On Tue, 08 Jul 2025 18:19:56 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.37 release.
> There are 232 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jul 2025 16:22:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.37-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.12.37-rc1-g3d503afbd029
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
