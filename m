Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618275;
	b=M7AwWsVViPSiGXtvfyNm8eOvAEOPwVZrrd4esN3Q6FT80FIAg22cIt4PmSKULe3rMAsl
	 wcAV3bjH1wJ58uWOcZMhtGu/Os6wjKAKI9k5XzN1FNNJKz0TWmt7ACJYb00lyBJMeuH6o
	 0zQKaMvyIO+itJHOYxgJji5coDjm0alcWfEmXSbmOIHZ+wHU6OHaPTuPF9IoPARjyz8Lw
	 bTdLwKllR45SGT0hE/KccafzpDmOM1dk0+RKwH66ucNXsWrCw9wAU2ucrCy1Zq5ts9mH4
	 OSWFDZ7F6WLMqWHW+UkXWeOLRMmdWqJCmVmAV2T36xebHVZU0/hndSmRbsOmkyue7sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qG4yO1fymlgUwN3p3qKm9xyc3DB5mKmCSAI2EMyvseA=;
	b=1XPdzNy1VTSn5iTgieO4onvEppL7RGnDeHbxsvHArQGSlhme3x0/ss+wX1Bjoas8Foyn
	 D7kotm2hK4Qnq6cRzi2DOxJFp8biI3yt9S5Ka4W4IfasDaBg9pVV4/aUrA3j3OT2jxAhQ
	 4MXbpUe9zMNQcwH9RgHnB/2l8iiAXKzxv6d8xtGmqrGj6f4Pj630KIx99BWPLYrsRf7K/
	 2MYu6c18IrDrfiTclZpT/q3EcYUTzsnLaB+r/FSnBiJ7CtAm9qrxUMUBrskL0D+rbonen
	 /zeJQx3wdKk4iGKTOZDrpkaHXL4+XHaXLtVZ91m9BhFzFPZDIGXjnpHlVDSpWqGQ4WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nG4D35fV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAFD606A31E;
	Wed, 25 Nov 2026 14:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nG4D35fV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C19F1F000D0;
	Wed, 25 Nov 2026 14:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618274;
	bh=qG4yO1fymlgUwN3p3qKm9xyc3DB5mKmCSAI2EMyvseA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nG4D35fVV+HMOLgXpE7uIDpZDsg48RkUGO83eAucWY4+4AQmTSpSrXLPF3/9hnskZ
	 g9evrI9sNMlgmDlLrOEctPT+570Mfr46H6Lw0N9oTBUdl9KfcR8Zn4IjbZkFkd36Do
	 UzHaIBnSSSHKD2nJcczrKjSnb5QzABT5BCZltqWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0229/1005] vhost-scsi: validate event queue descriptor direction
Date: Wed, 25 Nov 2026 15:26:07 +0100
Message-ID: <20261125143827.103653831@linuxfoundation.org>
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
index 886a9700351bb..8a32687f7424b 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -638,6 +638,16 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
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



