Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19CA145FFB;
	Thu, 11 Apr 2024 10:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830234; cv=none; b=LKUFfmrO3E6s4azauNQyQJJd9odh1pmkJ26xLmQ0tbzUAe7NnuYzLsH0XHGbJYErtydNLXthEftZp2QejzaBl41eSYQXP0JUsetb5nrzIkE1AL+izUqI2USHMdvnWiB6iGBucx1c68eMg6VJQJbN+WpMRdSmkwDm6c5rbKex35E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830234; c=relaxed/simple;
	bh=uM/ZAgFedWYvnNVVqlAYqBfgZ8pCgq1HEqvcQnS3yhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o9Nmvj+ZRi+9y3GYKM45yP5DoJBaI2DsRV+EmVdt9qLIIrJxyb2ZPEwLNleJCLfCOKiOSjF6vQk5UWK6U8lbDekwnF0V5lSLTRzscMrFVYvfZEZ5QmuZn88dwwiZb9bIBV4PnaklrOBw+0OXR1ElJrAmrmHDWe353N/lZ1asnGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dZO7jmwI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dZO7jmwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D142CC43394;
	Thu, 11 Apr 2024 10:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830234;
	bh=uM/ZAgFedWYvnNVVqlAYqBfgZ8pCgq1HEqvcQnS3yhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dZO7jmwI5sGzqXuvHPmeXdZgIDwMaakDYeZAZZWI0+Or/cj/WcVcwUKjTIB9NkOvH
	 doLCvWuAMxWwmRYm/VR2cZd3PlX73XJ5QVnCPed0fqqpoa3kIlzJDkLglPlIkYx87k
	 kb38teCn0dMrSPrcs3L1p+0LStJhFrvZfETVQ648=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 080/143] ASoC: Intel: avs: Populate board selection with new I2S entries
Date: Thu, 11 Apr 2024 11:55:48 +0200
Message-ID: <20240411095423.321828395@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 8e91eece992db..8360ce557401c 100644
--- a/sound/soc/intel/avs/board_selection.c
+++ b/sound/soc/intel/avs/board_selection.c
@@ -236,6 +236,82 @@ static struct snd_soc_acpi_mach avs_gml_i2s_machines[] = {
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
@@ -296,6 +372,15 @@ static const struct avs_acpi_boards i2s_boards[] = {
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



