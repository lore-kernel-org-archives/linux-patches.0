Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056198;
	b=SACIG3LgoajwCFocim841Kf+4V0Gg/XK5beaBp0Qqtp2fp9bMlI1QrK/Z6uePGWEjx4a
	 /g1Y93Jks8i5XkWXYLBKms97lVu2xKcvxTpgLUBUUZSQSoUnJ6mPyMI1yIzpA7ssYQ3AH
	 K0SgWwEIkgr4z1w0z40XqJTktE+vGCO1+uMQhvXPdE0690KlkfIth3LKriXBNJ3GQmL8r
	 9JjuNdiXWb4A3ggkdzwdB1yQ9herrQ/vg2DUYUwxYjYaeyVyyjBeOg8V4LebH3jRIZ0BU
	 +Zrm4q+fNd7rFNN7G8puHKWsrMtkBGzPKu/7bJBUpcle+g55HLE6gLq7t4NJWqVnIuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056198;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2gHwMYCb8jpnkWUt/nG1Hpx2HLzyt7+pvaImELi8Xb4=;
	b=5jb0WZtYfn2hoYuQ4b2wCKUs+pHq8m095ysLvHHO2huOFreBddX8uxat68eSfATDooM3
	 E8AKJkWkp06d6vA7RuV/Um3/BuQVa4ooYiP6F4hg4Fkq6XMLI4wLbCnEL6yuDgvwO12b7
	 tmW3JtOF9ZZEqmUOVtjPSWQD0ihMr+3aKP7t4FKl5pEHwGdX3JM/JpIfZoPhCNH4FXi46
	 3R8o2n6ZuF4ccp7AeOba0dniiZX4zWGDojn/Hf1qFEwvDdyymd0Z+wXWCHjt4quROF73I
	 2eBFCa8Qrnc416h2CZALGy4nB6SJQzORwKV5w5TXs6vLfEdSgsLp0WpHgqvTkHM6KCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N3ukHqZi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655B8606A320;
	Thu, 19 Nov 2026 02:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N3ukHqZi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B491F000C4;
	Thu, 19 Nov 2026 02:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056197;
	bh=2gHwMYCb8jpnkWUt/nG1Hpx2HLzyt7+pvaImELi8Xb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N3ukHqZiHN3egWSF8NdRR0nXCHjY/+T7wFYw8U50KELiw87dC1+N3P4MQNzhhzgnr
	 kw35/ybzEMEYKaDlQNPdWqczi6zqOPsQH4lan+6/jh4B/UTDcF7M4eEyJTFj5eI3e+
	 CYhX2k0YuaSSM62wxZWqxQ5wf/uVul0N1SV/Q+p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1862/2214] ALSA: rawmidi: Drain input work before freeing the runtime
Date: Wed, 18 Nov 2026 15:58:58 +0100
Message-ID: <20261118150125.820358967@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 8c3529f0a8faaac7d73333486f69da1617ecc579 ]

The input runtime embeds event_work, so the work must be drained before
close_substream() frees the runtime. The cancellation in
snd_rawmidi_input_trigger() runs before close clears substream->opened,
leaving a window for snd_rawmidi_receive() to enqueue more work.

With a sequencer subscription to a USB MIDI input port, an in-flight
completion can overlap the last subscription's midisynth_unsubscribe():

1. snd_usbmidi_input_data() observes input_triggered and is delayed
   before calling snd_rawmidi_receive().
2. Unsubscribe enters close_substream(), clears input_triggered through
   the provider trigger callback and returns from cancel_work_sync().
   The substream is still opened.
3. The completion resumes. snd_rawmidi_receive() takes substream->lock,
   sees opened set and queues runtime->event_work before dropping the
   lock.
4. Close clears opened under that lock, closes the provider and frees
   the runtime. Stopping USB URBs does not drain the raw-MIDI work.
5. The queued work runs and snd_rawmidi_input_event_work() reads event
   or substream from the freed runtime, causing a use-after-free.

Cancel input event_work again after clearing opened, before closing the
provider or releasing the runtime's private data. Receive holds
substream->lock through its opened check and work enqueue, so once close
has cleared opened under that lock, no further receive can queue work.
The final cancellation therefore drains any late work before the
runtime is freed. Keep it outside the spinlock so a running callback can
finish.

Fixes: b3c705aa9e91 ("ALSA: rawmidi - Use workq for event handling")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Link: https://patch.msgid.link/pm-pmb-98489078ab56528d8e4a-v2-9408ce8c8f3c70b5c10d@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/rawmidi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index b1632ab432cf7..add1cea72c4c7 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -522,6 +522,9 @@ static void close_substream(struct snd_rawmidi *rmidi,
 				snd_rawmidi_output_trigger(substream, 0);
 		}
 	}
+	/* Drain input work queued after the earlier cancellation. */
+	if (substream->stream == SNDRV_RAWMIDI_STREAM_INPUT)
+		cancel_work_sync(&substream->runtime->event_work);
 	substream->ops->close(substream);
 	if (substream->runtime->private_free)
 		substream->runtime->private_free(substream);
-- 
2.53.0



