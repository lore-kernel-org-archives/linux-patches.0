Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010050.outbound.protection.outlook.com [52.101.85.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DD73321A1
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 09:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775035174; cv=fail; b=MZ2HZvoz3ZAVvytyyRSnEg30biREcPX/y4GFvpG5QZX9S+k9c+5c2KCgRfZsSLkPr6wdvlediuh1V9WduFTLsrFCaH79TTKlQJnRvY/0wJ8GuFg4fdqMHwx5RxiiUiCkfALa3YdfSB1/AAmptEvXzhbUMpaTr+trVlAwlmaFTZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775035174; c=relaxed/simple;
	bh=FeI+LMQGUSMnJ5/vKZ4Olgt4WTtsjdyY4l2hhS0FxP4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=uZbkqB6ta/GcOPqljKys0LvJAZ3a/Iz5NM9NMcgPi+mz7psZUUpnlqY9drylaqVcBIypYNCQJ7BrhkCJx3vafQYFfGhewIZgkFB5ARB6dw/znoYFgzboEjl5gGRNi5tDxxdpYBGfX2lj7FfbhmHnpS5uf/HevUmEB+owBwmUofI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IlOX9c3E; arc=fail smtp.client-ip=52.101.85.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IlOX9c3E"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sek0ru0r9E9ssBxXeYcuTfYB6a2sjxf1OzfmBLaMljQ8qC3s+/5gExPMz5Zeytr/H1FsnpzJ6JUtWrEeZT6kaOf4ixgAZOU31W6iZpgKTYJX0g5D+a0HchcK+44c36X/+mSOlTTCc9oXc3r8kchCwrfWU7OYEYtp/vyhqWTEnQKuDdagx12ZzOcHsYahyWm5wel02kLioFlxtIVwlnEaWehtMwsBgWRLq0uMnGWMSlqqiZBsjv/qKx4ieHktJ1D+CvekjdiKc2s+X6C9BxiB8EhITL9KrrvhoA59RKcDx9kNnfG4OutxSQ+MlFK33zar38frZqYRMOkI5OFCd41Dcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=htoMCTk7r/g0WJSWbUF4ZRrqClBwAH9qqCvncc0VHrA=;
 b=sZc4qFLjgZHg9yqGz5qnLpsVmSMeL26IbQESRt4ecEAd4KN/BedkxnDI4GIrCLHF1t+Ptui7jaQ75FbCuq15JQG9IC2CCkTINoPngw9erIpsVCNzwGFdZGPKByoXjFxbaWOMr8THRHtmjxIdkpG1L5pJujuZ1YAbl7pJMeuC3+NiDQH2uxoUgB/oRYSQ+Us4CevPTs18rTwbPwe5HZwgZKgRWPKqa/w7oDap98ylrdA8NB4Nz69jthErjyQjiPemPem6y3HDu6oZfkhqb/eZgzmn3rTH+DWdff+nBqifxC4bOUQjy0wkdkDST1fyfaM0wfwlPp0u/JeqtbwoDkNPhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=htoMCTk7r/g0WJSWbUF4ZRrqClBwAH9qqCvncc0VHrA=;
 b=IlOX9c3Ew0Ld/WgBlJ1mFoiEIOgLP+mqsaimeLqR3kJTRDCOCv3o0Z9Txs2zPSw0rTWO/S4WUt/USti1ec2SJOPl7bUa06EIwIL/s8Y2Usiyykg1pf/7oLM3v93NQG6F87YocFKueRGjeGIciRvnXnMfT613WnPgrJORccUsxlxp1p74FOxmy8JMd6xE6XcQ4B1qSsRh1cs4toG1rp+YZB3fjDsvLROAlkHYF3YsQpg/i6LZ6OlNSIh/+GX8zaeXDrg2vgCRHtZedyaZLf6ju0jStD6lmeRaK+iGkuCQFqfEGxY3N76w/4osODrVFGdJrDDBnSlTfMoKfzJZmHXtWg==
Received: from BL0PR02CA0076.namprd02.prod.outlook.com (2603:10b6:208:51::17)
 by DS2PR12MB9750.namprd12.prod.outlook.com (2603:10b6:8:2b0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Wed, 1 Apr
 2026 09:19:26 +0000
Received: from BL02EPF0001A108.namprd05.prod.outlook.com
 (2603:10b6:208:51:cafe::6f) by BL0PR02CA0076.outlook.office365.com
 (2603:10b6:208:51::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.30 via Frontend Transport; Wed,
 1 Apr 2026 09:19:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF0001A108.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Wed, 1 Apr 2026 09:19:26 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 1 Apr
 2026 02:19:16 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 1 Apr 2026 02:19:16 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 1 Apr 2026 02:19:16 -0700
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
Subject: Re: [PATCH 6.19 000/342] 6.19.11-rc1 review
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <aa4dcd03-8c65-47c0-9c0d-9fc3d3b69a1b@drhqmail202.nvidia.com>
Date: Wed, 1 Apr 2026 02:19:16 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A108:EE_|DS2PR12MB9750:EE_
X-MS-Office365-Filtering-Correlation-Id: 33a72708-3b95-4628-9ef3-08de8fcfc557
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|7416014|376014|82310400026|13003099007|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	evpAY4fgMotUgxm6N0ZM+Zl83FmnGq9Xt0rP+qE0+oKkEpHCbNbzs8rwAae9PHFPc0MHYP19ebgQ2gItUoq63Qmzn2Gyrh7eI7HD0eczo8q5+5f1tZhyhTR7m6C0L/D+d60eKLSVY7+CZp3DuBVrYVOSnbwYyOimcbHcVgLcr1hFl4JDN9bLmQJf2d9GicdVWpqXEK15RorjPEJku8IHrI8brIX6PjBS3mSWShM6LTEvEQlBQ8F0t4/j2nqNYIzlTpbfpoVRCZ3dHxSMqKRgreRW8sLiSiR3jeh1816wEjkocebjTTHbVet+ewqaDOnKUdT8m25SKeCx8QJIUhXLRnOve8f6BFDOr+XchOlPWWgd4GQNjmzmBKHgoRmtTmvfALYvH3fFI9wsWb3TW6jeV7iEybA1mAMnyyPoPW92MT0xwu9+WuEGCLDFb8EdpmR/31Cwz9hPWYYidw/GuAnDu9POa4s+uOsezdC30AiA8I88RWpelq39wmQM8hKg2Z1wycGllCh1rrk4D4Qcu00ypMFFA9ONVYwYlhZvw5Lrksw2O8aZdxSvFgDHi/lJTlMfiSzWUgmzhx7GYWVRpUZGTK90/Es5phQG/IGPksY/U+b3xN2bpyljIdkojuUqDGazgri8J0zAh6TMRqYYDirVsDQZK2cAA/l3uLGAl+LOyEaSG+wJ06Fxay7Vpw5yb8wRHe4h0u+pWDPbu5WGGfA3YAZjieVQyHBbYKQL4wD0S6tYr7aTtI92UorQCfSMO4oxhbTe6z4zCfZZv1eEZQijSg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(7416014)(376014)(82310400026)(13003099007)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fPgD+LcgbgT0cDjW9LkdTLzn2nzZUY673vRm/ppNjHGSe7A8wSxvIXClCUSBaT9baQy59RAyapsqEYmJL0Ml8896JmJIAqkOqMkv1VZp5jmQp2r4AFLn+zQppa3eqs5y327EDunm8lUFfFYACUk6r28bq3u9Rw3zqaBL2HAmNS0Gvo5RoW/avMD04tuvIYFk1T6CLDK8wawL7izl4m7GAT6gdibI5SzMURAiITqW3dJZfVhFaYYQ+DKVa4Mk7kEmbudXLnErZghYxb9Jx+cHusu1Xb498YnUguomfin1q5ymYC/uDu3yh0+5/Li42wLPaHDBkOeB77dN6jnXeP8nLF4WI4jKY/d8959LwQKhxt3KFOrOi8Mqo9MCYZ37BlBKH9TRdQxQN939ia7p66JPMq1UF2JPaOx7/2Ckr241eueD0t/UaVxsPwGWenRN66SN
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 09:19:26.3050
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 33a72708-3b95-4628-9ef3-08de8fcfc557
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A108.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9750

On Tue, 31 Mar 2026 18:17:13 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.11 release.
> There are 342 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.19:
    11 builds:	11 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.19.11-rc1-g411f8a553ae8
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra234-p3737-0000+p3701-0000,
                tegra234-p3768-0000+p3767-0005, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
