Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E87C367B76;
	Wed, 20 May 2026 17:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296731; cv=none; b=RAHaLpTP5rLIgNE+ruFscfWPWs94Go4EijoVceKXUu16jkl0aPUVeaFjtK6ohLITxmsHfbjim+LZ+S/0GYo60AOunlzyUGsqfXfpGk2lPDDw40aqPgODhqyKJLSaEPaxGJMcQBqABC1AOzPU/OiqstuIZ0v7AZnnoK+qs7ZV76s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296731; c=relaxed/simple;
	bh=bJhMktQYNI8mZ1AoXhzBBLSeKKveBWFDB6qLyz2zuBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwznRjcgB4tFtxhhPc/a7qR3GfDGXlCttK32pumuW1CaLbzppxj2GyrTJtMsM38hxnOvMm8FiefB1hOd6dlQlmHjBGiD1z+IfLPlWIdpEoI1E7ARNz30jVe3Edtx6sYYqg2YIB3mlMFI+SJdsOJaAfCSKrQkyJqG4HTLrnWAQRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UqHSmlR/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UqHSmlR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACDA1F000E9;
	Wed, 20 May 2026 17:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296730;
	bh=N7ruRI3Vf1ORvIParAqtn4VIT/cnU3l7bpec6Q2NzKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UqHSmlR/h+0998OX0kLJesm4nbRXwVZv1RI4DgcAEsqIGtC6AnNb9LBWqR2Dus3mC
	 aZSt/hqydE+NFCj6VGB19mgoXOLpNoRJRz1+Pz5yCzMTowBMoIEvFci4anPysEW4gI
	 9MMSYRlmExDWj4dKy/ESskgsFBKa1GMOZVDQULVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Jiexun Wang <wangjiexun2025@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0908/1146] netfilter: xt_policy: fix strict mode inbound policy matching
Date: Wed, 20 May 2026 18:19:18 +0200
Message-ID: <20260520162208.788938393@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiexun Wang <wangjiexun2025@gmail.com>

[ Upstream commit 4b2b4d7d4e203c92db8966b163edfacb1f0e1e29 ]

match_policy_in() walks sec_path entries from the last transform to the
first one, but strict policy matching needs to consume info->pol[] in
the same forward order as the rule layout.

Derive the strict-match policy position from the number of transforms
already consumed so that multi-element inbound rules are matched
consistently.

Fixes: c4b885139203 ("[NETFILTER]: x_tables: replace IPv4/IPv6 policy match by address family independant version")
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Jiexun Wang <wangjiexun2025@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_policy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index cb6e8279010a4..b5fa65558318f 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -63,7 +63,7 @@ match_policy_in(const struct sk_buff *skb, const struct xt_policy_info *info,
 		return 0;
 
 	for (i = sp->len - 1; i >= 0; i--) {
-		pos = strict ? i - sp->len + 1 : 0;
+		pos = strict ? sp->len - i - 1 : 0;
 		if (pos >= info->len)
 			return 0;
 		e = &info->pol[pos];
-- 
2.53.0



