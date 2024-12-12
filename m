Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA402EAE5;
	Thu, 12 Dec 2024 15:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016680; cv=none; b=SX3rTNGylzBSSIJAu7VRfXQ32OWBlJSufnf2+q0H5nc3ZGvbvZexYsNHIkb/Hyfsi+qvGEMnI1bEgyVE1SA9Is64maNIhVFh9qJctmWHzwIXu+xMYZFptAKZdQjwqVcCr4oIvJsrKHjSmpbbRf1/Tygj4KBu4gBmkwTXZEseeQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016680; c=relaxed/simple;
	bh=edUPj1ynblmpy/izSsG39R9bOiMbEQNa6esSaNq0qHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ax7gBvOiGlJ3Cfc99yacjHUHGQbbsCJLOxzk16APNmIPMl4aOS+werulbILBcJknKvUcj+4qpC48oRb6NQ0du//ZKjGJ5wpmI0OJalFlViEj9BHiEqfrnyfXr7/zXI8jIJrq69ay+36lCFg3CJ48M2lnb5QiZwXA31xIt3o8ZHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/yp2Gsx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/yp2Gsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FC5C4CECE;
	Thu, 12 Dec 2024 15:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016680;
	bh=edUPj1ynblmpy/izSsG39R9bOiMbEQNa6esSaNq0qHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k/yp2Gsxrdp5dNYNFiQgIuHggqn34sS91tAjb0XuJR8IyIJjxsjXwOmDvG2B5f3s5
	 3wMze9znuYt+4D8B1ofwyNEjvxOZhLqQIlcGpk1oU3fjXCULjnltBt+1VuD+Ji6tv5
	 JmVa37x5ySMc0ZOkJRoe2minn6pgWP4rwxaNFrpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balamurugan C <balamurugan.c@intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 268/466] ASoC: Intel: sof_rt5682: Add HDMI-In capture with rt5682 support for MTL.
Date: Thu, 12 Dec 2024 15:57:17 +0100
Message-ID: <20241212144317.377956912@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balamurugan C <balamurugan.c@intel.com>

[ Upstream commit 0f5d2228a99a4733b2a6652e16255be9caf2616a ]

Added match table entry on mtl machines to support HDMI-In capture
with rt5682 I2S audio codec. also added the respective quirk
configuration in rt5682 machine driver.

Signed-off-by: Balamurugan C <balamurugan.c@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20241004030135.67968-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_rt5682.c               | 7 +++++++
 sound/soc/intel/common/soc-acpi-intel-mtl-match.c | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/sound/soc/intel/boards/sof_rt5682.c b/sound/soc/intel/boards/sof_rt5682.c
index bc581fea0e3a1..866589fece7a3 100644
--- a/sound/soc/intel/boards/sof_rt5682.c
+++ b/sound/soc/intel/boards/sof_rt5682.c
@@ -870,6 +870,13 @@ static const struct platform_device_id board_ids[] = {
 					SOF_SSP_PORT_BT_OFFLOAD(2) |
 					SOF_BT_OFFLOAD_PRESENT),
 	},
+	{
+		.name = "mtl_rt5682_c1_h02",
+		.driver_data = (kernel_ulong_t)(SOF_RT5682_MCLK_EN |
+					SOF_SSP_PORT_CODEC(1) |
+					/* SSP 0 and SSP 2 are used for HDMI IN */
+					SOF_SSP_MASK_HDMI_CAPTURE(0x5)),
+	},
 	{
 		.name = "arl_rt5682_c1_h02",
 		.driver_data = (kernel_ulong_t)(SOF_RT5682_MCLK_EN |
diff --git a/sound/soc/intel/common/soc-acpi-intel-mtl-match.c b/sound/soc/intel/common/soc-acpi-intel-mtl-match.c
index d4435a34a3a3f..fd02c864e25ef 100644
--- a/sound/soc/intel/common/soc-acpi-intel-mtl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-mtl-match.c
@@ -42,6 +42,13 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_mtl_machines[] = {
 					SND_SOC_ACPI_TPLG_INTEL_SSP_MSB |
 					SND_SOC_ACPI_TPLG_INTEL_DMIC_NUMBER,
 	},
+	{
+		.comp_ids = &mtl_rt5682_rt5682s_hp,
+		.drv_name = "mtl_rt5682_c1_h02",
+		.machine_quirk = snd_soc_acpi_codec_list,
+		.quirk_data = &mtl_lt6911_hdmi,
+		.sof_tplg_filename = "sof-mtl-rt5682-ssp1-hdmi-ssp02.tplg",
+	},
 	/* place boards for each headphone codec: sof driver will complete the
 	 * tplg name and machine driver will detect the amp type
 	 */
-- 
2.43.0



