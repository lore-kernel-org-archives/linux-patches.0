Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010027.outbound.protection.outlook.com [52.101.56.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AE92DB781
	for <patches@lists.linux.dev>; Mon,  9 Feb 2026 20:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770670548; cv=fail; b=ErBmb5/Kdqd1GdJ7TwWN26rZfrMuStv7dCgD9DIhnvYN7yTxFjGuphSXET6+4lT1F2muxP0/J15/2PypbgLYgXeccx1SVO1T7tCWQ42OzMZX9a+0XwEKdtAuAhvLqlFReANPXKQbWjw+e5zlJ55gJIDwwR/Yj7MFBNR430EMKts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770670548; c=relaxed/simple;
	bh=vIoVyGAkNmu2TvYZJ6oMoW3+3xzdE7oJppmD7ZHtQK8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=EsPXRNjGyaXsfxoX0eO8GzwRAqc8wime4NV/OBgxaUVtbIICSm9B88UQFPfklKXHtor+iSfASpSmNN7MQCScvTz06PBYOdiJ87d1/zFGVtyL3if5SWAs2mGE37wl/y5jhJdi31X26xdOlqkZfeNZIFhOi4MiWVbhGgUzenW1x4Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FBovB9au; arc=fail smtp.client-ip=52.101.56.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FBovB9au"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MZT2lmT6RSQB/PNghX/QZJC7WJu3u453iSX/l9h8UsoUWt22Qrz1QhSeFdHl+bjq6W4dlyjtL+qsJDV4P4+B7K19O5AQpWRXotlU9hRYpisOExrhjNL+zdMD0vi7tQe+RJWKrkjN+QkHjj6TVtm8snwUplLL091yNk+17Us1F0rhEmhVrIc8LAA43yu1KjCEdIriQBObCtIKCrLcg1xolXZQHIO7oXal3aVna1cMHzIIGXYAFGupDpGog4nuA5DcVb8bl0Po2iUsmmYOqlC0x3Ht8bAjNdeOYyykOVGCGrVEciglA8qtmbcNEfLxw2qQmpRGCa+/eCOArq1rAJ2yJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yDA6jgimbgSujwHs+a+/LrqOZxZgJwNlvUV4sJux86w=;
 b=vTIyd4E6KcWIDMhPXz2/37v9vv4BPGWhtypCAffEIXdVf0cD1Lhqw4j48FeHE9R+TDZoXKAIeTbczI5u+CyNQQr9MXAjajvCceJMSSQdTe4YDQF070S0AMolFzA9LV31SbhTumvVuC1mLQtz8lqEwqv9Wt87e38vnUyTiBYhhDUXKX9KvhRSVh+HlHhJUQFFTHj9lt/B7vu0/vLRIwnFrbmD0Dvn+gtdiF+YsPC7g3ZnuuaiUrG+2ShQ1FIHGlAGNh13nwG7kvE8kNCpMryFZGWsMAQjiVMZdsshgnOjicoiJnO50QsvhhIyJ5deblJh0EnE7ptroyDCq/QZPN5UUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yDA6jgimbgSujwHs+a+/LrqOZxZgJwNlvUV4sJux86w=;
 b=FBovB9auqI1w4XeSy9Zz+BqOLqBIhosRDXzQMv3fyJA1Qe2ato3nBhsGx2veKBj0W7UGzu03N+PEMlkYtMEEYHg7be0A0d5OA/cozUq8d82YPLvLESxm0447RfPTLrJbqD78RAl8MqA9LUsfXzt5qx+oHWlKF6D13cnboLGk5iGplFRYmTkkihHlYiOuwfM4eoIseW6Ctowr9AM+Q7aNmje6IvV0GVnFPWwXwgtBOUSpEAHtChDG3FWda+BGstKCp3wB7nMczbwROKGND715uxTY8Npq18bQrisbLXJzc0bjrG4+QTAJB4BAqXe3B7oUrQzgXK8zSm56uKXRDMgyjg==
Received: from SJ0PR13CA0081.namprd13.prod.outlook.com (2603:10b6:a03:2c4::26)
 by BN7PPF48E601ED5.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6ce) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Mon, 9 Feb
 2026 20:55:38 +0000
