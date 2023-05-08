Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD23F210C
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11939C433D2;
	Mon,  8 May 2023 10:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541142;
	bh=/yFPLacZ5zD4cyBBeXXj/glDEj/Gpj3zZaG5dwMznfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WxDb/YXE6Lg6eESGKeKx/vBDwJpD8j1TbpXytDVT64pWxoSo+/men6Dbm3BOZenZM
	 lFWNRqcfPDf36bjBo7pb7Rv6y5k/vNP3vr/vb3ONvpB6MsTlmfV3/gVWw+B8vFtRuO
	 jXksHxgSqOghd+76/UKpDr0PSid6S+/1FDJWjjCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Huang <eugene.huang99@gmail.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 002/663] ASoC: Intel: soc-acpi: add table for Intel Rooks County NUC M15
Date: Mon,  8 May 2023 11:37:08 +0200
Message-Id: <20230508094428.482469668@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eugene Huang <eugene.huang99@gmail.com>

[ Upstream commit 9c691a42b8926c8966561265cdae3ddc7464d3a2 ]

Same topology as the HP Omen 16-k0005TX, except with the rt1316 amp
on link2.

Link: https://github.com/thesofproject/linux/issues/4088
Signed-off-by: Eugene Huang <eugene.huang99@gmail.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20230314090553.498664-3-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/common/soc-acpi-intel-adl-match.c   | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/sound/soc/intel/common/soc-acpi-intel-adl-match.c b/sound/soc/intel/common/soc-acpi-intel-adl-match.c
index 28dd2046e4ac5..d8c80041388a7 100644
--- a/sound/soc/intel/common/soc-acpi-intel-adl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-adl-match.c
@@ -354,6 +354,20 @@ static const struct snd_soc_acpi_link_adr adl_sdw_rt711_link0_rt1316_link3[] = {
 	{}
 };
 
+static const struct snd_soc_acpi_link_adr adl_sdw_rt711_link0_rt1316_link2[] = {
+	{
+		.mask = BIT(0),
+		.num_adr = ARRAY_SIZE(rt711_sdca_0_adr),
+		.adr_d = rt711_sdca_0_adr,
+	},
+	{
+		.mask = BIT(2),
+		.num_adr = ARRAY_SIZE(rt1316_2_single_adr),
+		.adr_d = rt1316_2_single_adr,
+	},
+	{}
+};
+
 static const struct snd_soc_acpi_adr_device mx8373_2_adr[] = {
 	{
 		.adr = 0x000223019F837300ull,
@@ -624,6 +638,12 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_adl_sdw_machines[] = {
 		.drv_name = "sof_sdw",
 		.sof_tplg_filename = "sof-adl-rt711-l0-rt1316-l3.tplg",
 	},
+	{
+		.link_mask = 0x5, /* 2 active links required */
+		.links = adl_sdw_rt711_link0_rt1316_link2,
+		.drv_name = "sof_sdw",
+		.sof_tplg_filename = "sof-adl-rt711-l0-rt1316-l2.tplg",
+	},
 	{
 		.link_mask = 0x1, /* link0 required */
 		.links = adl_rvp,
-- 
2.39.2



