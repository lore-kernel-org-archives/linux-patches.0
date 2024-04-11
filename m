Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3931C146D68;
	Thu, 11 Apr 2024 10:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831401; cv=none; b=HKiZnyFj/lkeBpjQ36Oz2dF2SRMhdx2NxF246KH0ccGr/I+D+HncWG/fyr5VIRu2yYVnO+AaQ12xr7pY32RT2d47+Ott9N6+cYNqHMr7ke/2jQQFC7Jkc4vfLyMFeENAbHe7sPKP6ZYS7HM6TC33SNuexJX19MMpwp3b1s2t+qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831401; c=relaxed/simple;
	bh=m112fI/7Hj2R83kn0nZmb64KNy1G0SRdr5vIbnR5S0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q7EJImEySgW3KNZviIm8vGJPkwacx+nQpjKB/4HuWEdTaMwbmL8K+qlWUWnfsewOcy3snwxqoZpGv/k47trzXlPdc1vFJMXXZKYz8UHt0iTn1IwPenpXAIiW9xj3HSW2Ym4oFDJGWWMzx2bguCu5ttxrhIToL/uOt8CdtryX2Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=npa6BWIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="npa6BWIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30A2C433F1;
	Thu, 11 Apr 2024 10:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831401;
	bh=m112fI/7Hj2R83kn0nZmb64KNy1G0SRdr5vIbnR5S0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=npa6BWITQ/jiMe75YZDvqIxEmFNEVBy5W7FVxmP/bRwXy1zHRuixierkmUav4yhqS
	 JYnKMvmXHoCP/btsSU9VX5F4oY5TJKaOC3y1+rC0DMKRMOIcpZGrFsCElbWaJbKTqR
	 34WhYRT68jgByvhYI7NTODMfnSTSjYkhCYceK34E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/114] ASoC: Intel: avs: Populate board selection with new I2S entries
Date: Thu, 11 Apr 2024 11:56:28 +0200
Message-ID: <20240411095418.728338125@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 5b417fe0cded0b5917683398e6519aae8045cd40 ]

Update board selection with tables specifying supported I2S
configurations. DMIC/HDAudio board selection require no update as
dmic/hdaudio machine boards are generic and not tied to any specific
codec.

Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://msgid.link/r/20240220115035.770402-11-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/board_selection.c | 85 +++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/sound/soc/intel/avs/board_selection.c b/sound/soc/intel/avs/board_selection.c
index 59a13feec57b2..0db5e530a8de2 100644
--- a/sound/soc/intel/avs/board_selection.c
+++ b/sound/soc/intel/avs/board_selection.c
@@ -227,6 +227,82 @@ static struct snd_soc_acpi_mach avs_gml_i2s_machines[] = {
 	{},
 };
 
+static struct snd_soc_acpi_mach avs_cnl_i2s_machines[] = {
+	{
+		.id = "INT34C2",
+		.drv_name = "avs_rt274",
+		.mach_params = {
+			.i2s_link_mask = AVS_SSP(0),
+		},
+		.tplg_filename = "rt274-tplg.bin",
+	},
+	{
+		.id = "10EC5682",
+		.drv_name = "avs_rt5682",
+		.mach_params = {
+			.i2s_link_mask = AVS_SSP(1),
+		},
+		.tplg_filename = "rt5682-tplg.bin",
+	},
+	{},
+};
+
+static struct snd_soc_acpi_mach avs_icl_i2s_machines[] = {
+	{
+		.id = "INT343A",
+		.drv_name = "avs_rt298",
+		.mach_params = {
+			.i2s_link_mask = AVS_SSP(0),
+		},
+		.tplg_filename = "rt298-tplg.bin",
+	},
+	{
+		.id = "INT34C2",
+		.drv_name = "avs_rt274",
+		.mach_params = {
+			.i2s_link_mask = AVS_SSP(0),
+		},
+		.tplg_filename = "rt274-tplg.bin",
+	},
+	{},
+};
+
+static struct snd_soc_acpi_mach avs_tgl_i2s_machines[] = {
+	{
+		.id = "INT34C2",
+		.drv_name = "avs_rt274",
+		.mach_params = {
+			.i2s_link_mask = AVS_SSP(0),
+		},
+		.tplg_filename = "rt274-tplg.bin",
+	},
+	{
+		.id = "10EC0298",
+		.drv_name = "avs_rt298",
+		.mach_params = {
+			.i2s_link_mask = AVS_SSP(0),
+		},
+		.tplg_filename = "rt298-tplg.bin",
+	},
+	{
+		.id = "10EC1308",
+		.drv_name = "avs_rt1308",
+		.mach_params = {
+			.i2s_link_mask = AVS_SSP(1),
+		},
+		.tplg_filename = "rt1308-tplg.bin",
+	},
+	{
+		.id = "ESSX8336",
+		.drv_name = "avs_es8336",
+		.mach_params = {
+			.i2s_link_mask = AVS_SSP(0),
+		},
+		.tplg_filename = "es8336-tplg.bin",
+	},
+	{},
+};
+
 static struct snd_soc_acpi_mach avs_test_i2s_machines[] = {
 	{
 		.drv_name = "avs_i2s_test",
@@ -287,6 +363,15 @@ static const struct avs_acpi_boards i2s_boards[] = {
 	AVS_MACH_ENTRY(HDA_KBL_LP, avs_kbl_i2s_machines),
 	AVS_MACH_ENTRY(HDA_APL, avs_apl_i2s_machines),
 	AVS_MACH_ENTRY(HDA_GML, avs_gml_i2s_machines),
+	AVS_MACH_ENTRY(HDA_CNL_LP,	avs_cnl_i2s_machines),
+	AVS_MACH_ENTRY(HDA_CNL_H,	avs_cnl_i2s_machines),
+	AVS_MACH_ENTRY(HDA_CML_LP,	avs_cnl_i2s_machines),
+	AVS_MACH_ENTRY(HDA_ICL_LP,	avs_icl_i2s_machines),
+	AVS_MACH_ENTRY(HDA_TGL_LP,	avs_tgl_i2s_machines),
+	AVS_MACH_ENTRY(HDA_EHL_0,	avs_tgl_i2s_machines),
+	AVS_MACH_ENTRY(HDA_ADL_P,	avs_tgl_i2s_machines),
+	AVS_MACH_ENTRY(HDA_RPL_P_0,	avs_tgl_i2s_machines),
+	AVS_MACH_ENTRY(HDA_RPL_M,	avs_tgl_i2s_machines),
 	{},
 };
 
-- 
2.43.0



