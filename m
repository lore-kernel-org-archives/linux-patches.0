Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043522;
	b=yO4/vscLjqszPleNKG8fAUfO1wv5CaLe428FTdwGXNhIZwDtUTlLVJ1zc1CRHIinpXCR
	 h+SWE1jMgyM2xad1J1t5H6lpPgkneq7kW1FOJBTnn5QkAxW8TZmBTAqh32h0l/wDSVNe+
	 fxQCy1yvWuCvJUAfEHRdUqigfee6inf54JSglCOW9dczfSy31mskmYrEiKaAgb5T35XHU
	 5HMeb9vTkl72jmht7c1duaRIDFgnEgsMdzXNgscnLOK5yWTk18PQIzwVHd3YAAJCRz+i3
	 ryY5tIJJb5WlFTYUuuOLP9xaPRCH8xkfMPrsZ+xbIM+hi92uHCl0sk1Ks0+UaxID7yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d0EpG4txKjCWkBwgbRTol4HnfMUAZpAn9dwXXPlEZCs=;
	b=tFOcCd3oqN54iIWk3qCtUaCPISF/UxlKRnkaci/SPGx6Kie0v/7yj8sh0KHjkQqa+58m
	 dk06gaWPn/DPr+TMLYZMDJIDC1HlRyU+ioa1YkuxnQ+UfvqCvVSI+dSaqv5BjbhVIRYPq
	 asJo+J6IPkIx7CbFrPd+ImCMuSwU+826A/naoiE1dJjyVRE9QIhTP+yKXV7TfXTV0Tr/O
	 9D0Mg4wPbbQ80zQgrmDMgNVrBL3Z+Ob5yxjkLh8b3odDwTCM0zcU5q3QIALegG2L5IJwW
	 yvU0EPYPp+mvpkz1vqumBhiuh582XicsiPY17iGlSkbrsokLelz48rgCGWbWKDHPlCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=md9ekyS9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BFE606A325;
	Wed, 18 Nov 2026 23:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=md9ekyS9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE9C1F000C4;
	Wed, 18 Nov 2026 23:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043521;
	bh=d0EpG4txKjCWkBwgbRTol4HnfMUAZpAn9dwXXPlEZCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=md9ekyS9Kdk+qKqS0lzRjY1sCmiZKo54AwSzWraJsezcP9oxFwMb+2Gt8xwZYq0Rn
	 +oeDC8dvCvy46MlWDBHcRlx84JEhBXAKcw1hLo5gy0rvsq0PeUJjEnnlgLiFtl3wyR
	 ljBh1xuznZyqZNkJBmXc26rPWxkmVG19w1hbQgRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+06f9b2a53ba4a5a47644@syzkaller.appspotmail.com,
	Anuj Bolewar <bolewara@gmail.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0241/2857] drm/virtio: reclaim pending vbufs before tearing down vqs
Date: Wed, 18 Nov 2026 15:21:15 +0100
Message-ID: <20261118150210.127137991@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Anuj Bolewar <bolewara@gmail.com>

[ Upstream commit 61d85f99b5a55d4f717c4bb2f4c4acabf22ee3fc ]

virtio_gpu_free_vbufs() destroys the vbufs kmem_cache after the virtqueues
have already been released. Commands that were queued but never completed
by the device leave their vbuffers stranded in the virtqueue, so the cache
still holds live objects when virtio_gpu_deinit() tears everything down.
This triggers a WARNING in virtio_gpu_free_vbufs:

    BUG virtio-gpu-vbufs (Not tainted): Objects remaining in cache
    on __kmem_cache_shutdown()

Drain any buffers still sitting in the control and cursor virtqueues in
virtio_gpu_deinit() after the device has been reset and before the
virtqueues are deleted, following the same pattern used by virtio_console's
remove_vqs(). Each reclaimed buffer is released with free_vbuf(), dropping
the reference on any GEM objects it holds. Pending RESOURCE_UNREF
commands are handled as well: their resp_cb_data still references a GEM
object, so it is cleaned up with virtio_gpu_cleanup_object() to avoid
leaking it on teardown.

