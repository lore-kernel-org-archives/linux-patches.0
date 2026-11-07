Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064374;
	b=LrZPPRs+VKaav4ix+tz0yTD/gIquIoqOu5YDIeNV/mYCwSH0eljm3OruVKCGG29Eogjm
	 y9CKZI+0bzUEKmr6mNex3dQiE+9cXOvNJLw7/xlW5FfBMBUqFCtIsiW3Vq41/t0YLZliH
	 5siuU0w8Uo+6FASBsUBV95khFqWWGQBH2YQCOCJ799jodEU/0skKAIMSYxPynSCU/t/H3
	 MPRNP0klwAhYi1X26lq66D7L3KtDqUM4TmcDXgv2ZuJzL8qPLPdSH5cYDMzzuS26TVxOi
	 uQFabp8tCO4bK9zNEjT8octP/TXf6MMd7i2f1+fBSEclOcVWR/G51UwWcTUWYHPJkeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064374;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tb6Wttob8AKazP4dDXysXG9TWYmd+PRTIYfCGiL1L8w=;
	b=v/17IBVKpdpESZhIdK9A0itkYyBs/7mTSr9N2cHS8oODgL0f+F4i0kDsFkxwjCjHS7lM
	 mhqiSQzq1jSnOpkwvg2UmGbczZnlJCSDWFfDDav4n4g+cUQ1dpR99NDA50g1NurWYt5N1
	 jzy7jPfAF/sCDYqALY/2OwSC5K+Xk1vOx87/bCSsKkXmRe70Z+oxStOmRqn6BtU/L1tM6
	 JW8J+Uk3Ah8+ii4MCPGJN51OAjLGSjGPGsOR0+H3TGMY1W/OUDZAeWEbD0BRuifhSDSvy
	 /UHEr2yGBMsgZMAQqTIKP9GNxXW/JyAbidkmzUfACeH/YUoEK42XZfng5/SqM0IP3fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2e18xsuT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57AC606B8B8;
	Sat,  7 Nov 2026 15:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2e18xsuT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636821F008A2;
	Sat,  7 Nov 2026 15:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064373;
	bh=tb6Wttob8AKazP4dDXysXG9TWYmd+PRTIYfCGiL1L8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2e18xsuTM0sL59xB+ZUUBskoxEqgsNMchQDnKXvrXvO8RwxxUTYg4Z1eYpUeVPl05
	 Hz9t72kGf+WsV1nOtKVFmU/ao7T9Wtlwg/9sCvMdcVXxg88V1W4S+BsUzssc7/9cEx
	 d7b+J5FRgUkySZOHGYhI+mLDsGpAVzRBXtG0G9Lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0452/1257] media: rockchip: rga: fix rotation on rev0 hardware
Date: Sat,  7 Nov 2026 08:45:48 -0500
Message-ID: <20261107134951.959485424@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Keeping <jkeeping@inmusicbrands.com>

[ Upstream commit a67578c0179850e80cf08b1e0b8b1eb857f0fc46 ]

On RK3288 where the RGA reports version zero [1], rotating a buffer
gives corrupt output where one edge will be truncated.  This is a result
of some adjustment done specifically for hardware revision zero.  But it
seems this is not necessary and there is no evidence for why this
adjustment should be applied on these hardware revisions.

Comparing the TRMs between RK3288 with revision zero and RK3588 with
revision 3.2 there is evidence of new features supported by later
hardware, but nothing indicating any difference in behaviour for
rotation which is supported by all hardware revisions.

The logic here looks wrong anyway, since it's bizarre that minor
revision zero would need the adjustment for _all_ major revisions.  This
was added with the initial version of the driver in commit f7e7b48e6d796
("[media] rockchip/rga: v4l2 m2m support") so there is no detail in the
Git history to indicate why this special-case might be needed.

[1] Comparing with the vendor code, it seems this is actually 1.3 with
    the hardware reporting zero more by coincidence than design since the
    version register is not defined for RK3288.

Fixes: f7e7b48e6d796 ("[media] rockchip/rga: v4l2 m2m support")
Cc: stable@vger.kernel.org
Signed-off-by: John Keeping <jkeeping@inmusicbrands.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rga/rga-hw.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/media/platform/rockchip/rga/rga-hw.c b/drivers/media/platform/rockchip/rga/rga-hw.c
index be1bc8ddbd03b..2e7ec8b7c20f7 100644
--- a/drivers/media/platform/rockchip/rga/rga-hw.c
+++ b/drivers/media/platform/rockchip/rga/rga-hw.c
@@ -158,7 +158,6 @@ static void rga_cmd_set_dst_addr(struct rga_ctx *ctx, dma_addr_t dma_addr)
 
 static void rga_cmd_set_trans_info(struct rga_ctx *ctx)
 {
-	struct rockchip_rga *rga = ctx->rga;
 	u32 *dest = ctx->cmdbuf_virt;
 	unsigned int scale_dst_w, scale_dst_h;
 	unsigned int src_h, src_w, dst_h, dst_w;
@@ -251,13 +250,6 @@ static void rga_cmd_set_trans_info(struct rga_ctx *ctx)
 	 */
 	if (src_info.data.rot_mode == RGA_SRC_ROT_MODE_90_DEGREE ||
 	    src_info.data.rot_mode == RGA_SRC_ROT_MODE_270_DEGREE) {
-		if (rga->version.major == 0 || rga->version.minor == 0) {
-			if (dst_w == src_h)
-				src_h -= 8;
-			if (abs(src_w - dst_h) < 16)
-				src_w -= 16;
-		}
-
 		scale_dst_h = dst_w;
 		scale_dst_w = dst_h;
 	} else {
-- 
2.53.0



