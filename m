Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2A918FC7F;
	Mon, 28 Oct 2024 06:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098036; cv=none; b=bV3lyWGMqDvSchdTcaTHghRaxee2qstCWT4FG3mNf1D+hkRt1+HMfm/O0/Fq/iGdgo2c25Q/HOVLlOcfRDykLfpDd0/xb352rGz0ATUIbpjvaZlCMniCjN3UEiTTza4OTKD1ZXL1Aa82ckXjBkeWqL9P223LK+4DweRPgHQXTq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098036; c=relaxed/simple;
	bh=pnc8FeZVaZhhLv7V34PiOAiFFq1ABXnNXeHcB/jU9w0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cd+UTG3hoQsCx/DrRZ4zwLYqoi/0oio8FjpV+3ubuVMDGyFovDUogy64j/o3sRtcdpOoa2HxGS8EJZE8CXa/41o6klMHtq7i2ncFqZBEiDkxPp/+Ulru2QfVeQd6esefFcUxpmJeJ/zcuiyTvUFrgxALna0krdP9MYBFrcx3vaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XroA29BG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XroA29BG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1361C4CEC3;
	Mon, 28 Oct 2024 06:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098036;
	bh=pnc8FeZVaZhhLv7V34PiOAiFFq1ABXnNXeHcB/jU9w0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XroA29BGMDmnn6xbKu4IRSVm762+1C+7EUxgzQNw9C4Z+Jwna7fEcJTz88u32KRHI
	 M805B2Cub5G4cqJBIGm1bQ/A6qULVwMJQpv4O2/aGuRZFw9qx9Q0PV3Tw6cwcM1hOo
	 LoCPUSvGFcfl7RP+RIBfjG+tfgHagZLjxIDtchp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pranjal Ramajor Asha Kanojiya <quic_pkanojiy@quicinc.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 048/261] accel/qaic: Fix the for loop used to walk SG table
Date: Mon, 28 Oct 2024 07:23:10 +0100
Message-ID: <20241028062313.216643133@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pranjal Ramajor Asha Kanojiya <quic_pkanojiy@quicinc.com>

[ Upstream commit c5e8e93897b7bb0a336bf3332f82f8d9f2b33f14 ]

Only for_each_sgtable_dma_sg() should be used to walk through a SG table
to grab correct bus address and length pair after calling DMA MAP API on
a SG table as DMA MAP APIs updates the SG table and for_each_sgtable_sg()
walks through the original SG table.

Fixes: ff13be830333 ("accel/qaic: Add datapath")
Fixes: 129776ac2e38 ("accel/qaic: Add control path")
Signed-off-by: Pranjal Ramajor Asha Kanojiya <quic_pkanojiy@quicinc.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241004193252.3888544-1-quic_jhugo@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/qaic/qaic_control.c | 2 +-
 drivers/accel/qaic/qaic_data.c    | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/accel/qaic/qaic_control.c b/drivers/accel/qaic/qaic_control.c
index 9e8a8cbadf6bb..d8bdab69f8009 100644
--- a/drivers/accel/qaic/qaic_control.c
+++ b/drivers/accel/qaic/qaic_control.c
@@ -496,7 +496,7 @@ static int encode_addr_size_pairs(struct dma_xfer *xfer, struct wrapper_list *wr
 	nents = sgt->nents;
 	nents_dma = nents;
 	*size = QAIC_MANAGE_EXT_MSG_LENGTH - msg_hdr_len - sizeof(**out_trans);
-	for_each_sgtable_sg(sgt, sg, i) {
+	for_each_sgtable_dma_sg(sgt, sg, i) {
 		*size -= sizeof(*asp);
 		/* Save 1K for possible follow-up transactions. */
 		if (*size < SZ_1K) {
diff --git a/drivers/accel/qaic/qaic_data.c b/drivers/accel/qaic/qaic_data.c
index e86e71c1cdd86..c20eb63750f51 100644
--- a/drivers/accel/qaic/qaic_data.c
+++ b/drivers/accel/qaic/qaic_data.c
@@ -184,7 +184,7 @@ static int clone_range_of_sgt_for_slice(struct qaic_device *qdev, struct sg_tabl
 	nents = 0;
 
 	size = size ? size : PAGE_SIZE;
-	for (sg = sgt_in->sgl; sg; sg = sg_next(sg)) {
+	for_each_sgtable_dma_sg(sgt_in, sg, j) {
 		len = sg_dma_len(sg);
 
 		if (!len)
@@ -221,7 +221,7 @@ static int clone_range_of_sgt_for_slice(struct qaic_device *qdev, struct sg_tabl
 
 	/* copy relevant sg node and fix page and length */
 	sgn = sgf;
-	for_each_sgtable_sg(sgt, sg, j) {
+	for_each_sgtable_dma_sg(sgt, sg, j) {
 		memcpy(sg, sgn, sizeof(*sg));
 		if (sgn == sgf) {
 			sg_dma_address(sg) += offf;
@@ -301,7 +301,7 @@ static int encode_reqs(struct qaic_device *qdev, struct bo_slice *slice,
 	 * fence.
 	 */
 	dev_addr = req->dev_addr;
-	for_each_sgtable_sg(slice->sgt, sg, i) {
+	for_each_sgtable_dma_sg(slice->sgt, sg, i) {
 		slice->reqs[i].cmd = cmd;
 		slice->reqs[i].src_addr = cpu_to_le64(slice->dir == DMA_TO_DEVICE ?
 						      sg_dma_address(sg) : dev_addr);
-- 
2.43.0



