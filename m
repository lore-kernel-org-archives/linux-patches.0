Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585243;
	b=aqjNc33inUmd6ouKNpvjo5RettMrh7bUc80nnD6uf8cO6UJux7Mx+HC5Ho/qnZUALOXQ
	 MQW18l6pitwLSPvqG0vtSCkHrvv+tGziKE1iznMQP4J2Q5Vfeeg4/cSFVEFFjARuGeXfq
	 EO0VCDmBDBAqtEiSGGV4a10Q82kjF9KuApzxVzQ6snIB1fudKHxpS6IqP/YCZr/9wK01y
	 HGdiJEH6fE13pKNIp8gf1K4oDUfu7rrPmyUmPpWzfyhbTmwSE20SNFR2fqJf/nMOSuUpS
	 fErgjJsRqB4pyHAFpx2qPM0a7bxlAazlHuzsg1oVciFCXtWp2UpDwOkqY/CjDN+cwcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585243;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uXmwrSrraUjSwWNXEhT45VREGFDwWftELC2szmSfqZM=;
	b=c8uPKFfdpp0UyL4PC2BPjQioyWwexuudD/VtUdBbVOUcpn8z3gUPptammJD1Fs64qqZQ
	 ZmgkVmfagUqNJYbA7TJVf//bUYFO9lgLaI9P0mzFcxT6lYBHFRz4lrNL9OI2ZVkdNk7Wo
	 zGnMECk3BXnKpp+HHQSvM83FfPShX+aWY+8fQYiKwQAfdIZs3oQ8NzBDmjZ8r+d2hs/EU
	 HDCoyUgVBApVSgGMM5K6sMWZIGg99Isps1E7hCT8znl4kCviz+KFAP1kVHX3RQHXPHu/4
	 vz3WwG0GQBoxEOAXt62dAf2Nm7n4w0M6SaIuXmsNM1nsXFc6Knu58Nsf37VKDxt2WgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o79FAKjW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658DC606A332;
	Fri, 13 Nov 2026 15:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o79FAKjW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C103B1F000C4;
	Fri, 13 Nov 2026 15:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585243;
	bh=uXmwrSrraUjSwWNXEhT45VREGFDwWftELC2szmSfqZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o79FAKjWIPaGy29NB6CbOCzyPW9roFwMxLyFD4pSn4jJQGuTyBvreuXBFA61Fxi5T
	 gVGjTKh5g//Cm8eeeFxXhfvJBP3ymF7ugm1K89J0GpE2EvAw1K1bngoiyOzHOvhNaX
	 mA2wKxTscy0uKnd8xR797ul1irIpLVpAQkQ2YZTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/670] ALSA: x86: hdmi: fix chmap array missing terminator entry
Date: Fri, 13 Nov 2026 10:42:47 -0500
Message-ID: <20261113153811.295859866@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context for the existing kzalloc(sizeof(*chmap), GFP_KERNEL) call instead of kzalloc_obj() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/x86/intel_hdmi_audio.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/x86/intel_hdmi_audio.c b/sound/x86/intel_hdmi_audio.c
index 571a092b128a2..3c8f1793522ae 100644
--- a/sound/x86/intel_hdmi_audio.c
+++ b/sound/x86/intel_hdmi_audio.c
@@ -479,7 +479,8 @@ static void had_build_channel_allocation_map(struct snd_intelhad *intelhaddata)
 	kfree(intelhaddata->chmap->chmap);
 	intelhaddata->chmap->chmap = NULL;
 
-	chmap = kzalloc(sizeof(*chmap), GFP_KERNEL);
+	/* info->chmap must be zero-terminated; allocate a spare terminator entry */
+	chmap = kzalloc_objs(*chmap, 2);
 	if (!chmap)
 		return;
 
@@ -582,6 +583,12 @@ static int had_register_chmap_ctls(struct snd_intelhad *intelhaddata,
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



