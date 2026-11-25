Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619743;
	b=uc91XMMKFLXaw6U9J+7Dme6RYhqBDWDMTYTU1+ul7bmmXBTSGcb6FgQjM3asN6COaU4y
	 70CyNW/XFLOHyFRhp1QSLSPc8zFniCaQUWehEc1wuSwfRdx012sefe0wFMhhChTDYbi8W
	 fmwLXCOuEGubfonEBFt/ipQlRLKKVr9D7pKDVZcKREXj8x0yxUHzkKSVdTF29qLjWv+dJ
	 u5rP2SsPY00SpYA2HKhO6VC05k2YJgS7YuboS7kNPT8CZ2qzZYi7eSrXltz81j+tyFRdR
	 wwpMs+iSu+E6RtmU7hyIcQe39cWElRT9Cwip9m14Zj03OUPWKkjgFyUf+Lc4rZhaodA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lDZmltg3crGzuNvm6pwY69WXKh2NTsNJypPlm8mOwn8=;
	b=ey77zIAnB67M3YwLjsK0ffqLflGJT4GvfWfXdO72KSvcvqor3EtoDhKK/xHJwIAclMss
	 YqpceX9WdZ6VTb6nqPUPKx7ChFFvrRLjqHlI+gEIfVVCl0wNItpTQdB0p8NgHFSipdLNc
	 76I/KdXNB1vU0fueY9V5HFwcJEpTzufGZaKYfJx7w+0dKrXmtM30MoSuAObuNo3DiQg4g
	 RQVF/GIFFmoZSh2g9AgLhVB2xXXIXX+6ywRMXXBeLjs7H6L2fsrym5DEcxa09NLUtqhPS
	 tjr+Dtkz1w1EsIIaVBHkdl0zxY9DuOgvT3plTppoQcLNoHYvJY0UPm4oAVh4HFKKt2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mgI+g8JR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955C2606A321;
	Wed, 25 Nov 2026 15:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mgI+g8JR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCF51F000C6;
	Wed, 25 Nov 2026 15:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619743;
	bh=lDZmltg3crGzuNvm6pwY69WXKh2NTsNJypPlm8mOwn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mgI+g8JRrLvasrs0RQW9Kfe4i2zchA1nug/jmKdPnf/TTqD0vf5pNFM5h4V2qi+g2
	 F6XKNFCnYGeULRu9hZLKm+NS7iY7NMJxmc7kgXWkJGaRbd3zBKf9cJ3NM1czs6ptpf
	 0RM1drqjwDRJLdgR0SKBj9TJg9OHV8JQmrq4kDWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Xia Yan <yanxia@cmss.chinamobile.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 0649/1005] ipv6: fix cached route reuse for control messages
Date: Wed, 25 Nov 2026 15:33:07 +0100
Message-ID: <20261125143836.953615422@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xia Yan <yanxia@cmss.chinamobile.com>

commit f778e80b3daf5033fb996f45c2b5d0ce1e82c0a7 upstream.

A connected IPv6 UDP or ping socket can reuse its cached route when an
SO_MARK cmsg requests another mark. A packet can then bypass a prohibit
rule instead of failing with EACCES.

ip6_sk_dst_lookup_flow() reads the cache even when connected is false.
UDP clears connected after parsing IP or socket control messages. Ping
always passes false.

Only read the cache when connected is true. Ordinary connected UDP
sends keep using the cache. Ping sends do a fresh lookup.

Found during code review of IPv6 UDP route caching. On UML, the same
connected-socket selftest fails four IPv6 cases before the fix and
passes all 54 with it.

Fixes: c6af0c227a22 ("ip: support SO_MARK cmsg")
Suggested-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Link: https://lore.kernel.org/netdev/willemdebruijn.kernel.1e0038bcc3ef8@gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Xia Yan <yanxia@cmss.chinamobile.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20261109014400.9025-1-yanxia@cmss.chinamobile.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1305,7 +1305,7 @@ EXPORT_SYMBOL_GPL(ip6_dst_lookup_flow);
  *	@sk: socket which provides the dst cache and route info
  *	@fl6: flow to lookup
  *	@final_dst: final destination address for ipsec lookup
- *	@connected: whether @sk is connected or not
+ *	@connected: whether the flow can use and update the socket dst cache
  *
  *	This function performs a route lookup on the given flow with the
  *	possibility of using the cached route in the socket if it is valid.
@@ -1322,11 +1322,14 @@ struct dst_entry *ip6_sk_dst_lookup_flow
 					 const struct in6_addr *final_dst,
 					 bool connected)
 {
-	struct dst_entry *dst = sk_dst_check(sk, inet6_sk(sk)->dst_cookie);
+	struct dst_entry *dst;
 
-	dst = ip6_sk_dst_check(sk, dst, fl6);
-	if (dst)
-		return dst;
+	if (connected) {
+		dst = sk_dst_check(sk, inet6_sk(sk)->dst_cookie);
+		dst = ip6_sk_dst_check(sk, dst, fl6);
+		if (dst)
+			return dst;
+	}
 
 	dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_dst);
 	if (connected && !IS_ERR(dst))


