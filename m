Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212695;
	b=qSrUPx5fgeRUTJgYGEWQqYovr1sZrXH80FLIG6Lod1NNGob44kZXjRQZs1TFEBH1im3m
	 hMppbnqlllvFVxTeF6vbKHmJ1P4lWuVnsd3ZRRFo0carmmeVjOV9bRRpg7IRgvlrZobRC
	 AhflDXmOY47YvBHhmZzuED53+W0aKTMVzRCXUtPt5aV+Dpvg33GNDAtaUQ9W/+3lgoyfw
	 lZm1MXs4sXEoyS6fjkG2fiS21uw8l2MSJb0+SQ54s/SjeITjhWEQnOzdU4PzAJuX1PM2h
	 G1gNWwOHnKACU8LVjdL6a5ik+1EG7xyxgU877GI/bRLFh4z59c52m7aAPJ1PRdLmaEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212695;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cf3RNdhAIG0t9hVy5AsI0w5nvAp5Kq5WGFeO7lxPfkw=;
	b=uhciOAUnrWi5Xeu3wFimXEQJrnkVd2P3+FTQjBVp85F09UaR66DxnCaf3JIuS8VUISub
	 2OvSwZBr0tOlH8TfDaa1O2ZcHwWh+OtBFLv2OQGDs6PoijYYg/PMTdaau0ld36bPxlhgp
	 QMufRcBuXXMSVdo0bitKc+sRTBWmkAGc4IiWwdoxZ9LHYloMU1gz8C2PYPufP6RRymAPb
	 G2opxe/AphqOs8mdAK6hP/cBmuPF9qS0PoJmQc1edl84//fvEs/xvRq0LA2ppDvacWyG0
	 UqokRgRX5s5JZBfd6y8VEocqwqwTyT56OtmAuFsuwygoSuD9qwuo5aEj9/rU1wenFlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q9W3RXnL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C92606A31A;
	Wed, 28 Oct 2026 18:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q9W3RXnL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BD91F01825;
	Wed, 28 Oct 2026 18:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212695;
	bh=cf3RNdhAIG0t9hVy5AsI0w5nvAp5Kq5WGFeO7lxPfkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q9W3RXnLuJ4JAdXwx18H8LXmhJ05qmFO5ynLxH2Bom8+AVYS7ylkuo8uSyLWec19M
	 BKtHyIZwT5cpkacp40eygA5ArLVN+JTBYGSNmOJVqzir27m0cyP+6kkkUv6V50ZYI+
	 yCf7kJ3Ybh9tiqUwSEIZjbRlXPbnzoI6Fc77xaE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0242/1887] ipvs: do not create invisible templates
Date: Wed, 28 Oct 2026 17:38:58 +0100
Message-ID: <20261028170504.739052519@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit 616cf5c06934364ab1002b420ebe975850b4b208 ]

The IP_VS_CONN_F_ONE_PACKET flag was implemented for normal
connections. When conn template inherits this flag from
dest->conn_flags it will not be hashed. As result, we will
create new template for every new normal connection.

Fix it to allow one template to be used by many normal
connections.

Fixes: 26ec037f9841 ("IPVS: one-packet scheduling")
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260916231652.127456-1-pablo%40netfilter.org
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_conn.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 44ebc7b1c8134..50a768bf83bc2 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -591,6 +591,9 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, struct ip_vs_dest *dest)
 	if (cp->protocol != IPPROTO_UDP)
 		conn_flags &= ~IP_VS_CONN_F_ONE_PACKET;
 	flags = cp->flags;
+	/* Only visible templates can control multiple connections */
+	if (flags & IP_VS_CONN_F_TEMPLATE)
+		conn_flags &= ~IP_VS_CONN_F_ONE_PACKET;
 	/* Bind with the destination and its corresponding transmitter */
 	if (flags & IP_VS_CONN_F_SYNC) {
 		/* Synced conns are hashed, so they can not get this flag */
-- 
2.53.0



