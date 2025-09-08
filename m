Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C0830ACE8
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 15:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757343746; cv=fail; b=SBgEP+lyQSOFvACAy7kgJKPViQFEvio3UVi4YvmGAKtTWD6A09TxUzhCL3LXw+d7Akjlh+kebfGL8/B5ux5dOLs42HRFoRTgGoC2tPDHzyugFokLNs/MfVa9yHMYgKP2rGNXFLEfV6oP4gblW804nu+EGV5PCS+ssLEOmPszXDI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757343746; c=relaxed/simple;
	bh=Uep/jgae6aJeVG7cqrQ/GSV9bt2DlbSIfMPr3WnZlVA=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=pvFCJ0F7GiX4dvTPKOmEam6n4Ew98Xz3bPUjgtLECyVyz57hImTGucWAIIUe8saprvIE4kUyT6uYSb5EL0ULpe327ufSFDqQLpiufdoQ8Y+mdhbrEcrSQPaIT0BD0SzyR136IQ+BmKsMYrXao0oLc7U5slk61gk9LHi3mIzMddY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ac76df4m; arc=fail smtp.client-ip=40.107.223.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ac76df4m"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=btzaA8vb9UUPxNsSE/oFn43MARYj8EtdsrzFc8QbzcF8eIOGer7vzdDywv9lAaaO+fOQ2S+g9Vj0iyFsFx+Nqik4h6Is+jGtAeBzAv2RYzSLT/lu+ZT7Wp0j53vFsfxOdQ4YSrQjX3kaMJx7yIGHsSRGPRS/bgErvQeqFVRn3mIRB5EUiirkxx0we1i1nR9kxxgAJLVX3KfamyS5Te6tTnO6APpGdAxZ5JmKy8tgk1+n80AdFKt8MplBxR4JlfyCzInY1QpbyP5rYn1G2dsUp1e5VXXtvdQ/Pc0YhXDsmOQoAblW7CaWzRe2ciEW28meW+ZBImdi+QPzgHvBKW7Edw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ahb1RzxS/B6yT6lP5SZSSXjuF6QoTQxOsPAWim3SqpU=;
 b=xdsVOIp1gapMOVGCzekFNarMJ8UBoCm9aNK5zM9Xt8QAKYXNdIYyiLSo64nBs0wvhbrdh/ksAUf9od6lT8B0iRWHpfosGUkMNwYcVdpvwwwiuxFo+ZIELrwqNZbRVLDb3IF+x2+ZYXrZ0Q1ImoT/L6Fwd/I5CJToPo8kOtFmkkGx7m46ndR8BFweIb3jeJqSU1Hp4m0508Fr8P2TEO6CJwrbNwnv9mBUFDqhLhUWIqDh3PxRACjWBebHBoORM7j66J3hOaNQ21H1L58VSJlLQJrgJCrGA60BD08qLxKgJB1aJfLHq6XGVTERdcRytvFSprL7yiy5xfffBWf7UvcXgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ahb1RzxS/B6yT6lP5SZSSXjuF6QoTQxOsPAWim3SqpU=;
 b=Ac76df4maBFLEG40bdkkfY1cd6aL0kdi4uijkm3EWKCPsBwNjm9QeRWjtYq2GZPTItfc/CUNvv5qvSYkcXXn0Eq5DPhh4FpA4yLzEOd/CkjTE/jtxrKyX28N6kZkLKRavaZCoVPn4yGbeAsBPKrCF/zrCKxMdQFIMmspdtMEUVqMp6YQ5K5SJ+DXn5KC8balzqP419nBIt43k+w/QNHS1SfzRrXikaPVGAraIs300+Mtg7aUQNYSmqtBgbX9iygHqe3zKELzjpK2++D3dWuokNEYyt7IgzP+eubJeSZ7kIRMhZqOkkPxadPgLEosNKeXxcxcMrpdGjLu5stYoD50gA==
Received: from SN6PR16CA0057.namprd16.prod.outlook.com (2603:10b6:805:ca::34)
 by SA5PPFB2BF91BC0.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8de) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Mon, 8 Sep
 2025 15:02:11 +0000
