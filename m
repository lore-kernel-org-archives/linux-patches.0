Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012068.outbound.protection.outlook.com [52.101.53.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07238382F00
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 07:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776153284; cv=fail; b=luHtkqbIPaTnmom33wc4YPxVmirUm52YopAP5tNHevGiWYDqCq8GXXN3ZrFk5AL0I800yfgQowzY2dKMLDVU7gRbpQd++A+ZkM79soyY9j9FA7cppHImR5RhIhNIeowvEWji8W/3kae4LRqvhP8PaH2GwqohRQ2wUFv3upwoX5w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776153284; c=relaxed/simple;
	bh=ybQ6aLkSTfUuUGoZVg9vE+XOZOPdhbMMnHfJ1B4a5/w=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=PSjiEBYI0dK87MNQKeBgSSsAQYODC2fXgb/Udon8xW8QcUKVEsBPHpWxC5grHkWSPzgCiuoDpGLsx15QqqMom7f1iIYIlE0YHFQ+YGwpw27IAGHnTlYgFxB+qCB2OmnOg+XcpnJ/pAaDwf2GR28QWS5FNfgOjFQV5lacfSM/Gjk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aYrhXx/w; arc=fail smtp.client-ip=52.101.53.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aYrhXx/w"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BMFX70WycbEW2Znh8uv52PsDonOeHSvSrzmxtX4ZApvIrc8urp9VtTk7cDCmO8EFG2+gVIU0edwQLwni2I2tgyzLPzrUGsf5Phu3+6vTYHjjzEcnGQNkg4qdcfh/ghq5WboT4xZl2kN3xACHHwcNsgQUIBsxFQC5L9FRmb/iCHFCJljv9RVEMIaNs4gd+skQeAb6ii28C8+nodZH/pCgE+iUL1t+63UK7TH2OOumpt97Ejt2h19d18eEFlQNY77N7XlN61BW+aLfFP7P2ZUqlO/3uU0ST25YcF7PCrPU17tpkVM57d3y0P3zi9TPQ2Jc1PIIOWoC1pRqEGXQC25EyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=23+gaAiWBtqrtW7UAvxrSyLYP+bGNics205lzMzcej4=;
 b=PNgJl7Cerxj+slUuprYXTWVy1IzQSl9Aky5AhXEHO94DrL912B969mI5RbmjwuDTr0jifA0R1HDOyK/AQkwOM5cTDHZyOk/M9BSN8bcx61We+mROHV06ixERXLXxM8Yb/vpqI2QNb+bifJgUwJN+h2IkheTKTBpLoqvBkWerXCvF41N2wxYVbyO/S+Uxw7VNXJBa2qR2nH+zrOTsEOyu/Gj95xDNZpoI/fSr2fPeQOZwGDxEcfvYXbnIBTqYaX0/5Of3vyn0rFaZ9/iYDMPovNn3Dvt8GQEKjSRytEOy5vnkAjGZB+dhKtaqbs2WilN9uJlYT5qWTqHT5arFQb0uKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=23+gaAiWBtqrtW7UAvxrSyLYP+bGNics205lzMzcej4=;
 b=aYrhXx/wbonw7zIJNTu6lTwc6d0Ds63WD69JuoPAJJU4LZhPAYsVLFyIzpDPgWskuDBRmwQjmhZXKw0abkx4l4s1m8azqupvvDWA0NFPAM0MRbSQCpMBteOecu3BfyJCbYLNhF10uze4WZOZYTxirNRtv0r2MK7Btgf1d7jg/szfZNS8ypoYz4YbMQ0n05oM238UQgSaRWTDMivZvXVaOdcqP4yykcgxobe9hI4KO8PRl+L1D6r++uwqdGiXI/5FIRZSOD1R6safSuwJW/eUSZV8ckJuz8Q2iNE+8bmazPoFJjjRvbwum+Hi9nMQvuonAq9yxi/qUzKetw6HRwDvJQ==
Received: from CH5P221CA0019.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1f2::26)
 by CH3PR12MB8460.namprd12.prod.outlook.com (2603:10b6:610:156::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Tue, 14 Apr
 2026 07:54:36 +0000
Received: from CH3PEPF0000000A.namprd04.prod.outlook.com
 (2603:10b6:610:1f2:cafe::a8) by CH5P221CA0019.outlook.office365.com
 (2603:10b6:610:1f2::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.49 via Frontend Transport; Tue,
 14 Apr 2026 07:54:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH3PEPF0000000A.mail.protection.outlook.com (10.167.244.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Tue, 14 Apr 2026 07:54:35 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 14 Apr
 2026 00:54:21 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 14 Apr
 2026 00:54:19 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 14 Apr 2026 00:54:19 -0700
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
Subject: Re: [PATCH 6.19 00/86] 6.19.13-rc1 review
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <d58f727f-e42e-4725-800d-5fb4569ff781@rnnvmail203.nvidia.com>
Date: Tue, 14 Apr 2026 00:54:19 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000A:EE_|CH3PR12MB8460:EE_
X-MS-Office365-Filtering-Correlation-Id: 7787d8f5-1a35-4cc4-5aca-08de99fb128f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700016|1800799024|13003099007|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	JCnKyPXIhN8FER7wWAtRNxwVItQM82rgAWMzv/en3j5bU/HXSU059IAEr01k0SZyZr+PCsGBdL9822h2ImVV5EdQMMY8cU44/qaPBBrmfE8DWCIEBU9Sl6XqwQSbL+ZPUwLnuATQWiuPlsKBBES26zncolrGgCm1OXShLAUtn2/cxwTGO1dQVmRv3Dz4+Bddqmk/TqnRRfaxxVRI/j2BI7g4B4LSS0yyXDqZ6pICvuDQRHCzTIxQc/uskuvv5DYbtzmNt9ivOBDPzSwb1YRs4wqsZWTqgbabIRFgd3/91lCzzAfPnvW2/Son5BpBhZNRxzEVwOMgvkYM6N2GdZSTfzLNN65pVYrLyOD3MXuuxZDRzYh3gBl2Dr/tGQK2Y+pqmsWHWGvw7mAi5quPe24gk6EBzMb8WV0NIY86OvMdp2YNKmkfYizHAz/L1H9xig9dODTwQGr4L0SlhC2u04Gl3K8ljc2Je1ryXfb7l/AXtZH4UkYQcXS0KObeynugu/jyxsDwRTyld//izaUwBqGDVlzoWNh3JoLk1SqNnllQL0haIQh37TKPIvEaDM+bZR7er3ykyog+Pt1pJwSJ4XFfZsHNPF8eISbNTdzEJG/mnVF4cb/7N7FCe+Dh0g06HroLhp2FK7dcGMu7EkJOfUBIQv7rCWvngjKQ3T+eEmCt2ciq3q4JFTUzBrmdVJwtG5KpoW1Y8K+t6BKq/Zedc2mwElHXIHlroX3aXLDzMBIbDb/br58oBPOe/DxnZ4hNsuXcfLapsz9LsOqWHqZw5gX3UA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700016)(1800799024)(13003099007)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GgxxxDINVWlTJDfW39O44HZk5X0Iz4uorMWsR/2IaUWqHglvneY8siXEJDsIgtla6KywEltKAd2KjIkEXMyStoE7LW/7WrQyy3PczpFxJuyVojsepeTZdxPZyuKmv9w84j60gG+Q4glY4ochTYXlZPXW+a4IRnwUuSXXGdipDsIJdbiqh91Oq6b/XbB7JfQY3mcBKj+3KxMYT0eYnmf7+UbhYKdhZ1H1q2zvdpw3mqy15SYo1pPHa8iQJD4IZuwoppw09NgVgR7lZbjyqhsiLToYRvqThs/XGAg10UW21h3fVo2r13+4q+HOx3dC23Lf3EeTyt2EHBrTLdpKyrTWKj/8sT2Zq4/erpYzYcgt+wptbtS415KZ23rN9QmpHwPNGlXEgmfwmEvAvTsnrZRTHeXD9SWpTs9K3POQmJY9nLK58NYEj8GP0xwbMsXWUrYq
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 07:54:35.8808
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7787d8f5-1a35-4cc4-5aca-08de99fb128f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8460

On Mon, 13 Apr 2026 17:59:07 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.13 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.19:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    140 tests:	140 pass, 0 fail

Linux version:	6.19.13-rc1-g425b22d9f3ed
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra234-p3737-0000+p3701-0000,
                tegra234-p3768-0000+p3767-0005, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
