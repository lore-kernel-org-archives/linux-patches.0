Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D7A7482;
	Mon, 23 Jun 2025 21:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713697; cv=none; b=m6RvbTHNKXuT3/yDj60OsyDlGuMwtWuxsxWd/MB3eom+NGY6w1cZCc2CCHUjVCrypLwvZn5nCo4WnXdU3YhG343V52T+slHy+rFKc6XvXIOaDqUy57k183kydBtyBOdlyNMEcofgDm35lfe6UbhUCpZvT9qJ3iqZ/Fmhsm1QoRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713697; c=relaxed/simple;
	bh=26HJsaD6H+2aAg5SJNMfFWGu2ud3PTqM8aVdzEN4iqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnJkZ8Iqtn+KOwk+XQCDWWAcr7JhSrs0Lj3U8u7flu5wMMB/a86SfGQwBg8mx/KFeaKf5N6xzWpN/oJQgPx/R39lT2SIxxwLeUv76Bmf0Cq8PWxIe5hVnVtgeAOSkaN0wGZW380Z2oWBNcddNyiQrQjp0ruktDJJ7oPnZ0FTLvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZzkbQmY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZzkbQmY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30F1C4CEEA;
	Mon, 23 Jun 2025 21:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713697;
	bh=26HJsaD6H+2aAg5SJNMfFWGu2ud3PTqM8aVdzEN4iqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZzkbQmYoNIq2ZMFknNaI/TYCJvkeJPXPWXVqSgjXtah2S4H7oYT+ep1FdfdDC0yZ
	 Dx+hRuZgSG9lPGs0f3H5zQP5gvPquvCR/DQsiTfq4ErzwRcbFzbsWcZaFSbh9GwdPJ
	 54mu4ZRFR9gPQORIi6MTXNKrlz01gEK/7T+nF9BE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 058/414] media: mediatek: vcodec: Correct vsi_core framebuffer size
Date: Mon, 23 Jun 2025 15:03:15 +0200
Message-ID: <20250623130643.523961767@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fei Shao <fshao@chromium.org>

commit f19035b86382f635a0d13d177b601babaf263a12 upstream.

The framebuffer size for decoder instances was being incorrectly set -
inst->vsi_core->fb.y.size was assigned twice consecutively.

Assign the second picinfo framebuffer size to the C framebuffer instead,
which appears to be the intended target based on the surrounding code.

Fixes: 2674486aac7d ("media: mediatek: vcodec: support stateless hevc decoder")
Cc: stable@vger.kernel.org
Signed-off-by: Fei Shao <fshao@chromium.org>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_hevc_req_multi_if.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_hevc_req_multi_if.c
+++ b/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_hevc_req_multi_if.c
@@ -821,7 +821,7 @@ static int vdec_hevc_slice_setup_core_bu
 	inst->vsi_core->fb.y.dma_addr = y_fb_dma;
 	inst->vsi_core->fb.y.size = ctx->picinfo.fb_sz[0];
 	inst->vsi_core->fb.c.dma_addr = c_fb_dma;
-	inst->vsi_core->fb.y.size = ctx->picinfo.fb_sz[1];
+	inst->vsi_core->fb.c.size = ctx->picinfo.fb_sz[1];
 
 	inst->vsi_core->dec.vdec_fb_va = (unsigned long)fb;
 


