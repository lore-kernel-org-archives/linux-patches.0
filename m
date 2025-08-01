Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB76C1C7013
	for <patches@lists.linux.dev>; Fri,  1 Aug 2025 12:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754051236; cv=fail; b=rf+fQrWKgPrddhmWaWbYWGTnzIILco+G2YENJC0yMQLHJBTPXk14D/UKCd0Du6y02bNdcuBujJB2SrkLCcvs7JGWNXBrAhk9rtFmAMrRE3LwH2xHNKAMwHMtnU+0T7e9KogO6VlHa8vkx4JfD+mCS4B1Olu2Mlgao3Ank10t2ws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754051236; c=relaxed/simple;
	bh=lKu6AUlME1OPQ4biU2TYT/jmNsntDzFkq5ywhGmArWs=;
	h=From:To:CC:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Subject; b=tt/KL3m4XlqIFyyuZKbuhFGbE2ryYcnm4aQShv2cAEe5gLDeXNRQMe6outevCianGlTHqar8v4bDTgvbiihdqnsXGIAwRNPpGVk6shUx4U8z0htltssedCJRrveVw7K+VB0I5MK3MOqwqBE8rjwXN8xtXUxkYrfUpZianN4umiE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ni8asxo+; arc=fail smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ni8asxo+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE05C4CEE7
	for <patches@lists.linux.dev>; Fri,  1 Aug 2025 12:27:14 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ni8asxo+"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Fri, 1 Aug 2025 13:27:12 +0100
Resent-Message-ID: <aIyyoE7318G6wzD5@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Fri, 01 Aug 2025 07:23:06 +0100
Received: from sea.source.kernel.org ([2600:3c0a:e001:78e:0:1991:8:25])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=6/iz=2N=amd.com=venkataprasad.potturu@kernel.org>)
	id 1uhjAV-00CizS-LM
	for broonie@sirena.co.uk; Fri, 01 Aug 2025 07:23:06 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 73D1A41AE7
	for <broonie@sirena.co.uk>; Fri,  1 Aug 2025 06:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 65D60C4CEF7; Fri,  1 Aug 2025 06:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8C2F9C4CEE7
	for <broonie@kernel.org>; Fri,  1 Aug 2025 06:23:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 8C2F9C4CEE7
Authentication-Results: smtp.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mwQ5L+gqBcvIuW5WCXwoXfd5BMA8e1gyZ+uk3l/VgjCYGrbTBSGWc10L3dvgwVBEKyHSpxwTyhtGXkUdjX971AURGFwQu3JqKSFmOKE0u0pF8Z2D2l3WwnY3SRiavJKFXReHrern+8gIiL3kRF0be7c6QRs9uvBi5fc/gVVH9o9jLvPu2Fk72d1f6ETLyDPWX6n1qQH4+oQdSV2aRsQ+P2T4/TL+CSEUSJ/bBaksgC56Q4qgDh6s4RHy1AzrVfs+YthixqzoALio1CjUK5FDqbERMFvvaBbEeC0uXn2YHqZbmXWvG2+YqiuY8eHJrAwqMLYiHWioPd7AxrxB2sM0Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kfq8lUKoukk1DmhASgS/+VDP4vBRCi8uv2TlHM7BaKg=;
 b=q2NlyRaFkIolwFr58p6kqNhJDSBEPIRj8mzxxuc4AmoavO1Eh9NtxjrdBi7TCMvfR2FLrRVAajHU+my2DYl+Q/YE1kRvNRZ85blr87SRIITpV1W7NBM3CdGY2v92hmfJ6MzCMIq0hssfeb4LgDVn3SeO2VKrivi+i/RatJsxVY2RAOmyRR7zDH/xsXVG+jj231XzZ0ZJQLFJxBIJc5GpwiKkEfEowjEQN1qiQYGg75HRhO54L+9rPJ5gS/SWETfSZls0i/nuaCZK4UDaFCbDjZdJ8UcurRGvClEkWXxrlbVZZh92feSML48/BWgczf4y7Tz7Q1TxbezY+ZW3+nYRhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kfq8lUKoukk1DmhASgS/+VDP4vBRCi8uv2TlHM7BaKg=;
 b=ni8asxo+YS13/kRVBKsbw0UrkIKzq2nzGLWbUpUTnvLjmlsp2ut6kQgPqzSeCD1amc/Uuwj/zv0v0cx1C5UmD3svXxH/ocrOcgp293GNkFP8xr97aDUHgfIEGnmIZ5RCwTJ1S1/Y3TMfLGS65TNLbgKnYoDKbMsHtUo1Fi9TPzQ=
