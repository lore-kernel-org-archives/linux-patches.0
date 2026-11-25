Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619030;
	b=tPCILl0/vUL597YpuzeZdZ0oaK+h67t1uw6UFjieYAbilcm0tpnqwJffYSj2ab74ng/7
	 7IwwNMstq1mcNlZMjSkTr7YhG+Sr2ScHDF7YLs3+Kod8Suh1eNs4Di86kRFwTYqIwu1oc
	 SJEajjXT10vQn+Ech1CTv9Ed6yiu6Hl9iwTOZPv1SZhUAVSmBKwq/LbKZS/ixEFlwK1aq
	 KMn0EmOmtgzjYIw8MyBL8fKM5IREFQOmd+yRNbwX+TO7Fb2snNTvex2I6NoHNYjGIBHjr
	 5c6NN8jChUYW5zJ9LbwCvcAHAHBPQoYNRmVe/8etwlVjcWjBVy5n5WM+qR9DyMTb5Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619030;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=nmKkl0+y+4QMnY/zYJmuEJI/eLidumGoNbvMelEcNxU=;
	b=j/HNpnDm3OWGgJyxcK1Ww+yRYGE7EfiYxu1e+kmtGJ4N1vN0adAZsWNBnYIsUNluCqQd
	 MJizJ9BVitzwBqd89pM/hlwtejnyluRNFu/EtYdowNPOMRZXZpFWj+WdEtC58ZZvAUGiC
	 4LhC8rBKKkp+zR678jsEHuAVpMszfJRxouV/kTKZ/cWICkaBYKsWwR/XRfzdqofC180kX
	 6rZ1aXHvsDJZ6NLtX+AWEXOhkpRyRMC1H8BRFuDJZVQHLcKOYyOhYygGvimSR/4ywTaFp
	 TWFfHe7d/XqfGVHdn++O7zmVNf8ijj1tEs0h6ybw5HyrPDt0PzlyEPJ9pd60x03Z2Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hAjOVzZZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33403606A31E;
	Wed, 25 Nov 2026 15:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hAjOVzZZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5D11F000F4;
	Wed, 25 Nov 2026 15:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619029;
	bh=nmKkl0+y+4QMnY/zYJmuEJI/eLidumGoNbvMelEcNxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hAjOVzZZI6aPlVDr8ofpW2B7/HIWy68H+nJVilgC81W8ixDw1arylMXyEg6iJxUdg
	 IvYtm1RpLkhGPQFXRplt/sfOxK8veuMoiZjxYVsHefpTcsFB9kRtoKyoZK2WXwuJJC
	 d3OcnIUuHKpUx3mTu6HfadoTQQFdd629WrDZbziI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyi Gao <tianyi@cloudflare.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0467/1005] net: fix mac_len of skbs copied by generic XDP
Date: Wed, 25 Nov 2026 15:30:05 +0100
Message-ID: <20261125143832.685273117@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianyi Gao <tianyi@cloudflare.com>

[ Upstream commit 71578e43b8a6723025579a08a707f4975a3cd567 ]

skb_pp_cow_data() copies the header fields of the old skb with
skb_copy_header(). skb_copy_header() does not copy mac_len.

Generic XDP uses skb_pp_cow_data() for programs with frags support.
After such a program, the skb can have mac_len 0.
cpu_map_generic_redirect() and tc ingress then get the position of the
Ethernet header wrong.

Copy mac_len in skb_pp_cow_data(), as dev_map_generic_redirect() does
after skb_copy().

Fixes: e6d5dbdd20aa ("xdp: add multi-buff support for xdp running in generic mode")
Signed-off-by: Tianyi Gao <tianyi@cloudflare.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://patch.msgid.link/20261103200036.65764-3-tianyi@cloudflare.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ac78f28daea31..b24a949bd546e 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -966,6 +966,7 @@ int skb_pp_cow_data(struct page_pool *pool, struct sk_buff **pskb,
 
 	skb_reserve(nskb, headroom);
 	skb_copy_header(nskb, skb);
+	nskb->mac_len = skb->mac_len;
 	skb_mark_for_recycle(nskb);
 
 	err = skb_copy_bits(skb, 0, nskb->data, size);
-- 
2.53.0



