Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619678;
	b=N5IKrscRuYFflrmaRabr+P1OcfmQ1PUKkhMHE+T1aXwR3nAT1KqyAhWT5tn/3XHw6lBz
	 Q1Jg0et/n0QIxSGXoGwkgfDkFjA1uVMb84S/mENcc6um0YKy+weEFzgUZGlUMduAKR633
	 A+aMb5nR8CU5S50cHPjkzqOLCehxasCn6DO1kHt1WQfNlS7JLU8Jr/FMx3rwSLL5RdOXA
	 CnZyTU14r/BSP7J0SFHbbUJsstaOkACTAcm1+IW1N4yFQ8POtsx5B9TrKYX8HkEtSKkqj
	 SVEpUFLjkCB7ij3FCW2TrlM+e4PuDROc4dy3ep3XC0Va6K08HjewG5kXLU4GqcpmdHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619678;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9p5LQhb+WoWV5g5buYYAsOfq1v+wGFNAOapr+zx7cmM=;
	b=b8Wf0OQhyv52jhUKKQa3gh4wKjShxrFmxobfSvyX8YIM5Eoj/n3spdJITCEUQ2VtqkY2
	 X0uUP3R1p0ofDH+FbB7XDMpCs49PvxnvfLvwdEL0WkpiVL5uG147N7+LzQf04Tgq7qUuz
	 g0g3NxRnsRObX973GKe1GaVyjqImM/tgxIU/TJ6XUv5QSKD3r7pvaTC0mK3aBCoeHvWCa
	 uJgVva/xU5uO0B2c9o9WVwEObLjkxOW+r0qKWn+kJb98G+mUKKmLJ2+J97xJWr11D61vk
	 eZoWPgl9UQ6xt0HnARCb8suHv5aJaVnk66DpYlFJjG3LRQLhu2d79gzPEifHibExJUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EB9Glg27;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6162B606A321;
	Wed, 25 Nov 2026 15:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EB9Glg27
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E761F000E1;
	Wed, 25 Nov 2026 15:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619677;
	bh=9p5LQhb+WoWV5g5buYYAsOfq1v+wGFNAOapr+zx7cmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EB9Glg27bFQ0LAKyIQmEELb4Le0ygncqzP4gHHfrwW0EmE/pUkGFGup+cDIJySgG7
	 jrzboKBnArKWcDiBmyzcfSnzjWOA3uq5Yb8H5GyNTG/uxz2qwbrNjR9M9z3uERb57p
	 A3nwS/Pb0g1kHlJCpawtMUjJgjH2Q0PVP9N3A3Uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 0647/1005] ipv4: keep XFRM headers out of corked skb lengths
Date: Wed, 25 Nov 2026 15:33:05 +0100
Message-ID: <20261125143836.907309414@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

commit 0f47fce51a98d3d9f439c16861d519a7b833a176 upstream.

__ip_append_data() allocates space for dst.header_len in the first skb,
but includes that space in skb->len until __ip_make_skb() pulls it.
Fragment accounting uses an MTU that already excludes the XFRM headers.
As a result, the next skb can have a fraggap larger than its capped
datalen, and skb_copy_and_csum_bits() can overwrite its shared info.

For example, five AH tunnel states can reserve 500 bytes while leaving
an effective MTU of 348. With 40 bytes of IPv4 options, the second skb
has room for 288 bytes of fragment data but receives a 500-byte gap
copy. The overwritten shared info is subsequently consumed by the skb
release paths.

Reserve the XFRM headers together with the link-layer headroom instead.
This keeps skb->len, the gap-copy offsets and the trim lengths relative
to the IPv4 packet throughout corking. The network and transport header
addresses and the headroom available to XFRM at output are unchanged.
Both paged and linear allocations, including subsequent corked appends,
use the corrected accounting.

Fixes: 353e5c9abd90 ("ipv4: Fix IPsec slowpath fragmentation problem")
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Link: https://patch.msgid.link/20261030042229.74068-1-kylebot@openai.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_output.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1150,16 +1150,16 @@ alloc_new_skb:
 			 */
 			skb->ip_summed = csummode;
 			skb->csum = 0;
-			skb_reserve(skb, hh_len);
+			skb_reserve(skb, hh_len + exthdrlen);
 
 			/*
 			 *	Find where to start putting bytes.
 			 */
-			data = skb_put(skb, fraglen + exthdrlen - pagedlen);
-			skb_set_network_header(skb, exthdrlen);
+			data = skb_put(skb, fraglen - pagedlen);
+			skb_reset_network_header(skb);
 			skb->transport_header = (skb->network_header +
 						 fragheaderlen);
-			data += fragheaderlen + exthdrlen;
+			data += fragheaderlen;
 
 			if (fraggap) {
 				skb->csum = skb_copy_and_csum_bits(


