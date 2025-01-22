Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2081.outbound.protection.outlook.com [40.107.236.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5520213224
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 13:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737552209; cv=fail; b=qnOLEz8LKkb/iZACm8li9rIFQfk3zC6HlxEId0GYsQmWzJIRRR3sC75x1ANKz/rIEWTkfKewS9Di1Eu0xmHiSsTJMyOtZPsyyzuNcAbAo+rBuxOgaF3bbs/+FNJJ/6u8P8U4eDUwul2InWV59vj5d/I9TyL4CK9dYFqA5vGY2Dg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737552209; c=relaxed/simple;
	bh=S141pwXUEKDZvXEDMMz9HRpG+seP/flwJkg/FwsL1/E=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=DDj0ENPxU0YBtQRun4KwZU148p7CRZm1QcL1NDu5KJtzS2cBdkpYLLciSHpyI6TFwfCJZHGBeXvC9tS8vSBq2UjDJ//zjftpoh8lUPp32wqTC0r96cwE9yCKQh/PCDo8gWxw26y6I1j6a1u+kzizsVDRX5leHDcuGgkT491lxeE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iVN/kr8/; arc=fail smtp.client-ip=40.107.236.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iVN/kr8/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pPG1/+Kt3lgi+Z4G63ZiBrzoPd3Esj30uqjHrwchaJlKeLyY/CBR5F0b9Tk/KNcdjRmqWYHaDu/5Vh4IXojU9sIJBxOpamox3Uv6JD6XBw8a2nY3wQrDKtrecQ69gc0SwduQX+0dUnamtHFMd0XMYwee6FoVoLndQHqxnKfr3/s+FunLsKkCTrWHdQ0Vj3Q72+B5U+p44sWl0s7UIP5POJWwqhTg/CjW+7ZOn0qyeoIlepR6X85J/gA0l5naa7r/Wa/eKQcTyh3FoLcKFbIhkKt+CpeHhG81R+7yl7iYj+4PsEiuE5xuewCtrnbWyd51Ko7BwhtLKsUPnoxBJkCGhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GNcs37DtOJ4OO9dYxQGfG5+43fqIcEMSlUJBXMDMCeo=;
 b=pWoB2MwU1nT55FVWngl/A82EK3R9Qxe94U+z62Byf9i5Smf8eT+LY934YbkmL0O7Qx3+OkGLVU6VFszpRDPN9ZM+AzP1SB1sFrhPeQpdUbq1c+MY5uMMx4ueSzuUArEAeugd9L7jkCmLKXHJA55nKuhSEYVQjt3uu1O3pGNciPSm4tHafPr4X0Gdua+sJnkDZMAWhwiWSVvDIFXvo5nxnEBj5Mv5JqljokVq48RzF0zF1WYgOjnoM70Vi/u9c2GvV/b+kAOhfD5CzvbQ3kLHXspkwp8+VABjufqeO8yNRkoJ8hGl9DaRYTyrJGFkFbuDPkEYOo7hlP0l2nfSuffcVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GNcs37DtOJ4OO9dYxQGfG5+43fqIcEMSlUJBXMDMCeo=;
 b=iVN/kr8/f9CJZnEVVdQZigDQKx6SLUCCkqYF5j6abh5Y5557azJZJbXhFme/2jNDzfUm1mEmcZgVFb0GGnQ0092HZvaAVqvhuFLyJpWXmnTYKwAPKvQ4+FBJiLgpzRBdkia5onJlySeIvB6v2pR8GHT33IEvTV0UrNZ+uEe9jlgjPfWwbnkS9z1naoLhXoLR4ONqO1AiKFLqySM3KQeZX/p95Cjh/6hL+Dp1YS+8jvWiNL0TN0QriSgfCOO3FvH2U2hM66lP8NlsafPZi7RUH7BfBjw8EMl3O0B1UKnhrRSgcDNkfAYcVWTi9ULi0CH2hov/fLlaz8xY21D9fTW5zw==
Received: from MN2PR08CA0007.namprd08.prod.outlook.com (2603:10b6:208:239::12)
 by BL4PR12MB9505.namprd12.prod.outlook.com (2603:10b6:208:591::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Wed, 22 Jan
 2025 13:23:24 +0000
Received: from BN2PEPF000044A8.namprd04.prod.outlook.com
 (2603:10b6:208:239:cafe::ec) by MN2PR08CA0007.outlook.office365.com
 (2603:10b6:208:239::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.22 via Frontend Transport; Wed,
 22 Jan 2025 13:23:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF000044A8.mail.protection.outlook.com (10.167.243.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8377.8 via Frontend Transport; Wed, 22 Jan 2025 13:23:23 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 22 Jan
 2025 05:23:12 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 22 Jan
 2025 05:23:11 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 22 Jan 2025 05:23:11 -0800
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
Subject: Re: [PATCH 6.1 00/64] 6.1.127-rc2 review
In-Reply-To: <20250122073827.056636718@linuxfoundation.org>
References: <20250122073827.056636718@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <821a9bab-7d5d-4f93-b164-898ec52a03bb@rnnvmail202.nvidia.com>
Date: Wed, 22 Jan 2025 05:23:11 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A8:EE_|BL4PR12MB9505:EE_
X-MS-Office365-Filtering-Correlation-Id: 816f4793-bb24-481f-15c8-08dd3ae7f2a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U0tZQ3VzaUQyM0NIaVRRL2M1RWIxSjBzN3c4TC9IY2t0Z0JrMkEwci9ENURz?=
 =?utf-8?B?WUREQm42ZU9Veml2UjJ0Y3JZb0ZqeitsR2dqc0hpR3VaeVdTZlRBNzB6WDJn?=
 =?utf-8?B?VkZvYjR1QjJ6aFFxZ0JjcmRxaVNzRHZIbmxQYkpweWV1RUlESUpFOFhOVUZx?=
 =?utf-8?B?bXJPV3hhZHdzNk4vMlVUaXoxRDJUdjVsNHVuVEZrV0hMb0Q4ZEQrNHV6eHNh?=
 =?utf-8?B?bU42Y1NpSTJiVld2dWxZVGlncTR5QUZ4ZWZzRHN4OTZJSUMrczVJSHFxaDVO?=
 =?utf-8?B?RnVJTXU0ejkwMjlYSVRDcExQcnkvVUI4T2VWNlhTbE5DWmtxK1BIOGdXeFpp?=
 =?utf-8?B?MkF5cmx5cEVUQ2RDM1pVcmlkRjBMdzZ2V2dsam9idmE2dW9ReXVMUXpncFJa?=
 =?utf-8?B?Qk1lcmJLcXZvMy9TeGNIUTFTVEo1S1kwdlZYVnlrc01mU3BTSTd5MWVjNkV4?=
 =?utf-8?B?S2dOZHhVcTdWZk12U2RmaGYxcXNSVk0xYjM4OW5sUmpvV2NldmhrVkxXeTVo?=
 =?utf-8?B?R3ZMMkRhR3gxQTRIZjJTRURUbzMvS1ZXYlh2OVdlZVc5VHY5UW1rQWs1SjRv?=
 =?utf-8?B?OW1scndodTdER09BZ0VpL2NSVkd6TzRpR1ppVzhzV3hNcnFTczZ2Um41NVZG?=
 =?utf-8?B?QzJsN0ZSTmNHcVRzd1lsY1hKNnBWcG12WHJxNzJHQWhiZ3IwOEF5MzZCbnQ4?=
 =?utf-8?B?SHR0SzBCRk42clBvK0VieGYzd3pWdi9QQ0NWRHZXRmhkSzJFR1UwNmo3aDBO?=
 =?utf-8?B?UENCQUhrUGNjVkpzQ2I0ZmcvU1FRdTEyMGg1Nmc2UHJVTmo5Vlc1Wm1WRVo2?=
 =?utf-8?B?a3FhVDVTTHJvOVpBY2NQdVVQS3dscU4vbFRxMVpPSXY2K2pTU3RVSm5od0wv?=
 =?utf-8?B?bkYrRm5ZSk12VWQ0RjhNaWx4c2sxaFpxN09XTU1wNzZlWHMvTE43Y3IzMHl0?=
 =?utf-8?B?N2hIUzBRQ25iS2dQZ3h4K3FmZ1RYRjdvWFVzcUs5YlI1djc1dWhLWW5GeXBW?=
 =?utf-8?B?U25Nb1QrNVdvbjg5YlZsY0U0TC9yQlB3eGErNGlhNXRtSSs3WXRaL25lTWs0?=
 =?utf-8?B?ZmU3ajZGcW90ZzRyY1hINno1V3J5akNSQ1A2VUpQcks2OTVPTEl4R2NJWTlz?=
 =?utf-8?B?cTF6WDMvZ1IwOHFncmRUTGdIUkZna0pQejFyOTJneW9MMi9HQjF1RlFkZjNV?=
 =?utf-8?B?c0JyNGZvOURZVkdPRXlqU3dRQnNMUENJdDVtQTVZR0ZJaXZBNWpGN0dDWTlm?=
 =?utf-8?B?WnBwcFBlYTF0NHI1WDVuNGdvaURhdDdjaVI0bXpiOVpOM2VPeE5xWU1ERjA0?=
 =?utf-8?B?VXUzZ2JJcHc0bFN6V1U3cnhxNVJBdlA2SnJKZWcrN0Q4OXNIMWtGeG9BQ3k4?=
 =?utf-8?B?K2s4OXExMGxCYnF2NFlvUFdJU21LNlV5eWozNTV1Qm1OMU5hb3puM2V5RDhp?=
 =?utf-8?B?cjN3MGIvUEh4WGg0QUtEOGFRd0FLd0pqbkpocm1wcVpYUENwZ3dIQ3JhbndL?=
 =?utf-8?B?ZE5SOXMyWHlEQmsyclM3aFcrSW9DS1pIQTZ4VHBhOU9Qa0U1S2dNdHpUVXJM?=
 =?utf-8?B?bG1rVWhsaTd1RGF5dVJpdHd6UnNSYnJoTU5CR1FBZDlJVDVEbng4Q0tvREFE?=
 =?utf-8?B?MlBRK3FZQ1RkSXdWaExtUmkwSHFiRHRXQ0F6SVZyMERPQ3dwLzFkTEdGVWda?=
 =?utf-8?B?L3ZYbHlDRW5MeWJGK0RhSEdZSjFzRnZVZERTbVhieStqZVBJQ3FyZ1dNNzda?=
 =?utf-8?B?WmNVc3RremFKdnV2RmdFN2xQRjZlSHBsNXZsNDVXdlF1ZThFSDRGczdPQTdr?=
 =?utf-8?B?aEgwT09GRFFQYWdTQlhEekwwdXN4RnBUSWI4ckxReFpEcHN1Vkx5T2YrRW95?=
 =?utf-8?B?aFRpUEZNQTIwSnNXWUFtd0pHdGVnUTRKSkxZKzlKZllBK0xTQmp3WGJQZU1o?=
 =?utf-8?B?eGFWTlRhZEVYMThnTmd5ckJiYTJ1Y1UrTG9mOGllMzhRV25GVjZSUU5uMnEw?=
 =?utf-8?Q?zfjhMJV0vR2zBjRcsHwDcfHVnLqRps=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 13:23:23.7183
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 816f4793-bb24-481f-15c8-08dd3ae7f2a7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A8.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9505

On Wed, 22 Jan 2025 09:04:01 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.127 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jan 2025 07:38:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.127-rc2.gz
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
    26 boots:	26 pass, 0 fail
    115 tests:	115 pass, 0 fail

Linux version:	6.1.127-rc2-gc5148ca733b3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
