Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2088.outbound.protection.outlook.com [40.107.101.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA87B1DED7D
	for <patches@lists.linux.dev>; Fri,  7 Feb 2025 11:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738929341; cv=fail; b=DgSqeRlMqGKkIfUAh668uVv9m5qP5FQ2e6c/uimbMR/Rz1BCGczIYX6xSOT8l4Lbp7uiMIFRBevYSvkMfL89ONexiS8HhDxQjc6MTytbS9SA+FJfRgUeQ2OTyzvH+PerXGt6DR5zCVBJWiQFv2jl/LJX/yOzy7btmLRGXkyhIzU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738929341; c=relaxed/simple;
	bh=9HgSoci9xwswRZsresL8NSO9/XT11sxiTbhlq+fdzzg=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=RDUMqdmDG17KRH7OmtN9zPIGfankLpF0tzd22wYIEkP/PCp2gfcmZkDPR865RY70RUlT+UPiDapjKzZnH0ZYz4isoLPtCw0VqT7qltlUNgphOwDsYM+Sddb20mFZ9OW2GrHqpt9c2w+iyIi3mlCygYTjGKiC8m8JFN+tGmyNt/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GP3+cy/1; arc=fail smtp.client-ip=40.107.101.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GP3+cy/1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SvD3ccSpEAGLVM0zQtO11JCWOC42O5/atWHpk5/c9JgrUtOOMfJ4MgK2OrGMIMNnqpTGDsSzC3n/stJ2Wcq6NGQ01jScaYIygCVPwGFhgHKCYGlw5xYZ1PkEFDWddXiV5T3br+eb41zlRI/cAdkfGiYuBTGtH6GejkjjyKZMic+m2szrsXTwOpHFiHGGBWslS+ajstGyOhGWq/Jk0TDiPbBV3sRQfa3evfhHBbbxWs2VOJK3U2g33xUaJjq0PcLR8wMSpxxXjNXlyXolkXY65LMwoa0Uno0JgPK3vDAb6Rd2lDatLlgsoXvxZvJqIm8jZjUTmt/MM1g3l/00O0sD1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2mfbK6/5qoMyR1mn25Z8seN4ScznjRKdwdclaW5rsa4=;
 b=bGq/3nJaIct03zgLPNxN+zJZQPW21qoMxQPNJ7Ru5GlRCvw3OamAP3P+L+JBYwAgAxK7XyUfPiYl7wQ8AbRv3L42OvadNgmX8pmoXV4LAhVfJni8FjAWNQvNlrdCpOXRGKibfTSgRnHnGyWsAXrrnETgyUHpczsjvR6ku/aFCJJ67tWZnA8bTSKtC9FEGboXhSk/a4jgVfcli0qGYuD2iiBxcYKAhHLlDYvP9/uAFCcs9+/xMLlz9YO1PbIkAtvzdojwf9YLHVKWkXEcX90LSkevYZoIgnl0D1UTaS691V2PGGhLdYD6RN7MBFeIG+LgpHiuJiTTlHl/zLucprIFjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2mfbK6/5qoMyR1mn25Z8seN4ScznjRKdwdclaW5rsa4=;
 b=GP3+cy/11/xjyDd0UWj/4n6ngNUItXeanF4q9LQJPrKWZdTOTq3AI9IpoNicXpjyMdryPfV9mCN0Q/S54hg+S13ox+GbzuHmT3mKp66Z0kYkqkmibHxY5thkJT0RL+4ZlA4FwIMHNAtKUHhLjGXg5ABnrUDted0fN93zr44U7j21SRE3QiMiOWbQebKG1l4DV7qblQ2hYIfUB/qwWqYsIFIHDYXrQB47du9INdr4AK1sIPudJURvw+UfwlZgMJirmGb7W5ikLchwWbLBTtKcTi8S5BNO68ieYWcJY/d51gYmK5Ku2BWfh2q9IwGtTNd8Uo9Lf2YJSLGQdmAXkzOkKg==
Received: from BN8PR16CA0001.namprd16.prod.outlook.com (2603:10b6:408:4c::14)
 by DM6PR12MB4235.namprd12.prod.outlook.com (2603:10b6:5:220::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.12; Fri, 7 Feb
 2025 11:55:33 +0000
Received: from BN2PEPF000044AA.namprd04.prod.outlook.com
 (2603:10b6:408:4c:cafe::d1) by BN8PR16CA0001.outlook.office365.com
 (2603:10b6:408:4c::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.30 via Frontend Transport; Fri,
 7 Feb 2025 11:55:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF000044AA.mail.protection.outlook.com (10.167.243.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8398.14 via Frontend Transport; Fri, 7 Feb 2025 11:55:32 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 7 Feb 2025
 03:55:08 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 7 Feb
 2025 03:55:08 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 7 Feb 2025 03:55:08 -0800
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
Subject: Re: [PATCH 6.6 000/389] 6.6.76-rc2 review
In-Reply-To: <20250206155234.095034647@linuxfoundation.org>
References: <20250206155234.095034647@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <7275e41e-7afe-4d39-9e90-eae81b0eb77a@rnnvmail204.nvidia.com>
Date: Fri, 7 Feb 2025 03:55:08 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AA:EE_|DM6PR12MB4235:EE_
X-MS-Office365-Filtering-Correlation-Id: e6e7e417-217d-404d-0764-08dd476e53a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RG1nNTN4S1FrYnZwQ1J4dU9PNjI0TWVwREVvcGtwcU1yMHp5MGZBOThINVh4?=
 =?utf-8?B?MFVGTy9GODBBa1hOclNDaDVSejJWbnFVRUxMNTZRSW5GajhaSWZRdFJGRVNF?=
 =?utf-8?B?eDB5WWpNL1BJQzMzMy96ZndDZGtqM2w3RVFoZWwvWS9zNmw2dC9QS0cvQmZX?=
 =?utf-8?B?SWZJck5QaDRsdjZrNzFoTnMvTE10dHhFQVh6UDY3bjFkbXJSd2xGSEtpdDc1?=
 =?utf-8?B?VEEwbVEybjZjMWlCLzNKVkdJTW4vNjVtTmhJZGwzenVsbjlxN3IyUzhnNE1O?=
 =?utf-8?B?TlNFV0orclIrWEUyN3VDR3Y2TWdFN3lqY3J6V2o5cWFZREdtNVJ4L3dmVTlh?=
 =?utf-8?B?dFJzanhuUWE2cmI2OFpyRWM0bTNMSDNtYzg2YTBpYmROL0pEcC9YUEMzbVRv?=
 =?utf-8?B?enFsQ21zWGlvb2xSWXRkWE1md3NwVmQxYzN4YjgySWJTR01oSTIzQ3FjeHNw?=
 =?utf-8?B?VVFkTE9SZWV6YkRaL3d0YkpOVWlXeW41RUdtM293SG1sOUJ4bERzYTRkUmtm?=
 =?utf-8?B?SFY2TUNFSmZnajArNXY4UlN6OXJFc1A1NGduMnF5T3QrSWJGT3lBWEFtRzE5?=
 =?utf-8?B?UFZETXdKeU9QdTROZ2JseG5CM1BoRk9vQnFleXB2WnVoNjQySlcwR2hyeU13?=
 =?utf-8?B?RmthaEQzMktIUTBxdTNoOUVSOG1hZ3c1VjRlTkI5R3RtdjNDZm9MWG1EUU1v?=
 =?utf-8?B?WEl2bEQrS3d5QnZYZEQxM1plKzhiTVRIbFVrUlovQk9vaTdhWmtJK2VIZHpJ?=
 =?utf-8?B?NDNNdXZvQzZwdzBjRU5yUkcvWnVZa0IrWHFoNk5EZWltWUVrVS9mSElzOXdy?=
 =?utf-8?B?QWFPUGp3ckZUMEM1cjRkQTdzcko1Mm42T1laTTZNVmgzVGN2ZUliRFFmbVRn?=
 =?utf-8?B?cTBQUUh2RG9OWmdzZ1drTTZ5WXo2ODlremM5OHRpeVlhQndaY3d6L21WcFN2?=
 =?utf-8?B?Z0RtS1lBTU1uM1IwSDdvelAxVEk2Uml5OXltdlNucW9hQ0dNMmdITjNGSXM0?=
 =?utf-8?B?NW9DS2dya3RNVVlWaVVNV003NGUzVzZGS2FUbTZYUWRYalNhdzRFVVlYRGFE?=
 =?utf-8?B?RS9sL211cWQ5QVJGOUZ5anlvT2thQzNYd2llTDJpbUlVV1I4U3lSSEdjamVz?=
 =?utf-8?B?b1FvTmw3dVpKT0YxNk1ka25oUVQ2QTdoZ1pNa3hITThCWlQ0S2d1S1JlVjV5?=
 =?utf-8?B?SU15NHVheEN0cXYyTWFVRlJFNGlhZ3N4UVFXdFhPdmpZQ1YybkRrVThUcEpx?=
 =?utf-8?B?VWtXNlU5Slp5VVh6ZnEyZlBsdnJvc2x5S2Z0ZTFlVkpOMy9hdEhHUnBENHYv?=
 =?utf-8?B?YUxSM0RTbE1YS3JHVTRyYWdTZTlvSFE0WEZGdzJuaS9wZ3YySkxTeitNbzhz?=
 =?utf-8?B?c0wxOHlsUm9La1RCMXBBbHhlTjM3U2hrU3QrbUZUa2NwbFBRVHJLVE5zcjAv?=
 =?utf-8?B?R005NnRsSnN3TWQrcFZrbUhuMEZVbzl4bmwxRndOR0Vya3M4Y2t6ejFsQnUw?=
 =?utf-8?B?cmw4ZGJqVUdYcHBIakJzaUUySVVxWEduQllBd1RsZFY4NHB0SmVPY0Y0Yjkz?=
 =?utf-8?B?TXFXQjRZY1QrSnhmSG5MRTc2aGxVQWhMODJ6b0FxS1hGdzhocHI0ODVsbHVJ?=
 =?utf-8?B?OVdWVTFvR3U0NktkY0R6Z0NiS21qQXRKZmEzajQ3RXMzQmdsTnJaTSs4RDg5?=
 =?utf-8?B?VUxZRFZGTHFaenpKWjhWZWlwdXNFdTgyQUNpT0R1WmtucDMxR0gyTXJrbGZ5?=
 =?utf-8?B?WG1KOVF6QkwvV0t0YXhGWTdndk9pVXF3QzFSa09PMFVjanRXZzNnVHJENmVz?=
 =?utf-8?B?Z3JYZCtmaHFSMkVmd1BSTUZYZG9NeEpLcHhrQ3lNcm9JTk9ja2ZUSk5odFRG?=
 =?utf-8?B?eVRwOG4rQVE0blQ3NVAyb0VOUk9XcFJkc05aWVp5TDJIYStKV0thQ3MrMDB5?=
 =?utf-8?B?QVlMRXUxZ1MyczlwUVZ1SVRPdjZ3aFRLakNVZkp3b3pnZVZnNE5ZeFhST3FD?=
 =?utf-8?Q?EtEcKHwnl+aIsNMJ1McQ+jlaXoQvNQ=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2025 11:55:32.9615
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6e7e417-217d-404d-0764-08dd476e53a3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4235

On Thu, 06 Feb 2025 17:06:18 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.76 release.
> There are 389 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Feb 2025 15:51:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.76-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	114 pass, 2 fail

Linux version:	6.6.76-rc2-ge5534ef3ba23
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py
                tegra194-p2972-0000: pm-system-suspend.sh


Jon
