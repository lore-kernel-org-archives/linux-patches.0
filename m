Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B156F188A3A;
	Thu,  3 Apr 2025 15:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743694016; cv=none; b=ttz4SW2gyu5Cu+dyc4O/To85PECTXR2IVdRrmJzIvDwLyA5J51mzhkLn5Cu13iuGkTcyVG6K/p8yD4gnwuoPRfNeWIkzG1nJwWj1woprAzYTUdmo5qEzAEfNIMkM/yIoxWSPQMrLWz2lymBjuCA6PEoDOHyg5g3CT3PBQU8pn7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743694016; c=relaxed/simple;
	bh=ZplhR95TTUrFjd1kkzVPuYGGzIdy6KV2Ey7eNXr0ev0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OpiWsq4YdAn0J236ObdU6mh/t9pECSPRilBWsWPOBGYOWtE8iGb+krQNn9+2cPcedZTlcAPfReIhlT3bEIAq0T2s/De4VWFBTxrVD0YZ1mclZ9j4gomlYOylqzoy33khaUEmNynHkhEqw/ilC4qENKpwATeG9I/1gu9XWauGLs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QeW1j71F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QeW1j71F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E3BC4CEE3;
	Thu,  3 Apr 2025 15:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743694016;
	bh=ZplhR95TTUrFjd1kkzVPuYGGzIdy6KV2Ey7eNXr0ev0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QeW1j71Fw+Iy8b14QsriHbVoUf5vpi/3BKESXIMVMBcAWznC8hBsel87PordUhTOD
	 fPuUhxeV0kmnW7v1TiL2M8g7bmlXeZ6ZAGMqJ/Z7CxvSsIOU2ORtWlVoX2oetTFtiH
	 2dMdK1NywK1VDw/MA5GDxV26vT2e15Jkq12k1byg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhishek Tamboli <abhishektamboli9@gmail.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.6 26/26] usb: gadget: uvc: Fix ERR_PTR dereference in uvc_v4l2.c
Date: Thu,  3 Apr 2025 16:20:47 +0100
Message-ID: <20250403151623.171251386@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.415201055@linuxfoundation.org>
References: <20250403151622.415201055@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhishek Tamboli <abhishektamboli9@gmail.com>

commit a7bb96b18864225a694e3887ac2733159489e4b0 upstream.

Fix potential dereferencing of ERR_PTR() in find_format_by_pix()
and uvc_v4l2_enum_format().

Fix the following smatch errors:

drivers/usb/gadget/function/uvc_v4l2.c:124 find_format_by_pix()
error: 'fmtdesc' dereferencing possible ERR_PTR()

drivers/usb/gadget/function/uvc_v4l2.c:392 uvc_v4l2_enum_format()
error: 'fmtdesc' dereferencing possible ERR_PTR()

Also, fix similar issue in uvc_v4l2_try_format() for potential
dereferencing of ERR_PTR().

Signed-off-by: Abhishek Tamboli <abhishektamboli9@gmail.com>
Link: https://lore.kernel.org/r/20240815102202.594812-1-abhishektamboli9@gmail.com
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/uvc_v4l2.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/uvc_v4l2.c
+++ b/drivers/usb/gadget/function/uvc_v4l2.c
@@ -121,6 +121,9 @@ static struct uvcg_format *find_format_b
 	list_for_each_entry(format, &uvc->header->formats, entry) {
 		const struct uvc_format_desc *fmtdesc = to_uvc_format(format->fmt);
 
+		if (IS_ERR(fmtdesc))
+			continue;
+
 		if (fmtdesc->fcc == pixelformat) {
 			uformat = format->fmt;
 			break;
@@ -240,6 +243,7 @@ uvc_v4l2_try_format(struct file *file, v
 	struct uvc_video *video = &uvc->video;
 	struct uvcg_format *uformat;
 	struct uvcg_frame *uframe;
+	const struct uvc_format_desc *fmtdesc;
 	u8 *fcc;
 
 	if (fmt->type != video->queue.queue.type)
@@ -265,7 +269,10 @@ uvc_v4l2_try_format(struct file *file, v
 	fmt->fmt.pix.field = V4L2_FIELD_NONE;
 	fmt->fmt.pix.bytesperline = uvc_v4l2_get_bytesperline(uformat, uframe);
 	fmt->fmt.pix.sizeimage = uvc_get_frame_size(uformat, uframe);
-	fmt->fmt.pix.pixelformat = to_uvc_format(uformat)->fcc;
+	fmtdesc = to_uvc_format(uformat);
+	if (IS_ERR(fmtdesc))
+		return PTR_ERR(fmtdesc);
+	fmt->fmt.pix.pixelformat = fmtdesc->fcc;
 	fmt->fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
 	fmt->fmt.pix.priv = 0;
 
@@ -375,6 +382,9 @@ uvc_v4l2_enum_format(struct file *file,
 		return -EINVAL;
 
 	fmtdesc = to_uvc_format(uformat);
+	if (IS_ERR(fmtdesc))
+		return PTR_ERR(fmtdesc);
+
 	f->pixelformat = fmtdesc->fcc;
 
 	return 0;


