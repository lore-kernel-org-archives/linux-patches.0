Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0264A18C929
	for <patches@lists.linux.dev>; Thu, 12 Sep 2024 07:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726125594; cv=fail; b=GMFs/RzAOxa3QRkxKmQWN5WjEJWmdH2pkbMJ8dx8JEpmk0zgMh5ZMRbktvF2Zn8aQHpqW5GQ7fKWb8x4TffoMQiXyaLBVbH8+mAGhtu51w3OhOJYwJ84zVwOcI328N3LLlhEDd+uyvNhDPiqbqGovMnEb1kEJkjLVTiEVEDfjbg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726125594; c=relaxed/simple;
	bh=TWcUH//DgS6Tfn4alnYqGslIMseCPw3VYcSOc5A3AVY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=bU8Q8U7I4FZjrM/TKObu6drU/ynJg2cAafpMtqYaIGT+nv23vXM1JR5ueebpQ9U/fDlioNxi4G8LGsQNkVMcGsabukyoJurl0md9q1bOQNOQc2JpJCZcmbBsHR9wCkwOku4LayH5NpAmdFARj2io2g2dUAbzNeTctJXQhOzVunQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nub2rbL4; arc=fail smtp.client-ip=40.107.243.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nub2rbL4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mHWGi3jgSqDB3A65RFXkvRfBJQHnCXtnvjD0IzwpuzRQ6slZV2e1ltAqhB8tyMzvPUhdNa1jrwTVFz3DR3Cm9MbP9+POQq2iSSsbIUFFBMgdfOI6CECAU1aWzdSE7pR7jV2DlJ9R/9OrMJ1/39tu1EPkprD+iTrqF4WqoM/x7f0YvroAB5LjPgmtAOV4vYPcrW7miQ+hewhfPd3uJVYHCb8D0wjzsbORRayAtOhSpH6c9flbG1Te+9fE6fmdXEm05Dz+bsIr1kWYENc23kJeu/AjZUxyxdWKcFquzVGvwcm91x+cZTc5wZKyQ83rR4hQWjd5/roE2VjdSdnx2OlmBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jSOkcwRNFzYpMgxsxzbqkDSeF2YeIY0D6Rs7I5GCGcg=;
 b=OWcQZpVNIkp036T+clVvmS8D/85glNeOCZ7jhgD0bDcBpcRr3AQbZnWK8cPkwNHvse486s6wI1lgrw+mFfGH4T/PQgu6MpBKg7wR+iw5mgvyVayyXLy7Su2lyEpzmuS5WcCP2L/rm17T3Xhu0iZFamUs4Wk1dSEcOj35DFXEsEJORwU93GcrgrjCP+EwkOobyC7yLx86m6aldCfIYMkh+3Bd+GnCgiSURKnBCaxe3vnnybUEikg0q/kArMhHp5AMIq0e6e9zgqnZWgTwMDm9goyA9dXWAIA3ThEKed17VQxEwS92r2pvYrGp1bjXZOKfj5dtXgDNwfGZ2xD/VtoQtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jSOkcwRNFzYpMgxsxzbqkDSeF2YeIY0D6Rs7I5GCGcg=;
 b=nub2rbL4uJYi9BPovXaa0Mn/eGQxeQuyv4t2LUk/nlBpS2DLIfG2uvUjdcQ8WDydN1x4O8cQtFmAgYuQT7Kn3k/6xBb54CoO+/Bwqy//qeBQbIjE8sHODj/uP7XLTIJfnweSX9KGCNrfPmYZsA8RFwJTjCsgun9t6qYFt9HDinpIhn7kUq1Ox43fOZdbgix2aWao4LLKBLGhSYy7OvWiU4GaRnO2aBHSn6b284pjrxExkgLNWQaWHuetC7jzJ8iZeZ6QXkCz+eRnWMAG/8wSo7PZzyE+VVHG42VyaFMVzffX6vo/8ufDSwTIO5KpjV4dxgz2HqcKEiZDv4ovj1tDBQ==
