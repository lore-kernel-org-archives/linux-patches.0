Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011033.outbound.protection.outlook.com [52.101.52.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A733090DD
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 11:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761650950; cv=fail; b=TOxW1wk1KkDcQz5GEF7IGzoTuwZEhA6xApurPUwvFkFA7LQaeF5jMl5nafQKdTcTHUlegahOQw4P+DajXTHPBjuMVf7ju7dzou71XSvHrVSiVcxPj4tJcjk4r73D+DaD8B3UyQsVESPyAOXz1kRNkZCxM7Czl7nK+DnI33uQUQQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761650950; c=relaxed/simple;
	bh=wEsXXXXGlgLVZvz9s7tcgKtY8YRkBE6f37GBWwOur40=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=L417j/L0lF10NUPLPYa8fBIa7Tzs9lgGYiuozb/wMMEvR4bsb9TI4ecVi63GX8hIKixgUfpVaUp7LYx+OAhkFs/jQzUp91pPQM1QMPxhBaL89dw0WEp4TYpiSf6w+GxM61F6SPV22m98Ofkhc3Z7yItGWkBckU22H8BJsANo734=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jOkJcMDl; arc=fail smtp.client-ip=52.101.52.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jOkJcMDl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YDKXrIhwspi+AfUHIfNNnvnL3hd34/5IN5knWwARqbqzUc2+WKzjgtrutUCN4PSiQcA2Uhw6xQGcv9yepl2n+A7PLNEaNq99UK6X01APYQK0QYxpdE7yHTXFc/BNpT13WJpCIDnF37KrlFh95VVNCN0v1e/IIz+/y1RiKBVZrceEdCTs3FoqU4WQA/oKvgBUunqu6BxNNkeSareDt26Z5J4GHo9ut68Ox9IABxcvZrshRS/hx0nXtvij8YZSrmRu4g38Qn7XOrq3AKRhtSJH61fsoL6Ah8z+Og+u1n+2fQX13174nwu2Xy1ugfX0nXnCkJHwx34sTZZFEtJDXhIhHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TuwE6dp+rSiTBrrK7xLcs2a2Z8+n8hqrbh8hxb9Ww4Y=;
 b=Sq88NPjNYNk9fS+JHPTiD0IihTbm2ql2PMYL11hZzEKHceKexP9wxpil8WYhJMBqRCT8/cB2SaquaqDFxNgUpIkI7BuJmLz6gxERGk0rjkaWv0oTjZToaIfligoN5cP4OrTgSmzldUFGjsTJQcZKjwvorC6zbOC3SwBbmb766H7t9ZM7b6xL/uWoSZSqj319MIVKOGR/fNb8r05tppZRjF8tY98wp7I2keE/6B4K0Q+D0RciSwm9xMDYXzRs86h6MWbkXpVgAKcj4Vvtcc3lBjhZMovPNWk75AV1L27rL+TWnOFx3KncX7vJXplpFG78mNiytqr5RnZs1K/IEdvEbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TuwE6dp+rSiTBrrK7xLcs2a2Z8+n8hqrbh8hxb9Ww4Y=;
 b=jOkJcMDlYV2EtBrQR9P+vgtVF2UmJcix5xG93SBNY6dtSJo/jqXjsvQ+f3ga/2EV5oF/Hd3aTvShSNmXJSVKZrT9oLuETmO1QqlTBjhRtBGtH6MWcceONlbhIi/e2FNtFUGAyfxsi4iF15UbqgCLdJMvscjI+9xtamY8uHoJQr/QfqjMtNlEdB+L2dUfuAr3eMQh9aK+ISpkjEdcd/76oPzb7mVoH1KJkf9f4KLW66BShyXi0Hlya0i/6WUxOKspz8HnQMkjc13ouDHcoha3SyJ1fimZ+nDDILmLC+lbbyhUC9ehRENYvFj+ahNEEpETeru6VdsQDzkT714diZnyPQ==
Received: from MW4PR03CA0249.namprd03.prod.outlook.com (2603:10b6:303:b4::14)
 by IA0PR12MB8424.namprd12.prod.outlook.com (2603:10b6:208:40c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Tue, 28 Oct
 2025 11:28:59 +0000
Received: from SJ5PEPF000001CB.namprd05.prod.outlook.com
 (2603:10b6:303:b4:cafe::96) by MW4PR03CA0249.outlook.office365.com
 (2603:10b6:303:b4::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.18 via Frontend Transport; Tue,
 28 Oct 2025 11:28:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001CB.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Tue, 28 Oct 2025 11:28:58 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 28 Oct
 2025 04:28:46 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 28 Oct
 2025 04:28:45 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 28 Oct 2025 04:28:44 -0700
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
Subject: Re: [PATCH 5.15 000/123] 5.15.196-rc1 review
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <6b6eff65-5fd0-4f77-86ac-266df86d6cb6@rnnvmail203.nvidia.com>
Date: Tue, 28 Oct 2025 04:28:44 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CB:EE_|IA0PR12MB8424:EE_
X-MS-Office365-Filtering-Correlation-Id: 7881cef4-e7f4-463c-6993-08de16153012
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?diswQk1ueGRLR3FyR0V3UXVpUms5NmZiakVKaUplZzkzalIvbzRoclRxTk1q?=
 =?utf-8?B?M3RaamErVUNQeEdpSEI5ZjNDU0dtZlVuTlNwR0JkZXZkQ1JvYTVpRlduUG9Q?=
 =?utf-8?B?Mk9hTFVnYjlWWFRiSFhWRGtTSDcxTlNVMWJJajh4Zlliakp2bzFHR1A1WUdW?=
 =?utf-8?B?Q2prVlZVOURDVk5jdXhRM0tieFlaVGowZ092RlFrbDlwOVY2bDg4WnJvQkJL?=
 =?utf-8?B?ZWJmenN3TXc3M3ZicUtxRHZzVFpmcWhlZTc4bkdvc2J2cTZNU2E4WnkwRlN4?=
 =?utf-8?B?M2s1cmVLa3ZBNG5ML2xRV0JyYzRVM0x0TVhMVFFHR1pjTVhSdHY3cVp0TUpo?=
 =?utf-8?B?ZEk3cTZHWkdvVkE5Q0VxdGxUTkpFeWxiR0dVSHcxUHhtQ0VuRit5clV1RVAx?=
 =?utf-8?B?ZFBxTm1tOHhXZGVUTWpyNStYQldtclp4NkpCbHR3TGtnN3ZpSDNJcFVUUHlv?=
 =?utf-8?B?T1NzdXJDNVBES1Z4Y01wOVRwTmFHNGdmVmxneFphOGxBYnh5bUhnSUdmaXdV?=
 =?utf-8?B?Qi9CYXF1ZXNrSDlJb0prUEZVTDRiaG1pczY0Q0lKU3QwMTlkM0g2anFnOW92?=
 =?utf-8?B?QThPcGxQTFNrL1g4RGR0Mm5MTjJyQ3pSV0N4dHRaNUQ2T0NLYUZvUGNsVVps?=
 =?utf-8?B?cWZnL2lFMjBLTXF6eHFUNkE1TnJJUkJpcDVmd0N6ZjZ5aUk4Vmlyb0JKRGhP?=
 =?utf-8?B?VGlVNGNqKzVmTmgrc2t4ZFdRMXVDSnNsaG81U0l1NG9ka1BPR20wYnRtZ3NL?=
 =?utf-8?B?S1U5TUJNQnZPeGNTOUR1dGdlSk9CU1ZlNjhZNHFXbkN6ZWtQd0xTNENtdGVL?=
 =?utf-8?B?RTBVR3pHQVg1S1hHR3JrR1oxbjdsMlBBSHRVWjErT3k4bnFNOVRNaDlkQ1oz?=
 =?utf-8?B?V2VHN3d0azMvYm5yN3F4ck5KMkhEZ2ZtU3pjV0k0K1pFamIrS1BIWUNHdnlD?=
 =?utf-8?B?RnVYV2xwNFlNM200V0F0YnRHaURNZ1o3NmRKOEtybVVFV2I4N1B3RkVUU0lh?=
 =?utf-8?B?RlBGdHpIQ2F2N1pUSTFWN1ZJNlFHbkRVa0lFRnNqNytzWmlGajdSZVdHMFpS?=
 =?utf-8?B?b1hBd3VNVURkNnJ0SlhscHNhalloREdXZVFnckNxTUIzZFo0TTJYdjE5clpD?=
 =?utf-8?B?cnFTWlpRSjhCbHRsUVJiUVNka0pzRzI1VENBdm5KbzI4MUpveUN1YktBQVFG?=
 =?utf-8?B?ekUvL3VlOFV0N2x0OW0zeWlteHlCQmFLQUdQY0hRMFo0UmhRb3pZeG9saitp?=
 =?utf-8?B?eDE3ZzFObnZ3WDd4Y3J5QU83YSsxZlFMbmw5aGhQVU56UGJ0K3dYZFJwTUZG?=
 =?utf-8?B?ckZ3SGxWREN6YUdoWGg5QzBQTWpUTWRPMXhpS1BJNkhrelV2eFplZlBQNGpq?=
 =?utf-8?B?eHkyV01KN3FaM0JXM2NEbENyWndHeE5JOE8yOTBzVHNneUhUZmxCVEVhN3E5?=
 =?utf-8?B?Wjg0VFh2QWEwenNMMEVVOWFvMUFDY3FCTGpvTVorUThiS3Vxdi9xZWdsOUNh?=
 =?utf-8?B?K2l6N3Y0WXB3dyszM3NCQ1V0bEgrSFBCM2hoNG82Mm11RVoxUGFsTDhITWRQ?=
 =?utf-8?B?UTduQ0N5VmxoNnlsWUhFZFlPcG9BRithdU15QnZYZVUySjU5ZUNTazhDOW95?=
 =?utf-8?B?eGlXQWhvR3h2WkJQOHVDL002QUtwWFp2MzZ4YWcxVmpOalF5UmFxeExvcWl3?=
 =?utf-8?B?UmU2OHlxUzhKZkpDZ1ZXMmNCaDRNdDBSMEc3bXhHYXlsbjEzMlVpMlZOQWVZ?=
 =?utf-8?B?bFl6MEtZbEJERTlkMXU0RmNiWG5KemNqZ2wzZjA1SThVc1lkZnYvL3lMZU5y?=
 =?utf-8?B?aFBIanMyV05CR1VzM3lmSFAwcnd3TWJuZEJvaUpkZmhleXVFNnVBNERXNWhJ?=
 =?utf-8?B?UkJ3UzdRcmxjNklMUjZDeUFLalpHRlNDOU5hTk5hTytHMEpXWjAvWFA1dTBz?=
 =?utf-8?B?RVF3dnJWdzRLVmlUUHlLZ0RldWxFN0luVC9nTUJkc0h5VzFZZzFJNnFabWNm?=
 =?utf-8?B?UlQxcjNJSlVsVFNLZXF4RFR0WWExZ2JFNVFSRG0zckcvK045b2NrQVBoSjhZ?=
 =?utf-8?B?aWJxZ1JIZ01ocVBUVk1VRzBmUHJuSjYrT3R0K0xZcERHRFpuODNvUHRUZjZm?=
 =?utf-8?Q?2YG0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 11:28:58.9483
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7881cef4-e7f4-463c-6993-08de16153012
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8424

On Mon, 27 Oct 2025 19:34:40 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.196 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.196-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    105 tests:	105 pass, 0 fail

Linux version:	5.15.196-rc1-g01e66f319490
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
