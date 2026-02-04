Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E7E410D3A;
	Wed,  4 Feb 2026 14:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216652; cv=none; b=qKL+N6ojp2sH1lTvJMJXq/OglYOvZtvYr35dAQHom3KQoQzh59mpamO9gWSBpDv8F3bKA2rFBJcPZ8UlrZlH7frSvWbmHVDT6ezCS3wW9gXU3WzSWZKNIgZOIqAqk1x/ZQ7jKH+UMW+A4RlMCSGR73IlZRzxypduKzTjSKcZi5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216652; c=relaxed/simple;
	bh=goE80yCC5tYzIs0VTgl5oO3w+uJ58B5CXFmQuc+DpyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3tlaUGbr1uz4EBQbMiOn6j8zM7m/ZXwBjMrpA64GgAcIzT8yD/z1joLSaOZLnoSD05k28xvisaLokNjyNmG9t3b0WVmKuxamUvgmyF23XqVch6QbPv9Rxv8D8iLu9+H7zQ5cxq7ZQKaHc5B/n84H8Jef1RRY1miMvC80iqDtFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bVu3TriM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bVu3TriM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDF0C4CEF7;
	Wed,  4 Feb 2026 14:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216651;
	bh=goE80yCC5tYzIs0VTgl5oO3w+uJ58B5CXFmQuc+DpyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bVu3TriMJx9fJV1F159rTIeMdJCMHi3Y8TEiirdPTO935CcXFrUZ6MwnEQ6pnKmX2
	 pszAYlE8JeFyH1qZxUlHsux6lkWHulARqAqKamqwiR5bCwQUhZrpWVzOIXPisfBqFh
	 Q85tEZJC4cy4GzC/Hhi2+HLOw/HnxeyxzWIo87xU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Wiedmann <jwiedmann.dev@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 153/161] netfilter: nf_tables: typo NULL check in _clone() function
Date: Wed,  4 Feb 2026 15:40:16 +0100
Message-ID: <20260204143857.252508136@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 51edb2ff1c6fc27d3fa73f0773a31597ecd8e230 upstream.

This should check for NULL in case memory allocation fails.

Reported-by: Julian Wiedmann <jwiedmann.dev@gmail.com>
Fixes: 3b9e2ea6c11b ("netfilter: nft_limit: move stateful fields out of expression data")
Fixes: 37f319f37d90 ("netfilter: nft_connlimit: move stateful fields out of expression data")
Fixes: 33a24de37e81 ("netfilter: nft_last: move stateful fields out of expression data")
Fixes: ed0a0c60f0e5 ("netfilter: nft_quota: move stateful fields out of expression data")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Link: https://lore.kernel.org/r/20220110194817.53481-1-pablo@netfilter.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
[ Portion of this patch applied - gregkh ]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_connlimit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -209,7 +209,7 @@ static int nft_connlimit_clone(struct nf
 	struct nft_connlimit *priv_src = nft_expr_priv(src);
 
 	priv_dst->list = kmalloc(sizeof(*priv_dst->list), GFP_ATOMIC);
-	if (priv_dst->list)
+	if (!priv_dst->list)
 		return -ENOMEM;
 
 	nf_conncount_list_init(priv_dst->list);


