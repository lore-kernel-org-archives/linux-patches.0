Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB2D3749F5;
	Sat, 12 Sep 2026 07:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199529; cv=none; b=g+JZNoVtv+GX7DAiS3Cg/+aqNrAdsaWL++NNM4hIo5kcWU4xe/cD/7IxFR4vjj+fuQLipOHUmEkpvRP0OgQCMMupr5fh9fomOmiHvnXcFDg/FgLKi7gaLUtfDDec8KMt2RUVRW0IuJDHLcuMRM5HCjBagTNVfxtbFeHTNJ5nFng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199529; c=relaxed/simple;
	bh=HBcqd0CF8qYEY/245Mgo2J5CL2+0lB0yBO+fXO15yoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q98x7v0HEcc7ss8UQb8VooPpmIEywWSHvRC3/iQd5C8iUh3/UT8Vot0Mxyl/wQI8FZ3pzDeZ0xB4Lp3NbPDUIdATrwpamz4dckiWXbuyulN+r16Cz5IDseqXaVl5TstnFG5NnjDum/sL2BWawUPKJHrTX6F2qSUm5RASs9WiHn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZSYtZHmX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZSYtZHmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D531C1F000FF;
	Sat, 12 Sep 2026 07:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199527;
	bh=4UGEjWJXx5Q1FbuBG2AlOS/jyci6sjkplmbxuPmypRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZSYtZHmXl61XPeTzlGRYjWdJKXhYxZMY8FElr1Tw7GViARnYzhYDqo7C2qOhQEQBK
	 p0UkkN85OtwRfHEPfrK9/U5E6AAohNBzyCwMsagatScJO1Jy00YPBsHkSbEDoOaYGU
	 nbo8ES2piaHd7+bc+G6XOyAwFPkfRef3+Fz0jqfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0604/1815] wifi: ath12k: refactor QMI memory assignment
Date: Sat, 12 Sep 2026 08:39:14 +0200
Message-ID: <20260912065703.061600735@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>

[ Upstream commit ecb517f97e629d3b8c360cbb5db3fed4d599ea2e ]

ath12k_qmi_assign_target_mem_chunk() uses a large switch-case to handle
both memory region identification and allocation for each memory request
type, leading to redundant allocation logic.

Refactor this by introducing ath12k_qmi_get_mem_reg_name() to map memory
request types to their corresponding reserved memory region names.

Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01275-QCAHKSWPL_SILICONZ-1

Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Link: https://patch.msgid.link/20260630062048.1615178-3-aaradhana.sahu@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Stable-dep-of: 42399be44b13 ("wifi: ath12k: allocate HOST_DDR and BDF regions after Q6 RO region")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/qmi.c | 157 ++++++++++----------------
 1 file changed, 61 insertions(+), 96 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index 0176d6a4bf8cc..5bf045971c944 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -2726,120 +2726,85 @@ static int ath12k_qmi_alloc_target_mem_chunk(struct ath12k_base *ab)
 	return ret;
 }
 
