Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774332;
	b=DAIYmYAzKhrCeI744rodO2VM0FPZ09B2fXiAE3dhK3UM7qd0H1wxVZspNK/ZbxBUxAvL
	 jQZoZ/7j0hqRjUpDQFNnchFLEcHWJDqFAdMltyFAfXYWXxmP0SDd21WdZQmFY6OjtM5lx
	 alapXsO3Y8+zFq/mOjmWXRrzbGH6IXT2pQfjXbxA9z66vOG9fklhWYUY4Yuu9tJNjRDop
	 WdluZvFzQPHu5/zMiD1GGIlN822hySuSQ1bs2c16VFibke2fv3wqOOca1f3sp2VJIbb3L
	 TBXNYv6bi6axaQ/f/Qd09tzujyGNZf2GM/iW98jRaQ0G6XTxfSvzE3JjQHjb0wi6u9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DaB2KPRs7cVEwBjcI/GpRgvOkaBsU4J4rDgbwRJlMtI=;
	b=QsSqRGNDMIVcZekD9ROXy+8uK5BqNIN0CNa7xltNW33Do+n+unN+SbrhrgFeMrIEmUHG
	 3busdvC7gUgPjHqsQY/o6NgAzULczTxo1pQ77hNBMWZw4uI5j+SBO+xOwP+IpMpnN+cjA
	 /ZuGdVSLeqWvqvTV8ih4m619tmyxuLD2nqp1tcALuaB9z9S9txA4eWAxT4sxqbscUiDU3
	 zd/y5WjlTFFZGC1GRUo2Nlbmknv8mQc1cERhoWucPabXpda91M5bl3gQ6CaNqnJnxyz7j
	 i8c1BwdWbxN1F3N7EWvsBL4OhYKThBhwC54tJVAxhh4COkJPyGAA88L3/jcQTlc6kZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oOt32Qdv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8DA606A31A;
	Fri, 23 Oct 2026 16:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oOt32Qdv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C804C1F01825;
	Fri, 23 Oct 2026 16:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774332;
	bh=DaB2KPRs7cVEwBjcI/GpRgvOkaBsU4J4rDgbwRJlMtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oOt32Qdv6VJtlEfJMKoxWDIb5DKWbocOENACul05dHWAuQC7PFz3Rt8pLrsydiyLN
	 zJPuW5GMMII7BtuU6mcjy2s4wFUo6756xaanHOs1MiNUi06KVjnDgRrWOXJYGZ/AwP
	 qnzDS25SxX8Mv1XGmokVJhFnwz/uoOfri/rjSlOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 183/193] virtio: set skb owner of virtio_transport_reset_no_sock() reply
Date: Fri, 23 Oct 2026 18:37:40 +0200
Message-ID: <20261023163718.548674079@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport_common.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1312,6 +1312,12 @@ static int virtio_transport_reset_no_soc
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
 


