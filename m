Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058799;
	b=48ck0ECKxCq4/HfP64d3PXwMUs2kwEVyrn3Yr6IGF5AN4CPNkOAViRfV2xkfd4lhgjz1
	 tGBIeDXt7CXNGOxCX3HkKdMiN/w8FvL4Xp42wrNmnKaESPvFnbckTgaB5sxeGVnI7peWa
	 UBD/sf34XEylZNOBk2UzV+FWBayrc9GigVz1RC9lOCckqxXGNGA9SnOR2jLy8T/WjstdJ
	 zecitXNeCvN4ciIHuzrqlt+6D8vb52tHlzI8qdPQ8ZGRTFPciLXW6vjK1ua03K9Emzng8
	 L0fCk4jU4YAanJIMiG2XQkDLfe9mm+TXyEpcUlmr0g0B1yW5aq0PVTgNOiTyOl6xyzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kKAn/EnKF7WYKmUQ78VhQy9oDqvXvibCwWoG7F4Q6jE=;
	b=PSnu+5aHeDChC4ErPqr/XcjKN1Qt1rx9AKj8NFmZ9tU6MSbiFltcnNncftux6neByUCl
	 1eAu2lgn1kRMMA9EmSHawI3vFiKsdpP7bPyEnRkdcXP7sWyUVi2LmcAkJS1wxeZr29dlZ
	 QP5j5iiFFh2gP/1c44JIijcG12wxNxLBLLF9J4hI9N1l0pd0pNJiCUb/CH3XoM+AoekZF
	 F9ZNy34hwd5hW3WYLQKKWnztdkniPEzgx4tpCur0t/7xOZUykdhUSBAJT0wxLJhHPTpPe
	 1hfB6ZCqMEBCFRo5R7YLWBl7P1vaPS8EJ/xm9vpC6mBO0oPj3//2BiyKDbKvklk3oyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZOUt8ibS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5290606A325;
	Thu, 19 Nov 2026 03:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZOUt8ibS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2192D1F000C4;
	Thu, 19 Nov 2026 03:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058799;
	bh=kKAn/EnKF7WYKmUQ78VhQy9oDqvXvibCwWoG7F4Q6jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZOUt8ibScYEVo4Z1uthpYoLX6sgpuoHwe+md+8FrtVXB1KlidHCVZi4SasCdPlEYt
	 0mRk2u+2tH6HPhEjFWjJfDZ/HrJrYsYaW7WZTx6maYY3OPZntNuYSjPW+Rxrg3hmq0
	 htO+0GGxkw1mC6imTurXTsfolCOBPuSrQouaOhbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0613/1848] ALSA: x86: hdmi: fix chmap array missing terminator entry
Date: Wed, 18 Nov 2026 15:44:11 +0100
Message-ID: <20261118145940.957466913@linuxfoundation.org>
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
[ sashal: Replaced kzalloc_objs() with kcalloc() using an explicit element size and GFP_KERNEL. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/x86/intel_hdmi_audio.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/x86/intel_hdmi_audio.c b/sound/x86/intel_hdmi_audio.c
index dbaa43ffbbd2d..81ce6d8f5058c 100644
--- a/sound/x86/intel_hdmi_audio.c
+++ b/sound/x86/intel_hdmi_audio.c
@@ -476,7 +476,8 @@ static void had_build_channel_allocation_map(struct snd_intelhad *intelhaddata)
 	kfree(intelhaddata->chmap->chmap);
 	intelhaddata->chmap->chmap = NULL;
 
-	chmap = kzalloc(sizeof(*chmap), GFP_KERNEL);
+	/* info->chmap must be zero-terminated; allocate a spare terminator entry */
+	chmap = kcalloc(2, sizeof(*chmap), GFP_KERNEL);
 	if (!chmap)
 		return;
 
@@ -579,6 +580,12 @@ static int had_register_chmap_ctls(struct snd_intelhad *intelhaddata,
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



