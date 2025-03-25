Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9BC259CAD;
	Tue, 25 Mar 2025 12:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905768; cv=none; b=coRaYcbeTc0CpqKyx3xeVDBZt8rganUzZfv8BdYTyr293HcCqla/N4780hXiYDEnEBqNs8QRb6rudY9dOgCSAoSq70q5YVEug/QBm8kB8QePV0cPNyK5OIIR2LCpTlqiNI76/OcZI2tYNugBagSQlrRkPNvU1nPQ6HBCH+3QhT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905768; c=relaxed/simple;
	bh=Ph7QLvp+MaHAs/TDM5ju004s8hzBiOOhVt82b/U+EyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOmfmI9BP3w61bHtUOAEbnR/2lbxZPqtI1Cj63b6tE6zr3A+P2GUEnxLIJnnwUEtuzsNmvL/D83JlGf+TzU4tf/Ek3woMduCPMYSM3kIeFdEuLpfLKKKJu/nMqIhaZpfX/zHEfCbAPft/zL90oq6HNvULaOpRk9F5tCNfo+uUwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jegMkrUc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jegMkrUc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494D4C4CEED;
	Tue, 25 Mar 2025 12:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905767;
	bh=Ph7QLvp+MaHAs/TDM5ju004s8hzBiOOhVt82b/U+EyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jegMkrUclZYFkxl2306HGbH+Vkx7NySz+1PyCsTqGQbcpZUPv818BHeN7kOGBOMu4
	 m4ZCsr6ub4TFdJlR2q2VIPw4mkH+yCTKbhQD7gTC6qQgf/wqgpP+vcPc4SiBR56a26
	 g1i3/BbGEyCyG+JV55wKudQo76H3aEh6VxYapoio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 153/198] RDMA/bnxt_re: Add missing paranthesis in map_qp_id_to_tbl_indx
Date: Tue, 25 Mar 2025 08:21:55 -0400
Message-ID: <20250325122200.672075841@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kashyap Desai <kashyap.desai@broadcom.com>

[ Upstream commit 67ee8d496511ad8e1cb88f72944847e7b3e4e47c ]

The modulo operation returns wrong result without the
paranthesis and that resulted in wrong QP table indexing.

Fixes: 84cf229f4001 ("RDMA/bnxt_re: Fix the qp table indexing")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/1741021178-2569-3-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
index 9c28f4625c920..9d4f744b001a9 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
@@ -220,9 +220,10 @@ int bnxt_qplib_deinit_rcfw(struct bnxt_qplib_rcfw *rcfw);
 int bnxt_qplib_init_rcfw(struct bnxt_qplib_rcfw *rcfw,
 			 struct bnxt_qplib_ctx *ctx, int is_virtfn);
 void bnxt_qplib_mark_qp_error(void *qp_handle);
+
 static inline u32 map_qp_id_to_tbl_indx(u32 qid, struct bnxt_qplib_rcfw *rcfw)
 {
 	/* Last index of the qp_tbl is for QP1 ie. qp_tbl_size - 1*/
-	return (qid == 1) ? rcfw->qp_tbl_size - 1 : qid % rcfw->qp_tbl_size - 2;
+	return (qid == 1) ? rcfw->qp_tbl_size - 1 : (qid % (rcfw->qp_tbl_size - 2));
 }
 #endif /* __BNXT_QPLIB_RCFW_H__ */
-- 
2.39.5



