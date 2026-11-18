Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046489;
	b=GRtszB2yt04MKCSygIlDfdeVgXb5pCqmggpM7u7PnJ+n+Ik6IbrBIveqWEHh02HpkgO5
	 SegpNga+awUuLVy6+o5L6w2jkrK3adYDpenKn6F6zrgxZu2BkdqptXs78QNMAzE/KbHNh
	 FwS3uCoXoM0Bss/3zXNWC1lXD1cLghcU22dktRz0l7WhIltOYi/j8oP20XiKf8sFRBRqQ
	 I75mfeqJSuSgguDXA/7uHcWzywj3PDHrEuf7LTVLYWaEGmZMsSGhAktW7otnqOkdJjcsD
	 yMGuKPiV8+5qaLh7hycX7/TnBsizHXPCkaBWoCXgh2UFmyH9sTkO5ZrWdFWMU0No9bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xyHX6CzytX1Frx9Wy+EvdNeSi3pKcCsmudzVn5TKgL4=;
	b=DiG6BqDTAAgyi1oc4GikMTxzFPctXKizjCqpQ6z6CkAKl8QkPVT2H1reepw606gmVZoN
	 oLLhwQhHMxR1mcOZ6LHWQ9JLgIh7BdDhZsWodMDSKHgQ+6w8LKeR8gKWnWEFquz67L1Lc
	 67C5k9g13qFMhnAED8ANHUPwOKkyELPn/TJ5mGK3J2gOHDSe3BnmV6IX7KKj05CEp8OVn
	 InRGC1PkC7kk1Av4jUOdnZEEeWxAZMH24pm7hQyUdd7MutZ50Vx6Sjk80wBifxsjK2ql5
	 RypWmGjKnUH4gH6L4JT7AU0hahDd7ZPiBRoR+EWQ2HaYNk2h2J9KC5n6k5f6FeagznA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QqmfwiS1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F8D606A320;
	Thu, 19 Nov 2026 00:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QqmfwiS1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696D01F000C5;
	Thu, 19 Nov 2026 00:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046489;
	bh=xyHX6CzytX1Frx9Wy+EvdNeSi3pKcCsmudzVn5TKgL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QqmfwiS1pfAfVH1A4pZOggIxPIo+DR8iaz7Ls9UkGdtAeu4DGqxgwGeB/iq4ys6AK
	 scUHuvvXzS9PTbxfNklxDSwUOvZNQOapkB8jVbeYS6LQV1Iufh36jfHOgdIXaaB1Kb
	 LJ8o+lF1HhwEkAm0PbhR8G7YoHdVkERzcD6+9s9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1300/2857] ALSA: bcd2000: Fix use-after-free of MIDI URBs on file close
Date: Wed, 18 Nov 2026 15:38:54 +0100
Message-ID: <20261118150248.287895256@linuxfoundation.org>
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

From: YuanZhe Liu <25031212351@stu.xidian.edu.cn>

[ Upstream commit f6c7bb1f0799591a62be75b9bcf84245b4f208b7 ]

bcd2000_disconnect() calls snd_card_disconnect(), which only prevents
new opens, and then frees the MIDI URBs.  A rawmidi file that was
already open can still be closed afterwards, and its close callback,
bcd2000_midi_output_close(), calls usb_kill_urb() on midi_out_urb.

The URB pointers are cleared on disconnect and their accesses are
serialized with midi_lock, but bcd2000_midi_output_close() reads
midi_out_urb without that lock.  The check can therefore pass just
before the pointer is cleared, and usb_kill_urb() then runs on the URB
that has already been freed:

  BUG: KASAN: slab-use-after-free in usb_kill_urb+0x74/0x80
  Read of size 8 at addr ffff8880078e7d40
   usb_kill_urb
   bcd2000_midi_output_close
   close_substream
   rawmidi_release_priv
   snd_rawmidi_release

  Allocated by: usb_alloc_urb <- bcd2000_init_midi <- bcd2000_probe
  Freed by:     usb_free_urb <- bcd2000_midi_free
                <- bcd2000_disconnect

Take the lock in bcd2000_midi_output_close() and reference the URB with
usb_get_urb() before releasing it.  The URB then stays valid until
usb_put_urb() after usb_kill_urb() has returned, even if a disconnect
frees it in the meantime.  usb_kill_urb() itself cannot run under
midi_lock, as the completion handler takes the same lock.

Fixes: b47a22290d58 ("ALSA: MIDI driver for Behringer BCD2000 USB device")
Cc: stable@vger.kernel.org
Signed-off-by: YuanZhe Liu <25031212351@stu.xidian.edu.cn>
Link: https://patch.msgid.link/20261031190936.5696-1-25031212351@stu.xidian.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/bcd2000/bcd2000.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/sound/usb/bcd2000/bcd2000.c b/sound/usb/bcd2000/bcd2000.c
index 8be080d33eb0f..41a64f29fdffb 100644
--- a/sound/usb/bcd2000/bcd2000.c
+++ b/sound/usb/bcd2000/bcd2000.c
@@ -183,10 +183,24 @@ static int bcd2000_midi_output_open(struct snd_rawmidi_substream *substream)
 static int bcd2000_midi_output_close(struct snd_rawmidi_substream *substream)
 {
 	struct bcd2000 *bcd2k = substream->rmidi->private_data;
+	struct urb *urb = NULL;
 
-	if (bcd2k->midi_out_active && bcd2k->midi_out_urb) {
-		usb_kill_urb(bcd2k->midi_out_urb);
-		bcd2k->midi_out_active = 0;
+	/*
+	 * Reference the URB under the lock so that it stays valid until
+	 * usb_kill_urb() returns, even if a disconnect frees it in the
+	 * meantime.  usb_kill_urb() cannot run under the lock, as the
+	 * completion handler takes the same lock.
+	 */
+	scoped_guard(spinlock_irqsave, &bcd2k->midi_lock) {
+		if (bcd2k->midi_out_active && bcd2k->midi_out_urb) {
+			urb = usb_get_urb(bcd2k->midi_out_urb);
+			bcd2k->midi_out_active = 0;
+		}
+	}
+
+	if (urb) {
+		usb_kill_urb(urb);
+		usb_put_urb(urb);
 	}
 
 	return 0;
-- 
2.53.0



