Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021012;
	b=MnZefo4o63TVUMf6tymQ2PgwCgu2DPmbHP3w9FP6OFj7pI9i9boYFRTCaOhUGfrN6Whg
	 DwYpX5IkCdGaPbJp54EQlsJq0hU3Lj0MCY0nFNWqlvvy/VgJyVTgbHErliTz0TKTvWd+Y
	 +IBxn3E1CloJkM3bdBW+ZHPVcANcY8lyGeKvgWoOBhUY5UWufue+9POrH8e0pPOY39Cq7
	 McQVpI6gVdV5uYNa3UGKwQ2HxRBlk+cdQxWFuTb1udckbr5rfa+5xIshQl3DbYobkR5IR
	 g5NBT5CWjcyxB2Jozmutgz397tnExy4sfQG2RgQPeg73DTwsEl6SNHaA8zfu7Cl1RRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nvngIIimNv+33O0MqKKzbDD7MkNXSpKcGI7fYqdhvfU=;
	b=NUCWgCEsM2ZyJNhhqCgqOIqreTFwfYRNU/KTFq/r75Ww/1V+hnxp5jC+ib03mtE6VQX7
	 0ImfSotFwmmxSJiX4efhLHa464zAyJTkmeH/F+6J/p4TN5oTJrHmi1IWac5QnwJyTtsxI
	 oVN8NCPUzbV2B6oOPhQulQHextW24UdsPtYa1VhXeTXNf8km/bI/GFKORpsceGB62zs51
	 N9QVz9H/2jVkOMoBZV+hjddxinmzxZLYcVlzQBrJPs+h96/vzUuf1LJrjDAcN7TpaIZcI
	 L3I3on0hM1ItSd2KXAzlk1IwRF4ZpE/Uv9GU1O+a0om+Jwyf4TOcWsL9TVq3P3WFrwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TnojEujA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A6D606A330;
	Wed, 18 Nov 2026 16:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TnojEujA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179C91F000C4;
	Wed, 18 Nov 2026 16:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021012;
	bh=nvngIIimNv+33O0MqKKzbDD7MkNXSpKcGI7fYqdhvfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TnojEujAfL5/KMUypjLYMRXrtQBwsNp/xkArYNUc4VnPTJ4ZO5qbDczUWYYfBsgNe
	 UfY+2WTlyJprbsgKXQizQyDO5PRGVtgnKHjGXKRk0zu6vRk2vjCZvQrC5CMBLWLObL
	 ieTnifFN9hMsNtKnrBbbraWI06WbHUJSXaDpVcb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2157/2651] octeontx2-af: Fix CQ enable state tracking after AQ writes
Date: Wed, 18 Nov 2026 15:56:37 +0100
Message-ID: <20261118150403.470836434@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 153eb57bad067..95f782d479276 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -1239,7 +1239,7 @@ static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, struct nix_hw *nix_hw,
 				__clear_bit(req->qidx, pfvf->rq_bmap);
 		}
 		if (req->ctype == NIX_AQ_CTYPE_SQ) {
-			ena = (req->rq.ena & req->sq_mask.ena) |
+			ena = (req->sq.ena & req->sq_mask.ena) |
 				(test_bit(req->qidx, pfvf->sq_bmap) &
 				~req->sq_mask.ena);
 			if (ena)
@@ -1248,7 +1248,7 @@ static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, struct nix_hw *nix_hw,
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



