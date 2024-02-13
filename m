Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC0D60271;
	Tue, 13 Feb 2024 17:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845817; cv=none; b=MQf5VpTXi9C5w/5l4w2MwTKC5TXHZvCRj6nBbiecNgGIq4b8H4OfEse9t8uSwNrid2zIIq1Kik2uEiuzlsIcJx3uwFk88wGhumsN1qrgtbNKik+fGHwQHSi6ar9lSccTBwZTt6n7tYxqUrUhBrrOAJxDGM5u6oWDYTw75sO2pNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845817; c=relaxed/simple;
	bh=Xc0cCv6woxABUSBUPr0d/amMam1laWniGllXhMyF71o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWqUgAuoCvN0jzQ2uKR+EraPz9R0uLewWexRmSBUmT0iA3mNF6UaBSIlK8T2IEhdoDN0Q2vO7Z7wy0QWmXQSCWBdm8HwLn6SzHyfrVBksqzmuetjzQ+JVYEFdB0ZDCKubCiNQ3hejEOq44dZY1XPsQ1tXW9F/2d6lDGX2l1vaYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JGrrWMes; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JGrrWMes"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BFAC433C7;
	Tue, 13 Feb 2024 17:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845817;
	bh=Xc0cCv6woxABUSBUPr0d/amMam1laWniGllXhMyF71o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JGrrWMesKmambkHe+H/WjlSV5ojkOe1gCeTzxJyyy9gwEIaHUvwYeV1L3TGfxoO7B
	 D9lTA3kpvQ5nil+7ZglOosRRopivGotza91gnlfTfkopnzG9W8rQCDhr3DX/j1mGy1
	 l5O7j3iXu16pR6tcbAldzPyyHBY+gUb/vHH/qcRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 065/124] netfilter: nft_set_pipapo: remove static in nft_pipapo_get()
Date: Tue, 13 Feb 2024 18:21:27 +0100
Message-ID: <20240213171855.636074656@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit ab0beafd52b98dfb8b8244b2c6794efbc87478db ]

This has slipped through when reducing memory footprint for set
elements, remove it.

Fixes: 9dad402b89e8 ("netfilter: nf_tables: expose opaque set element as struct nft_elem_priv")
Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_pipapo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 7252fcdae349..a65617cd8e2e 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -603,7 +603,7 @@ static struct nft_elem_priv *
 nft_pipapo_get(const struct net *net, const struct nft_set *set,
 	       const struct nft_set_elem *elem, unsigned int flags)
 {
-	static struct nft_pipapo_elem *e;
+	struct nft_pipapo_elem *e;
 
 	e = pipapo_get(net, set, (const u8 *)elem->key.val.data,
 		       nft_genmask_cur(net));
-- 
2.43.0



