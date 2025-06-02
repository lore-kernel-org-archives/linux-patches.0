Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251BE4A1E;
	Mon,  2 Jun 2025 15:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877343; cv=none; b=A7UjdROOAFhNXRi1wVYf0qBzGtDmyqP6FksCONUIEZ3I60gSh4NGixbU7eosyXB0LFKYLa98BOYZe13+PZ9FzMaP4UgnUXj8rAnc+7zKrr1HWhlt+HzuoZATyRbgfzJWFnDO85sz/DZ75wLzT8+I3IWAc8WxKAqSHsnkdGvP9wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877343; c=relaxed/simple;
	bh=zkorsWqUaA9YF7LxMaKWjw7ZLfHhigxdLq4YGbPD9Us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JB0x5qeWkxBPm2eqnBXfGpVwjqFQVub6cQGAyWaXkpxmgBRBpvm4Em5Ql5QGRtwGZvSb68lev7LOFEdrmLOdw55st4WSPfUdt892MuVLDwkR/ewB0kRZz7EH2Ef/oKPLuS14nDlS9OcwAUUMJv9dRP9PZnzBU/oXOz47GHcG7u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tY1n6NQ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tY1n6NQ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DA0C4CEEB;
	Mon,  2 Jun 2025 15:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877343;
	bh=zkorsWqUaA9YF7LxMaKWjw7ZLfHhigxdLq4YGbPD9Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tY1n6NQ4OOY7cmHqrdCKmn5QR8H2WNih1gr3HJaxHHE70XRiezmUNv1C+Nvo45Tdf
	 c8B3G/bBdiPaC3HV6XuaheoXs3EslhiVIyNmJL/Nd531oW2IULkPElC7nqqEddLaFJ
	 OKlp1OtLKl3F+N87PRrosiARh7gFUlj5PGABFxwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Geetha sowjanya <gakula@marvell.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 248/325] octeontx2-af: Set LMT_ENA bit for APR table entries
Date: Mon,  2 Jun 2025 15:48:44 +0200
Message-ID: <20250602134329.859113975@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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
index f9faa5b23bb9d..6ec0609074dca 100644
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



