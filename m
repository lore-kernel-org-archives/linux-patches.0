Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059337;
	b=uHd/IkUY3KCU7GuXmtuERlSp9rlOuF3s5RLxWybWgbZIFTHqlZ3Y+lS9PNBjvdol7Tsu
	 y8Z14R/rpU9Jl3HkKGLYRx22HLk1/cETaWMYs9MSkxyXBqhsh+spKBBzJQNJ83pPB2gC3
	 cYrEHlAOHlUKsbf0R6bf80DX36FYfEVdYQfJqQ5RWbYx+DgqoMuKFI2RdR5KR0h8SEcGD
	 6VO9uE7pZRZgoX8r3ZLFemtjvxa/GuwUddFEbIEWw0NWkE21EGOdy+mxID3SDSkCJUFch
	 yhYf1f+wjL0nhTb5e6Tnq0aXPN7ckZ3MG4qz8ZNglrsd4plOASF5E5yI7woEBSD/TBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059337;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/jBBKUN7UuRm68HQpbjFPm0n8Mrj38LrpRbwEwB3Km4=;
	b=pfZN7UqLXx5wwcK83homQtf/qz7Uhhf2p9xvfk+1p/U1+NS0nQqJaJQKkQeKDphlu44a
	 GaKTyIldUhnWA93ea+6b76Tm75Yd9fkcn/4qXFOz1UT5qElTKRkXqe36dj15nNJq89Jr+
	 Rmyt2xttpziIa0z7WTGoqeYjdmXT1OYXexPEdasZMSoH0j6hEikmByRK0SRstNto1YBGh
	 pZ3c+IafHeyrlEM53xw9GC4/+Y4xdQlBLOJhYPQgYx6cDs7V7Yv7uFwTNtLNFqf6AEM+A
	 8Uf0ng6QEt5iHdHVb0QBGZjsDzucjij503kDd/D8WulJsLuTZzPIAhNpHepL6g3UXGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Z5Tc6Jb/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE03606A31C;
	Thu, 19 Nov 2026 03:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z5Tc6Jb/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D42D1F000CC;
	Thu, 19 Nov 2026 03:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059336;
	bh=/jBBKUN7UuRm68HQpbjFPm0n8Mrj38LrpRbwEwB3Km4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z5Tc6Jb/KJVFyrfa9ju6HtDOoBU29+NUYaQC5027aT2pZgUVZJdJKett43JZtu+Gr
	 b4LahivEbnFo9Ya/xlQEKKPlbm2hV9vYH9wL6d+pUUSBF11sFsnhpTNz9xtRW64s9d
	 pEI6FySITQvFi7Ot47DGnQ46j1Q7Ly+fuLFzL7eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0806/1848] ALSA: bcd2000: Fix use-after-free of MIDI URBs on file close
Date: Wed, 18 Nov 2026 15:47:24 +0100
Message-ID: <20261118145950.076519207@linuxfoundation.org>
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

From: YuanZhe Liu <25031212351@stu.xidian.edu.cn>

commit f6c7bb1f0799591a62be75b9bcf84245b4f208b7 upstream.

The 5.10.y tree is still built with -std=gnu89, so the guard() and
scoped_guard() helpers used by the upstream patch cannot be used
here.  Use explicit spin_lock_irqsave()/spin_unlock_irqrestore()
pairs instead; the locking scope is unchanged.

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
 sound/usb/bcd2000/bcd2000.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/sound/usb/bcd2000/bcd2000.c b/sound/usb/bcd2000/bcd2000.c
index da2c843440d27..ff11d673aebf3 100644
--- a/sound/usb/bcd2000/bcd2000.c
+++ b/sound/usb/bcd2000/bcd2000.c
@@ -185,11 +185,26 @@ static int bcd2000_midi_output_open(struct snd_rawmidi_substream *substream)
 static int bcd2000_midi_output_close(struct snd_rawmidi_substream *substream)
 {
 	struct bcd2000 *bcd2k = substream->rmidi->private_data;
+	struct urb *urb = NULL;
+	unsigned long flags;
 
+	/*
+	 * Reference the URB under the lock so that it stays valid until
+	 * usb_kill_urb() returns, even if a disconnect frees it in the
+	 * meantime.  usb_kill_urb() cannot run under the lock, as the
+	 * completion handler takes the same lock.
+	 */
+	spin_lock_irqsave(&bcd2k->midi_lock, flags);
 	if (bcd2k->midi_out_active && bcd2k->midi_out_urb) {
-		usb_kill_urb(bcd2k->midi_out_urb);
+		urb = usb_get_urb(bcd2k->midi_out_urb);
 		bcd2k->midi_out_active = 0;
 	}
+	spin_unlock_irqrestore(&bcd2k->midi_lock, flags);
+
+	if (urb) {
+		usb_kill_urb(urb);
+		usb_put_urb(urb);
+	}
 
 	return 0;
 }
-- 
2.53.0



