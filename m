Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829112;
	b=KQBUZgtW4lsenDJeYHcKjjs6byig840Zp39GsnLRk8/dL9AJ+PHbM6z8gjWgqffX+YBF
	 g6KE7WvWmbTG4Fcam6eT8EVcAQEZOPQzQMuJz5kf3PAyIH55K0fSBToMm2gzoP35I43Ow
	 UXL7qeDRkw/mZKzmeV2sP6aYiXJ6s7DpSMyzKtAKNkcMJZkhrZAMy0RNqsyD9sQ+NDmCJ
	 OGV7R6N80SUp4DyqL3a76AsP6IL70Cs9jcakthpyaun/7vLXAs6AyO4yELNn2Ti3U0TA3
	 JfmO3vDksjOVmuWYegCYBcoBIHLQoiuyE6b4HikJyECBhHXMMUY8hSAvVwFGLlppGCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fifqy3z0XiqUr/aKo7iX/oK68i/yhcrUxEPDURKJZ9k=;
	b=GWA+B236vQxTEm6iPOpfF4Y6Xc969maSNFRJJR0EE1/k/odc04m3aXFP7BtYy3dMx7Gu
	 0ToSHbg9uRyRJzuoK8F/ls1Hr+2ABf+Vu5y4vn+8qYGHbp/FtCxjlJk1Uf9QaGmOA+oei
	 5jK5ZJAxOk3ukrTtGraClc9XOCqjnsDAZFVcHezakJqM5LXQ9P5AwZhsMheez+3G8vbFP
	 CJ+x0qxcXWiRO9sPTc0GP5Kqd/4I1saRlqbGeaZDy0Pkx7N5sd0NpeS8kbV9F3KG8nLGR
	 7QWvw2UG/3ocDA6dOksC3o31U5k+o0oC5vFcrFZMkUU2iLf246Umdt+qz+94cqRNQNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z9IKZkN7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5626070757;
	Wed,  4 Nov 2026 21:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z9IKZkN7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2041F00919;
	Wed,  4 Nov 2026 21:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829111;
	bh=fifqy3z0XiqUr/aKo7iX/oK68i/yhcrUxEPDURKJZ9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z9IKZkN7c0IZuOir1m4b6ugT5Jun5n6oZigwDqkK1r+JVtp/dM8tCLGSCNuCd6OWR
	 oyfMhSYbgyer7e37XZKTZxS1MJ554fHYJCVrJf5g6g23xiuMT5JgZwUXdUIVXweLGe
	 EPw58iJeWqBZLPjGwGfDmNQ4TWxIQ6tGiHigYkcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.3 453/547] ALSA: x86: hdmi: fix chmap array missing terminator entry
Date: Wed,  4 Nov 2026 16:10:37 -0500
Message-ID: <20261104211051.225236808@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit f5e1a9a3fddab8421416b68bb132ae9626d07156 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/x86/intel_hdmi_audio.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/sound/x86/intel_hdmi_audio.c
+++ b/sound/x86/intel_hdmi_audio.c
@@ -475,7 +475,8 @@ static void had_build_channel_allocation
 	kfree(intelhaddata->chmap->chmap);
 	intelhaddata->chmap->chmap = NULL;
 
-	chmap = kzalloc_obj(*chmap);
+	/* info->chmap must be zero-terminated; allocate a spare terminator entry */
+	chmap = kzalloc_objs(*chmap, 2);
 	if (!chmap)
 		return;
 
@@ -575,6 +576,12 @@ static int had_register_chmap_ctls(struc
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
 


