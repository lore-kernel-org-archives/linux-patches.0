Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619684;
	b=20NhQHp1sGoAVfpQY4iEPL9BaFOC8yTpxsImytiUhhFcUo118bII1tVs/Pmg9ea0YOFs
	 qQk8PkJtKHovwObLqSO394At10FY+Y1B4HudDh0KOM/YlOq7OtaJZaEzfdqJa9P0B67Uy
	 eSQuML6HaaxqITHCzHEt+DnB21ZYE4hIGImsOwoXaDqA26+/yL3iGUDrZpGO3+tpB2DZ/
	 Pv6aj6gQFgwa/paceSrvzD44fCpAIE4z7VcG+zQJqrIRcgLsFZM5eLe/YWkKHyESJmyNT
	 r7byHznSaVUYZiZ3ZLXP6RDysYDpl6Q8Rm9F+kZiiqA60EIvBnguAeMLhWZSmPKRM7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619684;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UwZzMy0wMhZZ8/vUquzgH4xTmC9RWG8Wc+GT+mTd0K4=;
	b=j6FWMyUbxSK5kCYsvArb1v7mPV0ybVF2cQ3HbdcUXoNpf+XkP5M7CA8hqgrcMV8SuGMi
	 qKI2QdKamMeKScxbzV4hCvI4c/rJ6WVhJEa5W2wWWIdTMO7tjhU0H1/PbCUzAplpYUpNC
	 hzHYcnTjd1NwwY8+w6ZZF7JVzfoG6tCTjZA804D4Ywmq5JIFHN0aY6uSTj22OH34wq0UZ
	 0uPOu6aV8msDW0HBz8XHrrXglkOE/7VcxafUijxPhw9bMLRBTDlRpMFSu5kCl4N4qvVkZ
	 TgqI6/6L2Bi1xLxbRM+Beaq183x6Hfpge1e/7ZXa9/y02B/4iij7D/F1ZK8TMXhTIMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QyU0wiIT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80699606A335;
	Wed, 25 Nov 2026 15:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QyU0wiIT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC641F00A00;
	Wed, 25 Nov 2026 15:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619684;
	bh=UwZzMy0wMhZZ8/vUquzgH4xTmC9RWG8Wc+GT+mTd0K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QyU0wiITgLeh27FNkJM3zfX4T6yeZLz683df53SYidSlQGj190VrH5hoRmq+7pp1Z
	 E9p9ol672VXkogc9vVuiNcLK2rIGHVySQu/AfFo7jnkvCtSOJJGcdvQ0K2xYHL083J
	 NCicLB94yIJxqAQ9ZzUc4xrIxUbgdXODfR1bpGSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Aaron Conole <aconole@redhat.com>,
	Eelco Chaudron <echaudron@ovn.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.3 0675/1005] openvswitch: advance by the real header length in get_ipv6_ext_hdrs()
Date: Wed, 25 Nov 2026 15:33:33 +0100
Message-ID: <20261125143837.566294775@linuxfoundation.org>
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

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

commit dbce972650ed6348e3d3856e49308aa5603e02a7 upstream.

get_ipv6_ext_hdrs() walks the IPv6 extension header chain to fill
key->ipv6.exthdrs, but advances to the next header with ipv6_optlen()
whatever the current header is.  That is only right for Hop-by-Hop,
Destination Options and Routing headers:

 - an Authentication Header is ((hdrlen + 2) << 2) bytes long
   (ipv6_authlen()), so with hdrlen = 4 the walk skips 40 bytes instead
   of 24 and reads the next "header" from the ICV and payload;

 - a Fragment header is always 8 bytes, and the byte read as hdrlen is
   its Reserved field, which the sender controls and receivers ignore,
   so a non-zero value makes the walk skip up to 2048 bytes and miss
   the headers that follow;

 - in a non-first fragment nothing after the Fragment header is a
   header at all, it is the middle of the fragmentable part, yet the
   walk keeps parsing it as an extension header chain.

In all cases the OFPIEH12_* bits stored in key->ipv6.exthdrs depend on
bytes chosen by the sender rather than on the headers that are actually
present: payload bytes that look like another AH or a Hop-by-Hop header
add OFPIEH12_UNREP/OFPIEH12_UNSEQ, and real headers after a Fragment
header can go unreported.  Flows that match on OVS_KEY_ATTR_IPV6_EXTHDRS
then classify such packets wrongly.  There is no memory safety issue,
skb_header_pointer() bounds every read.

Advance by sizeof(struct frag_hdr) for Fragment headers and by
ipv6_authlen() for AH, and stop at the Fragment header if its offset is
non-zero, as ipv6_find_hdr() does.

Fixes: 28a3f0601727 ("net: openvswitch: IPv6: Add IPv6 extension header support")
Link: https://lore.kernel.org/all/178905555085.219967.6617611783437228045@kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Reviewed-by: Eelco Chaudron <echaudron@ovn.org>
Link: https://patch.msgid.link/20261102-ovs-exthdrs-v2-1-21ceef6a243d@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/flow.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -370,11 +370,28 @@ static void get_ipv6_ext_hdrs(struct sk_
 			return;
 		}
 
+		if (next_type == IPPROTO_FRAGMENT) {
+			struct frag_hdr _fh, *fh;
+
+			fh = skb_header_pointer(skb, start, sizeof(_fh), &_fh);
+			if (!fh)
+				break;
+			/* Only the first fragment has the headers that follow. */
+			if (fh->frag_off & htons(IP6_OFFSET))
+				break;
+			start += sizeof(_fh);
+			next_type = fh->nexthdr;
+			continue;
+		}
+
 		hp = skb_header_pointer(skb, start, sizeof(_hdr), &_hdr);
 		if (!hp)
 			break;
+		if (next_type == IPPROTO_AH)
+			start += ipv6_authlen(hp);
+		else
+			start += ipv6_optlen(hp);
 		next_type = hp->nexthdr;
-		start += ipv6_optlen(hp);
 	}
 }
 


