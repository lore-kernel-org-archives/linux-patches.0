Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031425;
	b=5lLKHfPPxPgeEWFBpm/vd6VVOImy1ZdUDmEDmda2jpMA/VO9zoI/nIeij4TPVFUZNrRl
	 Y0L5cvay5aPQQDMSVFJbeDqTQcoiGI9Y+rNQwKh9o4Ee1JK6xyQWZX/3qT4BH9ARgA5wA
	 0nDLhdQoBCF1Ih7Af3O8AzeZ86HPAT7Kb28FVmwWitg1zcA2W/54iRi2rVOIf/z1uRYDh
	 Ri0820YBQCeqKx8fWWsVID6DlKdQHgeZ8FK0z4az+UdspaS4fkRgKI5ja46E6Kr2ntnBc
	 Y14rtMkUL6GDqxZPs5CKE9lCKQwmMxCYziVJdPtHaxpayi4ftkG08/jVwT7pmQFtD/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KMss7+A45XKjt34W/5ncvwaY4gZvgQvJ8mhGDJFWCGg=;
	b=xEIekbNtYfjcvWgQxNUIXAV5G3LFiJPMUFHAIm/v1pXE8uxTnMW7ICPclqKVsgXp5yC+
	 fmIr2IpCUtXAZ9a5agNVpoyB4qoSaCAErqqTbPDvXlL+grMMkS+WCYK6VrsxAPSIp6jtb
	 7q18j1/1N3kVWDluMWjXIM0TXP+O51a0m69RCjkn6fFZjkGwkkRKILQsF/MrJ0f5Zusl8
	 ZF11T22JIaeiBzKlMBiNnWMwn+/ldFIUGcQbsSHisF/miZP59S5uM4zqx8YRYTKVMcKtJ
	 YQleSUbvZ8MSWA4x3EAp5qGhgCJwhG3dZR5yBcUaZSpf/7AqFYNnW9PAoDyWPjh9L4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q+nEoFX0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462D6606A31C;
	Wed, 18 Nov 2026 19:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q+nEoFX0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DDC1F000C4;
	Wed, 18 Nov 2026 19:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031425;
	bh=KMss7+A45XKjt34W/5ncvwaY4gZvgQvJ8mhGDJFWCGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q+nEoFX0VfOlLqeGAhWsAIXNHc2Qaa+ypDBJOCea1qrMTdZeGnVcLsZt7L3X+MAKO
	 snR1b1PNyu6QRCjeXkaHuKkw8cBCZ5VsDCiIFCRlOHC1R0s8iU6exylsxzbkI+eCjk
	 ea4lPI3E18aRwn4WI2ew/PrerndFALIR5rmlqF7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ting-Han Hou <ue081723@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1052/1756] ALSA: virtio: reset I/O message fill level on prepare
Date: Wed, 18 Nov 2026 15:52:59 +0100
Message-ID: <20261118150052.093419825@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Ting-Han Hou <ue081723@gmail.com>

[ Upstream commit f0e9db0f84249b65a72b5fba43e91212281ad378 ]

Since commit fe981e67568c ("ALSA: virtio: use ack callback"), an I/O
message is only queued to the device once the application has filled
the whole period: virtsnd_pcm_msg_send() accumulates the transferred
bytes in msg->length and queues the message when it reaches
period_bytes.  msg->length is reset to 0 only when the device completes
the message.

If the substream is stopped (e.g. snd_pcm_drop()) while a period is
only partially filled, the corresponding message is never queued and
keeps its partial length.  virtsnd_pcm_prepare() resets msg_count,
hw_ptr and the indirect PCM state, but not msg->length.  After the
next start, the stale length is added to the new data, the sum never
equals period_bytes, and the message is never sent again.  Playback
then stalls once hw_ptr reaches that period: writes fail with -EIO
("DMA or IRQ trouble") and drain fails with -EIO.  Capture is affected the
same way after a partial read.

