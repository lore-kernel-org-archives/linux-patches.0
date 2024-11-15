Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07262BB1B;
	Fri, 15 Nov 2024 06:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653287; cv=none; b=eAicNKLR96jXSaaNTfQopkierMZFoNckZH8Zf+COsWMvHnmDSZCk0KhcEeI7PieZfTDlVJFxwkXfh7mZpeYzTqWf6kAXEjxDiXlaNUxfT7DkIaKxeteXEoHmTrKqRXF+WIYIUiocHwtEiixjCu/u+yQJ0PsNFSMJueVilHsJKUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653287; c=relaxed/simple;
	bh=0OQCz882qz2b7DqnlGrfHHcTh0hAHYuyZwSrTB4dK/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lVbsK7CbUdV5cvZqiM8NKf3WJ7So/HLaYXRXlnLzfttY0Hl8x0lW3tRGNQLoBYNataTOobdOwEa6gAiPL/GnpKp6RACBKO2dV2eY5pUCkxOHd5pnrMsfxIkgvYl1WkJ0LZhLGuY9mziSFB2eL9ZDshrOnrcAxRwx8c9tWhxSxE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VXOABz+k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VXOABz+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBF3C4CECF;
	Fri, 15 Nov 2024 06:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653286;
	bh=0OQCz882qz2b7DqnlGrfHHcTh0hAHYuyZwSrTB4dK/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXOABz+ktLVqTMOOHfs045oroYHpdG2ixHDW+g4I1YDNAmBIEAwBits6hQSxwjprJ
	 5PdVzzByXlVsETrX16dIY5OTHcE5Axd0Vdh3LD2T0XvFNyBEWFavlSJY8IuCHTjllC
	 RG93I4Y9adU4UK1Poc3MR+V/WNsY4MBqTJpt8SZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Derek Fang <derek.fang@realtek.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 42/63] ASoC: Intel: soc-acpi: lnl: Add match entry for TM2 laptops
Date: Fri, 15 Nov 2024 07:38:05 +0100
Message-ID: <20241115063727.433318787@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Derek Fang <derek.fang@realtek.com>

[ Upstream commit 6924565a04e5f424c95e6d894584e3059f257373 ]

Add a new match table entry on Lunarlake for the TM2 laptops
with rt713 and rt1318.

Signed-off-by: Derek Fang <derek.fang@realtek.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20241016030703.13669-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/common/soc-acpi-intel-lnl-match.c   | 38 +++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/sound/soc/intel/common/soc-acpi-intel-lnl-match.c b/sound/soc/intel/common/soc-acpi-intel-lnl-match.c
index edfb668d0580d..8452b66149119 100644
--- a/sound/soc/intel/common/soc-acpi-intel-lnl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-lnl-match.c
@@ -166,6 +166,15 @@ static const struct snd_soc_acpi_adr_device rt1316_3_group1_adr[] = {
 	}
 };
 
+static const struct snd_soc_acpi_adr_device rt1318_1_adr[] = {
+	{
+		.adr = 0x000133025D131801ull,
+		.num_endpoints = 1,
+		.endpoints = &single_endpoint,
+		.name_prefix = "rt1318-1"
+	}
+};
+
 static const struct snd_soc_acpi_adr_device rt1318_1_group1_adr[] = {
 	{
 		.adr = 0x000130025D131801ull,
@@ -184,6 +193,15 @@ static const struct snd_soc_acpi_adr_device rt1318_2_group1_adr[] = {
 	}
 };
 
+static const struct snd_soc_acpi_adr_device rt713_0_adr[] = {
+	{
+		.adr = 0x000031025D071301ull,
+		.num_endpoints = 1,
+		.endpoints = &single_endpoint,
+		.name_prefix = "rt713"
+	}
+};
+
 static const struct snd_soc_acpi_adr_device rt714_0_adr[] = {
 	{
 		.adr = 0x000030025D071401ull,
@@ -286,6 +304,20 @@ static const struct snd_soc_acpi_link_adr lnl_sdw_rt1318_l12_rt714_l0[] = {
 	{}
 };
 
+static const struct snd_soc_acpi_link_adr lnl_sdw_rt713_l0_rt1318_l1[] = {
+	{
+		.mask = BIT(0),
+		.num_adr = ARRAY_SIZE(rt713_0_adr),
+		.adr_d = rt713_0_adr,
+	},
+	{
+		.mask = BIT(1),
+		.num_adr = ARRAY_SIZE(rt1318_1_adr),
+		.adr_d = rt1318_1_adr,
+	},
+	{}
+};
+
 /* this table is used when there is no I2S codec present */
 struct snd_soc_acpi_mach snd_soc_acpi_intel_lnl_sdw_machines[] = {
 	/* mockup tests need to be first */
@@ -343,6 +375,12 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_lnl_sdw_machines[] = {
 		.drv_name = "sof_sdw",
 		.sof_tplg_filename = "sof-lnl-rt1318-l12-rt714-l0.tplg"
 	},
+	{
+		.link_mask = BIT(0) | BIT(1),
+		.links = lnl_sdw_rt713_l0_rt1318_l1,
+		.drv_name = "sof_sdw",
+		.sof_tplg_filename = "sof-lnl-rt713-l0-rt1318-l1.tplg"
+	},
 	{},
 };
 EXPORT_SYMBOL_GPL(snd_soc_acpi_intel_lnl_sdw_machines);
-- 
2.43.0



