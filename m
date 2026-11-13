Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585248;
	b=WteRjYcwzI5Ef6FeQVWu9OWcOWz6OXE89YT2ANLe5bOXxtci97o0c0wdN5fs+h5S9ji5
	 N9PJD6rUoc8sIWOdy/62a7JSGyRq1XpqJ3zuWv/C/vekbNKTnmN575sk0x/WDQQYKJSWW
	 0mr/9eqUFYmsLL/rTspcvP+IAXlWd/dCuTUoFB9+uQs+7rXFqXHQGyE2mwuMTsvjrf00x
	 zQ3I1txzgatM1x0NES/6ZQhbVYR4dB2tEyqUD37ZdO44hfvrQB0sdJpctjUPzCxiA8m/o
	 kOb9Kp5GjNWW0ol1L5Xw9uooCv/B0qAqUXE9H/SeLzQWQMkRbw8Bk3ICmQXVzD9sSKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585248;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lC8fxfBbQ6TOjPUiMiGVTWCg3WYLqwIYRCzbFyAee9Q=;
	b=ycK5cSOMNb84Yj+vqDJUqHoURKzDEHElgkES/ijM3w3Hq5xFxOuOgxI1pWsdQS0Sk6Mb
	 ow6agvA+mOcFj9d1TU//QeZPxySF6NseIL3CvpcnB/5L9FO1MP3rolm0CLdfxBWx0qitF
	 49Ko3Vus4ajEbb8FE/WxMSSB/uC0NaT2NHWdRsigzVE6gpRPYWZIokne2V/ugzYQ8E2g6
	 lB51kw27N38j5J4FwPx6H5j4MX+UTkF5jNCQaNTpID4FObyTdPc5AZsBsTJ6Ygqxxk7I4
	 XQOfLdG0G8tjzkSf1hZfCnpytGb6kkw7LwpoF762PzLhQrMFBN+HUwuNbXwmu7TcKGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="f7bs/Pvg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C7E606A32D;
	Fri, 13 Nov 2026 15:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f7bs/Pvg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E5A1F000C4;
	Fri, 13 Nov 2026 15:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585247;
	bh=lC8fxfBbQ6TOjPUiMiGVTWCg3WYLqwIYRCzbFyAee9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f7bs/Pvg/up5VPBy25f61lnCkDbSUoPd4Yerfq3mdveV20ooMN6gvOwTi8G0yaNRH
	 Ev9FLXiHWdWu0+u2wr0Zoy3ADF8Qe+uW1LGJVw+1xnWi7m0ioGAt6Fx1wmOosAbgQz
	 +Ik/C8MS2trmYcFteYgje4QEzohVR7++OwY8Ssng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 002/686] ALSA: x86: hdmi: fix chmap array missing terminator entry
Date: Fri, 13 Nov 2026 10:42:15 -0500
Message-ID: <20261113153821.013423887@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
[ sashal: Adapted the allocation hunk to replace kzalloc(sizeof(*chmap), GFP_KERNEL) instead of kzalloc_obj(*chmap). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/x86/intel_hdmi_audio.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/x86/intel_hdmi_audio.c b/sound/x86/intel_hdmi_audio.c
index 8e2a007311d36..21ee9c9154804 100644
--- a/sound/x86/intel_hdmi_audio.c
+++ b/sound/x86/intel_hdmi_audio.c
@@ -475,7 +475,8 @@ static void had_build_channel_allocation_map(struct snd_intelhad *intelhaddata)
 	kfree(intelhaddata->chmap->chmap);
 	intelhaddata->chmap->chmap = NULL;
 
-	chmap = kzalloc(sizeof(*chmap), GFP_KERNEL);
+	/* info->chmap must be zero-terminated; allocate a spare terminator entry */
+	chmap = kzalloc_objs(*chmap, 2);
 	if (!chmap)
 		return;
 
@@ -575,6 +576,12 @@ static int had_register_chmap_ctls(struct snd_intelhad *intelhaddata,
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



