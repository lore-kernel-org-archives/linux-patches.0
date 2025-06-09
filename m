Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2078.outbound.protection.outlook.com [40.107.93.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237AC251793
	for <patches@lists.linux.dev>; Mon,  9 Jun 2025 12:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749473359; cv=fail; b=Rdoynxmx1qVANG9nAZz55zrMCg0OaNuAbXiIAmC0mTHu2YR/heYil7Nb85D9XG3GAugEgERDmbAXwZO66iVus1XbCLV4kuBsebj+4EfYGx4W3rCVK9ZYhCfb6Ix0t7crrwYE9z7dmvBxiEu71o64G6nrprOTniM8tII0MCmadig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749473359; c=relaxed/simple;
	bh=YcZPcge5nIlqI1Ua4gLVfWirxXpppfWzgAodmud/RYI=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=DK+sWYrUIKJginmLiCbYGLWhgKJw++zkvtOLTMEhvl5B0fKrXYVoUWR1w5cNUQOF/4vWKp+QmaEu974Z61KMcxKkHWIWLVBi2xrN2NhKmfgJKWrD9PrsLHF0ZDFrwZdozjFsvX+EvWl6mu7CWNoPHhPFXg/z1xPxbWB6QAPMSSQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=goQ2mGY+; arc=fail smtp.client-ip=40.107.93.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="goQ2mGY+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u+JXcjl/KHryAE8yVtNwJy83gQkaGJxpNeuokrGwUYa8U05DRtd1kA6hkmu4JIAZKHxMtWhh1YetpeI/i+C4KCEA1wTDXxcBO4RQciqIrfChtZAODoTzNeYAWFKVX5RSDqZDFpIitooqDr+ae6mSOXKMlLrHc2x59YidMWIULK3CT0VqCOExRgZ0c9JTqaSS9tQ3Bf1jijmSeUn3xnpq9oJ++ymjS6f+lTqzFmvEfN9BymSO16qLpsGTBd2Scl8PA3JkEQI52cVT6MKrUfyi2h9hzARM4wm8oZ6wfvRfSHllJ5OahP+4Rz4aKzwe6pzj6OwxZcDYUVocL3vcKa+U1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VzsZV/5qfBSXNaHJtR1K4IEYyb7Zft15159Vvf3Kscc=;
 b=ZL7+XhdLBauoc01F46FzM7hgRAJNkbLtj0ivNUr+kLYlvvrFAbIozGTgkXZxPLxVzVXH4NfV8EwfKjMmT2Umol2P8M2ihbfxaHPelhG7IxB4YyugXEw5PLUnKZkMZBNThZvbPbWfkfp2DxXom1SbHBCW1wTU3qw37j7rVqfGYO4UUwAeyys57oQ38AmnhLBVqt/gff3QKuigOCgl8zpIJkPECH8Mt+ilyt78UiwO6efHySkbu72BnGPvmhzeitB06+y3/ddBXzppcNBMZBFg6XM0ILdXvTUd7HeTvLi2+hVPCHfn4FOV7r6PxcxdizwooyCvX1YYrpGy2O6682XReA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VzsZV/5qfBSXNaHJtR1K4IEYyb7Zft15159Vvf3Kscc=;
 b=goQ2mGY+fZMkwROGaTa5ln5bQ5l8COH1yJMisJrhphLSdzqIDKAJygGCBFPsICtJc1Ym6ko3MNNquzLF70hLgnBplGynA4GLN2KnZrXR924BysCLOK7m4jNiaeRHsJjewxSRZ5Q9kMh1TG4qzW7d2OnQ2YotqRtqTQaeDb4dVNxJ9hAEsI97K+6G7gBB37c1DIOave8qk9pghL5OwRCC+2Y7S7Xp1pAAa7+eL54dJw0Bg2o0eFxe+WjmRH4AtFPN0ZF4dy0j2Yh2QXzxTYRgU+ajDhdemXONc7wQ9nWQkUBTlk/ihujzXRfWtDLKaq9gSFcFvMf9/khpXPtLBZXA3A==
Received: from CH0PR03CA0404.namprd03.prod.outlook.com (2603:10b6:610:11b::33)
 by CY8PR12MB8412.namprd12.prod.outlook.com (2603:10b6:930:6f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.38; Mon, 9 Jun
 2025 12:49:11 +0000
Received: from CH1PEPF0000AD82.namprd04.prod.outlook.com
 (2603:10b6:610:11b:cafe::3a) by CH0PR03CA0404.outlook.office365.com
 (2603:10b6:610:11b::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.24 via Frontend Transport; Mon,
 9 Jun 2025 12:49:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000AD82.mail.protection.outlook.com (10.167.244.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Mon, 9 Jun 2025 12:49:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 9 Jun 2025
 05:48:56 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 9 Jun
 2025 05:48:56 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Mon, 9 Jun 2025 05:48:55 -0700
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
Subject: Re: [PATCH 6.15 00/34] 6.15.2-rc1 review
In-Reply-To: <20250607100719.711372213@linuxfoundation.org>
References: <20250607100719.711372213@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <9e451188-d235-4c7b-9072-b7b1f6955dc5@rnnvmail202.nvidia.com>
Date: Mon, 9 Jun 2025 05:48:55 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD82:EE_|CY8PR12MB8412:EE_
X-MS-Office365-Filtering-Correlation-Id: f9ef7a75-ec1c-4d10-b8d9-08dda7540822
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UzFXZFk3QVMzZ0FRODJjZFdncWdzSGo4R1FrMTd3OCtXcExoOWxGeDIrMVNQ?=
 =?utf-8?B?Mk1OdVNFQ0Q5d3VXNlplUUlwaWNhWmIxUEF6VVgySnVLU2dkc2VFQjlUQkFD?=
 =?utf-8?B?T3BkN1pXbFZTaU5JVXBRZldXS3FSenVwRmc2cUFHdHJ3ZWJ0TzRkSHhyUU5U?=
 =?utf-8?B?alFXTExEYkRlbzlUR2R2NzhXeGJpclAvUmdIc01mVjBDbHhYZ25PUktjOGJy?=
 =?utf-8?B?ZjNMeENETndlRU5MalpDVkk0SUJxRVJCVk84NGk1L0U5RUQzT1hWV1NXckNC?=
 =?utf-8?B?Z1lacGp5bnFLSHNZUlEvZ3RzTnlvenVzVWpiVzZKMFdqUHc3U29jV29ZcEJ3?=
 =?utf-8?B?RHVmRkVGaTdIUFdDL21POUNQUHMzQzQyem8xOEgzbE55VnRIYVhPclpqWnhs?=
 =?utf-8?B?NStlT0FjUVJURHlocmZRM0IvNEtEOW1Jell0MmlIK2I5a1htamU5YUJSUFB4?=
 =?utf-8?B?M0dZWGZwWDJIT3ZKK2kraFdHNFNkdjZyTUJlL1dXK0FDQ2E5NnphR2t0NElm?=
 =?utf-8?B?TTdTTSs1azNRZC8zR1VHYnA4Rk9VM0hyU2VyM1R6UVh1Uy9GOW9pZzNGWHM1?=
 =?utf-8?B?aVdCRGJZU084Ylk4eUdkYTd4WW5qdE5ldjdCOTcwd1NCQjNEVUJpcEhhMzhv?=
 =?utf-8?B?YTVjcW5pMGp5aTVwdENNRERsL0ZrMzBCcFF3cmcrL1hnUFNuQlJoNitlYnJk?=
 =?utf-8?B?eXdNeWhUS2MwQ252SC85RVNkVExoVG12UXlsNGpRWkN6QXJHR2ZpRTNGRnIz?=
 =?utf-8?B?ZmVGaFF0bC9WYTlGeDFtZWRnajVwNVAzWk8xK0doTUFUWGoxTXZ5V3MzMEFN?=
 =?utf-8?B?TXZaYW1tdXNCR3hrUjcyVHAvT1FCYVBRYklNZUx5NytON3kwRGNWdkVsYVlG?=
 =?utf-8?B?TTdsRGV1MElFeTU2Vmd6SjFSN3hQOFoveDBMTDBHUCt3Nm5DVU9iRHBocnFD?=
 =?utf-8?B?a0h6RGZSd2xMSGFkSDZjMm5lalB3Tk95NzFEOHFjTzlRZ2xTSGlPckVOb2hm?=
 =?utf-8?B?VXV5d3RBSmdpRGtOOTY2UmdVdVdBdThQczNDeHI5OXNmTXdJZ05oSkZzb2dH?=
 =?utf-8?B?eEFzSHM1UlJQUVFXaUNibW9JajVkSDZocEFqcTJaRkdpUFpRUHR4NGxNTlI5?=
 =?utf-8?B?Z3VTQjNmUkIzUHQxVUd0KytERkVkNEExREJSYk1vNklTYlRFTG9GbXhQSHBz?=
 =?utf-8?B?TDY0OUZuWk1MS1hHSzQ0L0NDQ1RtUVJQWWVET1FxRUtmZlV1VUVLOWlHS3E0?=
 =?utf-8?B?S3pmZnByVk1JUUxXWVFCWTE4eC9iRDZKODFwUk42MU5DcXEwMDNOclR6MG4v?=
 =?utf-8?B?WXlEL25vSUYwUmI0c2lzUUZBWVdkRXlTSWtCWFFzK2VDWW1SRkVuVWtsV3pQ?=
 =?utf-8?B?VGlSc3U4ZHVUQThHSk9EaWdCM2tsQlBwYSt5aUJLam8xdlY0SUVTK2U5Rit3?=
 =?utf-8?B?Wmg2NVNjRk1YSnM0TWcwU3pyWVRHSVl6dkxGeCt4ZjZUcmQvVFZPRXlRZ0Ew?=
 =?utf-8?B?M2o2c3RRa210aTNVaXhEdGFxcU5aNlEwRUdnUGwxcVYvZkpNWGFvU2lHMXcz?=
 =?utf-8?B?anFBSWhseW9XaXVTa3NXcXZMNU9ON3Rsb0Q4Y3AzMVA0VmcxZ2dXMURCR3VD?=
 =?utf-8?B?bmk0Q0Z4U3NYS1liSmVsTFJZYWNWUnY1aElObzR5ZS9tbFppV2dSTG9tRUp2?=
 =?utf-8?B?TkJ6M2pYYnVqY294S2o3VmlNMFltbWhidkt3NDBrN2VnTzFOWnhPZmEraHNn?=
 =?utf-8?B?RFFmb0hPQ0FFTG16d0s0SHVWQytmRE9OUjh3cVdjUG13TkJZQmlISFpxb05E?=
 =?utf-8?B?YjI4RS9wT3V2WDJFSHlUR0tzWEFxR2hsK2k4SzlLYkVFeXFCbEdoSGgzd3BX?=
 =?utf-8?B?RTlPR01xQkhzQjdBZWlXZ2ZiTHFTV0ZWZTQrQjFtd3JXNlN2ZCtIOGNxeCtZ?=
 =?utf-8?B?OHdrSXBEcmxxRFVyMmM0K1hIWnZpc0VpWFRYbmZNdTdnQldaand5b08zTkpi?=
 =?utf-8?B?UTlGakI4U25ZcUV5S3dEY1EzK04xbkdXd2owcW1Lc0Vnd3RPaERaM3YyTFRN?=
 =?utf-8?B?RURGRXc1eFN4VGpvUWx0R2ptK3VmQ010NnR4Zz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 12:49:11.0518
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9ef7a75-ec1c-4d10-b8d9-08dda7540822
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD82.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8412

On Sat, 07 Jun 2025 12:07:41 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 09 Jun 2025 10:07:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.15.2-rc1-g04e133874a24
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
