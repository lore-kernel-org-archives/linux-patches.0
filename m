Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621367;
	b=5hZ+XUMTZxNp1yY8TiUoV13/6RikrPNZz2B+auwFED06f9ow6GLZOnKMjB3Rv4dJM3em
	 0+NGBe59RByBGp86LO8VCcLmAPoc72IK71au04N2UQZHB8PLThnqlfOlaHX43RDCU9zOM
	 jAUCpg+A3AIggVKhlwpSIVldhF4J8uEs9NfvjJVSMD5xHoFGwiIB2Va+VDCv5sHLlCHKm
	 OB8g3lAoLwnxabXsatM0nYOu5tLVwbCeEnCd793bUrt923J6q6w8JVcyhiX26NpxCRX3t
	 etIpMTpkr+/8Zx/ZJ5P+vPzERecDAlzXM6CVMyMp3iumZ6TlAo/hOiJSOXxFO/x0oWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zGlUvnHPG93tv3t2R2lS8p7/Tm0Id3Ejsqj/F5dNw4o=;
	b=ZTSD9nuM/Ey2R1rK6LWTJo1zjm4UB0HwOXSqwxr9Cdp1WZmSdzrVDiZPeYSstthsC+kQ
	 a+1W8ecAYsfbtFcEw8DwnU+ZqqLr9eZ/VzmXljCK553JuyAyLrBrc29QZ5Q/tqSkc3NE4
	 2pjVlE5kJkBnnIFEc3FrzUfsjCHbXJlW3U43pZEfSCVzOchNAt8AKETSrHuXydcY23/17
	 +irSFPLIOeD1kWx86HCFO3JDWOuQTs+UG1rmmmi33hl+fN1eBaN/r6boDq7SJPPjbAcDc
	 4ZbJQgeL2CJG06wiwsOyuUcgfw2NuxCYp3zcTe3kCE6leHsNWOtp5V4j0TnubdcOWcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dTI1q2J4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346EB606A33B;
	Wed, 25 Nov 2026 15:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dTI1q2J4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC241F000D2;
	Wed, 25 Nov 2026 15:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621366;
	bh=zGlUvnHPG93tv3t2R2lS8p7/Tm0Id3Ejsqj/F5dNw4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dTI1q2J45O3H9I9J4i/vW6IZORp9unay90+w0DvAvQljpQ9Mn2H8y49EJWcuTEzC1
	 MqT9vWOMkcV9obIGnBwSYKtfFK+07iG/wevsC2ZF8sTKONcJe5Xg1+wnF6iSfMMUGm
	 sD+BOjiz3KJRUy2wr1Sb5BvEVsq3VpqroSfDBy5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 201/990] vhost-scsi: validate event queue descriptor direction
Date: Wed, 25 Nov 2026 15:26:08 +0100
Message-ID: <20261125143826.803204805@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index 4c2964dcb78c8..ba5e454ef2667 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -607,6 +607,16 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
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



