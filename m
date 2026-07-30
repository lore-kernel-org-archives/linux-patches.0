Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC9B2D7DDB;
	Thu, 30 Jul 2026 15:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424573; cv=none; b=dizoipxxSv6xCb6FRN/w9xLUCd3MmkMv8OPRel9z9rQfVaw+0WVcgTEmTRPWz6XIpOi/oPgJdbG6KMdUGjCIYBFfAp3j7fODXtnO73b/GtxasVLX1t/2ZkDPPZZKNsvy3NEaJinu4+/GRwQeLT008ZVAV/dJSxlz+C6CDHUwn1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424573; c=relaxed/simple;
	bh=3PfXaEz2y5sikb0hjM8glR3/CFbzSHX0dE7Tqgu8d/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9lSuKlYZJCWpnQGOi229XQJuilxRUSC0qhBAUkwGOZmtzXWx7XMvz4WTHBfObNzbs+7x/pyr0P5gQbzkAUCgNZf04n9F9aP1j5tMwzJt3X3lgr4jLj7Qu5YTTZ8ylXsUeJdU1hCKj82Wg+rpgeOZ4RN4G6bUlN29YMELivdDzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gsam+Z6G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gsam+Z6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEA21F000E9;
	Thu, 30 Jul 2026 15:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424572;
	bh=ovcMZpwFaqyddcuyfY1Fx/gs/cDQaXKncZEX8LI5As8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gsam+Z6GYbeBIZWl7ar/NOZz+cd4wclmeJTk44zB7nYODgnrqEPxV8Esq9N8+ADXR
	 2NPRPIh03AuiiryT8epj8dyhHS2IyqVfDW6XnXO23O9bDKKBQwxrYfJlBRQyeb2OE+
	 Fr/oPIGth6Oe/CTr/wTbRSbXPNYnJog9codtczTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 440/675] media: verisilicon: Export only needed pixels formats
Date: Thu, 30 Jul 2026 16:12:50 +0200
Message-ID: <20260730141454.491698055@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


