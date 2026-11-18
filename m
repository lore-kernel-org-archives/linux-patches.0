Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056611;
	b=isz2U4a6MI3776lUa8NH1PdGdtabvBOPmXEglYKvLlrQl9NrfEIVjCokUeXlfy1K+8eC
	 FwlqaOgtbGz2yCLGgsHhY+XefEj3jYz7leHAqv5MRFJmDCWvhaLF2uX5NQLy6pWGfegIP
	 c2ueF8ddbRUMN9awgvCYfPZS6RTmlQyGF7UDe6qbOPHtfPJ7cFrQdERdIdYewxewrbczB
	 3Bc9LgKBJPvf1RjMBMoW80+X3rzKDvVoW/DCacdCvZElWuNpHi3embthUHlWnPoFWV3ed
	 jPtKOGPHS2N/2eRo6LI1w6FYnKrrCl5oUvaLoU1JlYXZcXJXI9ptlA8m5vN/99XgsLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056611;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ie4qE98SaffCxR50TXk3k5C8fZ2hrwMq1dDT9YlUlEY=;
	b=4wzhp+teC5Y5oaCkddskjMEpy5wj/wWyukPDO8vbc1Tx4WB3N80tlLUe1NG3iu+0lHeu
	 QFw8m1ZNV7AZI8BxZOzgdPAtn9m0CjIAOHpHKhbAtTQr4h73fCgACdNVIHG8mAKyNp/0w
	 ylf3MzLgNNRkRKJAXbPtb0KenTg9AYTlWMMipyzexfKxPQM+eAkZceqSyRP0i963Bl+iB
	 rR0fkbKEUXTB/VJJ0I5/lgUqytXl0p3ob0Rr46Ws7ezEtW4X76yh8A5La+TEN6w1Pdgc6
	 Jfef4xmFGANak2E+GM2jexHfJGnXfP3IedFbHHwmhVPdmuoYOSuhc4rRjwtGMvb8TwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WQ3so9Ee;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E17E606A31C;
	Thu, 19 Nov 2026 02:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WQ3so9Ee
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B9E1F000C5;
	Thu, 19 Nov 2026 02:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056611;
	bh=ie4qE98SaffCxR50TXk3k5C8fZ2hrwMq1dDT9YlUlEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WQ3so9EewQf+soALDLdtoz6ImjpsYmrcqdVO4Hb8hC+Bhd09R0j3R1SvIZZx6P6Pv
	 PvQybk1oCBYSuix2D1oT6yG0YviDKzPJAp21JDcE46RD651urPKMBQ0D+L8O+E7hui
	 qCrb+RkLv9cW6CdY3BjA4VQI/PpZHAGDMFzG+kwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangfeng He <huangya90@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2050/2214] netfilter: flowtable: use the vlan id, not the full tci, in the tuple key
Date: Wed, 18 Nov 2026 16:02:06 +0100
Message-ID: <20261118150132.711344720@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index 8fa16be0def2a..a7fd92f8da78e 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -145,14 +145,14 @@ static void nf_flow_tuple_encap(struct sk_buff *skb,
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



