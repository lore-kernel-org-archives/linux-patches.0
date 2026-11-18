Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057716;
	b=YAcuNhKw70PMJ7voI/j+G+WqU+wF/gF+DZpcqFWnmARISHfgrEa+uaL/6KsU/W8lPwHH
	 Gbs9Wn/a11R+fCxSAllouL8DdP7qDgypjiWya0IxiKXLV/x5OFc4bOQCoU2f1OjplRRGS
	 ndRt9d7bOc8pBVkdftB/J/Eo5k4actuuvrvmrjWoa2mjCEVCzTYMfWo4zFRFxLFdUZ36U
	 IM6zHl2Pt60E2tfvQ5KPnnRYXSG40b8LAkyqIkPYGaiPYSZ40UmjKDdlASrrwfDKsDj0E
	 hrpZQaBJvPica5OCm/fTyTjvGuwXV4OpUZNGzmrq6LV2JX1a0nE/aZ9FGPwrR9mydhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bVbLj9px5Nb+O3Y3JK5P3tdQDwinenaQkY2X8EpId4g=;
	b=4VMPjsNhA4I0qpRI/IvA6NVaGdLbx/JtYrBC+wDwXeZsg/LI13TTK7UyZzdETdkTzsEt
	 X9zm478cyMVqyY2mZpLW9D3f+SwZr/KBFFI6UXm5N6rggFRgFD9peHELMhR/NK2Qw3IqC
	 iO25KgIc1LtHT0Pqri5vc+wwTv90Eav0nk7fmL77Qx1ghj5S1mKxXQiJcsNGU20oK9dMu
	 XS0DVcGCjbtGinHGYmTG9R0QqPBASzR4DMKKgwavcnmvl9SwoNzbJ/SXZGDAHBevboHub
	 2As45aOtSSnlhMj+b1zdQ9aoeJK2yv8Qq6qr/ufb04rkhxdDR6mA3jLLAInCHayZRmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MpNvG5ZQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD33606A31C;
	Thu, 19 Nov 2026 03:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MpNvG5ZQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F821F000C4;
	Thu, 19 Nov 2026 03:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057716;
	bh=bVbLj9px5Nb+O3Y3JK5P3tdQDwinenaQkY2X8EpId4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MpNvG5ZQNRbutNZcfJ5eEHBBd2BNrIfZ9k3UAAPv66uOnchZNr9jh6ZCIZNDBjFGz
	 CWhl3IKHwGv+cBeMfGk0mhCOGxpefWBTAxyjIF533UJYZMmz7DiWBUU1e26KUBSg1l
	 ci8HRQyN2EVidc97z3KkJ2PnZj/IC1KThVVR9eAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 0230/1848] net/sched: act_ife: do not consume the inner header on egress
Date: Wed, 18 Nov 2026 15:37:48 +0100
Message-ID: <20261118145921.612270853@linuxfoundation.org>
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

From: Jamal Hadi Salim <jhs@mojatatu.com>

commit 498c631f9c6d74aad4bf43039fa3ce70ae9a8bb7 upstream.

The issue:
tcf_ife_decode() unconditionally calls eth_type_trans(), which pulls
ETH_HLEN.  On egress this consumes the inner Ethernet header, and the
device receives an skb whose data points to the L3 header:

- loopback_xmit() parses L3 data as Ethernet: the "ethertype" comes
  from the inner IPv4 source address, and the decapsulated packet is
  dropped or misparsed.
- a real NIC transmits the frame without its Ethernet header.

(The __skb_pull() BUG this used to trigger in loopback_xmit() when the
remaining linear area was short is handled by "loopback: use
eth_type_trans_careful()".)

The Fix:
Parse the inner Ethernet header with eth_type_trans() in both directions,
then restore the egress data position and MAC length.  On ingress the
existing behavior is unchanged.  On egress, push the inner Ethernet header
back after parsing so the xmit path sees the original frame and later
actions see a consistent network header.

Conditions to recreate the bug:
- egress tc filter on lo: action ife decode pipe;
- AF_PACKET SOCK_RAW frame: outer Ethernet with ETH_P_IFE, IFE metadata,
  inner Ethernet + a valid IPv4 ICMP echo request to a local address;
- before this patch, no echo is received; after it, the echo is
  delivered and answered.

Fixes: ef6980b6becb ("introduce IFE action")
Cc: stable@vger.kernel.org
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
[edumazet: reworded changelog, the crash is now handled in loopback]
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261028122703.2093730-6-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_ife.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -761,6 +761,10 @@ static int tcf_ife_decode(struct sk_buff
 
 	skb->protocol = eth_type_trans(skb, skb->dev);
 	skb_reset_network_header(skb);
+	if (!skb_at_tc_ingress(skb)) {
+		skb_push(skb, ETH_HLEN);
+		skb_reset_mac_len(skb);
+	}
 
 	return action;
 }


