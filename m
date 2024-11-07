Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C36120FAB4
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 13:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730986980; cv=fail; b=RM78k0ek+EjFJfIX/5Wq56zCp0V5HcBH6limbIHHAah8ws/bI9U6UL0blgTSGAgtf+1sNqrkBJhTWY9mkZuto6n2oyXInfuBMtcuDNZSEIsaHeygWOCdZVz7/Sa0tgO0Ly9q+kMakgFvgLfd8BT3xbHwQuFGaN5rXFCwSTAEEcU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730986980; c=relaxed/simple;
	bh=wJt016VTrJtW5unFI1D9xeSt4pAkp0KthugNFAFAHP4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=oFkg63RVQUarXm5ArPl22RGkicoybauKn30s5Mpg37bidsn06xdXgNAZxM9hu4p+MGbU58WR+UrySZ2fT4oUagbcZMUwg7ipk9de+8L8S5Vhlidqynv8s9SRScF455qvyvAf++5JqBhqhWMrFmNhxpUuA/8dkkengTDLoJcz/7U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=i+8MaZwF; arc=fail smtp.client-ip=40.107.223.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="i+8MaZwF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bQ76cVL18qrdy0JYQ9rlXQouJQxc9WC6xxAHvWZruY0yjyw4qo67s6HUO+MSDtydn1uTzhWs8SVrYnKgicuYxFfbn22RxTJ8mxlgiwKvwfPijS4RyhYeOWYU7nLdubhv7GU8thvu1E2F0loNZyoguKkCgf0NFUfHYQiSM+wvyv5oBR8eopV6Weh7sOJ3bvCq4TouecYvkGryG2tlY12MjAjkIpJ7hPPyCDFoS33HJ80ZVWbHMynRp2eCZHqaW6ylCf8J8NtixK6P9n7qUi/86vcACMcgdoLeRSaRjmPeZc7UdGS73bZxh76CfB/1dEH3+5ch8+y3iHKO+eGiY0REtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p3pcO3IYFjG/4sfPdY2E3zz46oursTlHzEu9W1uxRKA=;
 b=NYXXxk0LPvMdMgOF/hb6PoNCVVLeKLGCZx4lU8zwOX/vganU3PtnZdEp9+14Zek1Dl4FJE2KfKGzl2w8cm3fz0e/NrrdR1F+mdDbBVzWYRsdZRZo4ikDfnMtHrVlPCPQUQgp+WEqMPzW0An5G1OoSavcH45g7DWtiHKcnpdpf9kLzymwvRJL0IkgUeT6uztyM1FJptGLiiLF5bibMdm1zSYcoQvvuHDWrHyVLejIKKzZnaHFNQxfzxpQpVWoQ7WR+2jS3/CESBkvsoujQ9KHu8ZLAVTDJJpWIrha8vuxPjB7pumrTd45iM7F4RmA9CHifvFtn89zc2aj36Z3Z350Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p3pcO3IYFjG/4sfPdY2E3zz46oursTlHzEu9W1uxRKA=;
 b=i+8MaZwFyu47PjziBoGkfbwZcDt0ggoyh9X4LCAl7pE/cRdK6JosrHGH0Ue1738vSCQlXjTOgWehIz2e/pIGQXiSiZ2C2IY9uPqJCJQrwxkq14YS/X44h0vR+EqKPtRW9Q1vj/EijVsdkuDjkJA2am8B2RYoWFw4JRjH9upKCnbZwnTDOHOdCOw2DZtpNra+xIG49BQd+MCbZJ3xuDxRymR6z1Acd4bBcc4rSZpvKOAOPLLgRyky4/z+REwa828wtIv+kMYNSCk69bS4TL9+6K4jcbafaDQc/sfmqh5qk1RF+/xdCu9+tl7DRS6kOZGCM73DefotTGzaNL2H2oXZog==
