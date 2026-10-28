Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207793;
	b=xcHc+LEUtSos3RN+T03IKZjbepPYCtxez/M53SZPCwiEI+8ikyF2rQ8bvWjN4GO+P0MX
	 ISmxDrexu9XHatvn8zO9U3c+3xuR0d2AritWmN8Qe6qJ8OVkuA/8oZMIp2qhXSvoo0ySZ
	 4qIaodwO3Tr3/oxrOls/hFJu02S7Exq63twMo/3b1xiPTf/EBvxW6/sLV+lWs6OQD1YO5
	 pfgdO3CuoD+boalhSExqDQAJ9QXmxnPdum0v2aGlenk2hPaRL6VQvjuNeDC5obwsxixve
	 55gju7iCSTWUWtwROc03qHiZgB3upXdMiT/xomzglaNz2CBIZsGsuxslLcyzs4beXRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fL2BEq0CEiVgzvq/6HvV0WA6VfmaUaKqNDnpZ9Jc9hQ=;
	b=OrXFxpwfZ7rbet3YXAHOZ/bWJlkT0FyQVaPPCk5Flb3kNYumIyGAGtDr/B6gX+kXZdN4
	 k0Bao5FxG9mCE3PU0DRGfs8EmLH2yz40N4QbB+sj7ROh5dnu5VWFxUvoDsIKpVYvaiVIF
	 v/2YwyP+YaYmHj/T/T9RJtDFDnCfhPUxC2+FKH1+8vfth/4n9UpAxQ9VPlbccphLpnQh9
	 QKnKI5EL5oAGT+1uBPFUqJ6zyj3ABI7CkgbG+XERyjD7snXWXNBJOt2cI8v+y4UIt/WV0
	 WvxcxdJPI8sRs8Suho4APGwwv0YVpaK4NsWoyPcetBnGWBI9crhVRjAxcaWt/u/uTlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DurfZV+J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4208606A31C;
	Wed, 28 Oct 2026 17:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DurfZV+J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F389A1F01825;
	Wed, 28 Oct 2026 17:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207792;
	bh=fL2BEq0CEiVgzvq/6HvV0WA6VfmaUaKqNDnpZ9Jc9hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DurfZV+JpjlXFCzPcJHULjnucwZDncCZuycO4BzfrgojXkSHwzvY2i5DgzA9ohibW
	 WFbT4J5qV8dwS1gzuhXsBcxf1DytnOWbyNlczqHIp0P3kPa6zbw+wZUoceGiNYxKWK
	 eFBjL/A9odkpz6ks/pdualQpVGJuTenEs65w/kIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 142/247] virtio: set skb owner of virtio_transport_reset_no_sock() reply
Date: Wed, 28 Oct 2026 17:59:05 +0100
Message-ID: <20261028165950.772393162@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Bobby Eshleman <bobbyeshleman@meta.com>

[ Upstream commit a6ae12a599e0f16bc01a38bcfe8d0278a26b5ee0 ]

Associate reply packets with the sending socket. When vsock must reply
with an RST packet and there exists a sending socket (e.g., for
loopback), setting the skb owner to the socket correctly handles
reference counting between the skb and sk (i.e., the sk stays alive
until the skb is freed).

This allows the net namespace to be used for socket lookups for the
duration of the reply skb's lifetime, preventing race conditions between
the namespace lifecycle and vsock socket search using the namespace
pointer.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
Link: https://patch.msgid.link/20260121-vsock-vmtest-v16-2-2859a7512097@meta.com
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: dee44f41f206 ("vsock/virtio: validate packet source for connected sockets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/virtio_transport_common.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 8552173aafe16..75df280bcc81f 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1313,6 +1313,12 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
 		.op = VIRTIO_VSOCK_OP_RST,
 		.type = le16_to_cpu(hdr->type),
 		.reply = true,
+
+		/* Set sk owner to socket we are replying to (may be NULL for
+		 * non-loopback). This keeps a reference to the sock and
+		 * sock_net(sk) until the reply skb is freed.
+		 */
+		.vsk = vsock_sk(skb->sk),
 	};
 	struct sk_buff *reply;
 
-- 
2.53.0



