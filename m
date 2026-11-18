Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047570;
	b=no3E60smOq6e+6KeAuMJCSdP3RImavCV0XAH3BwHkn4WGcjvOdBZM9otlWFjFkKv3eBH
	 vP5dKbMd/7NG4nafUR+uIAKTDtCrp+q+TXZs08BykEZRc6b5XhHUjd4tIFxuzNfHnuOZr
	 XLc1nz7k9VzSRLp74y67O6oootfDE9L3iQ4I3R3mUGv/MTl/HvcK+dGFzFGC33XP2tyeH
	 MlSbfb39BdCsBUcAhE1VkyzDjpfAYR2Jge+Cf62WDsTRP7W0nX5H9k5X45kXlhcZyBWQK
	 D6EzA8/GR2MW1m0qCs4Imvs8UrMq/HKbUN8UOMPvy0LLSjHLmXsPde7KNe7zdpzuF9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047570;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZZ/RHCVBy8DOGCw1ykxCf9UY3Bq3O2h+ZpPMFOiPVe4=;
	b=lZ78SDLBPVqYk615dOaNSVvSv7fd/aAD6yBVySLouxJaNl0xx/E60JSWcfsgaGBpUu15
	 +6c8QssfroOCx/w22GGVyE+xdnPNFVspdlwiuhqjbjeyMtEGkS3fQ7Fvv50P9p3bcPO4/
	 J6iCnkwjlf06YlxxzK9zwd87m5cp6Nbp7xtGTRTW8qUjnx4QvNulI2yjF/V3g4BpmF89Q
	 hpJChYMGUdd9GYkos066+l2bVy29HBNtKieNGxEraoPPYmBfteJp83ZFY6Xin+udISSat
	 ge8FdnWYoamiOu+3E8z1aVm4tFOZGnx55jidsXvwPofc+QBVmgWkYYp6DGCuGoa6Zjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i5UHGSnB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEA7606A337;
	Thu, 19 Nov 2026 00:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i5UHGSnB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D8431F000C8;
	Thu, 19 Nov 2026 00:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047570;
	bh=ZZ/RHCVBy8DOGCw1ykxCf9UY3Bq3O2h+ZpPMFOiPVe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i5UHGSnBIWAWc1jT64f3nwlraAZ0ML5DZ12tcKzmjF/xbS0+DumC52+yp46bRUcHu
	 DbO9ZzLnQ/+NKHb/wuenJpQnA+e/CmmHzFUFThAoX5UTlTsE+RzV3Wa6OuU8moxZQm
	 DoYuP8j5kbvjhlyOQe+wTnHRSPShr5xZEKIlAdPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo Cao <treebacker@foxmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1645/2857] ALSA: pcm: Prevent O_APPEND open on OSS streams
Date: Wed, 18 Nov 2026 15:44:39 +0100
Message-ID: <20261118150300.567637851@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 9017bc3d13da0ea4e63be618c87143a7b69185e6 ]

ALSA PCM core accepts to re-use the existing stream when O_APPEND is
passed, and it's been used for dmix, etc.  However, this mode isn't
supposed to be used for OSS: the OSS stream allows re-configuration
via its hw_params/hw_refine procedure even while it's being mmapped,
so it implies the usage of only a single stream.  Because of this
assumption, the sanity check is skipped for OSS streams, and if user
may attach to an existing OSS stream with O_APPEND, it may result in a
UAF of the mapped pages which could be used as a privilege escalation
exploit.

For addressing it, this patch simply prohibits the O_APPEND behavior
on the OSS stream.  O_APPEND is never used for OSS layer itself, so
this can't break for the right applications.

Fixes: 0df63e44c3e3 ("[ALSA] Add O_APPEND flag support to PCM")
Cc: stable@vger.kernel.org
Reported-by: Bo Cao <treebacker@foxmail.com>
Link: https://lore.kernel.org/tencent_E90BB4F086165FAA3313723567A5C675EA06@qq.com
Link: https://patch.msgid.link/20261103155844.120838-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm.c        | 2 ++
 sound/core/pcm_local.h  | 6 ++++++
 sound/core/pcm_native.c | 6 ------
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index 2415a3c3ac6c9..a8d10a844e51e 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -932,6 +932,8 @@ int snd_pcm_attach_substream(struct snd_pcm *pcm, int stream,
 			return -ENODEV;
 		if (! SUBSTREAM_BUSY(substream))
 			return -EBADFD;
+		if (is_oss_stream(substream))
+			return -EINVAL;
 		substream->ref_count++;
 		*rsubstream = substream;
 		return 0;
diff --git a/sound/core/pcm_local.h b/sound/core/pcm_local.h
index ecb21697ae3a4..4b134d435c24f 100644
--- a/sound/core/pcm_local.h
+++ b/sound/core/pcm_local.h
@@ -80,4 +80,10 @@ static inline void snd_pcm_dma_buffer_sync(struct snd_pcm_substream *substream,
 		snd_dma_buffer_sync(snd_pcm_get_dma_buf(substream), mode);
 }
 
+#if IS_ENABLED(CONFIG_SND_PCM_OSS)
+#define is_oss_stream(substream)	((substream)->oss.oss)
+#else
+#define is_oss_stream(substream)	false
+#endif
+
 #endif	/* __SOUND_CORE_PCM_LOCAL_H */
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index e015f34ce463c..9e87aa2518411 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -720,12 +720,6 @@ int snd_pcm_runtime_buffer_set_silence(struct snd_pcm_runtime *runtime)
 }
 EXPORT_SYMBOL_GPL(snd_pcm_runtime_buffer_set_silence);
 
-#if IS_ENABLED(CONFIG_SND_PCM_OSS)
-#define is_oss_stream(substream)	((substream)->oss.oss)
-#else
-#define is_oss_stream(substream)	false
-#endif
-
 static void pcm_qos_req_clear(struct snd_pcm_substream *substream)
 {
 	if (cpu_latency_qos_request_active(&substream->latency_pm_qos_req))
-- 
2.53.0



