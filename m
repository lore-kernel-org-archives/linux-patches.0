Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023879;
	b=1ODiZXPTXZlg7N1YcBdmzmQIdn5lw4WAdGhblpcMBOPRT/EkhmOVxdWlNZ18YAixPSPS
	 1CMzijpHSjxikPYHa11ne5x59VRWqbNaomZUrcxcraNtds1sL+/oWnBYhjjObNeBz5bZe
	 M4zp0l+Ewvs5KstAR5u/2ZezymwUeAk2nGYqbONwOsr+GZKgqtK9LuGOc8DvMiKMqmk4a
	 uHAtcwx1yAX37tyQfwN+qDIwtiXLAi3qCjGakSOIZGL7bQFFZ4tHZSj+a4ykpC14PqduO
	 6lLV5lx7tcDm2sefoAdtalH1BTtJBZ77/i3L5LYW4BenlF2IBtQjHsFK0c5ZPQOAwHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023879;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cg7BN0z0HqOu3JZX9mg+/0eC+ccHDqyYD6gYd6dV0PU=;
	b=WTwIajERqvIr3PvK3iHgWpTjKWs9BpfSU4WvhYwoIYsNPPB3g5ZlbAyvEjDVmgSlvLnE
	 4djRFG/SndPVcUKJobSovwQG/yNqWb4z6vmzl1odO4FGOB941kwwwo8HPskcAH/FNuwC4
	 SksCf5A2uy7be2xu5H338dQcrtyf1qUwNF8eSi567nyU+6QV/zYtkSkGSD8MU7WTfbB+S
	 I70hUAsw9WjWelWjPliaPSgRnEqbKiDHGUE4b51ju4ppVCyNbc8MdtzHqBH9AQFOpz1Pi
	 +Fkk6dGC8jUP8FoIbiGUoBCaa5FXIZzailzWiX32VMO3jOn8th6IZjZvW2lOmkqt6Rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i8QfGMfd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E03606A31C;
	Wed, 18 Nov 2026 17:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i8QfGMfd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BDC1F000C4;
	Wed, 18 Nov 2026 17:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023879;
	bh=Cg7BN0z0HqOu3JZX9mg+/0eC+ccHDqyYD6gYd6dV0PU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i8QfGMfduB3BnTbNBwbUHM35M3Ds20FEHcUbk+1o5y9KDtc4MuvDL6ckF6lqjHEZk
	 J3riIXFoHQX1ez+Psl3bt40BobKoSKTJ+S7NFhew6Tq4PfnPPc5tX90qcKV8KSGxcJ
	 haUhW9deHvGaTPwPsuzUDc5rmc3IV3TaJHkbtZFE=
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
Subject: [PATCH 6.18 0527/2151] cxl/region: Create node access attributes for CFMWS-only NUMA nodes
Date: Wed, 18 Nov 2026 15:37:42 +0100
Message-ID: <20261118150141.224304737@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 148168319a266..46fc6644c8a72 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright(c) 2022 Intel Corporation. All rights reserved. */
+#include <linux/acpi.h>
 #include <linux/memregion.h>
 #include <linux/genalloc.h>
 #include <linux/debugfs.h>
@@ -2450,7 +2451,19 @@ static bool cxl_region_update_coordinates(struct cxl_region *cxlr, int nid)
 
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



