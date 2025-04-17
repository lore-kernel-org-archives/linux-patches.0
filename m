Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68E18462;
	Thu, 17 Apr 2025 18:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913803; cv=none; b=i7fKW5byVdsLQwqikO5EymHevOaFlLDw6LmtqbeF9beyA3MRpDmpphVuldtU0zs/2viEC5I8Q9MRGHMUAFRO1TxjDVKDhBVrvJVwRSsLDNJ2qZO2O94vjdC//KMrHI0BIjZUNebb28rbAYUsK5gRCmKvieDKn186DUv0Lm6eeHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913803; c=relaxed/simple;
	bh=salkEvi1JN5bxh+k55ppazByJ4gWLY3aEtFErNACHC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mORKWBraCaMbYVXv0nHbIOhUgfZoZrA8dCvO8bg6Hzt7ezUTcvBlE6G0gSHGNt+vT9wBYBZFrpXHr6OG2sW8nW6RwOoHmr1hahOmt7kHC9lUKRKUjb1WdQd2vUdx8iKTCudHoqqRm4NTtqjCo3lD9PTw7+3NC3XuuQ6Od2LZzHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iGap+EZd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iGap+EZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7A1C4CEE7;
	Thu, 17 Apr 2025 18:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913803;
	bh=salkEvi1JN5bxh+k55ppazByJ4gWLY3aEtFErNACHC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGap+EZdEmDYVjIZLo2uOlVmPhny8/qPnqADS0txm7KbmMW8cMz/s4K+bWCG5NNC4
	 ZEItFXZ37An30X4ryKwa0zE+cCIE5us3WKMAuShx1mFtqz7R+m1U1aX4k5izx47vGQ
	 Uf56ETbGBm47huAvaGccaeVE04WhTLlgba8r7FtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.13 001/414] ASoC: Intel: adl: add 2xrt1316 audio configuration
Date: Thu, 17 Apr 2025 19:45:59 +0200
Message-ID: <20250417175111.451233991@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

commit 8b36447c9ae102539d82d6278971b23b20d87629 upstream.

That is a speaker only configuration and 2 rt1316 are on link 0 and 2.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20250305135443.201884-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/common/soc-acpi-intel-adl-match.c |   29 ++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/sound/soc/intel/common/soc-acpi-intel-adl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-adl-match.c
@@ -214,6 +214,15 @@ static const struct snd_soc_acpi_adr_dev
 	}
 };
 
+static const struct snd_soc_acpi_adr_device rt1316_2_group2_adr[] = {
+	{
+		.adr = 0x000232025D131601ull,
+		.num_endpoints = 1,
+		.endpoints = &spk_r_endpoint,
+		.name_prefix = "rt1316-2"
+	}
+};
+
 static const struct snd_soc_acpi_adr_device rt1316_1_single_adr[] = {
 	{
 		.adr = 0x000130025D131601ull,
@@ -547,6 +556,20 @@ static const struct snd_soc_acpi_link_ad
 	{}
 };
 
+static const struct snd_soc_acpi_link_adr adl_sdw_rt1316_link02[] = {
+	{
+		.mask = BIT(0),
+		.num_adr = ARRAY_SIZE(rt1316_0_group2_adr),
+		.adr_d = rt1316_0_group2_adr,
+	},
+	{
+		.mask = BIT(2),
+		.num_adr = ARRAY_SIZE(rt1316_2_group2_adr),
+		.adr_d = rt1316_2_group2_adr,
+	},
+	{}
+};
+
 static const struct snd_soc_acpi_codecs adl_max98357a_amp = {
 	.num_codecs = 1,
 	.codecs = {"MX98357A"}
@@ -749,6 +772,12 @@ struct snd_soc_acpi_mach snd_soc_acpi_in
 		.drv_name = "sof_sdw",
 		.sof_tplg_filename = "sof-adl-sdw-max98373-rt5682.tplg",
 	},
+	{
+		.link_mask = BIT(0) | BIT(2),
+		.links = adl_sdw_rt1316_link02,
+		.drv_name = "sof_sdw",
+		.sof_tplg_filename = "sof-adl-rt1316-l02.tplg",
+	},
 	{},
 };
 EXPORT_SYMBOL_GPL(snd_soc_acpi_intel_adl_sdw_machines);


