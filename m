Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022545;
	b=vOpSFi+r8zgToq4aOHSAZOCy6kOzKy5Ww8aH7UB8rxXJWiZyoji+3olShaZGgTr621m9
	 zjPV7QehtMaFH0rLzRaapJ3EVBYit1iUYPW138qXlVVvX0nYarUWFRhSDEtvK5vuXFjIX
	 zq6IMRQqj2eRsMAyN193obDSMLtROaO8ajcmLD4NPtS02xSaq/Gqth432MMNETxgniFiO
	 NWOftmxtZerPSn+Uf+1nMCqNY/YSQ83h4aP2xEVW/+ffLEQfeX1b4VoxbYRafX6B4p7ko
	 QzBGoEwLLiW9coHSVMroHBr7t6+r8JopOCzYWGLAhDxxmPCRO3wjn6fFM5Fl1ch+76A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022545;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bom+iC3+702gaj6sTuXyH4dj5XceONfMb+9tB7PiqlI=;
	b=0UDjYAohvwssosd/SK3bkPmkpQbEyKAKdL4yr59ZLkUCIlW6IRdXMXNGQd4GJYeMqEaQ
	 /hVOAWP5rhD6sJyE1HMGv3ZFX7PtNQBD/qaHSnvqH2zCcVn1kAubXHqPrTIUQbYx6iRzr
	 3zAG+bHxxgRrgbIO/0Yjy1qNWe9UavBv/6qXZdJR6SErGBBJVWj2J2rLXHx2ayddlhzYX
	 c72pVT2sXnX+FQdWmzuo6U+6k1VIHuNHrqumuHsYZqlM77JL/J+N0NApWR98AADPXw4LT
	 uaiL9tYmmFg4wbJVWaKsOMYmeinYT5b0clC1QilxSGxepppB+dxg3WoJz6z4ydm0bVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wVK9V16y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E800A606A32A;
	Wed, 18 Nov 2026 17:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wVK9V16y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEF51F000C6;
	Wed, 18 Nov 2026 17:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022544;
	bh=Bom+iC3+702gaj6sTuXyH4dj5XceONfMb+9tB7PiqlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wVK9V16yj4d5IvxIfwjH1rwJVvY4fZmSMK0Pwk4TSpFG8FYksoy8MOI6rwqQlWT4c
	 2IrW1JA4jDRumoVIZRRqR2FXJKBvCwtFeY0dEb8MZ/NGOk9eImC3X3PE+S+njI0rRM
	 BNNaWL1hG2DhmYHkQn4c+eEl+Mr4wlrTZtnY8FMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Yiqi <yaoyiqi3@huawei.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0010/2151] fbcon: Rebuild rotated font buffer on font change
Date: Wed, 18 Nov 2026 15:29:05 +0100
Message-ID: <20261118150122.014403377@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Yiqi <yaoyiqi3@huawei.com>

[ Upstream commit e4b6b865d45d8dafb6c6f28c8a993a5b4431d25a ]

fbcon_rotate_font() caches a rotated copy of the console font in
par->rotated.buf. The buffer is sized from the font's width, height
and charcount, and is rebuilt in fbcon_init(), fbcon_switch() and
fbcon_modechanged(), but not in fbcon_do_set_font().

When the font is changed through KDFONTOP, the new geometry is
installed and vc_resize() redraws before the buffer is rebuilt. The
rotated putcs/cursor ops then index the old buffer with the new cell
size; KASAN reports a slab-out-of-bounds read in soft_cursor().

Rebuild the buffer for the visible console before the redraw, as the
other callers do: select the console's blitting state with
set_blitting_type() (which also uploads the new font's map on
tile-blitting hardware), then rebuild. Background consoles keep
their rebuild at fbcon_switch() time, as the buffer is shared per
framebuffer and must not be updated for a console that is not being
displayed.

To ensure a correct rollback when the rebuild or the following
vc_resize() fails, save the rotated font state, clear it before
rebuilding, and restore it in the error path of
fbcon_do_set_font().

