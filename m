Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618044;
	b=MgBFnYzYTnw3Iec015t7ttM0SZM0ckVQwmwGM7KiSWVlG0EYEbIE4zG8RQFFV6CibOkR
	 ezmRmFiTixDiEAnBx2M6dXGhTsF3oUQAWDIdZW3YAh8rPA/DRg9UtmjG/IpUXJxMhvmor
	 OVX/EUYVpk9cG0okyx1j2WkEIKlVtTZ/fKdRvmp/sTzUWR/e/ow3x+/qK/Usqjz4ZpnvO
	 1bXrOs2Q0sW5NieKb4+d4NdwDBXAi+Rhp7ImeznjwR1qMJLM2LUHdIpVa/16aYAlMgoY+
	 RqPg/UC9f9bVCo6zJLMMzPn07BU7bjNT4TlXac1Aospgj5+lSSHEGyMiIg/7Wna3MVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=REfpBwwcEZLrg+bPa/xwDBL8+oAeU82PJM/DRYJp2LA=;
	b=v+Zpt+CWo0fYd+A2YVn3rufU7dvampgk3ll6JeG7UK3tLCDZ2tF0am+T0rTerI1xZe9c
	 ab/SH7L+8uQw0baBhLVhLF4nwV4dUcOg/y3pfJd7ZPF6XbCYBoVb/j9/ZyktD8Nc8AsD8
	 v9EnxzMisNlEdD7531rYbeOV92IEAfWF1F7O0L3srTtJeN6ekyGK7aEnfoOUb+bkJuy+7
	 +8YkqMXuqqfKBLHO/CqufqKps2ZHsLuJUr3R8QUCE8wqPwIPRtU8AYI5fWyQdnePmjo4L
	 5NeFCP53LyFAvomZI8pLP/8Ik+t7phJUOhJQzeeHnnJxGW+2zxBTdkO0LvvPJvvz0Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hQLwS0Uf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3200606A329;
	Wed, 25 Nov 2026 14:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hQLwS0Uf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004AE1F000D1;
	Wed, 25 Nov 2026 14:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618044;
	bh=REfpBwwcEZLrg+bPa/xwDBL8+oAeU82PJM/DRYJp2LA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hQLwS0Ufc06FlEc8/K0B8y+ZRPtIBNtVHydkq2S4xEo9ixe/jEB4K8AEdISQYmUiI
	 5Tt4xbuWiSB4Z83DvkVUftvLnwLAr8BoQMiCZuaTrTUwThMplipYzjeqMdxCk+JL+z
	 LarxOTlCDL5vJ5qXWBmpTZ7s1I20Zt5L93/b3FOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0154/1005] vdpa: invalidate DMA mappings before releasing memory
Date: Wed, 25 Nov 2026 15:24:52 +0100
Message-ID: <20261125143825.342929990@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Linfeng Sun <linfeng.sun.dev@gmail.com>

[ Upstream commit acbf36deb53d9e14e4768bf58883795a8232aa5b ]

vdpa can release pinned pages and file references before the device stops
using the corresponding mappings, allowing stale DMA to corrupt memory.

Invalidate mappings before dropping their backing references. For set_map
backends, publish an IOTLB without the invalidated range and keep the old
references if that fails. Do this immediately even within a batch.

Serialize vdpa_sim set_map updates with its worker so publishing a new map
cannot race an active transfer. Abort mlx5 map replacement when resumable
virtqueues cannot be suspended, since changing the memory region while
those queues remain active would preserve the same stale DMA window. Reject
zero-sized and wrapping invalidations before calculating their inclusive
range end.

I found this bug myself, though the patch was written with AI assistance.

Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
Assisted-by: OpenAI-Codex:GPT-5
Signed-off-by: Linfeng Sun <linfeng.sun.dev@gmail.com>
Message-ID: <20260911-fix-vdpa-iotlb-lifetime-v3-2-8766d371748e@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 10 +++++++-
 drivers/vdpa/vdpa_sim/vdpa_sim.c  |  3 +++
 drivers/vhost/vdpa.c              | 40 ++++++++++++++++++++++++-------
 3 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 8563fec2855d5..0fcb18b5f30ac 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -3059,7 +3059,15 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_dev *mvdev,
 	bool teardown = !is_resumable(ndev);
 	int err;
 
