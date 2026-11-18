Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025155;
	b=My5atFDGupgjcCz8hHdW8DYYyt1dutZEWJNUr69ZjJZeg8lwtyKKfPysDpV17Kt4NgyF
	 LCjQRN6/Hyqft7oMzG90qL08vhM74nGpMt9i0vqKD3EX8OnMn2+kxO0MIM0V5Xr3vghmR
	 +ZGTwbvqp1yCqkCOGRGCzPFZdlUDth80bGhjU2fgDtgZPqmK/uxC9LS5maWn+u6G8woCt
	 OP9wnWXEwKBTKAWpNT+dGhc/pNbpkocIhckLIcQFDbKKn70eJXUczIZG2l/yOCxFKIoYv
	 klYZS7mPN8WpPSzQlq0GehYcBxjwTNLhz/1RaaCce7x+LBP3n8qCQ4YHOA9Lcguig6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OfTFIpj2LOxQTEb0rAyXTpxsNqbxT3SeyYuNgtZa6wc=;
	b=t0Fyc+hSE6u+KmD9+gQnxFKTvalxwMwAoANYJ6wfX+ItZgalIy/geQMOG0jeQIFAVbag
	 zdRO/CTEWs8cTin2xZUS+ub3Kj8/DBmwYahA50iuIZs6ztCkO4ab6SZYMS2SdtEph+3C1
	 tlhmO2DzB4wO3nyBHq7uVCQ+zo5Ghdp8aR3EoYYk7SA4w6dHroRxWbJvYp+0PF7ir/h2I
	 5Vp3FT11QtaAmkRi1sC66oBFOIVWlzJ39s1NWEAZ7c9izGnhT+MM+mLnqSv7n8cTvI+WK
	 dj3sRD3cCQ7quSQial2GckSZKayl6znlscbFqelbVJ5JoJUWtBcvj2ApplsGkzfqiNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S2yFtW2f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D62A606A32A;
	Wed, 18 Nov 2026 18:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S2yFtW2f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF921F000C4;
	Wed, 18 Nov 2026 18:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025155;
	bh=OfTFIpj2LOxQTEb0rAyXTpxsNqbxT3SeyYuNgtZa6wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S2yFtW2ff+wdMKyaWWpZDqSpsWRGjZiR10BPVArpJqiS7ASJ+vTNAiaSK332Dt5eL
	 8gkXIVWqfMPQnXzo2U72buKhKUEJluW/64i9q4wO//xwMTi3xG1K63aY59GyfwFMzf
	 m0oqwLjvFz4Cg+/YyjRf8y20lIFQMmhLtb99Geww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Omar Ramadan <omar@blockcast.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0928/2151] amt: pull the AMT header behind the transport header in amt_parse_type()
Date: Wed, 18 Nov 2026 15:44:23 +0100
Message-ID: <20261118150156.276803933@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Omar Ramadan <omar@blockcast.net>

[ Upstream commit eb0c18404c8943356f4aa164e5db9067b79ea93c ]

A gateway's encap socket passes ICMP errors to amt_err_lookup(), which
calls amt_parse_type() on the quoted datagram to see which AMT message
failed. On that path skb->data points at the quoted IP header and the
transport header at the quoted UDP header, and icmp_socket_deliver()
only guarantees the quoted IP header plus 8 bytes, that is, up to the
end of the UDP header.

amt_parse_type() pulls sizeof(struct udphdr) + sizeof(struct amt_header)
bytes from skb->data, which on this path stays inside the quoted IP
header, and then reads the AMT header behind udp_hdr(skb). An ICMP error
that quotes only the IP and UDP headers of a Request, the minimum RFC 792
asks for, therefore makes it read past the pulled data, and past the end
of the packet when nothing follows.

Pull up to the transport header plus the UDP and AMT headers, as
vxlan_err_lookup() does. amt_rcv() is called with the transport header
at skb->data, so the pull on the receive path does not change.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Omar Ramadan <omar@blockcast.net>
Reviewed-by: Eric Dumazet <edumazet@@google.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20260928181557.85796-1-omar@blockcast.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 3f4e974762926..96cde820237d3 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -1289,8 +1289,12 @@ static int amt_parse_type(struct sk_buff *skb)
 {
 	struct amt_header *amth;
 
-	if (!pskb_may_pull(skb, sizeof(struct udphdr) +
-			   sizeof(struct amt_header)))
+	/* skb->data is the UDP header on receive, but the quoted IP header
+	 * when amt_err_lookup() parses an ICMP error, so pull up to the
+	 * transport header rather than from skb->data.
+	 */
+	if (!pskb_may_pull(skb, skb_transport_offset(skb) +
+			   sizeof(struct udphdr) + sizeof(struct amt_header)))
 		return -1;
 
 	amth = (struct amt_header *)(udp_hdr(skb) + 1);
-- 
2.53.0



