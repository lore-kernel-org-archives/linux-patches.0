Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214921;
	b=Hfh78a72vg5PUcBLhgpbYdJVuCfHB0Rslje0b36Gxg5qJ77IHp1p1THc6jx9cvhh23Ol
	 CYYtRAz+tLiiZcG2q1/6HggN/yktlLlVlbBOKHy2q90NRaYFhL9WHPDVN1W3GyxJODK1T
	 9GKwTziTStpmMdMZUor/h/tP3w+BE4kIAEsZXmePgOLSan9oEdmNmb2fAxijd5PRfmUN7
	 WIWaoem7oH2wA577ksvB6XxTYWqBfYpl2Abq++9kn6Ff9tnUzFv0U3Z7aHAWlC7F3+SGd
	 ZEYIafLPLW4mPLWrJXTM3wuonP4XboiawOPPmFYFYDfY0rsjfAAqA1NM0bEkGdyPYuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214921;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l8OlWvg1v/kVuAvJkvt5jezwi4Sr5Mye70X9xDHAwo0=;
	b=xmvvRRyBgvxFSa8xH2xIpvRuXcARKIwy9FFi0C2jJZ7MMjg1XHkzTHGEw0IqKIg4SDF3
	 4ZSjwvT3k4vwA81plRNYypySIgQNLyEdUTAYmzinzGNqoSqNpBmnRAnF82skhMn88GSHA
	 FRDGXN1/A/wS1z8OOEaUEOTQUZgRrzWwl68hRgsEw/I8V8jZl1KAQUBdwJrtn3eZPwNtK
	 ZVIrnNS1bEfeJMAh0aFXzC+932Dslaw0p2vvvUx8TifChIq6XSstbcDZU7zF/gzuggFHp
	 07sDguP3U8ZmLpj7Qfl8xxuCnqCovPGKQ1ai1h5y+3hDLBe51cHeB+Vn36jDI9reGNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kppVElw2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A90606A321;
	Wed, 28 Oct 2026 19:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kppVElw2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160CF1F01825;
	Wed, 28 Oct 2026 19:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214920;
	bh=l8OlWvg1v/kVuAvJkvt5jezwi4Sr5Mye70X9xDHAwo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kppVElw2O2y6+goGijsI7AzqRZEKswbIe2Bmo5PL0W2+5HCeqfjyrpBApyBMFGHhX
	 wQFfaNIiADnyPQRs9NtDlc/9ZOtmgx6vtirDqiaSfb3/P6xnaYa9tkz4lvA0Y/WvDS
	 ZX8j8Vp1d2VQRmWrdulBS8uFh1RXcnTKJHnvoht4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	stable@kernel.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1028/1887] ext4: drop extent cache when splitting extent fails
Date: Wed, 28 Oct 2026 17:52:04 +0100
Message-ID: <20261028170522.808671964@linuxfoundation.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 79b592e8f1b435796cbc2722190368e3e8ffd7a1 ]

When the split extent fails, we might leave some extents still being
processed and return an error directly, which will result in stale
extent entries remaining in the extent status tree. So drop all of the
remaining potentially stale extents if the splitting fails.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Cc: stable@kernel.org
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Message-ID: <20251129103247.686136-8-yi.zhang@huaweicloud.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6d95dab538475..5f588728a27fb 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3268,7 +3268,8 @@ static int ext4_split_extent_at(handle_t *handle,
 	if (IS_ERR(path)) {
 		EXT4_ERROR_INODE(inode, "Failed split extent on %u, err %ld",
 				 split, PTR_ERR(path));
-		return PTR_ERR(path);
+		err = PTR_ERR(path);
+		goto out_err;
 	}
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
@@ -3323,9 +3324,12 @@ static int ext4_split_extent_at(handle_t *handle,
 	 * and err is a non-zero error code.
 	 */
 	ext4_ext_dirty(handle, inode, path + path->p_depth);
-	return err;
 out:
 	ext4_ext_show_leaf(inode, *ppath);
+out_err:
+	if (err)
+		/* Remove all remaining potentially stale extents. */
+		ext4_es_remove_extent(inode, ee_block, ee_len);
 	return err;
 }
 
-- 
2.53.0



