Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624552;
	b=gwmA/arGCNVO/D0GVmDsX7ai0/MWYib3+21pOXpsHP4Ui5j8NXhiGeQxGMzkI3q+RhoJ
	 stPFmewymY9s0qVz1+u8ieHIq7HREx4JN/eaKB0+6iXK8MzMBvyvOQumyOq98/V7oquY8
	 wzoT9nbU+dxEduqnIoA1Nqs8EomGoKPefpP1DgeUPyh6IuGvCS22reQqOShcXh/0VXgQK
	 AefihnbDJpj0kMLIEs/LvJGl8/alFtZ+rC5dKA/aAuDotiJXV39RgGpHZPvoMOTqgr+Pi
	 LaHXFfxKN0BZ0kg7zi5R2Scyfp/gwSK8EXRf5xJZTKXKYz37wlpvccpmDcQ+tx3QvRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1KEzK8KMN9+DX9sojpdcFx6QXrZP/0MolUOoduGZ86I=;
	b=Hs7KxLxmaMPvkfNHOrSvLXJO9xymG/b3aRN3lIMzaYClp9ndj6fAJ+k4oJmvd27cteMT
	 Qs/f1oNJs44N8d3tJd1lRr1nh+85PEcbnb9a8+7+cTCjxTuS8KNxQVdPq7OUDxX4RlQvQ
	 GzRp/8A3iZFcqPJKzvsSp45x5iVJm7CH+HValfyxNQgchIyOX1RjHZvXFtDjNS0yHsywO
	 6HVZ+LwVsZ7WYlRXxC3z846snWwmBZV0lqw9eDnQFqeucU74hP5vIqIuibv9rMAIZQ0FV
	 1xqFj3gf8I5QHNrD0Ivc2F/raA1u7B4Tt+69Q6yeIw6HYtGxoBgYfay2ojhUVb0rJBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="k+o+f/ac";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FC0606A339;
	Wed, 25 Nov 2026 16:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k+o+f/ac
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1A41F000CF;
	Wed, 25 Nov 2026 16:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624551;
	bh=1KEzK8KMN9+DX9sojpdcFx6QXrZP/0MolUOoduGZ86I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k+o+f/acwiUTv1Wt2nymi+Zpnw/uWl+cEg/7xBN7l2ouFnsW5H47tRHSObDBBCPXe
	 eYH4wjW0iwDamG5iaI2sUHGwCf4AUXZRPF3+lq1cvWzsX83Iml2VM3xRV62FeVWiyp
	 AaGMRA3cUuBf63wOGix94MdCfvmlX/GE2z8X+IZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 175/816] vhost-scsi: validate event queue descriptor direction
Date: Wed, 25 Nov 2026 15:28:43 +0100
Message-ID: <20261125143853.243656307@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Linfeng Sun <linfeng.sun.dev@gmail.com>

[ Upstream commit 3d8c5b714c186d08c8fe8c8cfd1f9b89525ab067 ]

vhost_get_vq_desc() returns the number of device readable (output) and
device writable (input) iovec segments. A guest can submit an eventq
descriptor chain that fills vq->iov with output segments, setting out
to ARRAY_SIZE(vq->iov) and in to zero.

When the host later queues a vhost-scsi event, vhost_scsi_do_evt_work()
uses out as the index of the first input segment. This accesses one element
beyond vq->iov and triggers an array-index-out-of-bounds report. With
panic_on_warn enabled, the report panics the host.

The event queue accepts device writable buffers only. Reject chains that
contain output segments or lack an input segment before using out as an
index. The input check prevents the out-of-bounds access, while the output
check validates the eventq descriptor direction.

I found the descriptor direction issue myself, though the patch was
written with AI assistance.  The out-of-bounds read with an
output-only chain was separately reported by Jia Jia.

Fixes: a6c9af87363c ("tcm_vhost: Add hotplug/hotunplug support")
Reported-by: Jia Jia <physicalmtea@gmail.com>
Assisted-by: OpenAI-Codex:GPT-5
Signed-off-by: Linfeng Sun <linfeng.sun.dev@gmail.com>
Message-ID: <20261009-fix-arrary-index-out-of-bounds-in-vhost_scsi_complete_events-v2-1-1f7689a54735@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index b8a726e1a2c78..c0129feba00fe 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -488,6 +488,16 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 		return;
 	}
 
+	/*
+	 * Eventq buffers are device-writable only. A nonzero in count
+	 * guarantees that out is within the bounds of vq->iov.
+	 */
+	if (unlikely(out || !in)) {
+		vq_err(vq, "Invalid event buffer: out %u, in %u\n", out, in);
+		vs->vs_events_missed = true;
+		return;
+	}
+
 	if ((vq->iov[out].iov_len != sizeof(struct virtio_scsi_event))) {
 		vq_err(vq, "Expecting virtio_scsi_event, got %zu bytes\n",
 				vq->iov[out].iov_len);
-- 
2.53.0



