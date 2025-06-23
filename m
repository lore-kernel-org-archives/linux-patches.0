Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A920219E0;
	Mon, 23 Jun 2025 13:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684787; cv=none; b=pELBM4fc9VeTFWQ//wwBVZbr0ZbLzJzzJ3CwaTtMIAC8qTd/6An0vrc4i+0bbsXYbdqwFDQVANEdEVSlr0fdk2aMZTSjeGOjSqWRe4sKddnuYwf+bcBPJQU8Q4NAevKkgv8p1185DgrJ6BYJneOLu7Ui7XFobLhlycpfDDgmqLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684787; c=relaxed/simple;
	bh=XOfP00PdTQYjFqeNsF1SwhhNjLKsiU4Fj7f4fbh4+k0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hOSaWesTuU+i3437qk15fH4LqlwwvDT+xKZYkLjhB2Y4cWttgKXcH2uNHjz2QL3W2dUsfzLdt9tGRM0hKP4o/7IvoGpvnGcB4TYHwpMIgSX2qhFizdwsWGi16pA4rC7UvJmj6MxPb5kiYr8eobbw6ND+t6UNFdRrQNvw58FqBXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lcrCIeYB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lcrCIeYB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36E6C4CEEA;
	Mon, 23 Jun 2025 13:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684787;
	bh=XOfP00PdTQYjFqeNsF1SwhhNjLKsiU4Fj7f4fbh4+k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lcrCIeYBtypWrOV6eIVtwIh8TtiP0EcO5rrU+umnNIxzUjaCcy/YxNVkmq8UM1tD2
	 ukqw+rg8WpEG2vG56xwwYShsLYz+BoF+l3WHbqdS7mQPzXHPnyWIK2BqOoKAoOmgqC
	 We/mKUAIigXPKWi8HLOipOkL9HJXqFalkomIDRgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 029/222] RDMA/hns: Include hnae3.h in hns_roce_hw_v2.h
Date: Mon, 23 Jun 2025 15:06:04 +0200
Message-ID: <20250623130612.772793773@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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
 drivers/infiniband/hw/hns/hns_roce_restrack.c | 1 -
 3 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 28bbc4708fd48..f494a571c7a54 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -41,7 +41,6 @@
 #include <rdma/ib_umem.h>
 #include <rdma/uverbs_ioctl.h>
 
-#include "hnae3.h"
 #include "hns_roce_common.h"
 #include "hns_roce_device.h"
 #include "hns_roce_cmd.h"
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index b9ab3ca3079c7..45eac5db33145 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -34,6 +34,7 @@
 #define _HNS_ROCE_HW_V2_H
 
 #include <linux/bitops.h>
+#include "hnae3.h"
 
 #define HNS_ROCE_VF_QPC_BT_NUM			256
 #define HNS_ROCE_VF_SCCC_BT_NUM			64
diff --git a/drivers/infiniband/hw/hns/hns_roce_restrack.c b/drivers/infiniband/hw/hns/hns_roce_restrack.c
index 39c08217e861a..2ac0359a647b1 100644
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



