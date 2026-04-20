Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1EA4219E7;
	Mon, 20 Apr 2026 13:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691658; cv=none; b=AQkpHZQB4lYYp3/FLaGYb5fruC7VGNYXsmMT6iy4YlUcUheHwkXNmGCRILg71z1G4S0hsKuFOTAf+APz4apwQaD9WcQAbbP6lK5y6yIeB80/NEnFVXmSA30gnegBBM1U+c7kQ7a3eI27K2qqcLpDK+3L8cy1ipVj7qqPZetrd74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691658; c=relaxed/simple;
	bh=5EVXv6bswRyc4/GBSLMH/hItWshSQQAHypGJ0xBPO1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GX6IbCqTamBOpWGTkO7GObg2+RNvbtbsyGhu6hoDSun+WiUzHkfbkSbb5pcrd2p0pUx/uO13oVGbRdf50ePBQBbD1Be7X7wSBOst2X9Ti0fY4fWvhCzwy1bUD1x/rS8R/hEEKTyV8UcHlr1CyUaQ9l55V/8Q2jit2wMk8nMiV60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WNmhMs3d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WNmhMs3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D038C2BCB7;
	Mon, 20 Apr 2026 13:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691658;
	bh=5EVXv6bswRyc4/GBSLMH/hItWshSQQAHypGJ0xBPO1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WNmhMs3d2BDJCx/Fk6uVd4js5j7GgJt2dk7rgLHLBlLhwZIWx6v1QSmnqBehKal/U
	 OozMuHJolZbo8Ua5LxIfuStUcpowr9k63UHWW2PLvwbt1Snt/SirnxuxtqTnqJaAMv
	 cCr0GRjbpPlSrwtzmCdxxjMYGBNSrbh3s0wSuSCmJkbzBef4ectPXLNf06gp3aSR/w
	 GSWQGUvxbfMF9W7Vsm40D6zGTjT3CWnyd6qiOgZLkXFp+MRFi4mD3kupRNI/ZhBXc1
	 pBjv2N8gym7b+TxxbVgKkmibB5mvSAQBdI3+z8tZFXaYSGFXkpQiOHVpx0k//1+9iD
	 EnxycibP5mVaQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	dsahern@kernel.org,
	davem@davemloft.net,
	pabeni@redhat.com,
	petrm@nvidia.com,
	kees@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ipv4: nexthop: avoid duplicate NHA_HW_STATS_ENABLE on nexthop group dump
Date: Mon, 20 Apr 2026 09:19:11 -0400
Message-ID: <20260420132314.1023554-157-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 06aaf04ca815f7a1f17762fd847b7bc14b8833fb ]

Currently NHA_HW_STATS_ENABLE is included twice everytime a dump of
nexthop group is performed with NHA_OP_FLAG_DUMP_STATS. As all the stats
querying were moved to nla_put_nh_group_stats(), leave only that
instance of the attribute querying.

Fixes: 5072ae00aea4 ("net: nexthop: Expose nexthop group HW stats to user space")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260402072613.25262-1-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 net/ipv4/nexthop.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 427c201175949..aa53a74ac2389 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -905,8 +905,7 @@ static int nla_put_nh_group(struct sk_buff *skb, struct nexthop *nh,
 		goto nla_put_failure;
 
 	if (op_flags & NHA_OP_FLAG_DUMP_STATS &&
-	    (nla_put_u32(skb, NHA_HW_STATS_ENABLE, nhg->hw_stats) ||
-	     nla_put_nh_group_stats(skb, nh, op_flags)))
+	    nla_put_nh_group_stats(skb, nh, op_flags))
 		goto nla_put_failure;
 
 	return 0;
-- 
2.53.0

