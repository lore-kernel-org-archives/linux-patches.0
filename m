Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830909;
	b=ecN4BB9DzWxBITovne/uJ6WQefS95Lh/Kvl+D25i/OPW09esLbCHloamxXRaSx4EcJur
	 VFJuLZ9uoJCQ/4QzMjSLfITH8jgDdP1gbUoR7NfO5r/GYPuNDLVUwLgCaH7WUNW470Tfs
	 vmhWyuCdrlf2ZL0oY6n38dEXdOAS2TS9TjhKprdoVwVt6tigUa13Q4+N1XPw9PNSKzjZM
	 3STCvZ2FSjJlzCN4afwjy/yYUF8FYm2UtwhEyWu3M9KniTzmp2PsbsNOglSuqekQP5msg
	 u3OcUDZnBkc01TLYqY6Tk9DhH4Kqwj3GwxVOSj/zyGfPVieaC3R12X46xTqqkYuxF8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830909;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rWmjd4/8b4kVe5iuGVScRstFjXhCXCSLjbc3X+EEjAw=;
	b=EBuCs7kNMBoIKAjohYCYaIBpXA59E6xxqkIKJEStre6SESNsyvXvUHE5Eq7xHUEYEWP3
	 blUc0C/PraJ2llgj5oxl8USB1qzm519k2U0Csk79ngiKURKJ+lgqsD0d4Kz0Qjfnthiiu
	 pZK+bSjcCojxf/hyZxuGpxjBPYO5B/59qvrLOvXLQJG0TjPy+IQAjTL+Jw0w/3CaMtYi2
	 FHhcdKkHk5UzdmebR+Q7WP5db4FeQsiV5vCabc2hs4wpBk8dh5ujbNPGgnjTzrsGNRYWk
	 ZR69QBPjMSi013THBCg/mc/uzF7bJOqxk4dD2sinEN7oCmprhfjx4RJlipH8+3cPKmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f8uPo6Gk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6889606A336;
	Wed,  4 Nov 2026 22:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f8uPo6Gk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D211F00919;
	Wed,  4 Nov 2026 22:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830908;
	bh=rWmjd4/8b4kVe5iuGVScRstFjXhCXCSLjbc3X+EEjAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f8uPo6Gkeewq62m8S3me1uLbVHhUvqKxw5xTCzJyMusP7WE6EnajP9gGkAtQ5TflT
	 QNCGchaPZkahBnpg9C3YNLTW8nxmnwVxJ/H1M4n8XDs1/Xf2C/G9H9DGpWnvjvFITf
	 vv6rr8AFLhMMVXheeX+KEA5fDX63GbezsWtIMtYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+06f9b2a53ba4a5a47644@syzkaller.appspotmail.com,
	Anuj Bolewar <bolewara@gmail.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0396/1005] drm/virtio: reclaim pending vbufs before tearing down vqs
Date: Wed,  4 Nov 2026 16:02:09 -0500
Message-ID: <20261104211055.163153498@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index 51b78f8a8aa2e..d52f35a09a1b0 100644
--- a/drivers/gpu/drm/virtio/virtgpu_drv.h
+++ b/drivers/gpu/drm/virtio/virtgpu_drv.h
@@ -355,6 +355,7 @@ void virtio_gpu_array_put_free_work(struct work_struct *work);
 /* virtgpu_vq.c */
 int virtio_gpu_alloc_vbufs(struct virtio_gpu_device *vgdev);
 void virtio_gpu_free_vbufs(struct virtio_gpu_device *vgdev);
+void virtio_gpu_reclaim_vbufs(struct virtio_gpu_device *vgdev);
 void virtio_gpu_cmd_create_resource(struct virtio_gpu_device *vgdev,
 				    struct virtio_gpu_object *bo,
 				    struct virtio_gpu_object_params *params,
diff --git a/drivers/gpu/drm/virtio/virtgpu_kms.c b/drivers/gpu/drm/virtio/virtgpu_kms.c
index 4a25347734fda..01ea5cd5ea7f1 100644
--- a/drivers/gpu/drm/virtio/virtgpu_kms.c
+++ b/drivers/gpu/drm/virtio/virtgpu_kms.c
@@ -289,6 +289,7 @@ void virtio_gpu_deinit(struct drm_device *dev)
 	flush_work(&vgdev->cursorq.dequeue_work);
 	flush_work(&vgdev->config_changed_work);
 	virtio_reset_device(vgdev->vdev);
+	virtio_gpu_reclaim_vbufs(vgdev);
 	vgdev->vdev->config->del_vqs(vgdev->vdev);
 }
 
diff --git a/drivers/gpu/drm/virtio/virtgpu_vq.c b/drivers/gpu/drm/virtio/virtgpu_vq.c
index 244a791ab915e..f7e7d212fc67c 100644
--- a/drivers/gpu/drm/virtio/virtgpu_vq.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vq.c
@@ -207,6 +207,21 @@ static void free_vbuf(struct virtio_gpu_device *vgdev,
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



