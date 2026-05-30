Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E96226738C;
	Sat, 30 May 2026 18:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166308; cv=none; b=O2TZxl5N8/rGFNPCuX33+L38kj62RsZoVQnYHDE58a9dRUVHnrxQVUI7HMwHS0x12Dgq74NEaEJRR03dme2ijV2mt2mT/PHpabAObrQ86dDUaSOSfiUwIgOEIU4Ba3tHnxkxfyCpYwyJX2L5bIeXtLvGQpS/dVjoNAuLsferaTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166308; c=relaxed/simple;
	bh=BtOjaUMbRVOOlSsfMfLnuElHMXZtPz1v7TwA5m7T1lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bG5BsCVqvgb8RKSnMwbNCF5C/qbdrmJaj5MuWt/eA9dT1WiPziBG1fwPYK1HhHiu+nl1Ey6eryJXv4C2rIy1oBldGz//xz2g5WpHIjU2KFZhhDxLr61dgUkduut0uTpAW6gRR9v10cZfDz80orNRYylnrU1kdHEqq67eCdviBII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUTyvEiT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUTyvEiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728C31F00893;
	Sat, 30 May 2026 18:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166307;
	bh=Ba/2fltFEUvEV4ACbv6/8abZwQ5MGxxkqX41coqsBpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sUTyvEiTfNNWdRRuzYDMnaOLFbeuOs1APttMyYZ8fRCFjKwJ/Ar0JgsGax+x6/4K+
	 JXyFFOMdyNjYTUW48PopPRM0dpS+0dqR8zlkp304Odae5wXfTEyK+jY15YBZn2QATC
	 BFF33SAED2B4IRdDxmelP3Rs3KiGMmRSzA1yBaew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinod Koul <vkoul@kernel.org>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 335/589] ALSA: compress: Drop unused functions
Date: Sat, 30 May 2026 18:03:36 +0200
Message-ID: <20260530160233.708664179@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit fc93c96fe34e10b873fef73e80cee52503f3a679 ]

snd_compress_register() and snd_compress_deregister() API functions
have been never used by in-tree drivers.
Let's clean up the dead code.

Acked-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20210714162424.4412-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 796e119e9b14 ("ALSA: core: Validate compress device numbers without dynamic minors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/compress_driver.h |  2 -
 sound/core/compress_offload.c   | 68 ---------------------------------
 2 files changed, 70 deletions(-)

diff --git a/include/sound/compress_driver.h b/include/sound/compress_driver.h
index 70cbc5095e725..c74bf9931fb33 100644
--- a/include/sound/compress_driver.h
+++ b/include/sound/compress_driver.h
@@ -161,8 +161,6 @@ struct snd_compr {
 };
 
 /* compress device register APIs */
-int snd_compress_register(struct snd_compr *device);
-int snd_compress_deregister(struct snd_compr *device);
 int snd_compress_new(struct snd_card *card, int device,
 			int type, const char *id, struct snd_compr *compr);
 
diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index c1fec932c49d1..8d1f71a621787 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -47,8 +47,6 @@
  *	driver should be able to register multiple nodes
  */
 
-static DEFINE_MUTEX(device_mutex);
-
 struct snd_compr_file {
 	unsigned long caps;
 	struct snd_compr_stream stream;
@@ -1170,72 +1168,6 @@ int snd_compress_new(struct snd_card *card, int device,
 }
 EXPORT_SYMBOL_GPL(snd_compress_new);
 
-static int snd_compress_add_device(struct snd_compr *device)
-{
-	int ret;
-
-	if (!device->card)
-		return -EINVAL;
-
-	/* register the card */
-	ret = snd_card_register(device->card);
-	if (ret)
-		goto out;
-	return 0;
-
-out:
-	pr_err("failed with %d\n", ret);
-	return ret;
-
-}
-
-static int snd_compress_remove_device(struct snd_compr *device)
-{
-	return snd_card_free(device->card);
-}
-
-/**
- * snd_compress_register - register compressed device
- *
- * @device: compressed device to register
- */
-int snd_compress_register(struct snd_compr *device)
-{
-	int retval;
-
-	if (device->name == NULL || device->ops == NULL)
-		return -EINVAL;
-
-	pr_debug("Registering compressed device %s\n", device->name);
-	if (snd_BUG_ON(!device->ops->open))
-		return -EINVAL;
-	if (snd_BUG_ON(!device->ops->free))
-		return -EINVAL;
-	if (snd_BUG_ON(!device->ops->set_params))
-		return -EINVAL;
-	if (snd_BUG_ON(!device->ops->trigger))
-		return -EINVAL;
-
-	mutex_init(&device->lock);
-
-	/* register a compressed card */
-	mutex_lock(&device_mutex);
-	retval = snd_compress_add_device(device);
-	mutex_unlock(&device_mutex);
-	return retval;
-}
-EXPORT_SYMBOL_GPL(snd_compress_register);
-
-int snd_compress_deregister(struct snd_compr *device)
-{
-	pr_debug("Removing compressed device %s\n", device->name);
-	mutex_lock(&device_mutex);
-	snd_compress_remove_device(device);
-	mutex_unlock(&device_mutex);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(snd_compress_deregister);
-
 MODULE_DESCRIPTION("ALSA Compressed offload framework");
 MODULE_AUTHOR("Vinod Koul <vinod.koul@linux.intel.com>");
 MODULE_LICENSE("GPL v2");
-- 
2.53.0



