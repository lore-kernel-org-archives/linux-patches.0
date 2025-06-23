Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EC9254869;
	Mon, 23 Jun 2025 13:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685244; cv=none; b=AZeXWy2wBs07q4MzT+M1TOpkOc/IxkyP2rm/QgrbBCjPc382q7vmmp+/QnywaojaQpiPU0OxgxVGnpttMM1smzuept2Vi9CmD1UIjbQlwGmQQnao9KboVhDjLVC+QX1b6zvoCiFOfx6/9vhEmWgGfHd1qb/1fmSpmyrWz467+hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685244; c=relaxed/simple;
	bh=HBXEaJKB7AiYNRAieSXYGwti5OHU0rGeuFqteoZ/Rr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQKaqcpA6HgpqrkPbgozJeG8mFks5x3Rq4hdOz8AwlsWKKjAy/v75c4tBd7FQxac+bd7jiSTNVydd/UgUz7UkL6LOxLvUjFFknvDkI3vS7wLe9p/Fnzh/K0EMDk9RaXK3V6atwq+32fbXYuiwEGdD3ycnNK7ptVDBoeyAVhAY2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvfCJmdS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvfCJmdS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A396C4CEF0;
	Mon, 23 Jun 2025 13:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685244;
	bh=HBXEaJKB7AiYNRAieSXYGwti5OHU0rGeuFqteoZ/Rr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cvfCJmdSrlp5YxK0MlvUuf4bawrOnwNQBTXa6d8eTcCVQ2kJTkbP4MFqAx9C/oufE
	 O6T2IpAFW0Qnm2BIahWHyROVsOv7zyQdrHC5+sr9/YMlQxv30CocWC9/Vb4o/BQNCD
	 s9he+O+FrxvckZarloBPkR4RoPcrZtaKGpQT/Ts4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/355] RDMA/hns: Include hnae3.h in hns_roce_hw_v2.h
Date: Mon, 23 Jun 2025 15:03:59 +0200
Message-ID: <20250623130627.970447775@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 2b11d33de23262cb20d1dcb24b586dbb8f54d463 ]

hns_roce_hw_v2.h has a direct dependency on hnae3.h due to the
inline function hns_roce_write64(), but it doesn't include this
header currently. This leads to that files including
hns_roce_hw_v2.h must also include hnae3.h to avoid compilation
errors, even if they themselves don't really rely on hnae3.h.
This doesn't make sense, hns_roce_hw_v2.h should include hnae3.h
directly.

Fixes: d3743fa94ccd ("RDMA/hns: Fix the chip hanging caused by sending doorbell during reset")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20250421132750.1363348-6-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c    | 1 -
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h    | 1 +
 drivers/infiniband/hw/hns/hns_roce_main.c     | 1 -
 drivers/infiniband/hw/hns/hns_roce_restrack.c | 1 -
 4 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 13aa8dd42f7d6..bb744ba155e2b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -42,7 +42,6 @@
 #include <rdma/ib_umem.h>
 #include <rdma/uverbs_ioctl.h>
 
-#include "hnae3.h"
 #include "hns_roce_common.h"
 #include "hns_roce_device.h"
 #include "hns_roce_cmd.h"
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 8948d2b5577d5..80d14261cc4e1 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -34,6 +34,7 @@
 #define _HNS_ROCE_HW_V2_H
 
 #include <linux/bitops.h>
+#include "hnae3.h"
 
 #define HNS_ROCE_VF_QPC_BT_NUM			256
 #define HNS_ROCE_VF_SCCC_BT_NUM			64
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 3c79668c6b3b5..9078855aad184 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -37,7 +37,6 @@
 #include <rdma/ib_smi.h>
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_cache.h>
-#include "hnae3.h"
 #include "hns_roce_common.h"
 #include "hns_roce_device.h"
 #include <rdma/hns-abi.h>
diff --git a/drivers/infiniband/hw/hns/hns_roce_restrack.c b/drivers/infiniband/hw/hns/hns_roce_restrack.c
index 259444c0a6301..8acab99f7ea6a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_restrack.c
+++ b/drivers/infiniband/hw/hns/hns_roce_restrack.c
@@ -4,7 +4,6 @@
 #include <rdma/rdma_cm.h>
 #include <rdma/restrack.h>
 #include <uapi/rdma/rdma_netlink.h>
-#include "hnae3.h"
 #include "hns_roce_common.h"
 #include "hns_roce_device.h"
 #include "hns_roce_hw_v2.h"
-- 
2.39.5



