Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207540;
	b=bSHDF+aA0Dc6yDVB8E1F0FZlFhyrGXsLD1QZX0NFr0j7T9ThC7dPH/rZqaXGx8OpWBdw
	 7abXCy+5iXUKAU3sT6evyYmrmajm63h28yWF5VSW2RCzPV0qsKQthmkkA39ivf/gUxxmo
	 iQrUKbJA/jZzN/++UMoaR/8lv2JKyoj7tGgb4yj8jjx11WBQY44RkQgKwz+9g4Ex2bgqc
	 YABKIqHZ43H1r92jiQRhwbDQG3OcVetoRqfTjsMxk0rDnD2s9Q3g0hK+tJlUq4hjJm/d9
	 b7OCPp07we83VmTcspPZ3LCEDMWp4+jZJ3+adSCLkr2jCcZMjaMKfdoNDYh2idN0hAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207540;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WxTDHD2/0RZCICIDXJf3yWe1INAXMnVQIEXFbhl2+Zo=;
	b=whBh9MpBP3aHrxs2zTK3jYDfVQ9xOvI1Y5ZjBFz8Q7tACJ5jOLCOuHeh2llEQ+aeRkrb
	 0jCpvOIqFg+Ycaa9OoOytC0APLpcv0RhGpqfxnTrL7MyS0/XPC/72OEs33D+8yrY5mIT9
	 0Yuep4jgtp6HIvcRUJdDc2tO3GoZgKOhcGM/jY05SwNewCjYNDitqT66g8JXoUR4Moc3Z
	 C5vJtjLrpyUIrA1Jx2lrH77tljxu1RvfzxIE8L5ppHpTQPTxOT455URyjVwu58IZugjBN
	 YPxxxmONsAbCWaACFebnA1fwlB6YtnyW0bZGeSLgl0JXFVL9eTJIqWJf/N/bLEGB88g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nnuOLFjB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB67E606A31C;
	Wed, 28 Oct 2026 17:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nnuOLFjB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3871F01825;
	Wed, 28 Oct 2026 17:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207539;
	bh=WxTDHD2/0RZCICIDXJf3yWe1INAXMnVQIEXFbhl2+Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nnuOLFjBA2d5zN8dgLu8v1tIOj9zV8RAeR6kSacZloWf8brFrqTzQNjZvpb3Jj93D
	 0Tvp+qf+X/1WYiitX0pQlTwx6+fGbzqUWzLMaXRVpr+ZH6NBgGyjPWF7BfFAwSGOwc
	 /wMMt6yMbXliipgkMfledTKbP1Pobyyxb1DNyi2E=
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
Subject: [PATCH 6.12 053/247] calipso: keep BIG TCP payload_len in calipso_skbuff_setattr()
Date: Wed, 28 Oct 2026 17:57:36 +0100
Message-ID: <20261028165948.632742314@linuxfoundation.org>
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
index f5cc02ea3092d..3ab22f9b416ec 100644
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



