Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618698;
	b=TQiKQ1/9EyZ3/g1Q+nSyt1HA1ST98SP5LRBH/PcRjm2bBjBkHmkBF7QP3mSb8bmcL1lp
	 cLxjRvT2AO/wnU0CGEqh9/VlWkW6pmBNesEr7VpQ1ss+vW6PJVIgMf+OtE9Xz/nuQihbo
	 snylNGRmy9WSVsPveZyApCfKKrdpikRiXnGh25Qqg4B/fwrCbs69zolbaRAtFxSH+Noft
	 JLipZyXPxKWfXYYrzUMsvFa+lxA3bebL8SExOtjur7Wp5YaGOtIMNLExXGGezfnG+qdfX
	 3nN0jICp3c8aXD+gig7in/HcTaRD9/TFD7lg/W6/eSuIFlB3aAuLhX2WnRVHofJeDnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618698;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eiEa55N03UTkWF9sU9spI5NZz1E3UlFsZNHH9HlEzN8=;
	b=uh/1eVaTDZIOuiQOQL1oUAk8t4oRpeRnRoI3RnJFohX8A/oLhiLSnJ/YuqAJBB0RyKen
	 tgWae8xlmO3SXGqrP4R+daCjlKwLWawKblMWzOU0rREQTJImC2vRfv1FxgaOoZXxZS17o
	 DkKralfQfPlS1ojdWrJ33bPzzoWVIxQMRNC4hhSp847cULyyWkpoy97flCBQO1Ep0NPp8
	 Dz3+/KDU1vj0V441rbphHZk4KLsbMRRjWjLz1wnK5UKhQMVp0b5jVAXseh2M66LZgbmTf
	 4xc+mh+bEu2W2R58bANRJ0E3zB6PMb/Y6HaH8pyg30jPm85qBYnmdN2daLG6EI35orw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cKFa0tY0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A34606A31E;
	Wed, 25 Nov 2026 14:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cKFa0tY0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA981F000C6;
	Wed, 25 Nov 2026 14:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618697;
	bh=eiEa55N03UTkWF9sU9spI5NZz1E3UlFsZNHH9HlEzN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cKFa0tY0sNdQSBIl4rSN98I1uAVoZb0AZI3Om9NqFlP6ufOOCgzTIao2Uz4QC0IWH
	 I0iZc+5AJD28VHHOOrqCDP13q4vYp/cQb4TRvkfV+Udu3Pbn4IoyNPH1fWbhilYoW4
	 jivKu0HvCflBan3892/AcJEtq39ZWaLDEUh1OQW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laveesh Bansal <laveeshb@laveeshbansal.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0315/1005] netfilter: bridge: use DEBUG_NET_WARN_ON_ONCE in nf_ct_bridge_refrag()
Date: Wed, 25 Nov 2026 15:27:33 +0100
Message-ID: <20261125143829.117754150@linuxfoundation.org>
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
index b5444335b86f2..8c83dc05114ba 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -358,7 +358,7 @@ nf_ct_bridge_refrag(struct sk_buff *skb, const struct nf_hook_state *state,
 		nf_br_ip6_fragment(state->net, state->sk, skb, &data, output);
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return NF_DROP;
 	}
 
-- 
2.53.0



