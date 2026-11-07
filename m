Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065118;
	b=RPqhC5TVDJ8rqpiKov4dn84xKoNEE/qEqdkUYLSgXLMX+7o0Xy939p95eEyU5wK9tSYA
	 3rU9lQSiY6u/Jnsl7yBRaE39/zmmMikCBLwth//kWbEac9N64EkZqq/ClvpjQR2VqTNE+
	 DUSp6IJpMjAao2DsaPu3YQZ1a7SSRQw+5nrxO88M3zIcjoVVBTRLk+Mr3lmGqvSUnyrRu
	 5bYesyFYMZ+UjT9nuri8gQIyw/Wlmqxc+/QyaKhE6bfV3/hPmEFBgu4M5neqF95hCnAqA
	 j7JyxnJ1xbUF8n+VcaTrv/s7A1E+dc16iHezPOTAMQUg9EtOOI5BWd4eZkR8xAqd2WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nMMVEHZcmdJhFieuQEiUFnBGYmnnzipluHD12eoasVA=;
	b=Z94xD1TJVgqmxYSfJv5Vzi8VeRYPdCL3Q7LwJeZUhz6vTMoaukjbieI5AuLWPs+LgLnO
	 xpjsj6sYmpwt00k6YgANw/oa2y81BoI8vDxhUN06JjdAS/MuGFvs3CXGw4mas/KpWnHZr
	 64Y2beNyj+HW7X5xHUIz5HlpNkB/fZHRunVrxQmQHFVDxF8ij45NIrnrnt/HdAHZuwpHS
	 r8syfxZPsFY5YMDaxozltaT6mGGME/LBvWZOGG1cVkilz2X8il29d0ENJk/uquffXHt37
	 SbXNFoupZNmEG/Hi/r9yR4hwiqj+LPyIZuwIpOSFIuP/8zQUdbrkKrjYQbs12jaMEvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WpPqpodA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D915606A32F;
	Sat,  7 Nov 2026 15:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WpPqpodA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46CA1F0089F;
	Sat,  7 Nov 2026 15:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065118;
	bh=nMMVEHZcmdJhFieuQEiUFnBGYmnnzipluHD12eoasVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WpPqpodAK9z3GhL1OTMpp8e+woUkjTXwNIFk07mznGXZq9I9xnG2BvpKQor5w946U
	 klz5s90M2PXRKDfZ348UrXa6ZHei9XHgYrT4P6bBsI8MUzEaCMdqoiZHGHe1Y0erJp
	 P3JEshDwaxbdGCsWY5lOBMsAsZgNeo0EFDJZ+fog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0943/1257] ALSA: emux: Stop voices before freeing zones in all cases
Date: Sat,  7 Nov 2026 08:53:59 -0500
Message-ID: <20261107135005.396336881@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 450147b1abed5..2a42d041e1da0 100644
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
@@ -95,8 +100,7 @@ int snd_emux_register(struct snd_emux *emu, struct snd_card *card, int index, ch
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
index 039357d96e07a..42d1f33fb2b50 100644
--- a/sound/synth/emux/soundfont.c
+++ b/sound/synth/emux/soundfont.c
@@ -443,6 +443,15 @@ remove_info(struct snd_sf_list *sflist, struct snd_soundfont *sf,
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



