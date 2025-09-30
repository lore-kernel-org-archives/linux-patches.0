Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39878306B08;
	Tue, 30 Sep 2025 15:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244505; cv=none; b=EHu6u/U4uePDmUBzQjWW6TICaJqpZA1d3okjJfRq79IjQ1ndm88to0KjJfgQ3kI5+Htb7cMI0YgtTVJ6TEPXO2IE9gvSSF3IIeQO/wRBN5w0cXLSpgtv27zQ3Fi2GwoT6AOPovb2xhz0dvLBmpec3y4Zcgs5JRinoWCouloojTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244505; c=relaxed/simple;
	bh=7HrMW2tW7czg5MqY+NNGAGCxiezZ4ZVLlGnX/7VJMYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3KEUr1PfmD99u9D4gr9yQCi5Uj68v7ghx4UZu6Zo31XkQewbJM10dD/S4K5jXyt/PGnYoBa7kyGwq+RiHk2raouuQt/XJcpL8bm+G2jEN7vuUXRsEgxzSueKcZYR7oq/4ZWHBSLgev7iYHRI4A2CEes6wxlQBdcLaVDXQtz2iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ahdecxrd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ahdecxrd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80592C4CEF0;
	Tue, 30 Sep 2025 15:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244504;
	bh=7HrMW2tW7czg5MqY+NNGAGCxiezZ4ZVLlGnX/7VJMYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AhdecxrdZ6Xass/iG3ArpmMOwfKFTjRsWea/pxjk4fDX16AGl3gcg/dTk21c82+ma
	 DvDQ7W3WyZ9l2KzBboJPlnQFOIAEhqYO848SJJbt21bZvQOjOWBK22ksWumNO1qhYZ
	 stSaD+SRn0xcKTf+gRPtwDmZDA3zP+r7fufVAjkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balamurugan C <balamurugan.c@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 028/143] ASoC: Intel: sof_rt5682: Add HDMI-In capture with rt5682 support for PTL.
Date: Tue, 30 Sep 2025 16:45:52 +0200
Message-ID: <20250930143832.365762838@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balamurugan C <balamurugan.c@intel.com>

[ Upstream commit 03aa2ed9e187e42f25b3871b691d535fc19156c4 ]

Added match table entry on ptl machines to support HDMI-In capture
with rt5682 I2S audio codec. also added the respective quirk
configuration in rt5682 machine driver.

Signed-off-by: Balamurugan C <balamurugan.c@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20250716082300.1810352-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_rt5682.c               | 7 +++++++
 sound/soc/intel/common/soc-acpi-intel-ptl-match.c | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/sound/soc/intel/boards/sof_rt5682.c b/sound/soc/intel/boards/sof_rt5682.c
index f5925bd0a3fc6..4994aaccc583a 100644
--- a/sound/soc/intel/boards/sof_rt5682.c
+++ b/sound/soc/intel/boards/sof_rt5682.c
@@ -892,6 +892,13 @@ static const struct platform_device_id board_ids[] = {
 					SOF_SSP_PORT_BT_OFFLOAD(2) |
 					SOF_BT_OFFLOAD_PRESENT),
 	},
+	{
+		.name = "ptl_rt5682_c1_h02",
+		.driver_data = (kernel_ulong_t)(SOF_RT5682_MCLK_EN |
+					SOF_SSP_PORT_CODEC(1) |
+					/* SSP 0 and SSP 2 are used for HDMI IN */
+					SOF_SSP_MASK_HDMI_CAPTURE(0x5)),
+	},
 	{ }
 };
 MODULE_DEVICE_TABLE(platform, board_ids);
diff --git a/sound/soc/intel/common/soc-acpi-intel-ptl-match.c b/sound/soc/intel/common/soc-acpi-intel-ptl-match.c
index 67f1091483dce..d90d8672ab77d 100644
--- a/sound/soc/intel/common/soc-acpi-intel-ptl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-ptl-match.c
@@ -32,6 +32,13 @@ static const struct snd_soc_acpi_codecs ptl_lt6911_hdmi = {
 };
 
 struct snd_soc_acpi_mach snd_soc_acpi_intel_ptl_machines[] = {
+	{
+		.comp_ids = &ptl_rt5682_rt5682s_hp,
+		.drv_name = "ptl_rt5682_c1_h02",
+		.machine_quirk = snd_soc_acpi_codec_list,
+		.quirk_data = &ptl_lt6911_hdmi,
+		.sof_tplg_filename = "sof-ptl-rt5682-ssp1-hdmi-ssp02.tplg",
+	},
 	{
 		.comp_ids = &ptl_rt5682_rt5682s_hp,
 		.drv_name = "ptl_rt5682_def",
-- 
2.51.0