Received: from SN1PEPF00036F3D.namprd05.prod.outlook.com
 (2603:10b6:805:ca:cafe::9) by SN6PR16CA0057.outlook.office365.com
 (2603:10b6:805:ca::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.22 via Frontend Transport; Mon,
 8 Sep 2025 15:02:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF00036F3D.mail.protection.outlook.com (10.167.248.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 8 Sep 2025 15:02:10 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 8 Sep
 2025 08:01:38 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 8 Sep
 2025 08:01:37 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Mon, 8 Sep 2025 08:01:36 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 5.15 00/64] 5.15.192-rc1 review
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
References: <20250907195603.394640159@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <a14b588c-6fe4-448e-81c2-71ae7623aaf4@rnnvmail205.nvidia.com>
Date: Mon, 8 Sep 2025 08:01:36 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3D:EE_|SA5PPFB2BF91BC0:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b642573-8dbf-425c-27b4-08ddeee8b064
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bFVyT1E0dXZlaVZneVJjYnNlL1c0NnJsRnJQQmE2T0tPalIwejMxVjNlbzNG?=
 =?utf-8?B?QTNLNkRnUWsxUmEwd1Z3ZmxqOUZhS1FvM2pLbDVTdUVJelovakY5WGorWmVR?=
 =?utf-8?B?T0dXY21vYThaRGU1Y2VKb3U0N0hwa3lHWTR6L093LzBwTTljbmVnMXBwN3VE?=
 =?utf-8?B?VXpjaDJiejl6aFRFRXpXSGNOMEcweXFiWE4zMFlJNGhqNUN1R2xralpSeDZq?=
 =?utf-8?B?OG1zRVZkNnliaW9GRDB5Zk1OTlNxN05RRDRPUEVKT3pyVk9CdWYzcXlxS2Qy?=
 =?utf-8?B?ZEIrYkFocFQ2VlNTSXlhakkwbVFMc05nZDlKeXBreXFCdTExTWdUQ1FoNnY3?=
 =?utf-8?B?NG9pQ3JMUkk1aGo1eDZlWnlaL2cxTEs4U1ZUZERjQlhDR1lBSlRpYVZNekJr?=
 =?utf-8?B?bnlnOXlCaTlmNUJ2MEtSdVl3Qmp1RFdTT3pwWHpxVTZxV1FRbWFIY0ZFU2Ru?=
 =?utf-8?B?VHpiTy9nTlczN0dncm9pcHdxUGV4R0hxaXZqR0REcTJCdXZwaGU4QXQzYTRq?=
 =?utf-8?B?a2o3c3VyUnlPZnl1NFovT0tsaWxKOGY4YmJ1bitMTUpRYmhzNlNlek53aUJD?=
 =?utf-8?B?N2g4QlAySnFmZnpselk4VU5uZkVpOCtCSHhNRzgyTWFER3REWkx4TEJxN2pI?=
 =?utf-8?B?dUswcHdLMUQ5TTJRcEVLdmRUL29qVUtmNGJ4L2xPcVEwUk1PVlFSeFZ4RDlw?=
 =?utf-8?B?cVVaeENCZkcvaGpsRVVwNnVwdWZNVVppUjRzL2xmVFVPN1Vsb3Y4MlJDQVFz?=
 =?utf-8?B?YXBvZk9kVmdLUHFseFJWTFpRQ3E3eVpsSjZFeXFXQUllWXQrallPdHpqMGt3?=
 =?utf-8?B?TU9WMWNwdWJEdjMwcEpBSFhqanptWDVqaEY4MmVGWFVPSi9hMTY3SWFsdnZt?=
 =?utf-8?B?VCsvWC9XeXBLNUk3Y040YWNOODFqU1pKUHR5aXpWOVJBZTZRaHRvQnJIbkRj?=
 =?utf-8?B?Rm5qRTZsbjdZVlQ0M0ovSDlmRzBrSHcxS2hsU1FRWDdzVGlOd0k1RjBYK0E3?=
 =?utf-8?B?RTFWYXl0eUN6ZVJiUjhpVU9FS0p3cmU3RmxPRnBISm5DcDY2ek85dXNSRmhE?=
 =?utf-8?B?YVFlNXZLekVCcUVOMFhKWXZzT2JjdmxFbEI1RGhGK1RsMUVwTlJDalloc3Nk?=
 =?utf-8?B?ajZvVS9MTmMvVnVZb1MyZzZiMmlITmd0bkswYStYVmFzd0hOVXhmQmx3Z29L?=
 =?utf-8?B?YWZoZzBLdFc0c2FzakdWVSt5NXlhTElwelpSZmNtbEdLZHpRY0Z2UFZPMU9z?=
 =?utf-8?B?NlNiRXp4dW1vSVUyYkhsUUtjSTdySGZ2cEduWEY3QmFBOG5lV0ZmSGNERHZQ?=
 =?utf-8?B?RzlLU1RTUjFzWlFhUW1HU1MxOXJ4UFdlQ092UnhXY2JrYWlXeS8rSG90OUJD?=
 =?utf-8?B?Vno3R05uOHM0Mk4rVG1WS08reURUQTkza3Y4YWlqNUpaWVkwRmd0T2EzTTgx?=
 =?utf-8?B?aVNYTGZEWUZFb0dtdUVmRmRXWEZYY0YrdkFGMm9SVUx5Z25uUkZlRk5JVWt2?=
 =?utf-8?B?ZEZFR0laeWFrbmFWMktSSVd1dm5iUmhUdlhRaXJncWtiSXM2Z2ZIelAvbk1s?=
 =?utf-8?B?NUc5ZUxkMjJTaDhJZXNQb0N1aXpuZHpENVVXUWVSZUl6K04xbTVKTzU5c3ZK?=
 =?utf-8?B?OE10aDJqdFRCUkdDSy8rS1FtZ0xOSjZNTmdDZGRTbGV2WnB4R1h4Qml6cVph?=
 =?utf-8?B?SThOREZIeG5XSnBSWkluWWJQdkFNdyttRHVZT3NKZ1NNZXA5K0pkcUp4RWJ0?=
 =?utf-8?B?c25MQjZjc2xVSG53SkVWR0VjZXpqMEYrZzVEZmMzdlFRTVRZLzhTU3BkRlo5?=
 =?utf-8?B?KzdHSWJhbTQ2eUtLUWs2ZkFtYU9Bc1hkbW9IZndaTHU5R291d0J1STlQTEdX?=
 =?utf-8?B?ZmFXR2JOSjNXMW5PemZ2My8wdkR6NFRneDlkQ3RjMWdSWWFiU25jano4d3hB?=
 =?utf-8?B?N3EvRkZPMzV4cXhHNlVIUTRVSHEwbUV2TDZIYmlMalhiZ3dmQ003bmxJbUJ2?=
 =?utf-8?B?OVFDQjdudnJqV1g4azZxWkNxYmFxZVhkaXdjbWZ6UDh6L3VlOEpHOHNWdGNE?=
 =?utf-8?B?N21CL0t0Q1lhYnI2MzN5aGtIdmQwbEtlQVVDZz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 15:02:10.5064
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b642573-8dbf-425c-27b4-08ddeee8b064
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPFB2BF91BC0

On Sun, 07 Sep 2025 21:57:42 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.192 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.192-rc1.gz
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

Linux version:	5.15.192-rc1-gccdfe77d4229
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
