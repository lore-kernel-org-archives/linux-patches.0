Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047131;
	b=hmfT449XpL87ZTlJW3qFfXvY7j18ou8SAnhbPPAlOBmR9JSlxJ8Z0BbZUXr3Mcv4YJ4P
	 tZF+RhOmPeVBjpf0UgqoVEmotONGOmlPRpQb9RknifWALOK/q+05Xe7u3TD9UTdPFZILj
	 sFjmQ+GWf4vd5YBTQQGUaD/ypSc0d6dtwcD0Umgfa9/xp1+b/fkhl2gz0/jFxa5zrUEgW
	 wId6RasTsYQ1ihSgxjEgfTEcYCVEmtI6GyLs8ebwmU5PE7N0ayIteTNpOPLYT2yZQtXfs
	 f/DW2Uqym0oufW7PZlCdwuD/t6RMK0+Qx3VoR/Dj4r5XHugcQEDSEKRoLMQjelOc/jA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047131;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qsn6Eu3lWhh0Lj096T1xYBImQOXzjZklzaiXvRIkdmI=;
	b=pMua+aLyaPfperAOZ4vRomtTNNKP1fbbmcwRVsdGRw11XIoj4gDgzuikXNw7i62KhO7v
	 o+S/i7n/DyPzySLnw3TYYmy3d6/EoX69EZpsJuxEEFBq+cEhlVT3dQfVIEUVMg4d0ct8F
	 au+RjJWiGjPLpac/CfRy3vT54E+8r4VKmleyp05NBvJaX4Xo4VftTrr36W9m9mqzEMGiI
	 AUslTQrXfoe+jHTsDwyXF3Mn3MYsnU8zheibm+mppFucf8pc/h8bfA4B5rFloW6kI4Yzo
	 24SWeTKP8OmJnVqrxnpevWygOiWgcyPgUjJ/evN3DMmhzJjiCUZnHRePvA+oWNRtd7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2INBE4x2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFD8606A320;
	Thu, 19 Nov 2026 00:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2INBE4x2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7A01F000C4;
	Thu, 19 Nov 2026 00:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047131;
	bh=qsn6Eu3lWhh0Lj096T1xYBImQOXzjZklzaiXvRIkdmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2INBE4x2SfcA5k9eGtDD3psAJ0SalULpmp5RTLkQ5gavEP7QX2QNxFmQcLcLacTCV
	 /wclWA1054Qjaq2RdXmenySIIi9YT33WKmFS6C466YKla71dl/T7Y4Rz0nOWuQe4B5
	 rpP6/f1GiuMNNrhrvyghHHFSQDkBYEP00NdxPUxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1529/2857] ASoC: SOF: Intel: remove option to disable the common_hdmi handling
Date: Wed, 18 Nov 2026 15:42:43 +0100
Message-ID: <20261118150256.376030924@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 834c69d3b849625d5c5bb81a3425fc8deef5f16d ]