Reported-by: syzbot+06f9b2a53ba4a5a47644@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=06f9b2a53ba4a5a47644
Signed-off-by: Anuj Bolewar <bolewara@gmail.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patch.msgid.link/20260802-virtio-gpu-reclaim-vbufs-v2-1-5767fb860691@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_drv.h |  1 +
 drivers/gpu/drm/virtio/virtgpu_kms.c |  1 +
 drivers/gpu/drm/virtio/virtgpu_vq.c  | 15 +++++++++++++++
 3 files changed, 17 insertions(+)

diff --git a/drivers/gpu/drm/virtio/virtgpu_drv.h b/drivers/gpu/drm/virtio/virtgpu_drv.h
index 1dc92ee7fbdb7..ad0bc7bc7651f 100644
--- a/drivers/gpu/drm/virtio/virtgpu_drv.h
+++ b/drivers/gpu/drm/virtio/virtgpu_drv.h
@@ -323,6 +323,7 @@ void virtio_gpu_array_put_free_work(struct work_struct *work);
 /* virtgpu_vq.c */
 int virtio_gpu_alloc_vbufs(struct virtio_gpu_device *vgdev);
 void virtio_gpu_free_vbufs(struct virtio_gpu_device *vgdev);
+void virtio_gpu_reclaim_vbufs(struct virtio_gpu_device *vgdev);
 void virtio_gpu_cmd_create_resource(struct virtio_gpu_device *vgdev,
 				    struct virtio_gpu_object *bo,
 				    struct virtio_gpu_object_params *params,
diff --git a/drivers/gpu/drm/virtio/virtgpu_kms.c b/drivers/gpu/drm/virtio/virtgpu_kms.c
index 27b7f14dae89a..7ebabd9193b1c 100644
--- a/drivers/gpu/drm/virtio/virtgpu_kms.c
+++ b/drivers/gpu/drm/virtio/virtgpu_kms.c
@@ -280,6 +280,7 @@ void virtio_gpu_deinit(struct drm_device *dev)
 	flush_work(&vgdev->cursorq.dequeue_work);
 	flush_work(&vgdev->config_changed_work);
 	virtio_reset_device(vgdev->vdev);
+	virtio_gpu_reclaim_vbufs(vgdev);
 	vgdev->vdev->config->del_vqs(vgdev->vdev);
 }
 
diff --git a/drivers/gpu/drm/virtio/virtgpu_vq.c b/drivers/gpu/drm/virtio/virtgpu_vq.c
index 01a231d21119d..c50caf7f6c75c 100644
--- a/drivers/gpu/drm/virtio/virtgpu_vq.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vq.c
@@ -179,6 +179,21 @@ static void free_vbuf(struct virtio_gpu_device *vgdev,
 	kmem_cache_free(vgdev->vbufs, vbuf);
 }
 
+void virtio_gpu_reclaim_vbufs(struct virtio_gpu_device *vgdev)
+{
+	struct virtio_gpu_vbuffer *vbuf;
+
+	while ((vbuf = virtqueue_detach_unused_buf(vgdev->ctrlq.vq))) {
+		if (vbuf->objs)
+			virtio_gpu_array_put_free(vbuf->objs);
+		if (vbuf->resp_cb_data)
+			virtio_gpu_cleanup_object(vbuf->resp_cb_data);
+		free_vbuf(vgdev, vbuf);
+	}
+	while ((vbuf = virtqueue_detach_unused_buf(vgdev->cursorq.vq)))
+		free_vbuf(vgdev, vbuf);
+}
+
 static void reclaim_vbufs(struct virtqueue *vq, struct list_head *reclaim_list)
 {
 	struct virtio_gpu_vbuffer *vbuf;
-- 
2.53.0



