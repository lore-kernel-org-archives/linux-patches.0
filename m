Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052696;
	b=hkkAQJvtEMhCkpnGbGUG3WIMDA0mL4ukYOxxz+tBU47W6c+6hoUGxuWuarTYFHXnKn5y
	 N76LJWy36mP1/DWeB0JaXdvIp+BdBKaDG7wfX8h/HlQUkMNxEP683ynW4nyIxlFaq8R3v
	 NB4/AaKbMXU2AmZ1cYm4XnUFp3nnFWqwOl4NrEYPq2tkAf30Sedviv2vkS3/vl05cf3bg
	 nEyXH12NH649ZqX1/XG+2Bg8rbrvsRrNRYYgr0036M6cgYIFSjejfOzh8jCU2qSkt4nXx
	 CHKAFEeo8oXlGgWEzzIl/oe5HjckcKUr3GOnkiMpGwfCLDUhvHs72GEvhki55KsJlfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052696;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V4YxgUwTkclE2AN5jslrALyChF5/nzZkf4P5NpA3WVk=;
	b=aUe0YEOPe1n3UeAaJpdVp2XEqSvU0ZYH1jc/gAmrte/13F78S6nU9jKm7MvaiB+wgqYC
	 X3bjsILRwICYdoaA7aN013Z2aXVh5M2RSfqQAmxxC6QpMXhs2ou0UHX02q8f75nBiH7cN
	 ZXkT2LXoKlJFRzj+RFhZ2ZF3SEDfFeEfJ3DWzgEycxVzUzCXnocVU69b32ej+rBKayCBr
	 u2au4oAp0yrcShaQRTZNZjmq1KGJx1orI4FCVDnye7SUhyJPMgfLPsI4qQqxQ6xp5b1Jf
	 s0hvykS3v5lWU9jSDRvp9L/4Vb4M4yxjUqVhM0y0OgRL55qgh7R5HG79q6fUw8xzoUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Lq+/8IhO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD25E606A330;
	Thu, 19 Nov 2026 01:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lq+/8IhO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2BE1F000C4;
	Thu, 19 Nov 2026 01:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052696;
	bh=V4YxgUwTkclE2AN5jslrALyChF5/nzZkf4P5NpA3WVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lq+/8IhO7tXPpFTOOp+pCA9v2hF8Z4zJPsJC+2VYRVWvRzBwkoL8P0cWl3DYXER1k
	 mYbFKHz1pMcenRsegIAJLaLnJVpHCiK5nGULzL/FKhYUBzrJDFDmIIsO44c6g946iz
	 qX1P/b2JtUxKn7S/xqrk5QZLE71xQlMIuiowQmuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0656/2214] ALSA: seq: oss: Skip events until fully initialized
Date: Wed, 18 Nov 2026 15:38:52 +0100
Message-ID: <20261118150037.772538350@linuxfoundation.org>
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
index 7b7c925dd3aa2..cb7e3d14a6955 100644
--- a/sound/core/seq/oss/seq_oss_event.c
+++ b/sound/core/seq/oss/seq_oss_event.c
@@ -425,6 +425,9 @@ snd_seq_oss_event_input(struct snd_seq_event *ev, int direct, void *private_data
 	struct seq_oss_devinfo *dp = (struct seq_oss_devinfo *)private_data;
 	union evrec *rec;
 
+	if (!dp || !smp_load_acquire(&dp->initialized))
+		return 0; /* ignored */
+
 	if (ev->type != SNDRV_SEQ_EVENT_ECHO)
 		return snd_seq_oss_midi_input(ev, direct, private_data);
 
diff --git a/sound/core/seq/oss/seq_oss_init.c b/sound/core/seq/oss/seq_oss_init.c
index 0ee4a5081fd6a..10459bae05a09 100644
--- a/sound/core/seq/oss/seq_oss_init.c
+++ b/sound/core/seq/oss/seq_oss_init.c
@@ -264,6 +264,7 @@ snd_seq_oss_open(struct file *file, int level)
 
 	client_table[dp->index] = dp;
 	num_clients++;
+	smp_store_release(&dp->initialized, true);
 
 	return 0;
 
@@ -409,6 +410,7 @@ snd_seq_oss_release(struct seq_oss_devinfo *dp)
 
 	client_table[dp->index] = NULL;
 	num_clients--;
+	smp_store_release(&dp->initialized, false);
 
 	snd_seq_oss_reset(dp);
 
-- 
2.53.0



