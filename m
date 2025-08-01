Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAE323C51B
	for <patches@lists.linux.dev>; Fri,  1 Aug 2025 12:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754051222; cv=fail; b=B+mlYMu3evHO4Q4+8Ye1stcVGjetAoWW0X7mOa+GDrs+HZZQRn31dQhvjjGshTbzDLJKzlje1URywsyakrZxzVrYruKuCFQnZAQjjQlctNIOSBuWNDS3bhe/MPebjH1EqqKWs54evsIOXXJZd4mguy1MaMzoXqRNR5gLa5K1gbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754051222; c=relaxed/simple;
	bh=cZ5s2OXQ5oLqXxuq32kEJjhvIJ9Yee285uqHylnjUis=;
	h=From:To:CC:Date:Message-ID:MIME-Version:Content-Type:Subject; b=n0J6+yWyXq87G5jpd3m1klxbU5JgfQf07T0EaOTUPPsHRwgJ0mZdtbpwg9DFh1xaz8F+HAhugKjHKZV7i0JogX64fqR6t6d+tkNjgl0nDIfRboS/F7JBd6DsM0tim/Pzmini3jHQBImOV1+pMGT43PH2Wb+H10ID66cc9RgYBpw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rxVv5jfo; arc=fail smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rxVv5jfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55E4C4CEE7
	for <patches@lists.linux.dev>; Fri,  1 Aug 2025 12:26:59 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rxVv5jfo"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Fri, 1 Aug 2025 13:26:57 +0100
Resent-Message-ID: <aIyykd8z4t3wVj_h@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Fri, 01 Aug 2025 07:22:23 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=6/iz=2N=amd.com=venkataprasad.potturu@kernel.org>)
	id 1uhj9o-00Ciz5-UA
	for broonie@sirena.co.uk; Fri, 01 Aug 2025 07:22:23 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 651FB5C6397
	for <broonie@sirena.co.uk>; Fri,  1 Aug 2025 06:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 26DBFC4CEEB; Fri,  1 Aug 2025 06:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 05AC9C4CEE7
	for <broonie@kernel.org>; Fri,  1 Aug 2025 06:22:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 05AC9C4CEE7
Authentication-Results: smtp.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QodQ71D++3erYfSGbCtQruFLlfQ6Kzb+T7iZJWpVFd7+68OE8uSp4dCoBtt7l42ZmSUlJM5oBPfQttgCxNwgRrqNDJhWttRjPCJMb1GA8+g1fyG2QQXESu3/KdGzLf4ZmlW3yzJig5tdR+HIXploIW/FnMrOY77L0R8IQzdgPVCiCc9rGEoiujIkBLVq9LsbokcaCYLwL/W5K/bErxjY6czo3PRQlwLpI1R9i3H3Oj07EIz0K8x3go9yCVv8ND3lTXwcfd/H/ed2VWYj5DsRmRb/OkB+MbVulan9CzyHxjgVWkvN24eM6MR5mm7m23QyblqI67F96z/gaST87CQNeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NtEocplxdMpGAAVO37DqoI3MFwhzQbyw73a3a5LmC3c=;
 b=mPv8bzkxy5UNDGsW6cQAZ9JRdZNWrNFreKedRfVS5Dbu570+Rug9iisxPNOAaWBtk04XP1/a7hfgjv51ZPTZKVY2uL3lPCTl2r0SNiih6aNqs3RIv1SBlm9ylUpKV+ibJmeF+2fCpVEvtveMJYQ+T/6RqGo7RvN0pvFRA4tYTqBtyP2SOrwslQQe55LxryrSLt/ElV5tiqp+KGTVHb34mywrQJkXffPRRteVUi29JXhooEutG/pXlPFzAyMz4h5zfaX7H3oBPerirC1C6X7b3356blx+vAH5yFHpaYx5pNyNdQ1etDY+7kOIlvvlGB0kIu0zrKVo5xtZz3mrEVeGtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NtEocplxdMpGAAVO37DqoI3MFwhzQbyw73a3a5LmC3c=;
 b=rxVv5jfon0y+qkrfmck5Yl+0kLxFcbZmWCmKJ8YXcFqmRj7szjvxM//qA5M3/LzBYtYpaAsv1yMhAOvs78geoW1p4FWdPCBXzKgu5UCmHJDFHI95Q9JdTziWf6PJOp5sR6qEz//ujK9lwWfXRv2E71D52YdZJk9Hm2ytJp7VIF8=
