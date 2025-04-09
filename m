Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBE925A35E
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 08:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185816; cv=fail; b=jFsQvX/pxk5AuLBNpSQA35h9iz6H7nPmAx5+xVfmPztifn/LNqhdJQZUAHBLQ58vtJUAD4CjuEHz0HDaGQx/OgH7v5IM9l74RFPZCcCIw/j738kUhCBrxGRfACOidEbYQRi0j5ZzSNTuR9wWI1lenySdFrYvEzxoN4xLhJmnK5U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185816; c=relaxed/simple;
	bh=wS/Wfq1/8HGAeVqTVKir3YypvLbMrn+V4KPuXW5Vqlw=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=hbHoakpDt4Zt8LRLZqgxY5wWrQ7ltKSKSssCSZdA+u3B1UC07dV9e0FVXxJsRIgct2DOa0sqrt85bznUmyqMkel17ZW/TLpr6XTfZznxd7IwlDKvO8bvTnhp8yQKoKWlj8lEK092CnEoJu4Gm+OkHyyNHHPpRFinoLKUOmyUxWA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EzFSiAbQ; arc=fail smtp.client-ip=40.107.94.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EzFSiAbQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NfEjIzVpxCyVh409TVgVgKVSRP6yKOaAl087VEV+V27sA5n5pt4f6rNi7+KyftJIauCu1cbxlcJugd6c4LIiLaLZXgcviqgwnV9PRP95I4ses2mD0WYIiUCM/O+LQvbqWxJYtWQYLRC6h1FxSi17A2dzYEvMsljXBJm/v271PyfPrmh/+LI4aDTA9YqMpu5sD8bC28R+84t09hp6Lo2QznRd+SbRPsT61ohpBt0XMP4Pgmt6pleRoivglfL/ZLEgq8tv/Glxq3qi8inWhqgk7NW0x4oD7kqCpoYczMindlAwzt9hOGTfaebQjMEs6PSpSQT5bXu4XiOXEeVBscStGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4d2dikghj8mUgYqCWTnVGJwHVGnKFqVBfrBqQ5AwIxU=;
 b=WYIXjlgg3z8p2+kHjaiLav/SKBhZmllLOh8Lp/6LeE++QaGWr/bBrPcVUAljvibCeeRh4fI+VDEYl7/Q2k0Ne1nmQSSQnY/uWrISelotsisK1Aam62kvoBG2xZ/q6yq5EcJ5ePANqKID5IV0XDaKQEldtficJuX3lIsNzs4yRsd8Oggm2Zh4Mjq08eIgCmGIo74US5AihQPpqhHJ0OEFlXKLUtnbXx5FDtLhyePLJh0tkKMMo23QdneueTEHTxMCZFuCIwag8En7Y6KSdRO92flWkR3ldoHoMLf0mpjKsBBVVLpGgUM0XaslB7EmcSGZB3LSRbg5FLQNec8vmk0mwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4d2dikghj8mUgYqCWTnVGJwHVGnKFqVBfrBqQ5AwIxU=;
 b=EzFSiAbQiR+LXNc26AqGw1DzW2NRF6c2DXaztBkLzNK9lifbppJ8EdANr3bHANyymTRP0MOYzaY/zUFFtI0eOGTJLvuANjfudS9koBWKH/9l7RRLKE1kQhXQsz9D6C49EB4ZGHPekxb/ICVW0wqp8UhqtHnGzyN6lXQVKYNE7sgMIhR2mDrFzRjiOjNEKgTch81gjRJMH+xif8w/ZEDPOt+jMxVePsPJUbXk1kAFj6tUYCo5wBv+IARBJNsjtfS5QqrwSw9hCZm0RRKCpb5K6/1kQbVJK/wWq9O3C+6l7Fl416RAA2xFyV9axSIPHLDOzB5I2gSZqOQ5KbGSxlvvAA==
