Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705299;
	b=GgQCYFc4M1I+2Iol2cUZJhc88um54zuR7Tcoe8/3fyr8UWlQgza0GSBPPQZmlUOCnpGd
	 Wp876M47G1ihlQN1jYK8E5XFOdQvFhUPFvrHIIaOz6gPW9UZdjRbrJ+aqbLRQ7KdLkuqG
	 9yrQ2+xnKmEg9Y6PRFHRplmSRGIdmEqKPAfOlv/tVjp/1YmaQE+qigHwka7UDMN53nRoq
	 j6JsEsdRq+THilaTvxmeCad1rvANwX+rM9WUDDgW8C/PcDm3XGdM6rbKHlmYvb6AXqL59
	 4DJWKobKE9W0ra8joLobsY5s/PZGGKgGz+g8F4L2RKtIRojWDUMA9+DWMOb9v2xfvtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705299;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PmES7aV1UXhWkJhUvM+nX7D7O33u6pDKouOTFVSKflk=;
	b=jWD1aiAFOkqOFFuf97jKowsmWYr/u4gaswwHu9BnnJPArlU6ccgtO7Q62RzxZH3dIjhe
	 s9yJPZ9EiyBR9zRrkyzlr6ZhKTDZ6ky2oMbfykUhEgs/eZymeh8cCnxeUGN7JIbXrPnKV
	 KgMQlxaPnxM0HTsJtvXzBfINjBrDftcfGgCe+ma+1qrYbLVYwqCsY1Ygf7bmaJJhwDINf
	 2IQnHGE8c9/vZp7kHRU7FKNaE5qAM+t+9ZVI2RfmA0ioJdkhOPHJ10PvQKqOp7rQZW3LN
	 k7An1RRNsRcgvD3Lpb9qO2l2YCDeCwhwqohNw3CTU3FT//lqA7t4AH56TdmPv6Ie8nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KnQ5yajy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98DB606A32D;
	Thu, 26 Nov 2026 15:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KnQ5yajy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FC71F000CF;
	Thu, 26 Nov 2026 15:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705298;
	bh=PmES7aV1UXhWkJhUvM+nX7D7O33u6pDKouOTFVSKflk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KnQ5yajyC0uscbEcxqC4KrZMS600QfHeeAkV/wf6VIgGw1T0DhEICUbOINjfd2IfJ
	 byNZWqg8f79tTjBLP6xn56pwWYwcRdZTELmXX0pI9esDF+H29LmC6ZThLXG7mHqnID
	 vA/QHzSyN+PC1PdK7P8zSzC4YQKSldn/k5iZeP8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 151/319] fou: gue: check IP version of held packets for direct IP encapsulation
Date: Thu, 26 Nov 2026 15:38:39 +0100
Message-ID: <20261126144010.153306570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit c59f004734a2a7c0e427011db13aca524e781498 ]

For GUE version 0, gue_gro_receive() compares the base GUE header and
its optional fields with every held packet. For GUE version 1 (direct
IP encapsulation), it skips this comparison and selects the next GRO
handler only from the IP version of the incoming packet.

A held version 0 GUE packet from the same outer flow therefore stays
eligible. For example, a GUE/IPv4/UDP packet can be aggregated with a
direct IPv4/TCP packet, and inet_gro_receive() then parses the held
packet's GUE header as an IPv4 header.

Clear same_flow for held packets whose first nibble does not match the
incoming IP version. A valid version 0 GUE header always has a first
nibble between 0 and 3, so this also separates the two GUE formats.
The reverse case is already handled: the version 0 path compares the
whole base GUE header, including the version bits.

Fixes: c1e48af7960e ("gue: Implement direction IP encapsulation")
Reported-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261106195615.2498766-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fou_core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/ipv4/fou_core.c b/net/ipv4/fou_core.c
index 556323c687e5b..9636a31e0a63e 100644
--- a/net/ipv4/fou_core.c
+++ b/net/ipv4/fou_core.c
@@ -368,6 +368,18 @@ static struct sk_buff *gue_gro_receive(struct sock *sk,
 		default:
 			goto out;
 		}
+
+		/* Match the encapsulation format and IP version. */
+		list_for_each_entry(p, head, list) {
+			const struct iphdr *iph2;
+
+			if (!NAPI_GRO_CB(p)->same_flow)
+				continue;
+
+			iph2 = (const struct iphdr *)(p->data + off);
+			if (iph2->version != ((struct iphdr *)guehdr)->version)
+				NAPI_GRO_CB(p)->same_flow = 0;
+		}
 		goto next_proto;
 	default:
 		goto out;
-- 
2.53.0



