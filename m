Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8672853E3
	for <patches@lists.linux.dev>; Thu, 10 Apr 2025 12:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744286924; cv=fail; b=KwkRjFtuwQsAhi/W5S9Ci4Z4BhgT5+xWHaZN9WlO440Uc+mMhUNFBNcPkY7h4KVPmSR/npjeFHAZHUdlAdkEETblMRDX/dH9rFHQOWeJCzcANXjApGerHHvgvNrFydQ4k5mmXJTT6/RBCrBZmzol+UPFKGxXo4Sf2EOG2NQtmrs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744286924; c=relaxed/simple;
	bh=5heVdupLDYelSS2n1AklsMRDPx+DmGhzVDvCBqMLmsE=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=S9u9EJ4951jyJ/9yMOE2hhb0WcvTf2CHo2FOhIB0JqqENckijIRXseWvK9lheP65shMtporOHQwhYtfcD50DLe3KHzfmd6Uuw2jnsp6mFEfJVVnG4b/u6e/Na/bVXx4w0XVZKRA4EGbaTU2qGfr6eFMaa7NnkkPxhxTYbJ0heaU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aRrZp8c/; arc=fail smtp.client-ip=40.107.94.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aRrZp8c/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iulxJAQVsrcjOnR9Zll+e0HdxQRoeoB+ra1oBAl256sPUk4KbjqaV4vHbYuW0aokFgLYv0LR79ueyRK+GRYOkhLmr46+PFVmSdZu6JG/Ci0HtQdbt7FH8byEpdVghsI1NHtq+zl3ELjHNmb5EUiLsoqjoqc2zNEN5pqYzLLM5Fidi/uTNtYUPCAm9n+ixNUhthm5+C8gG/NfKZirbMSiT3cjATxPbcpiC2gzoMTA/NkHNwF3Mn9gwmXqbg79X6hzz3AfmEpyiPKOGYLGVEIz+nnxo64aH/eNM0GXyfQzZB4igmQxHthVQRh1rIjWoMedZmLrA9QEMgcDrhc6KZT6OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fUztEPK7St51f2IMximpnsWRcT6wr7co7Q7rZt4piGQ=;
 b=AT7o6X1mpe3ja1tA0rBQQsNyBzKIqUz21GyhuHA5EK/DVXuWct+tkPBVbuiuryJBPRdJ2ybmCLf8EmFeiwdXsym5LYkx7kuBZyqqPXkoTUy/8eRPP6qrIRgOp1ij6jtFihxMj3F4GOIkGbB23DvMFuVLGtTGwsi9xjOGGo8uSa1gosbhMxEJFDoORc4L50XiZXaHVDWoiNJm678Uwwbzqcui53DXISkqymOF0I+lWKtChB9q46wMcuG5bA+mA7zfuZg2L9Y/QHsMF1pChzq0bbSGbcKR0yBIUhHjzLDsQACQF8X25OVTSG5UOfpsp2b+QVgZ/eXHK7S5zVlNfEPc+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fUztEPK7St51f2IMximpnsWRcT6wr7co7Q7rZt4piGQ=;
 b=aRrZp8c/ge3RMrHSTS0tTIgsVIktAZ91MIygwR0/tPJa3j3dT0kxp94hNEgkdLb7OX8N9bhtn/R0+Kfl2OYiXCZaySR/08QfQOF95iDZdSou/ixhgrkOLU2syBGG0K92AF8biymUJWvF6TL67+ir2mk63Lrnc9k93k5Jr+G6ujm0A0NjOX8MVvYWVyrjDrorA6UHpIF6J3H4zlrgnhKRdr6rR0qThBxDTp1hKDDU0e+L2YwikP5uQANcJzSdHJI7kWwYvBkNQPT2jewTkHjNuqqEjqQov3jVZBweQV91XExaDdyNUXyf/I7JgqwnB4hU3fkydn+1tdz/N7PXPUaS/Q==
