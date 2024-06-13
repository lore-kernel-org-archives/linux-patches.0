Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162482566;
	Thu, 13 Jun 2024 12:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282652; cv=none; b=pTg1v9UgmRfQbcNbvTwfF3f0B4/zIV43s236ItLKe8GhJrHmlV7vcVdCQKtSncyPuqcJADVLO69Kzi9GntFUG6WfCR6zl9gVciyG8O3l/Gg3L3OH0XMyks5NEmG+gPgY/n6xU15HdMtv+KLYlAGEcI51gGsJmwb5IgPBMPj/mPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282652; c=relaxed/simple;
	bh=Q7oMi45LINcSbQSsZDUhcIFx0bkFDlU14o+EVIQuJOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtpsIfvsA4SxGJzpdwZJBZC/48YlBQI/7Qo6Adk03YIvj0Jl2EaHZm6PGMGXcz6c6YQM54TDS7nL5KktvDuwHOVHiFRaV7HgzHysXjemEydSdXioIOUvAy0gkKSw2l5gYDiXbbB29jj7yOAzKck8TzmnFYCBln5FjAcvFxtxRf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cF7WAfIW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cF7WAfIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91782C2BBFC;
	Thu, 13 Jun 2024 12:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282652;
	bh=Q7oMi45LINcSbQSsZDUhcIFx0bkFDlU14o+EVIQuJOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cF7WAfIWMPskr90nhxl32Ilt9Txn0zoo+9gjwUB6Nf2yrtALwzwTYZFEBn0ctfF7o
	 le549WOIZLAnLM4C5JHG1dO9PLRqpKw78lRhgZRH0yqhu/bdXIF86n5atKcOHjDFL8
	 cRL5FJoVEqQt83LWIA1zFNZNlHa//3pme4hLiO0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 319/402] netfilter: nft_payload: move struct nft_payload_set definition where it belongs
Date: Thu, 13 Jun 2024 13:34:36 +0200
Message-ID: <20240613113314.582108257@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit ac1f8c049319847b1b4c6b387fdb2e3f7fb84ffc ]

Not required to expose this header in nf_tables_core.h, move it to where
it is used, ie. nft_payload.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 33c563ebf8d3 ("netfilter: nft_payload: skbuff vlan metadata mangle support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables_core.h | 10 ----------
 net/netfilter/nft_payload.c            | 10 ++++++++++
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 9dfa11d4224d2..315869fc3fcb8 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -74,16 +74,6 @@ struct nft_payload {
 	u8			dreg;
 };
 
-struct nft_payload_set {
-	enum nft_payload_bases	base:8;
-	u8			offset;
-	u8			len;
-	u8			sreg;
-	u8			csum_type;
-	u8			csum_offset;
-	u8			csum_flags;
-};
-
 extern const struct nft_expr_ops nft_payload_fast_ops;
 
 extern const struct nft_expr_ops nft_bitwise_fast_ops;
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 4192f0e366554..e5f0d33a27e61 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -629,6 +629,16 @@ static int nft_payload_csum_inet(struct sk_buff *skb, const u32 *src,
 	return 0;
 }
 
+struct nft_payload_set {
+	enum nft_payload_bases	base:8;
+	u8			offset;
+	u8			len;
+	u8			sreg;
+	u8			csum_type;
+	u8			csum_offset;
+	u8			csum_flags;
+};
+
 static void nft_payload_set_eval(const struct nft_expr *expr,
 				 struct nft_regs *regs,
 				 const struct nft_pktinfo *pkt)
-- 
2.43.0



