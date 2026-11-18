Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016598;
	b=Um+yHH2h+Q64uFlZl1aRDEI3YyDmVDV6jRNMs79HccMoq0Fy/HYCE4MfnGK3K0u13P+6
	 AtIqXzeDZpTEsuJ6wNZdyxmJaz0t192qRxiKRdaw3TdNpMqlrrdsCzYQabsQccvX8ZB5b
	 xU5OaBkGek3+yRf/sQJiEzbHDGG2hYZ7WbcjtlmRxq82pmMIckCFKHnq5P0n/HaiKJBat
	 JHqQjTl654XENp4YhVMozv4+8vtWpW4LcXu0CAwbft9XF7LMRgKkLEx3xsiBnNWItLRfa
	 iGztWtmzcHVEzoScjaPOvf/lMFnAEWHo+1S1/eFfplPOEWFPxQpTFQn0/gXOnPDNzVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016598;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n7RskBsrUcbIOut3hGMFDPLvMEJlBrCn8lbu18tvwS8=;
	b=Do1Q1yREI6CaSGsUiAqlC0HbLZjhSgMqbGepU96KfZGkUmZBhFRBMb7lSrH4Eh8pQTol
	 eBBJaUia5ZzzI04R1IaygpERphfJvRV1MAHxG6q/4/+6rsxpnKCdBJmbZoIeBcLP2W+Di
	 EhpED+Uy0AegQf4iX9a9gJ+xLI4aXdfqHqb0h+G037bvTcCx229wJy8qBKAsS1uIb4iq2
	 2X5z9Mrs19dHOrF5EbZ59/AsoK3NAjh8LHofLrlIu9C3/AFoWPTiLhyxKvbBeXeHJ8x0l
	 A/Pd/pl2EccL32LmQ5AaNEtlDrWtiXRQ6I5rVZ62MzSSCvND1sgkgOl9dZH8T5FR6Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nbpzcs9I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E702606A32C;
	Wed, 18 Nov 2026 15:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nbpzcs9I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779331F000C9;
	Wed, 18 Nov 2026 15:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016598;
	bh=n7RskBsrUcbIOut3hGMFDPLvMEJlBrCn8lbu18tvwS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nbpzcs9IbO+zDq0fPQgMpyc7Q8/bcNJbficZZzAOGE5l1IwdTtXNUo82uyy9k+Gcy
	 OPbPiHg1zvmjeE79FYQ9I0mF3Pd+qqPoeb5sy/Uxt4/O5lnHEVyRJSLm0feCp7UeXL
	 xQjc24+aeg1rIqDh88ZcxrKhij25FAdwcHcfNfgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Guixin Liu <kanie@linux.alibaba.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0585/2651] cxl/region: Create node access attributes for CFMWS-only NUMA nodes
Date: Wed, 18 Nov 2026 15:30:25 +0100
Message-ID: <20261118150308.785806746@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit ef71014055f7b4959e4cb023ca8a18258cb5641c ]

A NUMA node that only backs a CXL fixed memory window and is not
enumerated by SRAT has no memory_target in the HMAT code, so
hmat_callback() exits early at find_mem_target() and never creates
the node's accessN attributes:
/sys/devices/system/node/nodeX/accessN/initiators/* stays missing.

Commit debdce20c4f2 ("cxl/region: Deal with numa nodes not enumerated
by SRAT") had the CXL region notifier call node_set_perf_attrs()
directly for such nodes, but commit 2e454fb8056d ("cxl, acpi/hmat:
Update CXL access coordinates directly instead of through HMAT")
replaced it with node_update_perf_attrs(), which only updates
attributes that already exist and thus does nothing for these nodes.

Create the attributes with node_set_perf_attrs() when the node is not
backed by a real SRAT pxm.

Tested on a QEMU CXL topology with a CFMWS window not described by
SRAT or HMAT: node1/access0/initiators/{read,write}_{bandwidth,latency}
appear with the calculated coordinates once the region's first memory
block comes online.

Fixes: 2e454fb8056d ("cxl, acpi/hmat: Update CXL access coordinates directly instead of through HMAT")
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260917024632.1397380-1-kanie@linux.alibaba.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 27e63e6dab7c8..9a5fd3da539d9 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright(c) 2022 Intel Corporation. All rights reserved. */
+#include <linux/acpi.h>
 #include <linux/memregion.h>
 #include <linux/genalloc.h>
 #include <linux/debugfs.h>
@@ -2630,7 +2631,19 @@ static bool cxl_region_update_coordinates(struct cxl_region *cxlr, int nid)
 
 	for (int i = 0; i < ACCESS_COORDINATE_MAX; i++) {
 		if (cxlr->coord[i].read_bandwidth) {
-			node_update_perf_attrs(nid, &cxlr->coord[i], i);
+			/*
+			 * A CFMWS-only node (not backed by a real SRAT pxm)
+			 * has no HMAT memory_target, so hmat_callback()
+			 * never created the access attributes for it:
+			 * create them here instead of only updating them.
+			 * This is called at most once per node (see
+			 * nodemask_region_seen), so the attributes are not
+			 * created twice.
+			 */
+			if (!acpi_node_backed_by_real_pxm(nid))
+				node_set_perf_attrs(nid, &cxlr->coord[i], i);
+			else
+				node_update_perf_attrs(nid, &cxlr->coord[i], i);
 			cset++;
 		}
 	}
-- 
2.53.0



