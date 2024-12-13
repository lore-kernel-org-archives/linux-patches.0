Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2046.outbound.protection.outlook.com [40.107.101.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0797A1ADFF1
	for <patches@lists.linux.dev>; Fri, 13 Dec 2024 10:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734084200; cv=fail; b=e0bgoHioUF4euP8sPGWlOgyfR3WPK9cM5KkxLLMH6m9lmvBUtMGQw/OPb1Gg82qKOcEKXrynPk4/2bieBA3KBvQRA/Ju0xid8x+zD3qWS7cELCcD6NRX8oO65Sh8PTzzp0+9FI0+QdHWyrxku+lgzbI2iCfgSh0CtV5RsXui+z0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734084200; c=relaxed/simple;
	bh=xdUGrN+cBnQXRuCPazP9bc0LTVfIAsNq9wOS4D+x3Wo=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=AjKDUbOhjWM6aIq7VJHOQorzDV6oK7GjxpipmylnDm1RZx8boTdHpBs4RxkCLgzsAOkWztF02gWEPt6us45bRzW9p9StcDi3gDfIc0eDgtkV1lsyMQlvz65i4qCDi8Y67W4ijDf+zepRB47k/kpxv/4ZxWT6SMc4sRIV67lBDtc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=R5we/LiM; arc=fail smtp.client-ip=40.107.101.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="R5we/LiM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gu6PJNispAkIeDEwKe6QAtOPq/ufVFcP50SCJ6j822htgcW0+oeOKrB1cC8saoQYZB2Xg8myri+REHJZ+efRdtbHqXhkfcEw1cXhIpIOeUh9T4GfysmRp4/qCq1tWxp17m2WIRZqh/kktfzLzL2DM4qDxUdC+dib+hbkAlVlBuB2tskg9ts3FoTjLPidZetZE1uYqdQrBiTWSqoqbiQymQDckG6N3HnZZaGwVikzpl2e+WnxIVdTAFhj0fSMq4nGwN3rR531HpynGga5jD3qc3tc2V+NEBkEv4BmFREqsd3XkHtwBczdutab/T3khT3DnXReBtW/ScLVEGvJ+yF3EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=26486I7T1E7qCFE0TsXk8wb+dZWnEgf9EmzQYnrnRiQ=;
 b=htWZRa+TLW/c8w7RH56Skb3hmaXs/LjJu6nbQ0gYZT5CAdSVCSxJXtnkdphsfg+3k+4xse1lCFErM3Fy/l5Ke4m073aymUUwJKMSfBmmJhj2I55vJ7Bon52KEu8AASIRzdZ7Z1O5ANd73p384PeG+KCeGQxtl/27TDjNPE1kMI0I8pHyFxt/2QCRTV7AL6IELFqRk/J9v9BjkNW3+Y/nK8HHGS+rlXouIqfgrPGRpbeke7Y9zps1TfhN9/0XidguCt4hlZdd8fQa3cAZSoXMWgpMzLdXmU7/RUwjWombjtUVyWaorPX9wtA8KFWafsstV2bJMVcfU0D6I4FG7iHCoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=26486I7T1E7qCFE0TsXk8wb+dZWnEgf9EmzQYnrnRiQ=;
 b=R5we/LiMlAtY8EXmiM323UEH6QaKuGRiYYy/yc/O1EeLNhib7/YuHS3oHkq1K5R5IdmRFWh07ypg8mZgElkcDYMNNKuC5GGtyTTmfC8fJMtFnYS4zQ7WxspheW3a7YE++rRfbwcPVsZ5FU0w0LAdRBqmwFBrn/qpHKkIbvkjhhkmSsndKAD1ptsYXCeE3kOnZOLbq7TYy6PIEXhgTfpW9vZYuuATSO9yMA++VddujFMJAC44PErqkME53xfkBS3d3iT8lgWGpxEsgofhTDmQ5MU1H3jnKcUE9STxhBv7K6lYtr75G+82V25Mf7FQk6XXicZ7+YLCYGTgNDLlKfwPjw==
Received: from MW2PR16CA0014.namprd16.prod.outlook.com (2603:10b6:907::27) by
 DS7PR12MB6021.namprd12.prod.outlook.com (2603:10b6:8:87::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8251.16; Fri, 13 Dec 2024 10:03:14 +0000
Received: from MWH0EPF000A672F.namprd04.prod.outlook.com
 (2603:10b6:907:0:cafe::c) by MW2PR16CA0014.outlook.office365.com
 (2603:10b6:907::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.16 via Frontend Transport; Fri,
 13 Dec 2024 10:03:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MWH0EPF000A672F.mail.protection.outlook.com (10.167.249.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8251.15 via Frontend Transport; Fri, 13 Dec 2024 10:03:13 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 13 Dec
 2024 02:03:08 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 13 Dec 2024 02:03:08 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 13 Dec 2024 02:03:08 -0800
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
Subject: Re: [PATCH 5.10 000/459] 5.10.231-rc1 review
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <d3e4a2ac-4ec8-4b1c-9d97-51862cea9c4d@drhqmail202.nvidia.com>
Date: Fri, 13 Dec 2024 02:03:08 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672F:EE_|DS7PR12MB6021:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e25ffe5-c0ea-4f4d-84a9-08dd1b5d5b8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NVArQXJHVHpmeS8vRi9RdjFJMERHTHBNVllhZjBJRVlyWlNqY3lTNmF6czdi?=
 =?utf-8?B?U3NkUTdNOURkTVZQWEgxUGUvb0l0TGUvVFU5K1BVOURiM05Cb3NWRlpuTWtw?=
 =?utf-8?B?SEpkTkhEcGhVaWt2elB1aWQyMFJ1YUhBbUpRZ0l0bkRibnZKeHM5RG1rbTZY?=
 =?utf-8?B?Nzd5LzJjOUQzWnlGbDFvVE43QVYzZlRzWGVrY0xNY1hxNktRK240S0dZNzd5?=
 =?utf-8?B?WXBydVZySGxRUHI5WDA4dDV0MVhkS2x2WHU0MVNmazZ1TmtLaUZlT2N2TCsz?=
 =?utf-8?B?OXIzcG1Gak5zcWdHdVI1UHh1RUdsVlNqZFBGS3Z0eDZjUVREVUk2TVJkblZw?=
 =?utf-8?B?M2prM2UrbW1oYmdXNUpBSTNPTjlVeVRPdUU5OGxNNHdwOVNXT1NqSlE0Mlpx?=
 =?utf-8?B?YUNIQU5tYkhSWnRnRmMyd2lOZlBjNGcvNjlLSnkydEt2RC9QUlY0NUVBSXBn?=
 =?utf-8?B?Rm9Ja0orTmtaSytoL1MyNDlqM0JhcXo1dWttNkdhRFZyNStoTm5PU1pna20z?=
 =?utf-8?B?RzRqd1hublZFc2NMWlozdDZzK085bzY0QllLLzVvNjZKdDNJVXhWRkxhcEF0?=
 =?utf-8?B?UlNTOHgwejY3SGUwWGRqUWhxR0pjbzJQOTVEaHNGSG1tSGhnejhTVlZPb1RQ?=
 =?utf-8?B?SHE2VmxKcUViMnlXQ3RSVmptMTNuSWF5QTdXT3R6bWVEbTVTMURIVkhqY3p5?=
 =?utf-8?B?TXMwZUo3UHUvMzZsWFVJNkxoV2ZnUThWcXFzQm9VVE91c3VnYmtXSm1SVGZN?=
 =?utf-8?B?Tzg4Zlp3TEkreTF4RkFDUk1pbGYxQXdiSnZUL05XV2J0YXRwWUtIcGFEQi9L?=
 =?utf-8?B?YzdBd0R1czljNk9ZMFRTcWlsS3lDdlEyUEJZd2JoaTZwV291cHFnbnoxYVRN?=
 =?utf-8?B?VERsZ1F2dlVSdkZUNGkzV0hmNG4xNEtQSnhzc2FhR0JGM1NNR1k0SnhmdThk?=
 =?utf-8?B?ZnpQOWV0b0N5bmVQTytxb2dMUk1XeklibFJ1MWRjNGg5V2NYSjcwa2pVdlJ5?=
 =?utf-8?B?UjhYbUZFemYyT3ZUc21oK2RNRmhJVnFBWGJoZnZtRVJ0Qys3SWd4TS9FWFkz?=
 =?utf-8?B?ZFMrWEM5VUsrdlVocXpqalNlbit3YjlRM01QS095RTE5SzQzOFk3ODNKd0Rz?=
 =?utf-8?B?TEVFVEplblI2RSs0TXMvSU5VMFk1ajhjQlJzM2lVYjlvL3FYUHVOZ0FGWXBo?=
 =?utf-8?B?emJiNTZORmxLM2JNTk05NytySWNYdG4wcEJpUEQ2WnRINDROSUVWOTIwSXBL?=
 =?utf-8?B?VEtjVUZmZGUxWGhFMkkweXdEWFFnZFdnRXVWRTV1eTdCcFdzY3Fkd3BYSUNt?=
 =?utf-8?B?ZldVcUpPZGE4NndPZGtnSWt5MWxvaW1KaFZ6WU02SjZsQmdTQUVSK01EbE5j?=
 =?utf-8?B?cXZlTlJzcklCdjBCZkhlSWZ4Qm14VUlKc28vcmd5UUYzRGJVUGVDWldtc1hp?=
 =?utf-8?B?U2o5OVZONHAwUUltWWV4eHJpMGFCbllpOWJYWk9qSG5jelF1eHkreEdsL2Zr?=
 =?utf-8?B?alpjczJ3anVkRDBMQmExL3BCOTk0L1E2YzcxcW5TR3htSWFBR0labHhrek5F?=
 =?utf-8?B?VkVNeDcrRTlYZEJXSnpNUWlucHRLdTBSandBRUl3QWZ4RWZ6SEduV0loeWRQ?=
 =?utf-8?B?bVo2WDlMREE3WWlrY0d6eHhiYks0MlN2ODVNTmVBMnNtZFdKTDZHY1pHZms0?=
 =?utf-8?B?QTBFa0Uydmx0SXdyY0hXL1pSQVJYdnFFczlIUmVhNXlCMkFRNW1wUURpeCtq?=
 =?utf-8?B?c1o1TVNvL0VMOGFQUU14TDhhU2c0Ry9FSU9yOEtSdVBBa3ArK0N0OERHVVlO?=
 =?utf-8?B?d1ErZXBkaFQvOVhxMzhkdTNmdXB1SDYwdDFYc0pYbEhLMUJCblpnd2F3N1Ix?=
 =?utf-8?B?bGVjUmROQ2FjTnp1dmJNVE1kTkdrSSttaHNnbWp6NFdQVG8wVGZpZUloOThW?=
 =?utf-8?Q?9DDTgDXwe1rJwKRbRchEjz1/KA4q0Coo?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2024 10:03:13.7516
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e25ffe5-c0ea-4f4d-84a9-08dd1b5d5b8e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6021

On Thu, 12 Dec 2024 15:55:38 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.231 release.
> There are 459 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.231-rc1.gz
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

Linux version:	5.10.231-rc1-g2146a7485c27
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
