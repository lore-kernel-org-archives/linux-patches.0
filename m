Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056603;
	b=X4XCLy/hphjJs8G2OdoDDJOf7VUo91u1GnaT4NIhfvasf3kx4IwdmltKbOdvcx8jOihf
	 2ArXoHsZjQLstiqOCSl//Xm02WYv4sDya1mjFAikk+oZhIDMJDszg9EEgXOhs6cqkyAUh
	 0I9YnXIr6J6P1wkUDFg6HzpgDSVLLDDpnoomE9W7saEDC/+vyjf7iJigdhbZlAAzw+t2w
	 WNst+g6o7reLLghqTXN5rQUfpex0PZt7vlDTC+7i7A+g63KSJAHWAKrc5aRALWjHESWtT
	 lGONbhlRDAZ33zp3Y6NxtLW6l6NUp9troldxL/FlPAt6FnzKg0LqHZENln9mh2dGK+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056603;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qG5sj2xIt9AP8e16dIxwoUgqQ8X8jsGOSrZmyKbRKbM=;
	b=f+BSfHM1ypE5qj63ecjIvGubrfd3HiREUeL6ZH8IQhTI0VDz+K7Qwi4pwL4Gre+ecOHC
	 ypBkIUHqJYa+qdnCDyPdfgBI4UhmXetwW3OFNhG9eeJLDMq5/ZURv+w3ME27/Ciaihr72
	 erECKJcZuKikqxS2cSp3i/U6EqGDMzWzf3bmO2nM3wplhuGTvkbPT8BF+t4q4b857HPko
	 x93JSlnHiAee7MPINL0Bzi5nxTfQaSO3dBjdoYi1udy0jfDJGtK+h23PKMkNjLDMqtHoK
	 hzkIqsfeMmhL5oyjrtZjS7pAAYgFvTSMkeljPnNASRlmNs5PJjuSfwOPMRuc3kwJDEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dqzk4UXy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642F8606A330;
	Thu, 19 Nov 2026 02:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dqzk4UXy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A671F000C6;
	Thu, 19 Nov 2026 02:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056602;
	bh=qG5sj2xIt9AP8e16dIxwoUgqQ8X8jsGOSrZmyKbRKbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dqzk4UXywosjL+UWksmSZi4MQ/7TRbESAO04ymVvyeatLgfwoZKRZdGtv7JMO0jZM
	 2dRH/RixQdrit92e1ZKLO8yY1BkfaxG/w7GwQAWEmh+RTxML7k44rTN+t9xjGdVoGk
	 vqdpYv+oFn5th+v/nBK2YVMmTpFuNdGNluxzKx3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2047/2214] octeontx2-af: Fix CQ enable state tracking after AQ writes
Date: Wed, 18 Nov 2026 16:02:03 +0100
Message-ID: <20261118150132.603006435@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b4f36266d253a..50e9d420a765b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -1038,7 +1038,7 @@ static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, struct nix_hw *nix_hw,
 				__clear_bit(req->qidx, pfvf->rq_bmap);
 		}
 		if (req->ctype == NIX_AQ_CTYPE_SQ) {
-			ena = (req->rq.ena & req->sq_mask.ena) |
+			ena = (req->sq.ena & req->sq_mask.ena) |
 				(test_bit(req->qidx, pfvf->sq_bmap) &
 				~req->sq_mask.ena);
 			if (ena)
@@ -1047,7 +1047,7 @@ static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, struct nix_hw *nix_hw,
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