-	suspend_vqs(ndev, 0, ndev->cur_num_vqs);
+	if ((mvdev->status & VIRTIO_CONFIG_S_DRIVER_OK) && !mvdev->suspended) {
+		err = suspend_vqs(ndev, 0, ndev->cur_num_vqs);
+		if (err && !teardown) {
+			for (int i = 0; i < ndev->cur_num_vqs; i++)
+				resume_vqs(ndev, i, 1);
+			mlx5_vdpa_put_mr(mvdev, new_mr);
+			return err;
+		}
+	}
 	if (teardown) {
 		err = save_channels_info(ndev);
 		if (err) {
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 017366cb6684c..97d437d89524a 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -638,6 +638,7 @@ static int vdpasim_set_map(struct vdpa_device *vdpa, unsigned int asid,
 	if (asid >= vdpasim->dev_attr.nas)
 		return -EINVAL;
 
+	mutex_lock(&vdpasim->mutex);
 	spin_lock(&vdpasim->iommu_lock);
 
 	iommu = &vdpasim->iommu[asid];
@@ -652,11 +653,13 @@ static int vdpasim_set_map(struct vdpa_device *vdpa, unsigned int asid,
 			goto err;
 	}
 	spin_unlock(&vdpasim->iommu_lock);
+	mutex_unlock(&vdpasim->mutex);
 	return 0;
 
 err:
 	vhost_iotlb_reset(iommu);
 	spin_unlock(&vdpasim->iommu_lock);
+	mutex_unlock(&vdpasim->mutex);
 	return ret;
 }
 
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 6eb48cd5ac79e..5a8216f601ef1 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -998,10 +998,10 @@ static void vhost_vdpa_va_unmap(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 	struct vdpa_map_file *map_file;
 
 	while ((map = vhost_iotlb_itree_first(iotlb, start, last)) != NULL) {
+		vhost_vdpa_general_unmap(v, map, asid);
 		map_file = (struct vdpa_map_file *)map->opaque;
 		fput(map_file->file);
 		kfree(map_file);
-		vhost_vdpa_general_unmap(v, map, asid);
 		vhost_iotlb_map_free(iotlb, map);
 	}
 }
@@ -1075,21 +1075,39 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 	return 0;
 }
 
-static void vhost_vdpa_unmap(struct vhost_vdpa *v,
-			     struct vhost_iotlb *iotlb,
-			     u64 iova, u64 size)
+static int vhost_vdpa_unmap(struct vhost_vdpa *v,
+			    struct vhost_iotlb *iotlb,
+			    u64 iova, u64 size)
 {
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
+	struct vhost_iotlb_map *map;
+	struct vhost_iotlb new_iotlb;
 	u32 asid = iotlb_to_asid(iotlb);
+	u64 last = iova + size - 1;
+	int ret;
 
-	vhost_vdpa_iotlb_unmap(v, iotlb, iova, iova + size - 1, asid);
+	if (ops->set_map && !ops->dma_map) {
+		vhost_iotlb_init(&new_iotlb, iotlb->limit, iotlb->flags);
+		list_for_each_entry(map, &iotlb->list, link) {
+			if (map->start <= last && map->last >= iova)
+				continue;
+			ret = vhost_iotlb_add_range_ctx(&new_iotlb, map->start,
+							map->last, map->addr,
+							map->perm, map->opaque);
+			if (ret)
+				goto reset;
+		}
 
-	if (ops->set_map) {
-		if (!v->in_batch)
-			ops->set_map(vdpa, asid, iotlb);
+		ret = ops->set_map(vdpa, asid, &new_iotlb);
+reset:
+		vhost_iotlb_reset(&new_iotlb);
+		if (ret)
+			return ret;
 	}
 
+	vhost_vdpa_iotlb_unmap(v, iotlb, iova, last, asid);
+	return 0;
 }
 
 static int vhost_vdpa_va_map(struct vhost_vdpa *v,
@@ -1339,7 +1357,11 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
 		r = vhost_vdpa_process_iotlb_update(v, iotlb, msg);
 		break;
 	case VHOST_IOTLB_INVALIDATE:
-		vhost_vdpa_unmap(v, iotlb, msg->iova, msg->size);
+		if (!msg->size || msg->iova > U64_MAX - msg->size + 1) {
+			r = -EINVAL;
+			break;
+		}
+		r = vhost_vdpa_unmap(v, iotlb, msg->iova, msg->size);
 		break;
 	case VHOST_IOTLB_BATCH_BEGIN:
 		v->batch_asid = asid;
-- 
2.53.0



