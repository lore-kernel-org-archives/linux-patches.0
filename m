Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624558;
	b=Sldm1MvHZGK+eNdd2tiDGEUibJbWWaMkjFYoHNUc1w80tlUmkqcmjpUim4cRfGegfBWx
	 Q6/jtbVzQtzF1zgkMzYustCw9udDG8VS6A5zt9b5Q+z6nRqjtOdm8WroKER0XJUwZP55B
	 0j1tFnsSlQaWh/rgycVXLy5R0XP5vGqpdHL/czjubzRtKC5775b/FMR6dd3AnMiwF2pz5
	 GHMi0o9eXBlBpOkNJ0hVDu5huRHvdEXnJwMVUGHDaXjJh/4GIrBOBJQx/tbU+VOw6Fzl5
	 WyZuxpM9C4Piot3MLNol4K0YLTY9Iy2MpiTUpCm/vglhVDWRstxvD1J9Vus5iBqZgCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624558;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pYcv3RDfuY9U4nhjctg2wf0GtuGqOCaPg6OZhroGaBA=;
	b=Zv1nWmdTjsCKMMdu9l5RZkNcu1m3yDWTVOw3E+2sDdz5U9AG8jRd4p24/HrHIuL1uttI
	 p4LrUOmD2/HInim0WqcCxQ6B6IrbPVBDrA9m/QQYU/nRz5ItfgrGgrk6gFr9bcw30jHLW
	 WAMp01mULFEdupMEicGkbeEzWqfe1J72nQXUPrZS4F/jpXLjJFsCh166cGfU6PRmkUgHi
	 5NxnP7eOWSen3AmRVU3DpBlifK7jGltF/clLDxEUwqx4+g+X3w3UAPckqs54XoRQ7TtPm
	 APADYNMQ6pwz8Tq7XCm8GED0VMCIItwCNfdCTwzIJPH8sQjuiC7PlW/AJxoyiVbkN5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n+IiqeFF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32157606A321;
	Wed, 25 Nov 2026 16:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n+IiqeFF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB931F000D1;
	Wed, 25 Nov 2026 16:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624558;
	bh=pYcv3RDfuY9U4nhjctg2wf0GtuGqOCaPg6OZhroGaBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n+IiqeFFOD0oNlgKT+w5wrFyYs3DWAaBvVYu/+VzS5HE938K32MAeDWb2ABBOYzbm
	 sMj7RLhyZP93JqFh/27HN8Srf/ICM/zLXr8Aq9UJFgI6hmTJnuuyi5Xhva2txJKdCt
	 gm13foNwXRKKBIuo6Ryr/SGpcjNgw4KoZyU2PMvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laveesh Bansal <laveeshb@laveeshbansal.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 233/816] netfilter: bridge: use DEBUG_NET_WARN_ON_ONCE in nf_ct_bridge_refrag()
Date: Wed, 25 Nov 2026 15:29:41 +0100
Message-ID: <20261125143854.601614650@linuxfoundation.org>
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

From: Laveesh Bansal <laveeshb@laveeshbansal.com>

[ Upstream commit 683ff28ab18accb25268741a724645eee839d41a ]

nf_ct_bridge_refrag() warns when skb->protocol is neither IPv4 nor IPv6.
A vlan filtering bridge can get there with a vlan ethertype: if the
protocol of the tag of a frame differs from the vlan_protocol of the
bridge, br_allowed_ingress() moves the tag back into the packet after
NF_BR_PRE_ROUTING, where bridge conntrack has already defragmented it.

Anyone who can send fragments into a port of such a bridge can trigger the
warning, which takes the machine down with panic_on_warn. The packet is
dropped either way, so only warn on kernels built with CONFIG_DEBUG_NET.

This only avoids the warning. Such fragmented packets are still dropped.
syzbot reported the warning. It keeps triggering on CONFIG_DEBUG_NET
kernels until the vlan tag is handled, which is left for a follow-up:

  https://syzkaller.appspot.com/bug?extid=a8ba738fe2db6b4bb27f

Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
Assisted-by: LLM
Signed-off-by: Laveesh Bansal <laveeshb@laveeshbansal.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index b17962672ebfc..e7603a144538c 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -359,7 +359,7 @@ nf_ct_bridge_refrag(struct sk_buff *skb, const struct nf_hook_state *state,
 		nf_br_ip6_fragment(state->net, state->sk, skb, &data, output);
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return NF_DROP;
 	}
 
-- 
2.53.0



