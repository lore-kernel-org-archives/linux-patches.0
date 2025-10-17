Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B2E32C92D;
	Fri, 17 Oct 2025 15:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713925; cv=none; b=MmDboCEwsM+Q9SJpbWs+Dr72XLHEPSZiE9pbjg1BL+nv7LSBKMbtivgtHr37BU8rmLfOjM9pncvVBcGvfeVHD+DNxsvRauLX3BblElI19smPQTz/JptgsOMqw3VMY7sxZrxPIf29iOPO8kMRwzh2uPxbFvERVoSQ6Z/KRoanA90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713925; c=relaxed/simple;
	bh=T02zDQ3A4c8fhUZY9wUZ2oJ8eQG976sjgC/daC2lWlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7MZoJwCFC+uHIOXCCVDk56XdpzWfxeDwk+YVxSgwvxV/KLWKV3J7/i7Ji853+Ar7AIcVneQ68zrGM3FGqUzPe0q0fmUlx0zwggF2eSi/f/L9dcuHkFpzHCSfY4kKH5Ll0tuzEs0LnBwqW3VhNYFv9iOG1sFFI9oG3lgZAP8L8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2s7dHa0m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2s7dHa0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE84FC4CEE7;
	Fri, 17 Oct 2025 15:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713925;
	bh=T02zDQ3A4c8fhUZY9wUZ2oJ8eQG976sjgC/daC2lWlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2s7dHa0mLCxtrUpdzzWCMvbcylooJOYIO5r0A0HK0pw2ntsPZLH/o74J7ll1W12u0
	 k977KGJNtdpWaZhCnw0l/EPQRRjEN+RWtswJ4jfO8PrBNzzOPPqzicyxsuCdVlpQyU
	 6CjUOgPPn9e7ZnVZ//wDp2KUrZDzpC5EfpoJ0E1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>,
	Ling Xu <quic_lxu5@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 168/201] misc: fastrpc: Save actual DMA size in fastrpc_map structure
Date: Fri, 17 Oct 2025 16:53:49 +0200
Message-ID: <20251017145140.911068396@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ling Xu <quic_lxu5@quicinc.com>

[ Upstream commit 8b5b456222fd604079b5cf2af1f25ad690f54a25 ]

For user passed fd buffer, map is created using DMA calls. The
map related information is stored in fastrpc_map structure. The
actual DMA size is not stored in the structure. Store the actual
size of buffer and check it against the user passed size.

Fixes: c68cfb718c8f ("misc: fastrpc: Add support for context Invoke method")
Cc: stable@kernel.org
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Co-developed-by: Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>
Signed-off-by: Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>
Signed-off-by: Ling Xu <quic_lxu5@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://lore.kernel.org/r/20250912131236.303102-2-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -322,11 +322,11 @@ static void fastrpc_free_map(struct kref
 
 			perm.vmid = QCOM_SCM_VMID_HLOS;
 			perm.perm = QCOM_SCM_PERM_RWX;
-			err = qcom_scm_assign_mem(map->phys, map->size,
+			err = qcom_scm_assign_mem(map->phys, map->len,
 				&src_perms, &perm, 1);
 			if (err) {
 				dev_err(map->fl->sctx->dev, "Failed to assign memory phys 0x%llx size 0x%llx err %d\n",
-						map->phys, map->size, err);
+						map->phys, map->len, err);
 				return;
 			}
 		}
@@ -752,7 +752,8 @@ static int fastrpc_map_attach(struct fas
 	struct fastrpc_session_ctx *sess = fl->sctx;
 	struct fastrpc_map *map = NULL;
 	struct sg_table *table;
-	int err = 0;
+	struct scatterlist *sgl = NULL;
+	int err = 0, sgl_index = 0;
 
 	map = kzalloc(sizeof(*map), GFP_KERNEL);
 	if (!map)
@@ -789,7 +790,15 @@ static int fastrpc_map_attach(struct fas
 		map->phys = sg_dma_address(map->table->sgl);
 		map->phys += ((u64)fl->sctx->sid << 32);
 	}
-	map->size = len;
+	for_each_sg(map->table->sgl, sgl, map->table->nents,
+		sgl_index)
+		map->size += sg_dma_len(sgl);
+	if (len > map->size) {
+		dev_dbg(sess->dev, "Bad size passed len 0x%llx map size 0x%llx\n",
+				len, map->size);
+		err = -EINVAL;
+		goto map_err;
+	}
 	map->va = sg_virt(map->table->sgl);
 	map->len = len;
 
@@ -806,10 +815,10 @@ static int fastrpc_map_attach(struct fas
 		dst_perms[1].vmid = fl->cctx->vmperms[0].vmid;
 		dst_perms[1].perm = QCOM_SCM_PERM_RWX;
 		map->attr = attr;
-		err = qcom_scm_assign_mem(map->phys, (u64)map->size, &src_perms, dst_perms, 2);
+		err = qcom_scm_assign_mem(map->phys, (u64)map->len, &src_perms, dst_perms, 2);
 		if (err) {
 			dev_err(sess->dev, "Failed to assign memory with phys 0x%llx size 0x%llx err %d\n",
-					map->phys, map->size, err);
+					map->phys, map->len, err);
 			goto map_err;
 		}
 	}
@@ -2063,7 +2072,7 @@ static int fastrpc_req_mem_map(struct fa
 	args[0].length = sizeof(req_msg);
 
 	pages.addr = map->phys;
-	pages.size = map->size;
+	pages.size = map->len;
 
 	args[1].ptr = (u64) (uintptr_t) &pages;
 	args[1].length = sizeof(pages);
@@ -2078,7 +2087,7 @@ static int fastrpc_req_mem_map(struct fa
 	err = fastrpc_internal_invoke(fl, true, FASTRPC_INIT_HANDLE, sc, &args[0]);
 	if (err) {
 		dev_err(dev, "mem mmap error, fd %d, vaddr %llx, size %lld\n",
-			req.fd, req.vaddrin, map->size);
+			req.fd, req.vaddrin, map->len);
 		goto err_invoke;
 	}
 
@@ -2091,7 +2100,7 @@ static int fastrpc_req_mem_map(struct fa
 	if (copy_to_user((void __user *)argp, &req, sizeof(req))) {
 		/* unmap the memory and release the buffer */
 		req_unmap.vaddr = (uintptr_t) rsp_msg.vaddr;
-		req_unmap.length = map->size;
+		req_unmap.length = map->len;
 		fastrpc_req_mem_unmap_impl(fl, &req_unmap);
 		return -EFAULT;
 	}