+static const char *ath12k_qmi_get_mem_reg_name(int mem_type)
+{
+	switch (mem_type) {
+	case HOST_DDR_REGION_TYPE:
+	case BDF_MEM_REGION_TYPE:
+		return "q6-region";
+	case M3_DUMP_REGION_TYPE:
+		return "m3-dump";
+	case CALDB_MEM_REGION_TYPE:
+		return "q6-caldb";
+	case MLO_GLOBAL_MEM_REGION_TYPE:
+		return "mlo-global-mem";
+	default:
+		return NULL;
+	}
+}
+
 static int ath12k_qmi_assign_target_mem_chunk(struct ath12k_base *ab)
 {
 	struct device_node *np = ab->dev->of_node;
+	struct target_mem_chunk *chunk;
 	size_t avail_rmem_size;
 	struct resource res;
+	const char *rname;
 	int i, idx, ret;
 
 	for (i = 0, idx = 0; i < ab->qmi.mem_seg_count; i++) {
-		switch (ab->qmi.target_mem[i].type) {
-		case HOST_DDR_REGION_TYPE:
-			ret = of_reserved_mem_region_to_resource_byname(np, "q6-region",
-									&res);
-			if (ret)
-				goto out;
-
-			avail_rmem_size = resource_size(&res);
-			if (avail_rmem_size < ab->qmi.target_mem[i].size) {
-				ath12k_dbg(ab, ATH12K_DBG_QMI,
-					   "failed to assign mem type %u req size %u avail size %zu\n",
-					   ab->qmi.target_mem[i].type,
-					   ab->qmi.target_mem[i].size,
-					   avail_rmem_size);
-				ret = -EINVAL;
-				goto out;
-			}
-
-			ab->qmi.target_mem[idx].paddr = res.start;
-			ab->qmi.target_mem[idx].v.ioaddr =
-				ioremap(ab->qmi.target_mem[idx].paddr,
-					ab->qmi.target_mem[i].size);
-			if (!ab->qmi.target_mem[idx].v.ioaddr) {
-				ret = -EIO;
-				goto out;
-			}
-			ab->qmi.target_mem[idx].size = ab->qmi.target_mem[i].size;
-			ab->qmi.target_mem[idx].type = ab->qmi.target_mem[i].type;
-			idx++;
-			break;
-		case BDF_MEM_REGION_TYPE:
-			ret = of_reserved_mem_region_to_resource_byname(np, "q6-region",
-									&res);
-			if (ret)
-				goto out;
-
-			avail_rmem_size = resource_size(&res) -
-					  ab->hw_params->bdf_addr_offset;
-			if (avail_rmem_size < ab->qmi.target_mem[i].size) {
-				ath12k_dbg(ab, ATH12K_DBG_QMI,
-					   "failed to assign mem type %u req size %u avail size %zu\n",
-					   ab->qmi.target_mem[i].type,
-					   ab->qmi.target_mem[i].size,
-					   avail_rmem_size);
-				ret = -EINVAL;
-				goto out;
-			}
-			ab->qmi.target_mem[idx].paddr =
-				res.start + ab->hw_params->bdf_addr_offset;
-			ab->qmi.target_mem[idx].v.ioaddr =
-				ioremap(ab->qmi.target_mem[idx].paddr,
-					ab->qmi.target_mem[i].size);
-			if (!ab->qmi.target_mem[idx].v.ioaddr) {
-				ret = -EIO;
-				goto out;
-			}
-			ab->qmi.target_mem[idx].size = ab->qmi.target_mem[i].size;
-			ab->qmi.target_mem[idx].type = ab->qmi.target_mem[i].type;
-			idx++;
-			break;
-		case CALDB_MEM_REGION_TYPE:
-			/* Cold boot calibration is not enabled in Ath12k. Hence,
+		chunk = &ab->qmi.target_mem[i];
+		if (chunk->type == CALDB_MEM_REGION_TYPE) {
+			/*
+			 * Cold boot calibration is not enabled in Ath12k. Hence,
 			 * assign paddr = 0.
 			 * Once cold boot calibration is enabled add support to
 			 * assign reserved memory from DT.
 			 */
 			ab->qmi.target_mem[idx].paddr = 0;
 			ab->qmi.target_mem[idx].v.ioaddr = NULL;
-			ab->qmi.target_mem[idx].size = ab->qmi.target_mem[i].size;
-			ab->qmi.target_mem[idx].type = ab->qmi.target_mem[i].type;
+			ab->qmi.target_mem[idx].size = chunk->size;
+			ab->qmi.target_mem[idx].type = chunk->type;
 			idx++;
-			break;
-		case M3_DUMP_REGION_TYPE:
-			ret = of_reserved_mem_region_to_resource_byname(np, "m3-dump",
-									&res);
-			if (ret)
-				goto out;
-
-			avail_rmem_size = resource_size(&res);
-			if (avail_rmem_size < ab->qmi.target_mem[i].size) {
-				ath12k_dbg(ab, ATH12K_DBG_QMI,
-					   "failed to assign mem type %u req size %u avail size %zu\n",
-					   ab->qmi.target_mem[i].type,
-					   ab->qmi.target_mem[i].size,
-					   avail_rmem_size);
-				ret = -EINVAL;
-				goto out;
-			}
+			continue;
+		}
 
-			ab->qmi.target_mem[idx].paddr = res.start;
-			ab->qmi.target_mem[idx].v.ioaddr =
-				ioremap(ab->qmi.target_mem[idx].paddr,
-					ab->qmi.target_mem[i].size);
-			if (!ab->qmi.target_mem[idx].v.ioaddr) {
-				ret = -EIO;
-				goto out;
-			}
-			ab->qmi.target_mem[idx].size = ab->qmi.target_mem[i].size;
-			ab->qmi.target_mem[idx].type = ab->qmi.target_mem[i].type;
-			idx++;
-			break;
-		default:
+		rname = ath12k_qmi_get_mem_reg_name(chunk->type);
+		if (!rname) {
 			ath12k_warn(ab, "qmi ignore invalid mem req type %u\n",
-				    ab->qmi.target_mem[i].type);
-			break;
+				    chunk->type);
+			continue;
+		}
+
+		ret = of_reserved_mem_region_to_resource_byname(np, rname, &res);
+		if (ret)
+			goto out;
+
+		avail_rmem_size = resource_size(&res);
+		if (chunk->type == BDF_MEM_REGION_TYPE) {
+			avail_rmem_size -= ab->hw_params->bdf_addr_offset;
+			res.start += ab->hw_params->bdf_addr_offset;
 		}
+
+		if (avail_rmem_size < chunk->size) {
+			ath12k_dbg(ab, ATH12K_DBG_QMI,
+				   "failed to assign mem type %u req size %u avail size %zu\n",
+				   chunk->type, chunk->size, avail_rmem_size);
+			ret = -EINVAL;
+			goto out;
+		}
+
+		ab->qmi.target_mem[idx].paddr = res.start;
+		ab->qmi.target_mem[idx].v.ioaddr = ioremap(ab->qmi.target_mem[idx].paddr,
+							   chunk->size);
+		if (!ab->qmi.target_mem[idx].v.ioaddr) {
+			ret = -EIO;
+			goto out;
+		}
+
+		ab->qmi.target_mem[idx].size = chunk->size;
+		ab->qmi.target_mem[idx].type = chunk->type;
+		idx++;
 	}
 	ab->qmi.mem_seg_count = idx;
 
-- 
2.53.0



