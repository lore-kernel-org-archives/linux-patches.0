Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053595;
	b=DwhQTIWjzzmnURW19O1NDZGpQuLyXi61o8DtA2HM4VfL22tACWhL2UVaif006qvzlAVe
	 uNSiIxApWN04oIqUHPVjOJR3AR9WeRJeC1JCW6VnuolMl5bu5q9G7Uy1MTfvYffBnn4ci
	 vak8TKwion/+Mw0jHr1D/SlQ6JZbNy/Iy5/8D0qBaZDJCenNY9O/wBiSgvDY4OrzVpVMg
	 081JKEQiGspQbFy3XDYppEkRJHWNBZUbCW3OO0wOKu6x1hDoCS93/nHyw8PviIT3Qb+4N
	 E2bKKAX7NcdnsNHOdCmTXNmukTGJ3dhhyxhUzpQNR5xGPr7jOkZUdWclVWGawDW31dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9FXA3EAMRFr9fJ3UFTCMk88tzTrgmeoG3qKVvSXV6VM=;
	b=ur4Z1zon/gH6E5vvo3jJfgKyQAmoP3J4kxKLMWMqjFb2RUw9CYV5ClPNX6WfcIKmXOtW
	 2b2i6/hFukk+e2etq9BNH3+tZmSB9dNOgvJqJ+5KCht6E/9wy7zrpfHgwuz0+NB4MQ8NC
	 IyO3OiTeVESMtm+Oa5QVpQKHbcAEsrOjZ0Q/8E+N4ukKQO4Rg9WFQSOTCwKVubN+kMxQI
	 SVt6jeVXKzzmNpS7iD8hsqEo7HQzWd8A23Ze6mez9RTAQQ83O3BlZs7OAYVD1TQanIIeU
	 ka5Il/wXYTgY2CbPACtboSz7GTSFU4Zmfxi+MD+/oUDFsjo355SoJ5iejhTD00enQLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F7aMtZpZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1C1606A31C;
	Thu, 19 Nov 2026 01:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F7aMtZpZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA691F000C5;
	Thu, 19 Nov 2026 01:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053595;
	bh=9FXA3EAMRFr9fJ3UFTCMk88tzTrgmeoG3qKVvSXV6VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F7aMtZpZAvzTJBzpiGFtr2iVOtk/wq5C6Kk1gaDCFEFeqOOCaWwoPmhNVpKlXcTAG
	 e+ML5kzrGlriPjFVBezcr0rBGp+eOjFmArdokRJtmVnwo6dQjQJQ3gPzqKJz6Dcxua
	 +0mWkMfAqZkEwUNPsTBkgP4VpQdn+lAB9wO+cZUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0973/2214] ALSA: bcd2000: Fix use-after-free of MIDI URBs on file close
Date: Wed, 18 Nov 2026 15:44:09 +0100
Message-ID: <20261118150051.190498832@linuxfoundation.org>
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

From: YuanZhe Liu <25031212351@stu.xidian.edu.cn>

commit f6c7bb1f0799591a62be75b9bcf84245b4f208b7 upstream.

The 5.15.y tree is still built with -std=gnu89, so the guard() and
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
index 95806e031e407..69c0f1b964b29 100644
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



