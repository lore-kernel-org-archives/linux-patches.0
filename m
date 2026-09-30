Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543A54E9C32;
	Wed, 30 Sep 2026 17:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790231; cv=none; b=bSQs1ugOCMJaCJgG9kPqjwMN5vMmATXNlpOm4ogE7seGl4uM6WcATgVsB4GKYkkDxR/NDjeuHghfiOdZXnHT5x33QDh3ReHXVVUO0BTguLCDW2RIcunW3Bm4q9XpYoYruZPfADg3HB5i8dm3Q7eR3mw+akrRkytH8TOkPiNLACA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790231; c=relaxed/simple;
	bh=pmxL1eKkhwPUDq5WhBsVJV2Sp/9QCoQBizi6KMWqC40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkLNV/zzXEp9sWaFrVtowgnPxY36bR6MKEFaxDRoXjH5ojCSg1mHxV4CUDFpXA6gkSIK/o5xfhgZRdhumjGiqZPBH5fFi54Ji2i7xg8Ltjd7GODZzeCN9g/bGEglw2nrjYdJi3yNbunkt3PJza+lnwHZasBxjqn1IkDjTGcGHSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qMzUje7s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qMzUje7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D2D1F000FF;
	Wed, 30 Sep 2026 17:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790230;
	bh=iqgnrJeVfGxjO7r+hvOFuWTx6AwuABms/gL3q+lXKXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qMzUje7snBUA2IYIQ/nq9ywzUn5RpNi7wcw6jkLQs3sSx28/swT1lwLddhV3zYzAE
	 bs1+5xzlNhz7Tqzq8imuOPeSCZsra7PHLTPZXdZa4He/O4YkX915xA5RSAUeJBmouR
	 CMMBmCUBMsWL0EJyiFMpPYO5pDaSVplwNCbXIemU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 756/877] net: page_pool: rename page_pool_alloc_netmem to *_netmems
Date: Wed, 30 Sep 2026 17:27:47 +0200
Message-ID: <20260930152431.013601363@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mina Almasry <almasrymina@google.com>

[ Upstream commit 91a152cbb49c26609d217cf2f116d46143b9b8be ]

page_pool_alloc_netmem (without an s) was the mirror of
page_pool_alloc_pages (with an s), which was confusing.

Rename to page_pool_alloc_netmems so it's the mirror of
page_pool_alloc_pages.

Signed-off-by: Mina Almasry <almasrymina@google.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20241211212033.1684197-2-almasrymina@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b814dfbfeb0a ("bnxt_en: Propagate TPA buffer allocation failures in bnxt_queue_mem_alloc()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/page_pool/types.h |    2 +-
 net/core/page_pool.c          |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/net/page_pool/types.h
+++ b/include/net/page_pool/types.h
@@ -252,7 +252,7 @@ struct page_pool {
 };
 
 struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
-netmem_ref page_pool_alloc_netmem(struct page_pool *pool, gfp_t gfp);
+netmem_ref page_pool_alloc_netmems(struct page_pool *pool, gfp_t gfp);
 struct page *page_pool_alloc_frag(struct page_pool *pool, unsigned int *offset,
 				  unsigned int size, gfp_t gfp);
 netmem_ref page_pool_alloc_frag_netmem(struct page_pool *pool,
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -673,7 +673,7 @@ static noinline netmem_ref __page_pool_a
 /* For using page_pool replace: alloc_pages() API calls, but provide
  * synchronization guarantee for allocation side.
  */
-netmem_ref page_pool_alloc_netmem(struct page_pool *pool, gfp_t gfp)
+netmem_ref page_pool_alloc_netmems(struct page_pool *pool, gfp_t gfp)
 {
 	netmem_ref netmem;
 
@@ -689,11 +689,11 @@ netmem_ref page_pool_alloc_netmem(struct
 		netmem = __page_pool_alloc_pages_slow(pool, gfp);
 	return netmem;
 }
-EXPORT_SYMBOL(page_pool_alloc_netmem);
+EXPORT_SYMBOL(page_pool_alloc_netmems);
 
 struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp)
 {
-	return netmem_to_page(page_pool_alloc_netmem(pool, gfp));
+	return netmem_to_page(page_pool_alloc_netmems(pool, gfp));
 }
 EXPORT_SYMBOL(page_pool_alloc_pages);
 ALLOW_ERROR_INJECTION(page_pool_alloc_pages, NULL);
@@ -1051,7 +1051,7 @@ netmem_ref page_pool_alloc_frag_netmem(s
 	}
 
 	if (!netmem) {
-		netmem = page_pool_alloc_netmem(pool, gfp);
+		netmem = page_pool_alloc_netmems(pool, gfp);
 		if (unlikely(!netmem)) {
 			pool->frag_page = 0;
 			return 0;


