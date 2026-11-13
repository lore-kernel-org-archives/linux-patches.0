Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590593;
	b=Sxxo5nQWMR5LSUIC2Gf18P++mhE94IfDR3E7enPoOjB3K9RMy1xqQVjiPFY7dX1msRqE
	 CdL8KGcG74ViWeszknPWDUgucBV+PWHCsZ81lfO/HT9mSpiwKEdXG39wccLOZxGrCopAf
	 mPVQ9U0zT6Ql0p1dUzipa7aIV5BPfCmgZMiM1aev90vWHST8uxB9ioh0oMeZ5tNg9haVi
	 B5gIp7/+cLD2aeV/e/omvLo1dKbGx/azTtXEiiElfRL0jI/M6O+8jnD/bGD9XGkZv55ZR
	 n6TSRpPFxQp4/nUoCaJpB4ntmLZJQBOPjJMfLnEenx6h/Z6Z56WFjITgg9AS1h5bRLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w7iINGfkf1aSVaHe7YGT+NuOKXQg7qFPjyMldKP+JtA=;
	b=DRuw1zf/hqW3AQ4Dc8531vWK7qimWWmRkPVnoJyzUxSLOCamsab72fZlsX2VDdoK4AZE
	 S0LsHpAD5MazzrwH6bbEcIg9EBdwMLEmgVd5rNxiYIlclkXqi90kEvpbUO3JvTS2R6pEd
	 jqr8jvtCFcszvXMMEPaQRjTzxF1Gey+FMdiedb+nhcQJbi8X3Xaq3a0WijFRHiU0o2+gL
	 lgq8Gqeup+wzvu8nAvCDMmPFM5yOcMBPW6ZF4m5XAWmBgMaRJdYU6ocZ2Drt+OSEwERgI
	 ckrvDiakUf9xOOHMXGX2ju46o6Wqr6Ma2Cz53MXa5mYAi1LCAQKOm3Wf/A/bt8jFzGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=opTQY2bd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2636C606C096;
	Fri, 13 Nov 2026 17:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=opTQY2bd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58861F000C4;
	Fri, 13 Nov 2026 17:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590593;
	bh=w7iINGfkf1aSVaHe7YGT+NuOKXQg7qFPjyMldKP+JtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=opTQY2bd3oPPAhbwvAypDI4yIEVwqj4asKasstQDvbIgaYX+SZbKtbCNt0/QE2hlU
	 3yGaM8CKBtfbaN7GtxrsycqedEZWTBDhrqSynUmnDGHP2YFYA99alaE40KHAAoos3k
	 +RgwGgtn5hn0L9thvWPnvnvgsMnEnP34q9nKy+TM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumari Pallavi <kumari.pallavi@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 524/686] misc: fastrpc: Rename phys to dma_addr for clarity
Date: Fri, 13 Nov 2026 10:50:57 -0500
Message-ID: <20261113153838.893736934@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Kumari Pallavi <kumari.pallavi@oss.qualcomm.com>

[ Upstream commit 428b2f2b60c37f69e0723a225135da1f352d2602 ]

The fields buf->phys and map->phys currently store DMA addresses
returned by dma_map_*() APIs, not physical addresses. This naming
is misleading and may lead to incorrect assumptions about the
address type and its translation.
Rename these fields from phys to dma_addr to improve code clarity
and align with kernel conventions for dma_addr_t usage.

