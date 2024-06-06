Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E9319B3D3;
	Thu,  6 Jun 2024 14:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683376; cv=none; b=YkSC1KIKXwZzrgN9KjQJOKn2g4DlcT2Nf/G/bijFYFyFrQz0wmc3WYFE5iL+ZvogYfxfPWc5GM7uQf01TXXHUncRczxRiRWkZVrsjvTSRs6B8esfC5CHwMxO3qsJ1jq2Iwd6KC19LC6+RnNwj67OURDokH3GuZ0Sc3zEP1mgPbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683376; c=relaxed/simple;
	bh=C22R7VTYC22y3OBoDhL1VnFQUwLPQUqfc8DheIeQHAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ow3krMfxLCAcvIw/7NWd2hC9gsH+5bRmDAcFVl+EdMyEy94HnWH5VZJLb1VltYOP7s8M2ewg4aMMI1f7Kjm5wwyxRmAJ58o1rq6fKUsZQHbew5aAQqGii2bffUNUXcYNShHBlXy4NVk7ALCFPBQ2iC6p09GPmXaK/lD0BhjXRaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpceXjj7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpceXjj7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DEFC2BD10;
	Thu,  6 Jun 2024 14:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683376;
	bh=C22R7VTYC22y3OBoDhL1VnFQUwLPQUqfc8DheIeQHAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpceXjj7prlQyvWYQo2L23eEkUCGPtzCAxpGpYb3VqyAhhMiHynBu1nIt4rCyDjdT
	 8PXrF8jFezPvDCqjukNADWk2EjfAv3BPpQ+xAFeGvuILjDT01/r3DyRQU2UfxzkYZ1
	 if+OOW1bXXhnRn11H5XN9EyCkBox8I7hxKOBFcPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 242/473] RDMA/hns: Modify the print level of CQE error
Date: Thu,  6 Jun 2024 16:02:51 +0200
Message-ID: <20240606131707.833360960@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 349e859952285ab9689779fb46de163f13f18f43 ]

Too much print may lead to a panic in kernel. Change ibdev_err() to
ibdev_err_ratelimited(), and change the printing level of cqe dump
to debug level.

Fixes: 7c044adca272 ("RDMA/hns: Simplify the cqe code of poll cq")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20240412091616.370789-11-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 08e2e9569a52a..c931cce50d50d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3857,8 +3857,9 @@ static void get_cqe_status(struct hns_roce_dev *hr_dev, struct hns_roce_qp *qp,
 		   wc->status == IB_WC_WR_FLUSH_ERR))
 		return;
 
-	ibdev_err(&hr_dev->ib_dev, "error cqe status 0x%x:\n", cqe_status);
-	print_hex_dump(KERN_ERR, "", DUMP_PREFIX_NONE, 16, 4, cqe,
+	ibdev_err_ratelimited(&hr_dev->ib_dev, "error cqe status 0x%x:\n",
+			      cqe_status);
+	print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_NONE, 16, 4, cqe,
 		       cq->cqe_size, false);
 	wc->vendor_err = hr_reg_read(cqe, CQE_SUB_STATUS);
 
-- 
2.43.0



