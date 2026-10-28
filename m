Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208369;
	b=1fMRJuUbrRoy6LfG3eLUwLmV7LOlt2MtMg28jwNb7u2GWVRhzkGHJJu1uDaIf8sMqJIK
	 H9hZDCVk2B+l+kIpOx1o1x9vLvGHnj/z7RogBoMMusO3Z3qrxFgEP+RSfB5Ar8Z686MtF
	 X4fp8v58+kuiVb/dQvUGugkJeqL35otX32gsj0C9w4OPZlIrNd7YaHTqQMPE3rv/SNBsg
	 IZx08I5KLnGAZOsqafM2WOO7yQ+Hl1Tv83TIeZiNl7L2/lXNzuTy1cHVklXP74utEe9Py
	 HCb08f+vo/Me2rJbrW7WVde/p5S2e7rTID71aliMvQ5TWfBQ0woQcUpinaPK2qRQ29Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wDex9OWQ79PLjQGhLTgzE2nzEwX4herV8y9/fRaiWBk=;
	b=5KnjZtBl0Q8MHt7MAKur3I1Age80/jeyR8c57vYsktKJXWAMxSCdnbtGnMgJBxh+Lby4
	 03Y8628wtbnSOYqUxmcgSmiuh/kk78WGVqA5h9Bmw/DeDXeubUW2tYD5bDbgbY8Ag38iA
	 WDSIWFpz9lk86mea4ZaHfGkq4y/POB6E2lJMn3JebQnJ/sVsLQeFsA2rMypOxRGaXurB0
	 OfLJr4EAfg8ywarHNFz6bR4R50Mkfuaj5vA4q/ViySBw/hdp990Saqf7aJz/Eescvqosb
	 M9vkTEUXHDhEfN6bL+PRiOkstDM0Xip34WFiqUNKiuW6SyrfCcLqGCTGSouECCxt+kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SIw9cTsT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA3F606A31A;
	Wed, 28 Oct 2026 17:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SIw9cTsT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644AC1F01825;
	Wed, 28 Oct 2026 17:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208368;
	bh=wDex9OWQ79PLjQGhLTgzE2nzEwX4herV8y9/fRaiWBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SIw9cTsTrf17DGP6XGaXyZqr6tvT+37N2g7PCqjuyFbt3jA/2St0uh4WqBan51Tmm
	 XqEscG/tgyPVN8kgVGCCL9GeSUnZlMU81Zs2W/fNy4PPqb4pcthHtvNqdch7mHlxMe
	 sZX+Xm4W6xogk0ocpqmJhZJ6jbR4n6hRLZiBHrqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 093/516] f2fs: return writeback error from collapse range
Date: Wed, 28 Oct 2026 17:54:05 +0100
Message-ID: <20261028170005.725705342@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenjie Qi <qwjhust@gmail.com>

[ Upstream commit f8a4108800254d6f7b2755515fbbd9d0caac561e ]

f2fs_collapse_range() writes back pages moved by f2fs_do_collapse(),
but ignores the return value. If writeback fails, the ioctl can still
truncate page cache, shrink blocks, and report success.

Return the error before truncating page cache or updating the file size.

Fixes: b4ace3370324 ("f2fs: support FALLOC_FL_COLLAPSE_RANGE")
Cc: stable@kernel.org
Assisted-by: Codex:gpt-5.5
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ adjusted context to retain down_write()/up_write() on i_mmap_sem instead of filemap_invalidate_lock()/filemap_invalidate_unlock(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 751485437d7b4..9c12691ace0b6 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1402,11 +1402,14 @@ static int f2fs_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 
 	/* write out all moved pages, if possible */
 	down_write(&F2FS_I(inode)->i_mmap_sem);
-	filemap_write_and_wait_range(inode->i_mapping, offset, LLONG_MAX);
+	ret = filemap_write_and_wait_range(inode->i_mapping, offset, LLONG_MAX);
+	if (ret)
+		goto out_unlock;
 	truncate_pagecache(inode, offset);
 
 	new_size = i_size_read(inode) - len;
 	ret = f2fs_truncate_blocks(inode, new_size, true);
+out_unlock:
 	up_write(&F2FS_I(inode)->i_mmap_sem);
 	if (!ret)
 		f2fs_i_size_write(inode, new_size);
-- 
2.53.0



