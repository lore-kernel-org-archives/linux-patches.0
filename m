Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E06417BED0;
	Sat, 17 Oct 2026 16:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253998; cv=none; b=RUkSHPAsghkzQwrDrF8NtS2HMdDlWyDhpo9LEUa6lJVdgR6z2BRg+ptyI54K820CIREJ4ecXnIaoPJsX+Dew6K6LNAjpAPu6kJa4CzQ49nOJ1EgqqZyxUjs9qU9spYr+BUV8f49ga+9GfLSW5GAp4NkIGDZcfIVc/CJ1Vk2MNFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253998; c=relaxed/simple;
	bh=UNYoyOW7LSaljAeBlXb/NUXb1cycaO+8y3Yt4hbB0fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uh5Fsh7MCheiPlOICeT6YRLlzdglqXaRvd7BUgiRrudL6fXcDdsLKcPugT4SxYV8JcAYeOKJsiSdRYfPdXN2/UyCWcRCyvyUMr+XM/wJ9r+H1bFeDijUdZLRfY0uveXPuHysNRZ5zeeIh+CVk+TsCAYskJGiNGXv80Tkt8DQpEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BD4hmNMG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BD4hmNMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5C01F000C7;
	Sat, 17 Oct 2026 16:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253997;
	bh=T0edXhCVSENpwOi+JYQJVRXXoneqDO0y1AOgEsR94Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BD4hmNMG7EYtyNwFSpfZ+Zd0I3+c2h8BWzegJxUATeeVUPbHZgyzOGSexRRCp9uky
	 mWBRldUvoG2z3eV60n1Q2pW6W4gFKiCA1OzQv2Mb6BHyi9wInQxuNoUtQ00hubI1DZ
	 8rft022Ibu1spaj9wPvQ1QnephumGNgMIb/rsYm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daisuke Matsuda <matsuda-daisuke@fujitsu.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 303/869] RDMA/rxe: Move some code to rxe_loc.h in preparation for ODP
Date: Sat, 17 Oct 2026 17:52:24 +0200
Message-ID: <20261017160044.844068751@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>

[ Upstream commit 7f880725078d2314f6761f24c2a244e4a68c69c2 ]

rxe_mr_init() and resp_states are going to be used in rxe_odp.c, which is
to be created in the subsequent patch.

