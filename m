Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023078;
	b=5M3K7IW3NaZsRdKrT3FZCaN9zS5po771YfHZoId67pbLMg7CRvLxw0Nm0Iu7+97QIWB9
	 5Jf6TbT4Qry69DvJOFl8qcSRrW0ALFp94GRuh9GMm/x/fFL0O/G0TJ+F8ZsBobi0zEpWc
	 15K7CKlx/KTCZwmjObxU8EzF6cn1R8tCQGSlf/x3LMiarsh1gzr6tEjGhGS5sNwWRcliu
	 Ku6TDAgmKyJRW38xgJeZwcYCv4E1c8Fyn0oA+aumrVWDnlCp5QAX5E1HwHUpRQ72K0SHM
	 jQNru7L4GcWAPTv8b+9CMPrLIA+1wprxCLWJEaOG5mrnAg9GjlLPOnqpvSMaNRxOxiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023078;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H/OyV4Geq5VYFmaGvu6a4eeuJHyGr3Es15bRfJSDR4c=;
	b=1UMLN/J0jPq5d5YqRFB7ue1aYza24Pzfvziut9Bj+7F7NQo98UzpwxcYtwk1tSiRo0st
	 YyaCINB+DRSu8P6Yqh3e+GuQa8sDN2U/6T4YJ2HOSEgWZ84ZKIpOTkZ6R4EoOjE5NgoQ+
	 6rodJjp2FLxwHdhNGzNdIdLyshJ6Nsh3uMOD+4v8e56v3X6tpNcaCgFMhzBeMDn3kM3UX
	 tGybd2BUzeWNtrHbwDH8juFUvdRVI6EbhFr8SkOkHdbTedw/VNrIKL/IZVexxcxP/YQB0
	 Y8KVWsZQ5d+hUp3GUFaR5tvYP6tDXM78cwxvkQbTYjprPYrqEFExifjjEglKhrZWmUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z4p4O6E2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1E2606A320;
	Wed, 18 Nov 2026 17:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z4p4O6E2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258BC1F000C4;
	Wed, 18 Nov 2026 17:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023078;
	bh=H/OyV4Geq5VYFmaGvu6a4eeuJHyGr3Es15bRfJSDR4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z4p4O6E2eaKjnnpj04znKjUKu/rlOdMi3/58A3f0d2IGY3L9Gz2e+XGhWLIzIyoQA
	 LE5WyWHTdd06wiLmeUiZ8qmSxYGDZ04QSXB7tPrtxrLoNHZSAcwoPs6+MBUCEAcFrv
	 i0XqpEvGmPO+cFVRgNqXOCuIvemzZIaDatRbce8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Richard Cheng <icheng@nvidia.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0238/2151] cxl/features: Reject feature offset that overflows 16-bit field
Date: Wed, 18 Nov 2026 15:32:53 +0100
Message-ID: <20261118150130.451101090@linuxfoundation.org>
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

From: Richard Cheng <icheng@nvidia.com>

[ Upstream commit 3eb3376944ace574bf7ae299e944a2a3c30c93ba ]

cxl_get_feature() and cxl_set_feature() build each mailbox command's
offset from the starting offset plus the amount of data already
transferred, then store it in a 16-bit field. A user-controlled fwctl
offset and transfer size can exceed the feature extent, allowing a later
offset to be truncated by cpu_to_le16() and target the wrong feature
data.

Reject requests whose transfer size exceeds the remaining 16-bit feature
range. Express the check as "size > U16_MAX - offset" so the validation
itself cannot wrap on 32-bit systems.

Change cxl_get_feature() to return ssize_t so invalid input and mailbox
failures are reported as negative errno rather than being conflated with
a zero-byte result. Update the EDAC callers to handle negative results.
Keep fwctl behavior unchanged by translating helper failures to the same
header-only RPC response carrying the CXL mailbox return code.

Fixes: 5e5ac21f629d ("cxl/mbox: Add GET_FEATURE mailbox command")
Fixes: 14d502cc2718 ("cxl/mbox: Add SET_FEATURE mailbox command")
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Richard Cheng <icheng@nvidia.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260902053839.25595-2-icheng@nvidia.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/core.h     |  8 ++++----
 drivers/cxl/core/edac.c     | 20 +++++++++++++++-----
 drivers/cxl/core/features.c | 28 ++++++++++++++++++----------
 3 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 724361195057e..c38cd0fdb04c7 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -182,10 +182,10 @@ int cxl_port_get_possible_dports(struct cxl_port *port);
 #ifdef CONFIG_CXL_FEATURES
 struct cxl_feat_entry *
 cxl_feature_info(struct cxl_features_state *cxlfs, const uuid_t *uuid);
