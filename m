Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941AD26A1AB;
	Tue,  8 Apr 2025 12:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113879; cv=none; b=cIk7wY3IBwFN4NjlXsfoNk10BNdma1lWqZbnrV6KAPMp4Iv9qXi2hqDwiddkMvpD+Zp75FspOyH/kCZnxm29RKpJSLyDKg9mpupUl2ENZPNLiuILQOzTbTrxBTEt8a2/SOiay22WoPeFpwhVir55Elr2jAwkDJzCUL2guktAKME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113879; c=relaxed/simple;
	bh=aND2NqkBZo4/TN7oa5lAFcZPy0/nk6xQb9GFfnTaxPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCKBbdlcIPaGJPpbv0tru/KFuJdMmuwr/+KneF6qU0RxR9S+R1JAg7jqg9l7uit/eXAm+Vw5X+lvfukhPzUSkIBJ38I/r1WFBfq2z6EhxzShkyX8VG/PEzduabhX/Z1FUWvxuN4DO8OqFC7I4SaWF9wnV+dNLHMDewwROoF5BfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=woE3h+/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="woE3h+/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F70EC4CEE5;
	Tue,  8 Apr 2025 12:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113879;
	bh=aND2NqkBZo4/TN7oa5lAFcZPy0/nk6xQb9GFfnTaxPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=woE3h+/+8c39nbhiY77yDB32fnxulGRRJ7MH2uoTgaHV8e5v6Pn1HAR1G0kBcCKvN
	 6n3sYE8BvGPzlWBkJFIrvhv5/tvnWjX8O+yIo+7Y77zldP1x63KfoSjNLU59rYGUze
	 Ms7IjwPXm1kEGkAcTWQ/jhXBZF4EfdOBw9ODE2XQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/154] RDMA/hns: Fix wrong value of max_sge_rd
Date: Tue,  8 Apr 2025 12:49:55 +0200
Message-ID: <20250408104817.017074854@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 6b5e41a8b51fce520bb09bd651a29ef495e990de ]

There is no difference between the sge of READ and non-READ
operations in hns RoCE. Set max_sge_rd to the same value as
max_send_sge.

Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20250311084857.3803665-8-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 70991649dc693..4c5179e45dadc 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -198,7 +198,7 @@ static int hns_roce_query_device(struct ib_device *ib_dev,
 				  IB_DEVICE_RC_RNR_NAK_GEN;
 	props->max_send_sge = hr_dev->caps.max_sq_sg;
 	props->max_recv_sge = hr_dev->caps.max_rq_sg;
-	props->max_sge_rd = 1;
+	props->max_sge_rd = hr_dev->caps.max_sq_sg;
 	props->max_cq = hr_dev->caps.num_cqs;
 	props->max_cqe = hr_dev->caps.max_cqes;
 	props->max_mr = hr_dev->caps.num_mtpts;
-- 
2.39.5



