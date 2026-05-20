Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CAF36405A;
	Wed, 20 May 2026 17:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299144; cv=none; b=C/IIEXUT4D5aOVM0Sb3se7+fx5qXEdo4Gpkx4Hd55n6VjJoHdCtFlR+PGdfbGfj4XiVkUvfoMOS5asqkPp1noRURjpv5r/EaU6A4VX5fNZlJOOqKnCjTR2zM+KL7tIx6Zov4HQaPtyHe8EldIfOMTLvsjFk0ojHCdUqGQvhst+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299144; c=relaxed/simple;
	bh=GzhWVpzsRHZoWYl23Ox0SApO0NfOW/CKUQT5ptXfrgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bf5IndANS2/5oGAgcytqTBuCXSIh2DmSf4VBf78eCFKD/R/Iaffx2Cdx13bPmcYdTB1/jBh8PoEamaMmfMWIvL+qfVJ4gnUSFd2EhAU/LkR1vuI/maorqWsby2Gh4/xIszRFoLNdBG3cwIPe1pB/oEBZnveMbFnO1owyKGIvHL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UcheYD39; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UcheYD39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D813D1F000E9;
	Wed, 20 May 2026 17:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299143;
	bh=rohUQWr22PbOg4f6MzdAANWEwXs7QqzMx20FtN4o+tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UcheYD39G+ZHqepHRjoAo/IQY+z6Lt3MS9RDoWqNyek57DUSdS4ukCjrPkOfxqZbt
	 CnDWnukVFIr9E34dDsWBIVDYsocteSoV1HwhxwJa4DUu2nTPUjDbCYLlWMzEve2vYX
	 qha62/sCoyGn31xpQltJmjyNyc8OAabXe2gktank=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Dharmender Garg <dharmender.garg@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 680/957] bnge: remove unsupported backing store type
Date: Wed, 20 May 2026 18:19:23 +0200
Message-ID: <20260520162149.284830118@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Vikas Gupta <vikas.gupta@broadcom.com>

[ Upstream commit c6b34add67a5402f53359580956b5c318965a893 ]

The backing store type, BNGE_CTX_MRAV, is not applicable in Thor Ultra
devices. Remove it from the backing store configuration, as the firmware
will not populate entities in this backing store type, due to which the
driver load fails.

Fixes: 29c5b358f385 ("bng_en: Add backing store support")
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Reviewed-by: Dharmender Garg <dharmender.garg@broadcom.com>
Link: https://patch.msgid.link/20260418023438.1597876-3-vikas.gupta@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnge/bnge_rmem.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_rmem.c b/drivers/net/ethernet/broadcom/bnge/bnge_rmem.c
index 79f5ce2e5d083..75d14e52a5bb2 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_rmem.c
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_rmem.c
@@ -325,7 +325,6 @@ int bnge_alloc_ctx_mem(struct bnge_dev *bd)
 	u32 l2_qps, qp1_qps, max_qps;
 	u32 ena, entries_sp, entries;
 	u32 srqs, max_srqs, min;
-	u32 num_mr, num_ah;
 	u32 extra_srqs = 0;
 	u32 extra_qps = 0;
 	u32 fast_qpmd_qps;
@@ -391,21 +390,6 @@ int bnge_alloc_ctx_mem(struct bnge_dev *bd)
 	if (!bnge_is_roce_en(bd))
 		goto skip_rdma;
 
-	ctxm = &ctx->ctx_arr[BNGE_CTX_MRAV];
-	/* 128K extra is needed to accommodate static AH context
-	 * allocation by f/w.
-	 */
-	num_mr = min_t(u32, ctxm->max_entries / 2, 1024 * 256);
-	num_ah = min_t(u32, num_mr, 1024 * 128);
-	ctxm->split_entry_cnt = BNGE_CTX_MRAV_AV_SPLIT_ENTRY + 1;
-	if (!ctxm->mrav_av_entries || ctxm->mrav_av_entries > num_ah)
-		ctxm->mrav_av_entries = num_ah;
-
-	rc = bnge_setup_ctxm_pg_tbls(bd, ctxm, num_mr + num_ah, 2);
-	if (rc)
-		return rc;
-	ena |= FUNC_BACKING_STORE_CFG_REQ_ENABLES_MRAV;
-
 	ctxm = &ctx->ctx_arr[BNGE_CTX_TIM];
 	rc = bnge_setup_ctxm_pg_tbls(bd, ctxm, l2_qps + qp1_qps + extra_qps, 1);
 	if (rc)
-- 
2.53.0



