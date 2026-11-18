Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015571;
	b=xbsaH3Qqfon0GOd4ThFMlrtCk/ToLfjb7f7VrXnlaZowQmB7oj/9sx00/dJdyB37EHqB
	 dRAppSTIahjUGfUC0pSiWQkf3R13XGNcPvYUDoAjAxcya3lbnWkNIp/mmTK01sVdV9/V8
	 EYJgVCg0hF2gnZC06M6biXhMo1cfJWLHcDljIULFweLDqzrUZd0/3j9qnBaDDYslSTvmp
	 VvuAufKvyVbm1PBpy3UkOZ6i43SDbsfKvHv/nFczMg+KTQitnZtGprOPVFKTz5rCazutz
	 vowfaF2endYCXA+SnTnlpR6OqcfJgmRHYF1zZ9Y1gmm6muaLGpTJyozHIK7gfrnrZCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oGwnysel6q5Ezap7Ac/zQmdVHKOQa279Prm++kjIdec=;
	b=RTs3klyerKKNTjQPEFv1hEm4wZWkg3KG0iYeJL94l+bL75WmyU71rcZzkDe5lzVc3AWo
	 01UFOG7Si4Og6r66xOreqMxrIj+H6Vi0hxWVUiZaXj4RfXHVFi9OgORyjHNsp0IRsbSux
	 Yak5zWxh6c0qojni0Q9D3t4irMtdzWFjSYEMG5ZLnoPsAVixYa39W5CW3+2/vNTrq3oob
	 LRf3etFoWqtEQANQ2bhCtmaI867oQOv4H20FGYlCNilkgFjjH1PC1NN2YPvpPwZouj7Ov
	 SXqEnuOSK0+kA9nsGYMgeMxJ1diZy+h7q8BZ4mAvWgwzwy3YglNz7wqnOeWczJsTBIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d0LUGaVG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459BE606A339;
	Wed, 18 Nov 2026 15:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d0LUGaVG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA501F000C4;
	Wed, 18 Nov 2026 15:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015571;
	bh=oGwnysel6q5Ezap7Ac/zQmdVHKOQa279Prm++kjIdec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d0LUGaVGTyW5Kx1gVhU6jW+tPNB/HSRf79ABVAFEsXJFTvMTegYb/RM8bpJqP2L/e
	 pBGJOoEZNGnxFWLc1yUcCwufKiuTUTq8xuIK6rWXEoBsFUS5iS74DL3D6sHNr9+JTN
	 uG+dWHK48Y4mPQF+L8G+tRO4IJmVqOEHs8NLgyI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cheng <icheng@nvidia.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0222/2651] cxl/fwctl: Propagate feature RPC delivery errors
Date: Wed, 18 Nov 2026 15:24:22 +0100
Message-ID: <20261118150255.859997132@linuxfoundation.org>
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

From: Richard Cheng <icheng@nvidia.com>

[ Upstream commit 51493ff66ad6b1c8e904cf3ab8c69e9c59aaba0f ]

FWCTL_RPC requires delivery failures to be returned as ioctl errors,
while device errors are reported in the output. Get and Set Feature
instead converted all failures into normal responses, sometimes with a
SUCCESS device status.

Initialize the return code to SUCCESS. When the helper fails without a
device error code, return its errno. Continue reporting actual device
errors through rpc_out->retval.

CXL permits Get Feature to return a nonzero short payload when Offset +
Count runs past the end of the Feature. cxl_internal_send_cmd() reports
that response as -EIO, so preserve the returned bytes as a successful
partial transfer. Fixed-format EDAC callers still require complete
attribute structures, so reject partial payloads before consuming them.

Map an unexpected zero-length result with a SUCCESS device status to
-EIO.

Fixes: 5908f3ed6dc2 ("cxl: Add support to handle user feature commands for get feature")
Fixes: eb5dfcb9e36d ("cxl: Add support to handle user feature commands for set feature")
Signed-off-by: Richard Cheng <icheng@nvidia.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260902053839.25595-8-icheng@nvidia.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/edac.c     | 10 +++++-----
 drivers/cxl/core/features.c | 28 +++++++++++++++++++---------
 2 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/cxl/core/edac.c b/drivers/cxl/core/edac.c
index f1df4b5cfe5b8..34b81e8dfbbb6 100644
--- a/drivers/cxl/core/edac.c
+++ b/drivers/cxl/core/edac.c
@@ -89,7 +89,7 @@ static int cxl_mem_scrub_get_attrbs(struct cxl_mailbox *cxl_mbox, u8 *cap,
 				    rd_data_size, 0, NULL);
 	if (data_size < 0)
 		return data_size;
-	if (!data_size)
+	if ((size_t)data_size != rd_data_size)
 		return -EIO;
 
 	*cap = rd_attrbs->scrub_cycle_cap;
@@ -567,7 +567,7 @@ static int cxl_mem_ecs_get_attrbs(struct device *dev,
 				    rd_data_size, 0, NULL);
 	if (data_size < 0)
 		return data_size;
-	if (!data_size)
+	if ((size_t)data_size != rd_data_size)
 		return -EIO;
 
 	fru_rd_attrbs = rd_attrbs->fru_attrbs;
@@ -602,7 +602,7 @@ static int cxl_mem_ecs_set_attrbs(struct device *dev,
 				    rd_data_size, 0, NULL);
 	if (data_size < 0)
 		return data_size;
