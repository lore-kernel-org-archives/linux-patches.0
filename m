Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF963DBA1
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gupAUxAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC3CC433CA;
	Wed, 15 Nov 2023 19:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078314;
	bh=KFImAHLIefGUwpxZr+bqxoMcwkUNIO78FNeENTboe4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gupAUxAln1TuVJ7aU50WRQS4YZ5BOiMQJ/6FDqFR8WKJ2XoDRNm5JWhrQnfHvAZHE
	 arGAN4BgULniMw7SOTeUwP6Sb15craz90QFyLewZj42lX5qJyNakIjtwOa8Tq/YSqi
	 ZTnM05iv65IiNP8BqLsR4hccNiE+43q/eVmsB8Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luoyouming <luoyouming@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 222/379] RDMA/hns: The UD mode can only be configured with DCQCN
Date: Wed, 15 Nov 2023 14:24:57 -0500
Message-ID: <20231115192658.256437998@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

From: Luoyouming <luoyouming@huawei.com>

[ Upstream commit 27c5fd271d8b8730fc0bb1b6cae953ad7808a874 ]

Due to hardware limitations, only DCQCN is supported for UD. Therefore, the
default algorithm for UD is set to DCQCN.

Fixes: f91696f2f053 ("RDMA/hns: Support congestion control type selection according to the FW")
Signed-off-by: Luoyouming <luoyouming@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20231017125239.164455-6-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 56da0a469882d..8a9d28f81149a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4883,6 +4883,9 @@ static int check_cong_type(struct ib_qp *ibqp,
 {
 	struct hns_roce_dev *hr_dev = to_hr_dev(ibqp->device);
 
+	if (ibqp->qp_type == IB_QPT_UD)
+		hr_dev->caps.cong_type = CONG_TYPE_DCQCN;
+
 	/* different congestion types match different configurations */
 	switch (hr_dev->caps.cong_type) {
 	case CONG_TYPE_DCQCN:
-- 
2.42.0



