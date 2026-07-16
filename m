Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAACF3D25D0;
	Thu, 16 Jul 2026 14:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211768; cv=none; b=re2BXftNEgF9zzNbcO1qcfhtzl57n3R5fRshMh5ulAHNDQo/m+BxoTQ1AiaefD/pbnJZAjzx1EhMpL0jXpjP6PQX6cTQGZih2Mz7qOj2A7L2IkZOS/JuwoYgwJi2gVr2uBsiX2BbnXrsAmzf7V5oeo9suemoMHoqLtDSjbQa1SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211768; c=relaxed/simple;
	bh=cqyikwPYUJ+EbsO00kFD4rkvZUjsx517pyIFFEg9RhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tf0R4beDlxUOyyGT08ZxJVzoH5X3bjz6P8Z10vbWLNs4/WXYeeea99EF263cNeTNoumlmIgPWgJcGhvr4vQmWO2nzwzdaTuGxym58JgEqdcUj+hyLKvVMHndEWdoqzBFwSpdzX1XSxrCtZiBf5af93BNP47XsSzxupo05ATfduw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=otNXLClB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="otNXLClB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A641F000E9;
	Thu, 16 Jul 2026 14:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211763;
	bh=75rfaWkVbL5fHanITVuEW/ixcTc2+YWVJ0b/N1I8ZWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=otNXLClBmEGme47/N6IngrtY4goLsko6VIGh+Cp9wqKLpmWqvioTl5u2ltArmrl1Q
	 Uqyr7IWPqBu3kOC4Mz/hd2MG3cglOu7BsOdRKBzEypQlFRM4qRHO6ed9/Q3iIPPkDX
	 mFPb3QZpu9S5jwHBB8j6sr866ycGL5UwlwxX/BYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 071/349] ALSA: virtio: Add missing 384 kHz PCM rate mapping
Date: Thu, 16 Jul 2026 15:30:05 +0200
Message-ID: <20260716133034.911991303@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit 83fbbcb7935ec6d2c8ba3bc133e8a0ead2ab0b2d upstream.

The VirtIO sound UAPI defines VIRTIO_SND_PCM_RATE_384000, and ALSA
has SNDRV_PCM_RATE_384000. However, virtio-snd's rate conversion
tables stop at 192 kHz.

A device advertising only 384 kHz is rejected as having no supported
PCM frame rates. A device advertising 384 kHz together with lower rates
does not expose 384 kHz through the ALSA hardware constraints. The
selected ALSA rate also needs a reverse mapping for SET_PARAMS.

Add the missing 384 kHz entries to both conversion tables.

Fixes: 29b96bf50ba9 ("ALSA: virtio: build PCM devices and substream hardware descriptors")
Fixes: da76e9f3e43a ("ALSA: virtio: PCM substream operators")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260515-alsa-virtio-384k-rate-v1-1-35ecb5df835c@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/virtio/virtio_pcm.c     |    3 ++-
 sound/virtio/virtio_pcm_ops.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/sound/virtio/virtio_pcm.c
+++ b/sound/virtio/virtio_pcm.c
@@ -77,7 +77,8 @@ static const struct virtsnd_v2a_rate g_v
 	[VIRTIO_SND_PCM_RATE_88200] = { SNDRV_PCM_RATE_88200, 88200 },
 	[VIRTIO_SND_PCM_RATE_96000] = { SNDRV_PCM_RATE_96000, 96000 },
 	[VIRTIO_SND_PCM_RATE_176400] = { SNDRV_PCM_RATE_176400, 176400 },
-	[VIRTIO_SND_PCM_RATE_192000] = { SNDRV_PCM_RATE_192000, 192000 }
+	[VIRTIO_SND_PCM_RATE_192000] = { SNDRV_PCM_RATE_192000, 192000 },
+	[VIRTIO_SND_PCM_RATE_384000] = { SNDRV_PCM_RATE_384000, 384000 }
 };
 
 /**
--- a/sound/virtio/virtio_pcm_ops.c
+++ b/sound/virtio/virtio_pcm_ops.c
@@ -90,7 +90,8 @@ static const struct virtsnd_a2v_rate g_a
 	{ 88200, VIRTIO_SND_PCM_RATE_88200 },
 	{ 96000, VIRTIO_SND_PCM_RATE_96000 },
 	{ 176400, VIRTIO_SND_PCM_RATE_176400 },
-	{ 192000, VIRTIO_SND_PCM_RATE_192000 }
+	{ 192000, VIRTIO_SND_PCM_RATE_192000 },
+	{ 384000, VIRTIO_SND_PCM_RATE_384000 }
 };
 
 static int virtsnd_pcm_sync_stop(struct snd_pcm_substream *substream);


