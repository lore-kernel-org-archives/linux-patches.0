Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029531;
	b=x7RWSE2BMFDj3F3J30VWXtfbmRjnuc+o+OmiVopUFQgCm5EWkrYnEFfNmidl33O8k/S/
	 YRZZGPMYg1TulAxZFLSBOpsiUcQ708ktH16sOsn6zGO04VCmQaS8YHvSClwu8EiuQsFih
	 yBNXHJDO0ElgXijMuCAGirUdapiYiVrdykPuZt8ZV7lWIxIwjbsn9QUXgWVX8XfJBJawg
	 Y9mcBeiqxW9w8AgoaXA73hU/5YB2ZJPy6J/CpT5zthdf2rj5FSnpX60flMNnKUBGSzor1
	 t66xs4+zVdIoUdyK5oCary+btlBEBbc/tZawQ2oVGALnsN0W5RnV/u1OgujdGJlD0Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029531;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2uWeBxWitYU5Up8a1s9i+tH6nv/S0a8LonNVDkJdIkI=;
	b=rqP0fpwQAzX63CohGZmu7bvn+ykoKKqZ+0wXSZEoTV5Zze3Kt20uv+HTPK/QxYoWgv1K
	 MxPadI9sSO4OCxF2t7MWJB3XrNxCru5Q04DOR1roq3caCFhaXLqevXU7AAPygV6xyMs0z
	 0aotUxmdAeN0/rHVma277wkowQ6BQ+DE26Zc9OD0LGLxwBqteqGmIcBKU3sUsRsJIiKKL
	 cLMaZS2RWkFJwf695yxxoI8BwKX5fisFKq3XHZNXNzrXt0SJZ+aXdLadZUyagBvX6fjI8
	 QHVzPK2DMFxQwxM5ye4gZ1cyeyTjDTEtfim6j88s/B4GmK88vHxlOpalL/o0X3TKl7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qS1tOlEa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B35B606A31C;
	Wed, 18 Nov 2026 19:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qS1tOlEa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911271F000C4;
	Wed, 18 Nov 2026 19:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029531;
	bh=2uWeBxWitYU5Up8a1s9i+tH6nv/S0a8LonNVDkJdIkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qS1tOlEaa/dRmmW0Q/l8Oz/xFEj2uPCMoqa+EzDBx7fDvj2j0Wxy6U8Dp5Ibd73F3
	 7wTrN30AwoB3El3YhETEy5Zt1X0Bn5qzqYZkUeNNp1dFC/xVdOMi3HWtcv0iK+7xtn
	 +B58w99AVTXGYE5a/M9hUWOAfn8BC0inoIGfNsxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jiri Pirko <jiri@resnulli.us>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0384/1756] virtio_pci_modern: move avq cleanup from reset to del_vqs
Date: Wed, 18 Nov 2026 15:41:51 +0100
Message-ID: <20261118150023.894503118@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 2a12d96dd863cb23eadf07d8845e961580b5fcdf ]

vp_modern_avq_cleanup() detaches unused buffers from the admin
virtqueue. Calling it from vp_reset() is incorrect:
virtqueue_get_buf in the avq interrupt handler can race with
virtqueue_detach_unused_buf in cleanup, and get_buf after
detach is not documented as valid.

The root cause is that detaching buffers does not belong in
reset at all - reset quiesces the device, while cleanup belongs
where the virtqueue is about to be destroyed, from del_vqs.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/virtualization/20260911125745.E0A2F1F00899@smtp.kernel.org/
Fixes: 4c3b54af907e ("virtio_pci_modern: use completion instead of busy loop to wait on admin cmd result")
Cc: Jiri Pirko <jiri@resnulli.us>
Assisted-by: LLM
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <21fe35ad7b66e2c30dbdba6fe4df4824d1c0db66.1789204858.git.mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_pci_modern.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 4fbcbc7a9ae1c..9f12af3332640 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -245,6 +245,12 @@ static void vp_modern_avq_cleanup(struct virtio_device *vdev)
 	}
 }
 
+static void vp_modern_del_vqs(struct virtio_device *vdev)
+{
+	vp_modern_avq_cleanup(vdev);
+	vp_del_vqs(vdev);
+}
+
 static void vp_transport_features(struct virtio_device *vdev, u64 features)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
@@ -439,8 +445,6 @@ static void vp_reset(struct virtio_device *vdev)
 	while (vp_modern_get_status(mdev))
 		msleep(1);
 
-	vp_modern_avq_cleanup(vdev);
-
 	/* Flush pending VQ/configuration callbacks. */
 	vp_synchronize_vectors(vdev);
 }
@@ -766,7 +770,7 @@ static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
 	.set_status	= vp_set_status,
 	.reset		= vp_reset,
 	.find_vqs	= vp_modern_find_vqs,
-	.del_vqs	= vp_del_vqs,
+	.del_vqs	= vp_modern_del_vqs,
 	.synchronize_cbs = vp_synchronize_vectors,
 	.get_features	= vp_get_features,
 	.finalize_features = vp_finalize_features,
@@ -786,7 +790,7 @@ static const struct virtio_config_ops virtio_pci_config_ops = {
 	.set_status	= vp_set_status,
 	.reset		= vp_reset,
 	.find_vqs	= vp_modern_find_vqs,
-	.del_vqs	= vp_del_vqs,
+	.del_vqs	= vp_modern_del_vqs,
 	.synchronize_cbs = vp_synchronize_vectors,
 	.get_features	= vp_get_features,
 	.finalize_features = vp_finalize_features,
-- 
2.53.0



