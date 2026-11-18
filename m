Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016175;
	b=YiEZ9xfpWWGuuo/QsW3lQOh/1b14XUgowZn5uxLv2F95ftqTuak6NPiOV44RbHWyEqxT
	 CVjq9pJ/47bmkYtrF+eimR7rw6nvns2QTlocXC2HcWoO0vslsv+w5i9V4c5//XGcT02mk
	 u+BxqzoSuiUevOtn5PhjSejzivKnY7qWPVRUKORyCWejpST6wKRMWKDC9IEzTU56dVkxI
	 rM8oIHHH7niMw0Vcf3nb10t7I93XBhdCvjtso1xTbxYDxTNZRp1uUOiHj/6+HxTW1I2Pc
	 2vlUB4bcpYf/IjaMq3cmGJzEyoIUs7eEoIiIS5b+Liz0wIJh6GmZxEQkhGztOIVybfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RquJmRFsmQhltKe023GDgLOHsOl1I4+ARtEuXj7N+rY=;
	b=wIe1nuFL99l8ztjiqvVRnJkZzYJv60VISwah/m+YugW4m0cOJk4AWHhn+uVo3CTaH8tc
	 LfSuZkDtpZLiEfgh4fQrqZYLHJI/vsdJw41r7yJ9LaFws/JFSYt4Nr669XeSoB1ivVb9Y
	 q/IuHHaRtNtc89d4G6LaLZeJCgd4wPFxWRwkjdYCRGFmxYf24C6i8SwKnKyOQ+RnLEiGI
	 Xx1FjlLib2HCleYNcbkP5WD0gGqFhNxjfZVsVcj71vI+1XMlS31i6KnsuNnlkx5HmgcE2
	 dEs1xJD+Zqq+k+WPAxae/HV7Gji9Q7itE46fJ5kp3fhX/oIvV9sSGvgPjtLPiZUoLtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Osg0hSnW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48D6606A320;
	Wed, 18 Nov 2026 15:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Osg0hSnW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5671F000C4;
	Wed, 18 Nov 2026 15:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016175;
	bh=RquJmRFsmQhltKe023GDgLOHsOl1I4+ARtEuXj7N+rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Osg0hSnWnhUpTPXWz1dMWqCXvuiiCF7Wqr0ciaQozRpjLbHyrf+W0T1YnPscNH45E
	 f5JI02JeXVgTaxoZ9KT0wsITGZehT+hBEAdwKaje6KB82GKFrT91RmUMh2R6kytZG1
	 YFoFWdFxihz4mi6tL8C/f0ADOAj1UZCqsODdyHEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jiri Pirko <jiri@resnulli.us>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0437/2651] virtio_pci_modern: move avq cleanup from reset to del_vqs
Date: Wed, 18 Nov 2026 15:27:57 +0100
Message-ID: <20261118150303.558974166@linuxfoundation.org>
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
index 6d8ae2a6a8caf..b4249afd7f580 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -364,6 +364,12 @@ static void vp_modern_avq_cleanup(struct virtio_device *vdev)
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
@@ -558,8 +564,6 @@ static void vp_reset(struct virtio_device *vdev)
 	while (vp_modern_get_status(mdev))
 		msleep(1);
 
-	vp_modern_avq_cleanup(vdev);
-
 	/* Flush pending VQ/configuration callbacks. */
 	vp_synchronize_vectors(vdev);
 }
@@ -1232,7 +1236,7 @@ static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
 	.set_status	= vp_set_status,
 	.reset		= vp_reset,
 	.find_vqs	= vp_modern_find_vqs,
-	.del_vqs	= vp_del_vqs,
+	.del_vqs	= vp_modern_del_vqs,
 	.synchronize_cbs = vp_synchronize_vectors,
 	.get_extended_features = vp_get_features,
 	.finalize_features = vp_finalize_features,
@@ -1252,7 +1256,7 @@ static const struct virtio_config_ops virtio_pci_config_ops = {
 	.set_status	= vp_set_status,
 	.reset		= vp_reset,
 	.find_vqs	= vp_modern_find_vqs,
-	.del_vqs	= vp_del_vqs,
+	.del_vqs	= vp_modern_del_vqs,
 	.synchronize_cbs = vp_synchronize_vectors,
 	.get_extended_features = vp_get_features,
 	.finalize_features = vp_finalize_features,
-- 
2.53.0



