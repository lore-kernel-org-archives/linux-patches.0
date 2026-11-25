Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618055;
	b=uEq0Au8PzxhbkDjbkqZVbqzkD4tF7zXnN0NV19yqiX3asR7xOj89VIGqpsRV5EJ/DeNB
	 IGGW+AqoDVrYplHZsRRQamuj4PUElT9DhgzNhW5L+x89g7A9eK8hQUa1UutB5VrbRt41h
	 /m+7+gzfyy+yLo92VXsfllPMPL5jcGdGHKohy4rfvdWjkReg2kwdvU+Frn0UcwaQzkVOR
	 OvlHaLXV5zfhcjnWf9QvkmmXkzaJ9IqWNVKSEIPF0bGReO2Ubv9TuZ2a+K3BiaqDsXdPk
	 00bqnzZC8KyAhh45kDOPIgBBGiQbtaFAAIUqBg/r/ViUMa0CbGfZWEiLvc2JGrXCSPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gwyfCh6X6JIOJZMh5YVn9TRzo07oJrJoA6dMgYE7+wQ=;
	b=ClaiSPJhZ70jJ9wyEhsrOr0u/jxVqoxqWYiuf+qyMwfmcjKiFQFwFHwddBmIwHQ9CAZ2
	 TVqOlbWQNRBd4SiX+QqmH4TF1tUo800IkQSIdLYnaWelzARnN9x5edRMdxkierMhN/Qbi
	 ciHgIgG8kc+MFAovJ/cpad9XBTu6NUhA3EwhjhVv1O80c0UtAnykDmmFzXSV9lRvPjyZo
	 kaG2Gz8DnG3kjFAPnCc7XfWBZf40s7WtH02KwLR2VQVVvpNDbuhw/xV1e7j4MVmah0l+t
	 n+DPRSzu4d5k9u2IApX52y+HV/OiOk2fziJ/9iE/y5r3azsvRCtULDDLhGNloOEueWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x3r0oV5S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325A3606A321;
	Wed, 25 Nov 2026 14:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x3r0oV5S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A571F000C0;
	Wed, 25 Nov 2026 14:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618054;
	bh=gwyfCh6X6JIOJZMh5YVn9TRzo07oJrJoA6dMgYE7+wQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x3r0oV5S6d27lDpviOX4+DbiAFLw9Y8BQ+/FKOmF++txLDbGYONDVfFmLTognUK5F
	 1HO5yrLaPHO66Ymp5MYDGi/rney4sxZGlMfGL6nfZmUMlfCpt0YaVyUazIPgJ+wxj7
	 QcZySOjWh/hiIUS5g5VYIOMQpvFdfn/awZ52341U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0156/1005] vhost-scsi: do not relock event vq mutex on send_evt fallback
Date: Wed, 25 Nov 2026 15:24:54 +0100
Message-ID: <20261125143825.392681816@linuxfoundation.org>
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

From: Jia Jia <physicalmtea@gmail.com>

[ Upstream commit a016d03a9cfe29aeeba438f32f8e8f63291e3275 ]

vhost_scsi_send_evt() is called with the event virtqueue mutex held.
If the worker is gone, the fallback currently calls
vhost_scsi_complete_events(), which tries to acquire the same mutex again
and deadlocks the caller.

Split event completion into a helper for callers that already hold the
mutex and a locking wrapper for the event worker. Use the helper on the
fallback path.

Link: https://lore.kernel.org/all/20260905005352.1E5B01F00A3D@smtp.kernel.org/
Fixes: b1b2ce58ed23 ("vhost-scsi: Handle vhost_vq_work_queue failures for events")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260915094244.7900-3-physicalmtea@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 738db166cb5db..8f57a789814f5 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -660,19 +660,26 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 	vhost_scsi_log_write(vq, vq_log, log_num);
 }
 
-static void vhost_scsi_complete_events(struct vhost_scsi *vs, bool drop)
+/* Caller must hold the event virtqueue mutex. */
+static void __vhost_scsi_complete_events(struct vhost_scsi *vs, bool drop)
 {
-	struct vhost_virtqueue *vq = &vs->vqs[VHOST_SCSI_VQ_EVT].vq;
 	struct vhost_scsi_evt *evt, *t;
 	struct llist_node *llnode;
 
-	mutex_lock(&vq->mutex);
 	llnode = llist_reverse_order(llist_del_all(&vs->vs_event_list));
 	llist_for_each_entry_safe(evt, t, llnode, list) {
 		if (!drop)
 			vhost_scsi_do_evt_work(vs, evt);
 		vhost_scsi_free_evt(vs, evt);
 	}
+}
+
+static void vhost_scsi_complete_events(struct vhost_scsi *vs, bool drop)
+{
+	struct vhost_virtqueue *vq = &vs->vqs[VHOST_SCSI_VQ_EVT].vq;
+
+	mutex_lock(&vq->mutex);
+	__vhost_scsi_complete_events(vs, drop);
 	mutex_unlock(&vq->mutex);
 }
 
@@ -1864,7 +1871,7 @@ vhost_scsi_send_evt(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
 
 	llist_add(&evt->list, &vs->vs_event_list);
 	if (!vhost_vq_work_queue(vq, &vs->vs_event_work))
-		vhost_scsi_complete_events(vs, true);
+		__vhost_scsi_complete_events(vs, true);
 }
 
 static void vhost_scsi_evt_handle_kick(struct vhost_work *work)
-- 
2.53.0



