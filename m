Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037122;
	b=O4ApOAhsPvdDKLI9FmaCtDepjRHGUgLgKIvj5APK6JpisjG7+30Hud4kDtpR39MLf7dN
	 vaj+gWOOqT+nRlO2muKicR0WzRA7FKPLaM6CZfkJSGZeKbjgfsQbHAsMRWbbEpE8s4gzt
	 EIshRAkeAMp1NhOM9RwuS0FdPNP1CYPdf97FyCpw0EcXH80egt/Eqi0Of+U1Jhwv4jYnQ
	 7WnhcUUIjH53kSmnwragKyi8vWPRpZPqAzdPDjdpDZZ4aR4n53urmMHU22ccJQGdocwYo
	 gYT3eqWfgpfLYPqNWhZJxt5ZdvfW+OKzv566qaa9BmZhNF7TgWQMLutbTWE3cfXPJUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WodISmtBIDU55Ixwx1PEAX2qf+Z78Bqoh/+aPaZB7Yc=;
	b=eKxj5UtBmBAAZ6Toxh0q+IHnoRDExDpyhVd0u+DoMqaTq7Va5WVaiqvdZlCj87fs5X4z
	 Usa5Fpf+mbLn0mNDNKRiSio2gITmZzJKEyQnhJUiK/h+L20S9A7PdWgjBKI54NaO9MIZn
	 2kdMlNwF8YfNXlAgjEyjFAz3ZqK7NpfCEkUeTXsbUr3H83gtJZxgLHTSoftAy3E2LtHC2
	 vvVFJ493X6S71xWgDgdtFeFKx1YWdlKyiXIZ1EWLOA33ylDh5eG/TE7XAVfmU9+5aphb+
	 HQxizodjqKWPUDyCZT+Pa+l2fGR0jBsPzA7uMu6bDwJ22DZRGgqyeV6HOdEvBd0aTqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="FnsLeU/F";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8489606BE5C;
	Wed, 18 Nov 2026 21:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FnsLeU/F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031B31F0280B;
	Wed, 18 Nov 2026 21:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037121;
	bh=WodISmtBIDU55Ixwx1PEAX2qf+Z78Bqoh/+aPaZB7Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FnsLeU/FzzeeUl6jvzP6MrYosto+olZjNIlYLydhvYJWwsR9mG9/hYnofeWPZkyWX
	 CDdyNaz+d5SMF8jMjybdNT/UtrwtX1uHr9ezLoFixV0EURB+/MDQGOS5bUEw4ABbDZ
	 9tW4InzV/hkJ7gK8dS3brRA02fgu+cddK6UR2TTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1302/3318] ALSA: x86: hdmi: fix chmap array missing terminator entry
Date: Wed, 18 Nov 2026 15:32:04 +0100
Message-ID: <20261118150359.324594697@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit f5e1a9a3fddab8421416b68bb132ae9626d07156 ]

had_build_channel_allocation_map() allocates a single struct
snd_pcm_chmap_elem via kzalloc() and stores it as
intelhaddata->chmap->chmap. struct snd_pcm_chmap.chmap is expected to
be a zero-terminated array (see snd_pcm_std_chmaps[]), but
had_register_chmap_ctls() never overrides the TLV callback installed
by snd_pcm_add_chmap_ctls(), so the generic pcm_chmap_ctl_tlv() from
ALSA core is left in place.

pcm_chmap_ctl_tlv() is reachable by any local user via
SNDRV_CTL_IOCTL_TLV_READ on the "Playback Channel Map" control and
walks the array with "for (map = info->chmap; map->channels; map++)".
Since the driver's single element is never terminated, this walks
past the allocation. The same pointer is also freed on hot-unplug and
rebuilt on hot-plug under intelhaddata->mutex, while the TLV callback
runs under card->controls_rwsem without that mutex, so the walk can
also race a concurrent free of the array.

Fix this by allocating a second, zeroed element so the array is
properly terminated, and by dropping the inherited TLV callback
entirely at registration time, since the driver never implements one
of its own.

Fixes: 5dab11d89777 ("ALSA: x86: hdmi: Add audio support for BYT and CHT")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20261008085411.13742-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ sashal: Replaced unavailable kzalloc_objs() with kcalloc(2, sizeof(*chmap), GFP_KERNEL). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/x86/intel_hdmi_audio.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/x86/intel_hdmi_audio.c b/sound/x86/intel_hdmi_audio.c
index 7b9292cf839f2..d23dfdd50440a 100644
--- a/sound/x86/intel_hdmi_audio.c
+++ b/sound/x86/intel_hdmi_audio.c
@@ -478,7 +478,8 @@ static void had_build_channel_allocation_map(struct snd_intelhad *intelhaddata)
 	kfree(intelhaddata->chmap->chmap);
 	intelhaddata->chmap->chmap = NULL;
 
-	chmap = kzalloc(sizeof(*chmap), GFP_KERNEL);
+	/* info->chmap must be zero-terminated; allocate a spare terminator entry */
+	chmap = kcalloc(2, sizeof(*chmap), GFP_KERNEL);
 	if (!chmap)
 		return;
 
@@ -581,6 +582,12 @@ static int had_register_chmap_ctls(struct snd_intelhad *intelhaddata,
 	intelhaddata->chmap->kctl->info = had_chmap_ctl_info;
 	intelhaddata->chmap->kctl->get = had_chmap_ctl_get;
 	intelhaddata->chmap->chmap = NULL;
+
+	/* drop the inherited TLV read: it walks chmap without our mutex */
+	intelhaddata->chmap->kctl->tlv.c = NULL;
+	intelhaddata->chmap->kctl->vd[0].access &=
+		~(SNDRV_CTL_ELEM_ACCESS_TLV_READ | SNDRV_CTL_ELEM_ACCESS_TLV_CALLBACK);
+
 	return 0;
 }
 
-- 
2.53.0



