Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2902EA14C;
	Tue, 17 Jun 2025 15:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175732; cv=none; b=c+nXAKwgWepebkvQBg+DdtGBhTUaXfD0qC10ZMw0sZ/divLXv7X6PI3toMCWLhgQYH0ur+pyPmHW818YRyjTfU0B3g3qxQ7JhkJ4mqJhVA2llecm7mYcgE1aHzpQNl4Zj1m0TsBoNinb+ukk/BXpShRlYdna7l1/VKt3I5tH5n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175732; c=relaxed/simple;
	bh=xO9LGuFw+vnf0wgP3qunMf2SCSMXNJTmRE+dsVjyF3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhRsuPMLbzOnnegj44BF5Z68M98HYInP9i6e9K9bMVUuAd19cBABSeKfELV2wVqFFgLx2SO9PePz8krs2ylvLaqqf57r3VaHHw47byKxdZxj0KZr+DfzZoHobtDZGqZaRwZWfLyz8C4Kecfa2+GT3I7tlzPtPQ+3zXI23KJiFMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBntJAEO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBntJAEO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A806AC4CEE3;
	Tue, 17 Jun 2025 15:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175731;
	bh=xO9LGuFw+vnf0wgP3qunMf2SCSMXNJTmRE+dsVjyF3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QBntJAEOvIHDZZ4OTsc7WeczPZStoAbUCZ5U6IPbPCYVjeu4J94FZSAmyEPGMAiit
	 hxsCD8TJ9cnjJmW8kaOQSK0PCKyfsNyvhInbO3Yd5sNeTef8TsehHSfOYLRpvEO4XI
	 ZpvydXhfxXP8ivCSGy1mabprgSZELSd02N16tF00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 134/512] RDMA/hns: Include hnae3.h in hns_roce_hw_v2.h
Date: Tue, 17 Jun 2025 17:21:40 +0200
Message-ID: <20250617152425.025562320@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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
 drivers/infiniband/hw/hns/hns_roce_ah.c       | 1 -
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c    | 1 -
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h    | 1 +
 drivers/infiniband/hw/hns/hns_roce_main.c     | 1 -
 drivers/infiniband/hw/hns/hns_roce_restrack.c | 1 -
 5 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_ah.c b/drivers/infiniband/hw/hns/hns_roce_ah.c
index 4fc5b9d5fea87..307c35888b300 100644
--- a/drivers/infiniband/hw/hns/hns_roce_ah.c
+++ b/drivers/infiniband/hw/hns/hns_roce_ah.c
@@ -33,7 +33,6 @@
 #include <linux/pci.h>
 #include <rdma/ib_addr.h>
 #include <rdma/ib_cache.h>
-#include "hnae3.h"
 #include "hns_roce_device.h"
 #include "hns_roce_hw_v2.h"
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index f5c3e560df58d..985b9d7d69f20 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -43,7 +43,6 @@
 #include <rdma/ib_umem.h>
 #include <rdma/uverbs_ioctl.h>
 
-#include "hnae3.h"
 #include "hns_roce_common.h"
 #include "hns_roce_device.h"
 #include "hns_roce_cmd.h"
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 91a5665465ffb..bc7466830eaf9 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -34,6 +34,7 @@
 #define _HNS_ROCE_HW_V2_H
 
 #include <linux/bitops.h>
+#include "hnae3.h"
 
 #define HNS_ROCE_V2_MAX_RC_INL_INN_SZ		32
 #define HNS_ROCE_V2_MTT_ENTRY_SZ		64
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 8d0b63d4b50a6..e7a497cc125cc 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -37,7 +37,6 @@
 #include <rdma/ib_smi.h>
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_cache.h>
-#include "hnae3.h"
 #include "hns_roce_common.h"
 #include "hns_roce_device.h"
 #include "hns_roce_hem.h"
diff --git a/drivers/infiniband/hw/hns/hns_roce_restrack.c b/drivers/infiniband/hw/hns/hns_roce_restrack.c
index 356d988169497..f637b73b946e4 100644
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



