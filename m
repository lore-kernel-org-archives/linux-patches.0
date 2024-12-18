Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE771FA243
	for <patches@lists.linux.dev>; Wed, 18 Dec 2024 17:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734542467; cv=fail; b=peTUWCVgdsySnlJ0V0F0KxLUB7mhnVZ4IZQQo88mPmBSh9zTnndmiuhQlhwB4WthYEHC5rY+qQZ2fxuTXRcxpxZEJoSdxwXlomW49YnzEFP49d8RHojod/6dzsDoFgDgBbmb+HlDi8uSslXwlg8M6iqwmNOb1SdC79+S+xEItCM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734542467; c=relaxed/simple;
	bh=VXy67laCqg/xYML2PQOcBDL+/McmzcdYh6JhBEFGrHo=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=qAThSIheE3CWNzNlxkppcJ/jAHYxlUb872cEvCO+SlZKURoyBuwTt43ZOhZsuwTveB7w6ojnO+Y7k72sp1HqpuEIqF5hHL4697VzRJOlKa0WYW+VCJLrxIuLf4qHEfvsdK0T5DPjNhAyQFlA+VnGjq52z3D7T7gAM7d0u+d0PWs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=onAWxK1q; arc=fail smtp.client-ip=40.107.220.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="onAWxK1q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pREGaPCK3zujsTfvtiLoITj4e/JHYHn8UQo3aONc37Xi52zYOqQfbKkDmbknR2B/JUfrEyzeFXY7Udhrs4jsDuKQWPs5uJYyzud6Q8R8EtKEcSW1bgre+pM+DYQ8I2TEYsNAC9W5o8c0Ve5syxKIlm6Ah20f5HrsKDOr4xuG9Bg3cR6krmKgY3hN06WvMbpqGWjbOMkVwNaQKQ4V7fE/TkHLxDfCgieXuCvz9U3n1PWogdTWIrJopR5PBsXGESL6GwiGQ+F6pquNlHmDcLmrn4xECd2WYJttHL1RIUPTPsPze/9UWpeMGDXAV8ZlWfDV8oIXo7DFhUtXM8Gf16eWrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+UDKPkaMOzVzhVN+MgRaeqrTUrhpaRUShynUWGm6+Vc=;
 b=AQk5k9vEyqR/ChomSwJmY9wF4LMS3OfAbkgHPvoJC3mZkZDoN4gELETC3ZvqjyF6Z8l2QwlFX/N39FyNxxmS1xyG3uZvvP/5+xH713H5OOvnoLhksnj2m0D9I3QZ0M0R8ljhlkqExckoe+tcMMFC84LZN+ETMESKQJo/OzEztVUlWV4hr/PtxuucJx04Ro+7aJ9+JOAh4N9oqO7zdHjBRlD/HFBiRxcSK+ZHsv1OX0ir5wj26SRwcN7SZTS5onUGgiyN4e15fWfXFlAupmmnjUM6NSaEsDzgJFL23gc1MQYUljQRjLCTxDIrbYUMv3jqd3oMLGkmRYX2R7no5Cxz8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+UDKPkaMOzVzhVN+MgRaeqrTUrhpaRUShynUWGm6+Vc=;
 b=onAWxK1qnEB5ZT2c6sQGpT39ZWrcQrsUtx3QCp1/7mp/BX1W4b0Yx61tezY1cUn+7BqSMBolzSjMIbiNl7TQOkyQcHbRneiCvgGof/MZd1L7owhtP2Fcjsl1maCY1CHeYxgVgezAjaVjrYU+FmbSHd/H35CVcT0m0MQJSTbkz3LU6Ce3JDLOcN1mDmM+LoEHRhE24ubTjIvgvr4oeY7wRjeX71WwuLf2dTU9Z+uIZHDrk/7PyI3YvZVUZNP7uU5gL7AK34QaIsVAL7sdqX+m3N/yPKy+LbVFOheus7vyfTYxM7k9428gRI/C/FXc0zC31tq4ceWpMjfk9RIVfQjtSw==
