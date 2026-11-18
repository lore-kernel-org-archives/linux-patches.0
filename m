Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046198;
	b=EJeJzCt8l55aqWYXtkwKWkZb3MUyqzooF5EKT8sS/ktlLjncueFVe4EKCiDAr/t8RvdW
	 rZyaTxnTXKeaNF4hTVSuUbT2PpEyQi144f1cOPMum9k6cNGcQl3IgLm2XxpCDn6l3PhVX
	 rIzJSW8rs+iB8VYeK2Buuvh93Z/n12qv+OAVhzGDmBSGId7EHACq4iUfpt9V8KTyptzz2
	 +c/aG/gFLor+rOWr/m0Ir94fZ1Q/NZfAPutZTa3dsrEXQqtYSXJg00hFDzOvNfoKJn/Lf
	 sG/nh6ihgNlAo0nqixBzFwv+XL/yOttFSKyvSVvOcYFS1fM9Lbm/fPYzLclIQsyi8gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046198;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rhXDIMPNfWLgkvnkb9udqFBiw5KYkp9Sav6JogsGBDY=;
	b=4VfRDoGls3qxcuntpir584LHfys7Y8dxeKAOhfmXsOWkdm5/ChffcQETPG57nJvUa+lk
	 5AnfgAlUHw+uwbPBMuw+0lmPu4WWFm5dsweLflismWy7KTKiKd8WK3zel4sh+JYClyaRB
	 OLKCvOjreleaJLjmo2Z09js5+6ESnonXyo8WHLAu13oSndMbQP9N8h0RHmTZMzRX7dZPk
	 SuDdDwbyCGbO3V7R2puKgcoGut472AqkBV2trFDhaqfsE7kRLTqhG62SGQvl/OFdCe7g8
	 CC3K24S6T2GjYyVBsplSPFRd+L5ObH3e2yPYMXb1LDp8O+ERQGFsfZ6eBiH0KfJsOeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wWhi3jXd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42494606A31C;
	Wed, 18 Nov 2026 23:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wWhi3jXd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6F41F000C4;
	Wed, 18 Nov 2026 23:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046197;
	bh=rhXDIMPNfWLgkvnkb9udqFBiw5KYkp9Sav6JogsGBDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wWhi3jXda+JY1kqSp30iEr5KeJh/g8a37zmECrY3QwNX9Sx+ZQAE7BrNwnzIAHCbH
	 1rKEqGLjGgUw7e0f9nVKa8/r2nSyZ5GWnrj14c5LdIqiJwaOtFyLnf2szE7nwACZYD
	 WcjJzUTfksS9rKoMdo8kUnnLsJzycRrn8kMGlhUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1194/2857] xfrm: interface: validate the IP header on xmit
Date: Wed, 18 Nov 2026 15:37:08 +0100
Message-ID: <20261118150244.605379162@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Qihang <q.h.hack.winter@gmail.com>

[ Upstream commit 86de3a1118a16dbbbe5fabe9aa20ffb93c072ed5 ]

Packets injected into an xfrm interface (e.g. AF_PACKET on an xfrmi
device) reach the xfrm output path without IP header validation, but
xfrm4_transport_output() uses iph->ihl for __skb_pull() and memmove()
and expects the header to be valid.

vti_tunnel_xmit() already calls pskb_inet_may_pull() before handing
packets to the xfrm output path.  Do the same in xfrmi_xmit() and
perform the header checks ip_rcv_core()/ip6_rcv_core() do on entry
to the IP stack: reject wrong IP versions and malformed IPv4 header
lengths.

Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Qihang <q.h.hack.winter@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_interface_core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/xfrm/xfrm_interface_core.c b/net/xfrm/xfrm_interface_core.c
index 63d0e6e1c0c9f..7128e674da93c 100644
--- a/net/xfrm/xfrm_interface_core.c
+++ b/net/xfrm/xfrm_interface_core.c
@@ -524,8 +524,13 @@ static netdev_tx_t xfrmi_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	memset(&fl, 0, sizeof(fl));
 
+	if (!pskb_inet_may_pull(skb))
+		goto tx_err;
+
 	switch (skb->protocol) {
 	case htons(ETH_P_IPV6):
+		if (ipv6_hdr(skb)->version != 6)
+			goto tx_err;
 		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
 		xfrm_decode_session(skb, &fl, AF_INET6);
 		if (!dst) {
@@ -541,6 +546,9 @@ static netdev_tx_t xfrmi_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 		break;
 	case htons(ETH_P_IP):
+		if (ip_hdr(skb)->version != 4 || ip_hdr(skb)->ihl < 5 ||
+		    !pskb_network_may_pull(skb, ip_hdr(skb)->ihl * 4))
+			goto tx_err;
 		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
 		xfrm_decode_session(skb, &fl, AF_INET);
 		if (!dst) {
-- 
2.53.0



