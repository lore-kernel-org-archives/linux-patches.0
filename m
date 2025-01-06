Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7461A60890;
	Mon,  6 Jan 2025 15:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177736; cv=none; b=fgQv4AMICWolZEvOJX2krtmZEOzl9rAzfCrp09FlpmzXc2JdLVKjo+Xxvpj2amYWDffJ5GCf3r/+vQh7if4CJSOehbQMm7CqOO3XLH9cOUihWUO81QWoyIXggaHAeDjQqDKb7bEP9uP3p7ob1fiUGQkq8Jf6SizpfzJfwSmVgHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177736; c=relaxed/simple;
	bh=wq6KDaaTX3oMIIKAiTu+F/SZC14R16ctOP6jVIwnggM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fs/IXV/hn48wj7pkQKup9p7aaa1Zj+vNWi2FLKoy8c/qfYjc+axwL5qjVDDqbBtzYTAQVYOTnZmIkEGPre65sUrVdw1i20Y0FkB62GG4v5tqWsdaORY/EOrrsBXm2V99U6rtdZT7Bvz4xmvMpK5nC4+uZ9JA4Fu7AC1vR4qX9P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdicRB1Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdicRB1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82303C4CED2;
	Mon,  6 Jan 2025 15:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177735;
	bh=wq6KDaaTX3oMIIKAiTu+F/SZC14R16ctOP6jVIwnggM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IdicRB1QzYF+aR8klKdNGfofWo4waq3b1M52DJc1TCjrpXiCQ87R3d5VvBK2rVpex
	 Xm1MlF7X7OXRuyHE/91l7zqFnQNX6UD9EfouoTn/cCuqvp5YwTmnuaojLY/PBXQlfl
	 +GcTqtmpNKgUXQm5DfV8aMxy0LrWPmybaHLHAGQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/156] RDMA/hns: Fix warning storm caused by invalid input in IO path
Date: Mon,  6 Jan 2025 16:15:25 +0100
Message-ID: <20250106151143.209039752@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit fa5c4ba8cdbfd2c2d6422e001311c8213283ebbf ]

WARN_ON() is called in the IO path. And it could lead to a warning
storm. Use WARN_ON_ONCE() instead of WARN_ON().

Fixes: 12542f1de179 ("RDMA/hns: Refactor process about opcode in post_send()")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20241220055249.146943-4-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 6dddadb90e02..d0469d27c63c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -468,7 +468,7 @@ static inline int set_ud_wqe(struct hns_roce_qp *qp,
 	valid_num_sge = calc_wr_sge_num(wr, &msg_len);
 
 	ret = set_ud_opcode(ud_sq_wqe, wr);
-	if (WARN_ON(ret))
+	if (WARN_ON_ONCE(ret))
 		return ret;
 
 	ud_sq_wqe->msg_len = cpu_to_le32(msg_len);
@@ -572,7 +572,7 @@ static inline int set_rc_wqe(struct hns_roce_qp *qp,
 	rc_sq_wqe->msg_len = cpu_to_le32(msg_len);
 
 	ret = set_rc_opcode(hr_dev, rc_sq_wqe, wr);
-	if (WARN_ON(ret))
+	if (WARN_ON_ONCE(ret))
 		return ret;
 
 	hr_reg_write(rc_sq_wqe, RC_SEND_WQE_SO,
-- 
2.39.5



