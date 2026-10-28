Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210481;
	b=aRHD7mw8xOC+RrX8Xvqs0pS/CCeYOSy5+XQi0Jmgw2peTNrV6XhGHswP7Ux2K3H0v8vE
	 8YFGq8IKl8RVPnAQxNwzxYHUuIMiHcEO7UcyaJJyrYhxBJwO1zzr3t8CRImK6DVWSHnHX
	 jemAuSuIjfvLi7GuKfMspjtQzv41NwVj3NyoEzZZLVECw6zXgHoiAJTBcAkmKYQZDBT4z
	 dT6srSFUnNxUQ0D08f7sXdbu69IMV8TOZnaw7n+QQ2bSn5n1rkIinCoDhlx801VVgmdOg
	 zbA33zd8PilCwfAn2KtR1qwWmNEf9In2CadL+J9ozf2zM/AEY0qOLp7JFzo5jsDw9Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210481;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O5QJ1ffFMEDfADWzAlt15YyazsaoaFYfcx7b5oxh/Bk=;
	b=DQOugmyXaEagCXlKh6zBnkuCTipgc+ZcrvvoYa7buAFT1/aRjACHIVHddlOeA+n/mYvr
	 goJvn5sX/exMgUEgKyeTEiGklRm2vWwViOx8zI+Bd83APnygpUThQg14TMqMSGhu5ax/U
	 NrpjAKDzHmyn0BcPdqOUyH+lmJyh/WQfpmzhT1omc2hx+MamDIJey1v65xDyvWmJ5+cFJ
	 OjudaTfeyejHO7bNDMZipLVEOG9C/jhG45AQhgbZj+AYZVauhtQu5LpfCNCoPpKg9YbRL
	 ObKGhpEW6xRluKI9ntIij4C0ND8lQsEYGcpD+26VbcP99pXn1we1UCxducNjNDBAHSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g1J07NyR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EC4606A31D;
	Wed, 28 Oct 2026 18:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g1J07NyR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6790C1F01825;
	Wed, 28 Oct 2026 18:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210480;
	bh=O5QJ1ffFMEDfADWzAlt15YyazsaoaFYfcx7b5oxh/Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g1J07NyR2dxK/qwtrrUn7BbWLvrRQt4zrOex/a6CBUX3AZpcakJOEtvDdlt3DEwEX
	 M2XibpZTaHbncX7RK4p3ltejbJ1svuppC5npm7f+wVmwd/hibkQznR98LT6B0BHZ/q
	 EkGRXoxTNDQAQFmF0uFneCx7/RmUf5T5kPOEsC1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+0ea1ac045375cf05@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/571] vlan: require the MAC header to be present in __vlan_insert_inner_tag()
Date: Wed, 28 Oct 2026 17:53:09 +0100
Message-ID: <20261028170009.024886795@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
index 3728e3978f833..2759d38466663 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -346,6 +346,9 @@ static inline int __vlan_insert_inner_tag(struct sk_buff *skb,
 {
 	struct vlan_ethhdr *veth;
 
+	if (unlikely(!pskb_may_pull(skb, mac_len)))
+		return -EINVAL;
+
 	if (skb_cow_head(skb, VLAN_HLEN) < 0)
 		return -ENOMEM;
 
-- 
2.53.0



