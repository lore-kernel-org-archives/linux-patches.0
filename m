Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617980;
	b=NYooZns1FJDSxrs3+eo+f0IG+vmobKVZDVj2M3KeZL4/XZuFJoJb4HNnGO5zMKZ22Dcs
	 B4Rg//3cDzh2Q7Zbila2i+tjCRdzF7GAohaiyUDSVMxMHbTGriPDgogo1UtAaI9JgKst2
	 E8oeiR0UBw2IIbImI21gjYMnGTwrqC/NxUI215vlpLlzJ/zbCzRQCQ4gczNMQNBeAdv7r
	 dM3ZHOPFpsjzvmrkjRwXh6u+VDa6BKY9RzbpED9hIaqMuWtcL9n1SZxVeTFkNF0fVn2st
	 BN2ctGOs1s64Wyb1nym4cuR1W6xmMVw2M/Y14ZjEhajFlHc5m15Z5MFFJ1g+xjUVPFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rGGUuhkEGwopQsEpY1oUDdMRviYfAlQk7gybIUYEkgc=;
	b=3vBMi5wY7z301raOZu86ilSu+ONADZ2Hgm84no5ebFU6ZJyj4l9Qu2u0TXxNF7RGws4w
	 4NHx/j3UM5o9Hvdtt7U5ae714+i7jg6HFWhCJx7p8sW++d84WvemmL2HwWSuEPyI4P/ws
	 VChtfwX58x5Iitqo7RUPvSDT7E88bvwWssQWcyQRVH79xPPrVq85qNszbwP0XYfIesS32
	 qcL5mFOZt98vLfZQbeOfom1QFkloLFPm/Al2Jg2Yw3V5AqIeafwoDFvfSvWiRiQPZ/To6
	 2lLLaZIy2qLzCfF6AGTjiCT7YPrvo8zLYLepqW1GG6uYA4NQnJCjpB/Y9g0QYTaEHvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ywun+crl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D20606A321;
	Wed, 25 Nov 2026 14:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ywun+crl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E58E1F000CA;
	Wed, 25 Nov 2026 14:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617980;
	bh=rGGUuhkEGwopQsEpY1oUDdMRviYfAlQk7gybIUYEkgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ywun+crlI0FqnzN6sTAKP+n2PDx2EK3FHuGwgyAvZ8Fed+MJnEEcTzuN/4MDPtB5W
	 vkOD5W68Rd45PD9GNw8OV/aVW5/xZ5atSIpxep+GcidSC7WQ52Oz9YoMGpNhKHyPqZ
	 9KD0xfNpfJ7hms/y6S3krl+0JCw28deUy4Cl9Lgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0118/1005] bpf: Check the offset in bpf_skb_generic_{push,pop}()
Date: Wed, 25 Nov 2026 15:24:16 +0100
Message-ID: <20261125143824.507433256@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit ee36c9aa44ef300cd651074bd97552b229337f85 ]

To make room for len bytes at offset off, bpf_skb_generic_push() moves the
first off bytes and clears len bytes after them. It assumes that the first
off bytes are in the linear part. But in bpf_skb_adjust_room() off can be
the end of the IP header, and this header can be in a frag. Then the
function reads and writes after skb->tail, and can damage skb_shared_info.

bpf_skb_generic_pop() checks off + len, but this u32 sum can wrap to a
small value. bpf_skb_adjust_room() and bpf_skb_change_proto() calculate off
from skb_mac_header_len(). This length is a very large u32 when
network_header < mac_header. Then the check can pass, and memmove() reads
and writes far outside the skb.

Return -ENOMEM from both functions, like the present check, when
off > skb->len. Thus the sum cannot wrap. In bpf_skb_generic_push() also
pull the first off bytes into the linear part. Now bpf_skb_adjust_room()
fails when a prog grows an skb that ends before off. network_header stays
wrong.

Fixes: 6578171a7ff0 ("bpf: add bpf_skb_change_proto helper")
Fixes: 2be7e212d541 ("bpf: add bpf_skb_adjust_room helper")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-28-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index d27e73647a8df..7129e7c920a64 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3369,6 +3369,10 @@ static const struct bpf_func_proto bpf_skb_vlan_pop_proto = {
 
 static int bpf_skb_generic_push(struct sk_buff *skb, u32 off, u32 len)
 {
+	/* The bytes in front of @off are moved with skb->data. */
+	if (unlikely(off > skb->len || !pskb_may_pull(skb, off)))
+		return -ENOMEM;
+
 	/* Caller already did skb_cow() with meta_len+len as headroom,
 	 * so no need to do it here.
 	 */
@@ -3389,9 +3393,10 @@ static int bpf_skb_generic_pop(struct sk_buff *skb, u32 off, u32 len)
 	void *old_data;
 
 	/* skb_ensure_writable() is not needed here, as we're
-	 * already working on an uncloned skb.
+	 * already working on an uncloned skb. The first test
+	 * keeps off + len from wrapping.
 	 */
-	if (unlikely(!pskb_may_pull(skb, off + len)))
+	if (unlikely(off > skb->len || !pskb_may_pull(skb, off + len)))
 		return -ENOMEM;
 
 	old_data = skb->data;
-- 
2.53.0



