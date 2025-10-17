Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010017.outbound.protection.outlook.com [52.101.201.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A085A32E14C
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 18:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760725025; cv=fail; b=izmEpemLBqMedI4DwtED/DLVxmYa8nT8q4njU8LYiSRLh70i7NI4L5IT/DQkufkp9/4RLfnqYR5c2H0d+oIK4zrVQWy7wCvEU+s9p7OLl2774D9IFIPo9VhPg6KNJgwRcT8dfMEG5Zf3pa0zAqcQEgdxocyGblR0GyI4BAFhk6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760725025; c=relaxed/simple;
	bh=YTbFa0OdyNyiHzbiZuJb/M/N9IfpjStcEpTh/6xAMMo=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=LOHca0N3/poek98ZhdEh74J9GVeygbR3jOdXzbqo2cVo+m5RAQKsdwI7gn4w5DK/IOlSYz0TWXoo2mrDH3lLGKl9miNMDtLYGZcwP6KC3wS2fvg4JLobpya0OPsiMNB1wwfW3athib5DUSlDe4Ax+8bhh8HPu9ZGZrBukzxIYeQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WldxmMRm; arc=fail smtp.client-ip=52.101.201.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WldxmMRm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bkJmR8sTN/xlzZA5mQ9TkmzTwNoxlXhOXWYSzmoPulZegcDIS42CKKEkZ1Anmxq1u8P6W8227X5KURZHH0gS9RIdXIOWZ6wLtz+3K0MKeqDMRzGIxMvcHKnB87qYKErl9ZOsRJ50UBRrhwovAipnZdw3BokFy9INtANom256r9/EvoTyGUuFBepLCs2SXTu6zKu82yZ7LeLbAOv0p+kVNYqcCY9jbnfX3r7owb+ueA/a28I0z/hBNF0mFz+5uRRHeJbX13z9CbvINh1QXlxDadgVml+LJBBsYOSn5zcl/pS751sRzpRPNG/6ap4SrV7YNoZlaPrV7koxhJoFdTPOZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yDDSVQZSC06Ar+EuJ7cTFr9pzy2Mth0q6H1PHo3Jhts=;
 b=l8v5o2FtVsQ4xXIG4dG/K4MiyHmN3dodOLRwOCRP+tuKiXOxOYaD1SvWErxkVodxHR6gc9IbqBWVS7KCLgJ8SflIJaffnOqTB6Bxq/bZNacluTtzI5jDy020NEXINl51+BsKa86dPWB1wBVdTcK7B3Y2ZFpvMuToex0VMfnnsesRTIPGT7RUQgrlRHVV6/Plml2ePO1cVxlLXaR9qJ0GYw6T/9aTHk9p7TTagnnEcVGLK+VU7UVkAhrewUi+xsPH/NVsWY9qyLmpIzSqSvMunzqFiEQawPtnWLX9EaqEjXnaAg58HH3k0AOCDTFIuoLsI0KJb/yHnbHqJ9I5tPUiRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yDDSVQZSC06Ar+EuJ7cTFr9pzy2Mth0q6H1PHo3Jhts=;
 b=WldxmMRmtTtgxtvaqpZjfdZ/bNsDvxHwcTK1G+O6iGKEgUsqfdYvzXGNFxtfoW1khfkGQcxyMUvSHFxfOrHBZ2aBt6wEHlGOoN/i/WU8uDiN7TRyZWnAGM3wwJHcoMYhwPPKPmNDntXqXaEUHjUvtSTmujLViKRfjftRyux8Qg4pKAtSgrE+Z5U2xifWc5o1D/bpuVBhrVCRpG9RPvAXMfhPIQrR6o8tXdE4WC7DRqG1vwXr+Fgsn6Ru+TlbPyOHsYPFGd1gri2fIRQLHd2RbqGwHFVU3pKBEhLW2fWTxwhQMvSH4qMuSCOFPkRNZY1FjfUa+bXSX5FlsDyhZJ5dnQ==
Received: from SJ0PR03CA0331.namprd03.prod.outlook.com (2603:10b6:a03:39c::6)
 by DS7PR12MB6024.namprd12.prod.outlook.com (2603:10b6:8:84::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.12; Fri, 17 Oct
 2025 18:16:57 +0000
Received: from SJ5PEPF000001CB.namprd05.prod.outlook.com
 (2603:10b6:a03:39c:cafe::e5) by SJ0PR03CA0331.outlook.office365.com
 (2603:10b6:a03:39c::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9228.13 via Frontend Transport; Fri,
 17 Oct 2025 18:16:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001CB.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Fri, 17 Oct 2025 18:16:56 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 17 Oct
 2025 11:16:47 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 17 Oct
 2025 11:16:42 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 17 Oct 2025 11:16:41 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 5.15 000/276] 5.15.195-rc1 review
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <06a46976-7ac1-4188-94a0-3fcfc7891273@rnnvmail201.nvidia.com>
Date: Fri, 17 Oct 2025 11:16:41 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CB:EE_|DS7PR12MB6024:EE_
X-MS-Office365-Filtering-Correlation-Id: e14222b8-5bdf-4ae8-d6e5-08de0da95b69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TEZjSU44ZnBIVzF5M3lEVlZYMlpNZldpU0ZkNFdDVmdUdzdtbkVjNlNjMnUw?=
 =?utf-8?B?MWc1NXJvV3NRVERSdFFVVUs4bmFBdlk4MkNUYmpXaDBoMjdXL1F1TE5leTRT?=
 =?utf-8?B?NW4vNUhqQ0s4NUlhZUhtMERUSW5hRWtpU2c4NW5PUnNIaDdlZUE2enBzZk5o?=
 =?utf-8?B?VFRiTkM0UjRyMlZ3SlJBTlZMamFTenp0aWpVMktRYUlGQm5CbGNFY3hPT0tW?=
 =?utf-8?B?TVN0QjlNQktVdGZsTDMzek1ObU5MSzZJeDM1WDc2UzZDSWtIRUpNMWJhYmVB?=
 =?utf-8?B?Z2JIaU12aWVrRkJnNWJlOElpQlR6dFo1QThLYmFxbDljUURBRkFmcFE3ZTIw?=
 =?utf-8?B?aWlXZUQ0QmV2TFltaGZnWlFCaUlJWmZVY3ZQS2RUd2xIYzVtOThEVVFHZ2or?=
 =?utf-8?B?dGFLbm8zU2ZkZjlZZ05sSmozVi9KWmc4UFdwNnN3S1RJdjBpYXU2em5ERWJS?=
 =?utf-8?B?cjUrL1VHS3plRGtTbmNac1hraThwb093Qmk4NUFmUU5JTFZRKy9rS3NtVGtC?=
 =?utf-8?B?dWc4Z3BHYlQxQ1NQZHQzOWRCc3BaUjcrdHVaaVhpUEhIMldXZzM0NndheEZN?=
 =?utf-8?B?TTZ4SU0zNCtSOGFwY0s3bWRJUUZRQXlzQ0l5bjc4S1NXRk9Qc2E0V2ZDWXBq?=
 =?utf-8?B?TFF6NGpJV1Nlb0FNaDhubmJkamZlRER3ZkJ0NjF1cFlZRjd2TXhlNzJKc01B?=
 =?utf-8?B?WGc1ckRrbEtjd2Q5ZElycUhta2xZeUdZQk5JbktCRVZzc0lFQXFwcE5CU0Va?=
 =?utf-8?B?Sk1ycnVocG5kZzlCaGJLWk1pOUVyZmthKzhra1k3MlBPdThLS1BPZVRCTnls?=
 =?utf-8?B?N05yQVoyTWlMaVZocUZ2dlp3d0FhdEFmMXREc0ZDSHFib2VBcnNCRjR3blhI?=
 =?utf-8?B?R1pkcjdnNFd0Y0Uvd2swdW40UUtHU3ZnQzdxTmRuMHlMb0h1TXF4S1FyQXJs?=
 =?utf-8?B?NHNiNW1SRGhMRVhtSUlxbzcxczhpaDJUR0VHZE5VNUN0WW5oeWhidkJBVmlD?=
 =?utf-8?B?MHdMVCtjRHdka2h6bnZzVWdCeFhHS05jZHJ4YzJhTWw5THp0cm5MM3VhQTUv?=
 =?utf-8?B?SVpnRDBMOGZYWVRXanlSRzN6U2RxdTh3RG1zSzVtSEVFU0xESlNvMEpSejY5?=
 =?utf-8?B?eW5xVG05MTVCYWU4cGFjR05pNXRTZWhpZlc1Tk5SZG9UOUJUSThiR2pEc3RJ?=
 =?utf-8?B?NTBrMU5SdjhBRDFtQWVxbHozN3ZKYi9oQlAzVHBodGdUVXk1TjBOZ1E5UlVD?=
 =?utf-8?B?NHUvYS9xQUlEMnQwYzdab0NQQjFOZllxaldpQW1SL1VGRlNQRy9keVFuRVQ1?=
 =?utf-8?B?UjdUWGl2Q0oxNTFNVHhuVWw2cllML1k0QndvQ2pTczJPMXBqWFd1WFZCRitG?=
 =?utf-8?B?czhlNUl0bjhRdmo2TSt2Tkg3Sk85Ull4WDZwZUppMlVLdSthMEJqdlRUajYz?=
 =?utf-8?B?S2RGcVVleXZTNE4vVWxMbzhiaFNVOFJ5dmZwVStURUhnNTUxNi8yNzNqVlVC?=
 =?utf-8?B?eXByTUdwMUVkUUpta0dvWmVibVNERk1wZEdobjhiVHBWQzN6aGE3Y21xWGQw?=
 =?utf-8?B?M29GWWFwazZOOTMyS1BvemFYZ3RUSnV4ZkQwdXlIRHdUZ1psK2Z5d3NHQmR3?=
 =?utf-8?B?WG9JTUpOakNNNXU2SDNTb29xdktEbmc0TmY5UkxYTXNWYkY0R1EwWmtpNGpr?=
 =?utf-8?B?L1dWcllZQ0p4azlFcFQrb1kzKzBHRmRxS1ZkR1ZJek1STzRJRi9VZE9EajVv?=
 =?utf-8?B?akx3SEthdVVkNkJQRmtLN290Q1NTOTRhU2grcnpRSDM2UzFjM01Ea2ZsbVVu?=
 =?utf-8?B?Z3hxUVZpdjBkcDBYSC9Wck84QnJvdHVXMDM4QTBrWWtyZ3d4NFgvZEp1WnBa?=
 =?utf-8?B?cWJRcXNKV0pGUFZaT2xzQnEycU1wbmhSUVJQMkxBRk84TmxrSHNPREpyMW9x?=
 =?utf-8?B?eHh4akhZcGRtd2xrRG5wNTBZVHpNdkhuOWFJUENHa3hLSE1INUZMU0ZBYjZk?=
 =?utf-8?B?L00vY294ZlhXVFZwQzlQN2hJM0E4KzJpRlJuWGRwT0RQTE9xWnVyWVNyU21i?=
 =?utf-8?B?Y3hDK2dsVkk5N05kclNoWU94bTVIL0kxQzJxc1NhbjRKaUZTQWlPc1BWYktV?=
 =?utf-8?Q?YRfs=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 18:16:56.7317
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e14222b8-5bdf-4ae8-d6e5-08de0da95b69
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6024

On Fri, 17 Oct 2025 16:51:33 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.195 release.
> There are 276 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.195-rc1.gz
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
    105 tests:	105 pass, 0 fail

Linux version:	5.15.195-rc1-g06cf22cc87e0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
