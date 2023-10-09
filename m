Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97E5DF59
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHOLqxjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50238C433CA;
	Mon,  9 Oct 2023 13:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859181;
	bh=sWccsbyFE7f7e5n1mTu+znwueUSHj0sOBwKO6uQbFN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kHOLqxjYxAinJoq7bmTLdnslLgEvUlpyAa0S5Dl0zeFcBU93fzU8R/TGkqwC5D3CT
	 pSYMKGRZ2MAf3dPEVWkCevu0rgWmDo5ukHLFe04VSrCqlRg+dQCsNcFPEmniZG+C2s
	 /qNtjrlX0oMIx3IDd2uBXZUOmst2M8yL9cFdMd00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.10 225/226] netfilter: nf_tables: fix kdoc warnings after gc rework
Date: Mon,  9 Oct 2023 15:03:06 +0200
Message-ID: <20231009130132.389569864@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

commit 08713cb006b6f07434f276c5ee214fb20c7fd965 upstream.

Jakub Kicinski says:
  We've got some new kdoc warnings here:
  net/netfilter/nft_set_pipapo.c:1557: warning: Function parameter or member '_set' not described in 'pipapo_gc'
  net/netfilter/nft_set_pipapo.c:1557: warning: Excess function parameter 'set' description in 'pipapo_gc'
  include/net/netfilter/nf_tables.h:577: warning: Function parameter or member 'dead' not described in 'nft_set'

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Fixes: f6c383b8c31a ("netfilter: nf_tables: adapt set backend to use GC transaction API")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netdev/20230810104638.746e46f1@kernel.org/
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -439,6 +439,7 @@ struct nft_set_type {
  *	@expr: stateful expression
  * 	@ops: set ops
  * 	@flags: set flags
+ *	@dead: set will be freed, never cleared
  *	@genmask: generation mask
  * 	@klen: key length
  * 	@dlen: data length


