Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621632;
	b=BLv/2sL4Uvw7b2HdC1n5Nhs1weD9noEnCEzqWdDGil/PwrblSgu/+Zyt0Qfe0OU3L5AV
	 F1NAJD+c9WQ4HypIchqZ0LOgWV+t/Nz9EVwLZ+mLxxm1Wpmdn38y+bDh47Z4femGOVqwE
	 2m5EhpoWb0hmsBSlbSRbs8xnmdmbSkdyf1msIpdzrHo7kUVDXF9IPOFje7Qt6V0hDlLIb
	 HrH5wumiODMd6TD0zXcW7D9DBXqDOQE6yYGAoFEKgukF39l2Y9fqy5uey1Z+mKuVt3rMf
	 7mPAUZiaTM7qxTHak/3f+9HI7GBuOGYy3CONNR9BQtvwprncqoR03PLlN28BWTi1prA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rO4+/3DKKXHK+DcWKw0dpcIGJ3m4+iceqFomnUf9lC8=;
	b=aPJ0M4+d0R8nH8ob2fLOhh+o9J2SkXGYsHS20MFi4Pwd4wOz0NC3ZNrCpvKw/4r2mp2h
	 OKvFjBAdcvOCDV184xICuMs4rpOAPKGGfOoFhB/UB9aM94LdvyGUJve4bkcXmKyuhVupU
	 9yxTmYsKZs4e3H0tW+PxYGpUHXoveIcwGMOd2zCcQRRUrjmTbQ3PDriBUPSIZ6rEMtYgh
	 oP92Zow7WNpb/Ja1jBRZU73sFgo7G1aA+2MzjAONIWwfzDnZHb/reTSlJP9KTyLVeEFuX
	 PjKKJlyqTdDa8RmPVO9YQv0lN9+L1HncNoqFxNvqRiEFUkHI2zFqIi8K2sxOPeErGag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="MIPQT6S/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B948606A31E;
	Wed, 25 Nov 2026 15:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MIPQT6S/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20F41F000C6;
	Wed, 25 Nov 2026 15:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621632;
	bh=rO4+/3DKKXHK+DcWKw0dpcIGJ3m4+iceqFomnUf9lC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MIPQT6S/XWpcBCfRf8yWnWnyvXR4krTfFJcL8h4lu4SrGMtVI9ChWmUWwWzLkPCI8
	 DnGZZKjzeeEeVKfhqZm0SwTw0YTlkxKIPUmFhewnpnxt9NajC4JXsYXp2Te4MNckh/
	 VvhEbRiWu1cEBWAxBoClFEsRzYMtK8W8xtbki3hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laveesh Bansal <laveeshb@laveeshbansal.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 286/990] netfilter: bridge: use DEBUG_NET_WARN_ON_ONCE in nf_ct_bridge_refrag()
Date: Wed, 25 Nov 2026 15:27:33 +0100
Message-ID: <20261125143828.786692936@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



