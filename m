Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061016;
	b=3WRJa4HZlpCqpWTrsggbdAZ1n6h0vaZAxYE6GhKNEdCTTj7OcHpnCRati0G6J5v4MAEF
	 rJgG53pZ888cibR9/7SIXeIFg65nwSsnSPVwnJTkja/qis0T8Er3WJdRxlgJNu7/LW+LZ
	 1RGMF48PXAeb6Id47gNu8WU7LrRVzbiKk9jdr+R94hrdZc3tjKKdJcU47Jw5vOpEjdgyv
	 jDKQt/wbTJJIVA3YJX+SG19S2J3cNRf6E9KN9jEnlWac31oXcZsFrhcauNnUhd5WiUlMV
	 7ca9bJWGwVJVRc7PHUFjEF3bgV3gYmSarDpNdkbgT/5LPKpd4iFpGDoDCPx+juDeIBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6Al8XY2H+0b1rrFIpPCsIa+u8xx/0sEvNkdHYsMbjqI=;
	b=sy2xOLrdUX3BBqrPP0ZkMIyVoTki05rgLa3P+fECs/I5XICp1w5ONhqWCdxBbgF0fs7E
	 s5bySTyLLvC59sa8G5KnxjBdpRdrnaWZFaT5Db3qTSJIL2fG7t4UxWQlgeZfhXz/DIgUs
	 zLNQq5gD2Hwd270bNu9fq8FQfX54odPw4ZATIodgy4CMz30KB02D68Wy9IgZS4XcFvO/M
	 EE8BPAdfajL4dfhu6MlbZktFwBX9KsYQwveP+jaLEZ+8fsFl7tJZFAjssvpMCDnimBilx
	 jxltXDDWyLUzooSksXIds7/QegRr/OZ5ljns/oaJkbZQLK8skmm5fxLZiiiLZD9LLvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l5odjjbs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9413606EE9C;
	Sat,  7 Nov 2026 14:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l5odjjbs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54ECB1F0089F;
	Sat,  7 Nov 2026 14:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061015;
	bh=6Al8XY2H+0b1rrFIpPCsIa+u8xx/0sEvNkdHYsMbjqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l5odjjbs/oOIK2LcK6Xf8u+iiyOJS3mo82g+hVQAKxwtGNeWnsRJ6DHKWIeZWAQ4e
	 /VxoMyP92QIsuEtmrV6Fy3DQHuD3LqXLUgmFfU+BAD2R4tB8nRdmE5vqMJa2h9ICu4
	 wBhUL5K1xvlcf9pSjF0fLxvAskrdCn+bDbDeHRDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+06f9b2a53ba4a5a47644@syzkaller.appspotmail.com,
	Anuj Bolewar <bolewara@gmail.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0330/1536] drm/virtio: reclaim pending vbufs before tearing down vqs
Date: Sat,  7 Nov 2026 08:39:06 -0500
Message-ID: <20261107135006.973329915@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index a597c73a2bf1a..a8ff06df7e3f4 100644
--- a/drivers/gpu/drm/virtio/virtgpu_drv.h
+++ b/drivers/gpu/drm/virtio/virtgpu_drv.h
@@ -351,6 +351,7 @@ void virtio_gpu_array_put_free_work(struct work_struct *work);
 /* virtgpu_vq.c */
 int virtio_gpu_alloc_vbufs(struct virtio_gpu_device *vgdev);
 void virtio_gpu_free_vbufs(struct virtio_gpu_device *vgdev);
+void virtio_gpu_reclaim_vbufs(struct virtio_gpu_device *vgdev);
 void virtio_gpu_cmd_create_resource(struct virtio_gpu_device *vgdev,
 				    struct virtio_gpu_object *bo,
 				    struct virtio_gpu_object_params *params,
diff --git a/drivers/gpu/drm/virtio/virtgpu_kms.c b/drivers/gpu/drm/virtio/virtgpu_kms.c
index ec31a41d33d67..f402bef3998c2 100644
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
index 9bf7e69b85aa6..3a7e54d65c32a 100644
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



