Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011013.outbound.protection.outlook.com [52.101.52.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAAB393DF5
	for <patches@lists.linux.dev>; Wed, 25 Feb 2026 11:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772019783; cv=fail; b=YWhVMysopohHbxWS/SMoEDF1iYIhF1QUDW6NtrI7ELeEMzUsD7KKMGxrAY6Y2j/0r26EBnHIBGTgf2l8ZXcM6ScnySsJyWy++22iJsD5uMpHFQeyEg3mJEcykOFVk9lh8drcUboPPkBh3lhIxALT3I6R07ePzw3uKJpNQHpRh3o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772019783; c=relaxed/simple;
	bh=qKE8wA3L8iBSZFV4EuEsVCerJY7GE+732OasKPulY5U=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Di6kwvFIsTvNKuY5+WZx8kBYAy7WDjM3MYpJK3mPw62KjM1GbDCvLZHuRmWWnEBSmL6eo1uMFsm9LRuTiFwwf5ZdcaAs+SFncHV1AZbw2xqIX3bhJKlpaKwBgV72/ZUr/O1cOFpeewgqXzkcgzkmkNE0eROx38q9/2FzmQe+xSw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ndf+7s6K; arc=fail smtp.client-ip=52.101.52.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ndf+7s6K"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eo/XiPKgl/AKNs3ZmJgs5D2Lp26n49vFAStwXCBzpMwcvjIUImg8wrM7C/No6Pf5qs/lpnvUaLMv3AR1zgW2jtcpmoRRHcgdlfP1eGlpl2zWSAOGPYlrX8UUTfJnTV3halGJZ9XYsLq9EwIHQpwUhyrmLS9a+7k1M1kQMuURrZsGAxIOowMmh09VNH4zxSqJWr0aGvDT4iVQE0KsmMHXZdGaB7Z6ABhU4//VSJMNuWqYvOWlGt8VANH0500Pe7htV1l80uhBbdLOXbcqwAPVz9g2ISUh/6Kweyt/lM6/MxQzBEXTxnE7/LmT17Ln5E7s/z6VW10ubnKQxuQHE/asBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vTMxynhcr1msxt7U0nHywriGsmaM8wO5GhoWjInn+yM=;
 b=oCH111eb3/eSKXq2xZpAHYhphKg6rK0eo1UVOwS5VTjaZjRVgWio2xbpDOTD3jm52Nia/Xhpmb+dj4zkLEk5qVy9EFvs2wL2SEDv0yfjmhxGzB03oJtzR47LuriQXf2dHPu1xHwMTgOBTeVP20T59IF9e1tSMNbHaJFJMvVEmtnIqVnHqLwzkDUV3Ef8gr6aiiR9UK836xALeWtE1TfCfQ/qK1k8ht/eTccgIEhnYwz0yPAuWaaVP/2nlu8Vmn+6SmRxLWdkKP0dvvFGUGDSb5vzXiv8ZFwdl+rVvz+dndNTkqENe6bcjpfCk/NnH0lkef61ox57Q+LdGH4jE7UCCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTMxynhcr1msxt7U0nHywriGsmaM8wO5GhoWjInn+yM=;
 b=ndf+7s6KMmEym3fv0dWKWha/QF9EQoqvV5JFlxp9z6u0Gy0kNoWdFNSqwd29/2rXAbQkvviZNC+YZ7YaZk8cuqQRXQVUy5Kp9VeiyvKRZePyVROpILR2zDiCXLly1ChMvmQdKcwnp1/APWDfTMFxYMLVt4v7v9gRd+pVULzwrI5xJ6PhNZekcqnUpcf0lE8T8Y1A93Tbizk53zOPDBE47IIs0XH721xNypIiG00kIzygq1mjbk9ig20SSBr59XVWJzEiN6woEN+x7pJtJCaKGbsyK/CsGKaGiAfWf6MxI25I7tiGCsIyAl6XY8fQ5K4kKUGkGXqaCdlCjyk+YsB+aw==
Received: from BL1P221CA0022.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:2c5::16)
 by MW3PR12MB4412.namprd12.prod.outlook.com (2603:10b6:303:58::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 11:42:55 +0000
Received: from BN2PEPF00004FBE.namprd04.prod.outlook.com
 (2603:10b6:208:2c5:cafe::ad) by BL1P221CA0022.outlook.office365.com
 (2603:10b6:208:2c5::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Wed,
 25 Feb 2026 11:42:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN2PEPF00004FBE.mail.protection.outlook.com (10.167.243.184) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Wed, 25 Feb 2026 11:42:54 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 25 Feb
 2026 03:42:40 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 25 Feb
 2026 03:42:39 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 25 Feb 2026 03:42:39 -0800
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
Subject: Re: [PATCH 6.19 000/781] 6.19.4-rc1 review
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <a69bd084-d48b-4f2a-856a-cde2ce267d8e@rnnvmail201.nvidia.com>
Date: Wed, 25 Feb 2026 03:42:39 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBE:EE_|MW3PR12MB4412:EE_
X-MS-Office365-Filtering-Correlation-Id: 456f871d-cdd4-4845-05b0-08de746303d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	1ACkRKW15dXNDnrdUpqNtQpqKI+JIC20sn2ImtqWWoyfAvN2fuw0ZAoFaFIU4KG6gqXwcENVyBQ6Nw1sijgyskb0B8wjiStkLwOdAVUc3HQ4gwiaIFrqCEdme47SCuunQRyE2Ol1rgbkkmoOYBV4ViotEJ9SCMfFHGMJAZler5A6boyNdzpu3qtJGotGjNLTVAY6pnu5YMza8yowjxJoUO3B94FWoahdfle0rqShCg8rf7DLcmRlplMlpjmLIhzlkLD4sGCvA20S6mMYO1bEcasbU5jTIh1GFpZEgCnrF97cK/q7vAO4jaB7ZvL1wY77UQH3A/yoRqmg1YOKILW4nGzYjCYbIrMLy2bTcHi+HSX2PTWZ8A7W8KJQn31kld2LaH0vmyvalTNKFw09MMeeixpXob9q+KruhDpVuxFsrELLCptMZULMaCwl4c9jF5Tu+7NGEDJVHPNDvS38AMF0CuiySF968hie8PRVWP/HLzl7RduFXIoP0CxRaSiB7Uh8JWDcPDYCQhDOuaHauJz65M+8kZhzyeGfbIA81Brrf8D7Ok9sElpUE3Ai6vWBKnyDJDi7UB9MNN3DyGPdtj57Lw86Af/l2b2Jc4/qOeP4ykoN/YT9WnDvCkLDeIDjrVitraGSijWs52wTqlSHvdNKzXQqLvqL1e3D12W4pLuWS3uQ9hLFge5So2qj1fIu+M0Yfl/Q405/EBChLEzc3yznUh0bB8xLs6KfbfrY5qt/OIw2Bh0P9qgxpurxor2cCGf0XGihdxxdlNXFgdwtWcII5mhcmRYqg17Z6yTFAMXnTZC5vZvj5QdEo47cV700+5a7LJ7uPaJRn8KLhaHWLk6wSA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/4TOCNGC+jKG/9xmKcTBKg315EQKfE4rk51naDCA3k4ESCNh05JZOzytT5FVS8C928lt/xrLG3ntJxmMzyGmTUMlpLCYBuKpT+v/PccEDUOyzvqGVIuS9xzMT6nrnIhrqdu8M0vNAAUsgha95v9YEGGQYtTbkKJO7CYoUduseV8EkLV2WQg1C6ZnKovnbsnOAIpaQ8PM7tcTGENMOfzNLxWEafDSRiQXS0VrjP96wUV+xIRaG+Esmt8FS9VBQlzFei05S+7xNNB3nD7OGovMfR8y/uUUUaVo/njjyBtY15WX68MRKG8p1Aof3lk5pHhV17P6kruFUJ28D772Rvt+kZIvjdUtPrrXP/u66xAFOKarnKvMTioKbefo8qqv+HB4kTWfo5w99tiio2t3kPu0hKgMN40sStKdSFEdiYiK/zVuUKm/sVgarcFuuWi8xm2r
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 11:42:54.6039
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 456f871d-cdd4-4845-05b0-08de746303d2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4412

On Tue, 24 Feb 2026 17:11:49 -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.4 release.
> There are 781 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Feb 2026 01:22:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.4-rc1.gz
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
    133 tests:	133 pass, 0 fail

Linux version:	6.19.4-rc1-g88b880238ef8
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
