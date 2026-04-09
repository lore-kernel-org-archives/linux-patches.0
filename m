Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010009.outbound.protection.outlook.com [52.101.61.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08733AA4EE
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 09:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775725506; cv=fail; b=SzrNVRF7JHFXpDNEVJ86UizRQEV9UxV1XT7uAnLdePe3P0FzuOJdn3oeLy3gFO2ebj8M7Q1ym/yW05UPoLWfp9llBE6UpfVyNm+/56G9Im9ed3xkjRcXZfHPyKAuoudERySLSHNfZ1UVbOH7FA1NembPKFZmU1LQ4SKX3Y54RTU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775725506; c=relaxed/simple;
	bh=JJbahPULpENc/Ha3fYlCoc4QqZKH/p1AEmQD9OQlnYo=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Ic3uteCMfJPMKr2RNk0zu7SC3JcDuEkaTJyt+hQAHfKYFChtFFDJ5AcJOHhaZ6TnyRXh4HH4oNDhhAzgIzs4y4XkdtQAgSCsJhdkP/8QdFKaYEpxDz2i4Oi1izhCnGW/0DWI6VzwSeYC0jgiXyTeHJNr5bGxPHJSZ0QNI3Ljy3s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QjIJW36Q; arc=fail smtp.client-ip=52.101.61.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QjIJW36Q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gRzzAqJ5AyE/ZkFP3gxObyAoze+30656YNgVFxbszGd0XKh1tQx271TqHkl9UsoHqEuM4y2+b0HaYvH5tIXV6W8LLWm7n6midtqo0b7Zx8puannNBsp5K1ifhOy9RmTEPcTf/NRYTAjXCyfAyGH4dQCVHbaqip1dpv44tXHoRe3tAC6JCGzTQCIiJh3jIYisBtfd6xfStieUf5NmB17i6ktU2i7wwktGmMYii+I92r6yTeS6RS6Zagmq7WBHAPz32WbHbuaEX3rTQIYgGqCQqUKTXnXbL4CD77JDzgic/+et8dpgxzvoYZStwJ+TmPHbnL/rY4qSmrSByRBBqLxy8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sn3Vvu1bKWQSHBzz1rio/CWWs/Q9nVQxRQVhJkK3coI=;
 b=vVpA/2zEj3peYi+C8lSis0I4kcSeuzHW4etXbs1qD7+xrtBmGpklmAXiwn1a4NDGDZijNX+2yZc7S2lqfP+hvDZtOme/SCMSL6TcCDVSyHYvZR8H/5MS436fHpcmSj7c6oZn+LgljP/rfVlkdxq7fi81RE2lFFV94PpmNxELmBxRoSWKMSo88nFy0OyNbGzFZz3PM/NupzloQ1vOIn3klSnUgRrKw+2cISAAxOUcXNuoarcdM4T4E7kHesRv+TCXYmLykG3/oE8kaBy2Gdr1PAhVISvE9GevOYQ5bUVSxdKqPxp1p4jxX3VfKyFLxEKN//bw2UP+i7xTnJnSwAd90w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sn3Vvu1bKWQSHBzz1rio/CWWs/Q9nVQxRQVhJkK3coI=;
 b=QjIJW36QfqIA2PSBlWX1/oknMibRhz/2wKrPs4oyMSJM8GVHZvfyvSLpyIzDRts97qiN3G3aehUntN716efDLRBUDsM2qa1el7MLTXUSAIN97T5YcVQMe6YF7dQV1gDT2Amo+OueAy/TH96eZ0j2mdyIEkWM8xyxZqR9eWS13Yb7c9S2a8ZulVYB9TOtHDcOFlXRVSjiIf02QsyA8MEDXG4KYyJBeYOMVfm5N7R38BUaOfiJdViywnzrjiwBI6S4BHH0jQ6dHx6Ktd0bShDvKmYFRV5oUC5QviCgVAmgMRPk2wAORhIeDRaULUdJG8+HHSFUwO38K9RtIyQmGCqrcQ==
Received: from IA4P220CA0007.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:558::16)
 by MW3PR12MB4393.namprd12.prod.outlook.com (2603:10b6:303:2c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.7; Thu, 9 Apr
 2026 09:05:00 +0000
Received: from BL6PEPF0001AB58.namprd02.prod.outlook.com
 (2603:10b6:208:558:cafe::10) by IA4P220CA0007.outlook.office365.com
 (2603:10b6:208:558::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.41 via Frontend Transport; Thu,
 9 Apr 2026 09:05:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF0001AB58.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Thu, 9 Apr 2026 09:05:00 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 9 Apr
 2026 02:04:48 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Thu, 9 Apr 2026 02:04:48 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 9 Apr 2026 02:04:48 -0700
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
Subject: Re: [PATCH 6.18 000/277] 6.18.22-rc1 review
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <3422aee6-16e6-4eba-b82d-8f1679a23ae4@drhqmail202.nvidia.com>
Date: Thu, 9 Apr 2026 02:04:48 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB58:EE_|MW3PR12MB4393:EE_
X-MS-Office365-Filtering-Correlation-Id: 49576cf4-ea99-497a-3309-08de96171448
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|82310400026|1800799024|13003099007|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	h5DKbV+aWe/KHB2lZoDRGGrBBN4FOynGhrxnDrKRF1iJTdSvciBpEFXg1zig0cWctS2yYDOOBmgID/t9vPzuW1XDwczQazW6nuV3LiuT0AoKC9To8Yx/WGyzfQWu4XY2wxNrJkDcTPojDryeQ0zJyu/ambynnePltF43u9aAh6k0K+MNPfnm0O27PFQnY4Iz/L9Apym5tYV9A95k9oUuaMFlIviUQBalAjXL+5LBPe6xW0JBFY4cgwPuo7iMSg5c6pjTcaov2Aip6hlXWUFqL/DNIfT/LfBiDe8vVgMM4MAcT5KubVg+PGLZbB40xxcJGjiQVZUSYP1LEgvr6fPAfyiuJrUsOHqZDd81VjqdRsMUAewVNB9N8wEFSuUCmoV+uX/cwTbxk3e9SfSvSpoqdS5JSicJY7GWtYZ1y53QR5hmg6UTI1m6S2InQ/cFujFLsru8ifKNzVYqI6T9QHozIxeQqFYoNMvcxJXvzcp3vwjWTq3VYVPNo0oVTb+PFDSL9BMER15IOnAcDTli/AZgjQekP2McdrVLEHk1pLhnUj3dJXPUfo3ts+1+/JqPBRaMnfz3VZ/2h7rCBEQBPdDzp6ZDsE4vCx2934RPcJizK6WbmndjQaEqjk04Xf2IsZBr0ORbx0MMyGqsSLX7MFe4KxBrDTFM6kNYTJgThECrz5QENQ09RJDvqR98UTgpZ0BStWItqU9T5vmgalr7Cj4q24aKwqyPgUABqpo+scO8b1cICFXQZW0Yxz6fk5r+b/jKLKdrzv8POHDR7kN9ubiZuQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(82310400026)(1800799024)(13003099007)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5423fbwe+jeSsokWIedS2XfZPFfEVG4AVIK77cfFZydUrpDmMjSak1qwVwfLwPWpDPkY2l95S3mG3uwLp8lLI0v6NTXQS7YMJzTl6n1BGeM7Frtporv7Falztr4awQkngWGd7QTGhlFwDM5KRKEBo5xxQ4Xq8s2loAr74N2HnZ4G4eH5+k53sU2mvmm2sByCgcSO2v52I+rKH3T4CXpiIO9UzB6E5siHhdwpbM7pz6KSQiW+vBcnMymeM3JJrbNqbkqvHln59LZ42b8KdtaHAq1R6aOsRsEYJXv1JCLrlYoAh9JwFp0gLHiOkzE0SaCJyInNkcSFkLCpeYszi/0z/AHNg4gQzlXQjzpuPhTck3W+4gujAtR3a2EtmYTIzMVywylVuAOc/9MCrm+0y3Qkfoja7MM5fPIuyEKwj2nl54JxdT87CaeV6F3kL15pClX7
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 09:05:00.0045
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49576cf4-ea99-497a-3309-08de96171448
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB58.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4393

On Wed, 08 Apr 2026 19:59:45 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.22 release.
> There are 277 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.22-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.18:
    11 builds:	11 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.18.22-rc1-gef4577f805c0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra234-p3737-0000+p3701-0000,
                tegra234-p3768-0000+p3767-0005, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
