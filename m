Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055568;
	b=bH7BgBuHkqr5wfZ/lmK1eWrRyLBXxGJpcP6RcbkeOtJon5uMcfxlFl56V1bFmrkUFHNd
	 45KSL1oVFHWm0bnuvG0upZhiHv3hgBnEHyS5Y9d7SEKzMevNXRZGak2zdatn07DppdSq2
	 rHIiEB8+LkFv8xIWr5N+kO/cCPR71lMPGgsFUQA3/PWztWFtYCfbG3AbOXHoa4IPHlCwZ
	 gb9MYcOSvEysaxdOGnZRNEOrbVjMhBrb1bPTD0bEpbjINby3jtt2D5VPlLjnsrh9nr2yL
	 74YFlUVU5So1MFZKjuHbol5PNpdmjrdHAyqwPnDxzGe7XDy5tW3heZbJ0QYE+buf5EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UZYaGBuqSmCzPcGw3luDhQC7pGNlYe98HIRk1egUelc=;
	b=DAr8+BrvfPK2VdXVAGlJg3NH8wkekBDtSzk4bkhlVH4JZO+khHoCVD5O1UjxNZY1/Edp
	 +DkbOXXNgZtu/u7A9gUxzAnPoggfQw7P75h9eln3kPHp5OGkeCzS0gRcPYyWHai6T971p
	 uP7kcYQCWUv0i45lF0ljqUZSv21TL5oy9FTCIwmSvDin0vGf1PKH78QYrHaHgT+7UCA/Z
	 YBeGaomBsnf0Gl//NQx7pVrcc9tVdVGBer0jGRJQeuGeO1gq9vU4MaTRHNy4qLlj3ZmD9
	 qRSgUn4aPYFKoVMJlNBpWGPBAJdiRjZcWqaLMnitUXtbaWzOBuX5JTJYN9VmSRmYkBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Drxcgoz8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39921606A33D;
	Thu, 19 Nov 2026 02:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Drxcgoz8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A151F000C4;
	Thu, 19 Nov 2026 02:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055568;
	bh=UZYaGBuqSmCzPcGw3luDhQC7pGNlYe98HIRk1egUelc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Drxcgoz8xFPbyU9p1sQUEGOeQafIuSp/e2Tv217GNSBV2R1nh5SiO+mvC3/nQstRP
	 jAAv5nTpQfI5ADYG32Yx5y8nXp/twIPj5pGwKslHq6egrulux18I1Sa5fZT+V4l1JB
	 RdkUt+2ICYuaJyoHaOyrOnczRZ85b7i9YshG0Dws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Quanye Yang <quanyeyang@proton.me>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1676/2214] RDMA/rtrs-clt: Dont WARN on unexpected info-response opcode
Date: Wed, 18 Nov 2026 15:55:52 +0100
Message-ID: <20261118150118.881684673@linuxfoundation.org>
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
index 792dd2defaaaa..081b8cd9bccbb 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -2494,7 +2494,12 @@ static void rtrs_clt_info_rsp_done(struct ib_cq *cq, struct ib_wc *wc)
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



