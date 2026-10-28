Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212575;
	b=stpty9yUiK6ZkKaXEEc7+vcCer2nSzbAj1pWI3o4Vh+K9Dayaty5VtOeKUL8tBcEcRPn
	 4YQL6f0IJQsG47vubEiZjImpz2Pt60gAWKfjecOWu8KmM+LLeRyeXjlr/24qYNyc93yZz
	 4oxiz9G9GmbSQQKrqOx6e/vh5/qg2uaNnVA9onT6J6r4Y0xbrEJITv9cPWBAs2Ok2Nw9j
	 ClTSuwvD0RdGGu2DUUvMCLDYMLI0jrpBV9IwZkm+lE1+pn/ROT6y8l0eBlQ4frt5/GHSa
	 1Wd3hgphY7QNS4li4RUs46QO3vYNzK+QrlArUT3jU1YIFS4Pte/lI+XjJzEiwxF5CnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QhUTHLkz5UOhEJ3hdem61oXU/xxbZQa63W5VzngBx8I=;
	b=OpKZSxguTSV7KAZXGp0+KuFfYhpqGkEjTQmWrSI6AAEz0onlJTCMassgEZjjXZAX9tQS
	 hxpj76fr2DgotJGQOGI8VzX3PKZ2b3BIxa+ULOP2ZGl9YVobaCbkAVNXeFFi3XSfnn2dT
	 F+9I5HgFisrsVc2ZiW+ZlTuamkuevC3aU5ZgL0C+c1LKmJCrA2GJZlAvnqGBrkNWVMCG8
	 QF0/RfawhekrXIw7xe6UOvDcznNYGIMRqgM+fC2Q07FW43rRMzqEMQK9ccYxQ3TzLZ7s8
	 3hPpCaVGg+j/LrKgrCXgS44iA33riMPbMBxI1KO3j0GaBggeVb+NG8TSWNS3FdXSxEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HwwG54DX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D339606A31C;
	Wed, 28 Oct 2026 18:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HwwG54DX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5F51F01825;
	Wed, 28 Oct 2026 18:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212575;
	bh=QhUTHLkz5UOhEJ3hdem61oXU/xxbZQa63W5VzngBx8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HwwG54DX5TwNfKLWzQfwtfcLQaeaZP0EeUfvuw3k7fbGn6cO4MGYUJJ+1Wdm6gG+z
	 6nVkG4U7nj4fzod/9pK4fLaC7XqUkbcADO4tKbib37GSQVNj7lCkREoN3XNZY2wauf
	 sT/O+wFCtiUdhdLHxeDAKmDMuH+xuxsK62s4u+o0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Zizhi Wo <wozizhi@huawei.com>
Subject: [PATCH 6.1 0200/1887] vt: skip screen update for DEC alignment test on backgroup consoles
Date: Wed, 28 Oct 2026 17:38:16 +0100
Message-ID: <20261028170503.786996141@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
@@ -2543,7 +2543,8 @@ static void do_con_trol(struct tty_struc
 			csi_J(vc, 2);
 			vc->vc_video_erase_char =
 				(vc->vc_video_erase_char & 0xff00) | ' ';
-			do_update_region(vc, vc->vc_origin, vc->vc_screenbuf_size / 2);
+			if (con_should_update(vc))
+				do_update_region(vc, vc->vc_origin, vc->vc_screenbuf_size / 2);
 		}
 		return;
 	case ESsetG0:


