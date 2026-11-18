Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050339;
	b=XoMt5dSr/gUiyg9CCN3owF6FMu62B2PI8BCw7jTqAZeiucjD7s5rYVrotwRcIJCKbdqE
	 86kWI0ZNz6O0Qd+cYII7sSMfYMOFsa83J3v3NPh+5nN0K8zqeJqDV58gXCiHUOwJ2u6eP
	 DqbcpWPLx3MEIetM0U41zMVnKnEL1OlE0YeGS8jhb6RoHZyH8s3CjuhzzGDVsAHYTTAme
	 nzBY2jGlnMy0C+KTYKKtp8h3eCGNnREXQ8AYWyJvLmUOWE7YPaZjCHXXaeZq4RaP1LyQg
	 dfcnfnna2m9/Es598u+0HH/qCwR9E6cwEp7k5rxPVcnZxV+rcjbA7UjBM3qH+ZYkbgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050339;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=najeLN42aADuf9f1LCkOn3u7X06S5COKes7AK7Zpfo0=;
	b=j5K444J82SRMIiqFS/icQOCqsCwBHEedSsNtSeuj0EEfHa0ba3Y7OJbvtX8wuw68Sug+
	 UYLsaW8qAJQLXX1OMJJEeoXs0AxSvNUzaTXtNYAwUYdzUxHHAe1RsI/X4r+Sr2gV2dZzQ
	 YPkTkbE/ojVOkBkhItr1J7/auS2k+0rjH9xTWeZirr3m09YBLOsNwWh53Ufk3ok2VAAcS
	 gpHWedftTXE1GKW7FEvgHki6fM74+OnER5JH7kLsXDDt0hgBA4yqly5cERUedxYZqiBNp
	 LH/YpW1w6TJBDbufZShQ3pKD9yyi+o71Pu8G99l5/IRPl4qzVUhIDKtn1+Xus2DXsag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F7pnzAFH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9160A606A31C;
	Thu, 19 Nov 2026 01:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F7pnzAFH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7DC91F000C5;
	Thu, 19 Nov 2026 01:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050339;
	bh=najeLN42aADuf9f1LCkOn3u7X06S5COKes7AK7Zpfo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F7pnzAFHn0iyAYAGAhUyHtAG8ZNNTmjmpnoaTe+eP/WV801hlx3NLk55y0kj6u3a7
	 jr/RJAP5K2H1cPMdVPuphKEY+PPIUUoHsdhpZk+II9XTlKohyEnuuvFkgi75kc3iDf
	 5twPY8Hu2OSahw33uw5iWv75I9GahgpLe7K4I8cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2622/2857] octeontx2-af: Fix CQ enable state tracking after AQ writes
Date: Wed, 18 Nov 2026 16:00:56 +0100
Message-ID: <20261118150335.980886134@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8b2e59e864d3a..5d6cfd3d3a7cc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -1040,7 +1040,7 @@ static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, struct nix_hw *nix_hw,
 				__clear_bit(req->qidx, pfvf->rq_bmap);
 		}
 		if (req->ctype == NIX_AQ_CTYPE_SQ) {
-			ena = (req->rq.ena & req->sq_mask.ena) |
+			ena = (req->sq.ena & req->sq_mask.ena) |
 				(test_bit(req->qidx, pfvf->sq_bmap) &
 				~req->sq_mask.ena);
 			if (ena)
@@ -1049,7 +1049,7 @@ static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, struct nix_hw *nix_hw,
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



