Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047134;
	b=TKbO9m+V+e2ba0bGFa+Kl9pBArrfW3yIJQeHP/5R5F8Rt2E7rsaae9XJkisS6unMCN/2
	 4H1xqkROFQddp6H1zwcWr8iso6LTiaetd4ZhQbzUXt/3tcTDhZ3n+8r6CVg2N0eKaT9GQ
	 26LWkogEGopWTfJ5qSnyNNlkjcCl570BHg4kfF2q0y61/eNvaPsRfWpqVf+nSPUPvPnfs
	 QcmwrMiDKCrWdZZe7a5LYNhcl8/h1T7Qrt+3sq7Q2QBV5Eguamz0bfxippjWiNWmkpX1S
	 huZt0PvX8OXaq3XdLZJQS9Kl9HM3vxWt4VPtOaxbvc2KSRSSbT1fD1xayqjWtwY+xag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047134;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=1AD+giNrNEEhhL5VroMoCo+7uxd01p9hA1W2AK6A6HQ=;
	b=m0NYjDJX9I9PNpI1WyRGqEB/9HsbHBKxLMffDNkk7H0rt9PseBPmqVizAOC4C+H1GBhp
	 OpFRFnM4rMhAnxXOjdSbWxCZidyUmMf+tcJf5U/5zP2702ScjHD3RsV6mZTbKqj0qYvVU
	 VFQVz20FTcanlToPLYRyi8+GNjKIhDbwE3wKY517+k8kNryQVXDfl0Sbb7d4+KI1V+xPv
	 4GABBvE65+LRYwJ/had4Pbr+1w2EyYJji1qQe1Supyln+ut1DYCOgtMrlMyt4HMOhJF7s
	 ee1aAUrWo0aKoJz/YQYrR5769OdhglZ0+E8R7uo87ENdOFIOFUoEOl4UV2GXnys9duQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="OMJ/BJ/c";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7A8606A31C;
	Thu, 19 Nov 2026 00:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OMJ/BJ/c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8519B1F000C4;
	Thu, 19 Nov 2026 00:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047134;
	bh=1AD+giNrNEEhhL5VroMoCo+7uxd01p9hA1W2AK6A6HQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OMJ/BJ/cR7L1XEcndTOuGBpWMxn3RBa6XRl/Dee8/X8LWkVUpCzKRGGQPs/O70uly
	 7tzkA8Os0MzvuGmqSfV1Knjq++LS+CoChHjqyyKN8vbCjhn9RqIraOxmj+bQzEpFRY
	 OhUku23HznP9ZLoirvpD4xSvfGKoCCjMffAQAhg8=
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
Subject: [PATCH 6.1 1530/2857] ASoC: SOF: Intel: remove all dependencies on SND_SOC_HDAC_HDMI
Date: Wed, 18 Nov 2026 15:42:44 +0100
Message-ID: <20261118150256.410637616@linuxfoundation.org>
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

[ Upstream commit 2c6c809cc00b71b3195d76a69d603cc761716ab7 ]

remove all dependencies on SND_SOC_HDAC_HDMI and
clean-up ifdefs. The machine driver still supports this configuration
used by the Skylake driver.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20221027193540.259520-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 08a44bde821d ("ASoC: hdac_hda: Restore the codec device type on unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-codec.c | 3 +--
 sound/soc/sof/intel/hda.h       | 4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/sound/soc/sof/intel/hda-codec.c b/sound/soc/sof/intel/hda-codec.c
index 5827747cce2ae..a95b04d420279 100644
--- a/sound/soc/sof/intel/hda-codec.c
+++ b/sound/soc/sof/intel/hda-codec.c
@@ -231,8 +231,7 @@ void hda_codec_probe_bus(struct snd_sof_dev *sdev)
 }
 EXPORT_SYMBOL_NS(hda_codec_probe_bus, SND_SOC_SOF_HDA_AUDIO_CODEC);
 
-#if IS_ENABLED(CONFIG_SND_HDA_CODEC_HDMI) || \
-	IS_ENABLED(CONFIG_SND_SOC_HDAC_HDMI)
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC) && IS_ENABLED(CONFIG_SND_HDA_CODEC_HDMI)
 
 void hda_codec_i915_display_power(struct snd_sof_dev *sdev, bool enable)
 {
diff --git a/sound/soc/sof/intel/hda.h b/sound/soc/sof/intel/hda.h
index a4737c8e4fcb3..b032f4a4e232b 100644
--- a/sound/soc/sof/intel/hda.h
+++ b/sound/soc/sof/intel/hda.h
@@ -711,9 +711,7 @@ void hda_codec_jack_check(struct snd_sof_dev *sdev);
 
 #endif /* CONFIG_SND_SOC_SOF_HDA */
 
-#if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA) && \
-	(IS_ENABLED(CONFIG_SND_HDA_CODEC_HDMI) || \
-	 IS_ENABLED(CONFIG_SND_SOC_HDAC_HDMI))
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC) && IS_ENABLED(CONFIG_SND_HDA_CODEC_HDMI)
 
 void hda_codec_i915_display_power(struct snd_sof_dev *sdev, bool enable);
 int hda_codec_i915_init(struct snd_sof_dev *sdev);
-- 
2.53.0



