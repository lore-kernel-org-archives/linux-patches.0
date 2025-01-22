Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832E6213223
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 13:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737552224; cv=fail; b=t9QuBLX8J3j3GD+hWi/9yPFCCc7JZmzawgy1mrDna7Tu882JK+JkxkE2eXAMe6idS9ItCc18aMk1DAfpplB0+qd3PldfN0zlmWFnjiRvgPytOAdrKdp+wmne5wubCCqaCGawG9zR/CQJARSRNunOirRU7CbS8EmR4l2eUPvfB5w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737552224; c=relaxed/simple;
	bh=2RSlffEATYnzr+ihI/UrkdP1KKhT3AWzyYzbR1XVtu0=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=nbHuf4Q4LVh5gdk6DBZpt1F/Wq0N93dOt68K9xKhXehhxsG2zriiR6VuGIe7ABvM2VRsXiEs7+PmTR8WOWOw5ACGrq5U922jOMsR83wLZ8gvUGcUxbcR/of4ZMRSXqVco297fGCkKc9dDIJCvaHmdaJ4q9yMdbJGc9p6PL9pel4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JxwkpKVu; arc=fail smtp.client-ip=40.107.94.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JxwkpKVu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=efe5AcsVRGWxr/DXUhmdAzx7UrOSXZ2VORhbyEDoHHk1o4fbIrS4+SpRi1vJno+7xDGUUXRoRy6D4cAsLBlBRv6h7JH9Do/W2Q71uQlr60A3l/CG4Af0fmfIglpw085i7FwCqggkayvJjCyuwngx+3wnbAYSi58X6B1YrAd6zAnq70KBPXQ6WzcxvK4ZJua35ZIPmwVpyFoGYb8M1q0FQCUUs0Nw7Ud9b2k3e6zkskSZivDDanehFT0qhMFXX0LYTGiIXOhbJdCn4/xr7iSYfGnSLAjABGb8sgsxwJxlJOQkqTf+3QBFUfyRIxyrjqa75J5GU8QKEkOeXsYNpzGc2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jNO2qgkEEZt/sRm5XaPL9wCf4Gzn72Fp1l7h2Cs6+9I=;
 b=R6EPV/4CmbQbc2nj+Dil8RBc5ZmfTWZX5FMUr3jebuvAAdvgxsHv3FxDsv7iEA8zhoVNCcoC0y4n9qdmIB3DpZsj3zN39lQwaUtlJvcetlebt7mAJ5Na5+o1KVLEdhMEZwIXIfblNCyeYYLTbhoTMjMYSIjYuh0LnJFFWEuXhlILZZb9X+bSjWQn4z2vaksm7m+PAaqC0p4imxqp8zEv0FkaOFrBTR/Nq8u7Vx9MTp/EkQCOxaR4zQYaQ1bZSpThiRyba9tCqFfKwUQ4GHCTpPXEYr/y/mj5kAAJAIw4RQG29VQlwvCOlyUbV6XwKW0fsq1k8Rv9C2Kri4TMFNSKUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jNO2qgkEEZt/sRm5XaPL9wCf4Gzn72Fp1l7h2Cs6+9I=;
 b=JxwkpKVuipfamIgWArT/N+lyFZQgOhEb2jBksYphhfTkuefKVM5Eq39AhB/JVo+JCADyh4bh2RxUxUabDOGSGMOpvF5gx2hO/wH0zG/4XNkLwFj7woL8DNsFV5rQUGTqFsx1qYXA7Y1+eRKu031+asAhxQ9OTk4Z88W7+8rgSfZdxc8a3Y09k933ppC2JuUG5xIRLiy5LIdfZ1h/tgBssE2FPQLjfnRU0V/jzm9Rk1Yeyu28SCo6qB/R7WYMFs0rOSFZ2d8nJEz8mvFRgi4IfTTmrYNuPcbNXFLEnhuZ6UuW9qxMKd3c6EWeOpU2RnxsuXzPk/qnVmbCUEIIOYs+NA==
