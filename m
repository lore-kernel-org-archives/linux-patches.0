Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6B925A64B;
	Tue, 25 Mar 2025 12:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905958; cv=none; b=CkwNJdkyu+stoy/7cRJXc7KlMBzXl9xZDnS4YQIf7wLqrXKcjqqH386ET2PNIYld/AU5JeCoIb+VKBonb4zr7im8VBTn4AXd66RQZiWaqWKuGJRiRLCrXgxRgtkBri/1zv0buzSsUijrEnChmuc6njkX9glCs1aPgXV56Fog9ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905958; c=relaxed/simple;
	bh=25CrqT5GD93uIYAbmP9FrJBvIUAgQtjHwxRyDWJSa4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WcI3dsWJLmshDQjMXJsww7jd82STTgKdAt3ypDbcjy4dfuwtbKBakJ5nq0qJb/4z/DP+bNTpvO36sm8pFhiKzurxBPnaSm5uCT1JbANjtZSoBUCBalSFbEmWYfJ+1UBxFA3PLg5Pj4E8A5ETNbX3iNVQO5k5CiMPPlkq50elVnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rqWzP32j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rqWzP32j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505A3C4CEE4;
	Tue, 25 Mar 2025 12:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905958;
	bh=25CrqT5GD93uIYAbmP9FrJBvIUAgQtjHwxRyDWJSa4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rqWzP32j2FP5qyaqM1P5JPg0cMGV4wjiVENgw6daJzOeSDsZNUtIYDPjC859cRTal
	 zTrQFgdodgScJrJuvMRfBR8VmzUrYgW0SlpS/H+aLj1j13rGSZEo7HlqaCvzgsKm79
	 ARqPpJMTKNmujjeKUCjWC7wk2E38oDHh0RQCKrNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 027/119] RDMA/hns: Fix missing xa_destroy()
Date: Tue, 25 Mar 2025 08:21:25 -0400
Message-ID: <20250325122149.760833387@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit eda0a2fdbc24c35cd8d61d9c9111cafd5f89b2dc ]

Add xa_destroy() for xarray in driver.

Fixes: 5c1f167af112 ("RDMA/hns: Init SRQ table for hip08")
Fixes: 27e19f451089 ("RDMA/hns: Convert cq_table to XArray")
Fixes: 736b5a70db98 ("RDMA/hns: Convert qp_table_tree to XArray")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20250311084857.3803665-7-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_alloc.c | 4 +++-
 drivers/infiniband/hw/hns/hns_roce_cq.c    | 1 +
 drivers/infiniband/hw/hns/hns_roce_qp.c    | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_alloc.c b/drivers/infiniband/hw/hns/hns_roce_alloc.c
index 950c133d4220e..6ee911f6885b5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_alloc.c
+++ b/drivers/infiniband/hw/hns/hns_roce_alloc.c
@@ -175,8 +175,10 @@ void hns_roce_cleanup_bitmap(struct hns_roce_dev *hr_dev)
 	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_XRC)
 		ida_destroy(&hr_dev->xrcd_ida.ida);
 
-	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_SRQ)
+	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_SRQ) {
 		ida_destroy(&hr_dev->srq_table.srq_ida.ida);
+		xa_destroy(&hr_dev->srq_table.xa);
+	}
 	hns_roce_cleanup_qp_table(hr_dev);
 	hns_roce_cleanup_cq_table(hr_dev);
 	ida_destroy(&hr_dev->mr_table.mtpt_ida.ida);
diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 4106423a1b399..3a5c93c9fb3e6 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -537,5 +537,6 @@ void hns_roce_cleanup_cq_table(struct hns_roce_dev *hr_dev)
 
 	for (i = 0; i < HNS_ROCE_CQ_BANK_NUM; i++)
 		ida_destroy(&hr_dev->cq_table.bank[i].ida);
+	xa_destroy(&hr_dev->cq_table.array);
 	mutex_destroy(&hr_dev->cq_table.bank_mutex);
 }
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 52b671156246b..8901c142c1b65 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -1603,6 +1603,7 @@ void hns_roce_cleanup_qp_table(struct hns_roce_dev *hr_dev)
 	for (i = 0; i < HNS_ROCE_QP_BANK_NUM; i++)
 		ida_destroy(&hr_dev->qp_table.bank[i].ida);
 	xa_destroy(&hr_dev->qp_table.dip_xa);
+	xa_destroy(&hr_dev->qp_table_xa);
 	mutex_destroy(&hr_dev->qp_table.bank_mutex);
 	mutex_destroy(&hr_dev->qp_table.scc_mutex);
 }
-- 
2.39.5



