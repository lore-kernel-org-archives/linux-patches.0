Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010003.outbound.protection.outlook.com [52.101.46.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C33531A07C
	for <patches@lists.linux.dev>; Mon,  1 Dec 2025 18:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764613137; cv=fail; b=moM+9qa4kyhpEBVAVU8gagMI3LaIOCsF6x/W1Y+9gIUAHJ3p1EmAXJqSKMi7qR+6RZcrETTzrJ/O/F4GFDS8K5STnRwKCaWc8po5vb9f8F2/74JmWZaS/gtkNNp+8wqK7oj9qM6+ufeNuX+EYi2836ezTcsmMq158lq3dAdepco=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764613137; c=relaxed/simple;
	bh=XLRIOUMA3seod/tB7UjGvuTTor/WWnp51QW8N/OPKOQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=rXNEbs8ggS7JH2lvtsu39ApbcdfEfy/vlGBgDQ3ulADC0u2A8FxuRNjKs4Mmqzi1TQulqpux43lHIIavfvDAU+EXgegFK2WUWAdOicUSctl/fxyAaPM4MY8gPrrTiEW+2z1llBoPHG4rb6IelOzuXs4lpmeh+rjMKkPC0Yxy0cY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TSaoXuG2; arc=fail smtp.client-ip=52.101.46.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TSaoXuG2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zy8jeuuLn0gqMwV1bh11zUU8FftOzZfEig6eFycMCzAcMG0yrjMlKv+4kV6g44TDRLXz1e3p5rlL61MVBo9ndqj5y7PaBeIrqqN2A5BLnm219xCO7txXBG49pw+vzvykjGYXn0ev+Z3hrYSXN6bKZfNSYaibSMwxHSsJNjjxea27KJo740+BBGsPnZAlbNTEoPiNCfdMR5aKX/NZ5PYKPc7KM5dLFZuIPBbf52/X4cqOeRpokftRegm6wr0x7J2LiD28hhgU8S2KNEwajMc6WspkQmf7wuH8Y9mpBa1tK7TazT3mJaX1isvIpT4KYgBMrGxu2SvLornQPzLigyXegg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TvIx9eVtT+p2uupj1te1ADohxGU3QTtpUZRfYJYaaZM=;
 b=Fa9rjSfzGLMbr2mirZPC1qLwt1rITt6YN7ekPC505S0PEn/KHPVwcLVn2Mtvpt7dv3h7WlWRlDgmA46qqIRs31us5D2GQn4PQoQ918qA0WXhdgSXQ360cp7bZPgxgf/gtOIrAX94kYDO2C5ocNMxZsMOWz7gaC2ginfqqY6+LGPh7O4+TcU7XjymthHJ4srj6A870QCuAyCirYdFeSZMsqeFCy+fxqn0+W8UmoXBS4nQ2t/YOjbgHaWf7Vhj1StnLE0xbklvNIcwgD49LSPyoCCy1lD9OrAmAuGs7BAInbekNy5Q8NHkc6Rsm9oQs6gk6Ccb7phgGb4bk8qVMeP/jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TvIx9eVtT+p2uupj1te1ADohxGU3QTtpUZRfYJYaaZM=;
 b=TSaoXuG28ZxOpKq4yG/YqU5Kd1hE6rFUSsUHm2PMV/IUei1S3FrvLj4Dkzvc4/3JbxAKCqgVtf0kqGo4jwU5LcESe+yu6xb5jW9gCScHOPspZb92bzuJOaPo9SQX0Rdf73vPfteEwzEEmDwzcRpjoo5jvufOvbdUOqYx3ME6+Ei6QdYl/3rfm17ykr3wIB5NfZ8yZU9060lnLdnkVLnZ1jv70NeWj6kDMtmEcpkxFs3domM7RVAfm0yMaH4SZ2oWt71wRcInp1VqIwRMzDP7skMN5nRvYbfBULcyz60vpCNVaPzS1otP8ZwMoaKL/o7Bc0Rn/TIq7LWoBS+LYYaO/w==
Received: from DS7PR06CA0018.namprd06.prod.outlook.com (2603:10b6:8:2a::9) by
 MN0PR12MB5764.namprd12.prod.outlook.com (2603:10b6:208:377::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.17; Mon, 1 Dec 2025 18:18:51 +0000
Received: from DS1PEPF0001709D.namprd05.prod.outlook.com
 (2603:10b6:8:2a:cafe::69) by DS7PR06CA0018.outlook.office365.com
 (2603:10b6:8:2a::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.17 via Frontend Transport; Mon,
 1 Dec 2025 18:18:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS1PEPF0001709D.mail.protection.outlook.com (10.167.18.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Mon, 1 Dec 2025 18:18:50 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 1 Dec
 2025 10:18:35 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 1 Dec 2025 10:18:34 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 1 Dec 2025 10:18:34 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.6 00/86] 6.6.118-rc1 review
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <a23f8d66-0a3c-48fb-ba9d-a78f7f09aab6@drhqmail201.nvidia.com>
Date: Mon, 1 Dec 2025 10:18:34 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0001709D:EE_|MN0PR12MB5764:EE_
X-MS-Office365-Filtering-Correlation-Id: b50279b2-5698-4776-21c1-08de310613e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TUFKUmRGRzhtMVhWaHI5WWg3WUViM1MyT0ZjdGtVcVdWaVhZUWZpamdqU0dD?=
 =?utf-8?B?d05qTmI5WVFnOTdHRmpXaWR1UmFLZFN3dm5CMnFSelJRdEhRTjc3YmNTekVY?=
 =?utf-8?B?Y1ErbWNoelEvTHRaR2I0dUNaUXRnRW91MnVxc2dqNis5OXF1L2t5SGgveDl3?=
 =?utf-8?B?QnA2TE1qaUJER0NyelFUZi9jNEh2M0pvSUE3Y3cyQWYrOUlNY043SVBaLzhZ?=
 =?utf-8?B?M1hPRUlZU21FSnova2Y3di9PMERrbEYwRmdtZjc0TVJTOXI1WjhYMUVNdSti?=
 =?utf-8?B?OE82QXFtY3lqankvdWJLa2dQd2Q0bGZadnZvTjRaME9lcEpUMCsyUit2SGRP?=
 =?utf-8?B?dHQ5VGlFVlo2OXU2N2N1STE3WTJCZDBmTkxGMHlXUnNCMWNEd1cxdzZoWlJa?=
 =?utf-8?B?YS9VQXRQYUV0Z3RyK3VvY1RLV3ZsMTVhVFBhdVAxcHBQWFdON1lRTWF1aUdM?=
 =?utf-8?B?MUs5aG9WaHJrbWh4OW1nN1gwcTIrRW54bUk3YjlmbnFOZEVuNTkySDQrSWE4?=
 =?utf-8?B?QXJrVTU1S08wRGFqQzYwOHRBTGtaS1E4aDNFQmw0dUhJcUNhcjFNZFQ2cUtU?=
 =?utf-8?B?Q1Zuc0FuM1RQMjh0cmRBQVF1UU4wT2N6OFdBUGluUUM2RmtsNzN6SXNUV3N0?=
 =?utf-8?B?OUFBQkwxRnBKbkNzVXMwYkU2UiszeE9yUTFRQVlpMGplaUhSUzNuT2Nyd0tW?=
 =?utf-8?B?Z3ZMdzhJQ2RLNTRkNzAvOXFhNWEwcytqVTB6MFFGbzFrbFBQdytwRnhwVVNK?=
 =?utf-8?B?VWJzcUVFcTJUZnk1dTRFaDJuUVQxME9tSVBJUklyY3dRTVhZWjZ6aXM3N3Nt?=
 =?utf-8?B?QXpCWFV0VlJNanF6MmhLZUpBRjVYYWljV3IzZWp2d3VQVzMybFNvNUllTEpM?=
 =?utf-8?B?em0rcmNYK3Vuc3UyTlVqRXlqUnA3QWQ4OW1tR3pPdk9vMEJCYWVOaUExQk9t?=
 =?utf-8?B?VDVUUEtkQURQdThFWTRQdjA5dzZSN0tRM21BaUJOVzVLcUhjS1l5Z3ZLQVBr?=
 =?utf-8?B?NUFkTGRicEZRdEJrZC8waGJHZjlSb2FleU5hMjY0NHdBbE5RazRyYWR2VzhX?=
 =?utf-8?B?STJMNGgyTXdpYlhVYU9PNkh3bWN1blFXMnFzQWdpRVRJTEphdVkxdCt1UCtT?=
 =?utf-8?B?Q3drWit1ZEFNZFp2dytENVFIN3M3Ujg0c2Q3d054bURwTDZGM3lpNG95eEZ2?=
 =?utf-8?B?YjFrS0UvaUZtUnpRMXJFSStCZVB3N3JzdS9HSDJRbW00MjdBZ2FYZGNmN1RV?=
 =?utf-8?B?QmxIL2w0Z3ptcG9FMVdTREt0aWRJS3lWeHVBMkhqaUxLLzlmUWFGRnBSeUV1?=
 =?utf-8?B?aWI0cmRwNUhjL2M4aWJFSDFPM0hnWmszWWRsa1hFdHQ1MEdyNGRuN2RPUnZm?=
 =?utf-8?B?SnF0TkV5bVFvaHljaGdtemU5YnNjU3RKQUErZ0U5OEZ0Tkl5OUk5SlRrMnFw?=
 =?utf-8?B?c2RJVXFITS90STkzdmVpQ1lMOG1IbjJaWUVaeVV0VTI1dW5PSUUvS2ZKZTBx?=
 =?utf-8?B?d3kvenhxMjVJQ3Y0a2dTbHVmZFplOUZDYVgxSXdUVGo1a0RuREcydHo1YmRG?=
 =?utf-8?B?b3diN01vbFJ0YVJOTENUMTcxeVNSYWk3Q1ZkcXZzRmxrSitGVW1mUTFzUUhi?=
 =?utf-8?B?QnIzTmZ0c0hJbzZlekp1L2hrQkN2Nzd2Z2U3bW04b3pteUo0Mk50TVVQMFFR?=
 =?utf-8?B?Sk15ZTcrcUhYSS9SODI5amZNSG1RR2srNytKcnVzS2FOK2dWbm9oQ1lRVkxV?=
 =?utf-8?B?djJqSkdxM2NydkhaS1NlRnZZVndFNzV2OXRvZmZDenRabG82MmRydmJ4WXRk?=
 =?utf-8?B?MjA0K2pLNHFwd2hIbHpUNmgvMGtEKzRkR3FSMC9NNGlRM0kreFZkTXNWcE53?=
 =?utf-8?B?ZVVNQURpK3hnNXFKd3ppZXo4UHdUTHF3Nmk4M0JwRGdZeVY4R0FyZVRkQ2tq?=
 =?utf-8?B?NExpUk1iN3A2Nkp3cUpjL2dYeVNuam41VHNNM3NrZ3ZqNTd4NWUwZ2xRRndl?=
 =?utf-8?B?UHlFSEdoeVpOdUs1N0FwNVRSL0IwRGN3OEQrcUVCTGVsSDBtS1NUNTF3cm9I?=
 =?utf-8?B?VVV3Wnljcis3eGZQSG1aVkpMRHg5TVRQVGdtMmtHdDU2a29nUmlWSHJrOHRH?=
 =?utf-8?Q?gUOk=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 18:18:50.5054
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b50279b2-5698-4776-21c1-08de310613e2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001709D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5764

On Thu, 27 Nov 2025 15:45:16 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.118 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Nov 2025 14:40:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.118-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.6.118-rc1-gdd9a47301c80
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
