Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011001.outbound.protection.outlook.com [52.101.52.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E016437F745
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 09:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775035161; cv=fail; b=Rm7sjLr5OJOWoDtbS40+rkuDaZfLoR/Ncgq40FE8WmW+9obDy1FNTxT4pN7sVuQzdeldbH/GSuyACasPTK9+kpCPWjTj3czfrffRwEgTGdZWpJjbgc9xL2rhFqz4TH+BdJ+LSAOs3HKdjcN7WIMjAhcV0W3jAONHMimxPD34WQE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775035161; c=relaxed/simple;
	bh=vA07gF8B1HcY1OhPWBb4bqBVv52tqKAxtNBwgO2sdow=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=gaaMRZI+TdTIgeudkwRYFW4xdMoQ244MSLYqN4VF1WQfT0NmfQMAxhv/786bB4fjX1FptzI5h6WFvhCHn7KURlnYbloArk49RDP5WH1gJOcvpi1HOLjK4puxuIT7AYVjiMlBGGYt8Q5pk6BSHdEqQJSordxXx2FFQhCTGp0d9ps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=adBN09Ez; arc=fail smtp.client-ip=52.101.52.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="adBN09Ez"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JCH5emkjRFNOm5zA7gAuQn9hfw2q3sDWpSkw6B54gCA8+H8UgZpZC9mLPY+ch59PGK+4Bb7aDGXRRx3qk4YApP8pTvV0KiXPyfH3kd6nCbKSXVZEDFxEXRtiOpy8FFaNneP7uh+XQkM51mkWL5SRtLVhkkbimaV7nGlKFVw+JRCy82kQDJQEFZltmfStIaRyuAI2cIeckc2+j9OekFV/3ip+vRkzzNCZDgppUuiV7Ef7pd5+5elF+7ZAts8M5AhLbmTB/37hVLXcbyv26e4dW+0V4D7XRaX5qSIdf9ZTan78RFCTT0lfrv5FS/dLvt6ZLf9NT19X3UM/cKf/YbJudA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nfZaA6ueAub6Oz9F9jAV8Rm/JYh/5gwh7ypp4KYqoLo=;
 b=xOIds/ICw+C2k9ml+YcAevA0hEgSHPXGqPoexr+fJINXup5XzVeJCj2sm1bNE2EtHFoJhJjH4QZgAEN8cr6by3XgD+xaWP/D6C1RiBNRuk4XQm2hJ4bKhUvRuRvSKGC7RyDBSLsNt32PEeRKnz7CF5ExXbYf4UUxBOSXKjIq89aXnAM4Z90aKG2mSIjo7XrCjlUyha/LAMdC7x/ZhNn96J60pzR9IWzL23leWcB+2h6hpTej+/4IOFam1nMyG4ypaZGggQubJeRE84VV1664lu2m9cVuFNjnGGqhqbguqXbJSp6YS/qyLZ16wcEo2RV1lXEauoTsmBc3kkOMOOj2TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nfZaA6ueAub6Oz9F9jAV8Rm/JYh/5gwh7ypp4KYqoLo=;
 b=adBN09Ezjwic+MQQYnqNYkqlk7qNoGh19fwbmh+y7NWAs/WrcVPbyE0s7AkmpEP6yGahNQE1mAI0TrVJ0ZjQID2SZOpNAWTHtwt2/Ya/B4wV2xQXxlg8LqcAA8EY4o5cRCeLAIFmF1IrM1po0WqM/0JrFaVZXyZieAXGb9N2Dwp9t+c4s85xtkCw3iLUnrYNR74BhPdiKhizl/rBbT+P3KY8x25k8trMpVOZf9kvENDSVy/z/L/VNBq/tvVyDq2GXQ6vaGiL9BY0QauRhFuHDbvRmRhJnzYMkjamAfWZ73r/oF15fdcO4BJhvXKb+tN+/LsvybdwJhIFAlm/0EC/xA==
Received: from MN2PR19CA0066.namprd19.prod.outlook.com (2603:10b6:208:19b::43)
 by CH2PR12MB4200.namprd12.prod.outlook.com (2603:10b6:610:ac::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.16; Wed, 1 Apr
 2026 09:19:13 +0000
Received: from BL02EPF0001A102.namprd05.prod.outlook.com
 (2603:10b6:208:19b:cafe::6a) by MN2PR19CA0066.outlook.office365.com
 (2603:10b6:208:19b::43) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.30 via Frontend Transport; Wed,
 1 Apr 2026 09:19:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL02EPF0001A102.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Wed, 1 Apr 2026 09:19:13 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 1 Apr
 2026 02:19:05 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 1 Apr 2026 02:19:04 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 1 Apr 2026 02:19:04 -0700
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
Subject: Re: [PATCH 6.6 000/175] 6.6.131-rc1 review
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <7ffacdc0-c40b-4e11-951d-0faacc968a82@drhqmail201.nvidia.com>
Date: Wed, 1 Apr 2026 02:19:04 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A102:EE_|CH2PR12MB4200:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f5754e1-c3bc-4f07-7041-08de8fcfbd8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700016|376014|82310400026|1800799024|22082099003|56012099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	6Q3u2mqVWegssgqcarsxAvsDnZCHAUqLsHvqfPGJN3vOR/DZpY2L8MxaocXKQwh967aPV4wHywhDgC4z6cR042tHQ6dm7kZNet/UqdF8ORzOJUSIvtrqehTd/RUMiRcunQHSmRdElPnfT3VZtYqzIIMnex+TcJyx74BrqX8qgwT2N5JVi7AiaT660MNXLflyCoJBY/EnTDxTEkZ1S+rTyQqdqLqeKrI8OFOEGgT4n/fH1fStB/vqx+qPM/3cLwUfndt0/jBF431AdrRIErpJL017syv46uR1zLOFNBm387t6DSa4cR7T0zlFMXuRt0eX1PGHC2K6bvsAvdVZzsrfLgXqgzaT9QYxNP7jDqWuwyluRsjkhHwUOW8kfHnh7TAuOS21bNfLIR9J97NHKNMS+bsyx5Y20DizRfJ8QixBU6fVRHjUws78B7+OTz5zYYT32spB8JrifG3sjVGnELTJFABdcPFstWvhoJdrKGzFmZpwvfziVLcharmNPtlj2ADQNTyJfghj9p4+zNq5UA2TsrWC5JoKvzLH1zCIUQxATzHZO3aIk5FCgjshLvLTSK3I8cgFNyyrHnsDtJCTEAplaCLsLQngqgDBxhiuqlhUufEkcA+zJ8RH94YZ1DbEu8alqcmRAHT/FLHSuDOsKYKiBWWwexYuaJhHZXHrIdObvP7lQHjO0z6i4lmsqt+dInXT/ny5QdOmcypfMaoxlkY+UONV5eb/DBakg+z1eZUII4RfB05BQeUh9GptrwIL77aezsXKzk6OidJaFrWAJZ6IQw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(36860700016)(376014)(82310400026)(1800799024)(22082099003)(56012099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QMY+Vi/Ii3Ber/dc7jCA8TqRTB4OlhUt/RfE2S6+EMvaVDQcKjB36MGTzrTo7r/Oqkzp9P2gl++yN/2In6Q9WWXWlWWCPrCfyLTdfGLGbDKABWnPEakJL9K/Zv9+iattX+q6pWykdA2j6hdON4udbdX+APPGAtoWfCUqDFDDxVevxHWugRkzMoyWgZzH96AhbqKzi5hZGghCzBfu9DV5OzOUiFJ+WtTtGauQF0xhouC8CN6t389eqQl8LsCs7zDb4ChjEXrYt/VX0S7zbRMyi5q9TgVjPCwwRSCRTLKP6thFN/cQ9ps7Y8L9E2QOqq7G/TKpYcifvQVqvCdEHe4sDdEy9gHwSTk7t30Va/Ps+/djnB3dZ+qr4E2clOyl1BBUJ9GgK0C65J1XCfETx/0BzuPPDvsC3kChWw+HmGlmKFa+8kJPw8HLj7dFOoq7YXfy
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 09:19:13.2423
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f5754e1-c3bc-4f07-7041-08de8fcfbd8c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A102.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4200

On Tue, 31 Mar 2026 18:19:44 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.131 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.131-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.6:
    11 builds:	11 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.6.131-rc1-g616fc3cb7c95
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra234-p3737-0000+p3701-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
