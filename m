Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047137;
	b=USGP/c5UPYAVZ6SgZdXoeEQkzG0q+yJNFo5Jj2WsJ5/pSyWV21KXgYRRWH/uyjNbmbul
	 4shoXSlfhjoq2b14R935ejF7dkh8OUUHACI4rRODCzvBc335kAJrR7hQP7wO1SI0UGfVO
	 JB/0aspMuBkTBU+vekY6CXqfLpFgKXdrOay4IqxsojEwbRcQjCtW2FLiqLDMLsu3Mjvpa
	 tRgU2C9b4ucDx4/uwgie3m57tNJRABh2O7J/GET7OzJsOX+DHpgJHyfZndQ9Njd6fFLKD
	 7CSUHJki7ezqsxZawL3sUCQzIrnX3H5CENVsLRV914rRT2KNX0z4aDLoWrOopCoAfYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047137;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=EYsdUa354nNZNYrnmwhqMJo7n85e+SVMAb6WIz0A2YQ=;
	b=RyuZgjrBnOiNRYt+SVK3F2aWfSWeFWaq7dM2FetBqicu0/aMVMfNRhrBf3byqnjN9o/y
	 IkOABgUexq/YhhrCLgCE4+ITM7BUlzdONesJIC3vh3KXhDffHHRPLW5ZObjG+mYlWy3jA
	 TIWtCP3xWQnnnPF5pllUwQllhtPjuE5IZ4BxqEdtd4Vh2q6SYjDyifXSPLpvK1O3fXEKM
	 +4HCCn/iFBePI/oEwaEYsG2qD2MA5VY4M1Ft8+5UOjFyR25iQqUpQSS2PicF2PGwKBwYw
	 rkeC6SDXsKLmzKV7sawgcXKw1kV3hbXLeGwxo+CwatSRIFfDGPSFw4StdFj4WxmaXQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JGB2lcGs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0B1606A31C;
	Thu, 19 Nov 2026 00:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JGB2lcGs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CB51F000C4;
	Thu, 19 Nov 2026 00:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047136;
	bh=EYsdUa354nNZNYrnmwhqMJo7n85e+SVMAb6WIz0A2YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JGB2lcGs/ioeTLMy+Lbv2cSIyKITk7Dmo58vp4fsVX/myv5eezGbPSf92/h/vp5sN
	 0PBeFNprc9Z6YXXeX7x88vPuXIbdHSA+cbh+FLcytp53JtD9Ro7gfcFG8Gc5i04b+a
	 kimMWWIGO2iJ+5/fUeClnTJz3e4aDQJU9RhVcVOg=
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
Subject: [PATCH 6.1 1531/2857] ASoC: SOF: Intel: hda-codec: simplify SND_SOC_SOF_HDA_AUDIO_CODEC handling
Date: Wed, 18 Nov 2026 15:42:45 +0100
Message-ID: <20261118150256.447030217@linuxfoundation.org>
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

[ Upstream commit dc1d964a44dd9eb236f4e98b7b1eaa776093ca8b ]

Now that we have removed the dependency on SND_SOC_HDAC_HDMI, we can
simplify the code and make the code conditional on a single #ifdef.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20221027193540.259520-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 08a44bde821d ("ASoC: hdac_hda: Restore the codec device type on unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-codec.c | 37 +++++++++++----------------------
 sound/soc/sof/intel/hda.h       | 10 +++++++--
 2 files changed, 20 insertions(+), 27 deletions(-)

diff --git a/sound/soc/sof/intel/hda-codec.c b/sound/soc/sof/intel/hda-codec.c
index a95b04d420279..8603694710e0a 100644
--- a/sound/soc/sof/intel/hda-codec.c
+++ b/sound/soc/sof/intel/hda-codec.c
@@ -16,13 +16,12 @@
 #include <sound/sof.h>
 #include "../ops.h"
 #include "hda.h"
+
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC)
 #include "../../codecs/hdac_hda.h"
-#endif /* CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC */
 
 #define CODEC_PROBE_RETRIES	3
 
-#if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC)
 #define IDISP_VID_INTEL	0x80860000
 
 /* load the legacy HDA codec driver */
@@ -88,6 +87,7 @@ void hda_codec_jack_wake_enable(struct snd_sof_dev *sdev, bool enable)
 
 	snd_hdac_chip_updatew(bus, WAKEEN, STATESTS_INT_MASK, mask);
 }
+EXPORT_SYMBOL_NS(hda_codec_jack_wake_enable, SND_SOC_SOF_HDA_AUDIO_CODEC);
 
 /* check jack status after resuming from suspend mode */
 void hda_codec_jack_check(struct snd_sof_dev *sdev)
@@ -103,11 +103,6 @@ void hda_codec_jack_check(struct snd_sof_dev *sdev)
 		if (codec->jacktbl.used)
 			pm_request_resume(&codec->core.dev);
 }
