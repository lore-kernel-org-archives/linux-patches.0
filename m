Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207798;
	b=yQbCDi99D0i1uvslaZ1xD8hg5ufSmfjp5a3LO6c9gDtQi2JBlGq/A3qpUAi6zmTN6We4
	 UtZhHuIjBvyLd07iMV1VeBFs2TBTfwm7Le5TGYzK1RP0sPYfqYKaI5y1yqWK/DRIZYAHL
	 TdIgOY6O6Q3qqqNPVAZOj7TtfhNrql1PM73cYv6vcRf+FrsYl/QTEYWPzSxmG6m9MOiLX
	 SwNIf/i4yPgTNUkfKOAov7rVn5N6kkbS+3K6Vxly2Eo1RmyTILKMxYZGv2aIgAFEPNFrw
	 GJZS6/0cYcExn+ipQNQRxW0+RT02z+d32qziAP3jbjjB5gOn66Z5MDvyCgKKNS43uVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207798;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ibOA6NbuxMJW06q5crfPupbsw9XqcJJ283QuSNrfB54=;
	b=mkb3qrAoGfIw1Tpw+9K5gC4SOSyRcvU7KHNS2vQFBX6JwtUtNfK/7wilvvSL2nUf+Ih1
	 qPYa32UTPtpO8HbrRYCJItvNAxNeRQUtzwcWB3hfRabmYQ6jMrrgYZSFJNXDunLApAmzb
	 5jqD6TO5iCZsdORveryu/891KCqqNjlDYvrOizwIfaXd+JgjF0IFRMyg1vGPRYrkG1gcU
	 a8csmb6CbW4iPZGECuadm1Qw0XyjJb02TxfdAQp8/lGptXvnGURZywChUGj+FaCL/5Wrk
	 gZt2N9JbcLgL97NpBu/UYPWLG9+GEfJD+2jJ5dBu9RbYFhvQjTXwIDn5vcUyTiBiUBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ORAvmmJ6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3C8606A31E;
	Wed, 28 Oct 2026 17:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ORAvmmJ6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7081F031E1;
	Wed, 28 Oct 2026 17:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207798;
	bh=ibOA6NbuxMJW06q5crfPupbsw9XqcJJ283QuSNrfB54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ORAvmmJ6zxCSldg3oJj7WX7fLd9Bom9rRAJ37J3Y9ugYZYyhrdAt/1gYmf8JO+rvE
	 NcGjbzWm5nZU8lWWGbvV+TCh+ti1VtYGAUs/2QWCrehwl+m93HOEbbEhrVXaFpZGni
	 5wKqnuw3zrz21zZ6dVCO9Nl0DLXwCSpbWNXTRvB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Klein <aksecurity@gmail.com>,
	Noam Caspi <noam.caspi@mail.huji.ac.il>,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 144/247] ipv4: udp: Create exceptions before socket matching
Date: Wed, 28 Oct 2026 17:59:07 +0100
Message-ID: <20261028165950.819898531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 4c3499f79f8c7e8561266bcc220a18538cec0458 ]

Currently, when ICMP Fragmentation Needed and Redirect Message packets
are locally delivered and quote a UDP packet, a FIB nexthop exception
(FNHE) is only created if the kernel can match the UDP packet to an
existing socket.

This behavior allows off-path attackers to conduct a side-channel attack
on the FNHE cache in order to discover the ephemeral port used by a
connected UDP socket.

Commit 6457378fe796 ("ipv4: use siphash instead of Jenkins in
fnhe_hashfun()") and commit 67d6d681e15b ("ipv4: make exception cache
less predictible") tried to mitigate such attacks by making it harder
for attackers to discover hash collisions in the FNHE cache and by
randomizing the number of exceptions a hash bucket can hold,
respectively. Unfortunately, both of the mitigations can be bypassed.

Instead, mitigate such attacks by always creating a FNHE, even before
trying to find a matching socket. Do that by calling ipv4_update_pmtu()
and ipv4_redirect(), the helpers used when the quoted packet did not
originate from a socket.

This means that guesses (right or wrong) from an off-path attacker will
always result in a FNHE being created or updated in the cache that the
attacker can observe.

Pass an oif of 0, in a similar fashion to icmp_err(). This is also the
oif used by the socket path for sockets that are not bound to a device.

Note that this does not allow attackers to create FNHEs that they could
not create before, as both helpers can already be reached with little to
no validation. For example, by sending an ICMP error that quotes an ICMP
Echo Reply or one that quotes a UDP source port that matches a wildcard
socket.

Also note that in the good case (matched socket) the above scheme comes
at the cost of an extra route lookup, as the no socket helpers perform
their own lookup before the one performed by ipv4_sk_update_pmtu() /
ipv4_sk_redirect(). When the two resolve to different nexthops, it also
results in two exceptions being created for the same destination IP. One
in the FNHE cache of the nexthop resolved by the no socket helpers and
another in the FNHE cache of the nexthop used by the socket.

Fixes: 4895c771c7f0 ("ipv4: Add FIB nexthop exceptions.")
Cc: stable@vger.kernel.org
Reported-by: Amit Klein <aksecurity@gmail.com>
Reported-by: Noam Caspi <noam.caspi@mail.huji.ac.il>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20260828192344.2596928-3-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: inlined udp_err_update_exception() in the udp_err() wrapper. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 69e6897337417..22eee4fdd5d8d 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -869,7 +869,16 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
 
 int udp_err(struct sk_buff *skb, u32 info)
 {
-	return __udp4_lib_err(skb, info, dev_net(skb->dev)->ipv4.udp_table);
+	const int type = icmp_hdr(skb)->type;
+	const int code = icmp_hdr(skb)->code;
+	struct net *net = dev_net(skb->dev);
+
+	if (type == ICMP_DEST_UNREACH && code == ICMP_FRAG_NEEDED)
+		ipv4_update_pmtu(skb, net, info, 0, IPPROTO_UDP);
+	else if (type == ICMP_REDIRECT)
+		ipv4_redirect(skb, net, 0, IPPROTO_UDP);
+
+	return __udp4_lib_err(skb, info, net->ipv4.udp_table);
 }
 
 /*
-- 
2.53.0



