Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED752246BCD;
	Sat, 12 Sep 2026 10:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208026; cv=none; b=fnJq9J9QsHYKFM8o6gqFhqlY7ATqwNldD1mHgTOWNFV/HF2HUNOOVEswVUmcyi2Wu5wxxfjXg6tgl/mgy7ha6n9G4YX9aSttXWqdRACd5kaaHlqjLLdyvinQ+KseEWRFAfgm6e71K1/EGPTDvHgLPKOgciIghY/KQORbxGZyX3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208026; c=relaxed/simple;
	bh=3DHJcbA1IRSbSSdk8TVljB9Jn7/g/hsgdHzwOMVzG/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkUEsEaPP0I2aq8y5rXWKlKsLFKT1DxMDP1be6fQqJtPbKNGYbEc6lb4h1bFh7Od0s5m3a9dZWTN9GyBxY53rKxbfKF7j0rtxBXhbEupO7WBPW/0/1ij47rCa59s2Uo8fkvF7rmSHRSD6vchCc6I62xuNymrtXrZeabykbdkArs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wr5TfUiw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wr5TfUiw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C6B1F000FF;
	Sat, 12 Sep 2026 10:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208024;
	bh=CIvID3JvaNE5MDtbD/Bn7ygxzx6o0m3NUU4op0D1+rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wr5TfUiwCDsUyBpvZ6rPBWxxzrVlgIVwTc4T2Ntg4Z+6FHk90eO9h5opeBF0wtx16
	 Uoh0aaOkfCYOHK77+nRaXoSyAzIIch4iReOQdncK4CFnTIiEyRxNw+BBRTe9q/9FEp
	 GyhOtMaDLbsT63LbWAQ42cMIwGKF3Sl7PS2/bEos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0533/1518] wifi: ath12k: switch to name-based reserved memory lookup
Date: Sat, 12 Sep 2026 08:45:02 +0200
Message-ID: <20260912065635.501810651@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>

[ Upstream commit 3fe59edd1901c040e5b8e9d2428bf9ec6b4ce630 ]

The driver currently retrieves reserved memory regions using index-based
lookup, which depends on the ordering of reserved-memory nodes in the
device tree. Since different platforms define these regions in varying
orders and combinations, this approach is not compatible and can result
in incorrect memory region access.

Switch to looking up memory regions by name instead of index so it does
not depend on node order.

Use names already defined in qcom,ipq5332-wifi.yaml, so there are no
backward compatibility issues.

Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01275-QCAHKSWPL_SILICONZ-1

Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Link: https://patch.msgid.link/20260630062048.1615178-2-aaradhana.sahu@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Stable-dep-of: 42399be44b13 ("wifi: ath12k: allocate HOST_DDR and BDF regions after Q6 RO region")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/ahb.c  | 18 ++++++------
 drivers/net/wireless/ath/ath12k/core.c | 25 -----------------
 drivers/net/wireless/ath/ath12k/core.h |  2 --
 drivers/net/wireless/ath/ath12k/qmi.c  | 38 +++++++++++++-------------
 4 files changed, 29 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/ahb.c b/drivers/net/wireless/ath/ath12k/ahb.c
index b30527c402f6c..af68d5cd6a9d7 100644
--- a/drivers/net/wireless/ath/ath12k/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/ahb.c
@@ -12,6 +12,7 @@
 #include <linux/remoteproc.h>
 #include <linux/soc/qcom/mdt_loader.h>
 #include <linux/soc/qcom/smem_state.h>
+#include <linux/of_reserved_mem.h>
 #include "ahb.h"
 #include "debug.h"
 #include "hif.h"
@@ -345,24 +346,25 @@ static int ath12k_ahb_power_up(struct ath12k_base *ab)
 	char fw2_name[ATH12K_USERPD_FW_NAME_LEN];
 	struct device *dev = ab->dev;
 	const struct firmware *fw, *fw2;
