Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31AD46C4D9;
	Tue, 21 Jul 2026 19:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661671; cv=none; b=WsTzAfU+ga0tyTBV+OgKp+TG+x4qPe+wtqEh/bnmzrnT/+gG31W8Gf28Km/goQAoeOAOATUVa9N2oNRcOtbIchxqW7DUorpnwl4AbrhYCU8jxUUN02Rwy0rnjhvhGsEnM3edeylIy5AGjP83XlwR8jI2bTmCZ3onworI4YnH694=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661671; c=relaxed/simple;
	bh=BJ5W3ZkVLHHeXO7bQvViQWvUNDewAYE7qn+jJMQ2fL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LC7CLTLTbm/zMkkgPTgwS3gQrof5dWVZEsYKfvgF2S2OwTgO0ANVuu/V6U9E69VB7Xxyb0NG/dCm9s9PIDzOID4I1Ul+6R3Y1J/gRfZUXssFwfF5zVx5WTAQgtO9oK5dcZieIrAXR3dppgYjqmBsToeyNb6yhfnIx1T7cPfBq44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JCbmXHLF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JCbmXHLF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8091F000E9;
	Tue, 21 Jul 2026 19:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661669;
	bh=ZxIdPwT69JagsfdRYzmYAKDQcU7/Ti9tE7iX5xN09Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JCbmXHLFUMXqZ4ZOY8a5nJ51OK8SqOb2hU4Dpqch/u2J28riGPmLx1yiU6F3tUz0X
	 5d/e8eeEEtH3s1HD6G/zRJ21iBIIquKfwvq+wbov2OepxU7iLgo+vjNg8GE9UyJKrz
	 WC0NtLn1sxSR5QTcMu0NjnTmD+5iwIIFXvXu0k7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	=?UTF-8?q?Sven=20P=C3=BCschel?= <s.pueschel@pengutronix.de>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0137/1276] media: rockchip: rga: fix too small buffer size
Date: Tue, 21 Jul 2026 17:09:40 +0200
Message-ID: <20260721152449.166844663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Püschel <s.pueschel@pengutronix.de>

[ Upstream commit 65017e26c065d1240b0512c15867ef1128034fd8 ]

Fix the command buffer size being only a quarter of the actual size.
The RGA_CMDBUF_SIZE macro was potentially intended to specify the length
of the cmdbuf u32 array pointer. But as it's used to specify the size of
the allocation, which is counted in bytes. Therefore adjust the macro
size to bytes as it better matches the variable name and adjust it's
users accordingly.

As the command buffer is relatively small, it probably didn't caused
an issue due to being smaller than a single page.

Fixes: f7e7b48e6d79 ("[media] rockchip/rga: v4l2 m2m support")
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Sven Püschel <s.pueschel@pengutronix.de>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rga/rga-hw.c | 2 +-
 drivers/media/platform/rockchip/rga/rga-hw.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rockchip/rga/rga-hw.c b/drivers/media/platform/rockchip/rga/rga-hw.c
index b2ef3beec5258a..7de6f80fdce7e5 100644
--- a/drivers/media/platform/rockchip/rga/rga-hw.c
+++ b/drivers/media/platform/rockchip/rga/rga-hw.c
@@ -414,7 +414,7 @@ static void rga_cmd_set(struct rga_ctx *ctx,
 {
 	struct rockchip_rga *rga = ctx->rga;
 
-	memset(rga->cmdbuf_virt, 0, RGA_CMDBUF_SIZE * 4);
+	memset(rga->cmdbuf_virt, 0, RGA_CMDBUF_SIZE);
 
 	rga_cmd_set_src_addr(ctx, src->dma_desc_pa);
 	/*
diff --git a/drivers/media/platform/rockchip/rga/rga-hw.h b/drivers/media/platform/rockchip/rga/rga-hw.h
index e8917e5630a48d..03990fd30f158c 100644
--- a/drivers/media/platform/rockchip/rga/rga-hw.h
+++ b/drivers/media/platform/rockchip/rga/rga-hw.h
@@ -6,7 +6,7 @@
 #ifndef __RGA_HW_H__
 #define __RGA_HW_H__
 
-#define RGA_CMDBUF_SIZE 0x20
+#define RGA_CMDBUF_SIZE 0x80
 
 /* Hardware limits */
 #define MAX_WIDTH 8192
-- 
2.53.0



