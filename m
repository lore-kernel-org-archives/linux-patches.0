Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2043.outbound.protection.outlook.com [40.107.244.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C32928CF53
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 09:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749030057; cv=fail; b=DwjZP0GVEyINYagS/ZN4vwVnGS/IfF9excA4Z+ZEs4OHLX50dzPYDsRLgQtLfj0kpAZskv8InrWpUsz3GSaReBrdA2HU3B4ub4PLhug/D6Z8lt4lP1nAr+XEA9WlqXzGf31tN8NbIKBSEpmPnmpBHv1g2enAKoT9YItrKS7d9UQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749030057; c=relaxed/simple;
	bh=TZiCviasm3a5CqqSqd210HcTXITYnTtaxo5MfTsy56M=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=gxgPB+VSOhr5ZXzhfTXc8OP5fvIOi/0REMR5u4IWF5GdPLswNOocF/EXuEG5nRISDHNMStzEdJJFnPEZNtY1UjDInzwyWUrjzaPEo2FhRY+ZDhm0Pr6Tg3v8vKWCXpthKzxdpTW+u5lmUCB1ScF6xjAxaz2Mj8IWgCH+u4tZczI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=r9+jQ3hI; arc=fail smtp.client-ip=40.107.244.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="r9+jQ3hI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UO3MRD11moFfEc9lC5RrEQuXhfsEyeWy6nw8Ta3ZTuJmOZ9Yy0vNRa4pfjZJuQuCeLE7VxCAPqtQjmJNxOKB3TXhNA0j7ksNZB5hccGUk/TUmu15p7N8hB1Ggj1AyIMX+fR+npAHN746DBzRtQcxNW2Qir1NO7nJUBwVLFYsez8+FwAS/ZjOo2OeKXaKmK2f7le8kYrZokiv38nWDvb1wp2HNXASYYT41Fc1t4j8OIm4Rd/wEY4ic25GztBHbaSWnVZrq/FckkIo4pd0PRp+kYpQjYinSLWGc2gslGNxoHSBhNxlIh7ccK4MwbBLjyak9/GviyieGZ3JYLPxpX0ilw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U/00dzls60r/A/Vd9+S7AP34nauaD7tfsZkx8bVZmwE=;
 b=beK4qFRs8jyzPn9MzX+7szPcaN5c0mjIEIdURWuvg2gA4dddT2SHPWfQ/pHSwm+OhrX04y44X6mSHEkR8x2wp8/q2FJzvKC4tC+6mwwivOjuBv2U2wRd9L097Lwu73kxkPLFZq5qP3rMANlQPW+WSV59K0wfEWU7dEgQ3SlawfWRvd+RqNXcsV7pc6ou6T9E/7I9aWBExad5J/78IxSQUgbEy7iC5YZpqTR/gF56l/bvdJ94YadIjfNn7USQrgZGeTtaCGFq6mFZMPKxJ/Hyp6MTj0eWNTs6whlX1lhUaPKshQ9sjDM6woZjptQbZU/OsJUsry78++fuzQWJokkWBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/00dzls60r/A/Vd9+S7AP34nauaD7tfsZkx8bVZmwE=;
 b=r9+jQ3hIRQsvxsrE1NIAEp4Dik5HLY2xDAO95vrZ3bSn0E/VKB6DC3YYHTC/9b8zKnEVeRlU5MV8X4EeGfjk+eqs9Ga7MHEeUZNuBOVTAE1PldW1RTiesKDYQVjgUXsmzexxg+0KrC25NL21bSzx7IAeoCJHd+iARit9R/U4OByUSifDqZdSe1aonftNzcAEWsbh5YFZsFu4G4skIvygEdowRkcP4hoecG/PHbMHNYLGg8l79Gw499c3sFrVoBt+PlY6IiWj7W4Zfc29tvy9c0xZyO4sMwSRhr4vS/KOAXb7Sr4oBZ0P6sjUnOairiZWzgdMkjz3Gn7vAIPsWL4hvg==
Received: from BL1PR13CA0270.namprd13.prod.outlook.com (2603:10b6:208:2ba::35)
 by MW6PR12MB8733.namprd12.prod.outlook.com (2603:10b6:303:24c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.37; Wed, 4 Jun
 2025 09:40:52 +0000
Received: from MN1PEPF0000ECD4.namprd02.prod.outlook.com
 (2603:10b6:208:2ba:cafe::7c) by BL1PR13CA0270.outlook.office365.com
 (2603:10b6:208:2ba::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.22 via Frontend Transport; Wed,
 4 Jun 2025 09:40:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000ECD4.mail.protection.outlook.com (10.167.242.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8792.29 via Frontend Transport; Wed, 4 Jun 2025 09:40:52 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 4 Jun 2025
 02:40:34 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 4 Jun
 2025 02:40:34 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 4 Jun 2025 02:40:34 -0700
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
Subject: Re: [PATCH 6.6 000/444] 6.6.93-rc1 review
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b1a1b94f-9ece-4c88-b239-a2e35a1efb59@rnnvmail205.nvidia.com>
Date: Wed, 4 Jun 2025 02:40:34 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD4:EE_|MW6PR12MB8733:EE_
X-MS-Office365-Filtering-Correlation-Id: d3c44ae6-dc6a-4da7-53b8-08dda34be5a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bVJwQ1pWamx4RnZyWFlkV0M5cGM4NHFMTitHNkhGYzBwTDZGTUc3aU43ZHdD?=
 =?utf-8?B?c3NISzNxRkVEcnBRK0Z6cFZDS0tUQlFaRUR4SVdNNmhGSDE3QjZvbHVXcVRk?=
 =?utf-8?B?a0pUR0k4OWVQeE1vRDZRV3VEdlUvdjBiTU92cEk2dEVYN1RLa1kzbVRocmtw?=
 =?utf-8?B?YXlzREtXaUFUVThJRmpDenFWaTZBNzJWaDRHbGhONXoyRlJUY3FSUmZQQlZn?=
 =?utf-8?B?Ry9GNVREZ2RlQlJGVzhDOFYxQlo5Yi9OejBzbW5TMWdoczBrYWI0UUNKblBv?=
 =?utf-8?B?alc0c3dvTjIyYWtMVnYwb2ZvMzc2SFdUNzRKRGYwSWNLSUE0Z3Zqak1QMFo2?=
 =?utf-8?B?Tm1IU2RESFZqcnRJNzVUMkJjWFVaS3YzcHBxRWo3cEFpQUh2RnVvalJYRmFF?=
 =?utf-8?B?cTdjWlZXcXNNdElUeFk2SVgvNTVqODcyR2d5cU1WZmRSS29mVXFCaHJxSEY3?=
 =?utf-8?B?NVV4STZncVd5N3pxYmloTFpCaEZOY1R0QVZqYUFlekh0U3VqWnR1bUhrYUJv?=
 =?utf-8?B?dFpLTURMSEZHaC9IcS9vak12ejcwU3Q3YXF0Tk90UEczVkhqTW1jUUFoWXEx?=
 =?utf-8?B?dmkzcTllZ3kwY256QUVrdnE3NTdvbi9pMVhGS2Y3M2lXeVdZZER3aERab21m?=
 =?utf-8?B?UVNudEtnR1JaT1JJbENlR0JQMzIzZExvVStNclVxTWVNOFAxZVpjc3Y0TXVU?=
 =?utf-8?B?MHV6ZHJaL1lRUmtVdkVYT0ZhZVlvWG82ZlpRUGhUYUZoMXdtVTlPVXV1RUI4?=
 =?utf-8?B?R25JVkxoUVdTb1IrVTk5UmxlRTJTSXoyVUYyWG5CMXVsRXNoL29LdzJqNTd1?=
 =?utf-8?B?WE1XY1R2KzAxU1RXOXpVQVI0T2tNUXNPWi9MK3o1aW9aY01pUDVOaGRIT1dl?=
 =?utf-8?B?QWtwWVlHNXJpSkc2M2tSVlZoME9vU1NzeUxKZk1waWVWd3JiMlcvOTFrYjgw?=
 =?utf-8?B?Rm1wb3BPYVlMbjByZUJwS1hlZStDcEJGTGNIdHU5TjBWNUR0VmdMczdqbkZv?=
 =?utf-8?B?dklzR0o5aHpoclcvV3VOWXM3L1d0RUFtRHhRQSswUlRSUmR0UkVsR2Q3Q2N5?=
 =?utf-8?B?T1puTzVBUmZud1pRaWtUM3luZWFrQUVkQU1xM2dXRXMzL0c3dFJnTlV3TTlC?=
 =?utf-8?B?dGQ1Y2kxWEdBNms5U0RlaWpnSTNLZ1NueDhGNXJnblg0VXhZc2MrM20vTmQ0?=
 =?utf-8?B?N3N5TDA0VUVZTTh6NkE1VlFVUEhQRTFtdEpsbGpLaG8rOFlXR1hKQUJvdnAz?=
 =?utf-8?B?d0JqUDBhR3RIWHlQVHFIbWVlM3lXcCt3UDRaeTlGN2QvdVJIKzNFU2oybDVL?=
 =?utf-8?B?K0dveXNVOHd1ZG5pNEd1QjA3RExtK2gwQkpIMFU5M1JtSlVUZ1ZqYVlDamhI?=
 =?utf-8?B?MU5KbWw2L01jQW9vWXEybDFKWnEwa3J2SW55QkVwUGhybndsbmZHTDcrdlpa?=
 =?utf-8?B?VmNqY3NiVS94V0NPMGNFS252UTQ3UFZDTFA0MG5JTjhKMWpDMEZoVVVZeSta?=
 =?utf-8?B?SVpuc1Q5SFhQZU5WRXdxVXF6U3hPTEc2WitWR3dMejMyNnA5b3pZL2dvTVlJ?=
 =?utf-8?B?VDJkUU15WEtYcEREc0FadUxlWVFUL1BBamtuN3Z4QUs4OHlmNmFWRVhLaVcz?=
 =?utf-8?B?MkwyWkFpSXU1TmFVV1NYV3hsKytwT2g2Uk9QaE1Wb0tkUnhnK1hISWRneEky?=
 =?utf-8?B?d3o4UVd1amQrWDZwUEZCVGJQaktVeS9UQUZ6TWlraDhzVmdKUS9WWDNEcmNC?=
 =?utf-8?B?Y0ZnSktqVkNLVWV4b1ZiZUZnNlg2NDA3cWc3blZBWUlEVTZ2YWpoUi95Vjdz?=
 =?utf-8?B?Q1BQeElkckwrOVRRMWZScTVWTURqeGdwL0Y0NU1lQlIvNFZNVEdQRlZ1Yk0y?=
 =?utf-8?B?NWxNK1ZHdHZHZGxQb0owRW9BNjQ0K1RHenlhbGhRbk01bFU1cVo0ZTA3SjUx?=
 =?utf-8?B?aWFFQVVibVpJWlF0TG5MRGtCTzFMdk9pYnNpb0xVQnhkSFZnbEUxa3daUjNP?=
 =?utf-8?B?eWVETk4xcWdOU2EyTXdvS09lTXQ0UFc1WHlGZmZkdmhDdGQ3Q2ZpVkxzOUFJ?=
 =?utf-8?B?R1QybjdYQjVCeWhBTmd4cWJhbk1YNU1mOG5ZUT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 09:40:52.5110
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d3c44ae6-dc6a-4da7-53b8-08dda34be5a7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8733

On Mon, 02 Jun 2025 15:41:04 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.93 release.
> There are 444 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.93-rc1.gz
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
    116 tests:	116 pass, 0 fail

Linux version:	6.6.93-rc1-g58cbe685685b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
