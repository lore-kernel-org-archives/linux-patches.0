Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042075;
	b=V0Llpyze4eAMKNj7437eFwVl928T4IwFrsoOF2Dy51VmODxvbBGMbW9y/G2S1yOFN/D9
	 4jjEkz+RGNsl0/MRMbxGM7h4qmF1+nTrvtaW2BNaehGINMtAQnPdVGJ8ojNJ75e12yeRO
	 ecV76gFz93G8tEMX4BVDvJElmt6sbOa0216dmDlekWJ9DymAXbPeoQoyrJjEaEvVD2EHl
	 zk9xe/pZRQSK4dc7B+bsTsz/OurgSmMwBh98QuF7pOcgaXYEIKIqVXdaNa9xodwfGnqNT
	 Sltjduvjyrg8rLePn6AflFIlQEwZFzF6fBEej9MOANAzNP+SkB+nUj51wsogoiiLqDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AQjFmrV0C4csaIdB6IA7FcH8ymhnUqU9gPQmvX/WEOI=;
	b=QjPN4m2CAOzbEDfwk7m19EK+uNorQ/PCwF3ULs036SKCiaCSKuDS+9mFML/VU2wZ3IZu
	 7liEouatApOwmZ+A6lLQX7fdlzLulffpFAwHIzp2k1H4gr9iE4e3bmOPFfuw5KY55E0ee
	 U2xNF4t1Eh+7i7AcFJbsoURHDGq6Q71lATtBsM6zu6NggAvV8UDNXzblVHKKsm/eIg/qy
	 wlixzZ7uh4VWgLlQVexl9go2ncqEB4Pvj1xHnOd5mHwF7uoruLn/z2glBWG/PnOy84bG2
	 A0meGX7X+U7cuh7sAMuRbN3cZjVQ1ATcpiuQF/RkovSYiMHKwTFDmYq2zJUERZAlViA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="T2sutP/N";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1369D606A31C;
	Wed, 18 Nov 2026 22:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T2sutP/N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C6C1F000C4;
	Wed, 18 Nov 2026 22:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042074;
	bh=AQjFmrV0C4csaIdB6IA7FcH8ymhnUqU9gPQmvX/WEOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T2sutP/Nsrit5hS5rkN4pb5gvkXVGx1eQglSt3g1QYXNipo29NwwLzLteNitUkxI+
	 bC7YCoHWybTBpVTWMRpsKMMAJZ5DcNu7gJEhoZNf3i/BysD12lrUqCakYIi61NderL
	 hm83AQB+JG9sfEOKAAE8qtkYnZvd7fjs/InKrXes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3042/3318] octeontx2-af: Fix CQ enable state tracking after AQ writes
Date: Wed, 18 Nov 2026 16:01:04 +0100
Message-ID: <20261118150451.422618374@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 35c8c7229f352..1a418acdba22c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -1052,7 +1052,7 @@ static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, struct nix_hw *nix_hw,
 				__clear_bit(req->qidx, pfvf->rq_bmap);
 		}
 		if (req->ctype == NIX_AQ_CTYPE_SQ) {
-			ena = (req->rq.ena & req->sq_mask.ena) |
+			ena = (req->sq.ena & req->sq_mask.ena) |
 				(test_bit(req->qidx, pfvf->sq_bmap) &
 				~req->sq_mask.ena);
 			if (ena)
@@ -1061,7 +1061,7 @@ static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, struct nix_hw *nix_hw,
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