-size_t cxl_get_feature(struct cxl_mailbox *cxl_mbox, const uuid_t *feat_uuid,
-		       enum cxl_get_feat_selection selection,
-		       void *feat_out, size_t feat_out_size, u16 offset,
-		       u16 *return_code);
+ssize_t cxl_get_feature(struct cxl_mailbox *cxl_mbox, const uuid_t *feat_uuid,
+			enum cxl_get_feat_selection selection,
+			void *feat_out, size_t feat_out_size, u16 offset,
+			u16 *return_code);
 int cxl_set_feature(struct cxl_mailbox *cxl_mbox, const uuid_t *feat_uuid,
 		    u8 feat_version, const void *feat_data,
 		    size_t feat_data_size, u32 feat_flag, u16 offset,
diff --git a/drivers/cxl/core/edac.c b/drivers/cxl/core/edac.c
index 81160260e26b7..9fa67b1a62567 100644
--- a/drivers/cxl/core/edac.c
+++ b/drivers/cxl/core/edac.c
@@ -78,7 +78,7 @@ static int cxl_mem_scrub_get_attrbs(struct cxl_mailbox *cxl_mbox, u8 *cap,
 				    u16 *cycle, u8 *flags, u8 *min_cycle)
 {
 	size_t rd_data_size = sizeof(struct cxl_scrub_rd_attrbs);
-	size_t data_size;
+	ssize_t data_size;
 	struct cxl_scrub_rd_attrbs *rd_attrbs __free(kfree) =
 		kzalloc(rd_data_size, GFP_KERNEL);
 	if (!rd_attrbs)
@@ -87,6 +87,8 @@ static int cxl_mem_scrub_get_attrbs(struct cxl_mailbox *cxl_mbox, u8 *cap,
 	data_size = cxl_get_feature(cxl_mbox, &CXL_FEAT_PATROL_SCRUB_UUID,
 				    CXL_GET_FEAT_SEL_CURRENT_VALUE, rd_attrbs,
 				    rd_data_size, 0, NULL);
+	if (data_size < 0)
+		return data_size;
 	if (!data_size)
 		return -EIO;
 
@@ -551,7 +553,7 @@ static int cxl_mem_ecs_get_attrbs(struct device *dev,
 	struct cxl_mailbox *cxl_mbox = &cxlmd->cxlds->cxl_mbox;
 	struct cxl_ecs_fru_rd_attrbs *fru_rd_attrbs;
 	size_t rd_data_size;
-	size_t data_size;
+	ssize_t data_size;
 
 	rd_data_size = cxl_ecs_ctx->get_feat_size;
 
@@ -563,6 +565,8 @@ static int cxl_mem_ecs_get_attrbs(struct device *dev,
 	data_size = cxl_get_feature(cxl_mbox, &CXL_FEAT_ECS_UUID,
 				    CXL_GET_FEAT_SEL_CURRENT_VALUE, rd_attrbs,
 				    rd_data_size, 0, NULL);
+	if (data_size < 0)
+		return data_size;
 	if (!data_size)
 		return -EIO;
 
@@ -583,7 +587,7 @@ static int cxl_mem_ecs_set_attrbs(struct device *dev,
 	struct cxl_ecs_fru_wr_attrbs *fru_wr_attrbs;
 	size_t rd_data_size, wr_data_size;
 	u16 num_media_frus, count;
-	size_t data_size;
+	ssize_t data_size;
 
 	num_media_frus = cxl_ecs_ctx->num_media_frus;
 	rd_data_size = cxl_ecs_ctx->get_feat_size;
@@ -596,6 +600,8 @@ static int cxl_mem_ecs_set_attrbs(struct device *dev,
 	data_size = cxl_get_feature(cxl_mbox, &CXL_FEAT_ECS_UUID,
 				    CXL_GET_FEAT_SEL_CURRENT_VALUE, rd_attrbs,
 				    rd_data_size, 0, NULL);
+	if (data_size < 0)
+		return data_size;
 	if (!data_size)
 		return -EIO;
 
@@ -1264,7 +1270,7 @@ cxl_mem_sparing_get_attrbs(struct cxl_mem_sparing_context *cxl_sparing_ctx)
 	struct cxl_memdev *cxlmd = cxl_sparing_ctx->cxlmd;
 	struct cxl_mailbox *cxl_mbox = &cxlmd->cxlds->cxl_mbox;
 	u16 restriction_flags;
-	size_t data_size;
+	ssize_t data_size;
 	u16 return_code;
 	struct cxl_memdev_sparing_rd_attrbs *rd_attrbs __free(kfree) =
 		kzalloc(rd_data_size, GFP_KERNEL);
@@ -1274,6 +1280,8 @@ cxl_mem_sparing_get_attrbs(struct cxl_mem_sparing_context *cxl_sparing_ctx)
 	data_size = cxl_get_feature(cxl_mbox, &cxl_sparing_ctx->repair_uuid,
 				    CXL_GET_FEAT_SEL_CURRENT_VALUE, rd_attrbs,
 				    rd_data_size, 0, &return_code);
+	if (data_size < 0)
+		return data_size;
 	if (!data_size)
 		return -EIO;
 
@@ -1750,7 +1758,7 @@ static int cxl_mem_ppr_get_attrbs(struct cxl_ppr_context *cxl_ppr_ctx)
 	struct cxl_memdev *cxlmd = cxl_ppr_ctx->cxlmd;
 	struct cxl_mailbox *cxl_mbox = &cxlmd->cxlds->cxl_mbox;
 	u16 restriction_flags;
-	size_t data_size;
+	ssize_t data_size;
 	u16 return_code;
 
 	struct cxl_memdev_ppr_rd_attrbs *rd_attrbs __free(kfree) =
@@ -1761,6 +1769,8 @@ static int cxl_mem_ppr_get_attrbs(struct cxl_ppr_context *cxl_ppr_ctx)
 	data_size = cxl_get_feature(cxl_mbox, &cxl_ppr_ctx->repair_uuid,
 				    CXL_GET_FEAT_SEL_CURRENT_VALUE, rd_attrbs,
 				    rd_data_size, 0, &return_code);
+	if (data_size < 0)
+		return data_size;
 	if (!data_size)
 		return -EIO;
 
diff --git a/drivers/cxl/core/features.c b/drivers/cxl/core/features.c
index 0ea5a31275d38..a7e73d67f5e1a 100644
--- a/drivers/cxl/core/features.c
+++ b/drivers/cxl/core/features.c
@@ -220,10 +220,10 @@ int devm_cxl_setup_features(struct cxl_dev_state *cxlds)
 }
 EXPORT_SYMBOL_NS_GPL(devm_cxl_setup_features, "CXL");
 
-size_t cxl_get_feature(struct cxl_mailbox *cxl_mbox, const uuid_t *feat_uuid,
-		       enum cxl_get_feat_selection selection,
-		       void *feat_out, size_t feat_out_size, u16 offset,
-		       u16 *return_code)
+ssize_t cxl_get_feature(struct cxl_mailbox *cxl_mbox, const uuid_t *feat_uuid,
+			enum cxl_get_feat_selection selection,
+			void *feat_out, size_t feat_out_size, u16 offset,
+			u16 *return_code)
 {
 	size_t data_to_rd_size;
 	struct cxl_mbox_get_feat_in pi;
@@ -235,7 +235,10 @@ size_t cxl_get_feature(struct cxl_mailbox *cxl_mbox, const uuid_t *feat_uuid,
 		*return_code = CXL_MBOX_CMD_RC_INPUT;
 
 	if (!feat_out || !feat_out_size)
-		return 0;
+		return -EINVAL;
+
+	if (feat_out_size > U16_MAX - offset)
+		return -EINVAL;
 
 	uuid_copy(&pi.uuid, feat_uuid);
 	pi.selection = selection;
@@ -259,7 +262,7 @@ size_t cxl_get_feature(struct cxl_mailbox *cxl_mbox, const uuid_t *feat_uuid,
 		if (rc < 0 || !mbox_cmd.size_out) {
 			if (return_code)
 				*return_code = mbox_cmd.return_code;
-			return 0;
+			return rc < 0 ? rc : -EIO;
 		}
 		data_rcvd_size += mbox_cmd.size_out;
 	} while (data_rcvd_size < feat_out_size);
@@ -288,6 +291,9 @@ int cxl_set_feature(struct cxl_mailbox *cxl_mbox,
 	if (return_code)
 		*return_code = CXL_MBOX_CMD_RC_INPUT;
 
+	if (feat_data_size > U16_MAX - offset)
+		return -EINVAL;
+
 	struct cxl_mbox_set_feat_in *pi __free(kfree) =
 			kzalloc(cxl_mbox->payload_size, GFP_KERNEL);
 	if (!pi)
@@ -462,6 +468,7 @@ static void *cxlctl_get_feature(struct cxl_features_state *cxlfs,
 	const struct cxl_mbox_get_feat_in *feat_in;
 	u16 offset, count, return_code;
 	size_t out_size = *out_len;
+	ssize_t data_size;
 
 	if (rpc_in->op_size != sizeof(*feat_in))
 		return ERR_PTR(-EINVAL);
@@ -482,16 +489,17 @@ static void *cxlctl_get_feature(struct cxl_features_state *cxlfs,
 	if (!rpc_out)
 		return ERR_PTR(-ENOMEM);
 
-	out_size = cxl_get_feature(cxl_mbox, &feat_in->uuid,
-				   feat_in->selection, rpc_out->payload,
-				   count, offset, &return_code);
+	data_size = cxl_get_feature(cxl_mbox, &feat_in->uuid,
+				    feat_in->selection, rpc_out->payload,
+				    count, offset, &return_code);
 	*out_len = sizeof(struct fwctl_rpc_cxl_out);
-	if (!out_size) {
+	if (data_size <= 0) {
 		rpc_out->size = 0;
 		rpc_out->retval = return_code;
 		return no_free_ptr(rpc_out);
 	}
 
+	out_size = data_size;
 	rpc_out->size = out_size;
 	rpc_out->retval = CXL_MBOX_CMD_RC_SUCCESS;
 	*out_len += out_size;
-- 
2.53.0