Received: from BN9PR03CA0673.namprd03.prod.outlook.com (2603:10b6:408:10e::18)
 by PH7PR12MB5687.namprd12.prod.outlook.com (2603:10b6:510:13e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.14; Fri, 1 Aug
 2025 06:22:56 +0000
Received: from BL02EPF00021F6C.namprd02.prod.outlook.com
 (2603:10b6:408:10e:cafe::44) by BN9PR03CA0673.outlook.office365.com
 (2603:10b6:408:10e::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.14 via Frontend Transport; Fri,
 1 Aug 2025 06:22:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BL02EPF00021F6C.mail.protection.outlook.com (10.167.249.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9009.8 via Frontend Transport; Fri, 1 Aug 2025 06:22:56 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 1 Aug
 2025 01:22:47 -0500
Received: from r9-mach.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Fri, 1 Aug 2025 01:22:42 -0500
From: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
To: <broonie@kernel.org>, <alsa-devel@alsa-project.org>
CC: <Vijendar.Mukunda@amd.com>, <Basavaraj.Hiregoudar@amd.com>,
	<Sunil-kumar.Dommati@amd.com>, <syed.sabakareem@amd.com>, "Venkata Prasad
 Potturu" <venkataprasad.potturu@amd.com>, Liam Girdwood
	<lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai
	<tiwai@suse.com>, Bard Liao <yung-chuan.liao@linux.intel.com>, Ranjani
 Sridharan <ranjani.sridharan@linux.intel.com>, Pierre-Louis Bossart
	<pierre-louis.bossart@linux.dev>, Charles Keepax
	<ckeepax@opensource.cirrus.com>, Peter Zijlstra <peterz@infradead.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>, "open
 list:SOUND - SOC LAYER / DYNAMIC AUDIO POWER MANAGEM..."
	<linux-sound@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Date: Fri, 1 Aug 2025 11:51:38 +0530
Message-ID: <20250801062207.579388-5-venkataprasad.potturu@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250801062207.579388-1-venkataprasad.potturu@amd.com>
References: <20250801062207.579388-1-venkataprasad.potturu@amd.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB03.amd.com: venkataprasad.potturu@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6C:EE_|PH7PR12MB5687:EE_
X-MS-Office365-Filtering-Correlation-Id: 8de11dc8-9ca3-4c7d-598c-08ddd0c3daa7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?B4RcnH9axqtr7UpsI/SJ3SZaRWo9UFP5W4acSVyxhnaa3THujE55Tg+N2XFc?=
 =?us-ascii?Q?u4b5pleoi2O6C72HSEk0ZxA1lqRcI2OkUrWdYNSD++YP4Rd4iK019YlcbDsy?=
 =?us-ascii?Q?1pRCc3JQW2JivBkoUNI8PZ1Z9pTwPi4AZtcwbRltdJD2ed1WDJScjkc8Gd2X?=
 =?us-ascii?Q?+mdRwZ5mLhX47eF7UzQVfr6s5XIXSNOWx1AYDIT1dfiDmDcyYo417ueCAwui?=
 =?us-ascii?Q?mT2Vvze7iMbtqs0CgSjFneYx6D5Ny1DcbOK6CfJu0p0SyaM2FUZH5nLnEigO?=
 =?us-ascii?Q?H4Q64HyoKDWnvLYna2XsG9TKcxUVatnHa4MHHW+0VSa90yodar3uUc0bh58N?=
 =?us-ascii?Q?GFeu0jJtPVi3LSKOkIugqWQCfRJoSJqxKdljXgVL6/9XCGa1Zy1ROw0BpXEf?=
 =?us-ascii?Q?JGyzrC3EqBaUrKQYjDL4Jvg7TMsP6DP2NzewRyVtCVDwmxRVvmmPbhYpeD9/?=
 =?us-ascii?Q?Yro76pVEwB4ZUy/iramnRKbC4vjV56TnTe45tZrod920h8EmYt+9wx8Y9/zg?=
 =?us-ascii?Q?dJhOp6i0ocwc7AMU7I7IICi6Zp1FkbOrYzCJVBGBIiIiU22EupYJxf6RhDdo?=
 =?us-ascii?Q?yObXYcUj49bpaB3pyXLREL/zKtXItlZ/xPaPvzS9QccmtmgYmmBH8/hdigO7?=
 =?us-ascii?Q?cPnO811kKhZ7ak7fKORKZ9DrEAGNk4zMzJEhn6hC0hUVbC9vqbpiohUjEcD1?=
 =?us-ascii?Q?414J/7s+i/nEqF+UUhyy8m2LVfBLdNVfvaZYB+2Ay1Jxsk7RXt0VbCbjNOHr?=
 =?us-ascii?Q?tx80bGrR8Bg6m8XCe+THjo9zTimEFu/PxnVYJ2gy5y/lwosPENWYKKLMZL+/?=
 =?us-ascii?Q?ZjHRHnvFldpD1PoRBzprCfAFAM9I7SMfPODBfcIFmaEh4e3LUIR1MqAMtrYH?=
 =?us-ascii?Q?xY0T0JCKMQCVZB5jJx8AjjFchq5vl9KNfuH0huw7eaVNxBNXOSlEdg/WoaVc?=
 =?us-ascii?Q?kvEsyimPCi0yne3U0+8Ecuz5yZvGs4sqvcDdOHLKpa+v3ZI1plmuAXiTxkdi?=
 =?us-ascii?Q?Z0SbdXjsuJcOPgprVuWhEFhwnyLv8d4O6qUFX6RqcfWsQ1gLiWhOs+ZjiCFy?=
 =?us-ascii?Q?G5P8r1aLUF9+osqS3aY231YdPJRM7Nd/FbEpWCHzRq6sRAna9HKfW3+/GWdd?=
 =?us-ascii?Q?adqkQbToGxZOfYiPOs217xRXX1eLgba2sPGcF+qdy46B9Ru8F/4f/TPbDfF4?=
 =?us-ascii?Q?duuE3bAURd4SAOFzvPMbIUjNTRXpISgA8p/m+163Q+BJkCcBvAW82RbBljBr?=
 =?us-ascii?Q?2LUIQFXoL+fMWEKM4FFymV8MOEhWKqlvwcW2HzIeJLC+yTfU4BRTAUkWrDs9?=
 =?us-ascii?Q?l09ggTLxyojtry3HZA/BAKoRcTdVA+GGdXyja0fG23uoeRxoLrKbV3N6PXyz?=
 =?us-ascii?Q?4V1imdywi+fMT9nt5oRA2xA77TDrFbw1Dg5iOTAhce/XItPmcEvGz9GXO31/?=
 =?us-ascii?Q?f2/1/kwTptOMiRjNrzGgGzlCyfrE2/xm0I524LhZGRDwbSRyO1xFYCisOEd+?=
 =?us-ascii?Q?XlLxZCLMRCqr5j5aYVW/7WMO6mQjurIYDlmp?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2025 06:22:56.1623
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8de11dc8-9ca3-4c7d-598c-08ddd0c3daa7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5687
X-SA-Exim-Connect-IP: 2600:3c0a:e001:78e:0:1991:8:25
X-SA-Exim-Mail-From: SRS0=6/iz=2N=amd.com=venkataprasad.potturu@kernel.org
Subject: [PATCH 4/4] ASoC: amd: acp: Add SoundWire SOF machine driver support for acp7.2 platform
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: fCFclqyBu7Ye

Add SoundWire SOF machine driver support for acp7.2 platform.

Signed-off-by: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
---
 sound/soc/amd/acp/acp-sdw-sof-mach.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/amd/acp/acp-sdw-sof-mach.c b/sound/soc/amd/acp/acp-sdw-sof-mach.c
index 654fe78b2e2e..91d72d4bb9a2 100644
--- a/sound/soc/amd/acp/acp-sdw-sof-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-sof-mach.c
@@ -130,6 +130,7 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 			break;
 		case ACP70_PCI_REV:
 		case ACP71_PCI_REV:
+		case ACP72_PCI_REV:
 			ret = get_acp70_cpu_pin_id(ffs(sof_end->link_mask - 1),
 						   *be_id, &cpu_pin_id, dev);
 			if (ret)
-- 
2.43.0

