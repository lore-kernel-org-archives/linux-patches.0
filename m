Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022666;
	b=gVvVvx0e3q+/U7Z3hpguv2lgesXDl56f8cTtH3v0hDUWP+kKarfgccyL0OobXErCfvtn
	 SeqnRbgkGEkhDwtbkNktV0xqHU/rjAtMLSPT4w7e8LnYahDq6mOB3oOJk9pMgLmcuj0jX
	 0PQ9EklKlksbv9rRHRBujnPmQ88Tk59QfoT1WxW2ixz84xv9Czh8uKwIW4PTNfjcJg9RQ
	 57rryF5yxBXlmU703WP791hvquoV0DLP+5lJDklGtiIHogeb+L9f/B2YxpPubY/wA4cxl
	 6etgQ9huIx83QAlxT99L1z1M0KxDL7/DcJsXfLGLMOKI0M/haL8qi4xcJAghQdrkj6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZytQPHFSa9EwTRqDP9NvNbZVWnD5qtCL2+YJ3w0rsRI=;
	b=s9bCBobOOWMEbeGsmBgTdXr9tdywcOsFvRkhAXi2cr+wZhlfe7qb7c+nIfnE6oW5zpdd
	 nshghOg+3gkuRkOkEct9Bw1qpk24xbuj11f3TlJzriYzoiKaRdO5YE1rNrNnge7f7KSg2
	 f+o5AuV4ivUBrVO4q47GgVpNjc5oU3JVPkh8u7PnWhgSXFaVz6cnVbSyYVcupY+CZ6VQL
	 CnHjiLCuHQaNj9jnV1EqcT1GTAs5mYEAzT1o1Itcc4W7pWq4ND3PXxaLvI3CqffzupTno
	 DAGd3Ts7tFNbdJuEXvGjW22abJ1XuxJEdk9Uip5pzZj+zCoEENuy7Xu+9b4yUM9gDaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z24nfMzB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C87606A32F;
	Wed, 18 Nov 2026 17:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z24nfMzB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8091F000C4;
	Wed, 18 Nov 2026 17:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022666;
	bh=ZytQPHFSa9EwTRqDP9NvNbZVWnD5qtCL2+YJ3w0rsRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z24nfMzBOW+MpDQRDPNXtk1CVSvXvpf9HAf4oi2pSm5nQQQvMLhIInwxshM2kAkKg
	 L0U7I1C4dCYjBb2AAmu5+CxMdyQodTe9+yD4fTCK5IQxY0HrptJtxm0Rt6qbDTmBXw
	 2m2unA7b6iW5wHkxAv/fc0xslsM3qt2HdeT89J8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo Cao <treebacker@foxmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0053/2151] ALSA: pcm: Prevent O_APPEND open on OSS streams
Date: Wed, 18 Nov 2026 15:29:48 +0100
Message-ID: <20261118150123.669145659@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0b512085eb63f..a723b1e566077 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -921,6 +921,8 @@ int snd_pcm_attach_substream(struct snd_pcm *pcm, int stream,
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
index 7dab7ba130c0b..79b49d8e6a87c 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -745,12 +745,6 @@ int snd_pcm_runtime_buffer_set_silence(struct snd_pcm_runtime *runtime)
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