Fixes: 6cc50e1c5b57 ("[PATCH] fbcon: Console Rotation - Add support to rotate font bitmap")
Cc: stable@vger.kernel.org
Signed-off-by: Yao Yiqi <yaoyiqi3@huawei.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
[ sashal: adapted rotated font cache handling to the older fbcon_par layout and font reference-counting API ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon.c | 57 ++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 903823c9ce567..51860796f4364 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2430,6 +2430,12 @@ static int fbcon_do_set_font(struct vc_data *vc, int w, int h, int charcount,
 	int resize, ret, old_userfont, old_width, old_height, old_charcount;
 	u8 *old_data = vc->vc_font.data;
 	unsigned short old_hi_font_mask = vc->vc_hi_font_mask;
+#ifdef CONFIG_FRAMEBUFFER_CONSOLE_ROTATION
+	u8 *saved_fontdata = NULL, *saved_fontbuffer = NULL;
+	u32 saved_fd_size = 0;
+	int saved_cur_rotate = 0;
+	bool rotated_saved = false;
+#endif
 
 	resize = (w != vc->vc_font.width) || (h != vc->vc_font.height);
 	vc->vc_font.data = (void *)(p->fontdata = data);
@@ -2449,6 +2455,33 @@ static int fbcon_do_set_font(struct vc_data *vc, int w, int h, int charcount,
 	else if (!vc->vc_hi_font_mask && charcount == 512)
 		set_vc_hi_font(vc, true);
 
+	/*
+	 * Select the console's blitting state and update the rotated font buffer
+	 * to match the new font, so that the rendering below does not use a
+	 * cache that was built for the old font. Clear the cached state so
+	 * the rebuild allocates a fresh buffer; the old state is kept until
+	 * the font change can no longer fail.
+	 */
+	if (con_is_visible(vc)) {
+		set_blitting_type(vc, info);
+		if (par->rotate_font) {
+#ifdef CONFIG_FRAMEBUFFER_CONSOLE_ROTATION
+			saved_fontdata = par->fontdata;
+			saved_fontbuffer = par->fontbuffer;
+			saved_fd_size = par->fd_size;
+			saved_cur_rotate = par->cur_rotate;
+			par->fontdata = NULL;
+			par->fontbuffer = NULL;
+			par->fd_size = 0;
+			par->cur_rotate = 0;
+			rotated_saved = true;
+#endif
+			ret = par->rotate_font(info, vc);
+			if (ret)
+				goto err_out;
+		}
+	}
+
 	if (resize) {
 		int cols, rows;
 
@@ -2465,11 +2498,28 @@ static int fbcon_do_set_font(struct vc_data *vc, int w, int h, int charcount,
 		update_screen(vc);
 	}
 
+#ifdef CONFIG_FRAMEBUFFER_CONSOLE_ROTATION
+	if (rotated_saved)
+		kfree(saved_fontbuffer);
+#endif
 	if (old_userfont && (--REFCOUNT(old_data) == 0))
 		kfree(old_data - FONT_EXTRA_WORDS * sizeof(int));
 	return 0;
 
 err_out:
+#ifdef CONFIG_FRAMEBUFFER_CONSOLE_ROTATION
+	/*
+	 * Drop the buffer built for the new font and restore the saved
+	 * state.
+	 */
+	if (rotated_saved) {
+		kfree(par->fontbuffer);
+		par->fontdata = saved_fontdata;
+		par->fontbuffer = saved_fontbuffer;
+		par->fd_size = saved_fd_size;
+		par->cur_rotate = saved_cur_rotate;
+	}
+#endif
 	p->fontdata = old_data;
 	vc->vc_font.data = old_data;
 
@@ -2489,6 +2539,13 @@ static int fbcon_do_set_font(struct vc_data *vc, int w, int h, int charcount,
 	else if (!old_hi_font_mask && vc->vc_hi_font_mask)
 		set_vc_hi_font(vc, false);
 
+	/*
+	 * Re-select the blitting type, which re-uploads the font map on
+	 * tile-blitting hardware.
+	 */
+	if (con_is_visible(vc))
+		set_blitting_type(vc, info);
+
 	return ret;
 }
 
-- 
2.53.0