We've been using the same option for quite some time now, it's time to
remove the kernel parameter to disable the common HDaudio codec
handling.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20221027193540.259520-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 08a44bde821d ("ASoC: hdac_hda: Restore the codec device type on unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-codec.c | 12 +++---------
 sound/soc/sof/intel/hda.c       | 10 ++--------
 sound/soc/sof/intel/hda.h       |  6 ++----
 3 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/sound/soc/sof/intel/hda-codec.c b/sound/soc/sof/intel/hda-codec.c
index a75f81116643b..5827747cce2ae 100644
--- a/sound/soc/sof/intel/hda-codec.c
+++ b/sound/soc/sof/intel/hda-codec.c
@@ -133,8 +133,7 @@ static struct hda_codec *hda_codec_device_init(struct hdac_bus *bus, int addr, i
 }
 
 /* probe individual codec */
-static int hda_codec_probe(struct snd_sof_dev *sdev, int address,
-			   bool hda_codec_use_common_hdmi)
+static int hda_codec_probe(struct snd_sof_dev *sdev, int address)
 {
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC)
 	struct hdac_hda_priv *hda_priv;
@@ -164,10 +163,6 @@ static int hda_codec_probe(struct snd_sof_dev *sdev, int address,
 	if (!hda_priv)
 		return -ENOMEM;
 
-	/* only probe ASoC codec drivers for HDAC-HDMI */
-	if (!hda_codec_use_common_hdmi && (resp & 0xFFFF0000) == IDISP_VID_INTEL)
-		type = HDA_DEV_ASOC;
-
 	codec = hda_codec_device_init(&hbus->core, address, type);
 	ret = PTR_ERR_OR_ZERO(codec);
 	if (ret < 0)
@@ -215,8 +210,7 @@ static int hda_codec_probe(struct snd_sof_dev *sdev, int address,
 }
 
 /* Codec initialization */
-void hda_codec_probe_bus(struct snd_sof_dev *sdev,
-			 bool hda_codec_use_common_hdmi)
+void hda_codec_probe_bus(struct snd_sof_dev *sdev)
 {
 	struct hdac_bus *bus = sof_to_bus(sdev);
 	int i, ret;
@@ -227,7 +221,7 @@ void hda_codec_probe_bus(struct snd_sof_dev *sdev,
 		if (!(bus->codec_mask & (1 << i)))
 			continue;
 
-		ret = hda_codec_probe(sdev, i, hda_codec_use_common_hdmi);
+		ret = hda_codec_probe(sdev, i);
 		if (ret < 0) {
 			dev_warn(bus->dev, "codec #%d probe error, ret: %d\n",
 				 i, ret);
diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index 4ba7c4be670dd..dbbc78d65e46e 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -388,12 +388,6 @@ static int mclk_id_override = -1;
 module_param_named(mclk_id, mclk_id_override, int, 0444);
 MODULE_PARM_DESC(mclk_id, "SOF SSP mclk_id");
 
-#if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA)
-static bool hda_codec_use_common_hdmi = IS_ENABLED(CONFIG_SND_HDA_CODEC_HDMI);
-module_param_named(use_common_hdmi, hda_codec_use_common_hdmi, bool, 0444);
-MODULE_PARM_DESC(use_common_hdmi, "SOF HDA use common HDMI codec driver");
-#endif
-
 static const struct hda_dsp_msg_code hda_dsp_rom_fw_error_texts[] = {
 	{HDA_DSP_ROM_CSE_ERROR, "error: cse error"},
 	{HDA_DSP_ROM_CSE_WRONG_RESPONSE, "error: cse wrong response"},
@@ -924,7 +918,7 @@ static int hda_init_caps(struct snd_sof_dev *sdev)
 		snd_hdac_ext_bus_get_ml_capabilities(bus);
 
 	/* create codec instances */
-	hda_codec_probe_bus(sdev, hda_codec_use_common_hdmi);
+	hda_codec_probe_bus(sdev);
 
 	if (!HDA_IDISP_CODEC(bus->codec_mask))
 		hda_codec_i915_display_power(sdev, false);
@@ -1340,7 +1334,7 @@ static void hda_generic_machine_select(struct snd_sof_dev *sdev,
 	if (*mach) {
 		mach_params = &(*mach)->mach_params;
 		mach_params->codec_mask = bus->codec_mask;
-		mach_params->common_hdmi_codec_drv = hda_codec_use_common_hdmi;
+		mach_params->common_hdmi_codec_drv = true;
 	}
 }
 #else
diff --git a/sound/soc/sof/intel/hda.h b/sound/soc/sof/intel/hda.h
index 773df987d6473..a4737c8e4fcb3 100644
--- a/sound/soc/sof/intel/hda.h
+++ b/sound/soc/sof/intel/hda.h
@@ -705,8 +705,7 @@ void sof_hda_bus_init(struct hdac_bus *bus, struct device *dev);
 /*
  * HDA Codec operations.
  */
-void hda_codec_probe_bus(struct snd_sof_dev *sdev,
-			 bool hda_codec_use_common_hdmi);
+void hda_codec_probe_bus(struct snd_sof_dev *sdev);
 void hda_codec_jack_wake_enable(struct snd_sof_dev *sdev, bool enable);
 void hda_codec_jack_check(struct snd_sof_dev *sdev);
 
@@ -722,8 +721,7 @@ int hda_codec_i915_exit(struct snd_sof_dev *sdev);
 
 #else
 
-static inline void hda_codec_i915_display_power(struct snd_sof_dev *sdev,
-						bool enable) { }
+static inline void hda_codec_i915_display_power(struct snd_sof_dev *sdev, bool enable) { }
 static inline int hda_codec_i915_init(struct snd_sof_dev *sdev) { return 0; }
 static inline int hda_codec_i915_exit(struct snd_sof_dev *sdev) { return 0; }
 
-- 
2.53.0



