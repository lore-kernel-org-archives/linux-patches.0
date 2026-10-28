Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208593;
	b=IpqaoJ8lqGzw9nV0j7xSesGcICmqN7qzroXOuf43f9tBS7l0WNzXu+biKC5Fhx0HQDXO
	 YIZQlAjleZ2Os49LNSsFkIDNMFCW+1QdhSHXxvJczQpHWbKTo/u31hgV/z2AUJ2uB3WJH
	 FYAnkp6PggJ3wX3bnwN79qc9Mtc+oynf567GcW4l2zlLO6GtDXh2oEc1vW2R7ND7a7Cj2
	 QvdwlbYyu7mBaMDjuTA5rcKp0ib0kTujEbpmawjOcNiUrL4PWcsGaKx4VdMbNvVWbPlS8
	 lksQdzG+Ezlbmr3M4wIxM0rZ66rnAGlpe2QCFjHjjfHKLwFrf/o+uovjey49HvOC14g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SixDjXB83Lspnz9+XyBCOmg1+SFXZyQPEmiwQNvRrxM=;
	b=zNjjMIpEZ+WMsfqjOjPdgrkt2gWyN9v1VsRR/nQzWrM6C6cV46JpdR7TdobrrpyPsXdt
	 gcZE0THHLFOEPkay7bwnzYbGop2WYpn3vHcJ7+tdjf1LqjJA7vwyLx8Q9H1dgdRDRiO4K
	 DqeESLf8OxrphqbM6hlaToXIpuU+u0xQgjXInbELOlQ62EuKTjfJXiPepBMFAEFJXdeDN
	 XILIRIzbGQ/1ATemUAMxRUHrmVcF/eYL+5oz4ClHakz8l6wpt0qoXZpjJw2148j9LKuWt
	 mwJ7LtK/dpAhq6GX622rCgRj4CuNc4Mh/sAEsRe0KI3hLW2AmdW5MZoR5/YscYhvRFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zsMn0ojE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67763606A31A;
	Wed, 28 Oct 2026 17:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zsMn0ojE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67C51F01825;
	Wed, 28 Oct 2026 17:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208593;
	bh=SixDjXB83Lspnz9+XyBCOmg1+SFXZyQPEmiwQNvRrxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zsMn0ojE6+tJ8MtXhqapkVpENRCBA5BwVMIf7Wi+Rzhd4RQcLCVh4oHnQIoj2N1VQ
	 ifBq9invTO84q533R7UqSHNbaO17hAr40BgpZkAH5OlLkgu41Qsy5mFi8Bu5rfbYXR
	 kvMdTB4rNxz9yR3QUAj082EFODqZmKaU/Gv45Gxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 173/516] ipvs: do not create invisible templates
Date: Wed, 28 Oct 2026 17:55:25 +0100
Message-ID: <20261028170007.604957737@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 90efb3c3760c8..6cc79af875cd5 100644
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



