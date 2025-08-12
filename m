Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8581B87F2;
	Tue, 12 Aug 2025 18:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022561; cv=none; b=mjYH6Gv8rcdP41ALV1F5PUuRI45XfHke9/SxSSMeQWsFee7FcWTec88AWHM6dm0TvbukuYt83SHOT60kkz2aaF0Dcp+OkPsYYLng8ZfRyh82R1iie6PUxdTCP3JjfCx98JhqI2BGXcjpARG+reslj1QLPN4pLajx2hAjFr70VU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022561; c=relaxed/simple;
	bh=ZA/T6YscQtr4aD4wesSNfh/iXcbaxycR/Q0FeYd1aLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RI5vbiranDzmfSTE3+XVNu4BGJjDgMNTSy3XfqD5svAnqbhARhjtcSs7Re+DtWkwe4jJpe/l/tB18YG4AYBJ+YNkCIY1JaODH/c9EvXLqCtv/67hKaU48V7B5828CNjX5+MKk8jC/5szJtThD/JMhiwjXbT74goJfg2bced/AlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4edtIvx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4edtIvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9529C4CEF0;
	Tue, 12 Aug 2025 18:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022561;
	bh=ZA/T6YscQtr4aD4wesSNfh/iXcbaxycR/Q0FeYd1aLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4edtIvx1CPLO4msk9Y1COyxU3296YxY+reG/tXt90U7GfyGvK9ZNcu6+MUlOhAPB
	 NWL1yHmftwyNjbvg7hHRDaHVgbXcNiIJ7kfdB1bnIZXoaLx/IyeP4tQ7kXeOee6JRI
	 HzMiCUYqm0kcI1JSim6kt+fD1axTGkGutrayC74c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 192/369] RDMA/hns: Fix -Wframe-larger-than issue
Date: Tue, 12 Aug 2025 19:28:09 +0200
Message-ID: <20250812173021.989289955@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 79d56805c5068f2bc81518043e043c3dedd1c82a ]

Fix -Wframe-larger-than issue by allocating memory for qpc struct
with kzalloc() instead of using stack memory.

Fixes: 606bf89e98ef ("RDMA/hns: Refactor for hns_roce_v2_modify_qp function")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506240032.CSgIyFct-lkp@intel.com/
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20250703113905.3597124-7-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 5745231f9e3c..53fe0ef3883d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5371,11 +5371,10 @@ static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
 {
 	struct hns_roce_dev *hr_dev = to_hr_dev(ibqp->device);
 	struct hns_roce_qp *hr_qp = to_hr_qp(ibqp);
-	struct hns_roce_v2_qp_context ctx[2];
-	struct hns_roce_v2_qp_context *context = ctx;
-	struct hns_roce_v2_qp_context *qpc_mask = ctx + 1;
+	struct hns_roce_v2_qp_context *context;
+	struct hns_roce_v2_qp_context *qpc_mask;
 	struct ib_device *ibdev = &hr_dev->ib_dev;
-	int ret;
+	int ret = -ENOMEM;
 
 	if (attr_mask & ~IB_QP_ATTR_STANDARD_BITS)
 		return -EOPNOTSUPP;
@@ -5386,7 +5385,11 @@ static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
 	 * we should set all bits of the relevant fields in context mask to
 	 * 0 at the same time, else set them to 0x1.
 	 */
-	memset(context, 0, hr_dev->caps.qpc_sz);
+	context = kvzalloc(sizeof(*context), GFP_KERNEL);
+	qpc_mask = kvzalloc(sizeof(*qpc_mask), GFP_KERNEL);
+	if (!context || !qpc_mask)
+		goto out;
+
 	memset(qpc_mask, 0xff, hr_dev->caps.qpc_sz);
 
 	ret = hns_roce_v2_set_abs_fields(ibqp, attr, attr_mask, cur_state,
@@ -5428,6 +5431,8 @@ static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
 		clear_qp(hr_qp);
 
 out:
+	kvfree(qpc_mask);
+	kvfree(context);
 	return ret;
 }
 
-- 
2.39.5



