Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2049.outbound.protection.outlook.com [40.107.96.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5238470802
	for <patches@lists.linux.dev>; Wed, 15 Jan 2025 14:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736950453; cv=fail; b=bMGIG7p4kBs1acDf/Ww1w+lCMKro6HwxKe6ufqpKoNhaYOZffKbN+qaawV2IdQ+lzRWydR0XtZCMUxIeKugY5wRaA3smD/SSeEzZ3QzIheSKVmPTaVwr7z24Z/EHa4y0DUmE440HwE6vMckocBjHHEwifzv6Wlk/nELW9B2OAOM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736950453; c=relaxed/simple;
	bh=79Ps8HsSEVbfmu7XYWZsstj7/nQ8dNrz85W3z5u41jM=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=PybbG9dCRZBvp7Ju9P/RDFtwuN7spftr6o64rb7B1h0fNMA+0S0W7IbNrG4dYHmaZ7S87TsYJ5XfPgv73ny/70tKK8DGzRiraWdruxz5XO2LWjcNM1wA0V0Z4xPzplQrYT9pi34dce6k8qWJeWuepj9fSFOw33X8xsqlquPk+Qo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SZLyvQDs; arc=fail smtp.client-ip=40.107.96.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SZLyvQDs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z1lzoFjH+P8ke10pP9uuH76wRpY22K20ct2ZKQ/LKXkHlTr2y+GWcT7AbtZkXD8dTMwCRjalfH2TvMHtq2CuKj2her1KvH3RIJWuM/BpyRlRZ8BAL3fVpOjk7e9eWM/yZ7QoKyZNoM4jqGWiS0PAmQDKbB8KpD/HzOH15Yexv/k+zs4vZJ0sy0RtSUeMepY0jlCldxce+fLJbSatcdHaFjQ6eaozUvTz2YObJ/HSJbgkZsIGvo1S+aR17JQVzV+f09hwQmrTcCF9SKSOy5w1FcfnQGDQMmxDHMEplvZWMaxSlKNnqOWYIyBWhJ3vfMO9DVaAmutkZGIWuBzYoaAh6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rvXaf7RKCcj30Bs/wMZGGupcBRwKZWsoqTY3Sy3IFlc=;
 b=mmTPD23zzVDc6i5GivhSfHoO1zfmsnQcFx42lm3UI7qxkry3nniJ3LBvj0kbawG4ITZzOAHr4nczYVRebIqtB2TihUrjfC5PgJVr2nonpTd0M7ts6OMtZe5rinL1P1s8+MObN+7IKhhK0C+8rXRvyiyWtm7d90ld2A+VqssoGE8V2Bgw//qmUzAlJKknczWjxADq53r6+GwH0smjHOAOudCxvG9imgT0Efd5PbUXkw/oW81HvsunN69/1dtnUzSFGDktNnx207m4cHlKg8wpulRw1NxqzK54G/CDIgs1NyV2bnY1u7LWTlG/6fK+mD6xbwxYGe9cymiUDVggoKxF6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rvXaf7RKCcj30Bs/wMZGGupcBRwKZWsoqTY3Sy3IFlc=;
 b=SZLyvQDs4t1mye1oiJiOzQ5yD9O0NdHguKcSkFt6lTM3f6czN0v1IA/dNmtgZqepyeAw0NnhpPUWQzOocsIN0pKB2EPCzEK6XAFbXhN/iR5xL29kLq3NesfMgPTOqj7ESuZ4NvS2xse5ZSgKyARagsE/1BjnQzFem312o6lbcrPt9378ek/qLtRabedTqWWTvXQ2typbPQaYjIA5J5+IljwbFfNKxIWCXdSA6qScd42bUFgpTDTgkKRoK8+T4ydIQsVeE6JkvlPQdqYy1Z0xzziLnAhfNchuJeKStM56b/+wODa+914eg16xrvyY59sXaI6qVVqBMFEPaVUaYD8pNg==
Received: from PH8PR15CA0008.namprd15.prod.outlook.com (2603:10b6:510:2d2::27)
 by IA1PR12MB6161.namprd12.prod.outlook.com (2603:10b6:208:3eb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Wed, 15 Jan
 2025 14:14:04 +0000
Received: from CY4PEPF0000EE34.namprd05.prod.outlook.com
 (2603:10b6:510:2d2:cafe::1f) by PH8PR15CA0008.outlook.office365.com
 (2603:10b6:510:2d2::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.14 via Frontend Transport; Wed,
 15 Jan 2025 14:14:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000EE34.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.11 via Frontend Transport; Wed, 15 Jan 2025 14:14:03 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 15 Jan
 2025 06:13:47 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 15 Jan
 2025 06:13:47 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 15 Jan 2025 06:13:46 -0800
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
Subject: Re: [PATCH 6.12 000/189] 6.12.10-rc1 review
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <91938c95-7d33-44c6-8a6c-935e9e1bd6d4@rnnvmail202.nvidia.com>
Date: Wed, 15 Jan 2025 06:13:46 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE34:EE_|IA1PR12MB6161:EE_
X-MS-Office365-Filtering-Correlation-Id: ecf6e05a-6fca-4ad3-c482-08dd356edd7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cEk3enBpRG5qVUR0UTc1SGM4NnQ1ZjViVi9UdGhGR1hDN0xtc3E1YmdQVkxv?=
 =?utf-8?B?Z1JPREtrUGFBQkloNnp5OEFndlRGWlRLNkNOcGJ6UkxORDZ1eDRBSURzMmhC?=
 =?utf-8?B?WFBiV1ZaWkxBR1drbUhlOGNUQXdOTlZIbVZhL1hoTE1lRitob1hjMVU5UU91?=
 =?utf-8?B?SWtEdWZKN3daaStQeVBZT0FVWlROdXNNRGFGMTVDSDF2QzFwWEc1RWRJdlFu?=
 =?utf-8?B?RXZlckRRMjVwVlVJWThFZ1hvN3NWb3RPcS92bGp4NDZNczNCLytPTzd1RUJH?=
 =?utf-8?B?blQxdXk2Q3J3QTF3cjZBWlpjRzdTNTdQc0ZucWNwUGE5RXNMeWFJWHF4ek5B?=
 =?utf-8?B?T0dQUGxna2pSRC92MjZ4MGdPcExWVjVlUHk5WlRiQnhZT3lwZGVGOHlUMDdZ?=
 =?utf-8?B?VlkzRTZjNkVTR2RubjZlb0g3YkpOeEExZElIOG53YXRSSWJuY0pFRWJrblMx?=
 =?utf-8?B?Y2xYdmppVHdqNEhFOFMyL2Q5UzlsaTdrSVRoZUwrei9EZitRd2xJMWlwTE1H?=
 =?utf-8?B?THVyMmV0aFk4UjZRSVRMcHNHMGFWUEFzNDEzdy9DMWl6S3hZWDVmcllheWkz?=
 =?utf-8?B?TzVFTHlQeWhqYUozQzRzQlA0bktjZEpYblNKdldaUWhtNFBSMmhQTVVnL1VZ?=
 =?utf-8?B?ZldlVGp2TTZpMTZzTXBXSXV3eVhkM1hNYWM5Y0s4NjBtODhtOXAvTzlVbFdl?=
 =?utf-8?B?NGdPZ1NPcDEvVFh0QVE2U3RiWFdsa1pFaDdRa1VlQ1IxM1lody9ONDdJMkxu?=
 =?utf-8?B?ajVicmJFcWhKejVhYVEvVThoS3lDRUlBbnZYZVJDS3RidlpXcjduMmJuQXV3?=
 =?utf-8?B?OUtIRXdpRE5vdFdJUG45T0ZoR3c3RjJWTVlKZTBtRldxVzF3L1FMMVk4YnF3?=
 =?utf-8?B?QmtyUGdWVktHcGZ0RmtDbVhwVkUwOHZhQ1Fjd2x2ajVrdXc1Y0V6WWdhYW4x?=
 =?utf-8?B?bGpPa3JUZzh2ZTJ3aFhtT2U4QmVuQTV0NXpsMVM5M1FTQTRGMDdnQnZMT2pB?=
 =?utf-8?B?bXVOdzdzSXpTcUtrTlFoUkJaekVZdW1lVVBMQzBvRytWQ0dvYUpDeG9xMVJz?=
 =?utf-8?B?cktDRjdoR0hLYkgyYk9iS1poMlVsRlFRbFU0Qk5haWRIMW5GQ2xsaHk3aGhw?=
 =?utf-8?B?TnpBWnRGT3BTalRVOTdEOEF2ZldsVUJ1eU50bzJjMGZFMFFsT0pwZHBiM3Ni?=
 =?utf-8?B?c0dST0RuTCtId1VNUDl0YlVucDNXUSt2R2JQVUhTUEtRelMxZm5UK2Iyam5r?=
 =?utf-8?B?Y0JTaHAxOHhNbElTSlo1anVUM25mdWN1dDgyZHlvWVJockh5aGxKT0lJOS9r?=
 =?utf-8?B?UGs2RUVhL0tZNTgraUpGL1ZJNmU3SUhTZUswckdGTDRCLzh1WDJyRzZnMUtR?=
 =?utf-8?B?Z3hoSHhkVk02Z0xRbUE2Y21iVEpOaTFUWGpOOURpOHVSSGhSLzhwcHRHNThw?=
 =?utf-8?B?UnVIQkczNU9MT1UxSWdHSTNqR0VjbUZLak8vUURIUi8rbW1LSUQvZ3JHNFpp?=
 =?utf-8?B?YS81UU5KeE9BbUNEZVlLK3NISjh3SWhsY1V3d3Vud1g1YnFSN2NZNk5EZjNj?=
 =?utf-8?B?VmpuRCtkRk1sMlFyb2tWWWhuQmF2cEdFWXg5dEE5NGNhS2NRVi91U1EvODAw?=
 =?utf-8?B?N09OZ0d6VXRnTDE4SDk3ZGorR1E3TXQrZlh1QVptU2N0Ymp0NGQrYjZGQVox?=
 =?utf-8?B?NXRZZzg3Z0JnTHErYnJUeCtNZFhiOUNNZ3BCOHhsYnNvaUZqUEc4R0FQczFv?=
 =?utf-8?B?b2NERnlRcDFWZncvK2wxRmF4N0pWNjB5UjFiVEVHTm15NVN6TFF3ZlQ2YUt4?=
 =?utf-8?B?dnVPR3BjdVZvS2lvaEYzVFpaaU9iZ0RxV0dWZERUNTJpbjI5S2c4cGxlMERW?=
 =?utf-8?B?RXVaMGhVaXRVd1hSN2U4V3hXUFMrRnRpb2E5M1FmalRpS0NadjU4K2p2b1FS?=
 =?utf-8?B?YXg1ZlBzS3JVaHBUYzNZcDVvODYyMVlOeTAzeWJMZ0RBcE5UcE5wWS9keEdo?=
 =?utf-8?Q?OeUjheFJS2RcTMQNxBteO8eEE8S4Mw=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2025 14:14:03.4000
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ecf6e05a-6fca-4ad3-c482-08dd356edd7c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE34.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6161

On Wed, 15 Jan 2025 11:34:56 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.10 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Jan 2025 10:34:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.12.10-rc1-gd056ad259f16
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
