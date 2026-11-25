Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618041;
	b=RBBoVcwiYbrz2HlYdWeJbxg6oGuG7nenuXIxr76E2rPZkLjrTkuC4F1B9GoUgQedhlrp
	 g+s1yMyXpDO9Wu0CzJlnx4LhgLg/nhsZhws+gEnPx5P9b5V//L9W4u4mmPCYgN6+KWt/a
	 JRjaTPEd4oUvnhxGWAsZpP2NfXYfXHSw4ZoT15vh0xkRao3u1Du7/fFQZQS0pb4fgf54/
	 Bbp0CIUxoAJ12Ula/hG9xZtO4O/TGnTS098iAuSoBXLdEkySJ8Z0PDapgnKNCy6qJa7zU
	 EkiZrFkdEhdWx1tTSqo/jLFr2Y5183/4Ph7BS4XMTS2eEAGgpnNtoR1WE1lqhj3hISA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KHxaiE5b2FA1roH4UO5ZIitfCBD0QoFAAyCuyVIWm0Q=;
	b=NCxPrSEwBk7jgO8MFdTicwfXm6bM8Lioo9dyxRj/0d/JBTFIFzPcU3AUWHnn6KX3zQMa
	 CtT/R/B+5gnnfiQc0K7EXMmnwuxh0iDjnpWka9PmNLYotXm3HTkekAZMoAdeffSGrfiaA
	 H8ncB2taOUpfpdPxgcG4oWGX8PrhYVI6/SQR1H1jnxO4hTxl+wJqWkmyFnRZ+uiFqIGFi
	 WYphQJ0whNdbV/j456x90fI4VA0cKmYFSWU/3uDkWE8RTtg4hNxILpo2MqTLq5cJO3V4+
	 CmGp4uSOWpJWqrLKmSizt2dy0e+yh1xq/EK8BGht8VXDMagzh+YB2zV0yf8dWbBvTGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="P/QivG8g";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE606606A326;
	Wed, 25 Nov 2026 14:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P/QivG8g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4FE1F000C6;
	Wed, 25 Nov 2026 14:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618041;
	bh=KHxaiE5b2FA1roH4UO5ZIitfCBD0QoFAAyCuyVIWm0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P/QivG8gVhtNonjlVhh0bLd8jWEi2nE38DLxTUNm+aojDnKLGiY1c+hQJG5QkatUG
	 uEjFWZGkn5jPJOgEBK5dATBQKg71A8DUTVOxcs5Iqi2mnp6+uDZI+XDJLTEfpGkt45
	 Y+AB/s524jffR+pfqNs9bWu7rATV4OgfqLxJKLAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0153/1005] vdpa_sim: serialize IOTLB updates with dataplane access
Date: Wed, 25 Nov 2026 15:24:51 +0100
Message-ID: <20261125143825.319153175@linuxfoundation.org>
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

[ Upstream commit 8517ed4429a2eefd002dce00ea46e23e6714350b ]

The simulator translates IOTLB entries into iovecs or bvecs under
iommu_lock, then drops the lock before copying data. A concurrent DMA
unmap can delete the mapping and release its pinned backing pages while
the copy is still in progress, leading to a UAF in _copy_from_iter().

Use the existing simulator mutex to serialize DMA map changes with the
full backend work function. Also make vhost-vdpa stop device access before
unpinning the backing pages. Otherwise, waiting in the simulator DMA unmap
callback happens after the pages have already been released and cannot
protect their lifetime.

Keep iommu_lock for the IOTLB table itself and avoid adding a second
long-lived lock to the simulator.

I found this bug myself, though the patch was written with AI assistance.

Fixes: 2c53d0f64c06 ("vdpasim: vDPA device simulator")
Assisted-by: OpenAI-Codex:GPT-5
Signed-off-by: Linfeng Sun <linfeng.sun.dev@gmail.com>
Message-ID: <20260911-fix-vdpa-iotlb-lifetime-v3-1-8766d371748e@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 4 ++++
 drivers/vhost/vdpa.c             | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index cfa88a60a38fd..017366cb6684c 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -713,6 +713,7 @@ static int vdpasim_dma_map(struct vdpa_device *vdpa, unsigned int asid,
 	if (asid >= vdpasim->dev_attr.nas)
 		return -EINVAL;
 
+	mutex_lock(&vdpasim->mutex);
 	spin_lock(&vdpasim->iommu_lock);
 	if (vdpasim->iommu_pt[asid]) {
 		vhost_iotlb_reset(&vdpasim->iommu[asid]);
@@ -721,6 +722,7 @@ static int vdpasim_dma_map(struct vdpa_device *vdpa, unsigned int asid,
 	ret = vhost_iotlb_add_range_ctx(&vdpasim->iommu[asid], iova,
 					iova + size - 1, pa, perm, opaque);
 	spin_unlock(&vdpasim->iommu_lock);
+	mutex_unlock(&vdpasim->mutex);
 
 	return ret;
 }
@@ -733,6 +735,7 @@ static int vdpasim_dma_unmap(struct vdpa_device *vdpa, unsigned int asid,
 	if (asid >= vdpasim->dev_attr.nas)
 		return -EINVAL;
 
+	mutex_lock(&vdpasim->mutex);
 	spin_lock(&vdpasim->iommu_lock);
 	if (vdpasim->iommu_pt[asid]) {
 		vhost_iotlb_reset(&vdpasim->iommu[asid]);
@@ -740,6 +743,7 @@ static int vdpasim_dma_unmap(struct vdpa_device *vdpa, unsigned int asid,
 	}
 	vhost_iotlb_del_range(&vdpasim->iommu[asid], iova, iova + size - 1);
 	spin_unlock(&vdpasim->iommu_lock);
+	mutex_unlock(&vdpasim->mutex);
 
 	return 0;
 }
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index c7a9702c2447b..6eb48cd5ac79e 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -976,6 +976,8 @@ static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 	unsigned long pfn, pinned;
 
 	while ((map = vhost_iotlb_itree_first(iotlb, start, last)) != NULL) {
+		/* Stop device access before releasing the pinned pages. */
+		vhost_vdpa_general_unmap(v, map, asid);
 		pinned = PFN_DOWN(map->size);
 		for (pfn = PFN_DOWN(map->addr);
 		     pinned > 0; pfn++, pinned--) {
@@ -985,7 +987,6 @@ static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 			unpin_user_page(page);
 		}
 		atomic64_sub(PFN_DOWN(map->size), &dev->mm->pinned_vm);
-		vhost_vdpa_general_unmap(v, map, asid);
 		vhost_iotlb_map_free(iotlb, map);
 	}
 }
-- 
2.53.0



