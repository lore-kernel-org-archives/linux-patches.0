Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173D43D6F2F;
	Thu, 15 Jan 2026 17:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499810; cv=none; b=Omz8tscP2dqgt+VHWslKBF7aNMGg2LWOCDZ8uInJRUMvuwJMuaeF7J1iVLqAhaLfXwGY/5g7QCOX9DtDAQzDgZAx81h/wEx+TQ6CLyL4Austa1k9ztykL4BviCAFq9squz5Iu/cNpmc0quR6f/+Mdq8Vlc+FrRk0sN2ZCarhnq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499810; c=relaxed/simple;
	bh=BMpLo05xklDGuw55JEUyUs6bQGOtm0HJ4hKBa6LQi/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxZ1Xi6idYpNpe/5Ne6r9x47e/BtmrQflvULROg+A2cBgy4LUp1M5vPD4HFbhBosENxrOdzSezeN1P+L5Q4KdkSmFHuGHDGfg9IajiW3VxnJF7Kikoj4ysBIOh9rWLPOQjKv0K391s7gMMvacN3jA6k6tC3k1PM8eHXzb1qvbco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eKW3NkLP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eKW3NkLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B34DC116D0;
	Thu, 15 Jan 2026 17:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499810;
	bh=BMpLo05xklDGuw55JEUyUs6bQGOtm0HJ4hKBa6LQi/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eKW3NkLPSBiUEtihDtm8RxmBvQq+Xf8mveO7nid9e+PTdWz7b0A7eF5Uj9FQ1i0s3
	 Kxl/+1A2mABoJKIQchEZ83wNcQSZu9/A/lWo5dtTgeSunTo/U+5uQ5feRWK9rXIlJp
	 +fuOEyKvO6PvlLQVw7hpi5mWVcD83wP0oPn5fzos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peilin Ye <yepeilin.cs@gmail.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 340/451] console: Delete unused con_font_copy() callback implementations
Date: Thu, 15 Jan 2026 17:49:01 +0100
Message-ID: <20260115164243.193891114@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peilin Ye <yepeilin.cs@gmail.com>

commit 7a089ec7d77fe7d50f6bb7b178fa25eec9fd822b upstream.

Recently in commit 3c4e0dff2095 ("vt: Disable KD_FONT_OP_COPY") we
disabled the KD_FONT_OP_COPY ioctl() option. Delete all the
con_font_copy() callbacks, since we no longer use them.

Mark KD_FONT_OP_COPY as "obsolete" in include/uapi/linux/kd.h, just like
what we have done for PPPIOCDETACH in commit af8d3c7c001a ("ppp: remove
the PPPIOCDETACH ioctl").

Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/c8d28007edf50de4387e1532eb3eb736db716f73.1605169912.git.yepeilin.cs@gmail.com
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/sisusbvga/sisusb_con.c |    6 ------
 drivers/video/console/dummycon.c        |    6 ------
 drivers/video/fbdev/core/fbcon.c        |   11 -----------
 include/linux/console.h                 |    1 -
 include/uapi/linux/kd.h                 |    2 +-
 5 files changed, 1 insertion(+), 25 deletions(-)

--- a/drivers/usb/misc/sisusbvga/sisusb_con.c
+++ b/drivers/usb/misc/sisusbvga/sisusb_con.c
@@ -1358,11 +1358,6 @@ static int sisusbdummycon_font_default(s
 	return 0;
 }
 
-static int sisusbdummycon_font_copy(struct vc_data *vc, int con)
-{
-	return 0;
-}
-
 static const struct consw sisusb_dummy_con = {
 	.owner =		THIS_MODULE,
 	.con_startup =		sisusbdummycon_startup,
@@ -1377,7 +1372,6 @@ static const struct consw sisusb_dummy_c
 	.con_blank =		sisusbdummycon_blank,
 	.con_font_set =		sisusbdummycon_font_set,
 	.con_font_default =	sisusbdummycon_font_default,
-	.con_font_copy =	sisusbdummycon_font_copy,
 };
 
 int
--- a/drivers/video/console/dummycon.c
+++ b/drivers/video/console/dummycon.c
@@ -136,11 +136,6 @@ static int dummycon_font_default(struct
 	return 0;
 }
 
-static int dummycon_font_copy(struct vc_data *vc, int con)
-{
-	return 0;
-}
-
 /*
  *  The console `switch' structure for the dummy console
  *
@@ -161,6 +156,5 @@ const struct consw dummy_con = {
 	.con_blank =	dummycon_blank,
 	.con_font_set =	dummycon_font_set,
 	.con_font_default =	dummycon_font_default,
-	.con_font_copy =	dummycon_font_copy,
 };
 EXPORT_SYMBOL_GPL(dummy_con);
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2471,16 +2471,6 @@ static int fbcon_do_set_font(struct vc_d
 	return 0;
 }
 
-static int fbcon_copy_font(struct vc_data *vc, int con)
-{
-	struct fbcon_display *od = &fb_display[con];
-	struct console_font *f = &vc->vc_font;
-
-	if (od->fontdata == f->data)
-		return 0;	/* already the same font... */
-	return fbcon_do_set_font(vc, f->width, f->height, od->fontdata, od->userfont);
-}
-
 /*
  *  User asked to set font; we are guaranteed that
  *	a) width and height are in range 1..32
@@ -3174,7 +3164,6 @@ static const struct consw fb_con = {
 	.con_font_set 		= fbcon_set_font,
 	.con_font_get 		= fbcon_get_font,
 	.con_font_default	= fbcon_set_def_font,
-	.con_font_copy 		= fbcon_copy_font,
 	.con_set_palette 	= fbcon_set_palette,
 	.con_invert_region 	= fbcon_invert_region,
 	.con_screen_pos 	= fbcon_screen_pos,
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -62,7 +62,6 @@ struct consw {
 	int	(*con_font_get)(struct vc_data *vc, struct console_font *font);
 	int	(*con_font_default)(struct vc_data *vc,
 			struct console_font *font, char *name);
-	int	(*con_font_copy)(struct vc_data *vc, int con);
 	int     (*con_resize)(struct vc_data *vc, unsigned int width,
 			unsigned int height, unsigned int user);
 	void	(*con_set_palette)(struct vc_data *vc,
--- a/include/uapi/linux/kd.h
+++ b/include/uapi/linux/kd.h
@@ -173,7 +173,7 @@ struct console_font {
 #define KD_FONT_OP_SET		0	/* Set font */
 #define KD_FONT_OP_GET		1	/* Get font */
 #define KD_FONT_OP_SET_DEFAULT	2	/* Set font to default, data points to name / NULL */
-#define KD_FONT_OP_COPY		3	/* Copy from another console */
+#define KD_FONT_OP_COPY		3	/* Obsolete, do not use */
 
 #define KD_FONT_FLAG_DONT_RECALC 	1	/* Don't recalculate hw charcell size [compat] */
 


