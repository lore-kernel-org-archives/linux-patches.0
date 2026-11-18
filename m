Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034824;
	b=yfpB/BEYb8Zq5skFmybTyifb4vdSXhfbV9prWsVigBvqiiws7jAw7sIcajF7RlSrQCTh
	 QbARfqPDgc/8pKgDlBh6/BHM4/Wm3yathy0dFOnUweYYG+gercTF5MG82yL67rjJN28ut
	 3qwk7Qkri27kjZquhHuGoOy7O3zkbG/dFxz81LsMgg1Kj0c3qAUanFtBg7jj9/PRZSiBw
	 aqaUKyPz6UqiL8uqmqJBhYCuXeUd6zHcVa2XNlfjlaZFAy1fEbH5YXdDaS6Qa28QJokrn
	 QIRVqwrBkh60jM+zyOVpEpNgNCDC6E9ld5hD4RjF2r+Rvh0+09QP46RiOa6qPT8IFtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7xTzneBN5SKnvZJB5Fup2Sry6+xNtQEyeGwkCvb9CzI=;
	b=c/3RFqxy2QbptnWhZWsnGe5F7Tc0VayG+LvbeOjhQ5PKK+Nrgtq7H53klzH/wMxZokb1
	 yDuQBuRrDeLjhYwkv8h/JxmjsC5J1BWbq1IjtUKb3X3OwvOSBZIK6eM/pzsJet1zPd3kR
	 3bxedp7lAFKiPSV6bwnDe6ibwWhPoK87vhANRvXqzt6PG3MIOMj1X7i7rGjCSZgeXa89i
	 i/tVLcA+PgYDjsEsRSPlDXdy1vQlGSaG0SG/TuQwM4yXGPXMIakIgTxh5eNda9hTJAqeQ
	 Pb1ElfNwpAcXzL7oQGqBimFhytAaD4VAtXPl/79J2VI0nl+pcC1FEy/CukOO+UgOuCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="uInjsL/d";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DB6606A320;
	Wed, 18 Nov 2026 20:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uInjsL/d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BAD1F000C4;
	Wed, 18 Nov 2026 20:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034824;
	bh=7xTzneBN5SKnvZJB5Fup2Sry6+xNtQEyeGwkCvb9CzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uInjsL/d+xw7+X8hKNQ5IhUow9EtDt5DKydikq2VbGWhnFM2VLSy5kuEX38p5dvOv
	 35CJsLH+Ih1oDQ5EYTFF1tcPgDd6MBjH3jTvMWe3f+mFyRWJt5ug7khT2qt4M+tsuU
	 rsP6orK185QweMmaTwlqhixt41BmgPbk+oRqFrBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0507/3318] net: mctp: Add some detail on the key allocation implementation
Date: Wed, 18 Nov 2026 15:18:49 +0100
Message-ID: <20261118150332.308283158@linuxfoundation.org>
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

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit aee6479a458e2c5027e558cfe26c60c37f8efc80 ]

We could do with a little more comment on where MCTP_ADDR_ANY will match
in the key allocations.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 26cc0e69cce0 ("mctp: route: iterate socket tag list in mctp_lookup_prealloc_tag()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/route.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index bd1b0e912d1ee..c41fa80800238 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -73,6 +73,40 @@ static struct mctp_sock *mctp_lookup_bind(struct net *net, struct sk_buff *skb)
 	return NULL;
 }
 
+/* A note on the key allocations.
+ *
+ * struct net->mctp.keys contains our set of currently-allocated keys for
+ * MCTP tag management. The lookup tuple for these is the peer EID,
+ * local EID and MCTP tag.
+ *
+ * In some cases, the peer EID may be MCTP_EID_ANY: for example, when a
+ * broadcast message is sent, we may receive responses from any peer EID.
+ * Because the broadcast dest address is equivalent to ANY, we create
+ * a key with (local = local-eid, peer = ANY). This allows a match on the
+ * incoming broadcast responses from any peer.
+ *
+ * We perform lookups when packets are received, and when tags are allocated
+ * in two scenarios:
+ *
+ *  - when a packet is sent, with a locally-owned tag: we need to find an
+ *    unused tag value for the (local, peer) EID pair.
+ *
+ *  - when a tag is manually allocated: we need to find an unused tag value
+ *    for the peer EID, but don't have a specific local EID at that stage.
+ *
+ * in the latter case, on successful allocation, we end up with a tag with
+ * (local = ANY, peer = peer-eid).
+ *
+ * So, the key set allows both a local EID of ANY, as well as a peer EID of
+ * ANY in the lookup tuple. Both may be ANY if we prealloc for a broadcast.
+ * The matching (in mctp_key_match()) during lookup allows the match value to
+ * be ANY in either the dest or source addresses.
+ *
+ * When allocating (+ inserting) a tag, we need to check for conflicts amongst
+ * the existing tag set. This requires macthing either exactly on the local
+ * and peer addresses, or either being ANY.
+ */
+
 static bool mctp_key_match(struct mctp_sk_key *key, mctp_eid_t local,
 			   mctp_eid_t peer, u8 tag)
 {
@@ -386,6 +420,9 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 			 * key lookup to find the socket, but don't use this
 			 * key for reassembly - we'll create a more specific
 			 * one for future packets if required (ie, !EOM).
+			 *
+			 * this lookup requires key->peer to be MCTP_ADDR_ANY,
+			 * it doesn't match just any key->peer.
 			 */
 			any_key = mctp_lookup_key(net, skb, MCTP_ADDR_ANY, &f);
 			if (any_key) {
-- 
2.53.0



