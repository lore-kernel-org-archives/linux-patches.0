Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051290;
	b=dKBkWEe4n/4uqHkHp+6RnsczoMXe9bZugCNkFBYVblzhE3cbEndnXWL+uT48Jpjc6mYY
	 e5tbBggfq9rqeeOTIf7TVoNfd+iGQl9fdxMinDoCwL0Yo4e2OgP+wzXpUoZ8Dih64qL2r
	 ajrMJ9EkVov+91aqx10YQWYNQ1OciFnSBgK70oQJKSXogXNPCdSIflAfXC9bnpj95iRd4
	 tjoq+0P+3lqb8PXjoK8PWmIWo4/7HlBQwaPJ30MwxigrDCuRDDl92J0M9aoD7vd9tQMWH
	 Q5NzWdxAS/lfGeuk8qPaiA9GxXmDZMjGygZATSYPQTwR4BVxJJ9b9119K4x1cFoJ85Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051290;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=snURjwSdtrlddynHx2fJzAPH4Ki4Fqo+pIQsK92WrPQ=;
	b=a5jXXuJlOdv7E8WoF+2gjhdzBHnI+WUQ5EVQKFUBQma2pEGpeasen44rIVBnLXFYWgVA
	 ZU2O99WbXNaYfyvo3WKjIJWpzM9IYDHFJ+Lyk0P00Z83BkslSVSAibz5lTGGHkqvsgq0A
	 QVoCfIpxY01pleiYfpvYeOfWQBwOO65ryRnItPviMgmffjcixE6ePNQOAnvWM25PS+eku
	 Q7qlV7t308kOIhxzr2hLkgCpe0IOtQjPBWUijWDrXmCG1zz9hRyof6r3+XN6OxlCK8PsH
	 u6n7uDW85PxNw5SWoV57pCOb/ekjydOiSi2OMy9jR6vbHWq3X/zXM10G02MEnz7rghg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="BRG7/r84";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B86606A31C;
	Thu, 19 Nov 2026 01:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BRG7/r84
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E761F000C4;
	Thu, 19 Nov 2026 01:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051290;
	bh=snURjwSdtrlddynHx2fJzAPH4Ki4Fqo+pIQsK92WrPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BRG7/r84GjtSstDnQ1v1eLDW9wjAFwB7tCu8MQrk+qtckrC9XTus5Y078wy9RgfWX
	 IwXySy2FYr3bV9yvvttHZyWpsttD9OR79znoiOiw3gvuk4mLGP7P5n2sZFmGwPa7Pd
	 ovyfJ+ce9YzkRMeeyXeqJS/ncp1ByYEeS38oil9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0129/2214] ext4: check return value of ext4_get_block() in ext4_load_tail_bh()
Date: Wed, 18 Nov 2026 15:30:05 +0100
Message-ID: <20261118150015.383339107@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 705a3fd3bac167f1dabe3d3bba46cd484c5528dd ]

ext4_load_tail_bh() ignores the return value of ext4_get_block(), so an
I/O or allocation failure is silently discarded. buffer_mapped(bh) stays
false and the function returns NULL, which callers such as
ext4_block_do_zero_range() treat as "nothing to do" and return success.
This can mask real failures during zero-range, truncate, or punch-hole
operations, potentially exposing stale data if the block was not
actually a hole and needed zeroing. So propagate the error to the
callers.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260714080044.4038124-4-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5d2409cd4030d..f248bd14c8dc9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3750,7 +3750,9 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 	}
 	if (!buffer_mapped(bh)) {
 		BUFFER_TRACE(bh, "unmapped");
-		ext4_get_block(inode, iblock, bh, 0);
+		err = ext4_get_block(inode, iblock, bh, 0);
+		if (err < 0)
+			goto unlock;
 		/* unmapped? It's a hole - nothing to do */
 		if (!buffer_mapped(bh)) {
 			BUFFER_TRACE(bh, "still unmapped");
-- 
2.53.0



