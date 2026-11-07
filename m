Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064962;
	b=ZValTA7gC7blWRw4p1EnngjZefvOiGOrmTHkRLJa+FakSECP/qboP8fvhyYdbwpaLbI6
	 v7NBdD7PBtQzJKTaf6m1O+eUNVCJr6TCbBecvUTupv6AcHJWBemHRGKoP7smJS3fBSvqc
	 D9OA3ytn0M7gExhEfjATRy8wMhIWAy8J74fGdJWLg74k//hiKg2yVUPMWcsgBvyKPTVul
	 2ajEEGzyVLAqq39xaxxy9gB7M4bImbvnoLpG8Hu5/wwx4LU17rKB9zOOO5b9VdqUZ/l8k
	 TgEQ9YqBZffHOysHa3pC/So60LRjnL/GUcXqGcMnxe7HsVvsjL8atYkVX6rd8dFtqCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gQE9EMn96UZmZYpwjD3tKEVZI0WqJqO2AtHmBetgYYY=;
	b=yocX85rttrSOXJe2Mjvm0vRaJBqLVd16aw6FM54Sa54p3+LNbT4vif9PF55TgvJGlS7z
	 9zaX256jMiXifP/PnxJn7yhFLq7q+XRybwLbJ2IpYBsWTMQ9iobiwpzwOXFRenB5WmdUB
	 4QPy4rXh12cgvr4lDJf7TjhkfiJHov+UZEO8I00NOuSmZ8ifPDlWWSzbZSoC6ZnlYtKBv
	 S9NZUeYbeXoSPcKNpi9jIhoSZ932atf88p7f68sYXgeAZrPM90upthzexCPXVfP+ppmD0
	 c09jjWJeE1z5EvQYZxHTAlyhiTmVJ01QC3Y1ss78walNdFxdeK/J5CHmRqPSI8fcDCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TD0XAVtf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3858A606A9D9;
	Sat,  7 Nov 2026 15:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TD0XAVtf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64BF1F0089F;
	Sat,  7 Nov 2026 15:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064962;
	bh=gQE9EMn96UZmZYpwjD3tKEVZI0WqJqO2AtHmBetgYYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TD0XAVtfIZRr5pzH2fufRRIUp01iTmuZoOoCWcF633vnI48aNEGR/RGoZUhWLOI51
	 xoC6WznemULpy/nll4ujibdhUfx+9wGtvNxdf3z2nHuS7TKkyg0xlxfzHxl2dQZ4Zq
	 WducSUMy/XvOOmhp+IPc2lOjlTicp4hH1WCF+ubg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0846/1257] ALSA: seq: oss: Skip events until fully initialized
Date: Sat,  7 Nov 2026 08:52:22 -0500
Message-ID: <20261107135002.690626657@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 935cf3df0b30f..571186db4fa59 100644
--- a/sound/core/seq/oss/seq_oss_device.h
+++ b/sound/core/seq/oss/seq_oss_device.h
@@ -72,6 +72,7 @@ struct seq_oss_devinfo {
 	int cseq;	/* sequencer client number */
 	int port;	/* sequencer port number */
 	int queue;	/* sequencer queue number */
+	bool initialized;
 
 	struct snd_seq_addr addr;	/* address of this device */
 
diff --git a/sound/core/seq/oss/seq_oss_event.c b/sound/core/seq/oss/seq_oss_event.c
index 122735862044d..20f4c5ce763cc 100644
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
index 1aece46c8b064..a1063dc22d462 100644
--- a/sound/core/seq/oss/seq_oss_init.c
+++ b/sound/core/seq/oss/seq_oss_init.c
@@ -258,6 +258,7 @@ snd_seq_oss_open(struct file *file, int level)
 
 	client_table[dp->index] = dp;
 	num_clients++;
+	smp_store_release(&dp->initialized, true);
 
 	return 0;
 
@@ -403,6 +404,7 @@ snd_seq_oss_release(struct seq_oss_devinfo *dp)
 
 	client_table[dp->index] = NULL;
 	num_clients--;
+	smp_store_release(&dp->initialized, false);
 
 	snd_seq_oss_reset(dp);
 
-- 
2.53.0



