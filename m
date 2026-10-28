Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212158;
	b=XA+VklJ+BllYi6z478botX+DToaXmj6JWyHzeB8uT+JT6qd1h8BhCio1TTyiCXJ3cW1s
	 QOLL7PyqPP9Iyi4xswaRrBlJwbDdFmGD50a3twR8x4kPvi1QXMUAFOGc9rjLvLhnbLb+i
	 GPd53YAM94uCkPcKw4QrJZLf63++e993kIbGav3QTu3njvKJqKBk3BW7mJ+XZ96rRp8Xe
	 TgJIg/+v+rAbDXM4LD104FQkBxLux2tW5g5KEpPrj2focCo3MpxF5bypNlNXx01sBjbGZ
	 kI+UawxWWFf4lVxJ6rLmNXcXCG9P0AFO7/VxPiS1I4DjOYsXem9ejud+U2r7FhUo6uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212158;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v8o59z722D85rtCTwpQ7NkdYyoPWRGCFP8oxUudgcdQ=;
	b=cOVcq3sR4ju/KIAA2S5Lsa0R9F9lGz/WUN1qGavf2FwMg2H+eeDP1iv0Lkf5I5k42IDE
	 WfVKOFhDKpXLXqn9aAoXpLQTuRBTkh00mZqYsYB3psvALpdLtxLTeFGpFy2NICRvIeYQp
	 +Dz0WchuvHxL07P8smkReVSw5BqfaCEv/kV1LrtQ4XS5pv0wXEx7IK0PCNPgJ9peYBybB
	 xnqKhDVRn2eWI/4gVVRxGjuENZqRiDijRwoJkmUnaJfZ2aT7bM+WSZ9ZNcsB9a6hdKKWZ
	 uigpRIDNvOAhyNYHOJ+SNPgooIspZUcf8vkd1x4TzRuEaXBF1uIV7wQ9zxqj22V6L6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kvlxdKlL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D41606A31A;
	Wed, 28 Oct 2026 18:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kvlxdKlL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884B81F01825;
	Wed, 28 Oct 2026 18:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212158;
	bh=v8o59z722D85rtCTwpQ7NkdYyoPWRGCFP8oxUudgcdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kvlxdKlLTMAo+pYtYzYi/LlJ4h0rBLEIIOSV9gih7Mu+nrXMJUe/U5CoUz0cxf5gR
	 pMlk9uZdB9ekCIyyXXzKWwkAsJlYO/6cSBny8TLwF4Hwhz5QxHGIbJAxr4GUKvurqa
	 r4OB3PRtNRmW4GU3Q8vo6uYEQLZ5PZ5yiTnSMPFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+0ea1ac045375cf05@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0056/1887] vlan: require the MAC header to be present in __vlan_insert_inner_tag()
Date: Wed, 28 Oct 2026 17:35:52 +0100
Message-ID: <20261028170500.502098627@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit ab888242fce4f16f6c4d4c6ec53939ad36aa3b3a ]

__vlan_insert_inner_tag() only guarantees head room via skb_cow_head(),
never that mac_len bytes of MAC header are present.  Its ETH_HLEN
wrappers - __vlan_insert_tag() under skb_vlan_push(), and
vlan_insert_tag() under validate_xmit_vlan() on the generic transmit
path - therefore rewrite the first 16 bytes at skb->data: a 12-byte
memmove plus two 2-byte stores at +12 and +14.  No caller supplies the
bound, while the pop helpers use skb_ensure_writable()/pskb_may_pull().

An IFF_TUN device has hard_header_len == 0, so packet_snd() accepts a
one-byte AF_PACKET/SOCK_RAW frame.  The first vlan push only sets a
hwaccel tag; the next - clsact "action vlan push" or
bpf_skb_vlan_push() - enters the helper with skb->len still 1.  The
head comes from skbuff_small_head without __GFP_ZERO, so each push
drags bytes from beyond skb->tail into the frame.  After three the
one-byte send leaves as 13 bytes carrying 11 bytes of uninitialised
slab:

  0000: 5a b3 62 12 80 88 ff ff 00 b3 62 12 81
           `------------------------------'
  only 0x5a was sent; the rest is slab, here the top 56 bits of a
  linear-map address

Require the MAC header the helper rewrites to be present, so such a
frame is dropped rather than transmitted.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: co+0ea1ac045375cf05@bugs.sh
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260915083152.705309-1-xmei5@asu.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ adjusted context around skb_cow_head(skb, VLAN_HLEN) because the branch lacks upstream meta_len handling. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/if_vlan.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index f4eb8dd7308a2..e63081a9d7db8 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -351,6 +351,9 @@ static inline int __vlan_insert_inner_tag(struct sk_buff *skb,
 {
 	struct vlan_ethhdr *veth;
 
+	if (unlikely(!pskb_may_pull(skb, mac_len)))
+		return -EINVAL;
+
 	if (skb_cow_head(skb, VLAN_HLEN) < 0)
 		return -ENOMEM;
 
-- 
2.53.0