Signed-off-by: Kumari Pallavi <kumari.pallavi@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20251226070534.602021-3-kumari.pallavi@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 09fa66ec1b48 ("misc: fastrpc: fix double-free in fastrpc_map_attach() error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/fastrpc.c | 77 ++++++++++++++++++++++--------------------
 1 file changed, 41 insertions(+), 36 deletions(-)

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index 29f9003999a07..891f28e933537 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -106,7 +106,7 @@
 #define miscdev_to_fdevice(d) container_of(d, struct fastrpc_device, miscdev)
 
 struct fastrpc_phy_page {
-	u64 addr;		/* physical address */
+	dma_addr_t addr;	/* dma address */
 	u64 size;		/* size of contiguous region */
 };
 
@@ -171,7 +171,7 @@ struct fastrpc_msg {
 	u64 ctx;		/* invoke caller context */
 	u32 handle;	/* handle to invoke */
 	u32 sc;		/* scalars structure describing the data */
-	u64 addr;		/* physical address */
+	dma_addr_t addr;	/* dma address */
 	u64 size;		/* size of contiguous region */
 };
 
@@ -194,7 +194,7 @@ struct fastrpc_buf {
 	struct dma_buf *dmabuf;
 	struct device *dev;
 	void *virt;
-	u64 phys;
+	dma_addr_t dma_addr;
 	u64 size;
 	/* Lock for dma buf attachments */
 	struct mutex lock;
@@ -217,7 +217,7 @@ struct fastrpc_map {
 	struct dma_buf *buf;
 	struct sg_table *table;
 	struct dma_buf_attachment *attach;
-	u64 phys;
+	dma_addr_t dma_addr;
 	u64 size;
 	void *va;
 	u64 len;
@@ -322,11 +322,12 @@ static void fastrpc_free_map(struct kref *ref)
 
 			perm.vmid = QCOM_SCM_VMID_HLOS;
 			perm.perm = QCOM_SCM_PERM_RWX;
-			err = qcom_scm_assign_mem(map->phys, map->len,
+			err = qcom_scm_assign_mem(map->dma_addr, map->len,
 				&src_perms, &perm, 1);
 			if (err) {
-				dev_err(map->fl->sctx->dev, "Failed to assign memory phys 0x%llx size 0x%llx err %d\n",
-						map->phys, map->len, err);
+				dev_err(map->fl->sctx->dev,
+					"Failed to assign memory dma_addr %pad size 0x%llx err %d\n",
+					&map->dma_addr, map->len, err);
 				return;
 			}
 		}
@@ -397,7 +398,7 @@ static int fastrpc_map_lookup(struct fastrpc_user *fl, int fd,
 static void fastrpc_buf_free(struct fastrpc_buf *buf)
 {
 	dma_free_coherent(buf->dev, buf->size, buf->virt,
-			  FASTRPC_PHYS(buf->phys));
+			  FASTRPC_PHYS(buf->dma_addr));
 	kfree(buf);
 }
 
@@ -416,12 +417,12 @@ static int __fastrpc_buf_alloc(struct fastrpc_user *fl, struct device *dev,
 
 	buf->fl = fl;
 	buf->virt = NULL;
-	buf->phys = 0;
+	buf->dma_addr = 0;
 	buf->size = size;
 	buf->dev = dev;
 	buf->raddr = 0;
 
-	buf->virt = dma_alloc_coherent(dev, buf->size, (dma_addr_t *)&buf->phys,
+	buf->virt = dma_alloc_coherent(dev, buf->size, &buf->dma_addr,
 				       GFP_KERNEL);
 	if (!buf->virt) {
 		mutex_destroy(&buf->lock);
@@ -447,7 +448,7 @@ static int fastrpc_buf_alloc(struct fastrpc_user *fl, struct device *dev,
 	buf = *obuf;
 
 	if (fl->sctx && fl->sctx->sid)
-		buf->phys += ((u64)fl->sctx->sid << 32);
+		buf->dma_addr += ((u64)fl->sctx->sid << 32);
 
 	return 0;
 }
@@ -740,7 +741,7 @@ static int fastrpc_dma_buf_attach(struct dma_buf *dmabuf,
 		return -ENOMEM;
 
 	ret = dma_get_sgtable(buffer->dev, &a->sgt, buffer->virt,
-			      FASTRPC_PHYS(buffer->phys), buffer->size);
+			      FASTRPC_PHYS(buffer->dma_addr), buffer->size);
 	if (ret < 0) {
 		dev_err(buffer->dev, "failed to get scatterlist from DMA API\n");
 		kfree(a);
@@ -789,7 +790,7 @@ static int fastrpc_mmap(struct dma_buf *dmabuf,
 	dma_resv_assert_held(dmabuf->resv);
 
 	return dma_mmap_coherent(buf->dev, vma, buf->virt,
-				 FASTRPC_PHYS(buf->phys), size);
+				 FASTRPC_PHYS(buf->dma_addr), size);
 }
 
 static const struct dma_buf_ops fastrpc_dma_buf_ops = {
@@ -841,10 +842,10 @@ static int fastrpc_map_attach(struct fastrpc_user *fl, int fd,
 	map->table = table;
 
 	if (attr & FASTRPC_ATTR_SECUREMAP) {
-		map->phys = sg_phys(map->table->sgl);
+		map->dma_addr = sg_phys(map->table->sgl);
 	} else {
-		map->phys = sg_dma_address(map->table->sgl);
-		map->phys += ((u64)fl->sctx->sid << 32);
+		map->dma_addr = sg_dma_address(map->table->sgl);
+		map->dma_addr += ((u64)fl->sctx->sid << 32);
 	}
 	for_each_sg(map->table->sgl, sgl, map->table->nents,
 		sgl_index)
@@ -871,10 +872,11 @@ static int fastrpc_map_attach(struct fastrpc_user *fl, int fd,
 		dst_perms[1].vmid = fl->cctx->vmperms[0].vmid;
 		dst_perms[1].perm = QCOM_SCM_PERM_RWX;
 		map->attr = attr;
-		err = qcom_scm_assign_mem(map->phys, (u64)map->len, &src_perms, dst_perms, 2);
+		err = qcom_scm_assign_mem(map->dma_addr, (u64)map->len, &src_perms, dst_perms, 2);
 		if (err) {
-			dev_err(sess->dev, "Failed to assign memory with phys 0x%llx size 0x%llx err %d\n",
-					map->phys, map->len, err);
+			dev_err(sess->dev,
+				"Failed to assign memory with dma_addr %pad size 0x%llx err %d\n",
+				&map->dma_addr, map->len, err);
 			goto map_err;
 		}
 	}
@@ -1056,7 +1058,7 @@ static int fastrpc_get_args(u32 kernel, struct fastrpc_invoke_ctx *ctx)
 			struct vm_area_struct *vma = NULL;
 
 			rpra[i].buf.pv = (u64) ctx->args[i].ptr;
-			pages[i].addr = ctx->maps[i]->phys;
+			pages[i].addr = ctx->maps[i]->dma_addr;
 
 			mmap_read_lock(current->mm);
 			vma = vma_lookup(current->mm, ctx->args[i].ptr);
@@ -1083,7 +1085,7 @@ static int fastrpc_get_args(u32 kernel, struct fastrpc_invoke_ctx *ctx)
 				goto bail;
 
 			rpra[i].buf.pv = args - ctx->olaps[oix].offset;
-			pages[i].addr = ctx->buf->phys -
+			pages[i].addr = ctx->buf->dma_addr -
 					ctx->olaps[oix].offset +
 					(pkt_size - rlen);
 			pages[i].addr = pages[i].addr &	PAGE_MASK;
@@ -1115,7 +1117,7 @@ static int fastrpc_get_args(u32 kernel, struct fastrpc_invoke_ctx *ctx)
 		list[i].num = ctx->args[i].length ? 1 : 0;
 		list[i].pgidx = i;
 		if (ctx->maps[i]) {
-			pages[i].addr = ctx->maps[i]->phys;
+			pages[i].addr = ctx->maps[i]->dma_addr;
 			pages[i].size = ctx->maps[i]->size;
 		}
 		rpra[i].dma.fd = ctx->args[i].fd;
@@ -1197,7 +1199,7 @@ static int fastrpc_invoke_send(struct fastrpc_session_ctx *sctx,
 	msg->ctx = ctx->ctxid | fl->pd;
 	msg->handle = handle;
 	msg->sc = ctx->sc;
-	msg->addr = ctx->buf ? ctx->buf->phys : 0;
+	msg->addr = ctx->buf ? ctx->buf->dma_addr : 0;
 	msg->size = roundup(ctx->msg_sz, PAGE_SIZE);
 	fastrpc_context_get(ctx);
 
@@ -1357,13 +1359,15 @@ static int fastrpc_init_create_static_process(struct fastrpc_user *fl,
 		if (fl->cctx->vmcount) {
 			u64 src_perms = BIT(QCOM_SCM_VMID_HLOS);
 
-			err = qcom_scm_assign_mem(fl->cctx->remote_heap->phys,
+			err = qcom_scm_assign_mem(fl->cctx->remote_heap->dma_addr,
 							(u64)fl->cctx->remote_heap->size,
 							&src_perms,
 							fl->cctx->vmperms, fl->cctx->vmcount);
 			if (err) {
-				dev_err(fl->sctx->dev, "Failed to assign memory with phys 0x%llx size 0x%llx err %d\n",
-					fl->cctx->remote_heap->phys, fl->cctx->remote_heap->size, err);
+				dev_err(fl->sctx->dev,
+					"Failed to assign memory with dma_addr %pad size 0x%llx err %d\n",
+					&fl->cctx->remote_heap->dma_addr,
+					fl->cctx->remote_heap->size, err);
 				goto err_map;
 			}
 			scm_done = true;
@@ -1381,7 +1385,7 @@ static int fastrpc_init_create_static_process(struct fastrpc_user *fl,
 	args[1].length = inbuf.namelen;
 	args[1].fd = -1;
 
-	pages[0].addr = fl->cctx->remote_heap->phys;
+	pages[0].addr = fl->cctx->remote_heap->dma_addr;
 	pages[0].size = fl->cctx->remote_heap->size;
 
 	args[2].ptr = (u64)(uintptr_t) pages;
@@ -1410,12 +1414,12 @@ static int fastrpc_init_create_static_process(struct fastrpc_user *fl,
 
 		dst_perms.vmid = QCOM_SCM_VMID_HLOS;
 		dst_perms.perm = QCOM_SCM_PERM_RWX;
-		err = qcom_scm_assign_mem(fl->cctx->remote_heap->phys,
+		err = qcom_scm_assign_mem(fl->cctx->remote_heap->dma_addr,
 						(u64)fl->cctx->remote_heap->size,
 						&src_perms, &dst_perms, 1);
 		if (err)
-			dev_err(fl->sctx->dev, "Failed to assign memory phys 0x%llx size 0x%llx err %d\n",
-				fl->cctx->remote_heap->phys, fl->cctx->remote_heap->size, err);
+			dev_err(fl->sctx->dev, "Failed to assign memory dma_addr %pad size 0x%llx err %d\n",
+				&fl->cctx->remote_heap->dma_addr, fl->cctx->remote_heap->size, err);
 	}
 err_map:
 	fastrpc_buf_free(fl->cctx->remote_heap);
@@ -1505,7 +1509,7 @@ static int fastrpc_init_create_process(struct fastrpc_user *fl,
 	args[2].length = inbuf.filelen;
 	args[2].fd = init.filefd;
 
-	pages[0].addr = imem->phys;
+	pages[0].addr = imem->dma_addr;
 	pages[0].size = imem->size;
 
 	args[3].ptr = (u64)(uintptr_t) pages;
@@ -1945,7 +1949,7 @@ static int fastrpc_req_mmap(struct fastrpc_user *fl, char __user *argp)
 	args[0].ptr = (u64) (uintptr_t) &req_msg;
 	args[0].length = sizeof(req_msg);
 
-	pages.addr = buf->phys;
+	pages.addr = buf->dma_addr;
 	pages.size = buf->size;
 
 	args[1].ptr = (u64) (uintptr_t) &pages;
@@ -1973,11 +1977,12 @@ static int fastrpc_req_mmap(struct fastrpc_user *fl, char __user *argp)
 	if (req.flags == ADSP_MMAP_REMOTE_HEAP_ADDR && fl->cctx->vmcount) {
 		u64 src_perms = BIT(QCOM_SCM_VMID_HLOS);
 
-		err = qcom_scm_assign_mem(buf->phys, (u64)buf->size,
+		err = qcom_scm_assign_mem(buf->dma_addr, (u64)buf->size,
 			&src_perms, fl->cctx->vmperms, fl->cctx->vmcount);
 		if (err) {
-			dev_err(fl->sctx->dev, "Failed to assign memory phys 0x%llx size 0x%llx err %d",
-					buf->phys, buf->size, err);
+			dev_err(fl->sctx->dev,
+				"Failed to assign memory dma_addr %pad size 0x%llx err %d",
+				&buf->dma_addr, buf->size, err);
 			goto err_assign;
 		}
 	}
@@ -2091,7 +2096,7 @@ static int fastrpc_req_mem_map(struct fastrpc_user *fl, char __user *argp)
 	args[0].ptr = (u64) (uintptr_t) &req_msg;
 	args[0].length = sizeof(req_msg);
 
-	pages.addr = map->phys;
+	pages.addr = map->dma_addr;
 	pages.size = map->len;
 
 	args[1].ptr = (u64) (uintptr_t) &pages;
-- 
2.53.0



