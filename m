Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209498;
	b=0abAN0buqeuC1LMbPYRFv9x9786NHpAZV38fbQK5AqgfNChDgRwD1XMqFXQXp9Q6ibNF
	 TKV/k2HEr3I44T7NbR2cMhJ+xN4L8Oap4IJrOx3NSa/5/8gXTXvfUqupFV4Vky1bFhc1+
	 MGHjoKIIF3eFNQl8CpMSqatjBoy0YSToypMsbKqF8ma8I8N2LSZVGCxcrvN3JFnW2Y9jq
	 lSkr5toETwUNKkLu+l7DnkI1EIPXS7sBS+6aJR4Y8B/CFKsQrGGlqCgi8QDaYn2/YxYXF
	 LP1GOE15TRm9t3DWEegcsi+/Ae9OZSa1doiZCi0eGu7jCshZxbJToQm4EVJiFmcGhAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209498;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jdG1yN7jaWrzcn1+Ku4Bznrsf1c7EKo4izLG173/y9w=;
	b=LhqM4Mw+SBzCExZftZ/yroWFVNWHwIt8jly/WJ/ntASacPaaEQLTReSe1iO1IpuE7N2i
	 zQ0J7ve5REAMUGw/RRefZ6V+CRbMcoHsXiqSGQD+Sdngybtm3y+MfAXnQe76iGqYQx4IE
	 PqCTNn5bIUnASp4ost1Se9N5pMHPvgz+Tx4XgioPTE89W82CSCuHREbaHFa2HMw9Qq8rK
	 9hQLFsKqGXuw+FVWW93qWoeTDLPsLIQmGCWBiW0PTNSTqqV6RNG6ph0987MBXmNZhARnW
	 hrM3GEheb0UvoO6sUnt1eTS5Rlk7/fHRQ9qLsUZjapEMSTA3yUAJhaC5MsV6dH52A4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hcRh0i3Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8754606A31A;
	Wed, 28 Oct 2026 17:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hcRh0i3Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1060F1F01825;
	Wed, 28 Oct 2026 17:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209497;
	bh=jdG1yN7jaWrzcn1+Ku4Bznrsf1c7EKo4izLG173/y9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hcRh0i3YR5nKP6YT/vD9gTkNQMN4V5abOmh5myazDFTAes7KVDc91RP0rx4A9OxEK
	 thfpfXKml4qj7GQzZLydPOFzacTZlQJ4Z0KAccbQmLB9iwoaiaEpnmn/bm9kmpkg/Z
	 IcCpxY+i2NXgSIq8pv3CPd16JbQgSIWrdumoUnSU=
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
Subject: [PATCH 5.10 492/516] ipv4: udp: Create exceptions before socket matching
Date: Wed, 28 Oct 2026 18:00:44 +0100
Message-ID: <20261028170015.132845604@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
[ sashal: inlined udp_err_update_exception() logic in the existing udp_err() wrapper. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 7277bd9df482c..095daae41c457 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -807,6 +807,15 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
 
 int udp_err(struct sk_buff *skb, u32 info)
 {
+	const int type = icmp_hdr(skb)->type;
+	const int code = icmp_hdr(skb)->code;
+	struct net *net = dev_net(skb->dev);
+
+	if (type == ICMP_DEST_UNREACH && code == ICMP_FRAG_NEEDED)
+		ipv4_update_pmtu(skb, net, info, 0, IPPROTO_UDP);
+	else if (type == ICMP_REDIRECT)
+		ipv4_redirect(skb, net, 0, IPPROTO_UDP);
+
 	return __udp4_lib_err(skb, info, &udp_table);
 }
 
-- 
2.53.0



