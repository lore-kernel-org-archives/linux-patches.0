Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030423;
	b=K2UrS5OQbhNhJBPMscvx5Dq56qeMaa0NQhXW05tdq/Dn6ROEEXyZnTOXq9dcZI0wuRJh
	 h2cTLzOoCYQl2deMX73mX/Jtw/RHBgHA0Htw48T+2Kg8vKF8y2EbFrVcHE6drTDxIEe/V
	 sPEv/K85l9/5PGKFfslmmfj8MU3IR492YdJ24VuA9pR9W67HNj6RKey3/BQcpbN5hMOES
	 mRxpiDpSpb5btESUN7F7MrJOv0jKIdlLGnso//G73EqFlKp6MrWSj7vzHWUC5fsOYeUAX
	 k5UvCSQxq68G/zmwFOefr2afCpA+anOcYBtbdKQuj3t2KQxeM04EdiIKRBtzLCsve3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030423;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mNjklT3RBJgnVwNvmlsTj+5y+nZdxeQc7TVki8O6P0o=;
	b=BFMVNbMdHhwoR1qnIWn5zA3ymthSkdR4duF5fyPtq/zt4xtHttcE3E8SlFJbRwjWpwhU
	 7MwFdkX5AvmwyaPqZexEdy15lTpkeW2/mWx4Hb7wRRpMZAcfgUyb1dx9PosbH1vLdh3xp
	 rB1flz0DiYxiKF2PS2qrEWmyL6XDVnj2AP1rzX46VwSp9h7NWMy10R9zp2ECZZ+fwOmfM
	 0tEtXfGNhFZceuYPex07uL0iHZUAgAOcw+Ze2mTHpO5vYLNRUIjzi9aI3QdrDpo/uz0Px
	 5LZDJI2V0t21zd4CJ2tG72XIt1rT312tV22bT99jZQghwRuXV5GJbB+DVrg7uw75ZVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t3OfCytF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F669606A336;
	Wed, 18 Nov 2026 19:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t3OfCytF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849851F000C4;
	Wed, 18 Nov 2026 19:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030423;
	bh=mNjklT3RBJgnVwNvmlsTj+5y+nZdxeQc7TVki8O6P0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t3OfCytFwdAmGTJdhnhWD7uCzdZ2YZb8oTyODgFBuMvloSTMG9gpzVXpzXSXEmiKV
	 g/hbR75+aKzLGwRcrXiPWZgi3Kz4VMIzHk8qG8PmhfvNJ2hlc20XnVjRBSqpRlwiDm
	 HC1rnaRloQVvNgtF611I9XIFH7Srk7Z5cNAH0+Es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Quanye Yang <quanyeyang@proton.me>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0700/1756] RDMA/rtrs-clt: Dont WARN on unexpected info-response opcode
Date: Wed, 18 Nov 2026 15:47:07 +0100
Message-ID: <20261118150037.058232423@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



