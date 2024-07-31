Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B213232
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 15:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722438021; cv=fail; b=VeVHmi+/BPmqGzA9xQYpABLfWfCFt6lPl5jMr5o+gveWgBmic+if/PuREKo/TYn0qYsnr4m8lwCqi6upCAybzXZj2NBMK4vniJiHSoG4ClLWfQlnjetul9hLGfkPtkY7oynRN3GkGOkrQDc/v0Smi9IeT5KSlRB8f5OM4Hzr1TA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722438021; c=relaxed/simple;
	bh=/eVdjDu/kI+cDzANhSQt9wkD1T31rrZaCtojxtOGlys=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=fZOy+EDycpmdjRN/t4dfBbE1AqRXILZN2Iwcv0SGqpqDIZlxI7up8gC70TpozSOEsuVrAfB/jXoVH6yoAQcxbnGc424S120H50hMorXRufUwuSBUHyFjmVOs7QrybfHtnOy8owhPuK2ZVJnJ/BGmOCHP5de2lefcWo08PyRxzhg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YFsKuwFS; arc=fail smtp.client-ip=40.107.94.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YFsKuwFS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RlZ270zL3nUYGKzEQ6Qzqtf4favoQ2xKwbqVuhO7sY+hbyVvuhZ22ndaGCanYmdzSTY0vHnVDm0g515caz5ovJB/8SbUZ5qdaZ44tB+UT9u03FyDTnjZa888YYLGzLl0OXXwB9WADR4tt+VkEqnzK1KyzF1JfFyl+Z5RKRPtf9elD4cgWFc2xEpl8kx2/WKmnguZ2T6ocweE8B0Zn/qH20pgGQ/QvpZOKJHUbd/SEGf3ZGdgEJA7bZkyJwnrGSZ3rxzUNLeanb5ACVlKJscNGFaQdza8+GPDtItDWfdRXtqlLlerjX9nJI98IPDchwrTp90WZpgvqmlWmne9rCq/qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+HD9xEUIZSugshG8JTfkZzkVhL7aGVBdkdhR347ZyXQ=;
 b=SvSEFiqRlu3h+Mn8DcLNEipSOojZFwAHGe1RehZWEKNLdrzPOCmPG+7dvyfG3oQmxHe2CdFxNCNDIv1+rdtYqI1psfqmufU8UBut6+Yif9zfGA39Td5dJSMxUjxBf0uENwADmTdxDh/NnCSUgizMjbBrQTXBxE8AZOdYaHkY5fQrfUKqo2nxZqGclLlqPQD5BiCyb+Ec46YGuWX7yaD8m/Xf2AgHLQgjONFOut8dShr7hzOuZ6Kmd3tpJFZiwKIxciPEzpjURXrdMEg0I9m1Go/a7opJnzDQ/kks+xdbAVpxatmzKY0AfaVcUwLNqgxKRcXnRH+Dp1RPvppBA3zYng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+HD9xEUIZSugshG8JTfkZzkVhL7aGVBdkdhR347ZyXQ=;
 b=YFsKuwFSAWA1HWaL7x/XVjR7Xx/bWo3Yol3wUxQVmOMsQ6UB72XtjBBURO41/iOdg5OHi/6kyQgTO59sGX8bXEivbWRnc49/GgClXKH5HNDsKqJAF1v0MyyveucAxWIRLijHRG63l+OfbJ4HkPWnVUA1A3cmOstf7KrEhu1fetXCHycMU73S/sH9pUyeXoRatS9oH2Nv/TNMFcjvoXCzyY8olvoEdwgpMdXK1ROFtmhPpQzJ7aarbaqQ6gZ957XmjAHW8BawbxsXzTCZKuJAkSXVmJt3DQ51Z7etMKyw0VGEbmnOxu8cfWxjfOs0oN7G4C78iZAHSOluZBHjPVl6Ug==
