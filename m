Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045589;
	b=Iqfb422doEDtNy7OGqZxIAi9J3U2QnomXn288KeQ7tXB2bV+M6n6vyfjsYSOdA9EC0M7
	 mRRepV5zUUEIcI8Xbp75Eo0zk3Y57KgR5a6+MgSZ5HaFA1BDw56cnPSvF4O/m5TcVVq2g
	 gFqm5p5n8O2N2ezz+8EYHaCn+JU0Ds+JGD5CNX8j+yeS9xD9F1sKDzymbFbjy5wzISCBE
	 piomRlDkAiZyf1ZXxrMt7ayDx6NHWaV/X/GrCDL9EOxzVuxyBr8VTi3LyeC9APTHctJSb
	 j/GC877pOIt5+DLAA2kz04zVrm6vUlaSmQw+Qa7CjJiiK8Sq6J/s0ZsrkjvkUUBUaTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sZ2E8az48rL2V0YrFQaeupz5TPsVaOy9sAxMAvDDGic=;
	b=n2B4vfo70oxNqoezsE58YA5ag3EfGVkFQOG3yZddlOEA4ffU4sSyjzJLvrhii929qqSM
	 PC9h9RE8kU0ryxci0OjnFiWKC9zfMhAA/nThNsbBTJ3PynIEXvzhludQY3PLAh/ukIMaV
	 AZyyifZR+AZdyMonsoLocHzQ5ToyyptF8fBkRm4CZ6uw/4UoITnTcFmr114uNclFCDr8S
	 pilrz+QTQAduQ4TBOTp8ENxobON5/b1W6gtZ6XeUAW1dw4whtM6OTc//Rkms4/bxCaptV
	 JHUFcZG3teRRso4UA/K5l+lpEb2MlZ7huuxyRJ2VIm3Z2qFuqfJJAFCVmPNo/MkHbdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bu4zj4fn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053B1606A338;
	Wed, 18 Nov 2026 23:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bu4zj4fn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571AC1F000C7;
	Wed, 18 Nov 2026 23:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045588;
	bh=sZ2E8az48rL2V0YrFQaeupz5TPsVaOy9sAxMAvDDGic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bu4zj4fnf4e1pCrJ24PQOHs2wwDjYSYASZNDjsjZ3arUclkQVgkXYoWrOnFlblav8
	 pnCQv3MbTR51DsHyX/J9QB8d7T6Df2dSgLTbW+Q2iluSh6Kru3Gh8PhlVjID7P8aL3
	 P6N8kXAj7ra0a/C5VsA3uP2zDf0DciZiARJByMV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0976/2857] ALSA: seq: oss: Skip events until fully initialized
Date: Wed, 18 Nov 2026 15:33:30 +0100
Message-ID: <20261118150236.746223893@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 68d4a6ea6cc6091a05836f783bc17d525d266d0b ]

When an OSS sequencer device is opened, it creates a sequencer port,
then further initializes the internal states like a timer instance,
etc.  Since the sequencer port is published, an event can be already
delivered, and this may hit unexpected event handling, which can
eventually cause a NULL dereference (like the timer start/stop event
triggered before the timer initialization).

For avoiding such a race, introduce a simple guard and skips the event
processing until the port is fully initialized.
At releasing the device, in turn, clear this guard, so that any input
events will be discarded during the teardown.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20261016161930.482309-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/oss/seq_oss_device.h | 1 +
 sound/core/seq/oss/seq_oss_event.c  | 3 +++
 sound/core/seq/oss/seq_oss_init.c   | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/sound/core/seq/oss/seq_oss_device.h b/sound/core/seq/oss/seq_oss_device.h
index 6c2c4fb9b7537..f0d7bb0e11a94 100644
--- a/sound/core/seq/oss/seq_oss_device.h
+++ b/sound/core/seq/oss/seq_oss_device.h
@@ -73,6 +73,7 @@ struct seq_oss_devinfo {
 	int cseq;	/* sequencer client number */
 	int port;	/* sequencer port number */
 	int queue;	/* sequencer queue number */
+	bool initialized;
 
 	struct snd_seq_addr addr;	/* address of this device */
 
diff --git a/sound/core/seq/oss/seq_oss_event.c b/sound/core/seq/oss/seq_oss_event.c
index 4699c084d018e..fa91eb1233de3 100644
--- a/sound/core/seq/oss/seq_oss_event.c
+++ b/sound/core/seq/oss/seq_oss_event.c
@@ -427,6 +427,9 @@ snd_seq_oss_event_input(struct snd_seq_event *ev, int direct, void *private_data
 	struct seq_oss_devinfo *dp = (struct seq_oss_devinfo *)private_data;
 	union evrec *rec;
 
+	if (!dp || !smp_load_acquire(&dp->initialized))
+		return 0; /* ignored */
+
 	if (ev->type != SNDRV_SEQ_EVENT_ECHO)
 		return snd_seq_oss_midi_input(ev, direct, private_data);
 
diff --git a/sound/core/seq/oss/seq_oss_init.c b/sound/core/seq/oss/seq_oss_init.c
index 42d4e7535a820..e0e5e2853754d 100644
--- a/sound/core/seq/oss/seq_oss_init.c
+++ b/sound/core/seq/oss/seq_oss_init.c
@@ -263,6 +263,7 @@ snd_seq_oss_open(struct file *file, int level)
 
 	client_table[dp->index] = dp;
 	num_clients++;
+	smp_store_release(&dp->initialized, true);
 
 	return 0;
 
@@ -408,6 +409,7 @@ snd_seq_oss_release(struct seq_oss_devinfo *dp)
 
 	client_table[dp->index] = NULL;
 	num_clients--;
+	smp_store_release(&dp->initialized, false);
 
 	snd_seq_oss_reset(dp);
 
-- 
2.53.0



