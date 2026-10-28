Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216745;
	b=NYcw6lzQj9Wqtf02H0dSSa2bOBtqD7/XDNPRopm14Sq6dvZ3X1JpIuNtcaGnnUkTEhsc
	 D4+GIwqJ+4PlFIms4NCP1F+g+FY+syLKzuTnZYWM67iEbDHk1PCMuhWhCzBLHbEHYgJn3
	 uyT0pCidePycuNX5YaqP1uUR5pgHBunOnp8av/slCbm47uhSbc64xzwKRWNwH7KRyF92H
	 oaeGUR7eALI6tQp6kSt1A7VBrRrW4j6QmKR8+gVpS1gxImF48hE8JFazgG4v+Mq/kAP9g
	 N7AzeFmDW3TKLfdYs3DkjYLDv1W6ldaVZHmZXaCRJ/WcZFoVxEyPLGBP+6mH6jo1Z0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n9aaB6O7HNu7LaYgpT7TCyJXgmTdyEFGCtT+SyafkCw=;
	b=ULp/yqALHA7XH6o/ZdPg3uXS/oESiVdDt9D8xIAcTJEJmaz8n7ZLAxTps8VRu89cFiRb
	 jf5ueED+6AaJp1rMrQTH+2Znj1GiRhCBjBxt4c25gKYXNBLT5t0oxdIWIdmo2UxO49MNB
	 Ar1TqZTiK2+rGQa+2sSj7fJ9WQI2gPKwENwE/LKQ2JrAFGZF0M7F6VB/Bl+kDNcXQcrog
	 IXI4xNkyxLhkL8j3Le20OvpF2hYEW9BrpSBRjDoU9y9DzawM7Z1k2FEDwHukTcekzQrK1
	 +yuiV1XbmHOjVg1T+TqQcXKqbxXj/l/0qLxyR/sLL8mB5kvrYBnjXQfPy9tRoGYXGuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PL+2tnv7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75620606A31A;
	Wed, 28 Oct 2026 19:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PL+2tnv7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66C21F01828;
	Wed, 28 Oct 2026 19:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216745;
	bh=n9aaB6O7HNu7LaYgpT7TCyJXgmTdyEFGCtT+SyafkCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PL+2tnv73jS0O3JqLthMBkNWb11/50MXA7AbmhP+LY5MFGEqG0/vrwKfrZBQxrYwl
	 SMFb/OiLBblFc7y6rPBJTI1LrcO99ksvxCsivlj8V8J900h5VVIJ9TWH91UuaUuSSS
	 KQuVBWVZZqeUJ6eu060xwKyROKBAb2YxKlLtJgfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1664/1887] drm/amdkfd: Let driver decide buffer size at AMDKFD_IOC_GET_DMABUF_INFO ioctl
Date: Wed, 28 Oct 2026 18:02:40 +0100
Message-ID: <20261028170537.326670330@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaogang Chen <xiaogang.chen@amd.com>

[ Upstream commit 8242a8d9d7194d5ef8a8b38a5621ca0966a3ec15 ]

amdkfd driver needs allocate buffer to return bo metadata to user space. The
buffer size is controlled by user currently. It is a potential security issue
that hostile value (e.g. 2 GiB) lets any render-group user trigger order-MAX
allocation/OOM in kernel context.

This patch first finds bo metadata size. If the size is smaller than user
provided value drive can safely allocate buffer in kernel space and copy to
user space buffer. If not, driver will let user know, not allocate and copy.
User will redo with new buffer in user space.

This patch lets driver decide buffer allocation size to avoid potential hostile
size from user space.

Signed-off-by: Xiaogang Chen <xiaogang.chen@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f54ce9e8cbd3abe0eda3a285f54dc4f572fe589a)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c | 25 ++++++++++++++++++----
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c   | 10 ++-------
 3 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
