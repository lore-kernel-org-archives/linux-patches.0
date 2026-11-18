Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059736;
	b=kCMsKdbSzZATSPbtqIHhDnll1ti3DriGqJHwSz6hKX4dMdY0Gru4+iPjoIUXcpNeX6Av
	 RJkAogWwEvUx9giui6YiLu9Rj6vELVg1okI1ps3grL8Ny5LHm1JvvhIpE+bPKPAGZCdHx
	 bSwjwqipQ2JQEd5YP5tOyxqTNNT6uQyZ9o4ZMsndDocbRAh3iu35qcmzMfCkJfSdh33pc
	 Wf7CRPWzFmoNtUCKkdrMatJnZ+ePpDlWTka7qEkFlTsX9bH0QI8CTVImJuFsqjGRtk2Gw
	 MtN5bvSjWxcY4s6Arf35BrLeCA81V7Eq6UW1QUrUkr/Dc4ZBvWaoXT2MO1TDzl2767g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059736;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mc8WojzjmPTvAXRz1YI7Q3/Ai5FujEL2DQmP8cQrM9k=;
	b=y5IXx1736TFzt72W4fls8pAeYuzRjzlN041kzHZUrEX8Ae8s5TKx0vsh63TFKO0NQgSR
	 z33PolL6yMhhYitT4MrH12h/WZgMxJTqmcz2dqfa8SYs0MLrMDxNFAGMhXAMF7NMvR09f
	 Z9q8oESMQGw156zWk7ywifGu0cjOcHIFebwujLG7qGSg+UfnIOXp/jMPYrEkHlKCqdFRP
	 bQDVnpkUWLZ9CK0bwcrAnyzcqYyhUjIluZHAeWRUCq4qV6TYFep6+Ue/Nh6zmmDN8wylb
	 +/ClQpXtakKShkAA9L5dVD4IGO51c5ZbohcL2ZA/kFLOJV0Zy/HtYqPKEW5hOng24lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nbHeYDfP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2301606A330;
	Thu, 19 Nov 2026 03:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nbHeYDfP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4348B1F000C4;
	Thu, 19 Nov 2026 03:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059735;
	bh=Mc8WojzjmPTvAXRz1YI7Q3/Ai5FujEL2DQmP8cQrM9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nbHeYDfPPiqo6futLCQyEo0BSQ/2KxyNCgeHNaWY9ZZR+NyPS6Hk0qZjwKWcesRsS
	 kpB41hYmFj+wudq6PGlmRwFbYdf2NhLDfZZqrwZpP2mdoqbccnscKJIQrSbGBLi3qY
	 W0oigbPLfPH3KDTQovB5s9iDXIr9FJwtVLN+Px8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0931/1848] ALSA: emux: Stop voices before freeing zones in all cases
Date: Wed, 18 Nov 2026 15:49:29 +0100
Message-ID: <20261118145955.736927414@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 8a5d87c2ba30e8de31cfbe888fd4d95f43c63db9 ]

The emux voice caches the soundfont zone pointer in vp->zone, which
is referred to later, e.g. in snd_emux_send_effect().  For avoiding
dangling pointers, the soundfont code calls the sample_reset callback
to stop all voices before freeing zones.  However, in a few cases
(e.g. emu10k1's missing sample_reset or the call path via
remove_info()), the sample reset isn't called properly, leaving the
playing voices.

Fix it by always registering the sample_reset callback, falling back
to snd_emux_terminate_all() when the driver has no own ops, and by
calling sample_reset in remove_info() before freeing the zones.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261020101624.205638-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/synth/emux/emux.c      | 10 +++++++---
 sound/synth/emux/soundfont.c |  9 +++++++++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/sound/synth/emux/emux.c b/sound/synth/emux/emux.c
index 8e080a4bcd16f..cfd472effe88d 100644
--- a/sound/synth/emux/emux.c
+++ b/sound/synth/emux/emux.c
@@ -71,7 +71,12 @@ static int sf_sample_free(void *private_data, struct snd_sf_sample *sp,
 static void sf_sample_reset(void *private_data)
 {
 	struct snd_emux *emu = private_data;
-	emu->ops.sample_reset(emu);
+
+	/* stop all voices that might refer to zones and samples to be freed */
+	if (emu->ops.sample_reset)
+		emu->ops.sample_reset(emu);
+	else
+		snd_emux_terminate_all(emu);
 }
 
 int snd_emux_register(struct snd_emux *emu, struct snd_card *card, int index, char *name)
@@ -96,8 +101,7 @@ int snd_emux_register(struct snd_emux *emu, struct snd_card *card, int index, ch
 	sf_cb.private_data = emu;
 	sf_cb.sample_new = sf_sample_new;
 	sf_cb.sample_free = sf_sample_free;
-	if (emu->ops.sample_reset)
-		sf_cb.sample_reset = sf_sample_reset;
+	sf_cb.sample_reset = sf_sample_reset;
 	emu->sflist = snd_sf_new(&sf_cb, emu->memhdr);
 	if (emu->sflist == NULL)
 		return -ENOMEM;
diff --git a/sound/synth/emux/soundfont.c b/sound/synth/emux/soundfont.c
index 1266604cf33be..675f274a8485a 100644
--- a/sound/synth/emux/soundfont.c
+++ b/sound/synth/emux/soundfont.c
@@ -480,6 +480,15 @@ remove_info(struct snd_sf_list *sflist, struct snd_soundfont *sf,
 	struct snd_sf_zone *prev, *next, *p;
 	int removed = 0;
 
+	/* stop voices before freeing the zones they might refer to */
+	for (p = sf->zones; p; p = p->next) {
+		if (!p->mapped && p->bank == bank && p->instr == instr) {
+			if (sflist->callback.sample_reset)
+				sflist->callback.sample_reset(sflist->callback.private_data);
+			break;
+		}
+	}
+
 	prev = NULL;
 	for (p = sf->zones; p; p = next) {
 		next = p->next;
-- 
2.53.0



