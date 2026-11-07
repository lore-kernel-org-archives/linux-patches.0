Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061651;
	b=clnMxIkd2yOyBvOtXUM7RiIMAF1mbjd5BSrPuyiPd/EvoU9JPKAgzB12P++4Bkepriux
	 M8oJu/iaxdINESts0zdXY4wvxz8hI5JW2ZEULbJbTw/uyLlo8Bl1+d26zozC0bQ8sMS0N
	 Qxy6e7LICs+MojWqgbuUrUkiWXK4i30maayKE71Pr2UOU7M8zGuJENRnIJC/Bpfh/xmGd
	 722dV8kGTGpBS3OhvFgrRfZacC/ptYjzBCfJ6SkJ1BJcGMNXq0wGdNm1HDbLBep/qjMJ5
	 Gke+6s+arAav8qwFNZE0pkUmS9WKAvpDxetTG/oPHMfNUX7MJey21WY0VQ1hAlvIrFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BfRAd3f3iZ9h2TeKwHyyLJvP6z0x8VQ+ttXUiIrNzo0=;
	b=bhsTpCvyEIphzqllaxOuBjXwKGHK9/g10Ii2NgR2QvI/LTz/q9EiYSSTAuw7AFU/w1bw
	 1FkrkQb9viAu/SqHd7kCbKCOoRlB9ULPIV4nHB4KhrdPEvbdxTW7/Ajj5hFE6UXBEe6K7
	 WNp7qX9gmiJzdzo+s4srVHHFvAZUvHaNSnkN8LkVJmNfTZFyFouSlaDCPtFvKESMAYDFY
	 hzWoL7Nr3JCUoUEvbt6godtp4wCZ/MNRC5H2t6lrMrf/mWk1LxEiY1YHk57S6At8G5aV3
	 hE2vLGKkLaNBVi3XLIYJP4KNlHClrRMuNR5bl7RP16Z7i71nbLObsF7g9a8qOHtLe4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rz2jZ5uT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE6C606A331;
	Sat,  7 Nov 2026 14:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rz2jZ5uT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5791F0089F;
	Sat,  7 Nov 2026 14:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061650;
	bh=BfRAd3f3iZ9h2TeKwHyyLJvP6z0x8VQ+ttXUiIrNzo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rz2jZ5uTstdSA5IktX0cI16kFMrUXGd5N0AWYcNQbucqR8GVsC9Icths03ca9Q0k/
	 Q4LI7zPt2xyj3FDry0QGaBzbYXVZ2DwGerO7WhOpnZjj2cdRTLbwylkUseZ8+ydqbm
	 FxbgR1gh6F6DveCb5Mzn93aFdBDkQpTYfhCBIkrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0711/1536] xfs: mark overfull dabtree node blocks as corrupt
Date: Sat,  7 Nov 2026 08:45:27 -0500
Message-ID: <20261107135017.467834979@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -451,6 +451,10 @@ xchk_da_btree_block(
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


