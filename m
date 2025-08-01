Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877572441AF
	for <patches@lists.linux.dev>; Fri,  1 Aug 2025 12:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754051232; cv=fail; b=lryzZnj909+l0RQvGlBj+syZ0K9CjqGBIPH51PdpoqiIPp9W43yyWP2PRmRIY332IOyekA9Hu3TF9ePX01MEYM2H3IbARaARTR43YQRyw9lo4Z45/iSjex1GDk7nE8C88BmSS1GTi9D1UH4UEvdajlIL/b1mM4tXDQ24/s0dlco=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754051232; c=relaxed/simple;
	bh=6d1GEPp29hj3kPkHpnG38QOFJHT5+Yrf2Dysk5q6xqE=;
	h=From:To:CC:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Subject; b=NgQnuPsogyqerdlk8c/edwyXyfSGfERWzByAQIZR9RUpPCJLpbyuJecraD8UB+eJpaer5kIIremfWkygVSoAcoemwh4URlKFMSW5ef5KWlgMEIJKiQe1yZL0qczSLCGyy29Ar9UBMaR6+FKO88epRZIfSgCoaMB4vj7TTxK0L3g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PIEDuh4i; arc=fail smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PIEDuh4i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988A7C4CEE7
	for <patches@lists.linux.dev>; Fri,  1 Aug 2025 12:27:11 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PIEDuh4i"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Fri, 1 Aug 2025 13:27:08 +0100
Resent-Message-ID: <aIyynMTp13UwY6Qp@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Fri, 01 Aug 2025 07:23:13 +0100
Received: from tor.source.kernel.org ([172.105.4.254])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=6/iz=2N=amd.com=venkataprasad.potturu@kernel.org>)
	id 1uhjAc-00CizZ-Tp
	for broonie@sirena.co.uk; Fri, 01 Aug 2025 07:23:13 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AB7316020E
	for <broonie@sirena.co.uk>; Fri,  1 Aug 2025 06:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 75FFFC4CEEB; Fri,  1 Aug 2025 06:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85F12C4CEE7
	for <broonie@kernel.org>; Fri,  1 Aug 2025 06:23:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 85F12C4CEE7
Authentication-Results: smtp.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WQEc+uav5SzjxqzV7Yn3nHcaDKkLbDIQPAouipa3P5YiNapTvCyFxy9Buc1fnhOcC/j018m8hojFxwEM4XorFLS8maB74DuE+jqmpCIiMjZupI/vozvZnWMVoXgdVN3VIwAlf8zxX0qaOXrPqzSPy85hUEMeVD5s5lTG7dUQvHfoCT7XsZcyD0VOromwB5etz8XQzrpL9GkQwd6/Q3gQ/GxSCMgrqIkbYMxlj0VmiDrN+q1nLkLJi00hgc8fJcrLjEEZMU7LD7G4gaIOXfT8CNChNTPnSZ6zNs9QjeK+s6GSMH4puHyl6ioHrHPP1yEkq/1anZOwEEip6hnNNeLrlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ubTzMiMGm0cxJyahUTs5hMjcQLyN/yW87xQ6Auecr3I=;
 b=tPc1XAakf2lXC2AwamHpLWq4leO5KxS4m9fY356eryPZN/b9TR49Ebt0xSTsaC7enQaqwnmu1AARdeayva9IMGoK30aADSHrn3+Sc8XidsUzTMeGA2wzljSu0EpfQr5J3GgY7DZzf3WDDR+JcRxiVA8V70tkRrPsUzvO4hrAqgNrBudicC5kmmm58XklTHmioyLLmnI92uM+rgCu+Absd+WCN6lnpxTH47dkyF4NnOKyYJzbjIv8UE5dN4eqpXPvskwGwDj2xpVvcE+RXlT2AePSi8o0M31OjTe8rE3AXrRPAlPsw/bjTUaXSrgiBf0rV90Jctbg4mKzzrKdycAsVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ubTzMiMGm0cxJyahUTs5hMjcQLyN/yW87xQ6Auecr3I=;
 b=PIEDuh4ijZIa1HecrhJM/Hd1PlCRqlRL3wataAXYbyNKI5y7vGAKexn6q3JZQ0qkpX/NGEYshxe7r8PeUXf8xYJZ/G/5fzsJdUzdygk2uMh8Y73kZ2FVuDx2eC0IUAZ7YH2EVTa1MDepaZSuRketuaWBykWYRqEOQ396RLeBVys=