Received: from MW4PR03CA0210.namprd03.prod.outlook.com (2603:10b6:303:b8::35)
 by CH2PR12MB4118.namprd12.prod.outlook.com (2603:10b6:610:a4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.31; Thu, 10 Apr
 2025 12:08:37 +0000
Received: from MWH0EPF000971E5.namprd02.prod.outlook.com
 (2603:10b6:303:b8:cafe::7) by MW4PR03CA0210.outlook.office365.com
 (2603:10b6:303:b8::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.23 via Frontend Transport; Thu,
 10 Apr 2025 12:08:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MWH0EPF000971E5.mail.protection.outlook.com (10.167.243.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.13 via Frontend Transport; Thu, 10 Apr 2025 12:08:37 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 10 Apr
 2025 05:08:25 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 10 Apr 2025 05:08:25 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 10 Apr 2025 05:08:25 -0700
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
Subject: Re: [PATCH 6.13 000/502] 6.13.11-rc3 review
In-Reply-To: <20250409115907.324928010@linuxfoundation.org>
References: <20250409115907.324928010@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <26f5a7f6-ca3b-4932-bf90-51de483b2add@drhqmail201.nvidia.com>
Date: Thu, 10 Apr 2025 05:08:25 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E5:EE_|CH2PR12MB4118:EE_
X-MS-Office365-Filtering-Correlation-Id: e683768c-1207-4a40-5f61-08dd78286c9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NVNqVlo3Nm9aZktia3EvY1VEOFdqZ2craDc5N0ZKMDFUZzhLTUZLM2NBNGVo?=
 =?utf-8?B?SE9qTE9pRTVISmNiMVBhQ1JPZXpMVExiU1VqQlpxbnl2TnpKQ3ExV24yRXgv?=
 =?utf-8?B?WTBvUVdmWnZva2ZFc2RyaEZBZlV3eCtqZ1NUam91czNiTXpDd1EyRHpWVllG?=
 =?utf-8?B?RHVoZkYvSDFqbld2SGJWbkIyR1pwWjZieDRuejZvNVZqTW1QQ0JLKzFicENi?=
 =?utf-8?B?ZkxhM21vRXpONWg5bHdnWlQ0OUc2Skt1cEQ0QThkY2NjV2I5QkJaQk1oUVAy?=
 =?utf-8?B?OG5SRW9FckRJS0NJNFFIV2xmbGxwdE84Tk11YU9jNFdFVkxJYk9qV2NhZG9u?=
 =?utf-8?B?MEhDMm1zYXBUaVpSZ21YcmJ2TU03VUlZUC9vZ011aEIrM25XdWFmOG5DM0xQ?=
 =?utf-8?B?bzNlTXp4TlJTMFViREpselNDWGVwRWIzQlBKNDRaSlpuMVFmeXNGUnJ4ZHdO?=
 =?utf-8?B?anVUOFZ4L0hJS09HeUhxL1podzhxMTRPKzkxZktObVBQemVjZjd4TXh2aGhL?=
 =?utf-8?B?RWl0MGNUVlRRRGU0eWhTY25pa1YycEZTSmJ4TmRBV1FRZWIzQWFhUFM1NXE1?=
 =?utf-8?B?RDU2Yll1aUJUNkNldXdTdjF2WSsveUZwY3FQeTU4WjRWRk5Ra0JHWmhzRWx6?=
 =?utf-8?B?Y2lKaFl0TUNmWkhrU0FPQWdZRWVUK1Z6RXJpbG9tRHNmZUNocXZVcE5NTkVB?=
 =?utf-8?B?TFFGTSt0bkMyV25rOGJlZVJ5SUlEMkxPMDU5b1B2QU1ibEs1UStBRnM0RFNW?=
 =?utf-8?B?STBFemN2Tnc1VTFCMjhFaFhxdnlnazA1V1krNUY2b2xnMW9UVm9WZzZmWm9y?=
 =?utf-8?B?a0QrUlJOS3ZBVlBNMm9Oc2hlL0Y0SHN2K0NDS2t6bzY3T042MFRUNWZtN2pp?=
 =?utf-8?B?b0VTN2w5WC83dFdyRXUvNHBpandyRXhDYnpYYjh1eERGYzl4SW9xbHJOMmVX?=
 =?utf-8?B?VTRQL0xCWEd3K3lUVzExMGhaY21qTFJ6d2MrcVkwdURhMnN1ZUVaem1mRk1h?=
 =?utf-8?B?eVpEdmtLT2oyL3YzTEhEN2N3V05hUGVhUXNaL0VGa2lJemdHM21rQzFQV0ht?=
 =?utf-8?B?OE52R2EwT1RYbDg2Qk9CcGt3bmF6WjljTVpMNTI4bFlMNWVLRk1FRFppMnps?=
 =?utf-8?B?Z0Vta09UZnZpbjR3OC9VWmpUbnNYQ2dKWmhhRWFoZ3FoUUM1aGU4WW1OMEt5?=
 =?utf-8?B?R1AzUy93Y1Rvd3FwN1pjY2k5WCtiNDdYUGt5enJjaURFSWtGN2JBSWZUdmZJ?=
 =?utf-8?B?UHRCRDNTb2pISktMRGdid1FwbDhPYUV5b25Yd2o1Wmx6dGRjQUhPRlliNEdl?=
 =?utf-8?B?ei81WVF1bEdneVdiT1ZCUmVhdks4THlFWVFZY0ZId3ZncCtDN1Z2THcrTW80?=
 =?utf-8?B?N21CdlZqVTRNTEE0Smw2dTFReHIxcncrLzVFQlZqQitHck54c2xOQ2xhdVpN?=
 =?utf-8?B?SnFWc0lCN2U2QWplL2lhTy92aFpoZVMxSTVlRnRuWDJOVUVaaDVFMXZ4dEFI?=
 =?utf-8?B?b3cwam14VjlNWnNuOFMya1BzZ0R5R2ZOQStQTmRVazZmeERicnBRKzNmVTVC?=
 =?utf-8?B?RVlvWk13ejBoRTZ0cVoxUkhQY0ZucHl0eUFZSEZja05NdVlscTNyU2trRHFo?=
 =?utf-8?B?cnRaUS91MWJPR0daVXhlY25XQVBseVMrbFU1Y1ZCWFVWYWk0QkdvMGl6ckMz?=
 =?utf-8?B?SlF4RjlwOHdodE0yNWcyWU9XbmJXK3Y0dFdYR3FSRHF4bFpWZkFQV0kraHRv?=
 =?utf-8?B?UlE0dStoVXNMOURIRlcrZkFlQ04yd0FFYXZEUGFWNHJrN2IzaHdRamJLNkVt?=
 =?utf-8?B?UktpQ0Q4OEE0d25DdjVRL2ROWWNtUkFZcXFQY29qZkZUcXhLSkJ1YkJzNnhp?=
 =?utf-8?B?NlZLNkJpejZLSkxwNXhtMkJhS0MycG9MR25OaVRXa2VoTjJKbHhzN0xCUGNs?=
 =?utf-8?B?aWFuSlNTanI4ZDdGc2ZUR3JvNEQvM3daVHkrekU5aXNxZnoxWHFTcG9YU1kr?=
 =?utf-8?B?aS9EcE91WWpxcTFUVWxkeVdDYmdqakpHREViMlk1dE1nVklpdDNtcWUvTkRO?=
 =?utf-8?B?b0ljaVNtMlZRZmcrWWRraTZRNGMwMW1vSnc0Zz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 12:08:37.2222
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e683768c-1207-4a40-5f61-08dd78286c9c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4118

On Wed, 09 Apr 2025 14:03:13 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.11 release.
> There are 502 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Apr 2025 11:58:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.11-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.13:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.13.11-rc3-gb51363104424
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
