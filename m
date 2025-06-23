Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C99924A06B;
	Mon, 23 Jun 2025 13:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684497; cv=none; b=ujLPf3gPFhkpxt/GhOjEdlOkYMOVCh8yTLwPN1ATD/FlgS+QrrKtRMLB4OX/DsrcmqFJKsUXHQxUotaPotgXzt18ppuRIqHALOG3WHouYwnzaicEdoFpb9fpv9kliccueMYfw9YmNGMdAyPJ6hihkWlUyZA8hhTkPHWaFseeR+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684497; c=relaxed/simple;
	bh=nzwScgoePEnGnh/9qJawzc1os/VX5S49f3gMcYsbvDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ol+OxgtwVITsN5FioCRMwroMqFEABN9T/nCOq1kalKF81z2p4/jsdbfiDC48HUT/B2loOYVmcot4ggWK/MQpFzczc4BDIgB3mF6dBXB661iHQYMxsMKFGCO7LzHRwW3cald3Cdar/mGV8a+G3UqWy5HKeduIeGWTNuoqxtq4Ffc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxSKTOqe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxSKTOqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C680AC4CEEA;
	Mon, 23 Jun 2025 13:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684497;
	bh=nzwScgoePEnGnh/9qJawzc1os/VX5S49f3gMcYsbvDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DxSKTOqeePRnLNChICrSAc03IuquDai2OcutQhM4f4IJFagN+Myd81cvpao8NiyQq
	 pYV7bXIoJ/LQVtx3lQJgF7cijmcmenWiGg8cN2eADqPrVAErDie7PhT1P0jGtLqdmY
	 6lX395hK+0sDtHZn6jV5fEyBZ7oYA20mhOtZ6lRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 074/592] media: mediatek: vcodec: Correct vsi_core framebuffer size
Date: Mon, 23 Jun 2025 15:00:32 +0200
Message-ID: <20250623130702.023176756@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
 


