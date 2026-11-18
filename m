Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027394;
	b=r+fPEnN7WldKSyS9gD800lIMZZKcHfm2IWvmJ+QKv21V8OWJ8mkz++fFV6A+CIpZXd8L
	 hOZK4FD4VT4NPmYG5MNvlK8cgCXHysFwPzPhZMGIdY/7xOq0H91fOmTx9hPxRYsFCq0+P
	 PE+gMvMzoqNMQmVBwwfqeRMCB9AuJ7OX5ikfVVWwv9Ic+UWXpyq701IcK671EDGiBDv9X
	 l5LOQ96X6iOCeLYe2S75h+Y4w0OD8TXozy85SZ3kbcvAIW1YLeosG8K5noRWujCyGwbwV
	 LFuW4dukuXNC8Whvj0HGTCc//sWSUEXeAMom46fF2O1RZ+C4nsPBPHUmL6erFo3n55g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027394;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qmutZbNS1ruEAQWfNmOhawPv+0lV+ClRRl1+PmDEo0w=;
	b=s2r1umq4/qRzuuoZuIPL0Hg7KY1yY7zMXn+Ap+EmTaL67+GAQijkPkgw4AuuZDNW2XEc
	 piSNXJG84nGjeIq8x1qOHunq7YrTK51j4tQq5KH+X79SECxAFqvu8zwDDcuthbh/BncHd
	 1ix9Srvw8t4KJj/U0HTmop/0Km9Gs4WQuDE+NgHPeysuHdSndGlhLXyR4JDknot4DJOAz
	 p7R61Yq9syM7Q9LtMr9exWAfAolcfVUwK80ypPBDYQB3h15mPcqrXHazaMZL3ILR48K1c
	 zNvknwJXskI7L7sQyi+rPnuD7LSBXUEJeGePc4o2f+wMrux3dIebekAbMM8AaCFZTjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rEMzdPBx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B6760A2619;
	Wed, 18 Nov 2026 18:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rEMzdPBx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A961F000C5;
	Wed, 18 Nov 2026 18:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027394;
	bh=qmutZbNS1ruEAQWfNmOhawPv+0lV+ClRRl1+PmDEo0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rEMzdPBx55tfymP/h5+MlYpwcjuqv/4dy7yLsBNm3E0vsrAkuXO6qZLswD9/cDB6w
	 W4HvaPtva/CGmPM2dOeoMwtqAKCQm0wKnX6t4e456w9fgJRG84GM36ULeH2Gsr9hNq
	 fosh+jg2Z9UZ9iGXd9jZU0Iwwz1Od7oHXhyJTYRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangfeng He <huangya90@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1772/2151] netfilter: flowtable: use the vlan id, not the full tci, in the tuple key
Date: Wed, 18 Nov 2026 15:58:27 +0100
Message-ID: <20261118150226.383917999@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Shuangfeng He <huangya90@gmail.com>

[ Upstream commit c203ecf905745d979de5df28fa657121f2e9342d ]

nf_flow_tuple_encap() stores the skb vlan tag in the encap tuple id
using skb_vlan_tag_get(), which returns the unmasked TCI including
the 3 PCP priority bits. The flowtable entry, however, is programmed
by nf_dev_path_info() with vlan_dev_vlan_id(), a plain 12-bit VID.

When a NIC delivers RX vlan offload skbs with a non-zero priority
(an RTL9617C EPON ONU was observed handing over vid 818 skbs with
tci 0x6332, PCP 3), the runtime lookup key never matches the
programmed entry, so every packet misses the flow table and
software flow offload is silently defeated.

Mask both parse sites to the 12-bit VID so the lookup key matches
for any priority. The in-header variant has the same problem for
frames received with PCP != 0 on a non-offload path.

The egress side is unaffected: nf_flow_encap_push() restores tags
from the programmed tuple id, which never carried priority bits.

Measured on an RTL9617C ONU (PPPoE over VLAN 818 WAN, NATed 6-flow
download over a 1G EPON line), before -> after:

  download throughput      377 Mbps -> 936 Mbps
  CPU0 %soft at that rate    91.5%  ->  70.9%

Fixes: 4cd91f7c290f ("netfilter: flowtable: add vlan support")
Signed-off-by: Shuangfeng He <huangya90@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_ip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 1be506a175af1..041d928b0bee0 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -150,14 +150,14 @@ static void nf_flow_tuple_encap(struct sk_buff *skb,
 	int i = 0;
 
 	if (skb_vlan_tag_present(skb)) {
-		tuple->encap[i].id = skb_vlan_tag_get(skb);
+		tuple->encap[i].id = skb_vlan_tag_get_id(skb);
 		tuple->encap[i].proto = skb->vlan_proto;
 		i++;
 	}
 	switch (skb->protocol) {
 	case htons(ETH_P_8021Q):
 		veth = (struct vlan_ethhdr *)skb_mac_header(skb);
-		tuple->encap[i].id = ntohs(veth->h_vlan_TCI);
+		tuple->encap[i].id = ntohs(veth->h_vlan_TCI) & VLAN_VID_MASK;
 		tuple->encap[i].proto = skb->protocol;
 		break;
 	case htons(ETH_P_PPP_SES):
-- 
2.53.0



