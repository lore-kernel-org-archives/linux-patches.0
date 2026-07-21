Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECCA3E49E7;
	Tue, 21 Jul 2026 17:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655899; cv=none; b=ugKQTfKn5GJ+WyQ5GEd5BucD90bUGLJjMxj8pqFypxZ9E0HradXjA5tr+vXirKsotZmw9hCHWFShh/xuh8PYUxYiQ0n+HubrJstvfxP+5wRA4LPnvw2KKrWd/CYMqeHW6+BfzNpoMCDJoscIN3nEc7g0zga7qGTsG/C8Uh7Dnyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655899; c=relaxed/simple;
	bh=xR/fY8rB/17FiNQW6R6LXP4e2LuRsStw1yShAQZH3so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LvYjlnyol71tg+d/W81YkTVGkvOfvLAEsYDYkxPGhGZ5uQzbt6JLDjvhSZQV+wrrQYFtzEyZArYEHFSLNeCMYzj6cyt2B3Rcu6+Iyr03/6cT2c17ezaAaPDEtMiA3uMaB3dxB6auiOODcXAKjI6E5zYw8Is49kiwivQSqgoRJdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ytF47pRF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ytF47pRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5050C1F000E9;
	Tue, 21 Jul 2026 17:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655897;
	bh=KOXO2N5hwlMuYVglN1oID+bN6M4US7odQdpWhXVZyFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ytF47pRF2Ej1Lh/sC7F9cqMEUslJqTIhrZ2Y0Yv4+KC/fZzL799+DN2U6tMhyDVt8
	 Id7M8O0zQcCvz/Xj2im6Pb5IlmhOLhlVbSDH6NVx6dK/6kmnrkOw6B/1zUyxMLsP7G
	 bqSA79YYfv4NIq5Z0i2YDDrG6W3Rn0Bt3kz8pdMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	=?UTF-8?q?Sven=20P=C3=BCschel?= <s.pueschel@pengutronix.de>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0181/1611] media: rockchip: rga: fix too small buffer size
Date: Tue, 21 Jul 2026 17:04:57 +0200
Message-ID: <20260721152518.993294386@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 43ed742a164929..d1618bb2475013 100644
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
index cc6bd7f5b03003..2b8537a5fd0d7a 100644
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



