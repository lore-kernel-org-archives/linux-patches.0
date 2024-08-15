Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D68063C;
	Thu, 15 Aug 2024 14:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732188; cv=none; b=tHyBJxXzr6H0ZE3hHZobVAUN2HKemzQa/4zOvlPepTBIAydQ/7pkJ/S7w5iCgeW7IZzSFxUZGDpdidvZUZyUF3X7/b2+Tys74qNpRUyjuZ0yZ9aRHOQ0OHHxfMgCdZMHpgQItE496ipITF4tErGuL+EfZPOKo6pI2GwDpO5C0dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732188; c=relaxed/simple;
	bh=KBv0fFuNJmkR0lucH3Xg7dbpy5VD4Qs8YdUUx8uH70c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FsqikKalltg1AdOhM9eksfs1W2oMP8KbSC0eqUiSgt/2DSr5rdLihbpLkyLIRjuob9GhOUXKoqi4jFZJ5Qf9KQvYVLAIe8V9/59sIB8kE/Nm54FDlRQM2k7nnnRvp635DNMnAhKPAQQjiC/PX3d6BeYQ8Mr1j/Y4sySUag5qeKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I3yHSRFj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I3yHSRFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E537AC32786;
	Thu, 15 Aug 2024 14:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732188;
	bh=KBv0fFuNJmkR0lucH3Xg7dbpy5VD4Qs8YdUUx8uH70c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I3yHSRFjys+XgsRd4G+PcForsyDMeO2d6py9Xa4wkM1In6eS3c0MLOqis0bKNdyxM
	 xn/C9ms9VuLERm/QC/fycTUzQlZHQtRkxPFOKE6shMqSJITSGO09l9WV+yVxOguMSd
	 RNlnbGB2p+v20TreDhjDpxexJguGjgMsuf2IL9f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Honggang LI <honggangli@163.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/352] RDMA/rxe: Dont set BTH_ACK_MASK for UC or UD QPs
Date: Thu, 15 Aug 2024 15:22:47 +0200
Message-ID: <20240815131923.163052591@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Honggang LI <honggangli@163.com>

[ Upstream commit 4adcaf969d77d3d3aa3871bbadc196258a38aec6 ]

BTH_ACK_MASK bit is used to indicate that an acknowledge
(for this packet) should be scheduled by the responder.
Both UC and UD QPs are unacknowledged, so don't set
BTH_ACK_MASK for UC or UD QPs.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Honggang LI <honggangli@163.com>
Link: https://lore.kernel.org/r/20240624020348.494338-1-honggangli@163.com
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_req.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 69238f856c677..a034aa8fc5ca5 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -362,7 +362,7 @@ static struct sk_buff *init_req_packet(struct rxe_qp *qp,
 	int			solicited;
 	u16			pkey;
 	u32			qp_num;
-	int			ack_req;
+	int			ack_req = 0;
 
 	/* length from start of bth to end of icrc */
 	paylen = rxe_opcode[opcode].length + payload + pad + RXE_ICRC_SIZE;
@@ -396,8 +396,9 @@ static struct sk_buff *init_req_packet(struct rxe_qp *qp,
 	qp_num = (pkt->mask & RXE_DETH_MASK) ? ibwr->wr.ud.remote_qpn :
 					 qp->attr.dest_qp_num;
 
-	ack_req = ((pkt->mask & RXE_END_MASK) ||
-		(qp->req.noack_pkts++ > RXE_MAX_PKT_PER_ACK));
+	if (qp_type(qp) != IB_QPT_UD && qp_type(qp) != IB_QPT_UC)
+		ack_req = ((pkt->mask & RXE_END_MASK) ||
+			   (qp->req.noack_pkts++ > RXE_MAX_PKT_PER_ACK));
 	if (ack_req)
 		qp->req.noack_pkts = 0;
 
-- 
2.43.0



