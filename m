Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7BF19DF75;
	Tue, 16 Jul 2024 15:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145452; cv=none; b=DJ6OSf6OCG+/KNhkhuxV3vdPMDkkXekcXcewkZ9DPLJxZFZPR9alS/Z3V/QBMEAjkqUjrvFObnwsO61+salQeQs4tcUqXF5AIjoDy1BIXuQOvHRxibKKu0NHyx+sueFsuNemCJIv7KA947aH8zB1igcu5rgoQdZi2W/JYa1FRHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145452; c=relaxed/simple;
	bh=NdCbljlbaCnCqvi0cOEpqt315PkUxxeRJZk79ofACKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VY8GWqAk2EoZbLrwv00MBFxPZ490PU3UVAUE5CcSxnG/67ccDz+OG1iGXjqCQ3exMax9gfH2ru/LoqzoHPThrg9Gqb9BP4MrqugDQ+HSZLzSOLkSpZIdXyEnv+9MlmFZSWf9I8q51gxAZVOUgzpO2wirJtrDG+FS6EYb5ldAD44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snR8Qjt9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snR8Qjt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947CEC4AF0D;
	Tue, 16 Jul 2024 15:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145452;
	bh=NdCbljlbaCnCqvi0cOEpqt315PkUxxeRJZk79ofACKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=snR8Qjt9N/eSNfA1iBUqLgVpsR2Bwnyk7A7c/jjjNOiwIitVy7244etbT5g6jVjjG
	 1PsotAyJ2RPussgwoN5WfoAt6ZsbRSEJdKQ8NbAZlhp8naigAhRkGt8porP7VmrxrM
	 HsYyb3MMIjzqyOWEuszYcS9Az6ImOY3580Ws351s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srujana Challa <schalla@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 38/96] octeontx2-af: update cpt lf alloc mailbox
Date: Tue, 16 Jul 2024 17:31:49 +0200
Message-ID: <20240716152747.974729001@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Srujana Challa <schalla@marvell.com>

[ Upstream commit c0688ec002a451d04a51d43b849765c5ce6cb36f ]

The CN10K CPT coprocessor contains a context processor
to accelerate updates to the IPsec security association
contexts. The context processor contains a context cache.
This patch updates CPT LF ALLOC mailbox to config ctx_ilen
requested by VFs. CPT_LF_ALLOC:ctx_ilen is the size of
initial context fetch.

Signed-off-by: Srujana Challa <schalla@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 845fe19139ab ("octeontx2-af: fix a issue with cpt_lf_alloc mailbox")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h    |  2 ++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c | 10 +++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index be70269e91684..7c3d7e61afeb3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1628,6 +1628,8 @@ struct cpt_lf_alloc_req_msg {
 	u16 sso_pf_func;
 	u16 eng_grpmsk;
 	int blkaddr;
+	u8 ctx_ilen_valid : 1;
+	u8 ctx_ilen : 7;
 };
 
 #define CPT_INLINE_INBOUND      0
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index 63a52cc8592a0..b226a4d376aab 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -17,7 +17,7 @@
 #define	PCI_DEVID_OTX2_CPT10K_PF 0xA0F2
 
 /* Length of initial context fetch in 128 byte words */
-#define CPT_CTX_ILEN    2ULL
+#define CPT_CTX_ILEN    1ULL
 
 #define cpt_get_eng_sts(e_min, e_max, rsp, etype)                   \
 ({                                                                  \
@@ -429,8 +429,12 @@ int rvu_mbox_handler_cpt_lf_alloc(struct rvu *rvu,
 
 		/* Set CPT LF group and priority */
 		val = (u64)req->eng_grpmsk << 48 | 1;
-		if (!is_rvu_otx2(rvu))
-			val |= (CPT_CTX_ILEN << 17);
+		if (!is_rvu_otx2(rvu)) {
+			if (req->ctx_ilen_valid)
+				val |= (req->ctx_ilen << 17);
+			else
+				val |= (CPT_CTX_ILEN << 17);
+		}
 
 		rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf), val);
 
-- 
2.43.0



