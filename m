Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591389;
	b=tqVtx4mvY7qY2wWGNrJ00+QAxSDfFiakIa1uz5Q1wDlZkyKSaFmnJaXhxexRQNoLm1Fy
	 Oc2z+rO9lJHJCDlqEFbkPhMOD17Q4E1NKs63E4vMB0foqo2a+0zUx9kdZp9481S1MU+ji
	 dVsOxGxUHxdLilKlZNu9WVgLymtjM/puPse+lbQJMdlLZ+RpHHZNhiAniS60L3ueZwNYT
	 4VdPMW0vdLIvN23FVxNTkssJJi/beGu7nPpg6reTJGeO9Wvrtw6ZPuhBTDAT7fYmPuikR
	 qJCLqgghzoZTngCyLQzU25kvIdTPWqkH4um+AuqS09TlJi1sOsKhQns7aJZsIS9a4FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591389;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=36ZCPHFZyiwPN/lBfbCXUPfDCRpn18GNVspn0aTaizY=;
	b=JVEyVlER98k1qauVg+9kKCmnpCaFqix4ol+4up0acrNZ2xAhe4gkCVesfiq6wzGCdL0j
	 Z0AQoymk7Tnik8yjZPFDojKB7/4WWjDbjk21ZaafOqVmMc5LZ4IoNYTIOuU37r6/ouv0/
	 ZI3xmocWSR0Pm+k2YPYvQtWBtElDcLgjMc07uY2ExKoy8UsOnPe/KN7UMipYuAaf7LQtz
	 IN6p1dDeTWfsEG03Mq5HHnYVvNeD372HplE48LWsXTcyqs/Yfdjj9XSwjs2RHNTB2CUJA
	 6uJbhVOLsOy9c+D8aE3l1PfwzRkjixVkGt0NMAib7rTGymhc1a1yPMxzYcFuKq6JImQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RlWJevQb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87D5607A5C6;
	Fri, 13 Nov 2026 17:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RlWJevQb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295781F000C4;
	Fri, 13 Nov 2026 17:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591389;
	bh=36ZCPHFZyiwPN/lBfbCXUPfDCRpn18GNVspn0aTaizY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RlWJevQbaF4ndq2LsfURcFj5CMS4P6ATw73sanvaC1x3vvJoGW+wSdUSZ/GEV+hFy
	 kt02p2mZl5IhGMydaICvoaqQFRGTQJkFx4ITwq2iC13NRoRzS9ISJcVK8qNu8nyQaa
	 0UFme/n6PEUngXbBs4OX8VOEBcV0GDlQs8iICLWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumari Pallavi <kumari.pallavi@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 472/670] misc: fastrpc: Rename phys to dma_addr for clarity
Date: Fri, 13 Nov 2026 10:50:36 -0500
Message-ID: <20261113153827.957544248@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 576cd9e5b8079..afafaa68e2bd2 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -109,7 +109,7 @@
 static const char *domains[FASTRPC_DEV_MAX] = { "adsp", "mdsp",
 						"sdsp", "cdsp", "cdsp1" };
 struct fastrpc_phy_page {
-	u64 addr;		/* physical address */
+	dma_addr_t addr;	/* dma address */
 	u64 size;		/* size of contiguous region */
 };
 
@@ -174,7 +174,7 @@ struct fastrpc_msg {
 	u64 ctx;		/* invoke caller context */
 	u32 handle;	/* handle to invoke */
 	u32 sc;		/* scalars structure describing the data */
-	u64 addr;		/* physical address */
+	dma_addr_t addr;	/* dma address */
 	u64 size;		/* size of contiguous region */
 };
 
