Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829611;
	b=zHAijzvhobFh2ZHnfwY/huydFcdiBaMstnk5pg+JENOydZ4hv+RV9mV8tOT3xgs+XqOC
	 gkG9u8MkAPQZlSAeDmBxYWlQM9dV7R1nVNjgamId/tFk9PfwwwpZGPaeK6D29lX0ROt8P
	 /E/sRaGsrLWBbywifyNxyYAiBiZnkx5w0sETb75/HIeDrTjZ4uWijzs7DGAWKA35fW8WQ
	 7FEC1Hp2UeOI+2OLtpXwtjs5CkXJRKJfZjdKeyj0+fU3Ygn/PbsWZzNHH3ZS/0FVJNYbI
	 u/DREuzp4kJ+df6buGwsg8Lnpn0lWUtT+JPzzAGMVlYu+rC1/9fOxNtWtOORv+Xs45A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829611;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wQM7Z5N+X4JyN3c5jpOr85db8zkX+LSRr63zCHMqrNg=;
	b=4F9rM86MdokmGhnGa5b3A7mfaCPOz1o+Tw/dJAlg6fWRhCGCwO3pb2Aeb4JvmU+5KJg2
	 fkr2GtNw/PHgdqAUAs+RzpxyxGeJJ5FRd9R0mC6Ow41rNDICHgpRuQ0KIBX+MDZ4BKc3R
	 mU//V3MoVN26MNQnd36WhR0SF+2wQ7yYGA8q5th7+w3OTjOwnTBr1citmcwwtT6QfVtPA
	 QubZoRUVjFXPcgbcSZQFnHUuAET5B7YrljKy+O1/CnPmVQ9cK3Jd7QolHISr132IqnwRU
	 XAWEAqVDeaEHbq5rsq9DC1EQxb5Jj7vn5zqr8A0ATjA6dNj9obfdm4vQk7+uvvVpEeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fvKUW5J8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F101B608C984;
	Wed,  4 Nov 2026 22:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fvKUW5J8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB2D1F000C1;
	Wed,  4 Nov 2026 22:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829610;
	bh=wQM7Z5N+X4JyN3c5jpOr85db8zkX+LSRr63zCHMqrNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fvKUW5J8Kv3sCrjVJI9j+fUnTi8f3wmdxPLvh7bzFzi43JjVwmIHbEVN3vcBf+UTx
	 VGweZnj+AElh+9QZB4dsxieQtiELlZVRGOPtwCWOUXancHf1Es7l1VAept7buZsn2r
	 Kf1GxLB/1gQqN1Gp+jD8j44F+g3W26hDvKgB+O1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0234/1005] ext4: check return value of ext4_get_block() in ext4_load_tail_bh()
Date: Wed,  4 Nov 2026 15:59:27 -0500
Message-ID: <20261104211050.402256259@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index 9a5c08650bd1e..2e3f7ba1a924b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4119,7 +4119,9 @@ static int __ext4_block_zero_page_range(handle_t *handle,
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



