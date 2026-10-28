Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212493;
	b=OMdrJHFFCoT+8yY04QIwuBkNB0KAvfcBvGZDACnM7CNUUH+97CyMIIbCr04KS9mrmdwF
	 lsR9jsHrXn5sZ1EFr8hN4qLloKw1qqzLuQNkQ5xsiyKqJky4hCFPm3NpqXRGn3lZAtJy0
	 vUTRBwBGb+bD5ETUDAYh1D8TAXfsvErbzrkk+wMXPPtlTDkxKhkDlpPx6AeFo8/28u5en
	 KTNFZQjR0ywIVBtPEP1k4cedjWwLCdAgHK53kPxlWMywA6O6Tj/JdqjO886sJFcoyq4xZ
	 y2VqEDY1YLB5/M3eY2krcaiepqRVGGevdEMOo6jx3uvGckn29SnjDWhmy/iSET2IjrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JX6HAflKK3yyitIySs28XUOKjk8oad+BoDg0lcFBqqc=;
	b=r8zX4lCOgNpK28TTtDFSgoi4iYkfXL1BkMhmC17c50TLmfHs6pmWW08m+cuUqh4JM4Wn
	 qEwT5ezBNrNIkKGCN6Bi0yw43tg3VHLdgbY5zAolW46kn/1L882ly5dkmhlrZuBqSkIRY
	 PlK1LiCp+YGSoGde35xNezHMU0RDf+LPAhma49Zbl1lHD0q4oZCvBAV05qBtrHKz2wG6h
	 TzZnGpg6dMVZzNdTyBIKVbiOA2vzotHjAdQLp9JDknt344HBjFSivQ/eXufy0ddDR2PE+
	 A3X+5sjY5ISvpebe8hlynbvA2IGPxGCdeGx5vt+dKq+WlscFdaVGKSVa+MFEiJ9GaFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GRRSVO9v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9C0606A31C;
	Wed, 28 Oct 2026 18:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GRRSVO9v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385401F01825;
	Wed, 28 Oct 2026 18:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212492;
	bh=JX6HAflKK3yyitIySs28XUOKjk8oad+BoDg0lcFBqqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GRRSVO9vqAREgjIa++SRY2ixrPicWd/FPJPjatv0sOQ5hwx7E4kTYXkiMLBAy9uc3
	 NijI122ix6SgdHxdHdRbnkjZWeRP6+4KP64JryI8fI/+ofE9KhnQ5ZQ0taGUJVh8eE
	 jmaWg7Gvtfa6WgZ0SCL6XcruIwj2z+h/BrOKJPwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Aohan Mei <henrymei@tencent.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0156/1887] netfilter: nf_tables: skip expired catchall elements on insert and delete
Date: Wed, 28 Oct 2026 17:37:32 +0100
Message-ID: <20261028170502.783069228@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aohan Mei <henrymei@tencent.com>

[ Upstream commit 70194dc37670bd08e44b471389861cc01bd3a3c9 ]

nft_setelem_catchall_insert() looks up duplicates with
nft_set_elem_active() only, while nft_set_catchall_lookup() and the
dump path additionally skip expired elements.

Once a catchall element with a timeout expires, this predicate drift
makes it invisible to userspace dumps, yet it still blocks
re-insertion: with NLM_F_EXCL the request fails with -EEXIST, and
without it the request reports success but silently inserts nothing.
The stale entry only goes away when the (user-tunable) gc interval
elapses, so the catchall rule may silently stop matching for an
arbitrarily long time after its first expiration.

The delete path shows the same drift: nft_setelem_catchall_deactivate()
picks the first active-next entry in the catchall list, so with an
expired entry still pending GC it retires the stale entry instead of
the fresh one, and it deactivates an element that userspace no longer
sees instead of failing with -ENOENT.

Align both walks with the lookup and dump predicates: only an element
that is active and not expired counts as a duplicate or delete
candidate, using the per-netns timestamp taken at transaction start,
in line with the set backend .insert/.deactivate and catchall GC sync
paths.

Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Cc: stable@vger.kernel.org
Fixes: aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")
Assisted-by: CodeBuddy:Kimi-K3
Signed-off-by: Aohan Mei <henrymei@tencent.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 17092456431db..9f71ad2669c7e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6222,11 +6222,14 @@ static int nft_setelem_catchall_insert(const struct net *net,
 {
 	struct nft_set_elem_catchall *catchall;
 	u8 genmask = nft_genmask_next(net);
+	u64 tstamp = nft_net_tstamp(net);
 	struct nft_set_ext *ext;
 
 	list_for_each_entry(catchall, &set->catchall_list, list) {
 		ext = nft_set_elem_ext(set, catchall->elem);
-		if (nft_set_elem_active(ext, genmask)) {
+		if (nft_set_elem_active(ext, genmask) &&
+		    !__nft_set_elem_expired(ext, tstamp) &&
+		    !nft_set_elem_is_dead(ext)) {
 			*priv = catchall->elem;
 			return -EEXIST;
 		}
@@ -6287,11 +6290,14 @@ static int nft_setelem_catchall_deactivate(const struct net *net,
 					   struct nft_set_elem *elem)
 {
 	struct nft_set_elem_catchall *catchall;
+	u64 tstamp = nft_net_tstamp(net);
 	struct nft_set_ext *ext;
 
 	list_for_each_entry(catchall, &set->catchall_list, list) {
 		ext = nft_set_elem_ext(set, catchall->elem);
-		if (!nft_is_active_next(net, ext))
+		if (!nft_is_active_next(net, ext) ||
+		    __nft_set_elem_expired(ext, tstamp) ||
+		    nft_set_elem_is_dead(ext))
 			continue;
 
 		kfree(elem->priv);
-- 
2.53.0



