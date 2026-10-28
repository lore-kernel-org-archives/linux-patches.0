Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215879;
	b=XjJTd51lb1Ajep85kSI9HLVrd8izYhqwHoOKTLacgvQRogDyUZG6IR+KzZJ3N2SoOTFe
	 JNMek7QD0G9JcY+aCn9xp7h1qrx3e5MtlCLkSGNGDajeP+NvzyYb4nh3Pg6XM8BwDkdKY
	 FYZBdj34zgT4OsvrKXkUVt1u29G8yRej2RBzVd9+xhSRPqItLFI+B53rtFo2ND8G+sTLT
	 D0ZvQ1gdu0JYHsaRbEgDkPLgdqZqyK/DwqAsF0MQRBkqpWEarXqbZ3TIWmUWDtnvi9Eij
	 Z7YzT69c6L4IfaJXojektW6Dp2KX+CBoOjaWlvdXK3+K+IsRM+HBcA3+W6wGBPtycog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215879;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r3NUcjmSyZo2fFhYZAgvMflxQHuH5o7T8BEcg7fyJiA=;
	b=Py5O6oQUZbW+avEX7AsD/73Pqp+11PNz1cYifFqK4a9UXxhInDw2k5HuGtnlQ7lX0AB9
	 cwzDpq2PWhiJYU5XkzfuJ/V7YM9lkuWCIPn2X5uRQXdHU3qvWMQXVEZ570huseIWZiuHy
	 RNirqPsVAU+/DsV4RPyOEshkUAkBZo5MrN9wllhpX+Z855aZ7hy5h/BboCBCibxIw9mRH
	 wYA3nwercNNEY35/CrvnRIPHh6u07FNw9rcNU5SxWBW1BKVKt2eey6lx7SpgF/2lx3qOO
	 f1K8Ku+PDN/jirjmzFm3yjd+FycqzsnM4/IGB2C6eh+U+TRhfxQmGHQpYxMz7CjhUEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EDaLZBPR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506B5606A31A;
	Wed, 28 Oct 2026 19:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EDaLZBPR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613F51F01825;
	Wed, 28 Oct 2026 19:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215878;
	bh=r3NUcjmSyZo2fFhYZAgvMflxQHuH5o7T8BEcg7fyJiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EDaLZBPRuMhZ3lwNc5RnmNT7M4nhDVMqp7jOC9mUVeGT3+Rf6pAEG0gPYyWA1hyl+
	 iUrv6f3uutU9WKbfsnvF+psW9rx/gLw7cb2rKqeH8GF37CPwd9X5J2F0TjuL773PWz
	 2G37x9ykarpScyiBg4TRv4QCaziLm1Vcj6gAhMEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1362/1887] tap: Keep hdr_len in tap_get_user()
Date: Wed, 28 Oct 2026 17:57:38 +0100
Message-ID: <20261028170530.437762955@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Akihiko Odaki <akihiko.odaki@daynix.com>

[ Upstream commit 74212f20f366db41dd3148b951284ac38ef9bb10 ]

hdr_len is repeatedly used so keep it in a local variable.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20250207-tun-v6-6-fb49cf8b103e@daynix.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: cbb35cbe8db2 ("net: tap: fix wrong transport_header when sending VLAN-tagged frame")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tap.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 5b4b07e669cd1..eb48096850b0a 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -638,6 +638,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	int err;
 	struct virtio_net_hdr vnet_hdr = { 0 };
 	int vnet_hdr_len = 0;
+	int hdr_len = 0;
 	int copylen = 0;
 	int depth;
 	bool zerocopy = false;
@@ -656,13 +657,13 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 		if (!copy_from_iter_full(&vnet_hdr, sizeof(vnet_hdr), from))
 			goto err;
 		iov_iter_advance(from, vnet_hdr_len - sizeof(vnet_hdr));
-		if ((vnet_hdr.flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
-		     tap16_to_cpu(q, vnet_hdr.csum_start) +
-		     tap16_to_cpu(q, vnet_hdr.csum_offset) + 2 >
-			     tap16_to_cpu(q, vnet_hdr.hdr_len))
-			vnet_hdr.hdr_len = cpu_to_tap16(q,
-				 tap16_to_cpu(q, vnet_hdr.csum_start) +
-				 tap16_to_cpu(q, vnet_hdr.csum_offset) + 2);
+		hdr_len = tap16_to_cpu(q, vnet_hdr.hdr_len);
+		if (vnet_hdr.flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) {
+			hdr_len = max(tap16_to_cpu(q, vnet_hdr.csum_start) +
+				      tap16_to_cpu(q, vnet_hdr.csum_offset) + 2,
+				      hdr_len);
+			vnet_hdr.hdr_len = cpu_to_tap16(q, hdr_len);
+		}
 		err = -EINVAL;
 		if (tap16_to_cpu(q, vnet_hdr.hdr_len) > len)
 			goto err;
@@ -675,12 +676,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	if (msg_control && sock_flag(&q->sk, SOCK_ZEROCOPY)) {
 		struct iov_iter i;
 
-		copylen = vnet_hdr.hdr_len ?
-			tap16_to_cpu(q, vnet_hdr.hdr_len) : GOODCOPY_LEN;
-		if (copylen > good_linear)
-			copylen = good_linear;
-		else if (copylen < ETH_HLEN)
-			copylen = ETH_HLEN;
+		copylen = clamp(hdr_len ?: GOODCOPY_LEN, ETH_HLEN, good_linear);
 		linear = copylen;
 		i = *from;
 		iov_iter_advance(&i, copylen);
@@ -690,11 +686,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 
 	if (!zerocopy) {
 		copylen = len;
-		linear = tap16_to_cpu(q, vnet_hdr.hdr_len);
-		if (linear > good_linear)
-			linear = good_linear;
-		else if (linear < ETH_HLEN)
-			linear = ETH_HLEN;
+		linear = clamp(hdr_len, ETH_HLEN, good_linear);
 	}
 
 	skb = tap_alloc_skb(&q->sk, TAP_RESERVE, copylen,
-- 
2.53.0



