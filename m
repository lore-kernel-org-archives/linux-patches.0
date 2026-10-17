Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0923C061D;
	Sat, 17 Oct 2026 16:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255514; cv=none; b=OEWH7593O9e6DEYqw0Hc+Ex8PZQZbmzDN+VTc4IHYJNc5ucuOJfkbrPVTMxWIBdNOvi1dgzslfLm+62sLET5/HPP/+tTVyv1QxjjXujxXVH0ekSEyCLeBUX+I/ZltGwosh5ynv2k6BuLA1JlJeoRTxBx4SanzfHvUvXsH0oNxfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255514; c=relaxed/simple;
	bh=/F/RxBYtI7+w0v1xhU6pv0g693zHSlrNQXkq6iQVFII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRFtJb9wCJEzELd78eIehjyaz9xIkNEHkcM3H1d3WGgE821yqxSBFc4epev6kIKIhJN+j7yEUU8KHpzZvr1bczm6NvlYVgb0Nc1IOZBo0wfoaQ1lTl4j6Jk86bLZQ2c4irOB0uVvKg6BVh39j0DP2FasilClUqwYaAlPD2GYDYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kv3kGlkU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kv3kGlkU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CDEA1F000C4;
	Sat, 17 Oct 2026 16:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255512;
	bh=44DRCGV/rKVaNGgrNgidBWJDnXc2peJv8YoXSeixMPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kv3kGlkUk0r7pOH2+2C7mIipQsiBPp/lUvugB/udKFyrfCuwkqT9xYSDMbmea8T/s
	 L/6GT5YGv/3KuBeKaFP10PGuZLqFeo8lZW0lWkozxSCnLWxG6mCDk44PBniubilJUP
	 ZOnrvYUwi/0aOD8abXNOk72Y9uK+Qbt5oYiJVnsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Hoffmann <kraxel@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Rob Clark <robdclark@gmail.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 802/869] drm/virtio: Add a helper to map and note the dma addrs and lengths
Date: Sat, 17 Oct 2026 18:00:43 +0200
Message-ID: <20261017160057.464965884@linuxfoundation.org>
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

From: Vivek Kasireddy <vivek.kasireddy@intel.com>

[ Upstream commit 25c3fd1183c0631d67cd126b2ba3e48388e15204 ]

This helper would be used when first initializing the object as
part of import and also when updating the plane where we need to
ensure that the imported object's backing is valid.

Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Gurchetan Singh <gurchetansingh@chromium.org>
Cc: Chia-I Wu <olvaffe@gmail.com>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Tested-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241126031643.3490496-3-vivek.kasireddy@intel.com
Stable-dep-of: 6a736d2f9d0c ("drm/virtio: use the DMA API for resource backing on Xen")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_drv.h   |  5 +++
 drivers/gpu/drm/virtio/virtgpu_prime.c | 42 ++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/drivers/gpu/drm/virtio/virtgpu_drv.h b/drivers/gpu/drm/virtio/virtgpu_drv.h
index ca0f7dcc99a25..c73fbb239ddc4 100644
--- a/drivers/gpu/drm/virtio/virtgpu_drv.h
+++ b/drivers/gpu/drm/virtio/virtgpu_drv.h
@@ -89,6 +89,7 @@ struct virtio_gpu_object_params {
 
 struct virtio_gpu_object {
 	struct drm_gem_shmem_object base;
+	struct sg_table *sgt;
 	uint32_t hw_res_handle;
 	bool dumb;
 	bool created;
@@ -476,6 +477,10 @@ struct drm_gem_object *virtgpu_gem_prime_import(struct drm_device *dev,
 struct drm_gem_object *virtgpu_gem_prime_import_sg_table(
 	struct drm_device *dev, struct dma_buf_attachment *attach,
 	struct sg_table *sgt);
+int virtgpu_dma_buf_import_sgt(struct virtio_gpu_mem_entry **ents,
+			       unsigned int *nents,
+			       struct virtio_gpu_object *bo,
+			       struct dma_buf_attachment *attach);
 
 /* virtgpu_debugfs.c */
 void virtio_gpu_debugfs_init(struct drm_minor *minor);
diff --git a/drivers/gpu/drm/virtio/virtgpu_prime.c b/drivers/gpu/drm/virtio/virtgpu_prime.c
index 44425f20d91aa..8e63aa67270af 100644
--- a/drivers/gpu/drm/virtio/virtgpu_prime.c
+++ b/drivers/gpu/drm/virtio/virtgpu_prime.c
@@ -27,6 +27,8 @@
 
 #include "virtgpu_drv.h"
 
+MODULE_IMPORT_NS(DMA_BUF);
+
 static int virtgpu_virtio_get_uuid(struct dma_buf *buf,
 				   uuid_t *uuid)
 {
@@ -142,6 +144,46 @@ struct dma_buf *virtgpu_gem_prime_export(struct drm_gem_object *obj,
 	return buf;
 }
 
+int virtgpu_dma_buf_import_sgt(struct virtio_gpu_mem_entry **ents,
+			       unsigned int *nents,
+			       struct virtio_gpu_object *bo,
+			       struct dma_buf_attachment *attach)
+{
+	struct scatterlist *sl;
+	struct sg_table *sgt;
+	long i, ret;
+
+	dma_resv_assert_held(attach->dmabuf->resv);
+
+	ret = dma_resv_wait_timeout(attach->dmabuf->resv,
+				    DMA_RESV_USAGE_KERNEL,
+				    false, MAX_SCHEDULE_TIMEOUT);
+	if (ret <= 0)
+		return ret < 0 ? ret : -ETIMEDOUT;
+
+	sgt = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
+	if (IS_ERR(sgt))
+		return PTR_ERR(sgt);
+
+	*ents = kvmalloc_array(sgt->nents,
+			       sizeof(struct virtio_gpu_mem_entry),
+			       GFP_KERNEL);
+	if (!(*ents)) {
+		dma_buf_unmap_attachment(attach, sgt, DMA_BIDIRECTIONAL);
+		return -ENOMEM;
+	}
+
+	*nents = sgt->nents;
+	for_each_sgtable_dma_sg(sgt, sl, i) {
+		(*ents)[i].addr = cpu_to_le64(sg_dma_address(sl));
+		(*ents)[i].length = cpu_to_le32(sg_dma_len(sl));
+		(*ents)[i].padding = 0;
+	}
+
+	bo->sgt = sgt;
+	return 0;
+}
+
 struct drm_gem_object *virtgpu_gem_prime_import(struct drm_device *dev,
 						struct dma_buf *buf)
 {
-- 
2.53.0



