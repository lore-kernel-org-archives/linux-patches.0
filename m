Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE0F70838;
	Mon, 23 Jun 2025 21:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712825; cv=none; b=JPIddgCJ18Z0Ovuf3Payb29PvMXMMXTzXgvp7Aa+0DyvgUqbEpYvm3/DH6aTMI0PD7l2F+OaKA8NImNA8FuvTMFqQqScvC9J1IIcoYMjlszjpi8JqIIQTnn0iEdU9EVz7UCbGpfIferfXKEHHGOxNiHuAi3qv8YZu4D7DPDsQN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712825; c=relaxed/simple;
	bh=Q1uA7n/rOxBOYtR6+kpaKgtc2xD4+2hR55GPsN8ikuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6i9G81OYQhEZcdyX2Iy50P7TN/hHr2vLYtBqKlsZr2HvUo2d2kd3GMnKY+YCbcCRXmeWkyS2t0Z2StE9fbz+6fxMGCkZxNok0b0GaHVkN11LvWw/SJeftyklV82S9xiOWr1NTBhHhrr/Fvmjbynb5fZdgieo+p7Kb5UmlSlJ5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cwNz11hD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cwNz11hD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8050EC4CEEA;
	Mon, 23 Jun 2025 21:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712824;
	bh=Q1uA7n/rOxBOYtR6+kpaKgtc2xD4+2hR55GPsN8ikuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cwNz11hDD1hPOwnFgQ2dQr5wLwxWhYhnKHTjrYQ58b3y0CjPM5vzbGnuvz8NJtXaJ
	 T6iVbhLvxJPtDFu4HL93puIFGPIeHzz/Vx/ApIKj7eC8ewRc8QjTKtNCQkmVsBl30i
	 ntjI2vaOs1Ew4KAvmTAQ7szUANgvMCpft31Ias+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/508] RDMA/hns: Include hnae3.h in hns_roce_hw_v2.h
Date: Mon, 23 Jun 2025 15:01:47 +0200
Message-ID: <20250623130646.770176176@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 103a7787b3712..3a6a1f2430571 100644
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
index ab0dca9d199ab..be5d7a8ab4d43 100644
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
index a9eff72f10c62..e032db5e3dbf3 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -34,6 +34,7 @@
 #define _HNS_ROCE_HW_V2_H
 
 #include <linux/bitops.h>
+#include "hnae3.h"
 
 #define HNS_ROCE_V2_MAX_QP_NUM			0x1000
 #define HNS_ROCE_V2_MAX_WQE_NUM			0x8000
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index eae22ac42e05d..3a35f1fb84db9 100644
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
index 989a2af2e9382..6ba064899bf14 100644
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



