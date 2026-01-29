Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010065.outbound.protection.outlook.com [52.101.201.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DF52EA169
	for <patches@lists.linux.dev>; Thu, 29 Jan 2026 09:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769680172; cv=fail; b=KPod55ujNh3+4JMM4JWnrHyS7RZLRFZrYQrb5EVh+c3+Mf7vAgywbSfAQN7f6xXdfRrdCO509/py2KiJ4RmXQitcBlp7EHcAgbQAJKrgjv8mZuP9lqeu2d5pzjDVfmAJVMTNkF1eFl4H0g04H9VAcCL0AGUjfq92GybqQy/vh9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769680172; c=relaxed/simple;
	bh=ZaPUvgPNti5Hi4XzhLfyX5phKtDVHMnGbFgWDI21qpE=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=K9MB/4odduEGXhnfl5e/qZRVTAkvRn9bNNJ/xH44cWMxWYJagvIlDMJwe4z2F+Yt5Y+dupw9522fH02np23YQB5uh+syPS/ZlPP/oy/mGf5xHwayWfzOgNRRKMYzmgJ44SqKBaO3EBt6KwrH2ZggVR2x5VBYt4UE1s2Ao4rzFu0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Dstx3SPM; arc=fail smtp.client-ip=52.101.201.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Dstx3SPM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xF4DvnVKF/yApSLdSb9W6HXyh8hfSa+ZeO1vZVeJJ0uBYd/PfXSvAP5Ayzhk2w0sAx9qBFABI9EJIoK+A6zj8bfP6N/ks4kwaifGI7bFxt9l3eDULQE7UWqe/X78wrFVie0bJ2Rur+dTArfJovVEtcdfLQTt+X8lXefA0MEW/1haajWw1YtMtTZWCQEIheJySlD3iF25n3PsGXcYmxcfLPT0BfEOODCeNqo3RxOaK2tC3ZwndFuCbbJJ62P0rI6NjrP226LTDUKSvbov9AGOaV0UUJn616p8jReDB+KLsN5cPG3TgBtNQu7LPo+zpL8+fxiAA8PR/0Xl9mpkf0wPDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mp5Zv/W+J4VsuJjHRl/8xIGDJlc7J7q9fldzvA4pmvQ=;
 b=Yyv4N9x0rB094QtwfNCxhsg3yQnfo57UaD2ogjvklU4nnEKqhaZ1TBrH82Hsw+c/AXtL2MNpOBnhn3Da6TSIUT7Yofo2vIrF9AG6khJfbDp5Ih0CRSsATtZUBuqXxMT98wlFXpD/nAEVBAOmUNlzGQfXCbtTP8s+9qoSK9po3xsdvZRlRs2/HlAjVK1s/dKI8DgI8gnnI4oNHnwNRV36zA4uZu3qvey6ug98dRZlwvsIUwbeKxk4xfZPVUtluBUsGjrL5ntiemGYs6sZX0jfGpkG031RcAnMBlV3GmOkNH+zAauLxPobX4+9BW8Oq6jPQHgMNsPLZbanYG7C8UGZKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mp5Zv/W+J4VsuJjHRl/8xIGDJlc7J7q9fldzvA4pmvQ=;
 b=Dstx3SPMTnJ6SQdunN5GnCJquBsYcpVWqEuiNCdsVgTXXkSMcI8ldSBmSZ7pAU44OVVsFuZoN+YaaYqo/hj+Sd+Ypjg0WOEXLbSvfVP075tI5D8pnTNd8RThv7+7rhNO/UW677jwlr+0qllyFk24+8R+W8pG5kpnmn6cafGcyDRZ697CLUnWmUYi0vfTLU/itshrCsZsaKaoX2+de5XTV7+uGjBGJUwOMEa/2eEOMhwwbrLDuFg3gqclpOO12/NfLyjTp8GKHqYj5OLcHUGBfYhYBWdXoZp3u2FBq2goHQFN7najjIdP3tYv25cWZca6C3CBaAiTML+CHr3GVPss9w==
Received: from BY3PR05CA0056.namprd05.prod.outlook.com (2603:10b6:a03:39b::31)
 by DS0PR12MB8218.namprd12.prod.outlook.com (2603:10b6:8:f2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 09:49:24 +0000
Received: from SJ5PEPF000001D7.namprd05.prod.outlook.com
 (2603:10b6:a03:39b:cafe::fa) by BY3PR05CA0056.outlook.office365.com
 (2603:10b6:a03:39b::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.4 via Frontend Transport; Thu,
 29 Jan 2026 09:49:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001D7.mail.protection.outlook.com (10.167.242.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 29 Jan 2026 09:49:23 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 29 Jan
 2026 01:49:08 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 29 Jan
 2026 01:49:08 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 29 Jan 2026 01:49:07 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.18 000/227] 6.18.8-rc1 review
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <6a035f1c-f6a6-497a-bf4b-2a357357efc4@rnnvmail203.nvidia.com>
Date: Thu, 29 Jan 2026 01:49:07 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D7:EE_|DS0PR12MB8218:EE_
X-MS-Office365-Filtering-Correlation-Id: 886e66ac-e3ba-4dcf-7386-08de5f1baeea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?THlxT092ZzNxOUhRbWlSaHROTjVqL2dicHl2cm40aWZOaXFSc1QzN01kT25v?=
 =?utf-8?B?OE15c1VwQ3Q3Y2VSMExvVFh2VUNWZ1ZvTmpIcGg1aVV2ZTVBTG5EWW1TWFpQ?=
 =?utf-8?B?VlV5emFEcmZnVk0yNmlYelluK1dXT0twSlgzV0F2UlNMK3cycVpzRWI1Q1hm?=
 =?utf-8?B?MlMyOWZTU1ZrWUJ3ODFnQTJBKzhobVVVUktnaUhzNXRxVUhTUmxKN3VqRHI1?=
 =?utf-8?B?MDdCUGtqeXdaeUVaREdyUVR0bEdRTFJ6bEFXeWZKcmdTdVZsZ2ZEVGRzSk1B?=
 =?utf-8?B?UlFnTU5pcVl6Zm9mTnQ0V3BEZis5SnZJNUNqSFMvaGo4ZEpTckhSbjNldXdL?=
 =?utf-8?B?alRVRm9mM0I2WGxGU0lHb05yeENMS0dvY1BIWWx4Z2NYdzUxaHVMSHVTOEdF?=
 =?utf-8?B?bkxScFFaT0YwR1lnTERJV1RER0YzUVFtRVZmbm8zYTNvNWdqSzlXN1N2Vkow?=
 =?utf-8?B?WkNHbVl6UGRRUGt6S0piZ2lKNU5zY1hROThwRU5YWGhrN3JKTlRWUHdKY0Qv?=
 =?utf-8?B?OGJVZFdHZGtXL1Btc2RzMWNiOXgza1pwN3MzSlFEQlRsWEJkOXJrTkRhK0Iy?=
 =?utf-8?B?bC9COCtSZHlHTW1lYWYrQW5HdFdMcmREOTZnd2l5cnNTYUJ2d0ZlRm1tS3lk?=
 =?utf-8?B?cEJreHBKQzRLREhFUXROTXNNOWsxTHhHSzBsVDRUbUtPRW5nVDhNTVlSRFFp?=
 =?utf-8?B?NVllZXE0Uzc4NXpHQm5qZUZqZmYyTFk5UmQyK0lneHNmR09hRmxvSWIyaEIz?=
 =?utf-8?B?MUZjUjh2WUZOYmYzMk5ud3BBRWN5d2dqUnFXdExnMW5YYWR6Rk9MMHZFd05p?=
 =?utf-8?B?SVBQMnVzQkN3RzFmWSt1YnkrT0VkSEdsaDgyUVl2eVVCcWhRS3NsTEVXZlpq?=
 =?utf-8?B?UWVLRUozZDY0VVQzRjcvNHFhcTlXMC9OYzBHZ2w4UXl3UnY3R3ZraGF6ajc2?=
 =?utf-8?B?MThrK0hFdkhNeElDNEVBMHdBK0pQYU42ZnRETjVIdEZRZmZMUkhYUS8rWVg2?=
 =?utf-8?B?T3dJdU0vdHVxQUZ1S1Nzb0VFQzYrNkQ2MVYrUCtlVEFLMHMyZGVBOW43c0Fz?=
 =?utf-8?B?Tlp5SEJZN2N2RUtZRStzQVRCMm9RODJmYlZtWDJSNnZEY1EyYkpvOEtwMlln?=
 =?utf-8?B?WkpDQi9QOEtZMkQwVVBKWDdtSUllem55clZBRGc3TnBYSktJT1lncmR5TlUx?=
 =?utf-8?B?THR3Z0RqdDFFcjBPdTMrbDFUbGYvYnU5MVRJY21ZbmdqRWk1OHROdkY4ZldS?=
 =?utf-8?B?OEJXdEkvbnFjblJLTmx5b0lMYlNDczRvNk51bGwySTBXZzJRalovamcySUVu?=
 =?utf-8?B?MmowN09OT0tXTU5TanByY0hUVFhWbnNQZzk0V09YNy9vMFhzbUZyaUtzajZF?=
 =?utf-8?B?MTd2QmZ6UGRGMU41emE3bmp5UUhNa05NUENNVUpaQW11SnpNVmE5RGh2amRL?=
 =?utf-8?B?aVZ4RHJGR2gyMFN5M2tXcXFhY096UlZOcEtiS2d6VVc5WWZyYTY4VnF3ditu?=
 =?utf-8?B?Y3A3OGJQdU9KVEYrdkwveFRTUFdkSWNuVWNtWnhUNlRKbXJIUDNCZnF0YXV5?=
 =?utf-8?B?THE3bGZ3SXVKeUl4cGlDdmFiMEJqT3VyaHduV2RlTlVpRTdrT1JqRmh1UmN6?=
 =?utf-8?B?VUFXSjc5aklVSDRURXY3WlZiWnZtWnQ5dnZMeWhkTFRQcnQ4YUVralpHTlFG?=
 =?utf-8?B?TnFmeVZFd3REeUIrWWtYNThMck9WTDJoSkN6enJ1VkRwWVovS2JLZGxvTTVn?=
 =?utf-8?B?OHpjdzhkTUJsbUpDaVBLT2V1MGVqU1pyZ3lvOCtrNFkyaitma3BMbVpOY0xX?=
 =?utf-8?B?UklhZjF2TTBFZS9KOEgxRnlzZVBjei9GWVRBZEp2M3FJMVQ2L3VlSVFpN3BD?=
 =?utf-8?B?ejVqK3UzWEMxTlVwdnMwZE85Y0JxWFMzR1kxUzFXb09IbEhnMFdCdFNkR0NJ?=
 =?utf-8?B?Nlp2OWxLVmJvYXNTajlQdVBkWERKalhKWmVndHBOckJrWXVGeExoeFV1dE1q?=
 =?utf-8?B?UjFOYlhLckhweGk4WUdST1JkeHlUSUY5TFduT29VOUVhTnlXTURGNm5OVGRH?=
 =?utf-8?B?eEIrSWFwVVRybDVtYjA2UGR4WWVuUjBza0xyNmxSc004dnA4VWc4K1ZPZ0h3?=
 =?utf-8?B?bmxBcThiOEppdjBMMjJyZ3Ezc0UzSzJGczlweHB5WGVzOS9HQkZ3UlEwSG9w?=
 =?utf-8?B?cTg3WTJDQ3d1bE9yc29MY2hOM25VMHcrajc4R0szNW5tN3dScVp5V1dKUkZl?=
 =?utf-8?B?QzYxcFFDV2JlWmxva1doU0d4RitnPT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 09:49:23.5219
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 886e66ac-e3ba-4dcf-7386-08de5f1baeea
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8218

On Wed, 28 Jan 2026 16:20:45 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.8 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Jan 2026 14:53:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.18:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.18.8-rc1-gc0a52e9c6618
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