Received: from BN9PR03CA0764.namprd03.prod.outlook.com (2603:10b6:408:13a::19)
 by PH0PR12MB5631.namprd12.prod.outlook.com (2603:10b6:510:144::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.16; Wed, 22 Jan
 2025 13:23:38 +0000
Received: from BN2PEPF000055DB.namprd21.prod.outlook.com
 (2603:10b6:408:13a:cafe::fd) by BN9PR03CA0764.outlook.office365.com
 (2603:10b6:408:13a::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.14 via Frontend Transport; Wed,
 22 Jan 2025 13:23:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN2PEPF000055DB.mail.protection.outlook.com (10.167.245.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8398.0 via Frontend Transport; Wed, 22 Jan 2025 13:23:38 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 22 Jan
 2025 05:23:29 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 22 Jan 2025 05:23:29 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 22 Jan 2025 05:23:29 -0800
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
Subject: Re: [PATCH 6.12 000/121] 6.12.11-rc2 review
In-Reply-To: <20250122093007.141759421@linuxfoundation.org>
References: <20250122093007.141759421@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <098dcd76-81fe-45a9-b7bb-320a6cde4bbf@drhqmail202.nvidia.com>
Date: Wed, 22 Jan 2025 05:23:29 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DB:EE_|PH0PR12MB5631:EE_
X-MS-Office365-Filtering-Correlation-Id: 05085fd4-f0a7-4fa8-8eba-08dd3ae7fb2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MWh3cS9WMVJKSnA4UVhHYmVySjdUNWgzRnRJdHFDaW81OWJZL0Z5anp3NzRK?=
 =?utf-8?B?R0o3RWhGVmM3K2FsY2Z4T3RyZXVUaExiNUU4d0ZoMERqYjNGMGNpU2p1emlY?=
 =?utf-8?B?em83TWg3cW51cDFlQlRnMWpmZDFUOHo3ZzhSdzVhUGhldkpIbnlUNTdwZHl5?=
 =?utf-8?B?MWl1dlcwZnRzczJHM1d0dFlVRWFvMk84dXZHUzRvNGhMWVQwdE55Z2VZWWFI?=
 =?utf-8?B?SU1COHBERndCY0NiY2I4VFVPcnB4b0lWRjlGamRpY0UzdUNOS0F1MWpnYWJx?=
 =?utf-8?B?ektacUsyU2ZoQ2tpZGhJZnpJaWRoc3NPMjViSVprZUl1UTM0WEs4ZTlCRmZV?=
 =?utf-8?B?aUFpRStrVDBROXRJcVlySndMZlpsVXY1aDlMS1BzWXF0Z2ZGaXVWblJOWnhL?=
 =?utf-8?B?a3lHMms1SjM3cndqZkgxV1JaQkpjaER2U1JuWnJXMUNkVDQ5N0xrOWZmWWhK?=
 =?utf-8?B?dElOMFhzUG5kZjZoUGtETHJWdUZJaklZQ3A2V3RWZTlkUjFFTGpYTjBCK2xr?=
 =?utf-8?B?UkU4YzI4Z1UwM1VYREpWSVR5LytzWFpXU29DTWxtbTNRUEJSazNBcURDcjBr?=
 =?utf-8?B?cE1zOHYwVmJsb2ZmWnlkNXlUMVZsd0x2OWZDNWxtczJRSUdQL3BBV3dxdHdH?=
 =?utf-8?B?RzZMZUtRZU80VEpmOVpQTGZMN0xzd2luZExLYUZ2MEJCaElCWU9acjd6aUkr?=
 =?utf-8?B?R3lraDdUTUxqQXJxbmRFVFdCaExyNUlUUmV6azYyb3dVRWxBakJXNnBUbkJp?=
 =?utf-8?B?a1duZEFXWHVkbU16NnBnY3p6VWZqSlFjZGtmUDVzN1dkQWlSNitCYkkxM29H?=
 =?utf-8?B?eXRJSWhSYWZyZmxLN29KQ2FpZlNGVnBMajdVbEYzbmhaUVU3NUJsWWNSWVh4?=
 =?utf-8?B?OTlSUHNucklrYVIvNnl0eFE1SnRWTTI4M2NOTGZRc1c3Zk84OUhFeU9nb0ky?=
 =?utf-8?B?MDEvNmVsODlMRkszdjJzT1I3cWtxQysrZ0t0NmZNWWkzZ2lIc1hVUXRkRHBm?=
 =?utf-8?B?Y014MXFMdDcwcVljQ0NTWkhyRCtndTJJSUxSOWpra1R5M0JXQ3pQSDNvTG91?=
 =?utf-8?B?UzNoSnp3ZDhuL1o1Y3JFV0hqTmk2TG5GQzdTT1FrR2hQL3lPK0twcnpyd0I2?=
 =?utf-8?B?b0hUM3gvWTF0UTI4S3NiM2VoUnJxcjgzaERqUGZBMlRRNjhKZnlJM2x4TDdC?=
 =?utf-8?B?eEdBL09zMVdPR2J2OE5ad2F6cHZwY3JuZ053NEdZMmVrdlpBLzM1aHlzdDMz?=
 =?utf-8?B?SXFsOWEva1pFWkM3YmpoWHh5K3FFRmJxYytQUkUzLy9DVXAxZk1hanEzc1Ru?=
 =?utf-8?B?dFV2N1pvbG1NVW1ZbjhSNlZIc3pReU1TVUQ1UndnazRjaGF0MmFKTmJ0WjN3?=
 =?utf-8?B?MkxoUjFLOWg0ZVNzOFFUVXpvMlBnNGs5OUF5c0hQU3FiRGJzS2xHSXREc3Ju?=
 =?utf-8?B?SmhtTGMxbzkvSlhlSlVubG0rcWtndjM2bGtkTVpuSnRtQUNYTm5jY1NzaGtv?=
 =?utf-8?B?NXIzYTY0R1JvZWlHTm9VdHJhYVI1dWlPS1dHUUZIU1orS3pJRXlpUVpzc20v?=
 =?utf-8?B?SXFYYU9UTlFHTjVrRnNWTUxqM3pCRzErbDdRK2pxeUJiaTlXZXRZQ21tZmJ4?=
 =?utf-8?B?cjBhS3ZuR3RFWUxmQS9CNzZBcUJIb055WDZRQmk2NFByOWlaTVVZTklsVEdk?=
 =?utf-8?B?OUJucUh2cTlJa21NSjBtek8yakR1SEpyeTVxT2tGaVhpSUFIOG9PbjlHY0o0?=
 =?utf-8?B?NXltT3NPMW03d2hSUEZoakNVcHlsVHdkZmpZL1RyYzFTRjlJbmk2VloxNzBK?=
 =?utf-8?B?VzlzRkNCeGIxZzV4V1hGeVArMEJHckxEajJFcjdSbDFiaFI0MXdtT3ZtbzNK?=
 =?utf-8?B?dW1ocEdLdkdrcVEvbGJ6Rks1UEViMTVHVWtpTmhsbG45QmxWUjRaUmpTRXV3?=
 =?utf-8?Q?F2NYTMZcmSm4ZNUlKaEp2UchJfjF7ZE7?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 13:23:38.0526
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 05085fd4-f0a7-4fa8-8eba-08dd3ae7fb2d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DB.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5631

On Wed, 22 Jan 2025 10:30:49 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.11 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jan 2025 09:29:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.11-rc2.gz
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
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.12.11-rc2-g0bde21f27343
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
