Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033870;
	b=zqFIV+TttCWlE/rRysfPrEgBUclC1MJrA537zpPBN8GGJO/tFTMY1WVwGL8EnWisK55v
	 WUGlGzzkcR8XZQanLCuETW7yglXKgX683ZPRoppL6ATjMtnXlFjXPkf6NU+Vo4XbMfTaY
	 cy6tJBg6syWBABZkPcgOkQW8SOubQkc3ObXcxSer/OTBGBvi89WY8BajJ4dYIDZctVZDn
	 llRGBm9YEkQiXr3ZBMe/62SnZSiQgrP9z5e4rDU8dbvdsSlcNu6vWCFL5FAi5zcacX1E4
	 Lm+Qb06B0xCIQ9OA3DTUmFab49T2TxIJWIFlGx1gK7Rj/FJxBgGQ8CSW1T8vGFta/Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033870;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=voBXJyq/UPL5fnV5ZjsWvKKkAi12KeuK4ybGK+kWhbM=;
	b=E8Wgrm3SvBBZHfhH5/rhPN4EGv/j7IOobweuRp03CJRygJLmD8cHTRexBvYYCafAUYeX
	 LvjLPt5KuzxlcNZLdiIND7oJw9zGmISdNk8SdOnmTK/sxIt2FhstAYYM6MgJJ02/LYMfM
	 1Y4+KRzU0Bl8Xe9dUajkpvYs/FAo7B9dRrZL0z+9uT5GWyCq8M3y23k/GHJ0u6ahy5cJW
	 wvSu0iY5cl7eP3FZMJhZfldKiIz0xaUSjlIAISkeAF1IA7cdizFJ81zzsbSyU1F+Y4F7b
	 lQ/qLiyMhR5+fZ7qZPPU1xqIm3WcZd010jV7Rd178i+0ELXnTDQFEGbXt8qp0JwsfFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O2VXZxgw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364BD606A333;
	Wed, 18 Nov 2026 20:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O2VXZxgw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840471F000C4;
	Wed, 18 Nov 2026 20:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033870;
	bh=voBXJyq/UPL5fnV5ZjsWvKKkAi12KeuK4ybGK+kWhbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O2VXZxgwoOA15Woqq2OITnKLPrE/O8izy2DLlxiK5yOkQfjZcQr5HHRB+6Z5KezNg
	 M4/UuHupHu9DSynK3hxIymtxD+FW+BhCOJYkndqUc9DC1thpRVSLLEhsb/W1D9fVRL
	 Pf0uwqSMJD19ei3lm2J2RDkQ5204tmPa5nHBPLhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0169/3318] ext4: check return value of ext4_get_block() in ext4_load_tail_bh()
Date: Wed, 18 Nov 2026 15:13:11 +0100
Message-ID: <20261118150319.710119037@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b7fda0c0bd6a3..a81a0cc8758c8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3727,7 +3727,9 @@ static int __ext4_block_zero_page_range(handle_t *handle,
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