-	if (!data_size)
+	if ((size_t)data_size != rd_data_size)
 		return -EIO;
 
 	struct cxl_ecs_wr_attrbs *wr_attrbs __free(kvfree) =
@@ -1282,7 +1282,7 @@ cxl_mem_sparing_get_attrbs(struct cxl_mem_sparing_context *cxl_sparing_ctx)
 				    rd_data_size, 0, &return_code);
 	if (data_size < 0)
 		return data_size;
-	if (!data_size)
+	if ((size_t)data_size != rd_data_size)
 		return -EIO;
 
 	cxl_sparing_ctx->op_class = rd_attrbs->hdr.op_class;
@@ -1771,7 +1771,7 @@ static int cxl_mem_ppr_get_attrbs(struct cxl_ppr_context *cxl_ppr_ctx)
 				    rd_data_size, 0, &return_code);
 	if (data_size < 0)
 		return data_size;
-	if (!data_size)
+	if ((size_t)data_size != rd_data_size)
 		return -EIO;
 
 	cxl_ppr_ctx->op_class = rd_attrbs->hdr.op_class;
diff --git a/drivers/cxl/core/features.c b/drivers/cxl/core/features.c
index 8ff60229c3980..8024c2dcae1d1 100644
--- a/drivers/cxl/core/features.c
+++ b/drivers/cxl/core/features.c
@@ -232,7 +232,7 @@ ssize_t cxl_get_feature(struct cxl_mailbox *cxl_mbox, const uuid_t *feat_uuid,
 	int rc;
 
 	if (return_code)
-		*return_code = CXL_MBOX_CMD_RC_INPUT;
+		*return_code = CXL_MBOX_CMD_RC_SUCCESS;
 
 	if (!feat_out || !feat_out_size)
 		return -EINVAL;
@@ -259,6 +259,17 @@ ssize_t cxl_get_feature(struct cxl_mailbox *cxl_mbox, const uuid_t *feat_uuid,
 			.min_out = data_to_rd_size,
 		};
 		rc = cxl_internal_send_cmd(cxl_mbox, &mbox_cmd);
+		/*
+		 * Per CXL r4.0 8.2.10.6.2, when Offset + Count runs past the
+		 * end of the Feature the device returns only the bytes up to
+		 * the Feature size. cxl_internal_send_cmd() reports that as
+		 * -EIO with a short payload, so stop and return what arrived.
+		 */
+		if (rc == -EIO && mbox_cmd.size_out &&
+		    mbox_cmd.size_out < data_to_rd_size) {
+			data_rcvd_size += mbox_cmd.size_out;
+			break;
+		}
 		if (rc < 0 || !mbox_cmd.size_out) {
 			if (return_code)
 				*return_code = mbox_cmd.return_code;
@@ -267,9 +278,6 @@ ssize_t cxl_get_feature(struct cxl_mailbox *cxl_mbox, const uuid_t *feat_uuid,
 		data_rcvd_size += mbox_cmd.size_out;
 	} while (data_rcvd_size < feat_out_size);
 
-	if (return_code)
-		*return_code = CXL_MBOX_CMD_RC_SUCCESS;
-
 	return data_rcvd_size;
 }
 
@@ -289,7 +297,7 @@ int cxl_set_feature(struct cxl_mailbox *cxl_mbox,
 	size_t hdr_size;
 
 	if (return_code)
-		*return_code = CXL_MBOX_CMD_RC_INPUT;
+		*return_code = CXL_MBOX_CMD_RC_SUCCESS;
 
 	if (feat_data_size > U16_MAX - offset)
 		return -EINVAL;
@@ -340,11 +348,8 @@ int cxl_set_feature(struct cxl_mailbox *cxl_mbox,
 		}
 
 		data_sent_size += data_in_size;
-		if (data_sent_size >= feat_data_size) {
-			if (return_code)
-				*return_code = CXL_MBOX_CMD_RC_SUCCESS;
+		if (data_sent_size >= feat_data_size)
 			return 0;
-		}
 
 		if ((feat_data_size - data_sent_size) <= (cxl_mbox->payload_size - hdr_size)) {
 			data_in_size = feat_data_size - data_sent_size;
@@ -492,6 +497,9 @@ static void *cxlctl_get_feature(struct cxl_features_state *cxlfs,
 	data_size = cxl_get_feature(cxl_mbox, &feat_in->uuid,
 				    feat_in->selection, rpc_out->payload,
 				    count, offset, &return_code);
+	if (data_size <= 0 &&
+	    return_code == CXL_MBOX_CMD_RC_SUCCESS)
+		return ERR_PTR(data_size ?: -EIO);
 	*out_len = sizeof(struct fwctl_rpc_cxl_out);
 	if (data_size <= 0) {
 		rpc_out->size = 0;
@@ -544,6 +552,8 @@ static void *cxlctl_set_feature(struct cxl_features_state *cxlfs,
 	rc = cxl_set_feature(cxl_mbox, &feat_in->uuid,
 			     feat_in->version, feat_in->feat_data,
 			     data_size, flags, offset, &return_code);
+	if (rc && return_code == CXL_MBOX_CMD_RC_SUCCESS)
+		return ERR_PTR(rc);
 	*out_len = sizeof(*rpc_out);
 	if (rc) {
 		rpc_out->retval = return_code;
-- 
2.53.0



