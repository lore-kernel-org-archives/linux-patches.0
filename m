Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027493;
	b=en/yfnYUaVZVZYrH08cdtB3P+9K8ZqujE1h6hmy3B0gHmknK27D5AI5elnrDDjFS2p1Y
	 K37rA9Z9XwyzHivxcrwHAIS6r9uJBSZGoELLdXXcRwsyz0j+RoJtpTGNhcPSWeJ36/OaX
	 v2sTW6FS7SoFL19LkfuTnPbcWAeYk92X5dAaWe0i/uLGooFCuDKiLoiHFw/ua8BCSlvJF
	 7gCN2/jRm1bblrZrb1nNv5ZbpPKIn2W29UcBHGvplvWSNI7m3cfGuePQK0aOKxc2Vej4f
	 9QvWzUSVK47mOCBoM7W2V8AnSSu5jcFVOpeZUea+Zeqi7XTDWbPnFpdln1RzVDllFZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oEEouzrXDMnnsRE9gmpKsREsCqwFYYK9mkDycue0bFM=;
	b=l8iZrRaNq+NkFj4KdkMulzXOFIpRmKvp4NSRXXgECCfLndLj4bgCZqryIA5NPdsAZ94W
	 NgHpfLgSjkut28Zf5wqI2+qgOtWjg5Wszdfmfn1kF1HmjL2zoUh3FLYF5eIEVZ2PJ4Uoa
	 7GJ+HnPgp/lOl1RXwL7l1HJg57eAPZzb3S+UQMTGBovUYHZgwvESTDWoHYkvVv2yNCZGJ
	 Lejk/OcM3MZoEa7IYwsoEZbmzKHAbC1s2GEX+IyQs6t9Aa6Pggz/yV0JtiuJtzbXDypa2
	 E4WHfP0zQYwiM4BbueecKBEp98v2c9EOzhXz42tgYLWgkKkZFNHCzMAqHvzE2+5h+xQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="MTL/cMfw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F15960A260F;
	Wed, 18 Nov 2026 18:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MTL/cMfw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8BF1F000C4;
	Wed, 18 Nov 2026 18:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027493;
	bh=oEEouzrXDMnnsRE9gmpKsREsCqwFYYK9mkDycue0bFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MTL/cMfwihBfnc/oe7p3jB1uQYFDYZmCr+aqjXbl/FE/r0IbcnR9b3kivbBJ6ez6a
	 SJZFLMZOyjRp6Iu7OOFM2qZb90U5Ya8nuwrZxaErP+cJ1mDJaYUwR0WT1QhMtC6L7x
	 AtpoZTI5WhnipHZd0Nc0iZ1q1aESz/xbmH3K9470=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1808/2151] net: openvswitch: skip IPv4 later fragments on TCP/UDP set actions
Date: Wed, 18 Nov 2026 15:59:03 +0100
Message-ID: <20261118150227.669021758@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 14c0350142ab0a10ebeefed03b779df23749e16a ]

An IPv4 later fragment carries no L4 header, but key extraction leaves
ip.proto set to the real protocol and the flow may wildcard the frag
field, so validate_set() accepts such packets. set_tcp() and set_udp()
then treat the first bytes of the fragment payload as an L4 header,
rewrite them as ports and patch the bytes at the checksum offset,
corrupting the packet.

Skip these actions for OVS_FRAG_TYPE_LATER. IPv6 later fragments are not
affected, since their ip.proto is NEXTHDR_FRAGMENT and validate_set()
rejects L4 set actions for them.

Fixes: ccb1352e76cf ("net: Add Open vSwitch kernel components.")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://patch.msgid.link/20261015124749.4694-1-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/actions.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 9d9697cf63298..cbab49ecaf152 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -594,6 +594,9 @@ static int set_udp(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	__be16 src, dst;
 	int err;
 
+	if (flow_key->ip.frag == OVS_FRAG_TYPE_LATER)
+		return 0;
+
 	err = skb_ensure_writable(skb, skb_transport_offset(skb) +
 				  sizeof(struct udphdr));
 	if (unlikely(err))
@@ -637,6 +640,9 @@ static int set_tcp(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	__be16 src, dst;
 	int err;
 
+	if (flow_key->ip.frag == OVS_FRAG_TYPE_LATER)
+		return 0;
+
 	err = skb_ensure_writable(skb, skb_transport_offset(skb) +
 				  sizeof(struct tcphdr));
 	if (unlikely(err))
-- 
2.53.0



