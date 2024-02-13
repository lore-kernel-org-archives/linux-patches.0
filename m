Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0E45F54E;
	Tue, 13 Feb 2024 17:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845145; cv=none; b=Z59FSSs+gFMEPqRTK64W1Y3PvdM3LrtBTCBFL23qBffOSyzr6IyKm3NO/IUPVqqgdqnBbRrPMxVY2LNQbGJHyz9FOdiDqVkwiJo8stPDc8H24fkV4bdBtOBQE1UnhGA6KP/2mdE7NEBchPLFRijRq8rbWlOzrtnOlnqhElOIa8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845145; c=relaxed/simple;
	bh=n+vbUVJacupOe2zSjVqJ1kb3+0VxFRheCVPG2spDcVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Beq5nMg0qSbQB2wAnlP1bxcxRjNzwPw7QHNyX5+hCHd1RwIy9RhrUKcH88LYPD/CMhAvo+j22znHhgvxXwA8S53itD8ZycEeJ3MpRgU2yw7Zqub38lTEZQRP5dhFiKBVx33JIRUXZBmd/EQ/DWCKUn9tckoyqRQrqkmq/Pg6Fu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOVrU46a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOVrU46a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A6EC433F1;
	Tue, 13 Feb 2024 17:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845145;
	bh=n+vbUVJacupOe2zSjVqJ1kb3+0VxFRheCVPG2spDcVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eOVrU46asEDnAvxaQUtm84KNgclcu0UBqhLVK1Z9hd26NincXyvzVhPpRO6MmAGnq
	 7bvze1yS4zwTZm3pPJSVtK/A0a1NVQeW8HjAsuv7NtuUFc/TUbK62sRRx5MXzuI9By
	 C3Vczt/raxV0sOutCY7fCAgvsCdWtVnhOu+snmuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 32/64] netfilter: nft_compat: narrow down revision to unsigned 8-bits
Date: Tue, 13 Feb 2024 18:21:18 +0100
Message-ID: <20240213171845.762469084@linuxfoundation.org>
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

[ Upstream commit 36fa8d697132b4bed2312d700310e8a78b000c84 ]

xt_find_revision() expects u8, restrict it to this datatype.

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_compat.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 6952da7dfc02..d583ba50f181 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -135,7 +135,7 @@ static void nft_target_eval_bridge(const struct nft_expr *expr,
 
 static const struct nla_policy nft_target_policy[NFTA_TARGET_MAX + 1] = {
 	[NFTA_TARGET_NAME]	= { .type = NLA_NUL_STRING },
-	[NFTA_TARGET_REV]	= { .type = NLA_U32 },
+	[NFTA_TARGET_REV]	= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_TARGET_INFO]	= { .type = NLA_BINARY },
 };
 
@@ -418,7 +418,7 @@ static void nft_match_eval(const struct nft_expr *expr,
 
 static const struct nla_policy nft_match_policy[NFTA_MATCH_MAX + 1] = {
 	[NFTA_MATCH_NAME]	= { .type = NLA_NUL_STRING },
-	[NFTA_MATCH_REV]	= { .type = NLA_U32 },
+	[NFTA_MATCH_REV]	= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_MATCH_INFO]	= { .type = NLA_BINARY },
 };
 
@@ -721,7 +721,7 @@ static int nfnl_compat_get_rcu(struct sk_buff *skb,
 static const struct nla_policy nfnl_compat_policy_get[NFTA_COMPAT_MAX+1] = {
 	[NFTA_COMPAT_NAME]	= { .type = NLA_NUL_STRING,
 				    .len = NFT_COMPAT_NAME_MAX-1 },
-	[NFTA_COMPAT_REV]	= { .type = NLA_U32 },
+	[NFTA_COMPAT_REV]	= NLA_POLICY_MAX(NLA_BE32, 255),
 	[NFTA_COMPAT_TYPE]	= { .type = NLA_U32 },
 };
 
-- 
2.43.0



