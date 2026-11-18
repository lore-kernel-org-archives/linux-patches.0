Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044111;
	b=pSXmUoIt2EwSDPB+kghCbLaiUHpftaqqGm/cXPA5ksEG/tvNKEGBD8x8YTIdzfHWwRt7
	 mQ4bsdevVbjvRrJ5vj5s4jCjpPywaSYGYQJT3rmKrBfx/ji1sMFCb8QjeNUL7+W8a9iPe
	 yjcTgSlu0ZwaXq10CHL1ZD5/PzWHyAwv0KPNoJnOyTTHhHBe/JpRsG/yXpqYGBJ3WLI1v
	 1peWtL3WFH8PuE43t4dkAYa5CLaZmvCbyK7V8JBFWsWHaGJAwfQ/yakbqtKi4O5Jeusrx
	 Fq1RNoTKKYRhXawbfXRoEDaX6lzMEX2kmpFcixMTz36zBVPH2RLssX6uxtzbHqAIQWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044111;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e/znxfPhJbjmArlLi6u+a8jpYmt46wWBvhFsMr9rL6o=;
	b=Us2UaaNn5LI8NdX/fPc6kG8onu6z0y9rEpfmdt532ZEciKm0yChM/lI88y4tdQ6gUKRv
	 dRc7peMtANXlLJ+8I+kW69tJV8dYQUUuboouDUtXhWT33eaLAYNHS0TO52KekeowvvFxe
	 6HxcthrutHDQBDM67XVizYxM7YjLpZlIHPecX6CSB9OaPNzIbvVZPezYvHAOfI0mOJf+p
	 hbGoADBv4k5u9XQJULqDcV1fd+uiB0P47Edc9ypWFKvK7h5m2L6RAvn4Svc43Qb59Ng+7
	 jVjWgslhPLD8gxKx9JvwyAuD8NlXZ+zucoWQefSEpdH4SdhjOQqIm259QC3SiYN85+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o8Lm0SeE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B5C606A320;
	Wed, 18 Nov 2026 23:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o8Lm0SeE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780E51F000C4;
	Wed, 18 Nov 2026 23:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044111;
	bh=e/znxfPhJbjmArlLi6u+a8jpYmt46wWBvhFsMr9rL6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o8Lm0SeEIVxuW0DSAKz5PocurCKmBEtSrAOqVLqVqA1ixrAYURJtXxCOy4cXyHHBu
	 5UlKt1+EwE6ldwsUA3e6RR1AbqxppLvFFk2yB5PrYZiF89gpvtwm0bila6ndJcMgBd
	 +akB9n7H+T+VmAvk1B+SmIqNYh+ZfvzIIhiiIU8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	mst@redhat.com,
	jasowangio@gmail.com,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0450/2857] virtio_net: copy zerocopy frags in start_xmit without NAPI
Date: Wed, 18 Nov 2026 15:24:44 +0100
Message-ID: <20261118150217.583489165@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 07e1a9408b6c2f9d0cfb757b67dabb52da7a32b2 ]

Virtio-net without NAPI frees completed skbs lazily on the next
start_xmit. Senders waiting for in-flight zerocopy buffers can
deadlock if they cannot transmit more packets, as then no
completed packets will be freed.

When !use_napi, virtio-net already calls skb_orphan to avoid waiting
up for transmitted skbs to be freed. For zerocopy packets that
require deep copying on orphan (i.e. those that do not set
SKBFL_DONT_ORPHAN, such as PACKET_TX_RING), call skb_orphan_frags
before orphaning to release the buffers.

This fixes the tpacket_snd slot reuse bug on skb_orphan for
virtio-net, and prevents PACKET_TX_RING from running out of slots.

This fix also touches vhost_net zerocopy packets, which also do not
set SKBFL_DONT_ORPHAN. This is fine: vhost_net packets only encounter
virtio-net in nested virtualization, and only if napi_tx is
explicitly disabled (it has been default-enabled since Linux 4.12).
In that rare case, copying the frags is desirable anyway to prevent
holding guest descriptors pinned across unbounded intervals.

This is a prerequisite for the next patch, which converts
PACKET_TX_RING to standard zerocopy completion. Without this patch
first, a bounded ring sender can stall indefinitely behind a
virtio-net virtqueue that cannot reclaim.

Fixes: 5cd8d46ea156 ("packet: copy user buffers before orphan or clone")
Cc: stable@vger.kernel.org
Cc: mst@redhat.com
Cc: jasowangio@gmail.com
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260919004748.1463985-2-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Adapted to the older start_xmit(): used dev->stats.tx_dropped++ instead of DEV_STATS_INC and added a kick_vq label before the combined kick check, dropping the extra kick assignment. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 23362ef9cb8c3..9773a64c5dba8 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1910,6 +1910,13 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 	} while (use_napi && kick &&
 	       unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
 
+	if (!use_napi &&
+	    unlikely(skb_orphan_frags(skb, GFP_ATOMIC))) {
+		dev->stats.tx_dropped++;
+		dev_kfree_skb_any(skb);
+		goto kick_vq;
+	}
+
 	/* timestamp packet in software */
 	skb_tx_timestamp(skb);
 
@@ -1960,6 +1967,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 	}
 
+kick_vq:
 	if (kick || netif_xmit_stopped(txq)) {
 		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
 			u64_stats_update_begin(&sq->stats.syncp);
-- 
2.53.0



