Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB8779DAE;
	Wed, 21 Feb 2024 14:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525554; cv=none; b=kn0HG641UfPdqXRy5kWZdosNefVhMNWeREaQM6zv8q/sPtcJOfjBw6xhJrc1K2kRxKmpQt28nVo3I+5mlMpXrVZgcHf/7DtyQwAeYtvzIz77nug6unjQWycX2zgXmh1g/fYuuZI/aI0hWlNNK3TRfuP4xONCF2qR/kgCbcns1a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525554; c=relaxed/simple;
	bh=1G8S8Nx1xn9cwFNc83O2yqcg0u9izUdiAADHWG5d6UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGey519qNtWg0hkrszjt52bsYYMnI+vCluqumRx88aur5+Kg0VJ0d/Xx5sOWm7lcEbUFoUZxJySxN2uA4mckL9lgyyfdPb58Xzc201KgYnEzqkfJxuBWc2bMtRnIIxSttAlOyWojnS5osY121phFwatfTuns5U6PFUBdYIQhtCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RnEtmcYI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RnEtmcYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7B8C433F1;
	Wed, 21 Feb 2024 14:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525553;
	bh=1G8S8Nx1xn9cwFNc83O2yqcg0u9izUdiAADHWG5d6UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RnEtmcYIXEJZFh1SpilLoCV72OJFtSTqptA3A9D6BUQAstErHbwEFvJLCpPzFuoE0
	 wehI84HvqxYdmjnT9+skBFvs67lknQ1f6Hm3RV1QoJYlhuBJ3LMV9pfUnIYv/7VhfI
	 J+36BLxvlu8ZggVnOKf3fmxC+JShu6p1iKuLvHYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 191/267] netfilter: nft_compat: reject unused compat flag
Date: Wed, 21 Feb 2024 14:08:52 +0100
Message-ID: <20240221125946.131877311@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 292781c3c5485ce33bd22b2ef1b2bed709b4d672 ]

Flag (1 << 0) is ignored is set, never used, reject it it with EINVAL
instead.

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 ++
 net/netfilter/nft_compat.c               | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 6a08c03a511d..bc70d580e8d6 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -243,9 +243,11 @@ enum nft_rule_attributes {
 /**
  * enum nft_rule_compat_flags - nf_tables rule compat flags
  *
+ * @NFT_RULE_COMPAT_F_UNUSED: unused
  * @NFT_RULE_COMPAT_F_INV: invert the check result
  */
 enum nft_rule_compat_flags {
+	NFT_RULE_COMPAT_F_UNUSED = (1 << 0),
 	NFT_RULE_COMPAT_F_INV	= (1 << 1),
 	NFT_RULE_COMPAT_F_MASK	= NFT_RULE_COMPAT_F_INV,
 };
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index f01f3cf4f8f5..44583da6ec6b 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -204,7 +204,8 @@ static int nft_parse_compat(const struct nlattr *attr, u16 *proto, bool *inv)
 		return -EINVAL;
 
 	flags = ntohl(nla_get_be32(tb[NFTA_RULE_COMPAT_FLAGS]));
-	if (flags & ~NFT_RULE_COMPAT_F_MASK)
+	if (flags & NFT_RULE_COMPAT_F_UNUSED ||
+	    flags & ~NFT_RULE_COMPAT_F_MASK)
 		return -EINVAL;
 	if (flags & NFT_RULE_COMPAT_F_INV)
 		*inv = true;
-- 
2.43.0