Received: from BY5PR03CA0025.namprd03.prod.outlook.com (2603:10b6:a03:1e0::35)
 by SA1PR12MB6701.namprd12.prod.outlook.com (2603:10b6:806:251::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18; Thu, 7 Nov
 2024 13:42:55 +0000
Received: from SJ5PEPF000001CA.namprd05.prod.outlook.com
 (2603:10b6:a03:1e0:cafe::8c) by BY5PR03CA0025.outlook.office365.com
 (2603:10b6:a03:1e0::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18 via Frontend
 Transport; Thu, 7 Nov 2024 13:42:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001CA.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Thu, 7 Nov 2024 13:42:54 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 7 Nov 2024
 05:42:42 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 7 Nov 2024
 05:42:41 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 7 Nov 2024 05:42:41 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hagar@microsoft.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/110] 5.10.229-rc1 review
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <414993ef-ad10-4fce-b052-3c6d4db9ce15@rnnvmail203.nvidia.com>
Date: Thu, 7 Nov 2024 05:42:41 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CA:EE_|SA1PR12MB6701:EE_
X-MS-Office365-Filtering-Correlation-Id: fd86f4e8-f7d9-4790-d718-08dcff321540
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VG16YVprZ3U0b2orY1dQZGNMM25MUkYxeHFPUHhNdHhFL1ZCZEw1WlFNVVph?=
 =?utf-8?B?bkpDanJzRlNjMU1JODI2SjBGcTRteVJxTCsyb2ZkVUkxUnQyVmZ5ZTNkYjZv?=
 =?utf-8?B?UlNoVVlYMlVhZC8yT1lvaFpza2Uwc1FNSmxzU0I4QjRHczVzQkxoY040aGRI?=
 =?utf-8?B?bUh6SkhTNjVLSUtHcTh1bmg0YVFMWGxMVDBGY211Ulk1cFhUUmRqVXhsNXRt?=
 =?utf-8?B?RG0xTnBDYkFyYlhsZHdrQ2dyUHBlRDA4L1pGWWNIRVFyVXJqU0ZmeXRJTDRI?=
 =?utf-8?B?MExWRm1vRnNXb1RKV3ExMWpNcHFpV2FXQmVWN2M0eWE4YWQ1VGJIZGFLdXhi?=
 =?utf-8?B?cGRndTloaGZBMUVHeHM2VS9zWnZwU2Qyb1FCRXY3SGxrbExsSDY3YWhOREVX?=
 =?utf-8?B?YkZLbDFsREhSMkhxaDdGQzhnUG4rbzVZcUkxZy9HRlcrOXVrVGZBYXBPaXBW?=
 =?utf-8?B?QlA1citJNW5DRzJUUStPQlpzeW4zenhMMWxIazRSRDBPTWpPeHlkWXlsQW93?=
 =?utf-8?B?Wmo4U1lSaU1NajFmbFJHdkpRNk5SVVhRdTZWMjZOdmlQR0JzRTF4c3VEeGxz?=
 =?utf-8?B?SjNrWTF5UlMrWC82ZWZVZTFEemowRUZWeXU3TGZZK3BpNWZrOGcxZGVxSDRT?=
 =?utf-8?B?cVptVVNqamNqWXcrTTZ0MngrMlVBK0NxVGt2Y1pLUFFONzBMdVFuZUlnMW11?=
 =?utf-8?B?QlFOWlduaENWOFZhNkRVekdBZjBzNnpXMy9qdEpkU010c3NtbzJCSzNkR1lO?=
 =?utf-8?B?ck05R21jSW5ISm1NZjBEZmhubVdqVWxzWWZmNHJPT2I4TXFSeW9zNVQ2eFcv?=
 =?utf-8?B?UktyU01HVzFGeVpxck5teEZvQXlVM2d5cFZmV0Yza25FRWxyTHlndEExQ3Zr?=
 =?utf-8?B?Qy9YeHdtemw4ckZ2ejV2ZnVPMHhyVlVzeXFoaXVucnQ2QzdScTd2R1d0UlhW?=
 =?utf-8?B?Q3RJUGM0NjZvZWFXZksyV3hlT1JrcDlpaGFNcklPK2hrd2F3ZzlRK0swTXBE?=
 =?utf-8?B?UENQQlRhSWtnRlN3VktHeStnWTh4MWVtME5FbHRYRHA3Kzc4QW5yL0VXYlIy?=
 =?utf-8?B?S2d0M3k5RDBVSVkzWU90RlBzaks2d1NNR09Ud3JjWG9zTWExQlkvTnNHVXpN?=
 =?utf-8?B?Wko1byt5NU9sTE5sdi96eVFHcjl6djVlbHZpcWgzc0hEQklTakVUZ0NHRk1J?=
 =?utf-8?B?cVVaYTJ2TmJCUWU3ZEk0MnUrQ1Uxd3JTYUFzdHliWU9kZFNEeVUwWmJ5akNB?=
 =?utf-8?B?RXU0OUlwaWxTeGJwemthZmJrUm9HbmNEc3N1THo5c2RsNjgzMGZ6VWZhSlJG?=
 =?utf-8?B?WDltZ212MUVzVndkZG9RcWpQeGlmNUhlMFVaWkhkcFd4OFkvVGRxeFlseXcy?=
 =?utf-8?B?RmllZ2JVV0I5YXZSOFNOL0ZEaWwrR1NIWmJ1L1JCVEJWaEc2N05CdVhnd3Bk?=
 =?utf-8?B?bmU4SWZ2ZEc5YTRjUUdTMVNLV3p0ZHBNaVk2eWJxOXd4RU5Yc2RZbTA2VUtI?=
 =?utf-8?B?ZmtZS0pieUlKeGlpekZjYnVibjloVmdmNEFXVGFyK00rb3ZJNHduMnZYRFpT?=
 =?utf-8?B?Nlk5NXFNWnhwVXJWeTc2R3RIOHMzVzBhSk1VL2VPeU9lRlRZNCtiY1pVMlg0?=
 =?utf-8?B?QU5MZ3g1TWlCb3dRSnZHSDlEZWpyd0xLUCt2d1VSL2tIbm45U1hKSmlQN2ty?=
 =?utf-8?B?aW1sak90ZlBvRFg3dlhidlF6aklhNTVQQVFKN2xDZmlzTzdtZk5vd080aC9N?=
 =?utf-8?B?ejg4UzZOVWdiMnB3SGpGNkUvTkRBeS9uWG1EMVN2RDR4ak15eVhZOGluTGFa?=
 =?utf-8?B?a1g3QVNzSmozWFdlbGpBdGhiaHkyM1AwS25yMjBjZ1Z4UmR2eDQrOGJBTWJ3?=
 =?utf-8?B?RHlPVWRmYUNVUWtERkd3NlQrZE1DUmhZUFRNRm13MUpjZGc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 13:42:54.9161
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd86f4e8-f7d9-4790-d718-08dcff321540
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6701

On Wed, 06 Nov 2024 13:03:26 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.229 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.229-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    67 tests:	67 pass, 0 fail

Linux version:	5.10.229-rc1-g3cfcc23ba585
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