Link: https://patch.msgid.link/r/20241220100936.2193541-2-matsuda-daisuke@fujitsu.com
Signed-off-by: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 12985e5915a0 ("RDMA/rxe: Fix iova-to-va conversion for MR page sizes != PAGE_SIZE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe.h       | 37 ---------------------------
 drivers/infiniband/sw/rxe/rxe_loc.h   |  1 +
 drivers/infiniband/sw/rxe/rxe_mr.c    |  2 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h | 37 +++++++++++++++++++++++++++
 4 files changed, 39 insertions(+), 38 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe.h b/drivers/infiniband/sw/rxe/rxe.h
index fe7f970667325..120e114c2e1ee 100644
--- a/drivers/infiniband/sw/rxe/rxe.h
+++ b/drivers/infiniband/sw/rxe/rxe.h
@@ -100,43 +100,6 @@
 #define rxe_info_mw(mw, fmt, ...) ibdev_info_ratelimited((mw)->ibmw.device, \
 		"mw#%d %s:  " fmt, (mw)->elem.index, __func__, ##__VA_ARGS__)
 
-/* responder states */
-enum resp_states {
-	RESPST_NONE,
-	RESPST_GET_REQ,
-	RESPST_CHK_PSN,
-	RESPST_CHK_OP_SEQ,
-	RESPST_CHK_OP_VALID,
-	RESPST_CHK_RESOURCE,
-	RESPST_CHK_LENGTH,
-	RESPST_CHK_RKEY,
-	RESPST_EXECUTE,
-	RESPST_READ_REPLY,
-	RESPST_ATOMIC_REPLY,
-	RESPST_ATOMIC_WRITE_REPLY,
-	RESPST_PROCESS_FLUSH,
-	RESPST_COMPLETE,
-	RESPST_ACKNOWLEDGE,
-	RESPST_CLEANUP,
-	RESPST_DUPLICATE_REQUEST,
-	RESPST_ERR_MALFORMED_WQE,
-	RESPST_ERR_UNSUPPORTED_OPCODE,
-	RESPST_ERR_MISALIGNED_ATOMIC,
-	RESPST_ERR_PSN_OUT_OF_SEQ,
-	RESPST_ERR_MISSING_OPCODE_FIRST,
-	RESPST_ERR_MISSING_OPCODE_LAST_C,
-	RESPST_ERR_MISSING_OPCODE_LAST_D1E,
-	RESPST_ERR_TOO_MANY_RDMA_ATM_REQ,
-	RESPST_ERR_RNR,
-	RESPST_ERR_RKEY_VIOLATION,
-	RESPST_ERR_INVALIDATE_RKEY,
-	RESPST_ERR_LENGTH,
-	RESPST_ERR_CQ_OVERFLOW,
-	RESPST_ERROR,
-	RESPST_DONE,
-	RESPST_EXIT,
-};
-
 void rxe_set_mtu(struct rxe_dev *rxe, unsigned int dev_mtu);
 
 int rxe_add(struct rxe_dev *rxe, unsigned int mtu, const char *ibdev_name,
diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index ded46119151bb..1c78b9d36da4c 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -58,6 +58,7 @@ int rxe_mmap(struct ib_ucontext *context, struct vm_area_struct *vma);
 
 /* rxe_mr.c */
 u8 rxe_get_next_key(u32 last_key);
+void rxe_mr_init(int access, struct rxe_mr *mr);
 void rxe_mr_init_dma(int access, struct rxe_mr *mr);
 int rxe_mr_init_user(struct rxe_dev *rxe, u64 start, u64 length,
 		     int access, struct rxe_mr *mr);
diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 83e325b76f67d..ab1635d53da3d 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -46,7 +46,7 @@ int mr_check_range(struct rxe_mr *mr, u64 iova, size_t length)
 	}
 }
 
-static void rxe_mr_init(int access, struct rxe_mr *mr)
+void rxe_mr_init(int access, struct rxe_mr *mr)
 {
 	u32 key = mr->elem.index << 8 | rxe_get_next_key(-1);
 
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index 6573ceec0ef58..f7a226155e359 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -126,6 +126,43 @@ struct rxe_comp_info {
 	u32			rnr_retry;
 };
 
+/* responder states */
+enum resp_states {
+	RESPST_NONE,
+	RESPST_GET_REQ,
+	RESPST_CHK_PSN,
+	RESPST_CHK_OP_SEQ,
+	RESPST_CHK_OP_VALID,
+	RESPST_CHK_RESOURCE,
+	RESPST_CHK_LENGTH,
+	RESPST_CHK_RKEY,
+	RESPST_EXECUTE,
+	RESPST_READ_REPLY,
+	RESPST_ATOMIC_REPLY,
+	RESPST_ATOMIC_WRITE_REPLY,
+	RESPST_PROCESS_FLUSH,
+	RESPST_COMPLETE,
+	RESPST_ACKNOWLEDGE,
+	RESPST_CLEANUP,
+	RESPST_DUPLICATE_REQUEST,
+	RESPST_ERR_MALFORMED_WQE,
+	RESPST_ERR_UNSUPPORTED_OPCODE,
+	RESPST_ERR_MISALIGNED_ATOMIC,
+	RESPST_ERR_PSN_OUT_OF_SEQ,
+	RESPST_ERR_MISSING_OPCODE_FIRST,
+	RESPST_ERR_MISSING_OPCODE_LAST_C,
+	RESPST_ERR_MISSING_OPCODE_LAST_D1E,
+	RESPST_ERR_TOO_MANY_RDMA_ATM_REQ,
+	RESPST_ERR_RNR,
+	RESPST_ERR_RKEY_VIOLATION,
+	RESPST_ERR_INVALIDATE_RKEY,
+	RESPST_ERR_LENGTH,
+	RESPST_ERR_CQ_OVERFLOW,
+	RESPST_ERROR,
+	RESPST_DONE,
+	RESPST_EXIT,
+};
+
 enum rdatm_res_state {
 	rdatm_res_state_next,
 	rdatm_res_state_new,
-- 
2.53.0



