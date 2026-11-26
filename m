Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705077;
	b=E5LQUG6n4NOJfKFBaIgtqUvV7fYY9p6tlTzQIjWwtwufIZg7KvZyQzB6OFUj4+eL/iWa
	 q6P0Rm7QNwqe6hTrlryMVQj7UPHQFiGDf0bujNw9M6GPW5QL1laHR7927MfrfHeIsHyoK
	 1aSxqjhpOrG/q/858cSO5y9TjJSnmsQL4J+HOxIp6ljphXxTSc1BGxcDzX8vtD2ADDPp+
	 yiYw+HCcN03uLhYEwvYl5F/9lKHvL1GomsW8NodQs00ueNdhXS98NKR/CNXZ8RIG7eWY7
	 NnnTiRunvYetnCn2lhvMttuT+dbjvo4CQCEMV0qY9enEPUMsgYOOhUUTWDmpHxBfaYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KzGKk2Jz1G7lD9DM42VoLeoxPb6E4YQyyw1tKJAswK0=;
	b=lECGE03quPyIjowh6FRTU+7WS6z/furXSXQ3dyUy2xzjMWvQtiKrylu8QIGHsH6Q+wcV
	 0S6F6DM5VWAHDzhMHA+Y81dM56F08Fl7t5wgQ7YouegUzeudxKC75Kh4e/FzySovyoQOb
	 pNQdnawZc7ZxU8BvKEUMB/lLcCxfg1lGflf+HSvJT6zTCmCRRI6a0Md66hWopFjWAdJW2
	 r/B2F6xShq99vmU37bnvBhoIXuw8f3pD3NsR2RpG3M6Sm6l9WruvlCrLHcH3o0wVb0CKu
	 k6eaKCE4L9pQjeDmUCAPvd5BgN2CcyA7xeZ4kdPa5jVbNz5ZNPXsj7mKrW/I/v18NBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IsWbCGHT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7435C606A69F;
	Thu, 26 Nov 2026 14:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IsWbCGHT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B469A1F000D3;
	Thu, 26 Nov 2026 14:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705077;
	bh=KzGKk2Jz1G7lD9DM42VoLeoxPb6E4YQyyw1tKJAswK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IsWbCGHTXwxrlpQPjm7QjqEm/V75L4IPyRY9GgXlhYhBYVao9EnGXsgYdooRxcpit
	 JDKzpjzB53PaXFmhkFA63xOzUc33MdIptlasKaEQXnEtw9np6Y/eJqGxA1jI5W82yf
	 NbD7XGGxDv3WnJ5AdycpUWC0IhEN88R1Klz4dhxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/319] vhost-scsi: validate event queue descriptor direction
Date: Thu, 26 Nov 2026 15:37:21 +0100
Message-ID: <20261126144008.387925884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 18d2b0c28c6dc..f0e259399db9f 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -487,6 +487,16 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
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