Received: from PH7P220CA0042.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:32b::25)
 by PH0PR12MB8773.namprd12.prod.outlook.com (2603:10b6:510:28d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Wed, 31 Jul
 2024 15:00:11 +0000
Received: from SN1PEPF00036F43.namprd05.prod.outlook.com
 (2603:10b6:510:32b:cafe::e4) by PH7P220CA0042.outlook.office365.com
 (2603:10b6:510:32b::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.29 via Frontend
 Transport; Wed, 31 Jul 2024 14:59:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF00036F43.mail.protection.outlook.com (10.167.248.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.19 via Frontend Transport; Wed, 31 Jul 2024 15:00:10 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 31 Jul
 2024 07:59:57 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 31 Jul
 2024 07:59:57 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 31 Jul 2024 07:59:56 -0700
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
Subject: Re: [PATCH 6.1 000/440] 6.1.103-rc3 review
In-Reply-To: <20240731100057.990016666@linuxfoundation.org>
References: <20240731100057.990016666@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <736afb78-92e0-4167-844d-47d4905d8851@rnnvmail204.nvidia.com>
Date: Wed, 31 Jul 2024 07:59:56 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F43:EE_|PH0PR12MB8773:EE_
X-MS-Office365-Filtering-Correlation-Id: 331681aa-8fa0-4cab-838d-08dcb17179c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QlB4UTZ6YXl6N212QXJGT1BCaWJZWUpyYXkxSjdhZ0RWczBucmNveHhySVp3?=
 =?utf-8?B?cGVmVjE1RWo1Q210V3ZUQkZZRWxRamFJMGdFVzVsZ0Y5elg2MG5rb1Q3b3FI?=
 =?utf-8?B?Tzg4OUZiM0pnQStjVy84TUNRTm9lYUJudTFsTnpBN3dkZFNvYUtaK1N0ZVpK?=
 =?utf-8?B?MGFnRWcwWDVHUXFybmcyaGlNOGd0UUdUUXpuZFk4THRaVW44ZGs1ZlJ1Um5F?=
 =?utf-8?B?bnFQcnlVamdQYkIrS05BZnJpWUtTU2FVeXdIS3BtcFl1bVNCY0RRSER5b2NF?=
 =?utf-8?B?Nk9kdnpTVmVYbWZmUU9BTkc0R1pZQWJNRE4zNXRUZnJxeTlnRFBXSG5pYk5F?=
 =?utf-8?B?QzRXcFBCM1JrVnIwZnlNaHJTVXUzNktwZ2pwMWhxYjMrcHg2bW1GYk5sbnYv?=
 =?utf-8?B?ZEFQaHVIM0RKTTVNWStMQ2ZqRC9wdml6Wkc4SzIwUVRYRyt2dlhsL1NncVJU?=
 =?utf-8?B?ck1IY0c0bTJyc1BTU2o5WUxTdU0rSktnOUtYUUM4UkhvejVrVUcyOW5LdVVv?=
 =?utf-8?B?TzdIdVVLU0J6a3M1alZ1MjNGU0JkdHIrbW9EWGVWcW11bHNQVFJHRndvNzI2?=
 =?utf-8?B?SExFSUsrMjZCaWFUK3QzdVNMSUN4OXk1UUhUVUFKcTFxL2ZzQzM4Vk96dHpF?=
 =?utf-8?B?Uk4wYXFzWlh6UmM1cVNuNmV4cmxsRjhReEI3ZVRQSHRDSmVraFI1SkhXVmRn?=
 =?utf-8?B?UDlIZjRUZ1dnYzlZSHJNUGJVNTUrZWQ2SmV3aWIvRVlVYjlWdGEwY3pHRmkx?=
 =?utf-8?B?Wkg4dmU4REtIVEY0S2tYclUvT3NmRVV2U0YvL3Q5cTFPQ0pQT3FjUlA0bUJW?=
 =?utf-8?B?M2VkSmpjakw3SGZUeUhPLzlZdTlsRHR6YmdROVRYM2NXdDRJSDNEQnlOVjVR?=
 =?utf-8?B?NHA3a0VjdDY5elFBNzNLRUV0ZVgrN0ExT1pVeTdhdzJwNTZMR24rSi9kNDlt?=
 =?utf-8?B?eERqdEZ0cXY0Q3hhMGg1VzdSclpTdkVrM1pTT1dEN3R3ZnBCazF0U1JLSzRB?=
 =?utf-8?B?UTBXRVMycXBkdjdNQTVCRHE2SDAxQVFMT2dRcFlTRmt2YmJzZW9TbGpaZld2?=
 =?utf-8?B?dUFRTjlNTkZEQzN5am9GeGN4TDYwdTBGVkZpTTBKQ3l5b1FudmVqVHQrRVY5?=
 =?utf-8?B?WXppSnB5RWFqdEtqbUg2bVpvRGNBUTYrQUJKZ0xwNWVSdStyVFB4MmRkNUJ6?=
 =?utf-8?B?U2N1SVBpTk9uMnRYMTg4akh6dEl2VEd0SzVUNHRZWEV6RCtBR1g0M3NoS2lB?=
 =?utf-8?B?VWVNWkFiVWozLzVoaHMxQUNyMFQ5eTFQaExiM09JQitwSlZXeXJmbkRoUjFQ?=
 =?utf-8?B?M2llSG8xSmdmaWs0TTdOcDB4L3A1amE5SkhCUWdibnFHdm9VOU8reWQyZ2xq?=
 =?utf-8?B?eEUrbG56cFVuQkpSWms5TEM0UW1jWVRWekJKQkhaaUpsY04rV3VNRUNSWFBR?=
 =?utf-8?B?L1c1U08wbmRvK1h3QnQ3bHNiL1RiZzRSTWxkVG92aGh2NlYzdHBuNWRyL1Jo?=
 =?utf-8?B?YTZFeURXc2dUVlduamxyYzFQR29DUis1Z0hxK0VqNUUxdTdFVExqMkhvSlE1?=
 =?utf-8?B?Zy93cGlQK200V2xGWVpDYUFFNTZsazRtaGx0UldSWW9DNjN0cFlRbTZyNlZx?=
 =?utf-8?B?aDZlbmorblN2aXQyaW8yelI5MHBvcTdIbkRBYmZPT1BVTEJwSmdIK2NxRXls?=
 =?utf-8?B?bm10QUNKZDJEZHU5K0h4c01qczRDYUp2UFpSSlo4OE12aUt3TitnckFtcmM5?=
 =?utf-8?B?SkY0RGUxRWI3Y24xc3F2Y1BTNmFQMkF3eWMybjJMai9DQ1ovVGFzdkpoM0lw?=
 =?utf-8?B?V25FcUp4MG52Q3hiV3pEbGZJU1cwM2tQdEtyWEkweGx6bEhrVWpzNEYzSmdU?=
 =?utf-8?B?ZS9ZTVZaWVpvQjk2cUxtWjgzRVljL2tuaE5vZzNWc0NZV0M5TkRWenNSc3M1?=
 =?utf-8?Q?/ufX1AaUapeVarCn5FKz0EyESC1uFKcq?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 15:00:10.9832
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 331681aa-8fa0-4cab-838d-08dcb17179c5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F43.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8773

On Wed, 31 Jul 2024 12:02:57 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.103 release.
> There are 440 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Aug 2024 09:59:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.103-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.1:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.1.103-rc3-gdbbffaaee188
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
