Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2049.outbound.protection.outlook.com [40.107.92.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832A6283CA5
	for <patches@lists.linux.dev>; Thu, 10 Apr 2025 12:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744286918; cv=fail; b=NfHrW7z9t42Q+RoPbMLFgbVENnuSAIBzEQsVxpLiEUJaLHT//oSw7kV5g6cEDezZIj5ivMFiUXFiMchoQrZLvpdu8/0et9YRAPyk+ohVligrOWJNLy6TNt4YZ4R8aGrXMrrNbAqIhXNHoff1aOEUbJlRV2wEPXSn11h1HKkb5B0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744286918; c=relaxed/simple;
	bh=Lhit7ifJMvJfi7GWNw4N9LGByOhmG+xNCZf/xb6C7m8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=iOHaye/bo09OVc7iGVxrFmW9j2LJitp6otcP2r+mOKo91qBulD430Hc8GRNkBVWgLsG74FCDL9+wPc1LIOW0TQ9nxPrua++4GtsseqnmSbViWdvvLpW7n40KTW9n5VyNFxXozSjhnBwYSIFSoTk6ppZhP8/Nlf++//3DKNGVdHI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qCwr5njQ; arc=fail smtp.client-ip=40.107.92.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qCwr5njQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AaEQ3rMdhf0K+BAT3NF+P9T+Rc5rv8CfqXfxtClwK40hrb4j8/yFBxUBA5FsfO599e/LFYOJSDXJWj0BV0UhVzOWCmQzDgdIGBcTE9uS6I6Np7q55B97E60HRCqC22x1IwDHh+tLC0/+JLjsiwZ8qGsNbLaOqcurJsaJhkKzs4Hbd9DJoMXjisrsCEGnVQrhxV45mG4N5WWPyV3bf5F5o3LHFoY5h4y1tHuMyh0Mdq9YSNdFigeT8aICveWnbnrsGm4Mkfrb5Q9mbwb9GqxWwRXqFuQEEiymJfh7hkdUe6rD4Fyhk5u+UaGIfWkV9YAxlsJUGKisIeZQ9OnyE3BHVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OYIcLdyYHTv5QdDuwcZi+Y4cIhQBP5gv784tUlEXJxU=;
 b=dPTvX7zGG8TCK+5dDqp9g9KvhRhy3c2Eu/0pb29qHTvmq8aoQmvjHPKzWaPC1hgUHxOcKjOJ08B6smkk9bUzJIHUcRi12mlcklKwI4ehpo3REpYNpEhRjkkzI6bqVUEdWC3adJg15zmbxB+bh3got1uWLH58VUB/Z+eSCnZTcqulaZMQ0h+9iIbjuYUEdbgJdCHJeUeo4n5IzRJJtrJD2nOij2a/6iPAhr783P7DspSemSS7h+oqgCVP/gckAveC41LUjr/E+2cMcBXZ+yeFxrt60D5ZwVx4gQQlfeO5b/R+0mnO/WVabqDls1+c9PwBO0VXjDnKD8zU/aoq/9LtWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OYIcLdyYHTv5QdDuwcZi+Y4cIhQBP5gv784tUlEXJxU=;
 b=qCwr5njQJEcVpcipxHUoP9iFTZ4ykOnkDBYwhxrUiGQ+vJPYqhSK4p4k7T9rFt7pdLJlZgLw32kskdpC1YoNKxLDVnWw4HXyiqCVAl3lFZF9M0jJMyt5qtlnkofHejIFDM9fxEPs7Ta6TyXPzFjmsROLjJCbr2J6G4xva0bK9a/ZY8iBIjkDv9/smA84HU4XRYak6gCBUszK9nTLiXWHsiILgXAJFmmEe+V9eqGiQIJmNwYFZVYyEMBZrrr1ZE7c/1Dwgszy9+rU24hrJAINPq8XFL6sX/wuF4WlLBJksHR85eM8K1wRlG+pRYYUI5T4FMsCYwXS74DGNvV3jwGVuQ==
Received: from SJ0PR03CA0213.namprd03.prod.outlook.com (2603:10b6:a03:39f::8)
 by LV8PR12MB9666.namprd12.prod.outlook.com (2603:10b6:408:296::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.21; Thu, 10 Apr
 2025 12:08:33 +0000
Received: from SJ1PEPF00001CEB.namprd03.prod.outlook.com
 (2603:10b6:a03:39f:cafe::50) by SJ0PR03CA0213.outlook.office365.com
 (2603:10b6:a03:39f::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.25 via Frontend Transport; Thu,
 10 Apr 2025 12:08:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF00001CEB.mail.protection.outlook.com (10.167.242.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.13 via Frontend Transport; Thu, 10 Apr 2025 12:08:33 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 10 Apr
 2025 05:08:19 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 10 Apr
 2025 05:08:18 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 10 Apr 2025 05:08:18 -0700
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
Subject: Re: [PATCH 6.12 000/426] 6.12.23-rc3 review
In-Reply-To: <20250409115859.721906906@linuxfoundation.org>
References: <20250409115859.721906906@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b21ba435-dd7d-41a8-aa87-116bcc648b7f@rnnvmail202.nvidia.com>
Date: Thu, 10 Apr 2025 05:08:18 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CEB:EE_|LV8PR12MB9666:EE_
X-MS-Office365-Filtering-Correlation-Id: b9d44c65-e121-4226-8f54-08dd78286a5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T01TYUZpVEFFWSs3Z3M5ZDhQYUFlODIyOWpGZmpnQlNVUDVFUmZ2RGNIbk5i?=
 =?utf-8?B?Y1NQSFQ5VmVGdUpyc3dsVkYwT24wWW5PVlJNdmtrNXJ1WkU3ekhwZTFPUWd2?=
 =?utf-8?B?SHR5U2U1cnZuczdtVm5uY1oyZ010UkRNeEMwSjRhS0VTVys4M1FVRG12Q0hE?=
 =?utf-8?B?YUVFT3lzNWlhMisvN21DT25LNWZieU02ODgxcU1QR1oxd1JFcmNqVDY4WGhZ?=
 =?utf-8?B?c0tXL3orcytiNmg4YWNsdksyNDZsengrazZaeVhENEtYQ2lqZUVXeHdUbUo5?=
 =?utf-8?B?d21lVWZiemxhRXg2V1FqK2xaZmV5NjlDZk13OTM4ai9yQmJrc2lzd2ZCbUd6?=
 =?utf-8?B?V1pERmNja1dKRmlRUWlCZktNTzZGUUdoRUc3aEo3c1dsT003OTFUMG9pTmo2?=
 =?utf-8?B?TmRaWVRDWUxtdWNBMkNjZEJJak0yK3V6ZTFxQlk2dWNiN2x6aTd1dFowZFM1?=
 =?utf-8?B?VVEyWWdQTjBCaCtmZTQrdEtmZzBoOUdqaWdmVmZ0VDY4bWNtVjBHQ2RPcTNh?=
 =?utf-8?B?UjYxKzVFMGt1SHBNcU0xOGF0TUJLU3p1NHZMZHhiVVRhWGxCRHlTTUNleTJh?=
 =?utf-8?B?UUUrWG5ndGVUWkdHQkxaa1JBZm9FYVF0ckRzbGhOamFMYVo5QmJKTzI4aEFv?=
 =?utf-8?B?MUs3Slc4S2xCNjRJaVBuRjhUYjE4b0FXSXRYN1JpTTAwZW1oek9sb1pFK0Jo?=
 =?utf-8?B?ZmIxd05nWkF3ZDltOU1jQ0oyV3dUYlBQK3loUi8vSFNnZjQ1TkhzUEpzWlhS?=
 =?utf-8?B?aTd2OVlOejIveGptQSttblpxYldDMTZUZnJHdDA3R1I5d0h1VE5KcEU1bTE1?=
 =?utf-8?B?TnFpY2tGK21EdkRyQUNRK3NVQjk1MmJQOUszZk5kMGxIRGdINXZmUWRYRW9o?=
 =?utf-8?B?a05jUWVwM3c3V25mSnZRaWxsTHpuUkx2YXZsTUdnczUraGkzSnNaSSsrVGx5?=
 =?utf-8?B?aU1NUFNTZ3czbFk1WXdxRXhzKzJsRnpEam95dlRQRnlvOW1GZHhSNUZaZ2Zy?=
 =?utf-8?B?OFFsc2IzWW9sSGdoaXorSHlUMk0xeXV6MmUwaS9NOWtTUldGdGVBa25LbkRC?=
 =?utf-8?B?ZUpwVkNLMmovL0M4dWxTVXJDaitOV0tpdU9MU3dTLzBHUTBkMm5mZ3M2bGQv?=
 =?utf-8?B?YW4rMzN4UEVxcmpSMlF0L3gvSWl0ZHR6RlhvSmJ4NTFJcVhvQXhCcitQSTBt?=
 =?utf-8?B?VVhFSCtac3FYRS9wNXc1Wk0vUHg4ZTRZMUY4MXNQemczTlR4amJmOEhxTFFv?=
 =?utf-8?B?SHI3QlpDUHRmYlBDZVZGdWZWamJPOEtWL05Pcy9NSVhDR0lsNEszK2tCZjhS?=
 =?utf-8?B?Q3YvZlMrWkF6R3JMNU81ZXNocjdGeUphY2dNTTNpVGlZajZZWHJBTUFZcDZr?=
 =?utf-8?B?RnNPbEg3Vm9oN0hhbmhrditkVFNsc25oU3dvUFJ1SWlaQ25UenhxaS9jQ3h2?=
 =?utf-8?B?QW5PWlk3MHdTSFdqYVlrWm5paHRGVGlHazNjYVN6akVZemJ2UWJnRkxueDU1?=
 =?utf-8?B?QWxjc3pYVGxkakttSCsvYm1XM1c5MGVuS1dHTFdXMHI1UURnbkF0b3RvQ094?=
 =?utf-8?B?RUtydzV3VndaQVFoZW55V2cwSmFsZlZYdTVFZVdGaUF0dTdXaFpiWFVNSVc4?=
 =?utf-8?B?dlAvRWY2ckcwbDlQQUQvOWhFRmIxd0ZhTnAzdTNEUWE3dHhJWW5HeWdMbEVs?=
 =?utf-8?B?RTNTUE4za1JNUHZpSXllV21HektqL2dMeVQ1dFdLYnBRZGNIZ1BJRCtQZnY0?=
 =?utf-8?B?OS9zUXFsc3VJZUJTRk1uUmZuQ3l4N3VCZFlOZFBXMld1SlVzUmMvV0R2ZTQz?=
 =?utf-8?B?akgwVkRNbm1NaEtjcnB1YjRKNHM0RGVYeGVnWE5vKzltcGt5WlhTbHJNT3Av?=
 =?utf-8?B?NE5rYzdHVlZIV092ZHZLeDRYOXFVbEgvNDJGT2F6US81ajdhQnNMRHNLQW85?=
 =?utf-8?B?dXRCd0xoWjFIR0xuVXRuNUVoejVlSkJqK0VFV1ViZ296RkFJV2ZIek9GbzlB?=
 =?utf-8?Q?M+Xjxd56VzDVOCWbJVvmGWiP92P3GY=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 12:08:33.3860
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9d44c65-e121-4226-8f54-08dd78286a5c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CEB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9666

On Wed, 09 Apr 2025 14:02:59 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.23 release.
> There are 426 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Apr 2025 11:58:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.23-rc3.gz
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
    116 tests:	116 pass, 0 fail

Linux version:	6.12.23-rc3-g27cbbf9f1b51
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