-	struct reserved_mem *rmem = NULL;
 	unsigned long time_left;
 	phys_addr_t mem_phys;
+	struct resource res;
 	void *mem_region;
 	size_t mem_size;
 	u32 pasid;
 	int ret;
 
-	rmem = ath12k_core_get_reserved_mem(ab, 0);
-	if (!rmem)
-		return -ENODEV;
+	ret = of_reserved_mem_region_to_resource_byname(dev->of_node, "q6-region",
+							&res);
+	if (ret)
+		return ret;
 
-	mem_phys = rmem->base;
-	mem_size = rmem->size;
+	mem_phys = res.start;
+	mem_size = resource_size(&res);
 	mem_region = devm_memremap(dev, mem_phys, mem_size, MEMREMAP_WC);
 	if (IS_ERR(mem_region)) {
-		ath12k_err(ab, "unable to map memory region: %pa+%pa\n",
-			   &rmem->base, &rmem->size);
+		ath12k_err(ab, "unable to map memory region: %pa+%zx\n",
+			   &res.start, mem_size);
 		return PTR_ERR(mem_region);
 	}
 
diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index 5fed8d1bcadb3..a02db6fd23549 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -633,31 +633,6 @@ u32 ath12k_core_get_max_peers_per_radio(struct ath12k_base *ab)
 	return ath12k_core_get_max_station_per_radio(ab) + TARGET_NUM_VDEVS(ab);
 }
 