@@ -197,7 +197,7 @@ struct fastrpc_buf {
 	struct dma_buf *dmabuf;
 	struct device *dev;
 	void *virt;
-	u64 phys;
+	dma_addr_t dma_addr;
 	u64 size;
 	/* Lock for dma buf attachments */
 	struct mutex lock;
@@ -220,7 +220,7 @@ struct fastrpc_map {
 	struct dma_buf *buf;
 	struct sg_table *table;
 	struct dma_buf_attachment *attach;
-	u64 phys;
+	dma_addr_t dma_addr;
 	u64 size;
 	void *va;
 	u64 len;
@@ -325,11 +325,12 @@ static void fastrpc_free_map(struct kref *ref)
 
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
@@ -400,7 +401,7 @@ static int fastrpc_map_lookup(struct fastrpc_user *fl, int fd,
 static void fastrpc_buf_free(struct fastrpc_buf *buf)
 {
 	dma_free_coherent(buf->dev, buf->size, buf->virt,
-			  FASTRPC_PHYS(buf->phys));
+			  FASTRPC_PHYS(buf->dma_addr));
 	kfree(buf);
 }
 
@@ -419,12 +420,12 @@ static int __fastrpc_buf_alloc(struct fastrpc_user *fl, struct device *dev,
 
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
@@ -450,7 +451,7 @@ static int fastrpc_buf_alloc(struct fastrpc_user *fl, struct device *dev,
 	buf = *obuf;
 
 	if (fl->sctx && fl->sctx->sid)
-		buf->phys += ((u64)fl->sctx->sid << 32);
+		buf->dma_addr += ((u64)fl->sctx->sid << 32);
 
 	return 0;
 }
@@ -743,7 +744,7 @@ static int fastrpc_dma_buf_attach(struct dma_buf *dmabuf,
 		return -ENOMEM;
 
 	ret = dma_get_sgtable(buffer->dev, &a->sgt, buffer->virt,
-			      FASTRPC_PHYS(buffer->phys), buffer->size);
+			      FASTRPC_PHYS(buffer->dma_addr), buffer->size);
 	if (ret < 0) {
 		dev_err(buffer->dev, "failed to get scatterlist from DMA API\n");
 		kfree(a);
@@ -792,7 +793,7 @@ static int fastrpc_mmap(struct dma_buf *dmabuf,
 	dma_resv_assert_held(dmabuf->resv);
 
 	return dma_mmap_coherent(buf->dev, vma, buf->virt,
-				 FASTRPC_PHYS(buf->phys), size);
+				 FASTRPC_PHYS(buf->dma_addr), size);
 }
 
 static const struct dma_buf_ops fastrpc_dma_buf_ops = {
@@ -844,10 +845,10 @@ static int fastrpc_map_attach(struct fastrpc_user *fl, int fd,
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
@@ -874,10 +875,11 @@ static int fastrpc_map_attach(struct fastrpc_user *fl, int fd,
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
@@ -1059,7 +1061,7 @@ static int fastrpc_get_args(u32 kernel, struct fastrpc_invoke_ctx *ctx)
 			struct vm_area_struct *vma = NULL;
 
 			rpra[i].buf.pv = (u64) ctx->args[i].ptr;
-			pages[i].addr = ctx->maps[i]->phys;
+			pages[i].addr = ctx->maps[i]->dma_addr;
 
 			mmap_read_lock(current->mm);
 			vma = vma_lookup(current->mm, ctx->args[i].ptr);
@@ -1086,7 +1088,7 @@ static int fastrpc_get_args(u32 kernel, struct fastrpc_invoke_ctx *ctx)
 				goto bail;
 
 			rpra[i].buf.pv = args - ctx->olaps[oix].offset;
-			pages[i].addr = ctx->buf->phys -
+			pages[i].addr = ctx->buf->dma_addr -
 					ctx->olaps[oix].offset +
 					(pkt_size - rlen);
 			pages[i].addr = pages[i].addr &	PAGE_MASK;
@@ -1118,7 +1120,7 @@ static int fastrpc_get_args(u32 kernel, struct fastrpc_invoke_ctx *ctx)
 		list[i].num = ctx->args[i].length ? 1 : 0;
 		list[i].pgidx = i;
 		if (ctx->maps[i]) {
-			pages[i].addr = ctx->maps[i]->phys;
+			pages[i].addr = ctx->maps[i]->dma_addr;
 			pages[i].size = ctx->maps[i]->size;
 		}
 		rpra[i].dma.fd = ctx->args[i].fd;
@@ -1200,7 +1202,7 @@ static int fastrpc_invoke_send(struct fastrpc_session_ctx *sctx,
 	msg->ctx = ctx->ctxid | fl->pd;
 	msg->handle = handle;
 	msg->sc = ctx->sc;
-	msg->addr = ctx->buf ? ctx->buf->phys : 0;
+	msg->addr = ctx->buf ? ctx->buf->dma_addr : 0;
 	msg->size = roundup(ctx->msg_sz, PAGE_SIZE);
 	fastrpc_context_get(ctx);
 
@@ -1358,13 +1360,15 @@ static int fastrpc_init_create_static_process(struct fastrpc_user *fl,
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
@@ -1384,7 +1388,7 @@ static int fastrpc_init_create_static_process(struct fastrpc_user *fl,
 	args[1].length = inbuf.namelen;
 	args[1].fd = -1;
 
-	pages[0].addr = fl->cctx->remote_heap->phys;
+	pages[0].addr = fl->cctx->remote_heap->dma_addr;
 	pages[0].size = fl->cctx->remote_heap->size;
 
 	args[2].ptr = (u64)(uintptr_t) pages;
@@ -1413,12 +1417,12 @@ static int fastrpc_init_create_static_process(struct fastrpc_user *fl,
 
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
@@ -1508,7 +1512,7 @@ static int fastrpc_init_create_process(struct fastrpc_user *fl,
 	args[2].length = inbuf.filelen;
 	args[2].fd = init.filefd;
 
-	pages[0].addr = imem->phys;
+	pages[0].addr = imem->dma_addr;
 	pages[0].size = imem->size;
 
 	args[3].ptr = (u64)(uintptr_t) pages;
@@ -1962,7 +1966,7 @@ static int fastrpc_req_mmap(struct fastrpc_user *fl, char __user *argp)
 	args[0].ptr = (u64) (uintptr_t) &req_msg;
 	args[0].length = sizeof(req_msg);
 
-	pages.addr = buf->phys;
+	pages.addr = buf->dma_addr;
 	pages.size = buf->size;
 
 	args[1].ptr = (u64) (uintptr_t) &pages;
@@ -1990,11 +1994,12 @@ static int fastrpc_req_mmap(struct fastrpc_user *fl, char __user *argp)
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
@@ -2108,7 +2113,7 @@ static int fastrpc_req_mem_map(struct fastrpc_user *fl, char __user *argp)
 	args[0].ptr = (u64) (uintptr_t) &req_msg;
 	args[0].length = sizeof(req_msg);
 
-	pages.addr = map->phys;
+	pages.addr = map->dma_addr;
 	pages.size = map->len;
 
 	args[1].ptr = (u64) (uintptr_t) &pages;
-- 
2.53.0



