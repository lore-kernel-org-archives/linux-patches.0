Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2080.outbound.protection.outlook.com [40.107.101.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1B48063C
	for <patches@lists.linux.dev>; Fri, 16 Aug 2024 19:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723837404; cv=fail; b=Z0GAaSkl00WbKcut4+/0rx8w5U32SXM0GCfX24yeSoWrKTC/rcVoFQ57aH9KDM3xn/36btpiQZIkJp8rCz26oYpDq9V3zHfMtwJpIlAR/yPKafbPw7xhw4BusgQxk353dExrS1mRnyDy3yRNhuwyoi6XTOlZxTVb2IGqw38kItg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723837404; c=relaxed/simple;
	bh=TViISWUUQNtUwd9xfF7F/0/BoJlWV96nDCul0fBUlbw=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=kFj+JfSC4EJqG9fRApZfgOKrLFowJk8LH5CVoiTSTuJpGpxbhukmUKReo+OmaX/RUjWdG1X1/GKFN/BM5I2w8CkiDgscgKKzEG/Cxk5H1k40VK5T11AV5CNkT2Ulagef8s4S0LHmcU2/21fYeo7bUrpR8JtL94cO1lSDt5zkd6M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rcHMr4i5; arc=fail smtp.client-ip=40.107.101.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rcHMr4i5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MysSQYt2tC+3IKNFIX5e0G8xPWniA1WT4GtpoSfmC8L5RNZZsWC7Be5+3ymGaUgfpLkNSykV0JdnoMpqeX1yAAUUj+wo8/BZVGdimR39A2k0T/kLndOEkFKPNpeFn10c0BWJ0vprdYO0NYuWNDln8lOV7muKBaZ9Ad0Ao0+fuF4bOG6TOQ7KJp9mW2mR+p77dl2QORuMdjR7PyzzzTjtaOAQRDQP8quuI6fZw/aXErKd3mQEHpXeHWIvACl50jqWuUF4wvWfATQR0AaH/vOkHMd7TiwBewmst7CidZtfpDAyl4gw2LV+5nFsUfsJ2ceJnJfBmCrAaXfz68KQ217pIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gojqIcV/aBt1i4pbtP4p429RnrBBSN39wWHfA2bfWwA=;
 b=eSnzzv+wpbd0Np7FsjdOLxl8OCdsRRJE9LxzIkKu4DgkmO49Yt+DTn/O+0iTq6md7Gpgs8GYhEDAxp+pP0oH4Uarrj7XYbnPtr0q37GOcZtB3SvL3UqDrhYOiDzUAWxoOivPOMJjcw7lUn8n4FCk/DlL4MWMu+WO+LrtyEe0c8wPn30zZViMBRjJXSzcWHQzS8ZnNPUCrIj6TKdpOwVInuiV06sPQyJwZ7O2ApUWVxhqBR1Du6JbdLe/FW2mNZBY6WnWkjrUZq/j64bP+vUTPYJQT02RSJhu5t3BlqHigGYFShVyZRiFh++gsrGtyyv9MVR7opyAXKSQfk5VuV4bfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gojqIcV/aBt1i4pbtP4p429RnrBBSN39wWHfA2bfWwA=;
 b=rcHMr4i5fJvqabMUIPtwHwqmoblvojJ6RCktJ9eH3t8f83c/CRDp1FPIY4VQam2B/D6N2gYSBZ9r19d4vJMoHS2fsPXve2NZl0tEZvkvZz6pnm0b9yObaDNCjTLcOxgAuxrDeLLq4rmGmjiocNztT5UB60UptS/qigFjmACmN+GOQX43EZNJqISN4Ieu5NfRTNm1Hvwz5TbuqBSkBwMGsjCBQ9MIvRw2hPnK8fcihiwVS+ARBW3yK3yRJR/CE5jGucJZhRwLuUjjyaaHtPBOtQqx1q9/7xnvPsZIL8jFEVqRR1cDmuSxNl3efU89/ERX/cEFtpHavDaVM6/wcW0rCg==
Received: from BY3PR05CA0024.namprd05.prod.outlook.com (2603:10b6:a03:254::29)
 by DS0PR12MB9322.namprd12.prod.outlook.com (2603:10b6:8:1bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.20; Fri, 16 Aug
 2024 19:43:18 +0000
Received: from SJ1PEPF0000231C.namprd03.prod.outlook.com
 (2603:10b6:a03:254:cafe::f4) by BY3PR05CA0024.outlook.office365.com
 (2603:10b6:a03:254::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.15 via Frontend
 Transport; Fri, 16 Aug 2024 19:43:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF0000231C.mail.protection.outlook.com (10.167.242.233) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.19 via Frontend Transport; Fri, 16 Aug 2024 19:43:17 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 12:43:09 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 16 Aug 2024 12:43:08 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 16 Aug 2024 12:43:08 -0700
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
Subject: Re: [PATCH 5.10 000/350] 5.10.224-rc2 review
In-Reply-To: <20240816101509.001640500@linuxfoundation.org>
References: <20240816101509.001640500@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <058ae5ab-7040-4bb0-b451-c4fd4e37bb36@drhqmail201.nvidia.com>
Date: Fri, 16 Aug 2024 12:43:08 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231C:EE_|DS0PR12MB9322:EE_
X-MS-Office365-Filtering-Correlation-Id: f9525950-8178-4664-2008-08dcbe2bad3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WXl4NkVBS0Z1a0JMd0kvSEk2ZFdUQWdQaWNOQW1GYmJkcjRyL1Q5UmFJbnNZ?=
 =?utf-8?B?ditnTEwwMjJ3ZTFCZEdOWEtHQzVadFZjWG5UOUFvWGxKdkxqQkxXb3o1U2gr?=
 =?utf-8?B?T2syb2V0eDJGSkVibzBsa1FyL3lKNnRIbDdwUVVwTlJSbG15eW1JTFF4S3N5?=
 =?utf-8?B?U3hiQ211eWF1MHNpSWVZYmU2aXgwL0l2SG02anM2cDcrQklVeDArWEx1bjZZ?=
 =?utf-8?B?MXY3WVc0T1ZLWExYenRCa2VPSUZZaGFXKzY4bVNZT3lDeGJWakh2aDl0dEMz?=
 =?utf-8?B?NGNac01rdjA1MG9FdmRwZDlCeHVrRUsraUpxd2s3NEpDTDBoNjQ0NlBPUmFN?=
 =?utf-8?B?VXZPRlJzdC9rVWxuVEE1dEwwUGRMSUgzYUxRMjVEVDdzNDBMZWR4VTZSd0V0?=
 =?utf-8?B?eml3OGcyYy9wUmdqOEhuTGpvd1k5V3RmV1FZS3dZR0s4NUozTmdLTC9MNTJt?=
 =?utf-8?B?dmFlRU9neWw1bFRwWWpCYm5FblVsT29sdU1IU3lYZ3BEbjdKdkJKNi8yRlUr?=
 =?utf-8?B?Q05DR2tYT1pVTkRVVWR5Uk9HWU9LV0lzMXdpbnVhM25zMFhHY1RieXdTTVBT?=
 =?utf-8?B?bmg1bUJia1ZpaDh3elE4VFlFMTJaeHltbnptU2NPU2RDbXZVdEZnZ3pFQTJL?=
 =?utf-8?B?S29FZVJ5VkZIU2xvR0gzaUliRURyczFJZTJNVGtBV1FHenlGRGxDYXJ2UElF?=
 =?utf-8?B?RDhUeTN0dm0vS2lFU3NRK0hIUjl4ZDNBdUxwREFYRmpUWjVDbjZrQXJEdGlz?=
 =?utf-8?B?OXlsaG1UNFFldUJkdmpmTkFTSm5aMnZsUTd0elFuSHY4MEdaM2xtS3dIb0I3?=
 =?utf-8?B?YUtSbitwbFBxMUhxK1JyWitIUDIyYzNTS0RrSVhQc3dnc2l3anJPYzJmcDZW?=
 =?utf-8?B?c3hSa3o0dGZqUUdLWU5tNS9JOFlXamFTazg0SDB4N3JpNzNsTW43RERCM3RP?=
 =?utf-8?B?RC80WHhKeVhZZGU1OStlS3hNOUJVR2hiRFdDeWVRdWdxSHhsOGN0MFBzVDRR?=
 =?utf-8?B?b2VTTXJJT0U5UXVIRW1EZlhzblZ1eGIxSEp2M1JFTWE3VUQ1eDFGOFQyR2lu?=
 =?utf-8?B?RFh0K1ZFNW5Ec2ZCTjY2NHhIbFlibVphTWl4YStKT3NPV1QvUFlIenJQdUla?=
 =?utf-8?B?aHFBb2pxTWpJZVlkUFhieDhsQnQxVCswVWZCREl0OWJSQWVYaFNLYVhySVRC?=
 =?utf-8?B?bEhQTmJ0ZnN0NUNhZDhQOTBpRkVZcVRZWGtmT0l0cWlaR3YvOC9uRERBa05S?=
 =?utf-8?B?UTBLQUNFUVZyYnlzajRVdStqaHkxWjN4Y2d5Q3RGR0Q5SWdNMXkvRTJtRXBS?=
 =?utf-8?B?TFNDZy8yNnA5eC9ITnBqa212b0xHNktQVFlBbHY3RUdmUHNaUWxuL3FndjNj?=
 =?utf-8?B?WVA5bzRnNnZhdjVxdDNQOEMrRlN6VzZTNlBTQ05tWXZVYXdFZFZjUDM5cGlK?=
 =?utf-8?B?NTNBcnc4eCtKaGRHQytGTFhWc0p6NUhiRmlSUUNIb2VBdjZVRDV5SWJZMkdZ?=
 =?utf-8?B?d2t1WmRzMHdGVjBTSWFwMWtGaXBEeHVpaVpwRW1hV0RKUTBXcTlhQU9DZkZN?=
 =?utf-8?B?Q1gxQUVhTE80NENTYXp5VXFKa0xleGQyVVRvQmZvNjJTKzZGNWNFM0t5ZkV0?=
 =?utf-8?B?TWUrcmJhTDVJNWhSSTA3TUFlNGlsamV6VmZYQjNOQWpoYjNSdkQ5cXcyMFZl?=
 =?utf-8?B?TlI1S0RpZTRpN3VtcEVRR0taZWNIT1VHeWVPdjNjMDlnK01NMkhaY1l5dWND?=
 =?utf-8?B?L3oxc3daTDdPU3ZXUUpicFR6UmZIVklTRzZjcVdEdk5EODNFRGxhdUpMRTJl?=
 =?utf-8?B?a0ZEdTFtckd3TXdjM01qY2NwOTVpQW9EU3RldFNyOVBsMmpjTHhpamJTTlh2?=
 =?utf-8?B?dFdKTnlGVXREblcwOGNCV1NlSHB2VFkxUUhQdlkvR1hLbldMOVZvdzlGcDNt?=
 =?utf-8?Q?z1sHPmSgxfvnjX4Fk5Nq6AT6FccVEjCJ?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 19:43:17.8790
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9525950-8178-4664-2008-08dcbe2bad3d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9322

On Fri, 16 Aug 2024 12:22:05 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.224 release.
> There are 350 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Aug 2024 10:14:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.224-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    31 boots:	26 pass, 5 fail
    45 tests:	44 pass, 1 fail

Linux version:	5.10.224-rc2-g470450f8c61c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Boot failures:	tegra186-p2771-0000, tegra210-p2371-2180,
                tegra210-p3450-0000

Test failures:	tegra194-p2972-0000: boot.py


Jon
