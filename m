Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211013;
	b=oscKFyDySg3WRT/dWqjyQN4PmSFDD02XVh5f2jiMRtlEo98k7R+NFdrHWds28Dx3kHyM
	 ZgXgwvqhuM9gqiooeV49xtdSDCRqgFw6ux+XYr17YEKl0OIKdeuWStBal2mpOLKvL7kS0
	 cnBa2I7WsAbDFOhiBZXPBp+xdBOkxoNeVUmHl4GE1vRrMaXtm/Z9DpOLwsKJ8TjVjnB+/
	 NE+hoTPB5jyjyZnlp+PPK1fP1FrWPvAP0xp3cE2SvW3tjIPJ+Cfp31JhRk29BP0wafHtF
	 PVEhch+5SmyYYgUN8JrzT3tPj/lF7bAhClxQGxrPu3IDNDrm7CPfpH7777bhcCHxTLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hRzvqJQnRW8BAqL4yEu9DQpDq6mPKQ1Zc0YUPqCNCjk=;
	b=ar8akUsEyGoEH7zpePJDDlt56I/66ZvOC5W1BmJpupXw/4x7mcaM/XKP2pGAieirNW2z
	 HB9W5zgx0TYF8/x39ALqqOGq3ikOgPrIEXwTQnvGELD3gvWyMOae+x99y1eAS/jKUPEbM
	 n5nL1acRhbvYyMAHcbF+QC3Fq2vJydYqVYsTmJFS/ghIv1N9OfSoPDV4ACF6I0VFHyUzw
	 mYHk9j15FA3UqubntWbBDEq+EsJJsed4E3EwxzGiYJJj7IhLJfFTmwXYIOasif+rc6B8a
	 TGDsL6xafM2kGLOcwB2XU8HqdEw50WeRA/U10cpTD3XxU1VGmX9zp1mg+uHfNBMMDuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qMC1ZbN4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D33606A31A;
	Wed, 28 Oct 2026 18:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qMC1ZbN4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DA61F01825;
	Wed, 28 Oct 2026 18:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211012;
	bh=hRzvqJQnRW8BAqL4yEu9DQpDq6mPKQ1Zc0YUPqCNCjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qMC1ZbN4D/1XyevB+lTuuMzQK7vY/K5naTfd0CPcK9sO6Tce17vJPxPc4HFOzJs0e
	 npIBNHZ3g12adcagA/IWn13xw2oLoZ1F2ebewWjnK8ymvsX2sPmo/EISaEfp8KPRGg
	 qAvLg+34g8D8JH5X9ZLkJgH/KpE240wE8VgmpfiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 183/571] ipvs: do not create invisible templates
Date: Wed, 28 Oct 2026 17:55:30 +0100
Message-ID: <20261028170012.354427515@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
index 73361a4df43b4..bc150438c452a 100644
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



