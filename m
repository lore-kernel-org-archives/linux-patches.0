Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625536;
	b=iO72Q//Km3U6Od9vkITfRC0hDsOXFapHDLZrtZ/X+5HnivlxdT/JWg2FBRqulp5jo9GD
	 A1eOKejczBnI9ja3HPdt6sNmr7/ueXPwuCiuMyI9ZRO1uNqmUvTXFWvtpJfD7w1Oz33lB
	 1h5CJqmQl2Ng+zVVtKXfHoSDG7QK8+59ER0KfLAjTiexHdXX1zDzoObGN+ZYrcnjVdx6G
	 Ip484QGZcJLBluIa2jBfIjFIKGNt5HSWUOvm1R40x09mhfjpAaZDoRyU0QxNfaT297Jod
	 /XnFIb2n1XQYxggANhJedceDf92kNIELtvymF2d+ZXEvG6SNfeeAnFPN9WTG1uBrITg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625536;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JT2fh0rwXSrELvj89wa6ZdbFIrfWdOTCrGecdbhQnQk=;
	b=fhqP06xtYnToYfIvNvMQvnR7qKg8JjaKMT2wz34OtQO4zZJsTGh1CoJACMyYiHrXdthC
	 F0yzZfN5z42Bm/WIVdeVkvEweHlwPdq4j+0gfjKQU2XmtypqC0XMy77xVrZLK7va/+kdv
	 zZB6uYpfM4FdMRVMHvoq/le4D8xOR3JnlEbuvVF2PC6Fya5osugL0s/qfJEPpwU+VrRUS
	 pFyba1t+5xBDqP7pCknkTk0T/keTzIT/d4UTpFtni9CtK+eiN/buo72Ho1obwK+YwNS5s
	 EX3p0AjmL0PdAWmAJt4EDcM7jUF4CSgpK7q8zx0E7Cq0Rl/Uf1XGRj6Qb0xnCfHOC7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vRwUIpO9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02903606A31E;
	Wed, 25 Nov 2026 16:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vRwUIpO9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54A91F000D0;
	Wed, 25 Nov 2026 16:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625535;
	bh=JT2fh0rwXSrELvj89wa6ZdbFIrfWdOTCrGecdbhQnQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vRwUIpO97Mhs50Rc9m4iwn6WozYD3QmxD5g/CugXzBH8VfFKnFE9LQ1GTqzYaZMAv
	 XYpYB7qwNrS2Qn3iLE8EWlaWCNhaG8DY2gd/GLGlm9nivRt70Gy4LYJBmUVmJqVEAX
	 fO+7TT1aSZGB3D5NT8l/r+bOgVrRtvaEENnqgcYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 548/816] tun: clear stale skb->protocol of NAPI frags skbs
Date: Wed, 25 Nov 2026 15:34:56 +0100
Message-ID: <20261125143901.869663768@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 3287cd714a853d9443c4a743eca010aedcfbbcdd ]

With IFF_NAPI_FRAGS, tun_napi_alloc_frags() gets its skb from
napi_get_frags(). If GRO merged the previous frame with
GRO_MERGED_FREE, that skb was recycled by napi_reuse_skb(), which does
not reset skb->protocol set by napi_frags_skb() for the previous frame.

tun_get_user() calls tun_vnet_hdr_tnl_to_skb() before eth_type_trans(),
so the virtio header checks see the protocol of the previous frame:
GSO packets without VIRTIO_NET_HDR_F_NEEDS_CSUM are dissected with the
wrong protocol. A following change checks the outer protocol of UDP
tunnel GSO packets, which would then reject a valid frame when the two
ethertypes differ.

This needs GRO to hold packets across writes, and IFF_NAPI_FRAGS needs
CAP_NET_ADMIN.

Clear skb->protocol in tun_napi_alloc_frags(), like skbs allocated
by tun_alloc_skb() or build_skb(). eth_type_trans() sets it later.

Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/netdev/179386753589.488856.11455181721004759454@kernel.org/
Suggested-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261110213628.3476051-3-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 893746d4c8d0f..e8b4d988cd330 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1484,6 +1484,12 @@ static struct sk_buff *tun_napi_alloc_frags(struct tun_file *tfile,
 	if (!skb)
 		return ERR_PTR(-ENOMEM);
 
+	/* An skb recycled by napi_reuse_skb() keeps the protocol of a
+	 * previous frame. eth_type_trans() sets it after the virtio
+	 * header checks, which must not see a stale one.
+	 */
+	skb->protocol = 0;
+
 	linear = iov_iter_single_seg_count(it);
 	err = __skb_grow(skb, linear);
 	if (err)
-- 
2.53.0



