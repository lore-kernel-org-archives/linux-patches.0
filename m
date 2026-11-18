Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047383;
	b=1bw3dMX4rZM2tZz+Nj9AgZIQva/CYArs+DKm89/YzgQ3OgEWWC0jdoSrLJLNO0HT2AIO
	 kCK7hVpb2tDMis/OmIs6aiyqBEUvVrTnBpUOILS1OQLr5mBiMbzgcQz0/baS6YZkFvTd2
	 WbNGZVVvTmwVUrJYQ2+YDhpHELuU2xVn1vud5Mbq5lAQIN0O6CcOfqVF1SfJ4i7kj5+SE
	 rMyQGj87oKthgRmZh44AIUfKzh2/yb+cPPMw/tEhpfSwUBYmB1FyBsD/djY29b018oXnd
	 fudWd7HsdPqHO472+I+4a4M+VmLtSusISyW/OP2X5ZItLp8i08uKNmcAeMaaLYl6Beg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eRk0N+mNmTzFSxFkHFKvzT3RqsM+xnP237bmHDD0oDQ=;
	b=CmE1lyb4RkaySDLSDba7QF/Y3KjFz+mlNyupLVIm2NDBZmSJGo5p/gXwuNiE5Ya+BYhP
	 7eGYl/szd7b4nNHeYQR71M9UJyQm3GrsbvF3XnY562jzCd9cWbbrFJ6+kgZAwCbnIYhzc
	 fbi9rx2hGxJIJ2MkqcYD6old1BVV0MoZ/lfW75vZDFkckY87+xCuqPvBNfmyvIDJQ0opZ
	 H7s+xcOitEmACw4l5BvuxJCDIUUF3jS2NhV+Woe7O3Ack7u3IzYkZHkoOIWYaJ37XgT/A
	 VLcAtVHCErp3Xw63bzoCDKRdOla9Z5I2oFYUd3BIaq8aLTtUiIGDMzGBEHxLonZU2Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zyr7qJhZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACAF606A339;
	Thu, 19 Nov 2026 00:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zyr7qJhZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF711F000C4;
	Thu, 19 Nov 2026 00:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047383;
	bh=eRk0N+mNmTzFSxFkHFKvzT3RqsM+xnP237bmHDD0oDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zyr7qJhZhxPwjB+xtLd+cwX1Ab6E0wZZ9AV7p4w02K4lP/qIjHFfp1SLvcYKLCTm/
	 hQg+WbJccBqteQw2XDKFs/oDj+5rs2TH5MH2im29LOf5eajvDHiJ1YzrX8QH7ktw99
	 qeDsPCQTkk8adXe1N+jS/LlCPtZ0Y3ECEfCRfdSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Yiqi <yaoyiqi3@huawei.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1619/2857] fbcon: Rebuild rotated font buffer on font change
Date: Wed, 18 Nov 2026 15:44:13 +0100
Message-ID: <20261118150259.642989192@linuxfoundation.org>
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
[ sashal: adapted rotated-font handling to use separate fbcon_par cache fields and the direct rotate_font callback ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon.c | 57 ++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index d6a728e0690d2..2b891dd6330f9 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2415,6 +2415,12 @@ static int fbcon_do_set_font(struct vc_data *vc, int w, int h, int charcount,
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
@@ -2434,6 +2440,33 @@ static int fbcon_do_set_font(struct vc_data *vc, int w, int h, int charcount,
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
 
@@ -2450,11 +2483,28 @@ static int fbcon_do_set_font(struct vc_data *vc, int w, int h, int charcount,
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
 
@@ -2474,6 +2524,13 @@ static int fbcon_do_set_font(struct vc_data *vc, int w, int h, int charcount,
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



