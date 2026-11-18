Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018009;
	b=hpLcS4cgsiLOBIv/ENeAhS9oJ/ZTP685UwAer1FdXIXsOuOolkVnmKuKH8dNS9+BCsel
	 QUTH+jB2pat7E1PpvcLOfRe35tzyWik0mJf7HjTdqf0/TW10eeYjZN9M9zXrpaM2+cKzc
	 +a3rVjUVZROc7xW+KmAY3jriUb167+xER4dHe0EeH3yRrjrPHCdLVXA+NGaV58tPR4rvq
	 3tpydYypo9VrbFunWeDUshWPiq90KC9uJIVf+rFjiHhqRCOCBCN5KXPolKPx2XYM8CUk0
	 fjWl0w7oc0aoc1g8xZ2cIDJ2uFxzY0MhE4effAoxhzuxfX6U7iYPhP5TDZGDtBYGfMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=57LBuYJEW5FK2byw1BCldMJEVOz0Hleh36t3cPr+TzQ=;
	b=0wHkL/tDJ7oydGoebO3ysLTKGwSh/6TKr/WY80WjamZhBvYe8UrcN38qk9SZ3JT+wjG6
	 M9Sy96kQLugjxmZa4QdS1EuIf6vHHoQ5KsAg+mCARitw2I3RdosDteQBz1weGOwG5dlBE
	 6ugXa+5UNwmdKYr6j+toXIMW7MT1ScGhPIaBiGwEPH7kG00ogU8BvnYjbIdI26FvDAGNf
	 TndbcyqvFSmqPan8EdSyYa3RJZdsfQd9gZR5Yi6A9RyRH79XJjFZh7RbsjmErz5zWQZu9
	 7mVz4xOa/2pCMKYjc+AV2YDvvRQEVR3xPemsm1wqc5D/BfnsrkEDzEz9MfMIxgnVPXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mmLWld6h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5B4606A31C;
	Wed, 18 Nov 2026 16:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mmLWld6h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4024D1F000C4;
	Wed, 18 Nov 2026 16:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018009;
	bh=57LBuYJEW5FK2byw1BCldMJEVOz0Hleh36t3cPr+TzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mmLWld6hjW0KJa1aMqAaBaNkPIL08fFYmCMN44i2k0aoDRyoFNXvv+1qGeEk/cvqm
	 bW444ox6eEwWl/DVnKqduxru087Chg8un6ElXg49LM0Mus3JwbsMv5VvyBFZKFBbnZ
	 BFulINmRzGDUug0HZs42QNn75y6W8dVRuNGSkLn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Quanye Yang <quanyeyang@proton.me>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1047/2651] RDMA/rtrs-clt: Dont WARN on unexpected info-response opcode
Date: Wed, 18 Nov 2026 15:38:07 +0100
Message-ID: <20261118150325.660709261@linuxfoundation.org>
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
index 7fbbb9a536072..5ecfbad5ac89c 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -2518,7 +2518,12 @@ static void rtrs_clt_info_rsp_done(struct ib_cq *cq, struct ib_wc *wc)
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



