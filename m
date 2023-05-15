Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D314BDF40
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B06C433D2;
	Mon, 15 May 2023 16:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168551;
	bh=mPVHQG3wkykm4b9DcExtlMVpVjuKR6KpDR1/7/KdtCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rhj6CVwg6Plv2KMkKTIZ626WcJAfSIBwNrbj3/fdV9fWzOBFWdQ1848S7eZ84hqLx
	 sCjEpFK16l4vYkWXFu/pvyKk+fLXrRhi8T/okIC3MdwrzR3z/OmFS7MKix/ABLcJBn
	 N3bsYP51gW7bgcpRc6SiVc3ZX8iwHbZwCSDm+mds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 085/116] netfilter: nft_hash: fix nft_hash_deactivate
Date: Mon, 15 May 2023 18:26:22 +0200
Message-Id: <20230515161701.107297105@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161658.228491273@linuxfoundation.org>
References: <20230515161658.228491273@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ backport for 4.14 of 7f4dae2d7f03d2aaf3b7d8343d4509c8d9d7ca9b ]

Jindřich Makovička says:
  The logical OR looks fishy to me. Shouldn't be && there instead?

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1199
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index a684234bd229c..eb7db31dd1733 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -520,7 +520,7 @@ static void *nft_hash_deactivate(const struct net *net,
 	hash = nft_jhash(set, priv, &this->ext);
 	hlist_for_each_entry(he, &priv->table[hash], node) {
 		if (!memcmp(nft_set_ext_key(&this->ext), &elem->key.val,
-			    set->klen) ||
+			    set->klen) &&
 		    nft_set_elem_active(&he->ext, genmask)) {
 			nft_set_elem_change_active(net, set, &he->ext);
 			return he;
-- 
2.39.2



