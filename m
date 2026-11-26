Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704252;
	b=lJ7knlmreb4ZwNjQZ++GkvW8f3j7Yu2uaaJvnMw6RbAG+hivEdeupWXxHtoWmn7CcZ2F
	 OeHzIIae+AArf2YRPBljiDrnDP6AOsB4df+z2t5GEFuFeVSByKKR+uG8jIsWfKaVgb0GR
	 aAbdfJA2Mg0BbDSgJdrNc1grGlW1kuikwms3WuDbCny4VLzWFR8DQ5lvPfQJ0jytbzfCt
	 xQ1cYrrFaZTtntaW4pp68XjBzSN4Q87GAS6l9oyiW9G7UDh6/2pQCQ5VVPi5QWgnuZCX7
	 +tfsEyC4uGHiU15oL18J71yLZiHtHMzIJl6hDLgiZUyoag8Q60i5cfftaJjohUG7MWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=grWN5QTXUZpS4K0RUnivdLEO0x+5uRuXnSgrTM6va/A=;
	b=m/vV/s7XHZhE1wIBPy23ND9nVawQO1u97Yq4Ty0l0txW7Itl4HvJWlcVHU3Iq37rOOVS
	 DT7RxmHcQZjzmRa/3LvLP8t7lw86ySNhNyV+87wf+DJiu+s/FzROaCLFzJHHDbwOnlk86
	 ZEan3lA8TtYqiAJiPQJ1rBgBfPFOvei4QYZi0bKyIFD0lXF51XLz5IvdWTOaRw4jbiJfC
	 RdkoXHfyEq7I7wQyfhDOpJQ9HDc9xMmCE+IUkAwqPdXBq2QM0jsB4QiO2p352U0xsaUHr
	 XoQ8RwaNVN5aQFs6yGJSsUrfQdC3TMO7ayXVpCbjGNV/xxJfntbnAnqPOg4rshQZ+rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nFJJfGZz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D178606A31E;
	Thu, 26 Nov 2026 14:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nFJJfGZz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA27A1F000C4;
	Thu, 26 Nov 2026 14:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704252;
	bh=grWN5QTXUZpS4K0RUnivdLEO0x+5uRuXnSgrTM6va/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nFJJfGZzHkekyywh11LRLBYf1LqUVOinJ85JojrIvhdikX0xDUvHYwvLOOHPtBvHd
	 Id+maeNvejt1Bj3a9hAxr7BlgdOJmXGSYisPN2B2AFNw8k5I1sC7HVPLrRr1vSORnR
	 mQbOR7ZkWRBoqjaDzAvJXc3rCVAk1ZW/AzJ7vUA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/265] vhost-scsi: validate event queue descriptor direction
Date: Thu, 26 Nov 2026 15:36:30 +0100
Message-ID: <20261126143609.272244284@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a32520fe5a828..91d07c2224ef4 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -503,6 +503,16 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
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



