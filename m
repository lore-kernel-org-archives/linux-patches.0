Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213481;
	b=tJUkAfS2tvOnDGvENYQra8I9/f4XSsMoE1Y1hey4BdODBnE/jfqrtviQlLjQXg61zK88
	 ca/BxjkdKWZfd0F0C7zHaeedPoKNHQf55Fyn17edF/l+5VXQrLcmKw8yW9W+3aYTUThcA
	 fhJdOkbBnosQQQcOLPbDftaZcz1yvuNXj/i4C65MVbxeVeJ8P6ni1GgOzCASJq4/FCNfw
	 JBOYOHApquX7DQ9CJmWNxb7v/BYihB+yZoj/DaNDCrkwOxTH/pZx3cBodSJPJd79DvKS4
	 Ke2MC7GLnDCTVTL7u4WtN2D+q9bnaJKsT0It8gpZnl78Ti+tNkV38M4BZ2BEK+Mwb3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213481;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=85pPu74+E3kUcwv53vRTJZcF8XyS4U5dyl90n3VJUTA=;
	b=2uY+X2PCiBzy/rWPY7V6Dj/jNMb9RaQtkHO5/h1CdA0XQqAtglsq5GjEWdgwIIgD+wIi
	 RKsj7axl9br5dWZR7CYQwdE0GZ1GW/OMC8uV5kOcRpyppSeLb6LG4fjRdins7/mX/60ew
	 0nVfR2XggkUgShpRobodIuH+JwqTc9mnlJFb9KoV2UNySoPvNDy+66O3d+0agB/21U2DF
	 8qGoONsyqIUkJNSKLnyQcF/4b8n1MKndjcveinzgTjDls/ZLytsUBv1WJX5ovLA4sooUq
	 FrxoyEQckmaWf4342/ruxcv7qsvRZ8CAKt/v4zbUvIhR5Dcwwcaxod5+7ZKh7PWNLSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vTKmdglD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D0B606A31E;
	Wed, 28 Oct 2026 18:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vTKmdglD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FF81F01825;
	Wed, 28 Oct 2026 18:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213481;
	bh=85pPu74+E3kUcwv53vRTJZcF8XyS4U5dyl90n3VJUTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vTKmdglDo371UOzH2paaPn9K7WwiVIuq6W3vSHzCER/lTFloBD3A6dxUbrvYsbCzR
	 1AcMnVvR1V01AXkMYq8aTMeKco7cmsDlITh8DceaO+Txe0PKGXleGzuSyrenGoFq0p
	 zuL/fpNzgoAxQ96wl+KXMXoeSTaueAHOV5pRNJPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@nvidia.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Felix Fietkau <nbd@nbd.name>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0520/1887] netfilter: nf_tables: fix bidirectional offload regression
Date: Wed, 28 Oct 2026 17:43:36 +0100
Message-ID: <20261028170511.160086564@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 84443741faab9045d53f022a9ac6a6633067a481 ]

Commit 8f84780b84d6 ("netfilter: flowtable: allow unidirectional rules")
made unidirectional flow offload possible, while completely ignoring (and
breaking) bidirectional flow offload for nftables.
Add the missing flag that was left out as an exercise for the reader :)

Cc: Vlad Buslov <vladbu@nvidia.com>
Fixes: 8f84780b84d6 ("netfilter: flowtable: allow unidirectional rules")
Reported-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_flow_offload.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 4bc2664f33958..c65175ef47816 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -374,6 +374,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (tcph)
 		flow_offload_ct_tcp(ct);
 
+	__set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
 	ret = flow_offload_add(flowtable, flow);
 	if (ret < 0)
 		goto err_flow_add;
-- 
2.53.0



