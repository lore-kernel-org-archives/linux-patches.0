Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034968;
	b=l2c7isTHr6hbv8jdR0jJf5cMM2+uBQoEvjU6jLzDKRs2gLueiLEsEhZ8BltDWX8TLqqw
	 qSOCfMw79/h85FQ+TlRk7T1oQ8DNMBscMkwk39e4BB4utwlKRz7Apitcd04whuz0/2Or9
	 HEl135mDQPpPi1Uh0UbnngaZVyNBwjNhGTMyEh0fHQIOQUktlLmMmGgl0i9IVq5kqqSpa
	 CQPOcT0HzLxbIQVv6W0Wg2fYod6NfSrY6v4WEjbVpcxRbqP6hBgwt6kEyu6aWoIjzyb+d
	 sZyPUE250O+ajD/hLD78oX+fgvZmA6UehbgTaRiLtjP+AxR219+DohzAQ/PaauhYVDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2snNfACeUKzHUod5fQ2R25awZiPObGBjWpl5GCwVJU0=;
	b=xD25Rx3TJSCQ0kGEyiahOnIOisA19GnW2X/hzpW70bRqRfffryFytjnqtcqKIRxHfcVq
	 LUsriCKiTtwwXCQUOCR7gtjbniT+hCHjDFJV1mccX2tY18SJ6qkIJGqlz01SuY1+B/Btt
	 Lm1/R3wcANd0DMUiq03VzVXqXG73HKwWtKy5v708iwaj3FFigyHwQBwngdLE6KRlGKi0h
	 Isuk0gFitL8ugiteloTb2L8Tw673daEEizBpCuD0MfNJ4ANzOx8/Akuve3YkBbqUA0uNF
	 7cEFey70G+AFwJ+rYQDhJLcRjNpHXUom755yc2XHTYLh7sCrQxtIxYcuWgKu0nYVSpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r6sq8Fuv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75EC606A31C;
	Wed, 18 Nov 2026 20:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r6sq8Fuv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106571F000C6;
	Wed, 18 Nov 2026 20:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034968;
	bh=2snNfACeUKzHUod5fQ2R25awZiPObGBjWpl5GCwVJU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r6sq8Fuv1fdwXDpjZqrcjRp73iOeARIiptOS9yEQocEWBpaQJfhV4+wJN6tAJqNzM
	 a1hcoegFc9m6ZA+Pbj1kLKVwid4miBrIFKRFC+HQwXyO438ZrqxiLyommaJLI6telk
	 lW37or+Dz1kbkHOvKVvVva5xB7ZLyj/tQoTIdUzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0558/3318] net/sched: act_ife: do not consume the inner header on egress
Date: Wed, 18 Nov 2026 15:19:40 +0100
Message-ID: <20261118150334.090534595@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -762,6 +762,10 @@ static int tcf_ife_decode(struct sk_buff
 
 	skb->protocol = eth_type_trans(skb, skb->dev);
 	skb_reset_network_header(skb);
+	if (!skb_at_tc_ingress(skb)) {
+		skb_push(skb, ETH_HLEN);
+		skb_reset_mac_len(skb);
+	}
 
 	return action;
 }


