Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80651632D3;
	Wed,  5 Feb 2025 14:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767049; cv=none; b=FB1qHRq+yZ1vZleENZ/TGNKcVqvFrxcpTTpIZ1YpxTa7GNqnKnAbzSlNgwHnKdXYloGoPTr7Znk32Y/8JCAI0nq/FEBCCkhUKwHRTXPMj7EOAf19ZR9eSDURFQwzsOz8cf6uY+J/Y9yB1Vom7H9iSmVqFIhZQQ5zkHBKDqwKAfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767049; c=relaxed/simple;
	bh=1ehSU790AnDCAtsfCPyAudhyk234ZaYlTFhVEX+XWhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdD6gHj8i85LKFfkc1nDiQ9oHSRw58t8rv74z5DXa6fybknmDUoGJKC4bslpqXAkvYrZgtjE2vBhrgqQsrqSfZJiqV7bPzXaIFv/C3Kf1WtE14GU/T64m2Hwqap9uuiDgbbaJSII3J8kD/4r7N8bxZTigWEAgMzKt/dWSipwHsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wP7HqSvt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wP7HqSvt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F45C4CED1;
	Wed,  5 Feb 2025 14:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767049;
	bh=1ehSU790AnDCAtsfCPyAudhyk234ZaYlTFhVEX+XWhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wP7HqSvtBlknIHyNm9YKFGkL1ABFtFN6yQBm50nT5WXB/yTBscIjMT02qOaNgIqQo
	 NLSFwXXqxBwT7yDAk0w5vtR9ZpIkh4MpkUY6Z1jOA4m1ooFpT3Zo+Rxs1N+DBP57a+
	 2x2blEE6UfCCdTosCx28JArS4+j4GhcC6hR0u3tE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anumula Murali Mohan Reddy <anumula@chelsio.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 399/590] RDMA/cxgb4: Notify rdma stack for IB_EVENT_QP_LAST_WQE_REACHED event
Date: Wed,  5 Feb 2025 14:42:34 +0100
Message-ID: <20250205134510.529135322@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anumula Murali Mohan Reddy <anumula@chelsio.com>

[ Upstream commit 42e6ddda4c17fa0d5120e3723d522649f8fc62fa ]

This patch sends IB_EVENT_QP_LAST_WQE_REACHED event on a QP that is in
error state and associated with an SRQ. This behaviour is incorporated
in flush_qp() which is called when QP transitions to error state.
Supports SRQ drain functionality added by commit 844bc12e6da3 ("IB/core:
add support for draining Shared receive queues")

Fixes: 844bc12e6da3 ("IB/core: add support for draining Shared receive queues")
Signed-off-by: Anumula Murali Mohan Reddy <anumula@chelsio.com>
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
Link: https://patch.msgid.link/20250107095053.81007-1-anumula@chelsio.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/qp.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 7b5c4522b426a..955f061a55e9a 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1599,6 +1599,7 @@ static void __flush_qp(struct c4iw_qp *qhp, struct c4iw_cq *rchp,
 	int count;
 	int rq_flushed = 0, sq_flushed;
 	unsigned long flag;
+	struct ib_event ev;
 
 	pr_debug("qhp %p rchp %p schp %p\n", qhp, rchp, schp);
 
@@ -1607,6 +1608,13 @@ static void __flush_qp(struct c4iw_qp *qhp, struct c4iw_cq *rchp,
 	if (schp != rchp)
 		spin_lock(&schp->lock);
 	spin_lock(&qhp->lock);
+	if (qhp->srq && qhp->attr.state == C4IW_QP_STATE_ERROR &&
+	    qhp->ibqp.event_handler) {
+		ev.device = qhp->ibqp.device;
+		ev.element.qp = &qhp->ibqp;
+		ev.event = IB_EVENT_QP_LAST_WQE_REACHED;
+		qhp->ibqp.event_handler(&ev, qhp->ibqp.qp_context);
+	}
 
 	if (qhp->wq.flushed) {
 		spin_unlock(&qhp->lock);
-- 
2.39.5



