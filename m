Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012059.outbound.protection.outlook.com [40.107.209.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975D03845C0
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 07:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776153245; cv=fail; b=BP8KZ7AU88fZXHsWemI+HC9rmx2M5YbIKkJr4UmA9IXcQ6Dohz3Aav9qjLcArd3DBmCSWDvAUkn2ylCBeDUtsm+HBHNsqcTNUVR+8IMvRQClu3JcX8Q4OkyW7xnlBl1Pb0nCXguskPsL8zMgxcuzYtOD7EHo73agyULKXoGm760=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776153245; c=relaxed/simple;
	bh=P8UR5Wk1QwZvZu+XDLgkQxlU4ICqRduGZSYJUI4B9ws=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=f2Xqy/QRAabmAtYH+bNp+P0QINV2pv8bQ6Dhh3aGb4sO4UieGM9kDsnyHGRK3p5pTJX7F+wqcZBGws7ASngBMTivjdTontryOGQ8j22bMcmHzUifvezZ0Vt/6TCFU0lZkLD7g5l5VOcNgwq37IrQX+zHCi6PKzn5WQmcyXMs8kA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fPzdhMxN; arc=fail smtp.client-ip=40.107.209.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fPzdhMxN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yWylqUtTwBiR9HuRXnOVK5UfZPe+3uomGiC5soytO71MZqdYlBvqCPGBqbYlA25ek1qqOOHu/z89qTACRh2Yd1zvAZR8Ae73RMS4ea61ChrbAhDRC1/UNb0y5I5UlyPxDCHwds7OL2tppeoi8TITvJqpdFlaf0mmyKiQHF8lPmfFIow10d30wBVf0lcC0bbIUZrbIWBfzCVDrYG5WeWSiB+fyYaT4/34zt6+L9N5dYgohasvWB5dj/YPKZueDpPiNTeeLWVD/2KLicpNhcBE8DXLUwH+5HV1hF6zDTAWWCbltUyA9E1QLpEeI95vxiWdDMFPuGxswmjem5rGbmF2IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NTucPibLclBj+e66rOzZGANRsswEo6/cYOgmTIpJSq0=;
 b=M+xDZ7DmurxCGa9YrdEpQeCEvZ/S35ErXKQLLcBOjP4jM1taXKAKxMVgniMKn6EhyF7RIEqgp1y+UexAsaqpnUF23ata8CUKkU8btBbKZEMBDIjCkGyTe8DXfOGCv2TpEosJsR82feqP4yEHWrLMzQoJDRmx42WR2QmirO5Jx/GBjRM8VxYtscrkIU+JIzlMlYcQ6pxyUEzpm+1awbhnjSY4BCSEfYGG4mf4V9ZfhKB6TGaDOZR67/eWa0q+K5OW3wyK+pEW9eIwMiuDuqZjgQGuIYMfhUiLtEfkj+b7rld7kC0v50vOQCN0lSKM1ZNxOfhCiYz/m4mtBka+qUB3vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NTucPibLclBj+e66rOzZGANRsswEo6/cYOgmTIpJSq0=;
 b=fPzdhMxNoM4u8E50wZjVZnMO2hNyjh44oNJJsrNCG0PobkfXU1K8mh5C3ky98qr5fWhLS398b4B8RYH8nBSr33OR8idORiGVmN3Wf6OfTUUGSu7k9h+Mb4W6j1Cf41hE95e/kUMO/4hLZRROJnTzbhNXo7Xn49JfDOX2Jx3q4T1pWD9i8pecFyU6QRFs2sBaSakWf7N/qmPxrpMBN8cH1/vewShiaaALgVILUNyY64hRPlRTTov2gA+FZHzwiYGZFThJl0N94LdS9hCdknXh+E1Bi3ZH3gTPR7ECwhvSgPTbWm2ZSX2R9RmvKtIFwlh9zBDiiAfG7qgPR0u/t/EOHw==
Received: from CH0PR13CA0020.namprd13.prod.outlook.com (2603:10b6:610:b1::25)
 by MN2PR12MB4079.namprd12.prod.outlook.com (2603:10b6:208:1d5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Tue, 14 Apr
 2026 07:54:00 +0000
Received: from CH3PEPF0000000A.namprd04.prod.outlook.com
 (2603:10b6:610:b1:cafe::2b) by CH0PR13CA0020.outlook.office365.com
 (2603:10b6:610:b1::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.48 via Frontend Transport; Tue,
 14 Apr 2026 07:53:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH3PEPF0000000A.mail.protection.outlook.com (10.167.244.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Tue, 14 Apr 2026 07:53:59 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 14 Apr
 2026 00:53:45 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 14 Apr
 2026 00:53:45 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 14 Apr 2026 00:53:45 -0700
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
Subject: Re: [PATCH 5.15 000/570] 5.15.203-rc1 review
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ceca897a-fa82-4346-8329-2626b2165d38@rnnvmail201.nvidia.com>
Date: Tue, 14 Apr 2026 00:53:45 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000A:EE_|MN2PR12MB4079:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f8b8fe7-1a54-4411-8191-08de99fafd0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700016|1800799024|13003099007|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	GO5/5ULOvdlII8C5Q4EX9FV6J3SyO/Dkzp5T6xB4tQmHC95R/OiVMNRkfYpf+hf4zCtsXE9t8i0KsNEJMizMbnNfsvfUfHBkQYWIv8qL7HT9jtksN2D+fxdKs7IWfGg3QdcMIKocD22P6JVxTPe9QWjgu/8wGJ0efIp+BamabkgWgO76EWxwJsSvmTH2yKlDBdfwQDAirIFtu5i++oPYVIjREUE7EZvegGAFWWLzgIqpyKwhmPx+NgvzFvGkblIvkw1t4tJUiF9xuLEaGlbhjc8lIYvrDH+rgL5tTkE1Zu6cyatYX2h4m930P7xetPS0jdQXeZe1iI6sUTXF3eivC3ZEwd5GONLBDKO0Y44IKwaVtfKuGNMDhFvkbssprMoD9BnB3DlTimEKD8UlpZXDPhEKRdxK3aCd5RZ1jlAgG8QfZkCdPfvyI7ow5QS1SYp2PEpnFULhBHZuP6hUAmNBJuQA+e9bzM07NrQBt+H/iWst0Z6/56j6tNhyuUTrTzlrzy4p1TLImfa1z8mBKA8f3ARqMhe+nEzvOuqMggjp+zW/MEjpf6NCmTpmiiTsVd2EUbIymmaD25CKkKsC5kvuJ9ic14h/lB0OrRoZQCE5AeZrRvrJsGQCVvYDGKjy5wQ8hwk5e/NZi3fKSxpmBREFxd2TmKZWBL0ikkXMSqW5BayI3hb0LPXS6LLXnwJ1VqMFGa47iTnjC9c11eiIACEWL6syW5GIksbEgxUdcj3rVt94LBZo7ilsThN2CxCvbTLSbNsk3ed+xwc3jbnTsg3X1g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700016)(1800799024)(13003099007)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mQsWMObgmsKzbV6EU/qepaXpfp2BVKK6ijDk4BrWsGHKreuGjwXkYtVBWNmgmKgtuhqrp1p+ibkAg0W1YunWk73zPjbI5W5HszOR5r1bBoUD6crutWKTVw5D/F3IXIj1sOaxnkSDk+lHBcB3NoYg2fuYQbcwvNca01IPIiTD/wvI4wm7tB2dMefmO0HG0PGosyziiVUhqn4OpH48PDqd8lC8rctTtJbd/5MFsw32fCk2ONqyc7btzdy5wEEHtQrT8kWWDmKBaRLWPvkuEhwDkqdaVsztG2MNY9zW3b+hU17uupENiPcRtaejypaXv1z3fV8XOJ3/N9lAntC86q6mAD7+yc85asKWYgzUiPcWLNDKyJiBIFEuHoPPmeqww3sbCvMPbreeNY2Mnh4+hKqbMyFvjbSBg7Njm0PPIVchHWnQoX5p5271+3qiket5RIqx
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 07:53:59.8017
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f8b8fe7-1a54-4411-8191-08de99fafd0f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4079

On Mon, 13 Apr 2026 17:52:11 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.203 release.
> There are 570 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.203-rc1.gz
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
    118 tests:	118 pass, 0 fail

Linux version:	5.15.203-rc1-g0fdd6bfd28d1
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
