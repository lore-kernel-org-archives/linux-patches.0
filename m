Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010061.outbound.protection.outlook.com [52.101.61.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CE034C99C
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 15:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761145529; cv=fail; b=ihLQ2YY72SatfReP4EfnmBsnNlSA/eeDpOz2lavNep5ZZLscKfq1vpD+w+iN9STvHq/YnZAdvXPWEps51A1dBViLVui725gS37ausGqRwTRzywG+9TaottCFuxFFEpWRon0Bh2b9CJlslfY2miPKROINbXfR7THfhVHdX3R2fNw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761145529; c=relaxed/simple;
	bh=jwxw2mHDVAeq4kekniPF8U5kVLlL3iYeWr99zd8DUKU=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=AZ+UcsaVYHvXnPdr/95plkT5zX7UTh7n9RBRExA2gu+1XBsM1M77S3Omb2IbI5FRz5yP/g2z1xAk0g2Y/c/mBpEuqNL49Qok2URNX5qDoU6CbmLbBn97iFd6KVPzCgcF/PHVyJdI0HHNP1pHd+cyQsmAuxDLTLX6pC/QB5JF2g0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pdhsMymk; arc=fail smtp.client-ip=52.101.61.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pdhsMymk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MtX24IHSQn07vdl3z5XMk3fzyp/qQBa9ptQS20rzK8iVV0Pu/lQuFntD5Vo49XqgRv2DehL14WWsyyTkHmVzAqTVg14xx8tr1n4MR0Vvf7GxTrnyJGYpalqTHxkMlN0wKbqCbdG41ZJmbCvqYerYzUY7+nZo3CLnFfgq6akitsTOXHq9CAzb91/1mkXmhHjJKT/uZbtS5Lmcjl8u9d45rhU2prhfr/fxfzETn8a7PrPx5OuxtrSuP6+v93pWOA3NFitn7UEziQzCGQ9hKoZt7rQ4Bw8NpD4byAdVC+AEYJJF9nAUK3AnUREKNsJz1p9Gv/oGPRbLR+vE51PT2CcK/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fe8WJLWCs+4ok0JO3qqxQLelbMs+iiQgeISwlLd+fAo=;
 b=SmepFOs4CQmqxxhOAh3kyaoWYELOVGFCoD65IVT26e/Ec10Q/WH8RaqsCsBhfG6mbZNAaNBmwEhZl+sKVp4JnjdjHNHnsd5QOUD/HgJtwzmxquTQlNynxGTG+S6qRvcjroExz64M5tQChPhDfuU/9VxoVUQiyJvWril2vUToinKeCA7yNiitkqcdn9U55z3unGJxY18wSgr2hL4MO60uL2Ql5BjmKDls5Hx9ma6LpXPb/s3Sr1w/AjhLRMpuXvodsBomLF8wXfuhOzo2vFBRvRH0Kv4gw8hSJbeiEQPVsNViCaTagvNgGJzHAfIsIU3LSuLvWboASgz1MeXQF1fZDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fe8WJLWCs+4ok0JO3qqxQLelbMs+iiQgeISwlLd+fAo=;
 b=pdhsMymk/fYsAizngvtGLIDLbc81ucaPDr+uX0by9Ms1E3yr1kum+cowFcLbie0YWutniM/C+rBjMGEycYGZepr6Rry9h1N9XcucebZ3o6MQ1IFq6b9bYwCHlF5gecMjHiBw2bXqU24xOlSVevuKjzPE5Mzg7v/lT7rHhpwfyRMaPP+FHoFEV+YPq0s5xfqVIsLeFSdOzzVKFeEEkk5ivnCBU27E0N8WKsKP2edo5B7FaNS0bGXq5azT0r09cSC1QC3mzYcs8K81nJ0MNiNftro/ZeKWPBMsBcKV+7dYFr3Pu8H2/EmEqmByRdRRD79KUnmETsmjjRIZnaknWwJVWQ==
Received: from BN9PR03CA0223.namprd03.prod.outlook.com (2603:10b6:408:f8::18)
 by PH8PR12MB6699.namprd12.prod.outlook.com (2603:10b6:510:1ce::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Wed, 22 Oct
 2025 15:05:21 +0000
Received: from BL6PEPF0001AB4B.namprd04.prod.outlook.com
 (2603:10b6:408:f8:cafe::e3) by BN9PR03CA0223.outlook.office365.com
 (2603:10b6:408:f8::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9228.16 via Frontend Transport; Wed,
 22 Oct 2025 15:05:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB4B.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Wed, 22 Oct 2025 15:05:21 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 22 Oct
 2025 08:05:04 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 22 Oct
 2025 08:05:04 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 22 Oct 2025 08:05:04 -0700
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
Subject: Re: [PATCH 6.6 000/105] 6.6.114-rc1 review
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <1ef1b445-eb46-48be-b6e8-f5b5b3f0a5b7@rnnvmail205.nvidia.com>
Date: Wed, 22 Oct 2025 08:05:04 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4B:EE_|PH8PR12MB6699:EE_
X-MS-Office365-Filtering-Correlation-Id: c7aebebe-942c-47f1-65f2-08de117c6bea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|36860700013|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WDJ4VWI3dEFFdVI4RzBnaGgxSklHeXozbXhudW1vTmF3alVIVGMxY0RRQnIy?=
 =?utf-8?B?UWdVY3VkQUtnMFhIZ25JN3R3bTZzUGZyUXo0RU4zQzdNNEJzWVRldkx3ZGJp?=
 =?utf-8?B?SVFPU2dUbVNYZk5IdHgxSkY4N3Y1cnk0K0dlV0JCRnhHZDc2R0lVWTdqL29W?=
 =?utf-8?B?cDVUNlQrQTRkazJrUThtZnhEb05ndHpMNHVjQnJIemhXdmRsSWdNV1AzSFV1?=
 =?utf-8?B?dXZIUVQvaDdWR0kzNzVZZmhVdkVlOXplKzI2YWRYVGJOZmxQcHpmaWNZcXpw?=
 =?utf-8?B?VFpYL1l5U1FUSTA2Y3BKUW9NQjBWdjVZcDRIaFNtT3NaSXRmMmo0Uy9ubjQ3?=
 =?utf-8?B?TUNraDRnL0tRdytycWJzSnczTnRsOTJEcDFLb3B3aVRQcGU1aUxVeDZEQUI1?=
 =?utf-8?B?dy9oTE5yRWFwZEdvUlI0UDNPYW1NZEE0VW5Wa1lDaEQ4MjJTcXFsSzdGZUwx?=
 =?utf-8?B?RHZTVnpqKzdWSkFRQnpMQWFsdmZYQy9sYXQxb0FPYTk1eXFOY2cxdWszVFRD?=
 =?utf-8?B?cXJkNXpBMEFoUWdHa1QyYVUxR09mQ0FiVmcvdXlCT0dLRDBvMms1cHhpdUxt?=
 =?utf-8?B?S0x0YnBsdUQ0RE94SHkvTXIrL2lDSnBzSFBDL1M0RysvbW1UOGZGRjZESDYy?=
 =?utf-8?B?dFZqRkw1QTI1WXJsb05IVHRCYkNCNHBJSVowMmkyRUk0SjZ5dDMxVXc4cmRP?=
 =?utf-8?B?NnhVT3AzRkVQTmhIY0RtNjhRK0pORWM2V0x5ZGNkOHMxdURHMnZLWThCaSsz?=
 =?utf-8?B?YWtjV2VzbnZ6UXlYU3VCNm0zRUE0UTVOZjB1U2pCUm0rUWhRUnVTeUR6S1pR?=
 =?utf-8?B?ZmZIRTZhVmg5ZjB1ZlZ4cDcxYVJDdVVqRk8zY3JpM2xNZUQ4S01NL2V6OU1G?=
 =?utf-8?B?TEdmZ3laTUYza2NRQStlOTVSWUd6V3FrUWNzM1Z0WTNRMUlwWmQvdE9oZTh4?=
 =?utf-8?B?bzkvU2tDeFlUd2FReXo1ZTJPQlVQSzNTMytaYlhhbGEvUW5SRW9VbDNZQmxs?=
 =?utf-8?B?Wko3RXo0Y3pqTWdYM3JTTHBCNkdZYXR4T0ZJdkt2UWRhenkrYzdsUEZiSGNT?=
 =?utf-8?B?aTNVNE1tYno2cXE2UC9ZT0I1YUNHTTFhZko3VGdGQzZpdHV0YTFMS056S3RZ?=
 =?utf-8?B?Y3ZyRCtqWGN3U1hFdXEvdHdmZVhQR2xqSncranIzTStEQ2dQcXppVjBQQnlY?=
 =?utf-8?B?WjUxcEMwVEFESDJqblp2dWR2UUgrUm9ORU9jaTRLTzltZjlVQlV3M0dxZUpY?=
 =?utf-8?B?OFJybGFRSzVyK0pVeW9KT3BJYjF5OUliTGVFNVFIRG95VStsaVUxL0FpTTlP?=
 =?utf-8?B?aXZLcHJPeUlMMysvY0pKejFqT3hBbEFZSlFDeDRXNVV4WFpjbHdDUVRzMnlC?=
 =?utf-8?B?cE9lL3lKc0ZjcU9jS0xFQnlVaWc4eXY4VHJvNmkwUFRnaW9FZG1idERtRlpS?=
 =?utf-8?B?N3dxYjUzSVBNL2FjNFF5b2kweENkN3dISkVTTC9LUE45S2g5cXh3RFdCTDln?=
 =?utf-8?B?OEIyT1N4K1VIOXdoOGVGVkVrdE9YK25NQU1kWFlGYVU4emNUR0xFRXNjc2Nw?=
 =?utf-8?B?d1FrRHNCWTNncGkyTFpRWFNpdmlDY0ZxUGg4eWJEcVpMNlZkZDVVbEdnQVAx?=
 =?utf-8?B?YmlQWFhsYVZuQlVHY0FKMk1LWllXb2h2YzgwTktMSmpwRzhheDdSUFM1TmM3?=
 =?utf-8?B?cXdxRXFxdEsrVXMvWkhpZS9GUnA2bzVvTHp2OHJ3UlpqbFIvWGJPTkx0b3VH?=
 =?utf-8?B?a3RsUjdMN1VpKzBxY2dBMnp4eUJnV2txMjU1RmtFbWN0anA2QUs0Q1JWQ2NW?=
 =?utf-8?B?WWc1b3cxSGVEQTVZR2JGNENtcm1RRkNCekF1U1pReVlWUlk3TzM1MHljZ0k2?=
 =?utf-8?B?RTVCeUVYMm95elFKL0hmUUNvV3VMOGdLejNRWnBIRVl3L3NXS3U5VjQxUnFm?=
 =?utf-8?B?UXlEYzhUMDVWVFZiTHhtOTUvZUxoWldCNWJSOW45VXhVZytLbTJHdzg0UlZh?=
 =?utf-8?B?MzI3d1g2cWt0U3dMNDVLbFhJcU9xREpSc3lmYmlZb3lyaUFjWU9VRnpleEZY?=
 =?utf-8?B?L01mZmVCdTU0RmEzZFJHb1VJd3cxQURVMzY2Si82NDRGOGZqbm1hd0lhczd3?=
 =?utf-8?Q?xjg8=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(36860700013)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 15:05:21.5536
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7aebebe-942c-47f1-65f2-08de117c6bea
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6699

On Tue, 21 Oct 2025 21:50:09 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.114 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Oct 2025 19:49:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.114-rc1.gz
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

Linux version:	6.6.114-rc1-g8ed83e981d68
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
