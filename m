Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A815F199E8C
	for <patches@lists.linux.dev>; Wed,  9 Oct 2024 14:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728485942; cv=fail; b=FQTY04pjZ/sLMmCi3cq+RqH3I84DVbUxDoDMyKIlhZlLhvJEnkAfKN4srlsrHcNvpC0tBu7i4S5Vpv7wts99f4RPjx3ysG0pWBELzjO37M2zoOLRr6qXxElOpqqEakE9lspMvWRsCsSobXD3m2gBmj99/Bi5khEq2dpjFWL70QM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728485942; c=relaxed/simple;
	bh=GvIrbso45xsEkSpFlTjgaAvp+IMKlCABEhsNalMtFwA=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=bwd0tru8Lh74he9Sp8d3KGyO6R6ogyaDB9CDtEpBZUT8HCFXm8EXUiUtCe33Brbuf+i7CYmqrIo+wBwdPgg09np8Qtt51saOIurH9JTNhrhnrSZ6w+lyXZg5rh22eRaQcTkBWIjeNbzlQ4n2+N3kB/pYJC7zbdB1lPwCkzX/cF8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ps+rqKAd; arc=fail smtp.client-ip=40.107.94.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ps+rqKAd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dUGgoUnWuCR4D+zYNhe82Df0FV+uve27STIiOl+ka1w8xdwNcjZULRChwHD8o89Coy33Z3UCMpmkKU4TImmtF6W97IBe8B9CfcK97tnCVUGV4txWPaw3X41KmVLDGjL2/D6AsMb7CJcFo0KKi56mTaQzBeoorxs5sPG11ZeNSvvT5BPTR1d6Hy8wUVeJYlZppndJ3gQdSo+BDABKYeDmWCtySey/Icjl5Gl5bCBLgFp2R6YiwtSELGXs0FxRw9kmNYQAMOK/k9hb5ImH8c9R7c1eei+8IpZ2Xo8am8/0qa1Tc5E1heHRrAKl+ImkRZmCUopBHfAe2q+3oyYb8c/c3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f+Zwucmem6grjIWskBLg4KUk8kNK1oGxI+XQOO0WJq0=;
 b=TOPivORP35KfJh5JHKTlpkbQcYR20OI5kBhg8LG2fKpFNQaJZp5NuGcjhQaEOrr7hA5kVnNGXbwEDqYOeOOaYxF3TCZkE6UyW9UtEE8KBg6fzXqU2QzWH0IToF8AJTwMeZwzTj8l/p7r9zhVR8DtVu6JHaY0yJXBCl5Uv15kMzi04ERcq/nBylyoMLSdrldvBz/rB5IeBiBjHf3JEmjF3s8y5scZVh0npD4ZjDU8qeg8xaENc2FADLHuQQYYQK0PF4WUNmJTQOzvLZ6KktA0nRV3coe0ZDNk3tQ2tLBKHwbpz91pd9IMEbnmplvxmWgjvKfyA/FINJ/SzuyePdFnKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+Zwucmem6grjIWskBLg4KUk8kNK1oGxI+XQOO0WJq0=;
 b=ps+rqKAdyHoH+uJYpjB7lR6VbTeNfxLoTSrk6KVDG2le3P6yCSkzvmPXejsW+7kXb4SedQFpNz3oK3/g9KdcV7L67YN0tucDZE4vDZmkkuMVOo6UKg5obvf2zsUP1uamMZcAC0VvVxuHlKPueaCUu/9M27ekw3qk8PPMFlNX4TkvOz1ZgbE/XiVDY+FnfJfbdrfF1zcCmt6xL1Fyg8qkbah0UehNIL4WguwKLJjSZlrhz03pmFWyr69HJaEOWRhp5wFg0ZXN3hhcRG1CRQx82bGRfA6kgpKhj2OicjNfYF2e3C2vqn4Fo7IhDTl8rMvtCKlOZk2CdGS13jLk9EIWMA==
