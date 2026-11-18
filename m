Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039465;
	b=tP9ciyakCN1jwTitcHBlCo6acuCez0cKbFJ+kkTJe7BHcf9q3Wpq6kwkKjMiroUGi70P
	 ElS25HTMw+pzxwaOG7gQKq4oKgMUPQjl7gmQO1G5nVMucDflgFdVpYz5Uzt2TNKREvaac
	 ymLmPKsDbk62pO8Rp5uTHj2nSGuAmF+wuZhxdP1FNc2kDhWCYK8mPBMLlih3EiImCmvHZ
	 l+qgi44dUeOdwOnYW7ud8G8Amh+1C/DxtshpB9i1CGgVqu5tZ7DVKitj8SgiqY7vjGQLS
	 rqhdTuOd+ZKwxcY6+YgCKFhJ6ceHbxhoxg1C7sZHYVtP+EkHyf9SUqxconvhQCZe7jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039465;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DQWcWVW+ebJuulZQBLxXgiy+/gaXCsi0doT/UPI0Bus=;
	b=mQeuZncRGRcZUSli0nx0AhVmnuYSBK47MAsiqXVt421rzlO9057hkVvfPnpDMV5Me5Yh
	 pR7gOx0fbeeHavrzDK0f1kcXxuEn7Eha2qNXvCiczd0ZCoXGO1Epj4VZb2LyOMI0lbLjM
	 CAKULfWZ/mQKgh/Soxh/zlvSYmGXfxj7jGDekCt//+bnG8uFiYm+vL4TWtahe8vBSEC8/
	 Q2EMPH0hWj2NHIKZ87wwhsA5XDg5t0onXJVi6+O/xn5bf47eYMsgDnjosrPBDb6P1/j0g
	 jdzThuNOZGxKv951AmmQ8xkYktnEmunyxXjvbPfLAvD+T/fqobhadVrbpZRmlTVhDaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zcM3CdFr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40960606A320;
	Wed, 18 Nov 2026 22:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zcM3CdFr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975C81F000C4;
	Wed, 18 Nov 2026 22:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039465;
	bh=DQWcWVW+ebJuulZQBLxXgiy+/gaXCsi0doT/UPI0Bus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zcM3CdFrttG9881mHov7xu7recRhDCmXxwkcpsHdUDmY7VIH99Xrd06hXDifyU8aR
	 tLNxgGACtIlrPy25qP4fdMk2qNKvI2OoeBwKGyxe8yIPgRd7x7XZ77BXxybM6Fmv7b
	 EbFJ8qFq0EzAjzqKfMesT0/haS5Lj4u+64ES98aY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2111/3318] selftests: net: csum: Clean up recv_verify_packet_ipv6
Date: Wed, 18 Nov 2026 15:45:33 +0100
Message-ID: <20261118150425.400341390@linuxfoundation.org>
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

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit d772cc25ccf772f4cbb81270970cbe1356c23d3e ]

Rename ip_len to payload_len since the length in this case refers only
to the payload, and not the entire IP packet like for IPv4. While we're
at it, just use the variable directly when calling
recv_verify_packet_udp/tcp.

Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20240930162935.980712-1-sean.anderson@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8342c68435dd ("selftests: net: csum: filter packets by source address and port")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/csum.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/net/csum.c b/tools/testing/selftests/net/csum.c
index eef72b50270c5..89d3bfd969099 100644
--- a/tools/testing/selftests/net/csum.c
+++ b/tools/testing/selftests/net/csum.c
@@ -675,22 +675,20 @@ static int recv_verify_packet_ipv6(void *nh, int len)
 {
 	struct ipv6hdr *ip6h = nh;
 	uint16_t proto = cfg_encap ? IPPROTO_UDP : cfg_proto;
-	uint16_t ip_len;
+	uint16_t payload_len;
 
 	if (len < sizeof(*ip6h) || ip6h->nexthdr != proto)
 		return -1;
 
-	ip_len = ntohs(ip6h->payload_len);
-	if (ip_len > len - sizeof(*ip6h))
+	payload_len = ntohs(ip6h->payload_len);
+	if (payload_len > len - sizeof(*ip6h))
 		return -1;
 
-	len = ip_len;
 	iph_addr_p = &ip6h->saddr;
-
 	if (proto == IPPROTO_TCP)
-		return recv_verify_packet_tcp(ip6h + 1, len);
+		return recv_verify_packet_tcp(ip6h + 1, payload_len);
 	else
-		return recv_verify_packet_udp(ip6h + 1, len);
+		return recv_verify_packet_udp(ip6h + 1, payload_len);
 }
 
 /* return whether auxdata includes TP_STATUS_CSUM_VALID */
-- 
2.53.0