index d58c8e452ca3f..596abe49c19c4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -495,7 +495,7 @@ void amdgpu_amdkfd_get_cu_info(struct amdgpu_device *adev, struct kfd_cu_info *c
 
 int amdgpu_amdkfd_get_dmabuf_info(struct amdgpu_device *adev, int dma_buf_fd,
 				  struct amdgpu_device **dmabuf_adev,
-				  uint64_t *bo_size, void *metadata_buffer,
+				  uint64_t *bo_size, void **metadata_buffer,
 				  size_t buffer_size, uint32_t *metadata_size,
 				  uint32_t *flags)
 {
@@ -530,9 +530,26 @@ int amdgpu_amdkfd_get_dmabuf_info(struct amdgpu_device *adev, int dma_buf_fd,
 		*dmabuf_adev = adev;
 	if (bo_size)
 		*bo_size = amdgpu_bo_size(bo);
-	if (metadata_buffer)
-		r = amdgpu_bo_get_metadata(bo, metadata_buffer, buffer_size,
-					   metadata_size, &metadata_flags);
+	if (metadata_buffer) {
+		/* first get metadata_size by buffer = NULL */
+		r = amdgpu_bo_get_metadata(bo, NULL, 0,
+					   metadata_size, NULL);
+
+		/* user buf_size is bigger than bo metadata_size
+		 * allocate a buf at kernel space and copy */
+		if (*metadata_size <= buffer_size) {
+			*metadata_buffer = kzalloc(*metadata_size, GFP_KERNEL);
+
+			if (!*metadata_buffer) {
+				r = -ENOMEM;
+				goto out_put;
+			}
+
+			r = amdgpu_bo_get_metadata(bo, *metadata_buffer, *metadata_size,
+						   NULL, &metadata_flags);
+		} else
+			r = -EINVAL;
+	}
 	if (flags) {
 		*flags = (bo->preferred_domains & AMDGPU_GEM_DOMAIN_VRAM) ?
 				KFD_IOC_ALLOC_MEM_FLAGS_VRAM
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index c7672a1d15609..86a3315098a20 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -227,7 +227,7 @@ void amdgpu_amdkfd_get_cu_info(struct amdgpu_device *adev,
 			       struct kfd_cu_info *cu_info);
 int amdgpu_amdkfd_get_dmabuf_info(struct amdgpu_device *adev, int dma_buf_fd,
 				  struct amdgpu_device **dmabuf_adev,
-				  uint64_t *bo_size, void *metadata_buffer,
+				  uint64_t *bo_size, void **metadata_buffer,
 				  size_t buffer_size, uint32_t *metadata_size,
 				  uint32_t *flags);
 uint8_t amdgpu_amdkfd_get_xgmi_hops_count(struct amdgpu_device *dst,
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 38652724f3d9a..0826f8a1da655 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1507,16 +1507,10 @@ static int kfd_ioctl_get_dmabuf_info(struct file *filep,
 	if (!dev)
 		return -EINVAL;
 
-	if (args->metadata_ptr) {
-		metadata_buffer = kzalloc(args->metadata_size, GFP_KERNEL);
-		if (!metadata_buffer)
-			return -ENOMEM;
-	}
-
 	/* Get dmabuf info from KGD */
 	r = amdgpu_amdkfd_get_dmabuf_info(dev->adev, args->dmabuf_fd,
 					  &dmabuf_adev, &args->size,
-					  metadata_buffer, args->metadata_size,
+					  &metadata_buffer, args->metadata_size,
 					  &args->metadata_size, &flags);
 	if (r)
 		goto exit;
@@ -1531,7 +1525,7 @@ static int kfd_ioctl_get_dmabuf_info(struct file *filep,
 	args->flags = flags;
 
 	/* Copy metadata buffer to user mode */
-	if (metadata_buffer) {
+	if (metadata_buffer && args->metadata_ptr) {
 		r = copy_to_user((void __user *)args->metadata_ptr,
 				 metadata_buffer, args->metadata_size);
 		if (r != 0)
-- 
2.53.0