Received: from CY5PR17CA0002.namprd17.prod.outlook.com (2603:10b6:930:17::22)
 by SJ2PR12MB9238.namprd12.prod.outlook.com (2603:10b6:a03:55d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.21; Wed, 9 Apr
 2025 08:03:30 +0000
Received: from CY4PEPF0000EDD6.namprd03.prod.outlook.com
 (2603:10b6:930:17:cafe::61) by CY5PR17CA0002.outlook.office365.com
 (2603:10b6:930:17::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8606.37 via Frontend Transport; Wed,
 9 Apr 2025 08:03:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000EDD6.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8606.22 via Frontend Transport; Wed, 9 Apr 2025 08:03:30 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 9 Apr 2025
 01:03:16 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 9 Apr 2025 01:03:15 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 9 Apr 2025 01:03:15 -0700
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
Subject: Re: [PATCH 6.6 000/268] 6.6.87-rc1 review
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <797d9a53-652d-40b6-9e72-885c9e4ebbcc@drhqmail203.nvidia.com>
Date: Wed, 9 Apr 2025 01:03:15 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD6:EE_|SJ2PR12MB9238:EE_
X-MS-Office365-Filtering-Correlation-Id: f329282e-7adb-4dc5-27b1-08dd773d0449
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cXZ0V01BV2xuYmdQYW1IbG9SQzdSZ0xHRWlXL2xQRFZqMXhTUmhRZDAwV1Zy?=
 =?utf-8?B?em1mcWo0d1dBOWN2NEt4QWhUMG5GTWFmOHU1clRXcnQ1OFJKR0EydkJrR2M1?=
 =?utf-8?B?NlBWb0x5VDloL1JwY3pOMElEVGZPV0JwWEJUeXZJa2t1MUx0WFFDdkNmUHAy?=
 =?utf-8?B?cGZoTjQvQ2JRdlJZVFdTT0JJWHRNNDd0Yks2M0htdE0vK3ZrYUswU2cxWHIx?=
 =?utf-8?B?cDh6MGtpbXJFc0JKY21zOVRPYTZXazJ1T0tSSGk5TWJpcXJIcEFTM0pyS01u?=
 =?utf-8?B?YmtMNFpXVGxNZmhFL1QxRmk5QU9wanpNMFJXY3I1SFBQRHB2T1dseDNTaUVr?=
 =?utf-8?B?M1pRS3l4TEVSN01GMFk2ajlZNnZQUnJtN3pNcnZ3MnlSS253UmZNZTU0bGtW?=
 =?utf-8?B?NmN0T05aTDVRS0lHbHlPd1V3d094eTlVZm43Y0FtcXRpckRBWWdDcHpicTVV?=
 =?utf-8?B?eWVSdkFTaG1nZ2o0UFV5MnV5ek55ZXF2bE13VnYyWlFCdnhORkNCTWpTSS9P?=
 =?utf-8?B?c0NxVDYrY0JGSjdObTNuYzB6Q0llb3o2M2dLRXAzbFhzUUhQTUxSTzE4MlVh?=
 =?utf-8?B?OFhKUkNHUzQvTHVEcXdpZHphcVZ4TUlMcVZmb3dMYUJhcngzSVhZZmZGb2NE?=
 =?utf-8?B?UHZ6eW44SVNJU0o1Y3YrVlN2QnBpc0Q0djNYY2RLMGoxLzExTEd5d00wMlp5?=
 =?utf-8?B?bXBDVDc4SmNsTWpuaFZ0OGN1MytkSVA3dmFjcHJ2MHJ2aThzVGlnOHB5RllO?=
 =?utf-8?B?UldIU2NPUXBzU1BPWjh4S0U4SGtIUGJqaExlK2pMTkpidHJOUUNubCtzQ2Vi?=
 =?utf-8?B?OEJxNjkza2I4RVk2T3JoSWViSVk1b3F2bnNHSnBZR1RHU3J1eXVLNW85Z0Vs?=
 =?utf-8?B?MFJCV0lmcVpoVVJxT0xlcUZvRm1wS1dyMENYZzIwaFdqS0tIS2NnL3ZsUUhQ?=
 =?utf-8?B?NTZ2K0JYRGNvK3JxL1Y0d295MDd1MDBSQWV5SnB0UFJpbEVnZmlVc0Y5WDFt?=
 =?utf-8?B?QlJ4T0cxbzJkSTljdG55NTNQaXVvYmtHakExcFZ2UlNPTi9QVnA4SmhRSWxQ?=
 =?utf-8?B?YUdaUHpWSXBuUGZZdW9ZK251L1FucXIzQUJycnhFTzVneWJxWXByNDlSWVdq?=
 =?utf-8?B?Q3B5QXV4TjNzKzA0S25LbXNPVExCazlGUXlzWFR6VklwT01mZUV2RU5sNkk3?=
 =?utf-8?B?TGRaZFFZWFhSUzJxUmM1QllkOGM2RFArRGFEMWpIZjZnb2owTnVpUVZ3LzB1?=
 =?utf-8?B?SlJyREV4TFlsSWZVRTVDam54Z1pQYlRuRXFFNkFPRFZ2R2lPQkF1d1dxUTB0?=
 =?utf-8?B?ZzFKQnNZdjFYdjdvOEQxbUpoNUUycWM5T05PSjBBZzlSSkhEY2x6OWlMYjJm?=
 =?utf-8?B?eG9oZkNNbGVGZDlKbGlhTmU2K29sUHhyOHR1THh4WlM4elJvcHZPbU9UUzBt?=
 =?utf-8?B?M3grN3JGNDJkTzlhZmUwN2tiWnN2M0s0WUdQMm02NTM3WWpmQ3YyOXdTeHFl?=
 =?utf-8?B?L1dBaGJPNFhKM1lDaXFJME9UdC9udmFtemE2RmhwV2g3dmk3cWF5TnpvVkV1?=
 =?utf-8?B?T3RocUw2RnRILzNtbnNrbGs3NTNCbU1mSnAvSVpWcmRLUlVDdzRucEY4S1p0?=
 =?utf-8?B?S0FXRGVQakdvYnJNTGVGM1k3K0F2dXhQT1R1aGpJZE95dlRnaGJiS2s1WVZB?=
 =?utf-8?B?N2dmT3dWR3NsbmIxRjNQOG5vMEI3RHN0aEdCMmRhc2hvK3ByallyeEQvOVkz?=
 =?utf-8?B?L0NxdlRPVGxSdXcxU1JjWVRtUUxsQ3RTdGlNVitoWWtvZGVUalo0a1BkV0ZO?=
 =?utf-8?B?UUxzeGkvMFNhNHZiWE5Yc3drUXVzVE4xdm81bW5WM3FmMEJETk5XNFJ3MmNy?=
 =?utf-8?B?NUhOa0pQdmt2WjFYQ3Y1ZzByY1lUQUgyNXBHdTNmQUJtSEduRG0yOHE3ZEty?=
 =?utf-8?B?RjNoVzRpTGlNRGEzR2ZsVUI2NHphODlpbHpONThibzRRY2VaQ281ekVhbjZx?=
 =?utf-8?B?MmcrYUw3ZFJTLzJFNWF6WGc2dGxoMEFLOUV2dVFYZmJsdm5sZlJtQlRLWEVZ?=
 =?utf-8?B?MzYyRmYxR0c0b3NDTlRjWksyc3Vra3ArWXpudz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 08:03:30.3998
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f329282e-7adb-4dc5-27b1-08dd773d0449
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9238

On Tue, 08 Apr 2025 12:46:51 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.87 release.
> There are 268 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Apr 2025 10:47:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.87-rc1.gz
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
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.6.87-rc1-g5c3c45826e66
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
