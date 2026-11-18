Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029269;
	b=q1J4CWF5t2HMWv7ew6Ze1pD13gGFtk4pLqyKIdUtSpZk2pza8DjTq6uQUe43MJ9cK+gg
	 gKfyhB7aH9fI9mY/mnfSCXkZZnK4yvRq2otE0DbruMp2jxhLzH1F5gUnuwb+x64kgG5dp
	 7CyJ0ajHgw9fvc9dp0gg8srAabzhpB/eemCPTQyExKlRbO/H2nvkUBdxX7CVnhR/AsJ/Z
	 Zv/v6SQ9Ak3cZtAuRH2jc0T0ppTSPidGbkjGGD/oElncfaadZNpGm+8uzTG3ORMa1QnSI
	 dAtwuypDDDI2yz2oZ7Uig/Idj38SGxgoHJEfQYM+uPfVrxgvXVJAkQ6uk9f/+m3mpwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MSVBFV1Q7D//2u3+fgZP8SUH2ag7cu5FHGkb+yiuJFk=;
	b=AEZkqkplQSj2UPAAsXt06+/S2kFj7tYEQYzmy3zxXnthukV7eomSHirpFFZv+ENkpYJL
	 SRHnSDaZiQk5QpuCu4BaaJf+z5bHIHzWPC7czzqcstKjKx7vMOesrWl9hrl5qBMTRyuvN
	 0Pj3XjRHUTKNe2Z/aA7RNxiJPJcubIksCxC1F2vYETtnRxpgefY31z/1D51Lp1y3l9s4o
	 yt8ERajf2an8TgSBXb5vcBhrVVMXNmTOhZ8FTLCRmHRZrVypZjn4O9qp3dZHbmET2lEJy
	 rKe2rRriHRrtcKz48rL2kRAarodjBvMcCU0Gy+zuVXmY4F6H6xZhouJb6NnNNM6S/Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qbZUt1CM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A60C606A31C;
	Wed, 18 Nov 2026 19:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qbZUt1CM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581C71F000C4;
	Wed, 18 Nov 2026 19:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029268;
	bh=MSVBFV1Q7D//2u3+fgZP8SUH2ag7cu5FHGkb+yiuJFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qbZUt1CMu+wl4x3rU45rinOCCZoiI2eJPoxtrGi7NiMgLTv8LcmuDGozi0pYSYdak
	 y6a53Ynk21dJRjGVI1mLgUrqJl+i33KF+UMcKPfpn8SLoIHryuSMi58T6BfP7X/iVP
	 sA9SiGVMfGIj8SrHj+QOMieZQ4kqHyDmYNi/+Pgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0290/1756] selftests: net: csum: Clean up recv_verify_packet_ipv6
Date: Wed, 18 Nov 2026 15:40:17 +0100
Message-ID: <20261118150019.933152853@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
 tools/testing/selftests/net/lib/csum.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/net/lib/csum.c b/tools/testing/selftests/net/lib/csum.c
index e0a34e5e8dd5c..27437590eeb53 100644
--- a/tools/testing/selftests/net/lib/csum.c
+++ b/tools/testing/selftests/net/lib/csum.c
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



