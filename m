Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038585;
	b=dk5g5zQYeXjVfkFracrQF0PuclkSVHMxgneIPNVfzxQsBuKTc8Va1cZf7fjUzJcugjoZ
	 vx6B1/T3ubphIeG4KfLgqIr0CZkjy5gcceGEHNaO6uM1WgfQ7BNzBekFSOjZgAUO2Q72c
	 ooZpzrExEiv4dw8UeYEIzNNZ2Ltah3okOB1t6fniRyLxU3ddJ1wPyp9rDAkEvtZKASByZ
	 QrxLRgczenJQOzPi/z2Dg2t6g6Bn+gH7NyaVWCbsCRATQMk8YzptjKEntpSx5ekRuae/+
	 UzMDeGmyvY1GS8aG1/fqHFq5kSQi28tRY7wrwKgZpqoZeylzGnP5BWB8vGkiovf5rAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038585;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qfcrsC+v+eJPGGnRn3BtIy3mKObltfi/baKt6yieNyQ=;
	b=Se4xn94PzjpTBjiCk2b3Gz8kuqdE0l7KSoU09/Uqg3rfo4k9cjUMm1KxcoXDj+nU5SoR
	 wMkh0K8lpH3D/vRe8Vo4Wf6JbNBzVf0IFoZVghy7xLzi9XjxTDN7jzaVEaJ7Vy2PAhYNo
	 Mif2PRyqj/76WlHw/NQc5pd/B8t8GEcYIlDF3HuIOBL3tAQRRk1wNlr67MHyoeqCv1Wec
	 d1SxU9rcgQ9saH2bkuA9W05KJj5Xmpfw14h2gXLqLJiI7oP95j+XfKSZUZip6edrAqcfy
	 5dnc41MT7Sj4lxf4ipl0HEa3B0Vw6Lh1k6lRGdqiSyTKohofgsVm1pRPKb5HVSkD3+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gbvntwEv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC16606A320;
	Wed, 18 Nov 2026 21:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gbvntwEv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E051F000C4;
	Wed, 18 Nov 2026 21:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038584;
	bh=qfcrsC+v+eJPGGnRn3BtIy3mKObltfi/baKt6yieNyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gbvntwEvUsHzozPsA4ssSnO/PFm2QsDZ4t5yCPH9yUUMt/uyoBpngfBUU0rVXfNq4
	 udZLqC4BwNpwRSeUXh7HurJ9LJJ9KNzqFTmEsMVFxJajOMTafQzaAjPA7U0DP7gNMj
	 6v0RntfnThfbTAswBq4n0yvLqe4UW5Xg1lYM+Vqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1796/3318] f2fs: fix to adjust appropirate defragment pg_end
Date: Wed, 18 Nov 2026 15:40:18 +0100
Message-ID: <20261118150415.736950839@linuxfoundation.org>
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

From: Zhiguo Niu <zhiguo.niu@unisoc.com>

[ Upstream commit 197080156f27b6bf8cf198e9313dfbb94769c736 ]

A length that exceeds the real size of the inode may be
specified from user, although these out-of-range areas
are not mapped, but they still need to be check in
while loop, which is unnecessary.

Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 92154fe28c37 ("f2fs: fix defragment writeback range truncation on 32-bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 6f948f743db18..d92426073aecc 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2874,12 +2874,13 @@ static int f2fs_defragment_range(struct f2fs_sb_info *sbi,
 	bool fragmented = false;
 	int err;
 
-	pg_start = range->start >> PAGE_SHIFT;
-	pg_end = (range->start + range->len) >> PAGE_SHIFT;
-
 	f2fs_balance_fs(sbi, true);
 
 	inode_lock(inode);
+	pg_start = range->start >> PAGE_SHIFT;
+	pg_end = min_t(pgoff_t,
+				(range->start + range->len) >> PAGE_SHIFT,
+				DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE));
 
 	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED) ||
 		f2fs_is_atomic_file(inode)) {
@@ -2895,8 +2896,9 @@ static int f2fs_defragment_range(struct f2fs_sb_info *sbi,
 	}
 
 	/* writeback all dirty pages in the range */
-	err = filemap_write_and_wait_range(inode->i_mapping, range->start,
-						range->start + range->len - 1);
+	err = filemap_write_and_wait_range(inode->i_mapping,
+						pg_start << PAGE_SHIFT,
+						(pg_end << PAGE_SHIFT) - 1);
 	if (err)
 		goto out;
 
-- 
2.53.0



