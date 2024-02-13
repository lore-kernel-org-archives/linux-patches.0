Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C85B5F54E;
	Tue, 13 Feb 2024 17:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845148; cv=none; b=smT2V0t3k34WNC4OujXhuCVLb5EHFr+awyhiz8rIFoGYpv/dmVBC/vdKY7/kBrk67QHo+W0jaoQoZC2beOTFUREL0YsC8KOZJk7RoW2APStpa7T5ETeNRNzh4lxj+RvvOU8gTUyWuNaD54Q90ltN30WJrOx+ZVf25RJ743a1kaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845148; c=relaxed/simple;
	bh=xNdtKnM/EPjiolRu2HBRRf41pi/oRsTBx/APlWqWtWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKuTQ/mfifsDZXKXadgdl3aUdrjI0Z00qcNQNheYp2vs7DSXSHthUTY+sFiVrPWq9eE+Yqq8l4j2P7Trcwd3PlHkCovnOTtlHTDXgzdg7spkOyWwax3mNss6NRx3sp10KwRNT9W5uNKkNd/3Dx5ELVZkxDYSTgOqwld4PUgetQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0MT2C0qB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0MT2C0qB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B04C433F1;
	Tue, 13 Feb 2024 17:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845148;
	bh=xNdtKnM/EPjiolRu2HBRRf41pi/oRsTBx/APlWqWtWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0MT2C0qBV6dRaiB26k/0a6XAsgaUPyDVjsAM0F+0qH/oKPAlvIrioyM7oy18pqS5T
	 Bo+WZCSMExKtFwn5FT/WEL7z4jm5tHQhXwzKuhH/fKudzxhlmTDMloP5gKiCbmbVY6
	 eVcsAsCPNVEA5UHn/SFEwd9NXCoqhWBIo5BJTOT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 33/64] netfilter: nft_compat: reject unused compat flag
Date: Tue, 13 Feb 2024 18:21:19 +0100
Message-ID: <20240213171845.791080473@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index af8f4c304d27..707af820f1a9 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -266,9 +266,11 @@ enum nft_rule_attributes {
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
index d583ba50f181..05862b3ea33b 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -212,7 +212,8 @@ static int nft_parse_compat(const struct nlattr *attr, u16 *proto, bool *inv)
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



