Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555F446D0AD;
	Tue, 21 Jul 2026 18:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656810; cv=none; b=NHFoILdmTWuYjZGOxfUwLmwSIOufH3LEAS30+zgdZHQN87rf0WeF04KbI5zY5vIOeOUUXHUtLbd6bmpSiQGFLLdpAXOvxLOICnqunDHZZ2J2y4pmen65/2OLORiZBeYUelSH67GFHnjQb2bHn9lY10ip2yOqcz4dIwzlaA8Qy/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656810; c=relaxed/simple;
	bh=YyfdEj40CPJ4AV9wTEWD3ECccrUkBMeKgWEItCWFvM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HeAwdu4S5ZM7OT6yE29h93wRKkCAEW+mRZCLjkbP1YZ4/a0O8s0mo7SePZo/MwsDou2hEmqX1xOS1ZUJtgoLU7sh4g3yQ0IhbQOdsV9J2fXr3FUdNy6IdVG1PztAmZQydbHG5PZiQbgiDEM1kQ3ZqOSXDvoJPnrxstGWAz/JbGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yAsjFk/Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yAsjFk/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2A81F000E9;
	Tue, 21 Jul 2026 18:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656809;
	bh=tUdNrPB47tUPUEit/iipeI/zGdGIRntWKClrm0JiEws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yAsjFk/QgnkU1VLBlJLPiQ9UnsalOQDMWlNX4kaUXdFE9yfHShSFOcrHJ2VJofX/s
	 DxRX8P9mVdcbAuQEw3WN1gD6fYBCAKQdLs4icBtt9mSJ3nap62G5o5skB1Yzfbjp2e
	 KMGUC3QGj/V44bgG5wq26yanO7T1HYg1htAqkNL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Wayen.Yan" <win847@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0528/1611] net: airoha: Fix register index for Tx-fwd counter configuration
Date: Tue, 21 Jul 2026 17:10:44 +0200
Message-ID: <20260721152527.226709539@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayen.Yan <win847@gmail.com>

[ Upstream commit 1402ecccf5630a0b7fa4749d7d2e72abc3f3d73d ]

In airoha_qdma_init_qos_stats(), the Tx-fwd counter configuration
register uses the same index (i << 1) as the Tx-cpu counter, which
overwrites the Tx-cpu configuration. The Tx-fwd counter value register
correctly uses (i << 1) + 1, so the configuration register should use
the same index.

Fix the REG_CNTR_CFG index from (i << 1) to ((i << 1) + 1) so that
the Tx-fwd counter is properly configured instead of clobbering the
Tx-cpu counter config.

Fixes: 20bf7d07c956 ("net: airoha: Add sched ETS offload support")
Signed-off-by: Wayen.Yan <win847@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/6a2b40e7.4dd82583.3a5c46.e566@mx.google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 5bf725a7859248..7e7256d92fdb0b 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -1275,7 +1275,7 @@ static void airoha_qdma_init_qos_stats(struct airoha_qdma *qdma)
 			       FIELD_PREP(CNTR_CHAN_MASK, i));
 		/* Tx-fwd transferred count */
 		airoha_qdma_wr(qdma, REG_CNTR_VAL((i << 1) + 1), 0);
-		airoha_qdma_wr(qdma, REG_CNTR_CFG(i << 1),
+		airoha_qdma_wr(qdma, REG_CNTR_CFG((i << 1) + 1),
 			       CNTR_EN_MASK | CNTR_ALL_QUEUE_EN_MASK |
 			       CNTR_ALL_DSCP_RING_EN_MASK |
 			       FIELD_PREP(CNTR_SRC_MASK, 1) |
-- 
2.53.0



