Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6734826B2B3;
	Tue, 25 Mar 2025 12:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906271; cv=none; b=oI3hcN/sliEB06j+kjbbR3RY7e/pRMZAWRehMGgb+mMFHDHf35kokFhsbUlwWgJe9zWNYoeft73nFpqwD36TzB3jiB9QoynZm+TCieVgjeADzqKGYUIHqw6pwh0VhWELu7TkV2Rc6HzVbMxmz+wTCAWRaQEFljNBYTwzTdGamhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906271; c=relaxed/simple;
	bh=wyOFq07p58OSkWx9wXO55j/fM74n9ai2rtENavVwyUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UP3eGUZRpIwuLx5S+K1kE/XyBcKTBGXN+lIAeuOigFEUsHbsCfUEe+4pzqvOq3O7VBjunTv0gps78Tora/mkMQrsCNXQOX3Ae0mPvh6dcwkF18ZzMPVYe3p/0jpbDqkDG/FRodNrWjk2NkZ1yhu5NfGHnl6EFgqXLbQVNr3xocg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y0Eny3Wr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y0Eny3Wr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1577AC4CEE4;
	Tue, 25 Mar 2025 12:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906271;
	bh=wyOFq07p58OSkWx9wXO55j/fM74n9ai2rtENavVwyUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y0Eny3WrzSQZxfz/OJx7MJUjA1I2FHOrLQkF3DJAoyEYR0+ZrrGtVnanJa13jYtaK
	 1zsd6QDuHh3QunMXDLkYIB57E8vHZUIs4FTfFaeacPDWoNoMwxe1JY7SM3/VOGv0jz
	 /THYdqSywd4mM9Bikv95oLXEMH+skyRUosjDLVQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/116] RDMA/hns: Fix missing xa_destroy()
Date: Tue, 25 Mar 2025 08:21:55 -0400
Message-ID: <20250325122149.934085252@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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



