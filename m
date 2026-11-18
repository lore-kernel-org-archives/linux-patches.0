Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024893;
	b=DwZfO7bUb7krRbY9+Y78e/k4qmLOOTVgxcUacpLPBFHCfVwejt7FSx8OlOesc3Xjb1IJ
	 FsteF7E/tmsQn04LvlCKmpUTw+b4h933y20G6SSYYnhRAUdjgU8KablULgwFxZ7BcQenW
	 7tetFeJWJ+3MbRZRHvDbKTjTkGrskPSrx76Umnuc1H0K640cXNuQOw+UG+guNO20LFL/W
	 TyHUm+6ruUUqfAli+hrqK5N/hmGXsmeRtTetOfx8OlfhExpX2nYthpnvUt28VC5mY8Ik2
	 takZ/v8XTV6vOlTRTlvXwngRY1jfOavN7KXDrZ78PEHWXuc+tfhmBHViD9W49IxskLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WrWWXNDdLlB79R7YJLirtqXhiWOXMCwIudYRZIKtOZA=;
	b=w3URwOUVxQSA3GR5oBBQQTfEFlfvyape3pYCTafL5wm/BLTgd7MuxxZBpSDArE8dCpRH
	 ls+DczQgY+7YijzgmH6zrYncdddG3BPPQhQ60BEWbjQV4FsJWefPO3JZOGYcOZQRol06C
	 SYsIP8JJUshoDq0/uYagcybK1SDlJcrT3KU5f2mwLzal8mU2BSaGOHBTvhSys/JCFOJss
	 50pb+/dOSBtDezAEwd7tDcJ6ypJuoZGHUcarzx80g41OyUkdLI3/7WScfM2NfxRB/9JZd
	 ucNtOMSe/lsa9bSDSoirwPZTHqxWxvzlXvjLRCOj+mRwMbRCDFP4f0odnOxaIEc7lpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="NIJ/Ezrn";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F29606A31C;
	Wed, 18 Nov 2026 18:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NIJ/Ezrn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281321F000C4;
	Wed, 18 Nov 2026 18:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024892;
	bh=WrWWXNDdLlB79R7YJLirtqXhiWOXMCwIudYRZIKtOZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NIJ/EzrnnoGMYIMC3MqFmXgkk9KDlhOoX9lkTTby9K925NiPUkjimXPlErXC+fslr
	 YXITR/y32CzWXar8wmCllq/iGNWyYK1e7txpNhb7wFKPXtu4Qu1gkShZ8LkKUVVkkJ
	 3YD+d1ODRXWBsJwTltFFUXK5jl/cbO6mUuAtjdvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Quanye Yang <quanyeyang@proton.me>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0886/2151] RDMA/rtrs-clt: Dont WARN on unexpected info-response opcode
Date: Wed, 18 Nov 2026 15:43:41 +0100
Message-ID: <20261118150154.591616670@linuxfoundation.org>
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

From: Quanye Yang <quanyeyang@proton.me>

[ Upstream commit 49c5691ad76f000e66c4f2635d5f196db5d038f9 ]

The info-response receive is posted for a SEND.  The completion
opcode comes from the peer, so RDMA WRITE with Immediate is a
legal WC on that WQE even though it violates the RTRS handshake.

WARN_ON(wc->opcode != IB_WC_RECV) treats that peer-controlled
field as an internal invariant and panics with panic_on_warn.
Treat a non-SEND completion as a handshake failure: log it and
keep the existing CONNECTING_ERR cleanup.

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Link: https://patch.msgid.link/r/20260921-rtrs-fix-rtrs-clt-info-rsp-done-v1-1-c64281ed97c0@proton.me
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Closes: https://lore.kernel.org/linux-rdma/CA+0ovCge-K+hcGHXZ4R3Ww5+cg159uxHBeVbKeUSLBRSMT8OWA@mail.gmail.com/
Signed-off-by: Quanye Yang <quanyeyang@proton.me>
Reviewed-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 96f76dfe18619..99de772e99afb 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -2499,7 +2499,12 @@ static void rtrs_clt_info_rsp_done(struct ib_cq *cq, struct ib_wc *wc)
 			  ib_wc_status_msg(wc->status));
 		goto out;
 	}
-	WARN_ON(wc->opcode != IB_WC_RECV);
+	if (wc->opcode != IB_WC_RECV) {
+		rtrs_err(clt_path->clt,
+			 "Path info response has unexpected opcode %d\n",
+			 wc->opcode);
+		goto out;
+	}
 
 	if (wc->byte_len < sizeof(*msg)) {
 		rtrs_err(clt_path->clt, "Path info response is malformed: size %d\n",
-- 
2.53.0



