Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010040.outbound.protection.outlook.com [52.101.193.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CA331A572
	for <patches@lists.linux.dev>; Wed, 18 Feb 2026 08:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771402990; cv=fail; b=ikPRt40ui8ezV6kHiVbdKevjVVywMpaG+LM2GzplSx9Tto4TOxM6FsVoawuo5UqFgbMuL1cNGemP7wQ9bqRbkUVcUwc50nuARnjTDlO0qqtKKFxxfOjvaDriV3XD0exbysoBrgve2M4HQ86WeKCQ8H0pIVslesNKYNr5tYrs+Tc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771402990; c=relaxed/simple;
	bh=f+CQ0IEXHmVEjkyNCtFk95MyiXjIE4m33mW1phX0sl0=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=N8o8rdR9ZXBpDCbbyQW5i29vnA/xJDx7RIvJedFQpUK09BBYCxw7ZETGurWTtJeHFcfm7Gavf3ip3udzYfZzQ07TDC2+b/UDwIHhxenAg5/mamWZCwzL9s3D+Y+4O76/B+ZqNNE7gJcVZUvrWC2U/zR1iivqMUDfmkXlccb4/Do=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BZKfXWqV; arc=fail smtp.client-ip=52.101.193.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BZKfXWqV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SqKrTZ5a1ECiIDQOwPibd/N3YiVgoon7Z6rpWR37+ufoCCGPvUXeC0O2mUyviZA+Pyh7Czxq2rrMciE6cK3gvXX4+2TIV7vh3Vn6ChM1ntEjmIFhbbGC+qxOXdYC/AXt9gyLQOMYpwIT/TXDXwbw/D3/UsT+Kfh5U49558MM7Jt4t+liGOxl1XWQx2Y1Fxg5tf7l+77V8L/Ksuzo1kOTepZRHx5ZvdfPAUCkcwqlHzGticJ66iJyvgO6FY7wDNLMr6XnPtVtVDhwhmS9aVX5Hvxa5henNF7u2bEGNbxCxawRP5oGgIN386W3uS0/rusMEOxyilWyKNPoM27lEdA/Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9cS/0yNohYPOGkn9+epXt7+uySaliyvL1qDlQG8pTM4=;
 b=ckAamw5+21r+32M3y4BNWszjm0hSlnqpE+0VAOTvbJNAXJTt9MhNC1mtKN6FJaLVqF7RljPqonoSf96eoRb7tkX+DcbL54Srt11mismQGe1U5dHcUPsp6cj0sSfm/ANNMZcOWisz0HjbxS2OZQ+BqhU1xDxun9wu/mU11N+EVtDO6cZl4cL9pTGOXDY1Q5bqNGhlFvQ874owroGOnmzhtnF5qpUFTYQ3wtTwTqChAWyLWgkDqhc/GP9n+fFSEXnQw0HqF/t9kP1jDxhkroTSXbHw8fsBLC40fdvoInWCwWtUhWcrJ4ohU+mRSju77pvXbynl/TQBdr8VRhp8Vf1MBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9cS/0yNohYPOGkn9+epXt7+uySaliyvL1qDlQG8pTM4=;
 b=BZKfXWqV0fN4vQvlnsY1Evdd544+ootV6p5D3yYiZ2sPxIsvu8nMxcphNIQ2JRcSIAYgZ6XGv/DCGGlaIWOpQAqKccFHBP/cBIImmk12765COVOTjpaOw5TaD9//2TTPa+Ps944dB6xEML8BAYpwvnhRYZPwfw7JsMXpRhh3cwxl3dvUFWFmXlXitnOMATyswpR9Fvu/WfcZNBEZqKX1fQ4jVfKZ4r9HjNLujm8FD6SUB1itb1aeSCHI/P2aE7QjjR9y7U7z/dOk7AaW0jUNxZk60xWNycGTzotSrxtyK4gyB+9Q8dv5ysds3a+ycXc4RKG2g4ZSr2J7ZzMJLgp67A==
Received: from BY1P220CA0025.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5c3::12)
 by PH7PR12MB5709.namprd12.prod.outlook.com (2603:10b6:510:1e0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Wed, 18 Feb
 2026 08:22:55 +0000
Received: from CO1PEPF000044F3.namprd05.prod.outlook.com
 (2603:10b6:a03:5c3:cafe::aa) by BY1P220CA0025.outlook.office365.com
 (2603:10b6:a03:5c3::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.14 via Frontend Transport; Wed,
 18 Feb 2026 08:22:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000044F3.mail.protection.outlook.com (10.167.241.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Wed, 18 Feb 2026 08:22:54 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 18 Feb
 2026 00:22:42 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 18 Feb
 2026 00:22:41 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 18 Feb 2026 00:22:40 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@nabladev.com>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.1 00/64] 6.1.164-rc1 review
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b2aecef6-d3ca-4a76-a966-efbf17305e5e@rnnvmail202.nvidia.com>
Date: Wed, 18 Feb 2026 00:22:40 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F3:EE_|PH7PR12MB5709:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ee182a7-5517-442e-42ca-08de6ec6ea81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SWxHcFdzYUEvOTBGUnVWdDFyYWFEbHdiNzFMZk5qZS9XUS8vWWx5NG11QTd6?=
 =?utf-8?B?RUZYQ2hEaWlMUzRITWZPc3YyNlJkRGxkMGtsMUtxQk90WVc2c2lnTGNlUEFu?=
 =?utf-8?B?VUxiMml5VDJXMTFhK3JTV2MzcTNJeGVrb24zMmpuVHhDdENBZjJWRUp0UWZC?=
 =?utf-8?B?emU1Q3o1QmwvY3RMT0xrczk4enJiTVZFVmJtWTdiMXZrOFFBNFhEdFErb0ZC?=
 =?utf-8?B?SjYxUEtsNHNSa0lpZmRXVWhwbXNLRlVwOG5rdVB3bWl0eGVMYk4reS9uQjgw?=
 =?utf-8?B?UzBOcGpRdi9SdWpRTzVmbm5DUkNZNWNmR2RiUEFsaE05Rk9hM0dzeXhLUld4?=
 =?utf-8?B?UDBxZUhTWEk1czlCakdiU1BWQ0VmdzhLNDM2cDZMejFGcWFYcml5dWtNcnBF?=
 =?utf-8?B?OGhtNlZEK0ZscTFocWRiSllsMGlucHhkVytveFBOUzV0djl0eFRJUEkzUDhu?=
 =?utf-8?B?dy9MNnhUYkRWV1kzRDhGNUluQWRnbFNycmd5RzIvWkxrNzV1bzdFRFFIbXJN?=
 =?utf-8?B?UCtBcG1yK1FwNFRkalVkZzlJQXNMYjRWVTRkei9seE15dFVIUTNYZGNsMW16?=
 =?utf-8?B?YlVJVDNqYjkzMnhBa0JiNGlncjhvOWVjMWF5V25mVjhaVkZhR2M2bWswUlFn?=
 =?utf-8?B?Rld4dG1oclkzRks3NU5qcHVxY3MrOFk0UTF1UmtQZW1UeVVsVVdobE5GZlJI?=
 =?utf-8?B?Skt6dkVkVVFEVW5VcjFHZHpHVGhFUmxKdk03VXZIM0hiNEZpRlNXY3ZnRnNv?=
 =?utf-8?B?bE11ZXViMWM4VXB6T1JQdlhRQlNDL1MzWTZlelEvS3lnSzBCTXBuNjFFSmQz?=
 =?utf-8?B?VVM4R0NXNnBUYTVjcDhkUW51dkhwN09iakZ3N3AxdHlXUFpQOGpDYnkzN1RQ?=
 =?utf-8?B?RU45azltbzhQMWYzS09VUWRaa0RiUE1kQjcxYlRsUHdTQWNUVlNCTXRHT2lU?=
 =?utf-8?B?bFV6TWVpVFM5ZExsUjlPOW9UalFqZnRhSjIxSTZ5ZDVTbWdXdlpUb3pscnNk?=
 =?utf-8?B?ZWtWbytsRXUwSEVXbFdDVVNJQ2dEY2U1eUovcTdWUTAxVGJYdTYyVG85aW1o?=
 =?utf-8?B?ZGdIMHFsQzQ3elRna0ErTDVpdnBkSzNMK09TMSt4OHcyMUlBS0hpYnhNNDg4?=
 =?utf-8?B?eWJaMS8zVU9BYkgwUEVYYkFITzQxOWQ1cjhKTjZnUmJ2Y0Q3b09MKzhSTkhj?=
 =?utf-8?B?ZXZFeVRmZ1BrUTUzOUN5Z2w0SitvTGMzK3Nmc0tQVm5Kb2c2ZkczRmQrZllC?=
 =?utf-8?B?Sk5uRkhVdDQ0VEhBVWI4ZzBpWkU1UnFCcG5WMHpBRzRpU29CMUFpZUY3b0dn?=
 =?utf-8?B?NWhkcmluOUpEVkVxUXBoZUIrU2JhZzBYQkF1aHN6VnlDMzIvdHdXOGdPQjNy?=
 =?utf-8?B?RWcxMjJLdld5K2dsV0cxWW9saFdrcmhub2lkMU9mSDF1UFpNaG56U0VxRm1W?=
 =?utf-8?B?YVdCRDFxc3pnVi9kRUFRTHNubUQ4VEh2STErQlQ2VG5ldmYvK1dRVTB5TWZI?=
 =?utf-8?B?emQycXhGYWNVb0lpdFlEVERTaWpDdkxwZDZyRXd3Sm5OOTNuTXd3OVhuYVdV?=
 =?utf-8?B?blJyS3dXaUhQbmFCa2RsK1lyaDY2cTZuYkR3M2hnWU9ndzllRG9Nc1hNTXpa?=
 =?utf-8?B?WUxVbi9SZ2dhdmJTSzd1bWt1ZW9DYjdWbUFvRGlhbGJBS21heWlUTmlMaEV6?=
 =?utf-8?B?MDBhVTZnVURuL0s0WElDdEwvZmNYbXNiQUg4djlmdGRlbVMzZGpWTWtldGc3?=
 =?utf-8?B?VnBCVUZkRTYrVFYvdkhNMGpqbXFVK0cySG5DTGdVc3RsNzNyclZuQjR2UFds?=
 =?utf-8?B?WHdVNWVKd2dnSmlnQTNYaDFSVDZ0Uy82R0tmblJ1eWZZRkxTRldyQ3QrNmkz?=
 =?utf-8?B?ZHNscFdqdDluRXlrZGxBM2k1Uk40NVU1THFWVTBTVEhDTUwxRjR4TjltKytJ?=
 =?utf-8?B?NTRTYTJkWDgxRWxUSzFGcGFoQmYyUTgxK1V1N0pYbnVWU2x6RUltZG9sbVRk?=
 =?utf-8?B?ejVjK1NJeHdubjA5eUdTZXh0WHJjVEFyRnJ1QkM3N1E1YXpTUkRhUTVPS0FH?=
 =?utf-8?B?V3dyRFJxL1NQOW0wa0NLWGFzTStVZkpRaUh3REd5ZFYwcTFjVEdaTnBXTi9T?=
 =?utf-8?B?Wm9WTkNmWUM4Y3FFWXVyMjd4WHJtS2pLWlNCUHZqdEszQis1WGRQd3NndTVB?=
 =?utf-8?B?bnFVdng4ek94OUtXT0hlUlE5eG5XN1RnNHEzSWsvK3F5ZGM0VzNCU2gwSnRa?=
 =?utf-8?B?VG9UOFcyN1JWZEF3MFByaG1QRDRBPT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kFucX5KGSxACuXga6y0JJn0RGCetrvzp3NSAMwoyNjpYxZK3bzYpbH276n/6k8Wbejx4ihEcC5agepToBTILCwnMFaTS2/NfiLw6+V8b0GBNGt6jzCmfYAFLg2HvGIhWSr2A7RizrGnq3bWpnMld1PDpRb5PBEMq+zr0lBLF6cGmDuJu/QSLV6Y2ZbkJgSaLiOM5V08pPsy88bhASzbb9j7lnASDjOw4FfOEfHXmHcyyJUG1XR6ZSx5AFZMPkkDGD6z9WemlUAfVef0bW0rGpSJYkt+pd7SzxL06l4eEbKmxw4aEL+1p34Nir40Y8NvtzyQ9KtQvXYtLsU/lrJZkYoL/2ZWH6UdSEYIPETeJ27z2m+rKss/GgglA50HgWg8+4pDr/aU170QzhlWphoudEchGPtSqcTWQlwm5FOxbfAvkgnodmF+iAT0A4A1MwE1l
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 08:22:54.8743
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ee182a7-5517-442e-42ca-08de6ec6ea81
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5709

On Tue, 17 Feb 2026 21:30:56 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.164 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.164-rc1.gz
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
    28 boots:	28 pass, 0 fail
    132 tests:	132 pass, 0 fail

Linux version:	6.1.164-rc1-gec096a0e5918
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