Received: from DS7PR05CA0046.namprd05.prod.outlook.com (2603:10b6:8:2f::14) by
 PH0PR12MB7469.namprd12.prod.outlook.com (2603:10b6:510:1e9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.16; Fri, 1 Aug
 2025 06:22:11 +0000
Received: from DS2PEPF00003448.namprd04.prod.outlook.com
 (2603:10b6:8:2f:cafe::e7) by DS7PR05CA0046.outlook.office365.com
 (2603:10b6:8:2f::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.5 via Frontend Transport; Fri, 1
 Aug 2025 06:22:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003448.mail.protection.outlook.com (10.167.17.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9009.8 via Frontend Transport; Fri, 1 Aug 2025 06:22:11 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 1 Aug
 2025 01:22:10 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 1 Aug
 2025 01:22:10 -0500
Received: from r9-mach.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Fri, 1 Aug 2025 01:22:07 -0500
From: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
To: <broonie@kernel.org>, <alsa-devel@alsa-project.org>
CC: <Vijendar.Mukunda@amd.com>, <Basavaraj.Hiregoudar@amd.com>,
	<Sunil-kumar.Dommati@amd.com>, <syed.sabakareem@amd.com>, "Venkata Prasad
 Potturu" <venkataprasad.potturu@amd.com>
Date: Fri, 1 Aug 2025 11:51:34 +0530
Message-ID: <20250801062207.579388-1-venkataprasad.potturu@amd.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB05.amd.com: venkataprasad.potturu@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003448:EE_|PH0PR12MB7469:EE_
X-MS-Office365-Filtering-Correlation-Id: e834b1a0-aad8-4284-7018-08ddd0c3bfe0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xQEbVW6QkId04ogWV1j6Pu7acYfhAPQ+FeBD9f7YDAzASlOUKojHEAKmcAQD?=
 =?us-ascii?Q?KsCxi/jU64V213O7vpmB+D2YvqL1VbO3BgrenaYx4stgcnW+vuHMnXlFyhdf?=
 =?us-ascii?Q?3JRbFAdJmhBGkSZ96BxX6/jqpGe0aL9YEiG7qEVRHrtDJbkay4wFmA2usfRY?=
 =?us-ascii?Q?fpOaYd66imaeWWloWu1WqrDhRMQ260fXuPJkq6EdsjBrQYY7TRe3exTq1zsE?=
 =?us-ascii?Q?zTTOlsEiyoXJdxUMQmWwWtcXVkXk5Ag42JpVVpN1smNOH1JJ7epFNOk3wt+U?=
 =?us-ascii?Q?jtVlrKkkndsXSf6ylJV0cbEGu51ikUzKtV1Ht53EV/mCbcPBV1yoWegXDEiU?=
 =?us-ascii?Q?sptgqGX7y1vPgV9aooXJpkjUeQ8mAB12Xck7ze6RAp2ATc2fe/lV/7cr5ISq?=
 =?us-ascii?Q?2MeaOP+dr6YTmg9o/st4+mrWZKBonMH+BEbi/5noPsZvgjeAdR5QVG4FX4Mr?=
 =?us-ascii?Q?M0eyPIhxm1hxmPrSREIjJIyfKbY9uNwUe1jWyP+74NCYnsiqEK1zQAStVt8S?=
 =?us-ascii?Q?DZ6YzbIBDl+0Jhg6qxChGA1/FZzMbIOs0n397+xJPaoJLlLEpEvsnWVTbhHO?=
 =?us-ascii?Q?1RgM5q+vd5E8rTm+Pvn5S5Irv6MmLI0MML1Pg5hQNjA7G3+a7o3J7KcFOmxm?=
 =?us-ascii?Q?x1pmSHPvNcGsElotkhhZTScbN0kAKLTno8wIkALDFP8R1NrZB7qXukN5AQim?=
 =?us-ascii?Q?hyKmhZO5PrjZv5yPl5AaGjKQytmbdstwP+V1lLDEVhK6wBH6gIt7zyXABJQe?=
 =?us-ascii?Q?AZl7n/oHP7yXdebScm44imn7b4vwdmGrlZV4vrA7DDKrpJvb7CuoBpEcyfvr?=
 =?us-ascii?Q?/Y/38pY8pRbxC9EL8OdgVq4pE3Q9FUdDG/2g63oMcFYXywiNtrXcWE755LpB?=
 =?us-ascii?Q?NJuob2tJpRXL/OxzmBC/bwv8dfvUN2XyHAKC2FlUwbwIk5kOfzp6pQwCfz63?=
 =?us-ascii?Q?5El87UIFYPXsFyECjCL9R5SnaJL2MBR7aW6J1pscXSfUd53cws04R/n8qmZD?=
 =?us-ascii?Q?X1vUMWjkPjd+XnQBF1+hPNmVfyboDC6K1qz9JvtauHsk8TrxjjhKk1dx9qlO?=
 =?us-ascii?Q?20mPrIapLlWAQEeOr41PQPWbwTPfucoS89eMWO+UzO6r3LmaUVZ1KabE4G0g?=
 =?us-ascii?Q?HiUN670ycFYGnsK4ewzyUn4p9xyJHJb2L39zBzDE3QkXw7ZxLlRxrVnuQTyH?=
 =?us-ascii?Q?U3/vE51Kit8/DzWkGDANoC+2pOUZjDNPha9hsUJaW/11bgAuHuO/qYlFNFJH?=
 =?us-ascii?Q?TbtUshcyKWf1gUVvitSJyBvSqj+YRafBXaysHJ0ZkQZUcQ/30ODN71PKacAv?=
 =?us-ascii?Q?tmZZJOuLxRe/ApwKUH+SCGF6VOHDTLqKGP6fWEq65P6T4Vy2jRirQU/vp2je?=
 =?us-ascii?Q?B/sDbTWIYlheigeAqK+0LNoWxi1BEnBjQX8Xa1vwko0rWEagH42i4SBt4dB8?=
 =?us-ascii?Q?L8k2+07eB/dNoM2OEOyNxxlHxTpFLGJhni0AyE0x+QM+tg5Vjh1QVp4KK29x?=
 =?us-ascii?Q?t4JiqyrFZwRuYB7AnAaeH24OJG/oGbWXdem+?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2025 06:22:11.2021
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e834b1a0-aad8-4284-7018-08ddd0c3bfe0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003448.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7469
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=6/iz=2N=amd.com=venkataprasad.potturu@kernel.org
Subject: [PATCH 0/4] Add audio support for acp7.2 platform
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: 5cMOM7mdSEIG

This patch series is to add legacy and sof audio support
for acp7.2 platform.

Venkata Prasad Potturu (4):
  ASoC: SOF: amd: Add sof audio support for acp7.2 platform
  ASoC: amd: ps: Add SoundWire pci and dma driver support for acp7.2
    platform
  ASoC: amd: acp: Add SoundWire legacy machine driver support for acp7.2
    platform
  ASoC: amd: acp: Add SoundWire SOF machine driver support for acp7.2
    platform

 sound/soc/amd/acp/acp-sdw-legacy-mach.c | 3 +++
 sound/soc/amd/acp/acp-sdw-sof-mach.c    | 1 +
 sound/soc/amd/acp/soc_amd_sdw_common.h  | 2 ++
 sound/soc/amd/ps/acp63.h                | 1 +
 sound/soc/amd/ps/pci-ps.c               | 4 ++++
 sound/soc/amd/ps/ps-sdw-dma.c           | 5 +++++
 sound/soc/sof/amd/acp.c                 | 8 ++++++++
 sound/soc/sof/amd/acp.h                 | 1 +
 sound/soc/sof/amd/pci-acp70.c           | 1 +
 9 files changed, 26 insertions(+)

-- 
2.43.0

