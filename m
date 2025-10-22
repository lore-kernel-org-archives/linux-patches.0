Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010069.outbound.protection.outlook.com [52.101.61.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993DB34BA54
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 15:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761145548; cv=fail; b=cNpPXoWWyBbMSIdqbZv7xa+0V6lbI3sknnge1ZbzkgdbWHlRs826ws+N4G9tw6vPCG/7hDjIKEQvK4ZU/CwiFnW1gLbhN6y31Oa970bgVb2Ksw9OHxRbQD4pwcGnl6+qkInP+zMzvPNyBmpV43P5kKqfKw3pK5taZdhHTigNHAQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761145548; c=relaxed/simple;
	bh=dOQRItSiR5aly7whTM5Tuqd8eUocAkNW5ruhQc4rHQ4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=jY5brzJ05l1rBABi8OPIYUHzUjKeiqDvwfe4D+YW2c3R55BkRBIMqpIr7UEgcf0eW5b0Q2zBVu6WsONubxlxJEDb3Rsmxswp2AG0eNP12LK8A7yD3iIUD4PI3BxpU7hd1+/we7LEzLIlSANw7vhBIF2QylU2x34B79GVrFaTosg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FYF2f5Ab; arc=fail smtp.client-ip=52.101.61.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FYF2f5Ab"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A5chN8ASr6hQMcOgfwX6mTNgZ2q3jndkf/nRHsWlqw/+acLCKCS9PcYmCXkxlJHYVAud4jHSfw35qTQ2zPJN6c41uxi2lRkit9bZkOHdbIPLEQwW8DvM7DtUyBCg2R58aTmRziCbQKtyK+daGBOqt62YwRlO5mrk+r63FU2qtvgCOwm9oGkGgO0VXKSWw8JTG/TJin/BqKGx4nv5vUzesICFTGNUb/3DOwwjL/OatWcH/kDhz2v59GBXCeWhgqFeKJpcQR6S1LYQnicm/8Q8xf00FgjDtpwKvXwx5fxd3btYH07fWWOmbbHDExPam1A4LkCQXIwkDjLX+8RHFd8+Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0cF6eIu1O9/k9Np4+b0sARghoh4ChwFdT35Dz7WvRfs=;
 b=Dnko0RdoXeavJK0WLC5gdHb2Jl846ahAlhFahFbXSl25zS/S76DpONvQewr5FCV4yLkuN4fqAm9IX5VDeg9SRACZszQ4DyRFT6TQrakKdlUmYbykHichVzzDQwX2A8qoqeBbOJWoul6cJY6akf1Yzl/A7aNt2IHBtVjv/gTBgbVmYjVk/vl/Z7VyyNJbeS6sN0sBXuqFeS2LpfLkhI9O+r8pn+iFDte7LR207XMaCKWoXDcoZIWaIsGC9T3/CtEY3eNiazgwOTLG61Bet0f8rE53CRwwCjbXARtQOKFMoDelaEYPH5GiRRg6fGShJZO9LvpO27ELkbAM9FkicIDRAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0cF6eIu1O9/k9Np4+b0sARghoh4ChwFdT35Dz7WvRfs=;
 b=FYF2f5AbKiGDB23ASxJsIMghUd9aEkNg0/K9PboQzInhYjANXyurFJu5QEiHLfzLdzZI14r/wM6tyHjOnXevdZbagKtNsdXEWa/sTAZgz1KygV8i2WRm7lHwVj8hZDEwU6qlcCpsoygmGA5SDFs4gJRlUzHSYDe3m08vf3et41JessyfF05T1KgfLoiO2tTkn9BMR/B4YJOEXgunkVgauhajiknaTtNjArC9qGOnQW47z1e5BwuKHBqYcUo1LybBhc4mES3M8fjBD/cl1yZ8uGPpneHh1uNyfdWikPQA6hLVc9YVmxQICxEFCjWwwfz5zeovBVi9IAT+UREE3+iIDA==
Received: from DM6PR13CA0034.namprd13.prod.outlook.com (2603:10b6:5:bc::47) by
 CY3PR12MB9679.namprd12.prod.outlook.com (2603:10b6:930:100::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Wed, 22 Oct
 2025 15:05:43 +0000
Received: from DS3PEPF000099D9.namprd04.prod.outlook.com
 (2603:10b6:5:bc:cafe::87) by DM6PR13CA0034.outlook.office365.com
 (2603:10b6:5:bc::47) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.12 via Frontend Transport; Wed,
 22 Oct 2025 15:05:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS3PEPF000099D9.mail.protection.outlook.com (10.167.17.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Wed, 22 Oct 2025 15:05:41 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 22 Oct
 2025 08:05:21 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 22 Oct 2025 08:05:21 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 22 Oct 2025 08:05:21 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.17 000/160] 6.17.5-rc2 review
In-Reply-To: <20251022053328.623411246@linuxfoundation.org>
References: <20251022053328.623411246@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <dc6d9c35-c17e-46f3-8234-04e5bc6d7da7@drhqmail202.nvidia.com>
Date: Wed, 22 Oct 2025 08:05:21 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D9:EE_|CY3PR12MB9679:EE_
X-MS-Office365-Filtering-Correlation-Id: 905449a1-58d2-4fa4-a7ba-08de117c77ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R0YxV2hDOWpVdkVNQkdvU2c0MFI2UlVkWWQ4ZU56T25QMTJIMDREaEpneFZO?=
 =?utf-8?B?WXFYcTZHbEx1aktnRU96YUExY083UHJ6bnVkVjYrbGplRGRsYkFnZzJqcERy?=
 =?utf-8?B?cjZKWVJ2eVhmdmJrY0gveDZDNU9KeXRUeWdlWWF1Q0IxMXFFd0h5eEl6anJz?=
 =?utf-8?B?OFVsZ0l0MGFkSVdyQTU3NjRBZVd1U1dyOWYzTGtiV0Y4R0VSY3Vobm9Fenlk?=
 =?utf-8?B?Y2padlVTU3JNSDdzSmhkdWU4KzgwOTkxVXNILzkreEJjMWlzVU1kMVEzUXJK?=
 =?utf-8?B?bkY1QTkwaUlzcEY2RTk0YlhscFNDVWt6b2w2UXRCd2RCU1A5aWtuZ1l3Qnc1?=
 =?utf-8?B?MzRncmlNbUtFYVY5ZlhBK2tEbldLQUJQZkVJcUJ3bmQ1Y3ExT3VyS0c3bitR?=
 =?utf-8?B?V3FITllOTW45OGd0TGl3bXhTSVEwZllRY3J0c0JNRTVjKzRpeEtSakNadFZT?=
 =?utf-8?B?ellkRmpUbDNTQnd2bVpMYmJSRktINlp1UzYwcmVMTnh3MDZtaElMTmRoZEd1?=
 =?utf-8?B?VG5rQzZyWU83b2RSNGZSR0F4WThJUGJZK3lBb3VNT3hoM0dSSlhXb2RNZHc3?=
 =?utf-8?B?dVlVdzM0Q0tBR0sxaXJ2VXpIcWt3UXRvaENSaWpTcHRLdVI4cHY4RFpYSEF0?=
 =?utf-8?B?K1JUa0d6bGM5NjNoQTdXc29WOUI0YmQwUk9hcDRObXphVis3ZzV3S2hyc2tN?=
 =?utf-8?B?ek5SK3gzbzRXRldRc0NQTm1HVzByTDRHMXdMYXh2MEs4R0lhQ3NNSHZic1Nu?=
 =?utf-8?B?MU11dWkwTkJhcVQ0ZVlDeXU4K3hZRnFhN2VkY1QrKzd6UFh0dmEvT3pIR1Uz?=
 =?utf-8?B?L211SDVMOGY5QkhEVllLVFZJRGluK1NHV3JTd1lzeTFraDVyMDdpWjN1MDhD?=
 =?utf-8?B?RHFwb2g4bThFcXVKR1VDUHZWNklaMUJZN0JGbVJlOWZhcWpmdzh4ODJyaGJZ?=
 =?utf-8?B?RWhJZjJQYmMxbS9SWjE5M0x2ZnJ4NXpxZHlUUGd2emk0NXorREFRREN3RCtv?=
 =?utf-8?B?SGFVUnZVTi8vY0VidFJlSEc4Sk81VlZWeUxBUHM5d25PL3hBVDRqdWE4RUxi?=
 =?utf-8?B?c0JlSE9ZRHhxVFY1Uk9obCtVUzZYR3didUZGWjVqUG1xcHp5Tnh4L1dNa01G?=
 =?utf-8?B?bjJYN1oxblhrYU1oRXNrR3JDUFprUW50R3ZtakhjZ1l3b2ZIY2NQYVQ0VU9y?=
 =?utf-8?B?ZjBMdFFXWTdxTGdwc01vOHhPOCszNzhVQUluMW9VVnZaeG9JbnlCSkE1SytS?=
 =?utf-8?B?S1BhQzFDcU5ScmNZZmptYitzYjIyOENTUnNTRTNHaldiV0x3N1JHT0xDU0Ev?=
 =?utf-8?B?K0ozTExkbjVzWXVacmM4aVEzVGNLOUQxN0pCK1lUWnBQUXBFaFZwczhpUWFy?=
 =?utf-8?B?OG00MEJ6UzVRMzkvYWJSK2NUMmE4WnBxTUJJNmU1NkVNQlNEaWhPd3QxODll?=
 =?utf-8?B?Ym9yNlVIUTZMZHlCb3hzS1l5VmQrQnlqVVVGNkpyeDZiRStjRzlNcUFERmtu?=
 =?utf-8?B?R01RbXNwVlZBTm5QcmxSY2V4YlRiRXIwVHRhb0FURU5TVzkyVjhsekpERHkw?=
 =?utf-8?B?cFBBbHZOQlBHRm9nNjNvaHRjSUcrUmNoMXM1bVIzYlIxb1lpRXlSdlpsSGg1?=
 =?utf-8?B?YWpEYzR2SkNUM2M2V242bTdhalZWaytFOVk3V1hza0JWV1dCTDZvS0o1ZFdX?=
 =?utf-8?B?MHQ3WGZoUTh0MndZRld2ZjlQbjFNai9SZ2F3empLZVZzRjBHdTFlVDk0dCto?=
 =?utf-8?B?L1V0V29kcWFybTlQSzhSWU5iRkprUzVNd2hFaVdDcjMxaW1lY2JvNm1HMW5N?=
 =?utf-8?B?dkZHdFZka0lXU3JnaGpzWUMvVVRBTFpyMlFwRVcwc0xvMXJRVW55Q2FDcVZa?=
 =?utf-8?B?YSs1R2ZSbE1KeVVqeUVGc0JvT1hzZ1BzSGhob3U2K0tObnRoSHV6UWtvVi9Y?=
 =?utf-8?B?bHlzSFo5azZYT2Q4L2RsOXFqL25aSWJSeUFXc2hueDRlTHBSR3JCNUd0YXVr?=
 =?utf-8?B?aVlIUk1EcEgzLzFEd3JzUWdnc2pHbU9JaFphYmhPeHlnSWNRUkc4ckc3SDhO?=
 =?utf-8?B?L2NoL2RnSm9KaGhsVVJGWDA0OHdCQVZsUUF6ZEJ5VUxmOWx2REx2bUwxcTJT?=
 =?utf-8?Q?rjCs=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 15:05:41.4698
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 905449a1-58d2-4fa4-a7ba-08de117c77ca
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D9.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9679

On Wed, 22 Oct 2025 07:34:14 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.5 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Oct 2025 05:33:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.5-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.17:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.17.5-rc2-g3cc198d00990
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
