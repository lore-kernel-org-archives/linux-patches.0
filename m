Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2059.outbound.protection.outlook.com [40.107.243.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15481B0F29
	for <patches@lists.linux.dev>; Wed, 16 Oct 2024 10:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729072963; cv=fail; b=eZ9h0TGKtzoCzEDlwc+dZYihTrgUoR6leX+K/1p0DOmUMzfplucQGDiZiT80qvwyUDIF6cA1yijUVTPdF4DMg1BlEV3msgpJPI1Byfwnq5x8yZa74O2QvW0i7DOAxR7Pd7/VSIcLGta0VP4tLXd1pusSEMixLZYb9+oOcqdd40U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729072963; c=relaxed/simple;
	bh=kbKufQjtJNaoP4FkQMYgU6L98z3PBcOHPvaLy0520+s=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=MRpR7c0/rmjpWaMKGyZqP3L+8nf7u9Vmv/ORjFm2SbNynBdKoIdwr9bjq7ogmct67WWY0CB/GlMYlqrCWonTLeg7VFISGdcvdY/Sz4JWQlYTTu/BMEhGqJZ1slk1ppQa4NQfnYb2PswxF6juH8AMrTBm8Rj4D2giXhU9fIqFK2M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fcHXdcEV; arc=fail smtp.client-ip=40.107.243.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fcHXdcEV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ruMiTr/UA7sngoyoB5ndIpDAQCWpFf+/2AilXOo6uLA59FbU1PUiqy3CkAoo5MrxFKhZ1NfKlBzVy9P8lykBdykGEKGulpCLjU1JF3Msq77QsqGwnUG4ChLBdqXUQltlCVCMPkihm2zizx5M+X9DyGJyzdjIJzxGdcHQOqbEh181NcOgMmWiEvmkF713I+Uytw4Lihx/pRMCpFcnT5V5p8BKGgOJXRuXO/NA1a/WFjsRLMg1foyd++EdCY7DtcsU8M/ftX+Hju7we8QeQuSAaPtPmgeuXkM1oRxV4lbHEMPQdaSbcMCjjO4PcKPvUw1V5LK/qdnTM6Wew2WoFo1OJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YXX1UBD9n22vbWfYuEO9yHbZwuaAv86B/rrDRmrZsLo=;
 b=uB6DC870m8bM4qZph2iSVPoAtmAkj4sgLFiBJ/ZBOXDZTes8mNGUxXokiQ2qqVjiEg2HNjK8OUfQmKpo6xcOtGwD1mGj6G+ysawArodxxLmp5eDsGKyHpDa7BkICVB+6kn9ov16bVqdb83IW7rTs6iC2L5zi5pd9E3AIwPzAGG7yZz2lCZbGTgzo1ENtv7cjXl+zcP74hXWHJaFUTOpuFxagPTu65nP8ujv2c6SHoJGB91iCqERKrAH62UJ4UHedIFYSFd1K7bjJqALBLZR5/C81/Uuj4ifpD2YoTuk1qDPce07DDRU0UFc8NXbaCemH07TTp85c018UNw3WXfn8SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YXX1UBD9n22vbWfYuEO9yHbZwuaAv86B/rrDRmrZsLo=;
 b=fcHXdcEVz0K8WQ7JrbDh5KXlACgafjbaxDwFAYvUTxNs4VACraULpYmojlJt05jR5UKpMhnpBMGm+nKkaOfP5w3Fl/gBK/NeLJA7DKwC4+rnW66ojgv1PD6m8Wsp/tJiQWK2lleoRsuwbZ0+A/HxYnhGEAAPwYbqU99TecCvY/5NOpRXdxteBOmZMem9GO3l8U9z+N3UbhrK+qxEA+y9mFXdnWiU4BSqkQMqrpP4qHg2Gb3fCRDihoTkfj1aOzH35V2dwgf6+8Go0QxETqT8/Su41lsLq6i2fkeb2hvB047+IVzqGqYoRf3XXT9ZukhElhvk/2rr6Xf//RA3OrKCdQ==
Received: from BL1PR13CA0439.namprd13.prod.outlook.com (2603:10b6:208:2c3::24)
 by PH7PR12MB5902.namprd12.prod.outlook.com (2603:10b6:510:1d6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17; Wed, 16 Oct
 2024 10:02:30 +0000
Received: from BN1PEPF00004682.namprd03.prod.outlook.com
 (2603:10b6:208:2c3:cafe::97) by BL1PR13CA0439.outlook.office365.com
 (2603:10b6:208:2c3::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.7 via Frontend
 Transport; Wed, 16 Oct 2024 10:02:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF00004682.mail.protection.outlook.com (10.167.243.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.17 via Frontend Transport; Wed, 16 Oct 2024 10:02:30 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 16 Oct
 2024 03:02:19 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 16 Oct
 2024 03:02:19 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 16 Oct 2024 03:02:18 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <allen.lkml@gmail.com>,
	<broonie@kernel.org>, Gabriel Krisman Bertazi <krisman@suse.de>,
	<linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.11 000/212] 6.11.4-rc2 review
In-Reply-To: <20241015112329.364617631@linuxfoundation.org>
References: <20241015112329.364617631@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <fb309c40-15ef-4807-9ebb-02df10e71dbd@rnnvmail201.nvidia.com>
Date: Wed, 16 Oct 2024 03:02:18 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004682:EE_|PH7PR12MB5902:EE_
X-MS-Office365-Filtering-Correlation-Id: 204a7c56-3e06-42db-52b8-08dcedc9a5a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Mk5EM0tlL2hrWFU3aFhDNi93QW9LZ0xVdm52Wk44RHlNQ1ZCdnVZQitZT3dr?=
 =?utf-8?B?eHFJUFEzR0YvWkFJRHE4d1dreVBNOG1RS3ZXcWRMQ2h0OEwrMWlmZlZXekg4?=
 =?utf-8?B?MTY5ZnBQRWRnM09oeUtNM2RRbmxycEFjai9takk2K0lVd0VVc0NnNmFwTnE0?=
 =?utf-8?B?eDdUUW1SZExBSUJEWGpHbWtPc3Q2c3hzcHJDb1J1MUlPMXJ3WUxacnM2dksr?=
 =?utf-8?B?a3dpR0Z0dUNBMit1cHNoRzZGL2FtM2VsZ20rZGFwNjVoeHNCV2J4UW84TGtT?=
 =?utf-8?B?UlZ4VmhHZUpkZmxlc0JqcnRhcjRvRmVXT2JUQjdhcWxQSlN1WHpvODZkL280?=
 =?utf-8?B?bUNFVWlFc1BucHhkYUYya2tPaU5MbGIzTGdtck5uUUZGQ2ZxSkR2L2VJVTY1?=
 =?utf-8?B?bE5NSStqMjc4aU91b3ZQM0ZVLzR2b3NVU2wzY1ppSGdEcGtTenJycWVHOVRm?=
 =?utf-8?B?YkJ5dzhadlZDNjFjQ3hTa0J6SEpYRzZydmFlZ2tJZlpTdG9CR0c5TnRPVFBn?=
 =?utf-8?B?eGp5SlllakxaRDJPSDRIc1RQMDRQZlFWVkxLSUMxTXBGdFJxSTMzdzUwM0hD?=
 =?utf-8?B?V3pJZjM4a0w0RHlldEx1ajM4ekE2TjZNR3VVR3ZVSjNzUndEbTI0NWVabklY?=
 =?utf-8?B?djBpanBxbEpwdFNoanVWVUgxUUwzZzFueVh1QUZzcHdZN1pBUFhZNkE1Vnky?=
 =?utf-8?B?NmM5b29pREc0d0o1T1NBSFRIZW9oZ0RnT1Y2VlI1VmJjeUsrRUgxeFZTcU9O?=
 =?utf-8?B?eWQ3elVIVE0zaFh0dWVEN3k2SWZzRUxMc3NVZVdpR3lLNFhrcmgrVDlJRkh3?=
 =?utf-8?B?V1cwelFQdTZFZ3hJYXpuWG8xVDFCeHo2a3laZGozcVY5Ti9xcDFhSHNpb21Q?=
 =?utf-8?B?UkFVVkQxMm9DNWc4ZjZBQ2tYOTlQM1EvdTAycmwrQkdzQklCQ3krYnJSdHA1?=
 =?utf-8?B?Ri9xOGRwWjZrK0cvQ3NyMVpQL0x2MkhMdVZvckgxZithMXJyL2VlQXBRWUg5?=
 =?utf-8?B?UkFzWmVSeFdTR1JIUUgwS1E4WDhWbFprOWhJRU1DNlpXRjh0ejFlcUNEd1Zo?=
 =?utf-8?B?TFJsTTdSZVVqWHp0cnpCbFl3clNsWG9yTGVHWGVBSDFmOHBqQU5DQ3BrLzN4?=
 =?utf-8?B?cmQzdlpsWHViWUJWK1BLR0lPaGFzNmorb01RMXp3V1ZrMGZETlpYTVpZeHBl?=
 =?utf-8?B?QTM2T0U1NDdSZjZRa1dSVlZjZ3dMc3NEUDh4dEJDb1Z5RnpBV0xKLzByWDV1?=
 =?utf-8?B?WXplaUxBTW5GaVR0Wm1HdnYvTVMwc1Y3YlAzVFpqbXZuRXN3RWh4SWRkRGFW?=
 =?utf-8?B?TVNsakQ4dHpTTStHZDFSS0FpVTBRTG01eFR0WTFoOXFFWG95ekFRdUdVNS9J?=
 =?utf-8?B?c0F2dGY5MUMzZnZHcHM3bExxREY5eEZKRWh6ZjZIbU1LclpZK1U5T3NsWlgr?=
 =?utf-8?B?d0gxOWppNkJoK1F1T25DUk52R3RBMk0wVDhmd1pFVVQwY1lJNjZRN3E3VHdL?=
 =?utf-8?B?VGY2WjNqSHYrajcvV1hsMGc1QUMwV0lOQmg4N1diNkRkVzIvS0tiTHZSKzZz?=
 =?utf-8?B?UUgvVXZjemdHZUpoZjNibDdvSjZKbmIxRitqd2dpem5rSGtoTWdUMmpjcndR?=
 =?utf-8?B?NWNDaGozTWhnK0RoRzY4Z1FYZkFqamsyRjgzVGVWQUtpK2lvWEZ3alFmQS9D?=
 =?utf-8?B?bm1EWmhXWm1OTGJYelBsTnUxRmhlODRpbitDaDRYTG9tYjVNdmFHYXRiN25v?=
 =?utf-8?B?OWlNVnUyVlFtMHl6OGpEb3orSVhxYkgwYXgxaU93eVJ6L0NLWWh0bmwrRzN4?=
 =?utf-8?B?WlZVaWgzUTZnQkMzWVBkQ2RsSjRrU3NvQit3ZlRDbHE5c1lZeHFHRUY3OGZt?=
 =?utf-8?Q?zk9/f0QssJfWJ?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 10:02:30.1111
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 204a7c56-3e06-42db-52b8-08dcedc9a5a4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004682.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5902

On Tue, 15 Oct 2024 13:25:28 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.4 release.
> There are 212 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Oct 2024 11:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.4-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.11:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.11.4-rc2-g9e707bd5fc59
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