Clear the fill level of all messages in prepare.  Outside of the resume
path, virtsnd_pcm_prepare() already refuses to run while I/O messages
are pending, so no message is owned by the device at this point and the
reset does not race with message completion.

Reproduced in QEMU (virtio-sound-pci, wav audiodev): prepare, write 1.5
periods, drop, prepare, write 16 full periods, drain.  Without this
patch WRITEI returns -EIO after 14 periods and DRAIN fails; with it all
16 periods are played and DRAIN succeeds.  Period-aligned prefill works
in both cases.  The same sequence on capture (read 1.5 periods, drop,
prepare, read 16 periods) fails with -EIO after 10 periods without this
patch and reads all 16 with it.

Found by code inspection, confirmed with the reproducer above.

Fixes: fe981e67568c ("ALSA: virtio: use ack callback")
Assisted-by: LLM
Signed-off-by: Ting-Han Hou <ue081723@gmail.com>
Link: https://patch.msgid.link/20261011125426.35745-1-ue081723@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/virtio/virtio_pcm.h     |  2 ++
 sound/virtio/virtio_pcm_msg.c | 19 +++++++++++++++++++
 sound/virtio/virtio_pcm_ops.c |  1 +
 3 files changed, 22 insertions(+)

diff --git a/sound/virtio/virtio_pcm.h b/sound/virtio/virtio_pcm.h
index 5dd1b43b94932..0f3a433175e49 100644
--- a/sound/virtio/virtio_pcm.h
+++ b/sound/virtio/virtio_pcm.h
@@ -119,6 +119,8 @@ int virtsnd_pcm_msg_alloc(struct virtio_pcm_substream *vss,
 
 void virtsnd_pcm_msg_free(struct virtio_pcm_substream *vss);
 
+void virtsnd_pcm_msg_reset(struct virtio_pcm_substream *vss);
+
 int virtsnd_pcm_msg_send(struct virtio_pcm_substream *vss, unsigned long offset,
 			 unsigned long bytes);
 
diff --git a/sound/virtio/virtio_pcm_msg.c b/sound/virtio/virtio_pcm_msg.c
index 8c32efaf4c529..50a98e0b4cfd0 100644
--- a/sound/virtio/virtio_pcm_msg.c
+++ b/sound/virtio/virtio_pcm_msg.c
@@ -182,6 +182,25 @@ void virtsnd_pcm_msg_free(struct virtio_pcm_substream *vss)
 	vss->nmsgs = 0;
 }
 
+/**
+ * virtsnd_pcm_msg_reset() - Reset the fill level of all I/O messages.
+ * @vss: VirtIO PCM substream.
+ *
+ * Messages that were only partially filled by the application when the
+ * substream was stopped are never sent to the device, so their length must be
+ * cleared before the substream is started again.
+ *
+ * Context: Any context. Takes and releases the VirtIO substream spinlock.
+ */
+void virtsnd_pcm_msg_reset(struct virtio_pcm_substream *vss)
+{
+	unsigned int i;
+
+	guard(spinlock_irqsave)(&vss->lock);
+	for (i = 0; vss->msgs && i < vss->nmsgs; ++i)
+		vss->msgs[i]->length = 0;
+}
+
 /**
  * virtsnd_pcm_msg_send() - Send asynchronous I/O messages.
  * @vss: VirtIO PCM substream.
diff --git a/sound/virtio/virtio_pcm_ops.c b/sound/virtio/virtio_pcm_ops.c
index 936319db6a342..497a6c3f7bc5b 100644
--- a/sound/virtio/virtio_pcm_ops.c
+++ b/sound/virtio/virtio_pcm_ops.c
@@ -299,6 +299,7 @@ static int virtsnd_pcm_prepare(struct snd_pcm_substream *substream)
 	vss->xfer_xrun = false;
 	vss->suspended = false;
 	vss->msg_count = 0;
+	virtsnd_pcm_msg_reset(vss);
 
 	memset(&vss->pcm_indirect, 0, sizeof(vss->pcm_indirect));
 	vss->pcm_indirect.sw_buffer_size =
-- 
2.53.0



