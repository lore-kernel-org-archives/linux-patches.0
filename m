Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1681F69317;
	Wed, 21 Feb 2024 14:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524504; cv=none; b=mCs+lHcIkw8E1CEZspJeXiCQlM/Mw4FV5TDr+IbEXLz6+Y93qYkewKU2Hl+VhygFWgx6vJjqsUMXuBL6APnlQ6nXcGC88JiS28Q1zNwrjX7faly/Ps4iWKB6FwBPFqPUgd3u9meV5479z+VW0X2WuGXTsPjjpwPkUXc/tT/mT9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524504; c=relaxed/simple;
	bh=xSsX7u9zm91v3aI6HlQQd5vNO0sIEbjGRxpkbGwZ5p8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uM3LCT7VoWIXuGJxDdG/R6t6of/WAkF3RCp5fpQp68jd4NX5f4drkcnePYppFqKBAfRf7p6WAsuBwl3TFNLAcyxvVrWqEhLgn2LhPsIPfxrjt4QlW+Pqn0BtnHlN1VJsKzjtO5LdrrcdvvYcwtSbEb9XVfv+dWIwTWH2vCZCdD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUgN+IlO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUgN+IlO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D91C433C7;
	Wed, 21 Feb 2024 14:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524503;
	bh=xSsX7u9zm91v3aI6HlQQd5vNO0sIEbjGRxpkbGwZ5p8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUgN+IlOa4TLOF0H2cxpymVz2rV79/obzOdIkUKfNRl0BZJZK5/bdlcXsfsHFuADU
	 eQrY3DqPEB9BLzBapOtb+pB3yQfXNF9Fbox3zMFNJzBKtgXQ35c8saMeSZ3e7M89dg
	 5bLFGVgIK4pXHl4LhR/+M7gR/m9FR2cIks7aIb7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 265/379] netfilter: nft_compat: reject unused compat flag
Date: Wed, 21 Feb 2024 14:07:24 +0100
Message-ID: <20240221130002.752228472@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 163b7ec577e7..f93ffb1b6739 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -262,9 +262,11 @@ enum nft_rule_attributes {
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
index 3f1e272efbb9..025f5189f2ce 100644
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



