Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208525;
	b=hWaKbDXN2QhKjwONkCRFCj/xhiREKFgvUexDB5u2nfmH3YRi31rJgE/mWWKIxr5TtcSb
	 fGZ6IOUaC3JVQgAOKNbAcJJFBV29pp5411trqVpi8bTgd6oU98Y0n78E3Ici4k3caLS1E
	 5XrrxgIHJSZ7ePg28QqP/f4w1d7dHQySqKBXrvZhYoomOIbO0chxMC0Y52XdBQEpb7voS
	 BMUFvaa84D2aznccH+hRnwBUxUwWNpu+jPRE1sTBWuoeWRue0RvTDRqD1WKvVtW5ca0aa
	 tp8u4ZSjMwxBMfKifzuQVIlGec3LZ+4oYe2Cif7gtQAU3jo+p91GK+xkIJ4YJz/IsOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208525;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TKjv5rx6psh7IjzMAJxqCPUAmVjqT9WxL6RhmE7isi4=;
	b=3K5GrBlQZcTRXLmR6+78Gj2ikMjV2FwFMER04a3FwAIPgW5+PJRYplF/jZ4SlR3LtexC
	 cFx26DO4qUqPd3i18ODTHLxRnHD6/zG9LlGlwwqtjltutxvL90seSty2nDnhaZaoSeZAo
	 Leg0b18QMlZWygePK4QyJYADTnrcpFXEdXFq/tfUTJpXt0LV40+oqnjlZsLGosTOaE7lA
	 +yfGnytXzDOryEiJW5YCudbbJGcTtZTyMJl8lW2WKRsfq9QG1u0/plr7o0IU2jDQsCi5S
	 rkpS6z13eHtzyY4Ipd17FBHhWRTUtwEYHqUhIEj0Rohu1cc/ury/nmyuA/rt38cmNKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x418YahD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F294606A31A;
	Wed, 28 Oct 2026 17:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x418YahD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807F81F01825;
	Wed, 28 Oct 2026 17:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208525;
	bh=TKjv5rx6psh7IjzMAJxqCPUAmVjqT9WxL6RhmE7isi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x418YahDb/dbCOjePYAwJPFhFJCcqNH9KT3kPHmCeKApJekkYPdN4sdQ0giwR/dNn
	 mSX44+caNEcMt/7kVYkZGiCFSnOGiUEPnwp6uzly7gFuzhYphovA4/B8UEcByKy1RT
	 L+OdX22LfFyMuCAL206merf3hR/cKde1Miw2JkM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Zizhi Wo <wozizhi@huawei.com>
Subject: [PATCH 5.10 151/516] vt: skip screen update for DEC alignment test on backgroup consoles
Date: Wed, 28 Oct 2026 17:55:03 +0100
Message-ID: <20261028170007.084474724@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Zizhi Wo <wozizhi@huawei.com>

commit 0928ed9bd7946baee911efa401088697836e3b1e upstream.

[BUG]
Recently, we encountered a KASAN warning as follows:

BUG: KASAN: slab-out-of-bounds in fb_pad_aligned_buffer+0x11f/0x140
Read of size 1 at addr ff1100015fd9f6a4 by task tty_fbcon_oob/1239
CPU: 7 UID: 0 PID: 1239 Comm: tty_fbcon_oob Not tainted 7.3.0-rc1 #100 PREEMPT(full)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-4.fc41 04/01/2014
Call Trace:
 <TASK>
 ...
 kasan_report+0xf0/0x120
 fb_pad_aligned_buffer+0x11f/0x140
 ccw_putcs+0x86c/0xa80
 fbcon_putcs+0x338/0x410
 do_update_region+0x21d/0x450
 do_con_write+0x1e0e/0x4880
 con_write+0x13/0x80
 n_tty_write+0x374/0x1010
 file_tty_write.isra.0+0x404/0x7a0
 ...

reproduce:
1) open /dev/tty0, set a KDFONTOP ioctl with op.op = KD_FONT_OP_SET,
op.width = 8 and op.height = 16 (visible VC1)
2) open /dev/tty1, set a KDFONTOP ioctl with op.op = KD_FONT_OP_SET,
op.width = 28 and op.height = 24 (invisible VC2)
3) echo 3 > /sys/devices/virtual/graphics/fbcon/rotate_all
4) write EShash8(esc hash8) to tty1

[CAUSE]
All VCs render to the framebuffer. setfont only modifies the target VC's
font without resizing the framebuffer backing buffer (par->rotated.buf);
the buffer is only resized for the visible VC
(fbcon_do_set_font -> ... -> vc_do_resize -> update_screen). This relies on
the con_should_update() check performed before every update_region().

However, the ESC # 8 path (do_con_trol -> do_update_region) omits the
con_should_update() check. After changing the font size of an invisible VC,
do_update_region() fills using the new font size against a buffer that was
never resized, causing an out-of-bounds access.

[FIX]
Only push the update when the console is visible and not blanked, add
the con_should_update() check in the do_con_trol() like every other call
site of do_update_region() (update_region(), invert_screen(), ...).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@kernel.org>
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Link: https://patch.msgid.link/20260905064337.3083103-1-wozizhi@huaweicloud.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2544,7 +2544,8 @@ static void do_con_trol(struct tty_struc
 			csi_J(vc, 2);
 			vc->vc_video_erase_char =
 				(vc->vc_video_erase_char & 0xff00) | ' ';
-			do_update_region(vc, vc->vc_origin, vc->vc_screenbuf_size / 2);
+			if (con_should_update(vc))
+				do_update_region(vc, vc->vc_origin, vc->vc_screenbuf_size / 2);
 		}
 		return;
 	case ESsetG0:


