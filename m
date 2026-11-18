Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059483;
	b=znXKKNY0fnZA+cDxoLqAF1w9uSWzRfL1PHVqaNn/64S6dI0AGCtq51peHqrEI0ZIub6N
	 4YONoowPO9jVq2IBB1ZAtGz/it3wbt8H/3oWKlBv/xyA/YCAY5QlMoGOXiOfYVmwzFRgy
	 0IPI6tuPqSysH4lm0Mn0nNxhXiXMvvT3SfxEEnngNpUPrB4UF/yll28MSjtMqHrMS+Uq4
	 cJlJa+opEb0ruOyiiE0kaCvb6emJemWrYddGNj1wVAlDC87SPOb8tD7n7KHRTIjW3UIf2
	 ZPXn+vRiYnz4p03iocmhIBdEYhjN/CxYpoipWVUio3IyRjJAVFBI4kqfEvMtEv+RPcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BVsK1q10pibHlM09YH1arDG6ZbgV9V+XQTaqtuGfbTc=;
	b=E9PN0pRaOozDWUKKr3L1pVU9j2Cr1ZSO9xpvCok8ok2XCiWhtiSERNfb6ArrOmBiqntY
	 fFRMV8CVJFYCsxpmd1zK8rsCe7ras4ocK2aaF8/YZUJZ5kfz3YFfT+kVcRXDp5eHygn1z
	 EPKh/f29FzEsB739IWzKMHSp56ODFsBoBsHQrerPlC/ezbLMLpZOmXRFdihK2wIPec8MG
	 ZPQ6kF4ABcPcu+1uPLwK22GyS7/Q3Ih8lNUBsmqCJqJzR6mgj+GVuC37bvlFL+qRGSfUa
	 1S/L9X3P2OAbXUQ14D3J8GhyK8u933DPc3K8wLSYI2KIzn/HnQ0U+kRtxH9slA0QDfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=obJIXotS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1F0606A326;
	Thu, 19 Nov 2026 03:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=obJIXotS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5F11F000C4;
	Thu, 19 Nov 2026 03:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059483;
	bh=BVsK1q10pibHlM09YH1arDG6ZbgV9V+XQTaqtuGfbTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=obJIXotSamw7REoWe2qHBVkQMkniVVRW6JIODu8qzV+vM2N/Dns4fNTXQi/aGopiH
	 gIpx0D+oVkjYardL+MVtUBAe8/R6o4XEug7ipr8uJmsZzTVVO6Qqv2Ib7EGMbIATbk
	 JqJ4Fsk2LowoLu9QRVKeVFJ0rWT+DfGoFGSYjd6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0859/1848] ALSA: hwdep: Serialize DSP load requests
Date: Wed, 18 Nov 2026 15:48:17 +0100
Message-ID: <20261118145952.475154776@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YuanZhe Liu <25031212351@stu.xidian.edu.cn>

[ Upstream commit aee83c204f80d56b4d55f53acdb8594308ddcd4a ]

The check of the loaded DSP indices and the call of the driver's
dsp_load callback in snd_hwdep_dsp_load() are not serialized.  A hwdep
file descriptor can be shared among threads, or inherited across fork,
so two SNDRV_HWDEP_IOCTL_DSP_LOAD requests for the same index can both
observe the index as unloaded and enter the driver's callback
concurrently, even though the device itself is opened exclusively.

This breaks the assumption behind hw->dsp_loaded that a firmware index
is loaded only once.  For example, snd-usb-usx2y hits
WARN_ON(usx2y->as04.buffer) in usx2y_async_seq04_init() and may
allocate the US-428 sequence URBs twice.

Serialize the check, the callback invocation and the bookkeeping with a
per-hwdep mutex, so that the second request returns -EBUSY.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Co-developed-by: Bin Yu <byu@xidian.edu.cn>
Signed-off-by: Bin Yu <byu@xidian.edu.cn>
Co-developed-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: YuanZhe Liu <25031212351@stu.xidian.edu.cn>
Link: https://patch.msgid.link/20261029084810.21910-2-25031212351@stu.xidian.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>

5.10 and 5.15 still build with -std=gnu89, so guard() cannot be used
after the early returns of this function.  Take the mutex explicitly
and release it on every exit path instead.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hwdep.h |  1 +
 sound/core/hwdep.c    | 14 ++++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/sound/hwdep.h b/include/sound/hwdep.h
index 8d6cdb254039d..137be4b4074b2 100644
--- a/include/sound/hwdep.h
+++ b/include/sound/hwdep.h
@@ -57,6 +57,7 @@ struct snd_hwdep {
 
 	struct mutex open_mutex;
 	int used;			/* reference counter */
+	struct mutex dsp_mutex;		/* serializes DSP load requests */
 	unsigned int dsp_loaded;	/* bit fields of loaded dsp indices */
 	unsigned int exclusive:1;	/* exclusive access mode */
 };
diff --git a/sound/core/hwdep.c b/sound/core/hwdep.c
index 0c029892880a8..2862cbe757051 100644
--- a/sound/core/hwdep.c
+++ b/sound/core/hwdep.c
@@ -211,14 +211,19 @@ static int snd_hwdep_dsp_load(struct snd_hwdep *hw,
 		return -ENXIO;
 	if (info->index >= 32)
 		return -EINVAL;
+	mutex_lock(&hw->dsp_mutex);
 	/* check whether the dsp was already loaded */
-	if (hw->dsp_loaded & (1u << info->index))
-		return -EBUSY;
+	if (hw->dsp_loaded & (1u << info->index)) {
+		err = -EBUSY;
+		goto unlock;
+	}
 	err = hw->ops.dsp_load(hw, info);
 	if (err < 0)
-		return err;
+		goto unlock;
 	hw->dsp_loaded |= (1u << info->index);
-	return 0;
+unlock:
+	mutex_unlock(&hw->dsp_mutex);
+	return err;
 }
 
 static int snd_hwdep_dsp_load_user(struct snd_hwdep *hw,
@@ -376,6 +381,7 @@ int snd_hwdep_new(struct snd_card *card, char *id, int device,
 
 	init_waitqueue_head(&hwdep->open_wait);
 	mutex_init(&hwdep->open_mutex);
+	mutex_init(&hwdep->dsp_mutex);
 	hwdep->card = card;
 	hwdep->device = device;
 	if (id)
-- 
2.53.0