Received: from BN9PR03CA0681.namprd03.prod.outlook.com (2603:10b6:408:10e::26)
 by PH7PR12MB8053.namprd12.prod.outlook.com (2603:10b6:510:279::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.12; Fri, 1 Aug
 2025 06:22:42 +0000
Received: from BL02EPF00021F6C.namprd02.prod.outlook.com
 (2603:10b6:408:10e:cafe::76) by BN9PR03CA0681.outlook.office365.com
 (2603:10b6:408:10e::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.14 via Frontend Transport; Fri,
 1 Aug 2025 06:22:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BL02EPF00021F6C.mail.protection.outlook.com (10.167.249.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9009.8 via Frontend Transport; Fri, 1 Aug 2025 06:22:40 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 1 Aug
 2025 01:22:38 -0500
Received: from r9-mach.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Fri, 1 Aug 2025 01:22:33 -0500
From: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
To: <broonie@kernel.org>, <alsa-devel@alsa-project.org>
CC: <Vijendar.Mukunda@amd.com>, <Basavaraj.Hiregoudar@amd.com>,
	<Sunil-kumar.Dommati@amd.com>, <syed.sabakareem@amd.com>, "Venkata Prasad
 Potturu" <venkataprasad.potturu@amd.com>, Liam Girdwood
	<lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai
	<tiwai@suse.com>, Bard Liao <yung-chuan.liao@linux.intel.com>, Ranjani
 Sridharan <ranjani.sridharan@linux.intel.com>, Pierre-Louis Bossart
	<pierre-louis.bossart@linux.dev>, =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@baylibre.com>, Peter Zijlstra <peterz@infradead.org>,
	Charles Keepax <ckeepax@opensource.cirrus.com>, "open list:SOUND - SOC LAYER
 / DYNAMIC AUDIO POWER MANAGEM..." <linux-sound@vger.kernel.org>, open list
	<linux-kernel@vger.kernel.org>
Date: Fri, 1 Aug 2025 11:51:37 +0530
Message-ID: <20250801062207.579388-4-venkataprasad.potturu@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6C:EE_|PH7PR12MB8053:EE_
X-MS-Office365-Filtering-Correlation-Id: 77b48c0a-4644-4b31-720c-08ddd0c3d165
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5m/JtHYp8CqeyZkcG2tDWxarOmHNppxTXqpKC/0cDK815FbMVYlKzDf1vctS?=
 =?us-ascii?Q?JgvVIulrvc7ATX77bnH5RkYZ2KhYSraUn2Mnp59LgC0taCu/mkBSCuuFgEd2?=
 =?us-ascii?Q?S7g9RQ9U8nF89wt4fLIVjZ7rBG8Vax6MlRDrLWB9DpDIuM9nAgiNvE/txaRN?=
 =?us-ascii?Q?MmeEw3DmbcfuGwlA6flDzPoTyxlnkmcJQzrfVNXB7OTPJsApyYa0Z+rEfpTK?=
 =?us-ascii?Q?ZqCephWvpxCpjEx4uIbs2rn8VRuGzDz4BhfTB4ERGYw2ocY6YTgCiDOan4KE?=
 =?us-ascii?Q?bvQxwK/wXwApygsg9pfou7lnqMnLDDQ1OGLnPbHK75cNcrxYA91vDg7St1Qj?=
 =?us-ascii?Q?TPRtarUeLj93E5UmbZzAmvG6ha7TcErFmnnKxjToF8/85bi9v3yUknldwLOm?=
 =?us-ascii?Q?2PDaj8LR7OJ589ApNBi38xXWy0vSnMsPTBwdO7iel/5E5vRLxPWk8KaC6n9f?=
 =?us-ascii?Q?ciOpsxHvL0XV5oQPDjuPOR9+PSEKWyl+3BH0boqQpK1MPNpVLJ2eUyUYQoq5?=
 =?us-ascii?Q?XjbihY7/2c5TLP/WlXHQfjLasjLc2lkESD+fE1Gx2XoPyJyuRCalulKWCf/T?=
 =?us-ascii?Q?NxxguWK7zn30vcnkmzJHYsj6vpic5e7dX5hCkcyqMYUu333ChkrvPJz94Dy6?=
 =?us-ascii?Q?9lxPWClSUARv0IgJoDU8dRSAgzKzqtOffYGpBXUrduiUBqA1EqoQiezGNBwT?=
 =?us-ascii?Q?tb5vNhVXx5BfSp1k4YCy5YyKPqBEhifauDMX1AbN0olgVY+zUNwDgrXHXMqf?=
 =?us-ascii?Q?9aQ1vQpUp8uvGHZyC3P0henEyFwPkksWVMAa+cBpK2rgIC1g0lV+MIrvb5NN?=
 =?us-ascii?Q?Fyp3QQWVaYxOCrPrrkW9urB1o4yJklBJtGk4qPk5ia2tNUS/ZpnQCU4Jl4r8?=
 =?us-ascii?Q?gOJ2UyoXWhqDptJeZE+wpPtRe+vA1Nunqs2Bn7uUhd6wiOIuTyid9itLRm5S?=
 =?us-ascii?Q?eKbnzK66gLssod4YwOBk0eyablh8wswvFHu2jllJGX4oOr/wJlsME3dIaCM5?=
 =?us-ascii?Q?YlgDXZnwtwsxHqGRx0lUTf8fScqjsvA7nOUPWigAucx3iZJ4gIyGorI01igb?=
 =?us-ascii?Q?A0rZDYHqPpmyyRDus+Yd7ZFZznvhhBjB+xJUP12UhP9HAKxi+1ZZntOWlSll?=
 =?us-ascii?Q?9aAjLewNmE8pJ8WAL7z1j4smd2haq8AMy7kZQuUGdPBsydIyyBkI/+2qLRqO?=
 =?us-ascii?Q?KZzBamdrFrrKFlh8fzNSWx9mSbigefAGVUmSVZNRbj/UAehv0meI970+jWNQ?=
 =?us-ascii?Q?u9OVP63kkae9c2jqUKfor6HyuauhQpnCtvBnOojmerkS5mgMi/DIGWivgF3d?=
 =?us-ascii?Q?qJe6T6r91QwOeJ7OExo3VE0/glvr71xDAavD4YHqrk5leu8ZBKGov1C6+Viw?=
 =?us-ascii?Q?5OjTzhFwH9aQ1bJ1gH1C3c5PWwoqyhY05eidOOBSVrIoSRipVeSnyOyxFsbY?=
 =?us-ascii?Q?Tj8drOVybcBtlhvI8/AcF9OJJJCz1tLbclw0oP/nQGVXZ6232r+ibIN+gubS?=
 =?us-ascii?Q?uEHbOA6ABJIMZjXQEv9DnQ3WbIR2IZgNG0rM?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2025 06:22:40.6335
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 77b48c0a-4644-4b31-720c-08ddd0c3d165
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8053
X-SA-Exim-Connect-IP: 172.105.4.254
X-SA-Exim-Mail-From: SRS0=6/iz=2N=amd.com=venkataprasad.potturu@kernel.org
Subject: [PATCH 3/4] ASoC: amd: acp: Add SoundWire legacy machine driver support for acp7.2 platform
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: U8TM2o7gGUN0

Add SoundWire legacy machine driver support for acp7.2 platform.

Signed-off-by: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
---
 sound/soc/amd/acp/acp-sdw-legacy-mach.c | 3 +++
 sound/soc/amd/acp/soc_amd_sdw_common.h  | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/sound/soc/amd/acp/acp-sdw-legacy-mach.c b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
index 6c24f9d8694e..c2197b75a7dd 100644
--- a/sound/soc/amd/acp/acp-sdw-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
@@ -158,6 +158,7 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 			break;
 		case ACP70_PCI_REV:
 		case ACP71_PCI_REV:
+		case ACP72_PCI_REV:
 			ret = get_acp70_cpu_pin_id(ffs(soc_end->link_mask - 1),
 						   *be_id, &cpu_pin_id, dev);
 			if (ret)
@@ -264,6 +265,7 @@ static int create_sdw_dailinks(struct snd_soc_card *card,
 	case ACP63_PCI_REV:
 	case ACP70_PCI_REV:
 	case ACP71_PCI_REV:
+	case ACP72_PCI_REV:
 		sdw_platform_component->name = "amd_ps_sdw_dma.0";
 		break;
 	default:
@@ -311,6 +313,7 @@ static int create_dmic_dailinks(struct snd_soc_card *card,
 	case ACP63_PCI_REV:
 	case ACP70_PCI_REV:
 	case ACP71_PCI_REV:
+	case ACP72_PCI_REV:
 		pdm_cpu->name = "acp_ps_pdm_dma.0";
 		pdm_platform->name = "acp_ps_pdm_dma.0";
 		break;
diff --git a/sound/soc/amd/acp/soc_amd_sdw_common.h b/sound/soc/amd/acp/soc_amd_sdw_common.h
index 1f24e0e06487..3930cc46fa58 100644
--- a/sound/soc/amd/acp/soc_amd_sdw_common.h
+++ b/sound/soc/amd/acp/soc_amd_sdw_common.h
@@ -21,6 +21,8 @@
 #define ACP63_PCI_REV			0x63
 #define ACP70_PCI_REV			0x70
 #define ACP71_PCI_REV			0x71
+#define ACP72_PCI_REV			0x72
+
 #define SOC_JACK_JDSRC(quirk)		((quirk) & GENMASK(3, 0))
 #define ASOC_SDW_FOUR_SPK		BIT(4)
 #define ASOC_SDW_ACP_DMIC		BIT(5)
-- 
2.43.0

