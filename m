Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A051C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3F1C433D2;
	Mon, 20 Mar 2023 15:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324651;
	bh=CrlRtSmj+CpAkpqnYplqcn9+dUtNkH6NDMZXSXxVIr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o6ZuQP8jSdoIOUDEaZ1afbzSierw0nqFkh8kvG56O7jBG9rjGBOXNT4XiscPVZuXs
	 3CkvNyTL7YPcNwOW2IZ2vRb8sfu1datQxlJh9BArbt7bhLlf00fCCpv8LVmTK90dvd
	 BoJiPaQM6agiXCVLWwnftXwzHm72XeB/H80GpqIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Sowden <jeremy@azazel.net>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 011/115] netfilter: nft_redir: correct length for loading protocol registers
Date: Mon, 20 Mar 2023 15:53:43 +0100
Message-Id: <20230320145449.846513347@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeremy Sowden <jeremy@azazel.net>

[ Upstream commit 1f617b6b4c7a3d5ea7a56abb83a4c27733b60c2f ]

The values in the protocol registers are two bytes wide.  However, when
parsing the register loads, the code currently uses the larger 16-byte
size of a `union nf_inet_addr`.  Change it to use the (correct) size of
a `union nf_conntrack_man_proto` instead.

Fixes: d07db9884a5f ("netfilter: nf_tables: introduce nft_validate_register_load()")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_redir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index ba09890dddb50..deb7e65c8d82b 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -48,7 +48,7 @@ static int nft_redir_init(const struct nft_ctx *ctx,
 	unsigned int plen;
 	int err;
 
-	plen = sizeof_field(struct nf_nat_range, min_addr.all);
+	plen = sizeof_field(struct nf_nat_range, min_proto.all);
 	if (tb[NFTA_REDIR_REG_PROTO_MIN]) {
 		err = nft_parse_register_load(tb[NFTA_REDIR_REG_PROTO_MIN],
 					      &priv->sreg_proto_min, plen);
-- 
2.39.2



