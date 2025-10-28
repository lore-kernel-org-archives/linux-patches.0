Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011031.outbound.protection.outlook.com [52.101.52.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAA530C616
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 11:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761650959; cv=fail; b=XKdghzyufbYNimgOSCoqM01n6iCywbROa/1fkNlQHfHLMTx+LWy/P9nERhMJIwp7cZh3JVpCDi3GJTEaV9HxcZ88j7im1RDg2lFiEh0CrGC1IQh6XjYv+d/wfdOJsqTZwbk8MG6GxFEkZ5SfB4/GQN6moqGursZ7QFmiQogBzjU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761650959; c=relaxed/simple;
	bh=G9jiu2sQqifvC7fgeNfgQdA7Y46aExZ8taNGrX8BmBg=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=AEeQjWZqxF73hGXNMdd6C9XFRqUh6ejmxwrmz2swvn9Brh0lNXoXsDsExXSp4hfvDmnJtF1GqDWjSQl2Vn+f6xXvo2vNXC5FhPgb5fOx8d74F6vOORYfLDW5gmGOjgjML4tkoFJfSm7UoG0ytGoOVa46OolZYml34sfQ4aOYB4g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Rt/QBDyl; arc=fail smtp.client-ip=52.101.52.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Rt/QBDyl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nfy59t8eAMAJy7Z4d5CAoL1NCdWKY91KfXeHKH2R1uf3tkFUYRfUHt7hspE0CurNIEoU1DRzqpvYLEdydJ7jqhcGEDmha9oMskG8gKDdZQI+8334upnRo/hSzN6purZuwB7i0rZc3a9QF2mlCCGLNSBhRK/Wi4Km6ehc+1Kelptg6rFbtAyuxnAy4dbJ8hUfRvWaOwbbYiYBPPPupztV9a/ji0JGNKi1wxHOGPhHjvOdM/tW0HrSn5Hg2ilhlr6mfPtsRxxpha2k/sZh+9aEHUVi8bOsbkSGANwkRi6pfrOfQlZZUFnzsxo3cpWaL3blgL+tVG7CO8pflIDGE/mfAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YsykMG1oVPOdIQzfiSTyZlxCfSbK2rOlfkzTl1qQRc0=;
 b=jX/gN+is2/cln6QVTJSx7bGCDKnUCBe+gEorZxL1aIsIL8N+haEDUe41sLMlMYjCOd8dW+mKPLU9rEFV213SCY6bj1sFr2Z7mit07ebdi3HbdPp3Fs4w6FFfXLkOho+ocGY7TnwSc/KKFmM3SCiUAxr0kSEtEpfoeRlKSVLJengM17dWLgmSt7n1b3zZzo3XsJ+Z03wZuBTeXA4iy1NXuWpFHx4+Fe+Zrz3rsbD4720qaPruTdrpJw11EP6/mfwwg8XEwcdnSdQNUdBZxeiPPhrNuTh8sV0KFL5LSuSWo/p06vff/8V7t0tdYVxOcNDtSGUDki3Do7YgQYTughFVAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YsykMG1oVPOdIQzfiSTyZlxCfSbK2rOlfkzTl1qQRc0=;
 b=Rt/QBDylJWiNTAp4FiMizGgEt8ZZWv9e2DhFa30MyxaAUqhAi2AlPPbGVwmeDdetkguqWXsbnUDSXevjc2llFpJYSYXRAvzciG5Dmxfad7Ka0b0QY+NPETW5+WntmUGew7QY+afU1bUTEHsUaUK5ZasrZR2gcEmMNFLh3jVj8vy/mdhl80HCLBGHMjPDdmfyiTAggcF9G1pw9mjf4aMcV/H5GAlgDEvzix9b2XLN5VIcmXrAGTm7v9a94tTWHNOF1DAkh9373cnfCNt2HfKamBD+QZyr3foRXtrua//DZ8AXytq271aK+x7KxIdUzwNTL6DEDFAO6hbB8BB4KudXbA==
Received: from BYAPR07CA0053.namprd07.prod.outlook.com (2603:10b6:a03:60::30)
 by MW6PR12MB8833.namprd12.prod.outlook.com (2603:10b6:303:23f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Tue, 28 Oct
 2025 11:29:14 +0000
Received: from SJ5PEPF000001C9.namprd05.prod.outlook.com
 (2603:10b6:a03:60:cafe::cb) by BYAPR07CA0053.outlook.office365.com
 (2603:10b6:a03:60::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.19 via Frontend Transport; Tue,
 28 Oct 2025 11:29:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001C9.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Tue, 28 Oct 2025 11:29:13 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 28 Oct
 2025 04:28:59 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 28 Oct
 2025 04:28:59 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 28 Oct 2025 04:28:58 -0700
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
Subject: Re: [PATCH 6.6 00/84] 6.6.115-rc1 review
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <5991d1f8-37e5-4a3f-8cb1-4d703a1d2c92@rnnvmail201.nvidia.com>
Date: Tue, 28 Oct 2025 04:28:58 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C9:EE_|MW6PR12MB8833:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c9967ca-7483-4319-fc89-08de161538fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y0FMMnZ1dGk3cW4zTWVsK1ROMFJYRVdDeHMwUDNjSWJMOFdVWU04dkZVcW5S?=
 =?utf-8?B?dzF2aVF5ZFJraU56TG1ta2xkdHo2Mmt6ODQzcmNZNTZrK1dEVTQwYndGTXNJ?=
 =?utf-8?B?ZjVLTGR3cktXb3dWZDVERjIzbjRYdEN0cE1heXdyUGs1MkdFQVJvdER0M0xO?=
 =?utf-8?B?ZGx6VHp3TktnSlZBUHRQTUtQZCszODFwby9hcm12MUFwZkR5U0MxaUdCQXV6?=
 =?utf-8?B?bDZ6ZTNBWnY3TFNWRFZUUFNwR3R5Q0ZWbVh4R0ZWZ2lnZUFIWjUxVGFJcGFP?=
 =?utf-8?B?Vm5RZVJpbTRqOXlIVmtvRy9INWhEOWxQZHczMFh0S3g5c2EwdzJOR0pOdmNx?=
 =?utf-8?B?YkVGV2J2cmd4N0NxUjNsNjBKNk51Uk1yOVJnYm5XT1E3TlpUZWpzcjhLeHJi?=
 =?utf-8?B?K1VaclFiejdjdERyN0VGSVp4R1lZMHZqUUh1UWx6R2dwR014bDhFQjBFdkJy?=
 =?utf-8?B?aVJ3RGVzSFVUaUxLKzFRUk5xdHJIbnFaUHB3VUdVV3FQSk0xeWhNcTMyUGhr?=
 =?utf-8?B?Vkp3SWVzK2UyekRwUGl5ZGo5Mm5HME9aa0lyemNIMDdJamRGOWVHUHpXL1Yr?=
 =?utf-8?B?K3NDL2VqcXZIZ2FVNE0rMFdiMjlMSkFoMXVjRWVycmpUWll5eDNuWDNtQmh4?=
 =?utf-8?B?dXBDY1JHN3lONi8yRFVxTm9uekJMNzZFY1hNTURPVDRraC9YNXFuNU1jbzd2?=
 =?utf-8?B?U1Z4ajlDWE1lWUJKTmE1V2pKMEQ1clNJUUhXeVBlVE54aEpuVHE5OFFhYkFk?=
 =?utf-8?B?bGNReXY3YXNwbTJvbmxmd2kvTVlkTXdQNDh2S1BVelFTSUlhNlNaMk1CejhD?=
 =?utf-8?B?Vlp4azNZQVdQSGVQWWZMUEFvSkc5S1cxNHVJcnpLNkpKd0lBY3VsdGl5L0F0?=
 =?utf-8?B?d0ZpTXY3Z3hnNm5xWWljWkc2Rk9xSTBJN1dKdTNWVlJGOE5US3VvMEZjZ1V4?=
 =?utf-8?B?Q0hnSFoyWmVoeDR0aHVXNWVOam9CNDFndjUvWUtuR2NMVFhxcjdNT0psYXd3?=
 =?utf-8?B?dmpYKzQzazJ5NXYrOHBNQUEyQURIcEFUUk9vbjE3U0d3YmFDSzk3SkZqTXI0?=
 =?utf-8?B?ekhJeXhmSUJQRUt0OTRlenhlWWkvbHdESW1yZDVPNndyMVVLLzhlZG9OMHJr?=
 =?utf-8?B?cEF2ckdEblAzV1NPb0p3MzJlTEw3T0g2azQyem5VMnZObkhUQzNLbWhsK1dY?=
 =?utf-8?B?eUc5VDc2YkFSMjRRaFhHKzUvdHlndHc3d3M3WTZ6RVJjaVRacWdJYmRNYUJN?=
 =?utf-8?B?R1d2N3d2UU0wWEpMcUU4ZU9JbS93OVhZTEpDRVlwc1JKWkwvWmN2NVpZYWNX?=
 =?utf-8?B?YnVoY3lDdFN0WUM1M0FjazlhYzdZT01nOWdybnh3STRTU1lXUmttdHFDQjBz?=
 =?utf-8?B?bEEyRC93ZmRmY1lPQndIVFdObWpKdHRXVUlTMlpya0tjK3ErbklES1hXOHB3?=
 =?utf-8?B?U3A4VG5tZlNaVUplOFhudWxHSy9TazNVcVlmOHRzeWtsR1VMOHF3alFVYjl0?=
 =?utf-8?B?NDR5SzJ3TzdPVXd2ZjhMRzJaRDRvUmRyT01mSkFlL01CdUlCalExZkRZeHRV?=
 =?utf-8?B?MmlNbjBEQkNPaENBYXE3T3BrRStGZm1UQnZrZUxObW81VG9DVG5FdU0weUhy?=
 =?utf-8?B?cXErYlZZSnlhM01JTnU2RDB5QlF4RTZ4WGg5SU5HRjRUMDlyWm40ZHVoNDNp?=
 =?utf-8?B?S0lQZXlkNzJzVFZONnJIZXhWamVoTTQ1bm9mUkd5amdBTFdwc3lUbVpqbTJo?=
 =?utf-8?B?K0NLa2ZLY2FNQ1pBQ1JWOFd2SU5uK3U4L01YZ1RMWkFDZE04VVU3LzhUNS9J?=
 =?utf-8?B?YkJ0R2RFYlV1eUluSUdzMDdtUVpJWW5Kb05zc0Z1U0RuZkx3QkFDU1oyc3Bz?=
 =?utf-8?B?N29leTJvUU02eGNacnJzQnJiWDlQcUlCS0xtV2ZOd044alI5d1dJazZaZUZI?=
 =?utf-8?B?OWw5RndWbGhxSnFUQ3dGNklhTGltdEpIdU9tM3BuUHhId0dIOCswVWRMNGlK?=
 =?utf-8?B?eU4zNWZmaFQ0aVplT2JubURObW84YkhKWEFvK1pJbTQyNGo4Snc1V0Q5SDR1?=
 =?utf-8?B?N0pKNXFHU2RpOHRoeTdBMjJjYmdIZ3h2c09tUEpOS3YxYnI2V2E0VUxNdEM4?=
 =?utf-8?Q?OOhI=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 11:29:13.9223
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c9967ca-7483-4319-fc89-08de161538fd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8833

On Mon, 27 Oct 2025 19:35:49 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.115 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.115-rc1.gz
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

Linux version:	6.6.115-rc1-g6de03dd48e80
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
