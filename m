Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058673;
	b=CwCn3Ijctt5zdrXXFLKvm3X7j86eJf0Od0Ll9lbApZntJGkpYBqiG85ymfgV1jfmQ+fK
	 edMW+9DUhY+uLxDU4Yk1kfDhrQJBXGGTnjjXuZOM/VQlOvT0+RKjmQ6CSlm5blRQTNl6Q
	 aaQpXtPCRgMx1du1biCNhtukHfV9DaUQ3ps7CWzU50tY4kD2z1O4mj//DzCiPxRybYOlR
	 heSNtdsk2MM92ArZqdBcXrhJuStRnMLnH4O0BASODUYTsQTmXVUF9CGk8j7ZlkyyLpbIH
	 dKYXbFuuOz92KHQ6M2H1jLZRo5q2EckP7VOayGATJvn/Cvl22PUxTHMTBilmBx2cpRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058673;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t8YtEGnYeRuxOLxk0ZKSPu008qRjN9g1A8RMamLAtpw=;
	b=ZPQ9T14tOXl2QzIR+sWbBLa5tVJKQqcKEKQ6BmIDbu5/BFa69rwewTdJGFl86sBbG8vC
	 K/HoNshaCSkBofwXSH7zRUIBi2tu9bZ9xtggTj1zF6r0deEAAyHhq1/fb1RZCBIJ7vkN6
	 I8AwnmfdF2/nKG35uTxgQeP7x0YiSnB/GXOQ1ac238w4188InApeFXFogIbvrtRQt2bKk
	 G/ZAG8eWTOCF1ng16+kjz1+ZLmJ0hP2iFrRcT3AQmluh4WTs/4qdjNuQspUean6QI8duL
	 lCFj/x2TnFi0apTP63Qm94e6Sohim80xOohWktRvwda1Gv5p7Xv58hQ/1X5hJ16Ubvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FgtTwe06;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2090D60A2609;
	Thu, 19 Nov 2026 03:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FgtTwe06
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1DA1F000C7;
	Thu, 19 Nov 2026 03:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058672;
	bh=t8YtEGnYeRuxOLxk0ZKSPu008qRjN9g1A8RMamLAtpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FgtTwe06JbYToCqoWkhn2m0KTMGa9RRhB+wQ3W+MY5D3SbkIq0Gi9BHtRUtxgYsYZ
	 XIeZ+oPY4ttxjXjQYqdCgPCol6rPw8wNGm2/NR7kHY93gnpjKzHwOop7jGzC7flG/M
	 2VGYAy0k7ka1Z4lGq/UeObBzq9oIwL+nSpRdl3A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0532/1848] ALSA: seq: oss: Skip events until fully initialized
Date: Wed, 18 Nov 2026 15:42:50 +0100
Message-ID: <20261118145937.219944593@linuxfoundation.org>
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
index 4534a154b8c80..68747e6553b49 100644
--- a/sound/core/seq/oss/seq_oss_init.c
+++ b/sound/core/seq/oss/seq_oss_init.c
@@ -264,6 +264,7 @@ snd_seq_oss_open(struct file *file, int level)
 
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



