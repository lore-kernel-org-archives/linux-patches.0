Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0BC4F85CB;
	Wed, 30 Sep 2026 16:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785268; cv=none; b=JZOjfrwDWS49Jqr79HnTckMkeI1Zp6jYu82D6vXrGjLqlxhy98TzvGBkrcyY6L1f7CXzlZ6AO0SPf09PI/l8Sp2nxL/YOvfFcqcQjWnQlMJnxTne/mgUDfW9uPtLCw6C3gZarrmWnhTZsZx833BWpDbqrMKAGsvmR8Q6c5uWmsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785268; c=relaxed/simple;
	bh=swEAOJioaP5TCy6J+HgxJwAdaSgvN2SnYbOLyxPOhOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KGN2+lOkQRFRGOd62GN9ErZrkEPBie70spIIMxKhPrlAFXSGcH71XA7W7Osp7I25XPpo7qZ2KVSBb/nwE2ZkVU/KoJuVbvr5cUhERy+TfkqItDTgMHjlHyimHKdxSikvk8GcST5NDQDugZoAu2jyiJyQiJzO0kebkCuEVgQEmNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e5WM8J8w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5WM8J8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5729B1F0089A;
	Wed, 30 Sep 2026 16:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785262;
	bh=l7yuRfRtdt9s1vUBOolNa0n02+aaONfOBHx8gHE+4Zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e5WM8J8wXxU/qbTSbbhR0RIYSt41xvrraGjW+cdLqWi+AHMYsRZh2zUNLj/n5FiwV
	 +bMbIwOs/FuUBLA4dnYuK/JZbhY2qIaE+uOXsjR0fsLjrCSILgIMWTRuVxKx92uy5M
	 33RewC2v+7OPeAk34H+hI9x0Z4Q2I1+V9BPSFZRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 402/982] ALSA/ASoC: hda: ext: add ext prefix to snd_hdac_link_free_all
Date: Wed, 30 Sep 2026 17:18:58 +0200
Message-ID: <20260930152425.445472455@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 7f05ca9a7467f05b8703b37bdc1ddddd0e9f8876 ]

No functionality change, just prefix addition to clearly identify that
the helper only applies to the 'ext' part for Intel platforms.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20221019162115.185917-6-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 559ea14b7ae7 ("ASoC: Intel: avs: Clean up the bus when fetching ML caps fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hdaudio_ext.h         | 2 +-
 sound/hda/ext/hdac_ext_controller.c | 6 +++---
 sound/soc/intel/avs/core.c          | 2 +-
 sound/soc/intel/skylake/skl.c       | 2 +-
 sound/soc/sof/intel/hda.c           | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/sound/hdaudio_ext.h b/include/sound/hdaudio_ext.h
index 83aed26ab1433..9c1ec992ab53e 100644
--- a/include/sound/hdaudio_ext.h
+++ b/include/sound/hdaudio_ext.h
@@ -80,7 +80,7 @@ struct hdac_ext_stream {
 int snd_hdac_ext_stream_init_all(struct hdac_bus *bus, int start_idx,
 				 int num_stream, int dir);
 void snd_hdac_ext_stream_free_all(struct hdac_bus *bus);
-void snd_hdac_link_free_all(struct hdac_bus *bus);
+void snd_hdac_ext_link_free_all(struct hdac_bus *bus);
 struct hdac_ext_stream *snd_hdac_ext_stream_assign(struct hdac_bus *bus,
 					   struct snd_pcm_substream *substream,
 					   int type);
diff --git a/sound/hda/ext/hdac_ext_controller.c b/sound/hda/ext/hdac_ext_controller.c
index 80876b9a87f46..a2dae3abd541d 100644
--- a/sound/hda/ext/hdac_ext_controller.c
+++ b/sound/hda/ext/hdac_ext_controller.c
@@ -108,12 +108,12 @@ int snd_hdac_ext_bus_get_ml_capabilities(struct hdac_bus *bus)
 EXPORT_SYMBOL_GPL(snd_hdac_ext_bus_get_ml_capabilities);
 
 /**
- * snd_hdac_link_free_all- free hdac extended link objects
+ * snd_hdac_ext_link_free_all- free hdac extended link objects
  *
  * @bus: the pointer to HDAC bus object
  */
 
-void snd_hdac_link_free_all(struct hdac_bus *bus)
+void snd_hdac_ext_link_free_all(struct hdac_bus *bus)
 {
 	struct hdac_ext_link *l;
 
@@ -123,7 +123,7 @@ void snd_hdac_link_free_all(struct hdac_bus *bus)
 		kfree(l);
 	}
 }
-EXPORT_SYMBOL_GPL(snd_hdac_link_free_all);
+EXPORT_SYMBOL_GPL(snd_hdac_ext_link_free_all);
 
 /**
  * snd_hdac_ext_bus_link_at - get link at specified address
diff --git a/sound/soc/intel/avs/core.c b/sound/soc/intel/avs/core.c
index 04d0099adb8fb..44e5d2ed2b95a 100644
--- a/sound/soc/intel/avs/core.c
+++ b/sound/soc/intel/avs/core.c
@@ -528,7 +528,7 @@ static void avs_pci_remove(struct pci_dev *pci)
 	snd_hdac_bus_free_stream_pages(bus);
 	snd_hdac_ext_stream_free_all(bus);
 	/* reverse ml_capabilities */
-	snd_hdac_link_free_all(bus);
+	snd_hdac_ext_link_free_all(bus);
 	snd_hdac_ext_bus_exit(bus);
 
 	avs_dsp_core_disable(adev, GENMASK(adev->hw_cfg.dsp_cores - 1, 0));
diff --git a/sound/soc/intel/skylake/skl.c b/sound/soc/intel/skylake/skl.c
index 7f058acd221f0..3d8cb8cb533b9 100644
--- a/sound/soc/intel/skylake/skl.c
+++ b/sound/soc/intel/skylake/skl.c
@@ -445,7 +445,7 @@ static int skl_free(struct hdac_bus *bus)
 		free_irq(bus->irq, (void *)bus);
 	snd_hdac_bus_free_stream_pages(bus);
 	snd_hdac_ext_stream_free_all(bus);
-	snd_hdac_link_free_all(bus);
+	snd_hdac_ext_link_free_all(bus);
 
 	if (bus->remap_addr)
 		iounmap(bus->remap_addr);
diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index 63764afdcf617..b7d6a54bbb634 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -1224,7 +1224,7 @@ int hda_dsp_remove(struct snd_sof_dev *sdev)
 
 	hda_dsp_stream_free(sdev);
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA)
-	snd_hdac_link_free_all(bus);
+	snd_hdac_ext_link_free_all(bus);
 #endif
 
 	iounmap(sdev->bar[HDA_DSP_BAR]);
-- 
2.53.0



