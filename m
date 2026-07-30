Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EC740FD86;
	Thu, 30 Jul 2026 14:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422712; cv=none; b=opEVaZ9wvRRxWnTtAzv8E8RsD5GaWr1wu2JS9tpQ7cn3eJTBwfN6Yij909w+xKRfoKNaPl8enEBU7XLzM0zBln+nx+GL+v9Mne0utRBwA8nvwNDPcu+qnOMpaLDnkZkb/VYUWR0r7CgxcRPk3g6cff/0Qz9E7aQTtj3ZQnKWY6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422712; c=relaxed/simple;
	bh=ylrIrBjE0PElMGU8hJiu5EH6q4Z2SGCp9FkdYx2j6JM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHtmmZkCMQ0ITNwBbgELb5SfiNLy9fjXATdLr6gVUWPhyPb7Qh/2RTxUK3Nxzb9m3AZOliHhc6YUqWD0CjjUlb6Q55dT9LGWmPIW554t1Ii1mWz+ktGWBbKzIZHVV9RQjVSSVFqKhJLsDdN/+7tjxY0u4FiPaH4wbFySf12K5vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n8DeUN0b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8DeUN0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297B21F00A3A;
	Thu, 30 Jul 2026 14:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422710;
	bh=+XRrGr7IBtmXTKePxr2rPni/FfeR3nY/D6JoFJfCOLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n8DeUN0bHCqV1IgF/MI/bQYhca/WUA1JZX1rMNsXR+ESEEy8uyDSTH9Z6nj90JYqF
	 j4U7UYdjGDX1PSODSNUYFuCk9JF9ds9m9H5ExQsSM5ThRuq+mIeCDnODQVhhcWEBPy
	 eOxGQ3erlFafOhCkS+WtNLYVcdhz/ROQZwtQvP3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 531/744] media: verisilicon: Export only needed pixels formats
Date: Thu, 30 Jul 2026 16:13:24 +0200
Message-ID: <20260730141455.558179841@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Gaignard <benjamin.gaignard@collabora.com>

commit e0f5d6ae76423ec5b6f97c7c3e1f02187b988afd upstream.

Some pixel formats can only be produced if the decoder outputs
reference pictures directly. In some cases, such as AV1 film-grain,
the use of the post-processor is strictly required. In this case,
only enumerate the post-processor supported formats. The exception is
when V4L2_FMTDESC_FLAG_ENUM_ALL is set, in this case, we enumerate
everything regardless of the state.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Fixes: bcd4f091cf1e ("media: verisilicon: Use V4L2_FMTDESC_FLAG_ENUM_ALL flag")
Cc: stable@vger.kernel.org
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/verisilicon/hantro_v4l2.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/verisilicon/hantro_v4l2.c
+++ b/drivers/media/platform/verisilicon/hantro_v4l2.c
@@ -222,6 +222,7 @@ static int vidioc_enum_fmt(struct file *
 	unsigned int num_fmts, i, j = 0;
 	bool skip_mode_none, enum_all_formats;
 	u32 index = f->index & ~V4L2_FMTDESC_FLAG_ENUM_ALL;
+	bool need_postproc = ctx->need_postproc;
 
 	/*
 	 * If the V4L2_FMTDESC_FLAG_ENUM_ALL flag is set, we want to enumerate all
@@ -230,6 +231,9 @@ static int vidioc_enum_fmt(struct file *
 	enum_all_formats = !!(f->index & V4L2_FMTDESC_FLAG_ENUM_ALL);
 	f->index = index;
 
+	if (enum_all_formats)
+		need_postproc = HANTRO_AUTO_POSTPROC;
+
 	/*
 	 * When dealing with an encoder:
 	 *  - on the capture side we want to filter out all MODE_NONE formats.
@@ -242,7 +246,7 @@ static int vidioc_enum_fmt(struct file *
 	 */
 	skip_mode_none = capture == ctx->is_encoder;
 
-	formats = hantro_get_formats(ctx, &num_fmts, HANTRO_AUTO_POSTPROC);
+	formats = hantro_get_formats(ctx, &num_fmts, need_postproc);
 	for (i = 0; i < num_fmts; i++) {
 		bool mode_none = formats[i].codec_mode == HANTRO_MODE_NONE;
 		fmt = &formats[i];


