Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85568196DB4;
	Thu,  6 Jun 2024 14:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683349; cv=none; b=ktEITAZ+fuojeLPw4UCbp4rIL+4XLn6sTqMgczzPkwobmRzYedBMOY/EXgIbxRdaTyY3RGSNqMbuAyihd2rzC5Fz41ul5CegE8qIj6KqxPpDiMVUNG04L25+jBPmM7gMMZUllmJJwGm/48nWwbHnE8rSs26Av3lKXj6zvTBA670=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683349; c=relaxed/simple;
	bh=CPgqF1YYrJANJfVyKEfUHj6XIxf/KBI98jQysTbZNyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nI5vjzdfK9HVo46eOeYJ6/wBTNLRUFMPg5tMT3VK40cJOSgtE6MRrcrTn+EWF/pv9dL1DQoZdzZjPh50Il8yat1bidrr1BI4NGdnSK/xq3T3Mov7zW5IqE+FZwWfF+yp0vV12QiOCn0gi2qQ6lpbaZOd/VvKbQ77cI2NEZ47hLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VF9RuiHV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VF9RuiHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EFFC2BD10;
	Thu,  6 Jun 2024 14:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683349;
	bh=CPgqF1YYrJANJfVyKEfUHj6XIxf/KBI98jQysTbZNyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VF9RuiHVsD1mDABGpYt3iTNeBu+ITmVVTmFXNt+nI2/M8QkYC17tgJSwcSvr7NDJk
	 KPf4VVygwZzZ/p9WXcPnlw2b2b+qJJ/jMV8SIMm7VrdYnQh/oPq/EOxsCABGlZruGP
	 Rb+Fn9ZgwXK+f5b8V2DwjttKCu8J5KTXOlHx6aAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arun T <arun.t@intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 290/744] ASoC: Intel: common: add ACPI matching tables for Arrow Lake
Date: Thu,  6 Jun 2024 15:59:22 +0200
Message-ID: <20240606131741.705555319@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arun T <arun.t@intel.com>

[ Upstream commit 24af0d7c0f9f49a243b77e607e3f4a4737386b59 ]

Initial support for ARL w/ RT711

Signed-off-by: Arun T <arun.t@intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20230915080635.1619942-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 1f1b820dc3c6 ("ASoC: SOF: Intel: mtl: Correct rom_status_reg")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc-acpi-intel-match.h          |  2 +
 sound/soc/intel/common/Makefile               |  1 +
 .../intel/common/soc-acpi-intel-arl-match.c   | 51 +++++++++++++++++++
 3 files changed, 54 insertions(+)
 create mode 100644 sound/soc/intel/common/soc-acpi-intel-arl-match.c

diff --git a/include/sound/soc-acpi-intel-match.h b/include/sound/soc-acpi-intel-match.h
index e49b97d9e3ff2..845e7608ac375 100644
--- a/include/sound/soc-acpi-intel-match.h
+++ b/include/sound/soc-acpi-intel-match.h
@@ -32,6 +32,7 @@ extern struct snd_soc_acpi_mach snd_soc_acpi_intel_adl_machines[];
 extern struct snd_soc_acpi_mach snd_soc_acpi_intel_rpl_machines[];
 extern struct snd_soc_acpi_mach snd_soc_acpi_intel_mtl_machines[];
 extern struct snd_soc_acpi_mach snd_soc_acpi_intel_lnl_machines[];
+extern struct snd_soc_acpi_mach snd_soc_acpi_intel_arl_machines[];
 
 extern struct snd_soc_acpi_mach snd_soc_acpi_intel_cnl_sdw_machines[];
 extern struct snd_soc_acpi_mach snd_soc_acpi_intel_cfl_sdw_machines[];
@@ -42,6 +43,7 @@ extern struct snd_soc_acpi_mach snd_soc_acpi_intel_adl_sdw_machines[];
 extern struct snd_soc_acpi_mach snd_soc_acpi_intel_rpl_sdw_machines[];
 extern struct snd_soc_acpi_mach snd_soc_acpi_intel_mtl_sdw_machines[];
 extern struct snd_soc_acpi_mach snd_soc_acpi_intel_lnl_sdw_machines[];
+extern struct snd_soc_acpi_mach snd_soc_acpi_intel_arl_sdw_machines[];
 
 /*
  * generic table used for HDA codec-based platforms, possibly with
diff --git a/sound/soc/intel/common/Makefile b/sound/soc/intel/common/Makefile
index 07aa37dd90e99..f7370e5b4e9e4 100644
--- a/sound/soc/intel/common/Makefile
+++ b/sound/soc/intel/common/Makefile
@@ -10,6 +10,7 @@ snd-soc-acpi-intel-match-objs := soc-acpi-intel-byt-match.o soc-acpi-intel-cht-m
 	soc-acpi-intel-tgl-match.o soc-acpi-intel-ehl-match.o \
 	soc-acpi-intel-jsl-match.o soc-acpi-intel-adl-match.o \
 	soc-acpi-intel-rpl-match.o soc-acpi-intel-mtl-match.o \
+	soc-acpi-intel-arl-match.o \
 	soc-acpi-intel-lnl-match.o \
 	soc-acpi-intel-hda-match.o \
 	soc-acpi-intel-sdw-mockup-match.o
diff --git a/sound/soc/intel/common/soc-acpi-intel-arl-match.c b/sound/soc/intel/common/soc-acpi-intel-arl-match.c
new file mode 100644
index 0000000000000..e52797aae6e65
--- /dev/null
+++ b/sound/soc/intel/common/soc-acpi-intel-arl-match.c
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * soc-apci-intel-arl-match.c - tables and support for ARL ACPI enumeration.
+ *
+ * Copyright (c) 2023 Intel Corporation.
+ */
+
+#include <sound/soc-acpi.h>
+#include <sound/soc-acpi-intel-match.h>
+
+static const struct snd_soc_acpi_endpoint single_endpoint = {
+	.num = 0,
+	.aggregated = 0,
+	.group_position = 0,
+	.group_id = 0,
+};
+
+static const struct snd_soc_acpi_adr_device rt711_0_adr[] = {
+	{
+		.adr = 0x000020025D071100ull,
+		.num_endpoints = 1,
+		.endpoints = &single_endpoint,
+		.name_prefix = "rt711"
+	}
+};
+
+static const struct snd_soc_acpi_link_adr arl_rvp[] = {
+	{
+		.mask = BIT(0),
+		.num_adr = ARRAY_SIZE(rt711_0_adr),
+		.adr_d = rt711_0_adr,
+	},
+	{}
+};
+
+struct snd_soc_acpi_mach snd_soc_acpi_intel_arl_machines[] = {
+	{},
+};
+EXPORT_SYMBOL_GPL(snd_soc_acpi_intel_arl_machines);
+
+/* this table is used when there is no I2S codec present */
+struct snd_soc_acpi_mach snd_soc_acpi_intel_arl_sdw_machines[] = {
+	{
+		.link_mask = 0x1, /* link0 required */
+		.links = arl_rvp,
+		.drv_name = "sof_sdw",
+		.sof_tplg_filename = "sof-arl-rt711.tplg",
+	},
+	{},
+};
+EXPORT_SYMBOL_GPL(snd_soc_acpi_intel_arl_sdw_machines);
-- 
2.43.0