Received: from MWH0EPF000A6734.namprd04.prod.outlook.com
 (2603:10b6:a03:2c4:cafe::cc) by SJ0PR13CA0081.outlook.office365.com
 (2603:10b6:a03:2c4::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.7 via Frontend Transport; Mon, 9
 Feb 2026 20:55:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MWH0EPF000A6734.mail.protection.outlook.com (10.167.249.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Mon, 9 Feb 2026 20:55:37 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 9 Feb
 2026 12:55:10 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 9 Feb
 2026 12:55:10 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 9 Feb 2026 12:55:10 -0800
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
Subject: Re: [PATCH 5.10 00/41] 5.10.250-rc1 review
In-Reply-To: <20260209142256.797267956@linuxfoundation.org>
References: <20260209142256.797267956@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <bfbe4cdf-3618-4aa4-9594-29ef3d5f183f@rnnvmail203.nvidia.com>
Date: Mon, 9 Feb 2026 12:55:10 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6734:EE_|BN7PPF48E601ED5:EE_
X-MS-Office365-Filtering-Correlation-Id: 322af3d4-1ccc-4eee-6765-08de681d93f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bkZ5UDdJeGNpK1dKZGdpTGg3RTkvRHVvYVNWUUFSRGJMdVRVK0M4YXZ4Wm13?=
 =?utf-8?B?U25ENUhrSDdXMUR2ZVBSVzlvbE5sTEl2amptZUovRDN2MnYwNWFCOE9GdG5I?=
 =?utf-8?B?dkQweUhmbWpSNHVYdWxEQklyZE9YQ2VWeTA0anhuUzdSZkZrdjdtQW5XMXVG?=
 =?utf-8?B?TE1yY01uY2RWQ3UzbSthMVVqY2VQV1ZxYnhQTEJsVCsxN2JoL0RLSWQ4eFV6?=
 =?utf-8?B?WjNaYVFsckVYRVRDM1JOdG5DSTJsVFRYN3RTbmdETTRsbnhTWUdHN2tLR3pY?=
 =?utf-8?B?cXJXVkZIRjJSZlE0MUdQZ0hTQW84N2I1U1RmZTFkRTlnQzJiMjRrbjFGUHJa?=
 =?utf-8?B?VkJxblFqTm5FNG9vYU9tQm84QU1PVS9GUUtBVk1KN2cvMXFUQTluYnoxRFRq?=
 =?utf-8?B?MDUwNzh2MnkrZ0hNRElzT1U5ZmFqcEZKK29oTC9jOXk1cW5mVUtFUzlOSXpV?=
 =?utf-8?B?Qyt4VWNXU2FFQlo0UVJvQnNGSHorMlZ4TEZFa28zZXFWQ05YSFAxQ1ZCc3VV?=
 =?utf-8?B?eWN3dWk5dTJWK2s1NEo1TGh4enJrLzc4NERvRURBRjdDam5XQXc4OFlDbnpC?=
 =?utf-8?B?OURIVFhQcGVuU0g5YUdDdE9HRFpPNW1CMzlqMnBJV2daZlRiWXIvMGVyV3Vx?=
 =?utf-8?B?TVFDQ2VwbTdRVDVGcGJybzV5ZzMyb0dTT0s0NmVoSGJNLy9EN2lqc3R6cDEr?=
 =?utf-8?B?L3JadElaZTJ1SnJiZjJ3OUVDVjVVdDAzbkVVQzBya3h4MUVqT29TbjU3MnVz?=
 =?utf-8?B?MWgxVXp5S1NHQm9qUnpyT1FWZEtYMVNVNHNkVDJnWktrTGZHd0J4SHlRNVVL?=
 =?utf-8?B?RWd5UkF2ckVqNkZjL0pGRVMyS3dvYjdjNGMzUHQxWlcyWG1OQ3djZThXdENH?=
 =?utf-8?B?R1ZQdGVRM1A1eGlIbEJ5K2lyd0x2ZHB4SHBXVTVGQkFkajlDazVsbUJhNXVK?=
 =?utf-8?B?RVpiaUU3WS9DMmsrZmhtZkw2cEwxakEzaDBON3dNaSs1Nk9ldm5xK0JzT1A5?=
 =?utf-8?B?bnJKdHdML0hzUVFtQkJUaGU3VU5CMHJNT2lPN0g4cGE0b1FCY1hDNVJyekhE?=
 =?utf-8?B?S1ZMNGg5Z0xJMmR3M0dxb2p2OHJjTlZjVytmZmZ5MW1XYnFlNGlyeHBhQ2ZW?=
 =?utf-8?B?MFJxMXVYUllhUkNUR1VzdmEwRXY0cnJFNEs2bkl3RkFIYWh4dWpPYUFzTm02?=
 =?utf-8?B?TGxxc2FNU0E5V0syV2k3ZFhkalRsOTBXMjRwVlpidVhIcmNsU1ZoSk96MGtm?=
 =?utf-8?B?MlVKLzFGcTRHWU91ZEtaTlJvclYwSU9nSitickh3eWhnMVlCRXN5QVJiNC9Y?=
 =?utf-8?B?bFJqSEQ2c0I2MTBLcHl4WkRKZHlmUVRWd3pSL3ZlLzlSbnJscjNha2NzeFk5?=
 =?utf-8?B?dUFMMUR3UXJsZzBFbDBCNGFWbnlWeFdraTlhT2pZRmFHQWpjRUdEMmM5cUFU?=
 =?utf-8?B?Z1BtbWRtbGVJaHQraExIM2ZyYXpsVWVpNkdnUDBMU20yVFpYbjZEZmpRdy8r?=
 =?utf-8?B?ekNkOTRBTTl0OHdTN0FPRWVjbysrZjlxQ3BLWXQrVWxqR0lnTTdrcEloUGk4?=
 =?utf-8?B?UkE0UGRLOEdmNkZZTkwvMkdzd0xyNTFkN1BQOE4rQ3dnaVdWVEF2TzluY05S?=
 =?utf-8?B?cTlsbm8zSFhmN1lpeVVsTWpITEhFTkEwcFNzQlZuVE9ZemVQQU5VZU9mUjQ2?=
 =?utf-8?B?Z0ovanVTVGtRTFM4MUNORVNVL0JuSDBvb1pkTGR2VDZzejBuK2hleEEzSzM1?=
 =?utf-8?B?UWtKbURkbFVPL2I3MEVKQ0hxdDUvUVg1NTdUeGxXK2l3MmVWT3IzVThGWXU0?=
 =?utf-8?B?YllvSlpuZkFLTlZvdGNjWUZ1QmZ1ZmtkdWNmcndITEg5S1J3MkdoMjNUMmJD?=
 =?utf-8?B?enJ6L2t1WUNickVZaWI0TnRJQmx0SkVpZjMxVFY1K0RoZVFQbmtjK1dhMU1y?=
 =?utf-8?B?Zk4zQkpKUFVzM1llRHcvN3V4VS9nYWdQdDNZcjJvWWJPdGlmcEIxOExnM3cy?=
 =?utf-8?B?bHR4SUVBdjBrQnBHWlRxaHp6eG83U0VieTlhc0JkK2dSYkhwSlFqYnUrWVFL?=
 =?utf-8?B?WHpmRTlUb3Y0TWxMd0VhdVlHOWNjUHB6ZTFUUCs5dTE1bThMZm9jS1Q1VDRn?=
 =?utf-8?B?b0Jsb2FYUWhzRGNzUlpIOE1TclFZaEE5aWdxM0lxVVhZL0MwUkFqeUFXWDFV?=
 =?utf-8?B?S25MWXI3UE1qSk1CaUY2NVRUQjZibXNFK05KYW9pZjlLbi80ejdPTXRtVHEr?=
 =?utf-8?B?dTJCeVUrN0lqQjQyaTdJWEdyZGhRPT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QFkk42hn+mNqMI00oZZXI5SCP6jZYjXyaphNMTH3xMPUOhJtlD6aVZ+sXKBrseX34dt5S7yqrQo+gGA6PmH6/6PaWBMz7h1ggy7pL3DvDz9QeMZd5cKK+cI+0utEPB+2OXX1s6rylHZcHTKel2gFM0Cm6+JoVa0PpZG+WeMffjpaa851Se+kMk9C+kiXG5Cz1wnd0oWyCFkBq0SDCqjsfwNzC61X/5EFjiU6hJllr5F2Yi1u1ATK5sT1j4b8Fbr2RTEMqGN9WiVGtF5DN8GgNZO4eV+2tzdnqJfiYGw7xqv07LHbuIjs0bfiePNJPUrLgppjZG2wxRwS8A67SaTrcSNj75qq0y4Hp3LoG2lY19WOVAWyTkjUCq/UCJD7yXAck6GjFhYimg0y/6Ss4ntB1lRvrRxP2NIUAj37m1KV+5LQaJL+XpAQ0J3k5ZbGwV92
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 20:55:37.2681
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 322af3d4-1ccc-4eee-6765-08de681d93f6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6734.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF48E601ED5

On Mon, 09 Feb 2026 15:24:21 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.250 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.250-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    80 tests:	80 pass, 0 fail

Linux version:	5.10.250-rc1-g58ef7f63a0dc
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
