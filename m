Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B46E30274D;
	Wed, 28 Jan 2026 15:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615381; cv=none; b=rXnqXaMlmAkk3Wi1OpFslrh9KINjnyMY+jlBsVeeOnoUoD+NcuV9dDdcpvPHO+YX88jTTOwpZaASo97AmzznowElP9gfC5bXrsSIqAy3zylJyJ9lUvNLk9RmrInvK2I1bYjNFeFULqS1jmSTE4B38qoKPYAjsC6ldhvVLF7ep6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615381; c=relaxed/simple;
	bh=ejsACe6hwVjjBJMPbiOom7XoZXX0b8clbjQva0k/OG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WoIB+ksQBpdSjkF3v02AjhwhtH6HfyjLHP8fo1aQaMv3hZ8pDxi2h+qFwJb0++QXhVj41jk9U5UpTkWc+u2nxsrI4zm8znmSM8hjlGkw3r94oXLz4QTwb3rYhgZMKTo/v38geX8jMSAlMWz22AawXrSVCYeFt3DBK/MzqEFLB2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bT5qO1CG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bT5qO1CG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E10AC4CEF1;
	Wed, 28 Jan 2026 15:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615381;
	bh=ejsACe6hwVjjBJMPbiOom7XoZXX0b8clbjQva0k/OG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bT5qO1CGMMkHDMJ/qOkft+GHsUuwBBZsmcpPVuAicCJVdpsHlkcefuUopkCW+E0Sn
	 6UH7ma0Q+jBMgRRe13TRBh47tss8SEB6gkWohSCGKvsKd0WVLOOARkBfhfuXFMF04J
	 XtGC+0/Y33Jvez8LXE46B5SsEl0UzipCO3C9VnQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"kernel-dev@igalia.com, Heitor Alves de Siqueira" <halves@igalia.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Heitor Alves de Siqueira <halves@igalia.com>
Subject: [PATCH 6.12 163/169] vsock/virtio: Rename virtio_vsock_alloc_skb()
Date: Wed, 28 Jan 2026 16:24:06 +0100
Message-ID: <20260128145339.887737903@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will@kernel.org>

[Upstream commit 2304c64a2866c58534560c63dc6e79d09b8f8d8d]

In preparation for nonlinear allocations for large SKBs, rename
virtio_vsock_alloc_skb() to virtio_vsock_alloc_linear_skb() to indicate
that it returns linear SKBs unconditionally and switch all callers over
to this new interface for now.

No functional change.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Will Deacon <will@kernel.org>
Message-Id: <20250717090116.11987-6-will@kernel.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Heitor Alves de Siqueira <halves@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/vsock.c                   |    2 +-
 include/linux/virtio_vsock.h            |    3 ++-
 net/vmw_vsock/virtio_transport.c        |    2 +-
 net/vmw_vsock/virtio_transport_common.c |    2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -349,7 +349,7 @@ vhost_vsock_alloc_skb(struct vhost_virtq
 		return NULL;
 
 	/* len contains both payload and hdr */
-	skb = virtio_vsock_alloc_skb(len, GFP_KERNEL);
+	skb = virtio_vsock_alloc_linear_skb(len, GFP_KERNEL);
 	if (!skb)
 		return NULL;
 
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -52,7 +52,8 @@ static inline void virtio_vsock_skb_rx_p
 	skb_put(skb, len);
 }
 
-static inline struct sk_buff *virtio_vsock_alloc_skb(unsigned int size, gfp_t mask)
+static inline struct sk_buff *
+virtio_vsock_alloc_linear_skb(unsigned int size, gfp_t mask)
 {
 	struct sk_buff *skb;
 
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -316,7 +316,7 @@ static void virtio_vsock_rx_fill(struct
 	vq = vsock->vqs[VSOCK_VQ_RX];
 
 	do {
-		skb = virtio_vsock_alloc_skb(total_len, GFP_KERNEL);
+		skb = virtio_vsock_alloc_linear_skb(total_len, GFP_KERNEL);
 		if (!skb)
 			break;
 
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -263,7 +263,7 @@ static struct sk_buff *virtio_transport_
 	if (!zcopy)
 		skb_len += payload_len;
 
-	skb = virtio_vsock_alloc_skb(skb_len, GFP_KERNEL);
+	skb = virtio_vsock_alloc_linear_skb(skb_len, GFP_KERNEL);
 	if (!skb)
 		return NULL;
 


