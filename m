Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27646535A4;
	Mon, 27 May 2024 19:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838540; cv=none; b=VuJ8HYQWwq5YN25/xjG3ujPNLILbK54IE3WsokVlkBc+afMJu4ogUMDNPtx7GynHRv5Mwi8vwDO6I39uN5QIfTXCB3vVaotfjlyOmw2bxy007rpQF9SYorn8kezhnuxheXfNe3MTqnzIRdkxsnouezK1ZPglSXsXLLzlgd2Mgpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838540; c=relaxed/simple;
	bh=6ZpzoyfiOnCmo0rCdPwbEDtk3yw3jK0ay+ALJ8VqSRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRh9i+Kn7VVVvOuIbUP3vXaADaG0lWbX2YrcTHa2I1mv2gY87mvUA7ytbXHiY6+UUBz/Mw2drfLKKa9FeNNHis7x+USp6/zfcqyNjndVazRMA0zxDqOh0eKBHT0l5qrlDAe5mgvDuhd9Unr8fgp5e4ZanU1jSac4kwuqT2jIY7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YeQBGmVL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YeQBGmVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55560C2BBFC;
	Mon, 27 May 2024 19:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838539;
	bh=6ZpzoyfiOnCmo0rCdPwbEDtk3yw3jK0ay+ALJ8VqSRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YeQBGmVLAbmmryj8r/r6dSVW0MzNukXod96ZHWcqEeLyvDkspNvMwM/Xbtv0fzYGq
	 /O/CT28hVLn2HV8ZxFi6tnrLr3VYHc70nGNNR63bEQCaLBVhIfnNM/5i6qsUUfPW1b
	 GylNS4WrAWSZii4Mlpnb5/8Jxtr07xGpYJyJP3YI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 431/493] RDMA/hns: Modify the print level of CQE error
Date: Mon, 27 May 2024 20:57:13 +0200
Message-ID: <20240527185644.379360275@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 9c9a707d26d67..f95ec4618fbed 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3715,8 +3715,9 @@ static void get_cqe_status(struct hns_roce_dev *hr_dev, struct hns_roce_qp *qp,
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