-#else
-void hda_codec_jack_wake_enable(struct snd_sof_dev *sdev, bool enable) {}
-void hda_codec_jack_check(struct snd_sof_dev *sdev) {}
-#endif /* CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC */
-EXPORT_SYMBOL_NS(hda_codec_jack_wake_enable, SND_SOC_SOF_HDA_AUDIO_CODEC);
 EXPORT_SYMBOL_NS(hda_codec_jack_check, SND_SOC_SOF_HDA_AUDIO_CODEC);
 
 #if IS_ENABLED(CONFIG_SND_HDA_GENERIC)
@@ -135,10 +130,7 @@ static struct hda_codec *hda_codec_device_init(struct hdac_bus *bus, int addr, i
 /* probe individual codec */
 static int hda_codec_probe(struct snd_sof_dev *sdev, int address)
 {
-#if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC)
 	struct hdac_hda_priv *hda_priv;
-	int type = HDA_DEV_LEGACY;
-#endif
 	struct hda_bus *hbus = sof_to_hbus(sdev);
 	struct hda_codec *codec;
 	u32 hda_cmd = (address << 28) | (AC_NODE_ROOT << 20) |
@@ -158,12 +150,11 @@ static int hda_codec_probe(struct snd_sof_dev *sdev, int address)
 	dev_dbg(sdev->dev, "HDA codec #%d probed OK: response: %x\n",
 		address, resp);
 
-#if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC)
 	hda_priv = devm_kzalloc(sdev->dev, sizeof(*hda_priv), GFP_KERNEL);
 	if (!hda_priv)
 		return -ENOMEM;
 
-	codec = hda_codec_device_init(&hbus->core, address, type);
+	codec = hda_codec_device_init(&hbus->core, address, HDA_DEV_LEGACY);
 	ret = PTR_ERR_OR_ZERO(codec);
 	if (ret < 0)
 		return ret;
@@ -186,25 +177,19 @@ static int hda_codec_probe(struct snd_sof_dev *sdev, int address)
 	else
 		codec->probe_id = 0;
 
-	if (type == HDA_DEV_LEGACY) {
-		ret = hda_codec_load_module(codec);
-		/*
-		 * handle ret==0 (no driver bound) as an error, but pass
-		 * other return codes without modification
-		 */
-		if (ret == 0)
-			ret = -ENOENT;
-	}
+	ret = hda_codec_load_module(codec);
+	/*
+	 * handle ret==0 (no driver bound) as an error, but pass
+	 * other return codes without modification
+	 */
+	if (ret == 0)
+		ret = -ENOENT;
 
 out:
 	if (ret < 0) {
 		snd_hdac_device_unregister(&codec->core);
 		put_device(&codec->core.dev);
 	}
-#else
-	codec = hda_codec_device_init(&hbus->core, address, HDA_DEV_ASOC);
-	ret = PTR_ERR_OR_ZERO(codec);
-#endif
 
 	return ret;
 }
@@ -231,6 +216,8 @@ void hda_codec_probe_bus(struct snd_sof_dev *sdev)
 }
 EXPORT_SYMBOL_NS(hda_codec_probe_bus, SND_SOC_SOF_HDA_AUDIO_CODEC);
 
+#endif /* CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC */
+
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC) && IS_ENABLED(CONFIG_SND_HDA_CODEC_HDMI)
 
 void hda_codec_i915_display_power(struct snd_sof_dev *sdev, bool enable)
diff --git a/sound/soc/sof/intel/hda.h b/sound/soc/sof/intel/hda.h
index b032f4a4e232b..dc6b1a6e9508d 100644
--- a/sound/soc/sof/intel/hda.h
+++ b/sound/soc/sof/intel/hda.h
@@ -701,7 +701,7 @@ void hda_dsp_ctrl_stop_chip(struct snd_sof_dev *sdev);
  */
 void sof_hda_bus_init(struct hdac_bus *bus, struct device *dev);
 
-#if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA)
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC)
 /*
  * HDA Codec operations.
  */
@@ -709,7 +709,13 @@ void hda_codec_probe_bus(struct snd_sof_dev *sdev);
 void hda_codec_jack_wake_enable(struct snd_sof_dev *sdev, bool enable);
 void hda_codec_jack_check(struct snd_sof_dev *sdev);
 
-#endif /* CONFIG_SND_SOC_SOF_HDA */
+#else
+
+static inline void hda_codec_probe_bus(struct snd_sof_dev *sdev) { }
+static inline void hda_codec_jack_wake_enable(struct snd_sof_dev *sdev, bool enable) { }
+static inline void hda_codec_jack_check(struct snd_sof_dev *sdev) { }
+
+#endif /* CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC */
 
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC) && IS_ENABLED(CONFIG_SND_HDA_CODEC_HDMI)
 
-- 
2.53.0