Received: from MN2PR05CA0046.namprd05.prod.outlook.com (2603:10b6:208:236::15)
 by CH3PR12MB8994.namprd12.prod.outlook.com (2603:10b6:610:171::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Wed, 18 Dec
 2024 17:21:02 +0000
Received: from BN3PEPF0000B370.namprd21.prod.outlook.com
 (2603:10b6:208:236:cafe::4d) by MN2PR05CA0046.outlook.office365.com
 (2603:10b6:208:236::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8272.9 via Frontend Transport; Wed,
 18 Dec 2024 17:21:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF0000B370.mail.protection.outlook.com (10.167.243.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8293.6 via Frontend Transport; Wed, 18 Dec 2024 17:21:02 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 18 Dec
 2024 09:20:42 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 18 Dec
 2024 09:20:42 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 18 Dec 2024 09:20:42 -0800
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
Subject: Re: [PATCH 5.10 00/43] 5.10.232-rc1 review
In-Reply-To: <20241217170520.459491270@linuxfoundation.org>
References: <20241217170520.459491270@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <189e696d-b044-43ab-8041-80ba5ff640fe@rnnvmail203.nvidia.com>
Date: Wed, 18 Dec 2024 09:20:42 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B370:EE_|CH3PR12MB8994:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f9b97da-c187-4621-3c05-08dd1f885902
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Nm9hTE4zMlNMZUllUDdRSHkzVlh1SmJQQTA1Q0JsNmtWbzJ3dFkwOU9QaTkr?=
 =?utf-8?B?Z2lJYmRjQWpIODNjSDY4bHF1L3lpMTRSWmlXU25PNjN2OXhGZUZsSUVPWWts?=
 =?utf-8?B?OG80NEFnVll5VjJZeStRZXdyUWd6OEMvUUVESXJzRXd3YnBVTTV1LzU5eFda?=
 =?utf-8?B?d2E1OEdLeDVrTU1JdEtmQlc3VmdRL0l0djBmZHM0UDNrMmJZdUQyMUxhR3p6?=
 =?utf-8?B?djc4L005YWVldXN6eHFjUXgycVhKNUpKKzdXWVJsUzVWNlBFdmlIQTZZMjB6?=
 =?utf-8?B?Yi8vTzZyWEVOUjR1eUdrUDh0a3ZVaEJ3TlhEUklLREtVb3RBQWgyN0s1S2li?=
 =?utf-8?B?Vm5ubDc3bnRob2h6bllyUEsxdXV1MWRWUHc3S2NudnNMTk90QzRPbVBmSVJH?=
 =?utf-8?B?Ukh2blJMbHpXRFdRdi9CWGZtdDgvdkl4Nmp4blBBa1FwalQ4cGJVMXE3eU5I?=
 =?utf-8?B?VjBwaElXYVdhY01pQkNHa09FdmF3RE1XR1I0NFVOSGQ0aTVESmhsV3pKTWtY?=
 =?utf-8?B?YndMWTMvdGNWV0dOMVJlRUcrT21DcTJHdENBQURVREtWM0VPQm1rR3RaR1ov?=
 =?utf-8?B?OU1RK1VPdmYyNVdUaXV5UW1KVnQrUnI5bHA4MWlSN1FzbHp1MWYvNmtKa2tN?=
 =?utf-8?B?UXZGNXVCeitsVDdmNWdzTHVhS0Ewa3RXM1E2WXhEUEdKSGRMemE5YmVocXc0?=
 =?utf-8?B?dnVBaVBWbStrVkxteGd5YWxWaW1IR2ZaM25LbXR4TjFTQVlPZ2l6dWptcmQ0?=
 =?utf-8?B?NUIyMTVLbkpxOHNVTmhWT1dPQVduRXoxRUFqSXBXRWFnanFMZmJLUEZIQXNV?=
 =?utf-8?B?OUFXRDh1ajNocGJldWx1dDlvcnU4TmMrVWMwTzJDK2Q0U2ZUc0hzRnhqQmsv?=
 =?utf-8?B?ZzlBM0tiTWFkVkNCSEZlb0NHd28wY0xGb2YyRnJzYmdsK3RDcVRLdG1sV3pI?=
 =?utf-8?B?OXdsblNjYkpJV1hZNmJIaWdwaGNCaG55UWYvZHV5RG11b3dnWXI2WURpZTQx?=
 =?utf-8?B?RXBQN1g1RWJ2RUIydlZzeFF0bDhrUHc5dmpiUWtid0huQmlJZXhXWVk0TmNO?=
 =?utf-8?B?S3p6MEtzdjlna1FwbEZFRzBJTDFSL1FpZFF6MXcxRXVIVjJuY1BXRjY5bDUw?=
 =?utf-8?B?OFg4U0xZajZjVVJBYzY4cmtDamRGaEcydDY5a0Zlc3VEVExodm5NMVVHU2p1?=
 =?utf-8?B?MUY2VnhTMThDRXF1WnNHbTdGUmpJWFB6d1hoYVdIYzQzM2JuRnZyNE1aU1hU?=
 =?utf-8?B?R3R5MzdHbEUzaTJiK3F2amJ5MFo4NGpPMFlOWTQweGJpMmFMM2pQMkFxZXpC?=
 =?utf-8?B?YW5GbDZzZ1lEREx6dU04a0RkS3poWFc1bWhzYXpCZzVCejhhRVo3eXFLM1ly?=
 =?utf-8?B?bGh6aFBoTUJHMXh3RnU5b1J2MFBNUmJvZnZLQkFzVGFxdEdCQ0srenlNWmtJ?=
 =?utf-8?B?aVh2QjFTSnl1eWNQeThTSmNlUXNFeVMxR0pUSWNWMys2bzBaUUppSkFJZmpn?=
 =?utf-8?B?c041aGRYd2JNRHhpanBJd3ZmMVo4ck5nL0tvQk1oajB0dVRESXEwdGUyM1dW?=
 =?utf-8?B?U2R3K2Flb2F4UDZVeW1JcEszT2J5VUZ6RFQzZVdtSWp0ajI1L0ZpZE81ZXJu?=
 =?utf-8?B?NldPQmpGZzFiNXRUNkVEUmlBZ0NMaWY2L0VGZzY2ZW1oYWxJKy9NZWtUNVMw?=
 =?utf-8?B?NXhYbGxBbGVPRXU5QjJFVTBBTE0zWkNxaU02VXFLRmtxbjBjYVVGZ2I4cTQ0?=
 =?utf-8?B?NjZwcWNhdWEyOW5RaElvMEEyZ054L3Q2b1plSDZNYWpRVi94VzlTQTlNcm5T?=
 =?utf-8?B?b0JPdkxTRG1JUURMNmY2dDUraGVBVERUckg3NTR2VVFicjZUL21nUktOZWZF?=
 =?utf-8?B?NlVLTnhQN2tHQmNIZEU3aGZkcUFWcjNJZTZHbmxrSklZZTJndzdWejI0ajBD?=
 =?utf-8?B?Y3AvbHJWK2xYWmxlVElSZmdxaWlRMGdjZFlaRExuT1lWL3VxTCtXVkNIV21U?=
 =?utf-8?Q?L5Vd3e7geyyAqn1PA2tu7/2ubSQep0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 17:21:02.3780
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f9b97da-c187-4621-3c05-08dd1f885902
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8994

On Tue, 17 Dec 2024 18:06:51 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.232 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.232-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    67 tests:	67 pass, 0 fail

Linux version:	5.10.232-rc1-g238644b47ee3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
