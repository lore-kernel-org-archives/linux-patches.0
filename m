Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027383;
	b=Udf1LmWBjTGfAn/1EYxy5C2oZIoLRxzysYIGF/xayGN+mYcfwQ5qHQw9i3tJvR3DLPZk
	 9cmc0yeKdFXA+CbwljtO6jF8gtd9W+i8NJP82FtXb1jZ8lKy7LJqUSPMGJnyf6b/LsRBz
	 jzkiIi6gDEODciHtaJ1zwgI5Mygf/n5InYXv/Ssvv2uqdB8qIRMWPj0yGjj4y1P8okHuV
	 E3aYF8Cdm9naVE+BfDwousC8683HFUr/reRTZKNE405V9i5d19JA++6ALClXcn33E7CFa
	 dNSQiWKhkUnQgWZf38gW16t+NqZtQb1URiRz+Fj2R9uBwerRY+YuIdgfjEgZYETPsrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aXmykG3WhNI3JxyXwo7KxBhRy+l4l8t7LBxorE8WDBo=;
	b=fCAaaz3DYxaAgwihgayOXPrFkKMx1ia6mjs+4Xh5rydr2rBRp3h9Vhojz7JVj90z7aS3
	 IYt4tbSmaRlUfqWIgZ6x2DkNRuNX+N+ZNlOaUiWnVeLtq8BcnuDR78Ut37Qr45nF4GR02
	 T2SHDnCXY+DfcIareGfGlkP9U7/9JXIR9AlMi30sSxxCqN+TDKRCKFfhXmiN+FxQ92c/7
	 2+dMNYooihhvl9hcKVerw/zcWb4dHCAYgG9wsby9Lu+joX767U0PXVo+V9G0EI2Cp6veG
	 nHoGkhIfSYKk4KDISe3Ptmq/6sbdQXzcqDdDTt1knwIu6ciucKpLBCVKp7hVitmMPRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zt/STux6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A153560A260E;
	Wed, 18 Nov 2026 18:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zt/STux6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A991F000C4;
	Wed, 18 Nov 2026 18:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027383;
	bh=aXmykG3WhNI3JxyXwo7KxBhRy+l4l8t7LBxorE8WDBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zt/STux6PfOOjmzdib3xQmDPU2qQktRHs42tjY00sIWqlwOk2dJulmBIjU4Us4n85
	 uFSze17AQqUlotP/cAfYx0HBKEmRwuCL217M5xXxl3wKsgbX4F82W7Hc2iJEBJha53
	 IHUQV0eygPc6MpOF4jiNuIsAWNp1YqVFgn3UoAc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1769/2151] octeontx2-af: Fix CQ enable state tracking after AQ writes
Date: Wed, 18 Nov 2026 15:58:24 +0100
Message-ID: <20261118150226.274731109@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 07bd391eb9572e74f073c49acef327611234f9bb ]

Use the CQ context's ena field when updating the CQ enable bitmap.
The current code reads rq.ena, which overlaps bit 0 of the CQ base address
and can leave the bitmap out of sync with the hardware context. This can
cause enabled CQs to be skipped during teardown.

Use sq.ena for the SQ bitmap update as well, so each queue type reads
its own context.

Fixes: 557dd485eaeb ("octeontx2-af: Support for disabling NIX RQ/SQ/CQ contexts")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reviewed-by: Sunil Goutham <sgoutham@marvell.com>
Link: https://patch.msgid.link/20261011125508.534618-1-alok.a.tiwari@oracle.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 27c8a43192666..69430252ed492 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -1224,7 +1224,7 @@ static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, struct nix_hw *nix_hw,
 				__clear_bit(req->qidx, pfvf->rq_bmap);
 		}
 		if (req->ctype == NIX_AQ_CTYPE_SQ) {
-			ena = (req->rq.ena & req->sq_mask.ena) |
+			ena = (req->sq.ena & req->sq_mask.ena) |
 				(test_bit(req->qidx, pfvf->sq_bmap) &
 				~req->sq_mask.ena);
 			if (ena)
@@ -1233,7 +1233,7 @@ static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, struct nix_hw *nix_hw,
 				__clear_bit(req->qidx, pfvf->sq_bmap);
 		}
 		if (req->ctype == NIX_AQ_CTYPE_CQ) {
-			ena = (req->rq.ena & req->cq_mask.ena) |
+			ena = (req->cq.ena & req->cq_mask.ena) |
 				(test_bit(req->qidx, pfvf->cq_bmap) &
 				~req->cq_mask.ena);
 			if (ena)
-- 
2.53.0



