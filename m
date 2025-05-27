Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B7E27D766;
	Tue, 27 May 2025 17:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368476; cv=none; b=auJreaAq6t75NQD3LzwemUBVXk0cqan1EwbO0BpEevXqIFo4Z6Rc+2H/HMu3bp2k0XV76zL6RfI3kBb5fZ6VAjrW69eGl1ZDEHrkFxNKei94Xl33ABFUiJV6kZC3A0BzF03D1uMKLcu3zVZ5ns5DtlL12RReGi3S1AGV56M69BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368476; c=relaxed/simple;
	bh=23LimxGTbJySPNKiuaUxLNAUHBSBWEJQoEHteULM1DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGp0I3oHcYT5Z2d4uzgLGthbZbhN4Ub+DMTsBPzqjVXzUSxcByv3sKLKWRwZujzMVPAEqycrT0RFfhvg0q0pH1x7EzOM/RgqmEZNsJwgKY6reVVKsQcYfVJqS1MQHcX8+k1aw64jYh1UyexVI0EvOWZG66WSGbEX2jhjckv9ETg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I18jo7W1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I18jo7W1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBE4C4CEE9;
	Tue, 27 May 2025 17:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368475;
	bh=23LimxGTbJySPNKiuaUxLNAUHBSBWEJQoEHteULM1DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I18jo7W1IKxJ07fuxEUTlLQMBZRQ2HzUQHu5lrw0bKgBlXQ82tvvH36OlJzLOC0d7
	 ULwrfwsQvAY1aJSduUMDyBhUl4C2W/maUBDV+Hk8MQCT12WbOgUhRiZGw6GgGbvKac
	 TJkeryLPaDG0yi20yzsGYRWtA8XKR3tN0BPNZKI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Geetha sowjanya <gakula@marvell.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 719/783] octeontx2-af: Set LMT_ENA bit for APR table entries
Date: Tue, 27 May 2025 18:28:36 +0200
Message-ID: <20250527162542.392820864@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit 0eefa27b493306928d88af6368193b134c98fd64 ]

This patch enables the LMT line for a PF/VF by setting the
LMT_ENA bit in the APR_LMT_MAP_ENTRY_S structure.

Additionally, it simplifies the logic for calculating the
LMTST table index by consistently using the maximum
number of hw supported VFs (i.e., 256).

Fixes: 873a1e3d207a ("octeontx2-af: cn10k: Setting up lmtst map table").
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/20250521060834.19780-2-gakula@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/rvu_cn10k.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
index 7fa98aeb3663c..3838c04b78c22 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
@@ -15,13 +15,17 @@
 #define LMT_TBL_OP_WRITE	1
 #define LMT_MAP_TABLE_SIZE	(128 * 1024)
 #define LMT_MAPTBL_ENTRY_SIZE	16
+#define LMT_MAX_VFS		256
+
+#define LMT_MAP_ENTRY_ENA      BIT_ULL(20)
+#define LMT_MAP_ENTRY_LINES    GENMASK_ULL(18, 16)
 
 /* Function to perform operations (read/write) on lmtst map table */
 static int lmtst_map_table_ops(struct rvu *rvu, u32 index, u64 *val,
 			       int lmt_tbl_op)
 {
 	void __iomem *lmt_map_base;
-	u64 tbl_base;
+	u64 tbl_base, cfg;
 
 	tbl_base = rvu_read64(rvu, BLKADDR_APR, APR_AF_LMT_MAP_BASE);
 
@@ -35,6 +39,13 @@ static int lmtst_map_table_ops(struct rvu *rvu, u32 index, u64 *val,
 		*val = readq(lmt_map_base + index);
 	} else {
 		writeq((*val), (lmt_map_base + index));
+
+		cfg = FIELD_PREP(LMT_MAP_ENTRY_ENA, 0x1);
+		/* 2048 LMTLINES */
+		cfg |= FIELD_PREP(LMT_MAP_ENTRY_LINES, 0x6);
+
+		writeq(cfg, (lmt_map_base + (index + 8)));
+
 		/* Flushing the AP interceptor cache to make APR_LMT_MAP_ENTRY_S
 		 * changes effective. Write 1 for flush and read is being used as a
 		 * barrier and sets up a data dependency. Write to 0 after a write
@@ -52,7 +63,7 @@ static int lmtst_map_table_ops(struct rvu *rvu, u32 index, u64 *val,
 #define LMT_MAP_TBL_W1_OFF  8
 static u32 rvu_get_lmtst_tbl_index(struct rvu *rvu, u16 pcifunc)
 {
-	return ((rvu_get_pf(pcifunc) * rvu->hw->total_vfs) +
+	return ((rvu_get_pf(pcifunc) * LMT_MAX_VFS) +
 		(pcifunc & RVU_PFVF_FUNC_MASK)) * LMT_MAPTBL_ENTRY_SIZE;
 }
 
-- 
2.39.5