Received: from SN7PR04CA0166.namprd04.prod.outlook.com (2603:10b6:806:125::21)
 by CH3PR12MB9122.namprd12.prod.outlook.com (2603:10b6:610:196::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.18; Thu, 12 Sep
 2024 07:19:49 +0000
Received: from SN1PEPF000397B3.namprd05.prod.outlook.com
 (2603:10b6:806:125:cafe::48) by SN7PR04CA0166.outlook.office365.com
 (2603:10b6:806:125::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.25 via Frontend
 Transport; Thu, 12 Sep 2024 07:19:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SN1PEPF000397B3.mail.protection.outlook.com (10.167.248.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Thu, 12 Sep 2024 07:19:48 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 12 Sep
 2024 00:19:48 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 12 Sep 2024 00:19:47 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 12 Sep 2024 00:19:47 -0700
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
Subject: Re: [PATCH 6.10 000/375] 6.10.10-rc1 review
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b0810572-0357-4c48-ad0e-d38a3e70016b@drhqmail202.nvidia.com>
Date: Thu, 12 Sep 2024 00:19:47 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B3:EE_|CH3PR12MB9122:EE_
X-MS-Office365-Filtering-Correlation-Id: 573a62db-6745-4a5a-2bef-08dcd2fb4961
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OTNmRmwvaC9YVERXZXdNNlVVQTVwQWJ1QjhnbUlBamV1NTI1bmFUS0ZRNWtM?=
 =?utf-8?B?R3pLN01YcmtiTTd4S1dMQjNLNWhQZWlZUTVZUUFtZ3MxU0N1aGJpTkNrMXBD?=
 =?utf-8?B?N0xDRWdXUnVsRTJ5RE54V1VMckJNa1JZZzNhaGJCS2wrNVJ6TUFnMnVHd0Zs?=
 =?utf-8?B?RlpDdm1XeDlIbzVQN212R1kybFBBbklBc1R6MlNrSmtaMGJiRWwySmlZaTlN?=
 =?utf-8?B?c0Nrak9SWWQyYlNYWkdNWVIxNkltamJ1RVE0c2tuNXh3SWZSRjUxNUhtLzVT?=
 =?utf-8?B?blFtbXQ4ZWhVS01kTFRycHRwM3NINlNVWE1uTDh4OUk3cTFKa0liUlV1UGUx?=
 =?utf-8?B?NG1aQURtaGxwVTVCNDQ2ZGo5VHkxWU43MVlkQmoyMDJJdWpwUytvNnBob1Fv?=
 =?utf-8?B?Ym9xK3kzMnNhMXFoMUxGeXhCOXlQWExqRTFjcGI5SGhvemNhT29qWWloRFJG?=
 =?utf-8?B?ZGRGRUZ1bmVjK2tucmk0TjlUbE9GQS9FUXh4US9LTEQ1MXExWm0zL1A0NW1E?=
 =?utf-8?B?Yit2TThnU2hZbTVBeGFrUmdrTmhJRnFNRmhpZmxQMGZOVFNiaEZXQ0loZFBa?=
 =?utf-8?B?VVI3S1NSdmwrZXRScVFtUlFyanhMNkJSOWdVZWxpNUJ0ZUJ3bzE0dG5CZ29y?=
 =?utf-8?B?Ri9IMVZOM1Z1WDJ5TkZxU09lQzlodHl3dzU1UXErTTZnd3JRZlJ1RUhQK0Nz?=
 =?utf-8?B?bDU4UTRWSkloZ0dGcWl6VlNjNW9QRTBJTjNXQ2tCSlpHcStxelFCb1RDdENt?=
 =?utf-8?B?dFNnWXo0ZFAwQ05FQlVtUEg3NFNjdHdNYWZpb2dDOU1QamEyUW1PeXF0Q3J0?=
 =?utf-8?B?dTMvUGZNL0R0MUk4UlBMMDFIVCt0dWdoRDh3NFBaNjdSSUc2bXJKZk90RURQ?=
 =?utf-8?B?UGNaUmhkL2NRUmY0Q3FyQjlTMS9IS3lRZ1ZrQThiQzVybUVqMURoZG0wNkNN?=
 =?utf-8?B?UEM3OUNUZ2dYdlhUME9mckErNk5LT2wzY1NXSTBlcnNTc1FmNlFyT2ptWDQ0?=
 =?utf-8?B?cGkybFJOb2p3SFU5dWhiMzNwQU9IenA1bFNqYWlHNFdzcHo0SWcwd2l5NlAy?=
 =?utf-8?B?eHBUbkUxVy9USUpkamtYWXpudEZ4dFlXeS9pREMwcjJRRzZuaHVmTDNudDBM?=
 =?utf-8?B?T21iVVFrVHBRUW5HVTY5Y1dWNyt2aHlCVUl5akFvaU1IV1lUWXFiSWFSd052?=
 =?utf-8?B?V24zNXJiMWpVbHZUMG8ybUhJS0lmdCtKTHBvYWhYVDRSTDZhaFdwSzdBSkhp?=
 =?utf-8?B?RHV2elZ1cHVBNm03ak5LbitGcDV0RmxUYXR6WUVhZFZuWnRqUTBkcGdOVGZv?=
 =?utf-8?B?dmZwZEhCdHFRcm5NUjBEbDREd1UvYWdEVnlYbEFaTGs4OVZFZWRxM3FoR1Bz?=
 =?utf-8?B?bThkS2ZBVFRRTWc3dm1HRHhIQS9NVmlRejhYcG1pY0JRTmF1WmwyNFFwVFZK?=
 =?utf-8?B?VVlTc3RpME1oSW5Uc2o2UVNaWXJmQ0lEYU9BSTZ2bzV0clpiTFp0a0tLeXVG?=
 =?utf-8?B?V29wK1VJaFN4OG1hbzlxWWx2T2E5SVIxUm9EbFpwdEhDREw3b3FtbDhLb01u?=
 =?utf-8?B?QXRqZFA2UGFXUjdpUEM5Y0dqVkwra1ZHd2V4aDc3RWNlZDNIYTlnMEJDSVJv?=
 =?utf-8?B?emo4RkxTYlZsTUdhcXhUcFFjeXVtWVp5WkhLR3lsMmxHZ1cyVGRTUVRWT3NB?=
 =?utf-8?B?N2VEcjNBUlVTMWNwN1dmNFBmYVNHN2x1RVlqWDhSYnltZ2VTMEFybUk0NVF6?=
 =?utf-8?B?eUREYUVnUXdKV1dBSW5VNXF6WGlEcVZpR3dhRElGcDJ6Q3B5dFg5WkpNQjhl?=
 =?utf-8?B?anhqMVZkMlp2Y0V2c0hBaC9vT0JoS1YxdnpqeXdqYmNzWjZJbDNuTXNsTWRl?=
 =?utf-8?B?L3AxV1lFRXlsbWhFYkErUWlOMVVobUl6Zm01SXhIa1BqKzROUXV3a0hqTThu?=
 =?utf-8?Q?8i5MjpRYrg3JxxXmfxSe44sLRBBsLJrT?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2024 07:19:48.8247
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 573a62db-6745-4a5a-2bef-08dcd2fb4961
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9122

On Tue, 10 Sep 2024 11:26:37 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.10 release.
> There are 375 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.10:
    10 builds:	7 pass, 3 fail
    20 boots:	20 pass, 0 fail
    98 tests:	98 pass, 0 fail

Linux version:	6.10.10-rc1-g8f68b409002f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Builds failed:	arm+multi_v7

Jon
