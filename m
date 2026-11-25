Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621629;
	b=xfAsptbAyD/wdefnr7+VKX3jIY8QuEIsSCOjyLcFQyl5rEinlVjy6b0hdkHDbME4KkJT
	 ni4n5fcsD05bmO2buu14kPAJZm9qfZJc1a0tVdMO7nL/AWr9swphGLzGncV59mEJMfBqA
	 zdSGLplP0gKvFEqceDilqCq1U1WKgTEDuJWBVuwrgNuOaCjQY5OEk+JGm1yvMEnjKfI73
	 PGAw48eAn43IHzB4G/8Wbzt3UGfyThxws4NZeBZ+F2SPLsTznoGpIsvs25X6TmlqyeNR5
	 Y8NglTU67Y4s7KBNeY47qLleqmHi0TklJXM17vEavAb4sAJ8JZJ3BVz2IhYLb3YkV9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621629;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gUshBm3wzdXDLNt6SiNyr4GnUYLgA2To1JXtYSF+K1I=;
	b=UtosfFC7eMJDQtgbm82Pc36PuQJpkQw9DQWPZ69hsntHdoMSwmuP8LALL/JHFhjXi9z5
	 n6Oy4A7gCmxnvoovADXEg4qzI/AabfYJuL04P7Y1TsYBPkqFYME7G7BpBBt4rg5Qip3SV
	 YkhY78+NRr5caYC0+RUMUpEmv4nbASpWIBGxTD6PEy5OlYHyADnLu8CT64FTjV7I6fTQx
	 vV4cretxHuP7U3x1+kEhmd+XDejGfwx6FnnafYfnsMIk7A3hc5mOmUeXXOq9nTVTR2qxv
	 0vMBE3KODJ5d1dTKLfxjxln6r8s6kkIEUmkLj496I7RmXRG5kulbokKdjXyhqIUxqCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QakPHyzQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEA4606A32E;
	Wed, 25 Nov 2026 15:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QakPHyzQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690D61F000C4;
	Wed, 25 Nov 2026 15:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621628;
	bh=gUshBm3wzdXDLNt6SiNyr4GnUYLgA2To1JXtYSF+K1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QakPHyzQMXcLrGHT5cLiRJqN4n158sLkAXin75SE2LEMO+0YZ0S2B6uRCAY/2KMx2
	 N8xk/KZ2kQYUrwgI/T6NFv8cNweOmynyIq/XL4+ZOZD+9gsuV08AqcyL2Xb8Y/TLFt
	 520mbei0t15bsY0rO70W3NDRNbMkJ9QY+ROdd07s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyuan Mo <hdthky0@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 285/990] netfilter: nft_set_rbtree: check catchall_sync return before queue_done
Date: Wed, 25 Nov 2026 15:27:32 +0100
Message-ID: <20261125143828.762908621@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingyuan Mo <hdthky0@gmail.com>

[ Upstream commit 1cec19d70bc282a8e7f7c42697d44046f60dc506 ]

nft_rbtree_gc_queue() passes the result of nft_trans_gc_catchall_sync()
straight to nft_trans_gc_queue_sync_done(). When the catchall path flushes
a full GC batch and nft_trans_gc_alloc() fails, catchall_sync returns
NULL and queue_sync_done dereferences trans->net (NULL+0x10). Guard the
call like the pipapo GC path already does.

Fixes: 7d259f021aaa ("netfilter: nft_set_rbtree: prefer sync gc to async worker")
Assisted-by: opencode:deepseek-v4
Signed-off-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_rbtree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 1270b472e3334..c00ac231ccda0 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -958,7 +958,8 @@ static void nft_rbtree_gc_queue(struct nft_set *set)
 	}
 
 	gc = nft_trans_gc_catchall_sync(gc);
-	nft_trans_gc_queue_sync_done(gc);
+	if (gc)
+		nft_trans_gc_queue_sync_done(gc);
 }
 
 static u64 nft_rbtree_privsize(const struct nlattr * const nla[],
-- 
2.53.0



