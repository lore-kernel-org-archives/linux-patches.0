Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044473;
	b=nzbspPTbMxO4rEPC5nU8xaQ3ZyomvAsN8Og73PeKcK4TWTLyJYF8QFt9dLv6VCjB9Fq3
	 r0dExoR52954IljVUc/sF+e2GZUTZDAp/EN+tHL/26ka/iCzx6pK4/8OH6TPoOqRVm0oI
	 LZ4WKM/ixhfFXQaCMfsV0+nw3Q86bBK69LJUCfX+O/3euPfE1a+8t9wZxDF04I+WhExkx
	 vOYsnu7Ly9AWreu/7A+LXlwjxpJyb0E4oC7Um9e64fCx318xfBSz3PX0YaZqe24+/0wqD
	 FDTXnAia1nNZgAEdcrgorNugcBKcIsACu+HAjiODhmLQczvrNykwjO6ZT6DDl0iZWGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WP9uF4O861bXkVymHQrvfj57IwViUDDKJ9l6TVKUgiw=;
	b=AaCaAwCHTih8pmkvfamm1STKYRU03RTzL0LDa7Gk8NmFzI03lT54U8rK1yWG2T7LRub+
	 fGmm+ABOWvE3d5gq1w0fr70f3imsvyt9d3kyjmmRClSDvNtMnUYuEqOC8kqzeabVgnhPC
	 bQIiZqtX/O5G1xw5QISaV8a9i3FOCk6KWcA/fiFBlsnoH3uDroWGqAWZeUecuC5ZxfgGB
	 BCFTCwzDek8Ep4yQDn0h0nU5/Mxx4D5NpMewiiO1lqLA4j4RVo36f+HAHxsmp33PnvI3g
	 AHKXfBSc6Wi82vsZ1PpXAFBMY87zrl54/3oB8d3zGxAnA9g0ZsCEgD9Nqhju3lp2cvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vXBL/Oen";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46AA606A31C;
	Wed, 18 Nov 2026 23:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vXBL/Oen
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386E51F000C4;
	Wed, 18 Nov 2026 23:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044473;
	bh=WP9uF4O861bXkVymHQrvfj57IwViUDDKJ9l6TVKUgiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vXBL/OenX+WTBtGtAafjeZ+brq7RslUsX3moSSz0H0KMuDUVSe61GEvbWupY4KjW0
	 0OudYzUoIxf186BPActKZZ8YvB/NkjgEa5/JwXzOu1fnIwSZXA2KydW9lY8dm9hVKL
	 wX5Uv+Zb5UwM56kuhtpGMmuPtHAV7YQM0341W2X4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.1 0581/2857] xfs: mark overfull dabtree node blocks as corrupt
Date: Wed, 18 Nov 2026 15:26:55 +0100
Message-ID: <20261118150222.401497263@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit f61c91a2e5994fa81141d6c06dadae1fed206018 upstream.

LOLLM observes that we need to range-check the dabtree node record count
before using it to index an array.  Fix that.

Cc: stable@vger.kernel.org # v4.15
Fixes: 7c4a07a424c18d ("xfs: scrub directory/attribute btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dabtree.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -433,6 +433,10 @@ xchk_da_btree_block(
 		node = blk->bp->b_addr;
 		xfs_da3_node_hdr_from_disk(ip->i_mount, &nodehdr, node);
 		btree = nodehdr.btree;
+		if (nodehdr.count > dargs->geo->node_ents) {
+			xchk_da_set_corrupt(ds, level);
+			goto out_freebp;
+		}
 		*pmaxrecs = nodehdr.count;
 		blk->hashval = be32_to_cpu(btree[*pmaxrecs - 1].hashval);
 		if (level == 0) {


