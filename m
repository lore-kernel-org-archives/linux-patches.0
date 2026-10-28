Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216008;
	b=eOsijP/8oGAkIlUFJz4iKrn8QhE99rulajzf/r7QPhLMM7xr7IsQLWRKtq6EokEAEvIK
	 bAY/2ksFSvRnDDLHqHiGPThXKD1e2wQsQn6UiBeeDyWUrauoq7B46+tNMCgt9ASENXdHv
	 N7rEzNJoZqLzLJX8XJksjFCUe5DDa8LSFKvfJaL3sMVVqDg8pxINoEzw8GS4KoPLuIgNx
	 EIZ/hSY1kvRqdu3yoV+Wp0gbk0nsb+bP7EiEbxGIRkmheKOMEi5qUEZHJ+qE25Ha11uwP
	 qycLEP9T+W/7DK7aVF6fJ0APvqZf8U6tSH3wApH4wTWH9WrXAiByWx1c7yiroZXN+nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3eTLGZpIon9YeUl21ZH69Au+FzfF4VK25O3rq6w8W+c=;
	b=xaLYIWUkYDqVA6UsyxRc9Gn+xbkTG1BdaMKCnOhP1bemWfWkUnBiJHSb2syiIK7YljjE
	 Oe6U5+ETanUlwv5NPEA1H5tHOEFhhWwpheHxVY2ZjPk2TRj1ma9otUg0WeudcNV4epAEY
	 fSPLVcVPhWZUXpgS/98kaPJbYm80yrlk93jzNWnpWBbO7TaHrDFNsWjqhwzOJzfbgshOY
	 HvNRhPRWYa9TFfRPchKfk2DPtZKXWi4FXxCXH4R6kTHAUlviEizEjO/kMBCGvXSoT4Abx
	 Lsr2rUFtkgHjb7dAhB4OVUqEdH3hvXXVdpTIr+MV5rvGsoj6z5YFD0fIytueyEhnCeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fe96GQbE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A587606A31D;
	Wed, 28 Oct 2026 19:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fe96GQbE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0D61F01825;
	Wed, 28 Oct 2026 19:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216008;
	bh=3eTLGZpIon9YeUl21ZH69Au+FzfF4VK25O3rq6w8W+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fe96GQbENkjjy4ii117QZWEI9GZ8KgqB4b5pyQ9u8YMxP9Sl0L0GpuVki06JXNGly
	 i6xkFhrLXMcSOdqwj5J0EX0b9zixW6842nXuzB51qbGj5iDRfLGjeA3wcocO6oX7z9
	 j2SYZFKd9l7ZzPG5D3UuGdaFr1u+ecxqnHUuOiRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1407/1887] ip: orphan prefetched skbs before multicast forwarding
Date: Wed, 28 Oct 2026 17:58:23 +0100
Message-ID: <20261028170531.472303235@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit e36ce6e78fe3fc3c071a26750783b7ba081ce10d ]

IPv4 and IPv6 input preserve an skb->sk association installed by
bpf_sk_assign() so that local delivery can use the selected socket under
RCU. Both address families can also prefetch a socket in UDP early demux.
In both paths (BPF and UDP early demux) a reference is not guaranteed to
be held on the socket.

When a multicast packet is not locally deliverable, IPv6 hands the
original skb to ip6_mr_input(). IPv4's ip_mr_input() similarly keeps the
original skb when local delivery is not needed. Either path can put the
skb on an unresolved multicast route queue or forward it after the
receive-side RCU section ends.

After the prefetched socket is destroyed, a later skb free invokes
sock_pfree() and dereferences the stale skb->sk. Orphan the skb before
each non-local multicast forwarding path. Local delivery retains the
original skb; the existing skb_clone() calls provide multicast forwarding
with a socket-free clone.

Fixes: cf7fbe660f2d ("bpf: Add socket assign support")
Fixes: 08842c43d016 ("udp: no longer touch sk->sk_refcnt in early demux")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/0c52eb3d7532aaf8bccf37e0f7c922143c639735.1786552223.git.zhilinz@nebusec.ai
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipmr.c      | 3 +++
 net/ipv6/ip6_input.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index efc31dcbf4d26..dd4e8897ee9cd 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2125,6 +2125,9 @@ int ip_mr_input(struct sk_buff *skb)
 	if (IPCB(skb)->flags & IPSKB_FORWARDED)
 		goto dont_forward;
 
+	if (!local)
+		skb_orphan(skb);
+
 	mrt = ipmr_rt_fib_lookup(net, skb);
 	if (IS_ERR(mrt)) {
 		kfree_skb(skb);
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 1ba97933c74fb..26f57852e81f0 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -572,6 +572,7 @@ int ip6_mc_input(struct sk_buff *skb)
 		if (deliver)
 			skb2 = skb_clone(skb, GFP_ATOMIC);
 		else {
+			skb_orphan(skb);
 			skb2 = skb;
 			skb = NULL;
 		}
-- 
2.53.0



