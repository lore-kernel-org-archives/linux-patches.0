Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774035;
	b=MXZScmWLNqH2q8QNcJKB7YhcEllTIbTupm6uQEHlMIVnaob/ZhZTbOceQMMm9xw7s0eI
	 duKLU1VWOxN9tA8faixJ+RIxLL1F/EAuqxxGnEkO2EvwfrWpFSPyOGIYZtAbjtgKbtZFg
	 ssW1fzsj4JuCsu1xCx6iGYJbyHXVS07ln38Ldn3562YY4xTFdpLwUDT11s9PgTUiyNkl8
	 eKnzboxWPGbntrr1TEnbGjVqdQq7Oazd5SrvAIiHlX7DImSMkzGHlyzuimHjqWhtLlUfU
	 DCS56dYFYNFgo7QKPkGp92+ce6QtPGfUOAh9Vj3U3Y/IDdIWWJWr1lS1cxU2SnYEKDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SeoFKCcOZ22yNrNjhJ9YNO4ajTEy40RgOOx4YWHNNVQ=;
	b=b9tsp5vm1H4lxoRzVB/JPTdeHy5YPK+EJoWWJN4n36Bka2g9ML19FriRlPQJqbfvz2Da
	 l0VVSqzCwfoauksTuA/PR5cdyidwSE3+2OSIyTZsRxuHEku7ql0fX14XYqCq8pvwbUpLl
	 6n3X35pf8e/0U320sE8Q8mMvzAT4D3V3sn8Ehqyo1iFweci6Iz+QdeMfHI6XBetJpi4e+
	 zWcw+lOxHBG7Y9eEWV589lLBlOvZBTynUGW4eWqZNuOYnydhnpl0AJ0a7kX1XtwWkSfDR
	 mVwGKN3NUrOGLhNhVgb3mmP9eHFSBIi/QGoaImQL2ttbiGu/ReHNLVkENUXNjT4D8pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OmcVSAFj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D91606A31A;
	Fri, 23 Oct 2026 16:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OmcVSAFj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B956A1F01825;
	Fri, 23 Oct 2026 16:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774035;
	bh=SeoFKCcOZ22yNrNjhJ9YNO4ajTEy40RgOOx4YWHNNVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OmcVSAFjVwe863pesBP/vl7SaFuYpODQzxQilJE2/2mWfvGEi68/+TRAOxI3CFQTb
	 tM1eMq4nRaCv/GfacafJj+kavgAlptt35ShvMC/WMfkscr1JKGFjgEohFrU7RsG85y
	 hPIQtkg+B2YdpgpMcX3VXbFMJoJGU/DPwwDt3WhM=
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
Subject: [PATCH 6.18 061/193] calipso: keep BIG TCP payload_len in calipso_skbuff_setattr()
Date: Fri, 23 Oct 2026 18:35:38 +0200
Message-ID: <20261023163715.650174638@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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
index 21f6ed126253a..22008f5a2973d 100644
--- a/net/ipv6/calipso.c
+++ b/net/ipv6/calipso.c
@@ -1319,7 +1319,7 @@ static int calipso_skbuff_setattr(struct sk_buff *skb,
 	struct ipv6hdr *ip6_hdr;
 	struct ipv6_opt_hdr *hop;
 	unsigned char buf[CALIPSO_MAX_BUFFER];
-	int len_delta, new_end, pad, payload;
+	int len_delta, new_end, pad;
 	unsigned int start, end;
 
 	ip6_hdr = ipv6_hdr(skb);
@@ -1358,8 +1358,8 @@ static int calipso_skbuff_setattr(struct sk_buff *skb,
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



