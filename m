Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052987;
	b=gVpaaVXRs760jlhTYCNIn+J5kdh2snIbK0H+N2wc6y9ISYv4+Jzm3gydjES32MVtyzAN
	 DUIOvXETTD+7tKUmHl3YvyjVE6nRKgFo2S55VDx5u1inYFO5lHYwGq1DGOT5j15Qt/3SO
	 OOUyWADJcf3wmnOMfeDpnfWzb4HyT714klfFtnSYdnFDHVadAKTW6Qszx/Tst+WmwzNOf
	 1WBt9dKYl2WDALnZKtgp0TAlPLCtAnmQaGIAPHnfghC+DtaKTeipNFLIs/2gzQuhZqs/r
	 fyOeRNYg8vleJNPuC2mIk7z6Rk4B77EjJWcDRf9U3ExIPqQkoYIO819RsBzkYzUalXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052987;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1u/phU/T70qwrLh+gg+NBNylyFh/xLSBXW9DGu1ioVo=;
	b=0LbqkmIL58ezAxJaA3O+jwvfTafukeq10tAzEfk+9LmB5HJMVscey7eubmb4gXWy+0o5
	 GG9F2G5ijQqc5Z2MQeWJqY63MX6qmViKAj9XqguClcKpjNnA+fijHMk8DCW6vvFGCHrtY
	 prktlquzs4cE4DGlyuJDvm7WWdxeHnEhxR8NzLhN5QDKe2Q+da/3DHsQ/0Lf5gRsPxnBe
	 Y9SmoziSXz/Tk/PbsEvfAp+3GSp/mp+QJFrDxfDbm/W+Ud0fu1yaM+cx6zM64OwQ/8OAM
	 c1l6BdI8FbPHU2Zwz4gez6jfRTA1uWvgCbCyoDwzSgsJNNmYonHLw9T2pG98kqLzuLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oXt8BNE8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF81606A336;
	Thu, 19 Nov 2026 01:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oXt8BNE8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30FF11F000C7;
	Thu, 19 Nov 2026 01:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052987;
	bh=1u/phU/T70qwrLh+gg+NBNylyFh/xLSBXW9DGu1ioVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oXt8BNE8HbuWYESce6fvzvI3ZRZfWyAaSj0YxD5Njjcemh689das+zNy90ninahxj
	 pof8l3UMwbOU273mKGC7VXAvNQMzCChq00Q0TXbUSFABC7ZnspfqRt9TKAsG8LrhE1
	 Z1Kb5CNKRFOLS7YcFlUA7/CaWY6/o2rJWRphWizs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0759/2214] ALSA: x86: hdmi: fix chmap array missing terminator entry
Date: Wed, 18 Nov 2026 15:40:35 +0100
Message-ID: <20261118150042.100103846@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: replaced kzalloc_objs() with kcalloc() using explicit element size and GFP_KERNEL ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/x86/intel_hdmi_audio.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/x86/intel_hdmi_audio.c b/sound/x86/intel_hdmi_audio.c
index ff80ac3e1cbab..0a6b78cb9c2a8 100644
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



