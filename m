Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061914;
	b=dJ2N8SOHoo80CnBzSeCnCgmGpe9NbmxUw4GWe3yn3ycN3PlWb0iBBnqFA2o2C8zJeg5E
	 +FIpIE1DU9iH0WheXpRNICsLGYhRrnVFh7g3LbZKu5A40+jIDpnl6Cn21OUES1d3sxYIU
	 paXzyayCwMj3vxLk+jBk8pz6mrEaV7hhpEsUJasf42yLSnsff1XTNGO3tjg9HRnfdkpya
	 vyGWeNt12BZWofi/jti//k2W6Sj6ID2cgctShsUxhAlBfFVW9H9msW0micvFh0JqgmjtY
	 eIx+HCCrAMZiIXtHzPmcQh7q/Nqu/sXmEA2CIAf2WiPFMSwr4djjrm2UQmfzQSgFRpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061914;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4RjztGMWZwXVoW+Vs35UzTxrtlk3zCwnPOInoRxD1fI=;
	b=dkIJdWLctXbqdBWUMUlbYwiT6CL6aALjNMouKYSo17r8C55KeJfxymt1alIszsPdyEex
	 eMonNmZ10UJCsE+/oZ6WHiEht3UH0jQV194xbkly099G4IVCtuvkbURiKvZeCXd9cHKwx
	 3y/zDUnbcczQNa+xyFR4MOER+UGjaXiBe0AwlAL/u/Atyj9mwzR8XmZp26XXqHGvRHWvc
	 KMaqA5BGyKIdKyvUgUzTtvgx8i28S3rojmW96WYYZOlZpZw40OkaLlYgr2f4/wmxmdu+x
	 dtQwq10QJRwQzJVjCktu+85CVZUoCE7RGUmu/W6dDwjMZJtNv159mGhI+SMfqHWpK8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lK3nEBRI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D49606A320;
	Thu, 19 Nov 2026 04:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lK3nEBRI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F521F000CA;
	Thu, 19 Nov 2026 04:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061914;
	bh=4RjztGMWZwXVoW+Vs35UzTxrtlk3zCwnPOInoRxD1fI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lK3nEBRIN6epVnl1K4EjmGx1JA/CkpiNZYQRi6HBI6dsjknKzalRjXMPJgFcJqz9b
	 Pfds5HWjLzNCIOHLustT7arHMcnNUFXFySbX6dGNIyAMnQ5FYFr0nSWTuQte0m8z2j
	 YwwSNuP3hk+MuNlvN8LvNThsu0ZL3JTF4DOo+9ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1722/1848] octeontx2-af: Fix CQ enable state tracking after AQ writes
Date: Wed, 18 Nov 2026 16:02:40 +0100
Message-ID: <20261118150031.728320233@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 971e0ae917f41..283f8fd2bf450 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -799,7 +799,7 @@ static int rvu_nix_aq_enq_inst(struct rvu *rvu, struct nix_aq_enq_req *req,
 				__clear_bit(req->qidx, pfvf->rq_bmap);
 		}
 		if (req->ctype == NIX_AQ_CTYPE_SQ) {
-			ena = (req->rq.ena & req->sq_mask.ena) |
+			ena = (req->sq.ena & req->sq_mask.ena) |
 				(test_bit(req->qidx, pfvf->sq_bmap) &
 				~req->sq_mask.ena);
 			if (ena)
@@ -808,7 +808,7 @@ static int rvu_nix_aq_enq_inst(struct rvu *rvu, struct nix_aq_enq_req *req,
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