-struct reserved_mem *ath12k_core_get_reserved_mem(struct ath12k_base *ab,
-						  int index)
-{
-	struct device *dev = ab->dev;
-	struct reserved_mem *rmem;
-	struct device_node *node;
-
-	node = of_parse_phandle(dev->of_node, "memory-region", index);
-	if (!node) {
-		ath12k_dbg(ab, ATH12K_DBG_BOOT,
-			   "failed to parse memory-region for index %d\n", index);
-		return NULL;
-	}
-
-	rmem = of_reserved_mem_lookup(node);
-	of_node_put(node);
-	if (!rmem) {
-		ath12k_dbg(ab, ATH12K_DBG_BOOT,
-			   "unable to get memory-region for index %d\n", index);
-		return NULL;
-	}
-
-	return rmem;
-}
-
 static inline
 void ath12k_core_to_group_ref_get(struct ath12k_base *ab)
 {
diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index d7688b383f62c..93cdfcaf95bd2 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -1369,8 +1369,6 @@ void ath12k_fw_stats_init(struct ath12k *ar);
 void ath12k_fw_stats_bcn_free(struct list_head *head);
 void ath12k_fw_stats_free(struct ath12k_fw_stats *stats);
 void ath12k_fw_stats_reset(struct ath12k *ar);
-struct reserved_mem *ath12k_core_get_reserved_mem(struct ath12k_base *ab,
-						  int index);
 enum ath12k_qmi_mem_mode ath12k_core_get_memory_mode(struct ath12k_base *ab);
 
 static inline const char *ath12k_scan_state_str(enum ath12k_scan_state state)
diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index 8de9aee2498ec..bb90b7c360cf8 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -13,6 +13,7 @@
 #include <linux/firmware.h>
 #include <linux/of_address.h>
 #include <linux/ioport.h>
+#include <linux/of_reserved_mem.h>
 
 #define SLEEP_CLOCK_SELECT_INTERNAL_BIT	0x02
 #define HOST_CSTATE_BIT			0x04
@@ -2685,20 +2686,20 @@ static int ath12k_qmi_alloc_target_mem_chunk(struct ath12k_base *ab)
 
 static int ath12k_qmi_assign_target_mem_chunk(struct ath12k_base *ab)
 {
-	struct reserved_mem *rmem;
+	struct device_node *np = ab->dev->of_node;
 	size_t avail_rmem_size;
+	struct resource res;
 	int i, idx, ret;
 
 	for (i = 0, idx = 0; i < ab->qmi.mem_seg_count; i++) {
 		switch (ab->qmi.target_mem[i].type) {
 		case HOST_DDR_REGION_TYPE:
-			rmem = ath12k_core_get_reserved_mem(ab, 0);
-			if (!rmem) {
-				ret = -ENODEV;
+			ret = of_reserved_mem_region_to_resource_byname(np, "q6-region",
+									&res);
+			if (ret)
 				goto out;
-			}
 
-			avail_rmem_size = rmem->size;
+			avail_rmem_size = resource_size(&res);
 			if (avail_rmem_size < ab->qmi.target_mem[i].size) {
 				ath12k_dbg(ab, ATH12K_DBG_QMI,
 					   "failed to assign mem type %u req size %u avail size %zu\n",
@@ -2709,7 +2710,7 @@ static int ath12k_qmi_assign_target_mem_chunk(struct ath12k_base *ab)
 				goto out;
 			}
 
-			ab->qmi.target_mem[idx].paddr = rmem->base;
+			ab->qmi.target_mem[idx].paddr = res.start;
 			ab->qmi.target_mem[idx].v.ioaddr =
 				ioremap(ab->qmi.target_mem[idx].paddr,
 					ab->qmi.target_mem[i].size);
@@ -2722,13 +2723,13 @@ static int ath12k_qmi_assign_target_mem_chunk(struct ath12k_base *ab)
 			idx++;
 			break;
 		case BDF_MEM_REGION_TYPE:
-			rmem = ath12k_core_get_reserved_mem(ab, 0);
-			if (!rmem) {
-				ret = -ENODEV;
+			ret = of_reserved_mem_region_to_resource_byname(np, "q6-region",
+									&res);
+			if (ret)
 				goto out;
-			}
 
-			avail_rmem_size = rmem->size - ab->hw_params->bdf_addr_offset;
+			avail_rmem_size = resource_size(&res) -
+					  ab->hw_params->bdf_addr_offset;
 			if (avail_rmem_size < ab->qmi.target_mem[i].size) {
 				ath12k_dbg(ab, ATH12K_DBG_QMI,
 					   "failed to assign mem type %u req size %u avail size %zu\n",
@@ -2739,7 +2740,7 @@ static int ath12k_qmi_assign_target_mem_chunk(struct ath12k_base *ab)
 				goto out;
 			}
 			ab->qmi.target_mem[idx].paddr =
-				rmem->base + ab->hw_params->bdf_addr_offset;
+				res.start + ab->hw_params->bdf_addr_offset;
 			ab->qmi.target_mem[idx].v.ioaddr =
 				ioremap(ab->qmi.target_mem[idx].paddr,
 					ab->qmi.target_mem[i].size);
@@ -2764,13 +2765,12 @@ static int ath12k_qmi_assign_target_mem_chunk(struct ath12k_base *ab)
 			idx++;
 			break;
 		case M3_DUMP_REGION_TYPE:
-			rmem = ath12k_core_get_reserved_mem(ab, 1);
-			if (!rmem) {
-				ret = -EINVAL;
+			ret = of_reserved_mem_region_to_resource_byname(np, "m3-dump",
+									&res);
+			if (ret)
 				goto out;
-			}
 
-			avail_rmem_size = rmem->size;
+			avail_rmem_size = resource_size(&res);
 			if (avail_rmem_size < ab->qmi.target_mem[i].size) {
 				ath12k_dbg(ab, ATH12K_DBG_QMI,
 					   "failed to assign mem type %u req size %u avail size %zu\n",
@@ -2781,7 +2781,7 @@ static int ath12k_qmi_assign_target_mem_chunk(struct ath12k_base *ab)
 				goto out;
 			}
 
-			ab->qmi.target_mem[idx].paddr = rmem->base;
+			ab->qmi.target_mem[idx].paddr = res.start;
 			ab->qmi.target_mem[idx].v.ioaddr =
 				ioremap(ab->qmi.target_mem[idx].paddr,
 					ab->qmi.target_mem[i].size);
-- 
2.53.0



