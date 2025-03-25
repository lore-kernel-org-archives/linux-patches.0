Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F0125B673;
	Tue, 25 Mar 2025 12:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905960; cv=none; b=m4/JPQuFbJnNh5y6hmSR0BpdvfyE8ZHj+mTE6Z3/Bsr9x5027uzIyfgCYG4ESoWOwuDsWXNUZkIdFj+/RQeXAl9GozcrzRQy3bj2QCV+Qu3r9y5IIXlM9MUYsop5W6lyh75YaSpkv6w83D6QTSYORNX1Ts6uObehQCIq5wAX2S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905960; c=relaxed/simple;
	bh=a+qeyKDTyPf4KKvtnDuf01Qz5CfZ8DGAOIG+rDcJm0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=is9PAL3JM7zEfGN1FxpAHL7ILJ6t/Q1TxsXgUMk38HLDo+W12fU82+a7nsL0AE6Ilvkxj9RuJmTvXQX1TaLChUsbYZG+OX9QYRhY7Qkgk8ZYFT5Js7FOXVnBsMFXClk6jToSXQtohAk44oYX/YxLQGSAmJXNbgOzdVgD5IO+twE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uWLz6uvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uWLz6uvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B03C4CEE9;
	Tue, 25 Mar 2025 12:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905960;
	bh=a+qeyKDTyPf4KKvtnDuf01Qz5CfZ8DGAOIG+rDcJm0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWLz6uvrD0EayAxT47yKSE5UBT7XbDRTgwabjA5uyu2rXqWR2q6KgEakCXz06tWa8
	 JswgTgjBW33ZgzZDA/oY6JVxVMkvuCH5d1HaE/gqNaIm7bRxMzPiN/3y6WVosqiyTo
	 tqgaldISK7CnVL8mdLWDh/8iGm1IpOs3gL1K08Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 028/119] RDMA/hns: Fix wrong value of max_sge_rd
Date: Tue, 25 Mar 2025 08:21:26 -0400
Message-ID: <20250325122149.784832862@linuxfoundation.org>
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
index ae24c81c9812d..cf89a8db4f64c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -183,7 +183,7 @@ static int hns_roce_query_device(struct ib_device *ib_dev,
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



