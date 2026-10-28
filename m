Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209985;
	b=yNxM+uGjX75g64CrrDYvWvjdFjYPZYoeYmZb2LQp5akanhpmcVLmFeK4/u0i1sZ/Z0u1
	 CE7nfMOI4sgmOsMau1MmCNGcuImP5EAhglFxmaAm8ecdBtw29PHJiZbSANdn+vsR00LYJ
	 zHvScfgs4ECuGJTB0joonRQbVDZiuVRbDwFeQIL3BSnZAgg18sybImRhbM5iloVoCATU/
	 3zBt3zsC8QUKPfrT3TcafNpt0o0bUG4nuaAu2NiTv1mDccrdj2y7DrgFodT79EM3W2k3v
	 fZIFbQbnMDdEcCtxDLkWYXPQ4ILDc28sICacYCOcRhoLRJxjVGmGQFELzITVAfnB/EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KRsJ+znztcvHRNSQwKxl384NIm0YPqxzdgMLr2T1YSA=;
	b=qGfmudLeUjICYBfnvRYIJlfiNkpW3EJF6KUl5VBpg+nSEfJ3yJXDURQk36aG1FEyVBSS
	 2leMH5HV//gXrn6AwUzlM4RfLcoi/APNLb4pBtv6VjJxuLmLTFo4e6aUQvvtbcw7fQRG5
	 XfHH2WFuwyzghjPdChcc6lEPsltd1cGYPCRp9rfrustWOBKwW5gzi/a9pWebrLx2QhH0y
	 3lWcyNB1T1rV/OI55kncgPsUg2I+I89Xi5i444WI82VNdd3GlqMKYU//UUhxcnH+Z7P87
	 aWjzAnBgFw5/JBn/yArxrpHTrPeuisoNoeiCbmIC1A2gH97TzoxORvyLUlf0RmDeK/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z4nEz90V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9FC606A31D;
	Wed, 28 Oct 2026 17:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z4nEz90V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BF21F01825;
	Wed, 28 Oct 2026 17:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209985;
	bh=KRsJ+znztcvHRNSQwKxl384NIm0YPqxzdgMLr2T1YSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z4nEz90VkP6hgSJusDLoIcO4gKScQMts72hjp5bGE1ZG9E6E/RfOoEI2R3eWvXg2J
	 RQJ4zRg6R4i0FKDAfBuE9nmSwlPD+lUarCrMcM1XDwByB2yFyw7XwKTQMWzZxYzjjh
	 a2nqckt8xRPQjG0HiLgd0FKk8CIGh+4BVkhKO6tU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Wang Zhan <wang.zhan@smartx.com>,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/168] calipso: keep BIG TCP payload_len in calipso_skbuff_setattr()
Date: Wed, 28 Oct 2026 17:59:31 +0100
Message-ID: <20261028165943.924717087@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

[ Upstream commit 8070ed578b6b9134e045627fb745c887a806d46e ]

calipso_skbuff_setattr() adjusts payload_len by the length of the
option it inserts or resizes:

	payload = ntohs(ip6_hdr->payload_len);
	ip6_hdr->payload_len = htons(payload + len_delta);

GRO can build BIG TCP packets larger than IPV6_MAXPLEN, and stores
payload_len == 0 for them; ipv6_payload_len() then falls back to
skb->len.  For such a packet forwarded to a destination mapped to
CALIPSO, the code above writes len_delta (or 65536 + len_delta when
shrinking) into payload_len, and ipv6_payload_len() no longer falls
back to skb->len.  nf_tables, conntrack and sch_cake rely on it.

The same arithmetic also wraps when a packet grows past IPV6_MAXPLEN,
and a BIG TCP packet that shrinks below IPV6_MAXPLEN should get its
real length back.

Set payload_len from the skb length with ipv6_set_payload_len(), which
stores 0 above IPV6_MAXPLEN and the real length otherwise, as
ipv6_gro_complete() does.  The network header was just reset to
skb->data, so skb->len - sizeof(*ip6_hdr) is the payload length.

Tested on one kernel (arm64, QEMU) with SELinux permissive, a minimal
mdp-generated policy (network_peer_controls=1), "netlabelctl calipso
add pass doi:16" and a NetLabel mapping of fd00:2::/64 to CALIPSO
DOI 16.  calipso_skbuff_setattr() was called through
netlbl_skbuff_setattr() from a test-only debugfs hook (not part of
this patch) adding a level-only label; payload_len after the call:

  case                         before fix   after fix   real length
  1000, unlabeled                    1016        1016          1016
  70000 GSO, payload_len 0             16           0         70016
  65530 GSO, grows past MAXPLEN        10           0         65546
  65540 GSO with a 24 byte hop
  header, shrinks below MAXPLEN     65528       65532         65532
  1000 with a 24 byte hop header      992         992           992

(0 means ipv6_payload_len() returns the real length.)  On the forward
path, with a client injecting unlabeled UDP through a router to a
server, the router adds the CALIPSO option and the server delivers all
datagrams (Udp6InDatagrams 5, Ip6InTruncatedPkts 0) with this patch.

Fixes: 81fbc812132c ("ipv6/gro: insert temporary HBH/jumbo header")
Suggested-by: Eric Dumazet <edumazet@kernel.org>
Suggested-by: Wang Zhan <wang.zhan@smartx.com>
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Assisted-by: Claude:claude-opus-5-5
Reviewed-by: Wang Zhan <wang.zhan@smartx.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Link: https://patch.msgid.link/179156155963.36253.400481753322266658@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/calipso.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/calipso.c b/net/ipv6/calipso.c
index 72079ef2959b9..f23bccb0ee5a2 100644
--- a/net/ipv6/calipso.c
+++ b/net/ipv6/calipso.c
@@ -1322,7 +1322,7 @@ static int calipso_skbuff_setattr(struct sk_buff *skb,
 	struct ipv6hdr *ip6_hdr;
 	struct ipv6_opt_hdr *hop;
 	unsigned char buf[CALIPSO_MAX_BUFFER];
-	int len_delta, new_end, pad, payload;
+	int len_delta, new_end, pad;
 	unsigned int start, end;
 
 	ip6_hdr = ipv6_hdr(skb);
@@ -1361,8 +1361,8 @@ static int calipso_skbuff_setattr(struct sk_buff *skb,
 			sizeof(*ip6_hdr) + start);
 		skb_reset_network_header(skb);
 		ip6_hdr = ipv6_hdr(skb);
-		payload = ntohs(ip6_hdr->payload_len);
-		ip6_hdr->payload_len = htons(payload + len_delta);
+		/* 0 above IPV6_MAXPLEN (BIG TCP), the real length otherwise */
+		ipv6_set_payload_len(ip6_hdr, skb->len - sizeof(*ip6_hdr));
 	}
 
 	hop = (struct ipv6_opt_hdr *)(ip6_hdr + 1);
-- 
2.53.0