Received: from BN9PR03CA0087.namprd03.prod.outlook.com (2603:10b6:408:fc::32)
 by PH0PR12MB7984.namprd12.prod.outlook.com (2603:10b6:510:26f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 14:58:51 +0000
Received: from BN3PEPF0000B36D.namprd21.prod.outlook.com
 (2603:10b6:408:fc:cafe::4c) by BN9PR03CA0087.outlook.office365.com
 (2603:10b6:408:fc::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.17 via Frontend
 Transport; Wed, 9 Oct 2024 14:58:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF0000B36D.mail.protection.outlook.com (10.167.243.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.0 via Frontend Transport; Wed, 9 Oct 2024 14:58:50 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 9 Oct 2024
 07:58:33 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 9 Oct 2024
 07:58:33 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 9 Oct 2024 07:58:32 -0700
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
Subject: Re: [PATCH 6.6 000/386] 6.6.55-rc1 review
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <773d651c-61cb-4b78-83a5-284bb2df58d4@rnnvmail201.nvidia.com>
Date: Wed, 9 Oct 2024 07:58:32 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36D:EE_|PH0PR12MB7984:EE_
X-MS-Office365-Filtering-Correlation-Id: 1580aa66-8825-4462-cb49-08dce872e2e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TTJ2NVo1UG5aNURYNW1CbDNzVWxsNVU4cEo1MDJjL1hRbmZDQWVrQVJDTXBm?=
 =?utf-8?B?SzhYaWt3c0xmTmNQbWN0U2p6dWx6Q0dEZ1dEV0FsbUcwODVCcjNyYndCcWk5?=
 =?utf-8?B?K1F2RmhnT3lQNUtvMEVRWURnUzVPR0UyWmJXK0lMck1Ja0FWTXI2blBOWC9B?=
 =?utf-8?B?eUtTOWhPQkRFTmN6MU04N2cxOHBnV3MrSHpYblEzcVNGVTlVWVJoOGl5cjF3?=
 =?utf-8?B?Y0tGWmtjS2VhUUN5cldlQzJzLzRBVUsrSXZkQnFUWjIweVpHK0hjUWpWaTF1?=
 =?utf-8?B?Tm8yK2U2OHVsMnRJMVZObjJEZmhhN1RnazkvbjFKa0FxajFDcDhPWG1UUmU5?=
 =?utf-8?B?MTNDNFVGRlZ4VzBlS2pJZit0Y1J6b3U2a0F2TW13QVRpNUtucXhHT3RzMFVq?=
 =?utf-8?B?dndUQjlWN3k0d3pJY1VKS2ZDa0lpQ1BrYmxOOXRXVlM1a2g3YjBwTXovakhN?=
 =?utf-8?B?OUpWaGxZWHJXUWdMV3R5M1pzVFlremdZR2FMdk5ZY2VMV3N5V3BqbklWWFRY?=
 =?utf-8?B?NThuaTZ1TlJjYXBFVDJhcXFUNW1VbUpNNWtRSlJxb0taQmhtSHNPRTVvaWUy?=
 =?utf-8?B?cEp3SG13azdkZjE1RnQyeVh3VWhtQUJ2RXE4c0NKZnQxb1k2d1hEOGRBTitW?=
 =?utf-8?B?UDc3UTYyMWtVNWhpN3M2QmUwQlpOOS9XSHAxR0grSnRZbXhzbG5DMm40cmY0?=
 =?utf-8?B?MDdQK2UvdDFJTytOQnJMTVR6Sk5TUk5yNG5NZENhZHR4TU1waDdiYVRTS2Zi?=
 =?utf-8?B?VGJ4eE1zcUM4bmRqaElRRVNFUXpDdGtXamNNZXB6R09lUGo2aFMwb1g5bzVJ?=
 =?utf-8?B?QzdRVEVyR0JkcVorL2MxOWthSVI4ZG9PYm9ZUEFOZWx4MG9ubzl6cGg4ZWhB?=
 =?utf-8?B?M0FSSEgwWjI5dHQxRUtYeWgyVVVuRTdFeUdvbnRGdVYwMUFTaHplTXBQQzJH?=
 =?utf-8?B?NXVvTi80UXlPN2VKem1tV0daRmtkWjUvY05hUThnTXlobDJqbUUzSWsrcEhU?=
 =?utf-8?B?ZGFaaUU2MUliOVJXcHJEeThLNTB5bVdzYXNpWXllS09xbnhwMUZhdTVUZnVn?=
 =?utf-8?B?S2x5ZEhnZ0UycVJNRUlST0szWHBVMnVsclpCRTMvb244U0w3Z3ljd1Z5c0ZR?=
 =?utf-8?B?NFl4S0JYRzF1MWRicUVndkQxYlNaQU1YWVBDVFhtdk5GaWE4cVF6N254bGdU?=
 =?utf-8?B?cnlLblpEYnFpUDRCSnNxRXhSTm5tcm85OUFwU2haU2UwRUt3WUlxUUkrdTZ2?=
 =?utf-8?B?YlRMNTVnS3JOQmNjbjYwZ1Y5SXdmS1dobWlXRlViaEhaK1FXQi9OaHlSZjBl?=
 =?utf-8?B?bmxhbnNZQ1BnYkpqM1pHd1RJYmZCTTdNYWRNUnFQaCtCV0twT0wrTDJ4dzBz?=
 =?utf-8?B?MjlITTFTY2Evb0RFZFlUekFzMFdyYTlsbTlvUzRNQUtma3dka2R2OHJDbkRU?=
 =?utf-8?B?ck9BMmovNnNmMjREdkJQWXZZSm9HZDhhUTFwbHBWRUJSWiswcm9vb3BRbHFW?=
 =?utf-8?B?RE1tTE9rcTB4TGt3STdjRnVkaVF3OE9mUGFCUUxDZmpIYnNYRFc3MXpvSmV0?=
 =?utf-8?B?N1FySWl3NXYyS3QrcmQyVVlyTlM5bWJoNVYxeW1kK3RKUHBlaGNXSlZ1TGdq?=
 =?utf-8?B?alFOcVBQeEx0MmpzdXRSWkF2bUNsNE9JUmFDbHFUelFaZ3oydUxWL0hlS3RC?=
 =?utf-8?B?V0FTQUNBdXdXdlY4Mk5OU0dEVzRROU0zdDREbWV4VFBlMGt5b1hsTzNvczRF?=
 =?utf-8?B?L2k3Vjc4bjNYZW9KaXo5bjVseE1FZStQYXZ0VUFpVHBrc28zQnZINHVKNUxa?=
 =?utf-8?B?NVlwRFVoelhnc2ZxT2E1MEFuQU13MnhnN3UrTHdIV3RJYmt0WHJ5K3VJckJp?=
 =?utf-8?Q?bJ1Gpca8svkkP?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 14:58:50.8100
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1580aa66-8825-4462-cb49-08dce872e2e1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36D.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7984

On Tue, 08 Oct 2024 14:04:05 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.55 release.
> There are 386 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.55-rc1.gz
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
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.6.55-rc1-g75430d7252ba
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
