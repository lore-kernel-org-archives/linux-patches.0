Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040450;
	b=kddXmp/ozqpTFYuZuR/EIL54tLtzeWFoLtPoVIxM25m87VRTFvTRsa+MSZM8u9nasyov
	 Ni13lgVUBk/WHblgC+Dk3JZ+qLzr4ZvHK22EJtctqMyBjT66dfit7OuGh7/RFsASp6BmI
	 fc0uryp04kf79q7KxHS3cCgsf03LmVoaOJ0B7t9Os1gd5+J0rQOVTg9JDjJll8cb3PiUW
	 NLAX86C0SpCWIOm28GUdivLbsJNP5FJYh1T88WRFDXCfm39sBaS2/QyNFBVCWqbjdPDo4
	 nJdaQB38/9a5EqQUaluZ59FgzUABujr8S6k2Wsb+2ycCoh9DWPPg3zrqdOGKzJRNcWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040450;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CSAENoQ/nnkevvVVxn9F2OE4dlg7MlqpIi7vgbX2G/8=;
	b=g2xVMsGTVSaE2kHyzlo0T0P9WzSKoaicBnbIDiK1fG97hjdjGMMxtT8tbsuYJ6GX6x48
	 h3aigijqW0ev7LdpogZ5FxSVvbFhBodB6Xkob3QlLzw/jCtDROAiKUxNMt5QzxLPzuDsB
	 9q0mSUT5zb6zO3PRTl1DM0r5fS3iFNG83Mr2rlbcCaBU9bY/FZ7s/kd8iUCUtHdwMK9fM
	 OH0DgEqvbsEkFPF22STDqkWzdJOnaCpcxlZxBd1SM9KKWRBi0ibGW3OAfC7CdApa0nlqf
	 Z/e1JO6sj6KODxFcplPIl6HCqLJPDiSHwMPnoDbYqGDG32nNNEMnBB8zq+DRdVvjxUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=REyCKRtU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF7B606A31C;
	Wed, 18 Nov 2026 22:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=REyCKRtU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4636A1F000C4;
	Wed, 18 Nov 2026 22:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040449;
	bh=CSAENoQ/nnkevvVVxn9F2OE4dlg7MlqpIi7vgbX2G/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=REyCKRtUCpItJALY4MXexE31zxe03Ny8aAYNZGQ+2Z2PKNTYaawjYm4UWgxDM4zdP
	 gN/AWb6TOs5SY0c0x3BDHSP0rBOv4aR9w8ri48H9wg7o555Pw/YAnESoWqPMz8bWJI
	 X8vDupj9q/Z+vtvYiYAo4Nx/2ft4SPNj4BWPSLAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Quanye Yang <quanyeyang@proton.me>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2462/3318] RDMA/rtrs-clt: Dont WARN on unexpected info-response opcode
Date: Wed, 18 Nov 2026 15:51:24 +0100
Message-ID: <20261118150435.289636975@linuxfoundation.org>
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
index 55ea37d3796f6..f69a6252b93e6 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -2498,7 +2498,12 @@ static void rtrs_clt_info_rsp_done(struct ib_cq *cq, struct ib_wc *wc)
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



