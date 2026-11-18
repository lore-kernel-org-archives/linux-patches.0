Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058970;
	b=2lCJdM2w4amFVj57FMThUbMdX6YtTXQAejdgaf/SwqfKtqpNCCLzKqsK5gakZqhiliEX
	 AVoo4ChofRjH45lML1W0DrBF278r5xHuGK68ud+0VBCAsYvwrsQn6AIOM3M4ZlhlVwOH7
	 keoxFfBd3QH/oqwU87DdoHhf1sFQk5EAotKeg/f5D8N4VFc2a2vAxSuoJWSiOvVZRr8Qd
	 CDw+apB9R71s5g+auMvqcAfg5uBPyWoRJt53gMr44vAu4JeLeYSJLIGfaEl1Zpzs2Hb++
	 30FGh5odXYEMzsjF6C5UcR9TFre4IEAQm58J0adgmzEp6jX9LMkZFmHmrX10wMmEf/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rApkJWeezOBk+FeQ8J+74P/9iaOaT8KJuKaJRDfF/Mg=;
	b=czSyzcsI1w+aq9ByoxOFFt/6LreVHwmBk4uKL47r/MtvtVMFDD0s9IKbx6buZ/9nxUAB
	 YFvZjzojwrrAxZ1uelA6B/BNudoWAey5C0IsHruMmQtbbTX2tz2gTJ7BigHHDGKPPwAkW
	 gvUgDSX1JdOAGGV2/jKLy7WblW3UHG1MP/mtaMHVjAU9KBTsuz2jOl5RPa8UmRaL9X9kx
	 A9THv4wOnJAjCYOnlYgaIPxrEGH31709eR/pc3av6dsxqIhmV8m9fpmDeQCOZl9/2/oGv
	 ba68Sm64nxkQlVkV7G5PFJIc2nGnbmWbHpcjBnAxaJEYcWYOrtH7pwJ2Hq/65B/tKQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rrDLJuyi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31D3606A33A;
	Thu, 19 Nov 2026 03:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rrDLJuyi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414D01F000CB;
	Thu, 19 Nov 2026 03:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058969;
	bh=rApkJWeezOBk+FeQ8J+74P/9iaOaT8KJuKaJRDfF/Mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rrDLJuyiIjIJGY8RsC4vJKu7GYoR0hbw3R7dqbdBEAFRAxhbyelcCMa3Am4qC3nOP
	 ZjKX3iaezN/yd+KU6S33y/bjNhrtcYePCHrko9U92buq69wpyuewN5tdj1VAlyEngl
	 9qRsfPFqu//PIdlX3WcaHTnfMWJ3qJKpyKkKY9gU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0676/1848] xfrm: interface: validate the IP header on xmit
Date: Wed, 18 Nov 2026 15:45:14 +0100
Message-ID: <20261118145944.147093873@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6afbbf21c0465..e16edd529bcd2 100644
--- a/net/xfrm/xfrm_interface_core.c
+++ b/net/xfrm/xfrm_interface_core.c
@@ -399,8 +399,13 @@ static netdev_tx_t xfrmi_xmit(struct sk_buff *skb, struct net_device *dev)
 
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
@@ -416,6 +421,9 @@ static netdev_tx_t xfrmi_xmit(struct sk_buff *skb, struct net_device *dev)
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



