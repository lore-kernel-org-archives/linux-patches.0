Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011036.outbound.protection.outlook.com [40.107.208.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD6335CBC4
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 14:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772547147; cv=fail; b=jNelFPWqZiLvSAWX3tr1ZXr1Cq3wZEWNZGuxJoqCWZEuSGykvpNTugB8OCoDUls4wZKxYG7laheXkWId3qQkF4viNBAGeLBl/C8gQCaF9SjX2N2powZXXGsZX667WBIXODKsq+xs8KTHEfY/Lba3ifUto+YFalC5dpUVj1VUCPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772547147; c=relaxed/simple;
	bh=/VnRVuGfX7MSpZhuHSwsWtIaBVg5Oj5ghq6jC1OKoOI=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=uX8qGRf0pj1Uf9/Zx9O2VV0xEXiEYxRQV9KPXVpxfuJoNhw2ct39D3zH6RyHvRWlY6sp8Ufc3FrGa0xNr/7DkMuGAOAbdWeKxs34GrS/XaYixMBPWzLtYo1jKbEopRndKtO0uc1KvEv3icK3AmRSGmZkrUACiFBIo5KP6SH1xyo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IelEeG57; arc=fail smtp.client-ip=40.107.208.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IelEeG57"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fhNGCWu3OI5KwCZDHT5A7nssne2mjxXrJ3SL36XjNxf495oiNOuuL/r2lUJf6zcII4u2AIMnVO/CqTcdajDAJxLE2MX0qlmRpwCy/cKarrQ46jYV8LM2qCKQmA9bgkc3TpJg1NANpINSQfWMYoCosEUQK/j9bpO3TmWLxI2flDw/cpcMlxfe58RG6xp1WKOerzbccmr1oTupbnkvREIpTKvhjR+aUrkmBXZCBn1lGnp+iyy0/WjyL0TMV4xxwP/RnVe46me79yzKjsgMrWLF/0ApekzDB/X/4YvBNYoijFTlzdHUuaNblhttneSaBynWnfAzjfEFAWWdE2B4HtNbdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i2NftyahK3DdWGLJk3JTQZQShkCb3Erj+82K9aFK35Q=;
 b=pFLewCv3ykMNF6UE0yx5h7/M+1spah9LDCI7DemnDbu+VBZEl4GvRSrbsjrbCbpdQUl0pTpYsV1QL/RUQZOjotmSZDxTcLeZoEjZJ8J7MXlps44MWed34JiEy0LmR1XBpHMrWA7vDo9zAlyYNbPBDDBjK0iokSfwOi/PWKhoAQVuQk2z/q9R12rMKTIwmc0pyVKJkN1ldROIUfd0/XlxJCsLOCVa1kSTnk+0R4RxcITm4E8bOMktBdGm53RDyzXcjuB4kE4hOu+V9uB7TS9ZspIIjJV7bIRRWD8PhcC16vsgREgueSDTWUejw0EGTTfFgqsF1TC7VnFJnkhe9Ol8lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i2NftyahK3DdWGLJk3JTQZQShkCb3Erj+82K9aFK35Q=;
 b=IelEeG57+w4/fIrYJWjlZwRaFm9OOFD9288kLscbrWdV/C8VUirSnwu3gIoMB0uUh0yA6v13ktT3GYPeE8Q5hEZuXyHRGZTNQsdqqSry/NzndPUQtVWdgRBu8LKQ+7h/h3essd1UzW2FyovzzuuoOZVeBfOJt5/a5d6ih50qaatzTlnDsRmJAz+CMM3J5C8mASLUkk7PDlhRGlZk007YS+MPUC8QuW8NXJrw5jeKozgndw44lBuIG6OO6VIC6Q0nmUspcLoPC3irEfCKNI12xD24ifCJZlnNCzPR92wKbUh6np1Re1rFb47BModjltXTxlECuqka/KMXlzIXw1nh6w==
Received: from DS2PEPF00004568.namprd21.prod.outlook.com
 (2603:10b6:f:fc00::50c) by PH7PR12MB7258.namprd12.prod.outlook.com
 (2603:10b6:510:206::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Tue, 3 Mar
 2026 14:12:18 +0000
Received: from DS2PEPF000061C2.namprd02.prod.outlook.com
 (2603:10b6:f:fc00::215) by DS2PEPF00004568.outlook.office365.com
 (2603:10b6:f:fc00::50c) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.3 via Frontend Transport; Tue, 3
 Mar 2026 14:12:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS2PEPF000061C2.mail.protection.outlook.com (10.167.23.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Tue, 3 Mar 2026 14:12:18 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 3 Mar
 2026 06:12:10 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 3 Mar 2026 06:12:09 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 3 Mar 2026 06:12:09 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Sasha Levin <sashal@kernel.org>
CC: Sasha Levin <sashal@kernel.org>, <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@nabladev.com>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <sr@sladewatkins.com>,
	<linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 5.15 000/410] 5.15.202-rc2 review
In-Reply-To: <20260302160955.2522727-1-sashal@kernel.org>
References: <20260302160955.2522727-1-sashal@kernel.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <e0bd19f0-477e-48bd-9a9a-ce33157cf0ec@drhqmail203.nvidia.com>
Date: Tue, 3 Mar 2026 06:12:09 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C2:EE_|PH7PR12MB7258:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c035a7d-ff83-48b8-fb1c-08de792ee0ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	dQ6OWAX2I+vr1hLlYWG6bNP2EYfZUBR8Qu5TJdzIj/Ek+RX7fypaTPx6wkzACh8lHF9rhViQdzlWYDq6OvRvpmlS1gGogekmilaM6CAtLYPcisNt0rxuiVSFTlH4hIG9QK+4F9+ogjhl03NPsYUfLlKwECedsRjH6cuO2aBa0cWHgoWJ24FbrvolmewEFweqvZhs+FU0SpKLnOxSWN/Ep0bi192DPbvSUOQ5UC5Z8MB7fVvMdUL4wp9RklYF8ftH2z0w9PArruUQ41wg5zR+NjyDKYAEaLMEe0pXvBu5zt04vVlThNyP2DnFX7SVOH+nGFgTFE61NUY7kRAI6X907C6XbX78nJ9JjVkJka+E+eEDpkTlcJeCX17bzXMcIotADA1oaE9JUvRocEXdc24azwPL6tTgEtTWnEbJx/zivSe/MuzojuDhAX3k/IOug6Df9XDfHQsk2iTKAY0KLJTzbHJvm8yFdUjdd0lro4Z7jSG7Z3yNz/LokIrQkF2gfJuHkUFJmkqDusCCD2p2B3Mp3u2uNibLlSCA07BWXqFy7qEes3SMcZ+qZA89AfhjWv/Da3RwGbM2mhnAd5z31BNS/+AvF11o7K1ejwc94FMWUTO+OoAalOIYqx3m4ZwrkUUb/K4qNng/d8sB4W+EnGgLdLegp5yW1vBU5GP+Sw4IYtrtpyFrcCA0xPQEwnbK2y58v8U1xig8KKEW5fymot6KwZhaf5ZpXEf9FJnHOOIWENZk0IGDeCVl9EcBme2weTumoQYxWl6VrMSTNJZp8sPuC05J5IYFkVNJ6adX0EG07TT3NZYXUXwZcEAAsNOL7ohHiFYAQER9f+DOW8NOiwqkvw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SRZvXwnU5G6BqnwcmZQOEU0vrIWEumk+Ja72eCI0ZYZ1QY+f4tyR7kT33IdVZEwUh4icRXDr0o6wCkWmGuh4b9xZj5C09ETOB1ATFv6iYOT4pKPsnYIxZQIDCchCzjBYMEvVmfm9cq0JKP29qWXtiJ7FJlus9WLAJVYpkr7L/FWCB+fIsnFVpH50WS/ufftv8cN5V1o5AR7A4uPC5vudDnBm++99258UL63QODJKhvxnZ184leXkc4hNuk9XJhhYZdtmpRNK+h0xzbAT11HOqmgm3p7yTBUnlddV0O3X8Q8FUY6UchPYgEASBZ5U60na3QAaimMwWz2POjk5Nnu+q3FEd//rI3/TpMqctauAcHQhAYiMipEryPDJ5ZliL7cytjprER4HHAfsQ3al2ddIEbfy7jl5hD7eXqsdg9nCssRDaQbA4vBnlEjYFIa2PXOV
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 14:12:18.0757
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c035a7d-ff83-48b8-fb1c-08de792ee0ee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7258

On Mon, 02 Mar 2026 11:09:55 -0500, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.15.202 release.
> There are 410 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:09:54 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.15.y&id2=v5.15.201
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    118 tests:	118 pass, 0 fail

Linux version:	5.15.202-rc2-g2ecf8c20edad
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
