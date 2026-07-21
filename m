Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4770339768C;
	Tue, 21 Jul 2026 22:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673526; cv=none; b=YO0KPky57WLRJEpyFRLTCBIvH4y/a8MKI/cNrpBccm+tD7RqBYIGPG2i3TwPWJ65suWtw4jk/h3hK5fhFSYN8KE2/se2Q17UfiuCIsbSnep0FquhuIGw76v44n0dtsd76kNbxQ5WuiQADTt2ynUdOTH0K4jfgrd93UnscPQsei4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673526; c=relaxed/simple;
	bh=V1m6NHcU1L3ldLjhqHr68R2MXjaX9WtYCZ/LmcS8o6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XeNOfEIeH0i8MknVumPCBgY73WJTwfqk3wb+wGfB99LC7TOEgQiAgY3uubKNm56T1YvKyGe9c3zSmzyI00vO10mZ81DSdyPUGn3hG43UuplC1gNk1NnzznDz4bp2bPviCmUHjve2jfYh++b6GQeXh3P4t8NxfYNFfWf0OyCtbjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlBg6Xvz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlBg6Xvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B15A1F000E9;
	Tue, 21 Jul 2026 22:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673525;
	bh=bjOFT7XO20ytvFeMFuGbFBya7MyLFJQvcXEpk6RUXoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rlBg6XvzkVXMXUa2b59U+iClQL71boaTqDHAhPmk7Q0aAL7Rn67/nM1Acpom0EwVv
	 GRc/F06m4ucAr68jfoMN27Dae4VA0pzsp5SfzLFo7Am1LCgubZa66ocAlSmpciubHg
	 NpEvuK/wz7qK+ALFyBot6nUyGtGEIZeLCYM3Ittg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	=?UTF-8?q?Sven=20P=C3=BCschel?= <s.pueschel@pengutronix.de>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 195/699] media: rockchip: rga: fix too small buffer size
Date: Tue, 21 Jul 2026 17:19:14 +0200
Message-ID: <20260721152400.095858546@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index aaa96f256356b0..bdfb9bc3eb3f6d 100644
--- a/drivers/media/platform/rockchip/rga/rga-hw.c
+++ b/drivers/media/platform/rockchip/rga/rga-hw.c
@@ -379,7 +379,7 @@ static void rga_cmd_set(struct rga_ctx *ctx)
 {
 	struct rockchip_rga *rga = ctx->rga;
 
-	memset(rga->cmdbuf_virt, 0, RGA_CMDBUF_SIZE * 4);
+	memset(rga->cmdbuf_virt, 0, RGA_CMDBUF_SIZE);
 
 	rga_cmd_set_src_addr(ctx, rga->src_mmu_pages);
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



