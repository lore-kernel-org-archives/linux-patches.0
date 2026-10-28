Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214298;
	b=BGKDrO3qXnqpwIDiZ+0BY/1/VlIyboSLoU0d1tUxfbhUQdf+UyrlgaF1jhJ+byo+M4KQ
	 GyUpWAyM/oPjkYI99oElvvkeBtIHXiCmUWRRjvBlGD85PPsoF9yTR7Go2e/oYYPO6adIf
	 k23RV1Mdr0AESLXc2EioKtjNl0RkMiq3PBvZvwHVgqXTsiUqJonYbz4dgSA83axm0jd8N
	 5Uw+Z+BM4BF4881VFBwwpJjF6oTW5+2Sh3XkYDX8fq0PwFFz3EDk8xcfNjSZTyl0bqQqE
	 R7XEeNcayYiiRavImvuwqB1MWwT1i+CsPsel7hGKSITuxv39LYKP40xD7A1YhASiSNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214298;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WtHWTqaWiF8c9vT6tpLkdogA6p3BUsUODBAMJVjkxBg=;
	b=VCKEo/iE8dLxqBu3WFfnwR8qI+uUTU7KN6QkzhKydzxmumbwHAV1FyCwX//W2rsUgVDx
	 ewQwfPRtDexw9Wj9/pGezv+lIC5iemH1scyVbp8u4QohnLyYQdt36g6fljJrck8oK0fwx
	 WEAaiUK7sy5PcXh0gG82YaX+K/IqdOgWSUCNY8fT9+ure2qfq6pm5xCPyHrbrKkE2gvH4
	 shh0zO2LXRjguhp+NGlrLhiLdwhhNP+OKvhysU+VFw3vwbToTwQZ+bGUzzGfsTfKieAkR
	 kSvlVgSHRrqNvn9+yBSLF+tomf4757M/4W6IZ3MymkxCK8WeH/VFb4wuJKVZ2NU30pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NRq6drHH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB3B606A334;
	Wed, 28 Oct 2026 19:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NRq6drHH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA75D1F01825;
	Wed, 28 Oct 2026 19:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214298;
	bh=WtHWTqaWiF8c9vT6tpLkdogA6p3BUsUODBAMJVjkxBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NRq6drHHpzFXcGicy9hVgHfcFQm0SHE5fSwKXvNF2KOjaIJqDFT4wqQJPzHo07SXi
	 tO6GYfwUBUAN482v+uTIW1Gd5cfpmD9YPRQMc8/xG7iIEaPb/4uUStuM7WWsoEcXYB
	 qic1nkB/vW9MgwaYXWm3vWNDKhxn9c/KNrIim9ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Wilcox <willy@infradead.org>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0766/1887] f2fs: convert f2fs_handle_page_eio() to use folio
Date: Wed, 28 Oct 2026 17:47:42 +0100
Message-ID: <20261028170516.871912515@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 763a0dc792f9d7c79c1d85415c6cebc1f79bba16 ]

Convert to use folio, so that we can get rid of 'page->index' to
prepare for removal of 'index' field in structure page [1].

[1] https://lore.kernel.org/all/Zp8fgUSIBGQ1TN0D@casper.infradead.org/

Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 3147ee567dd9 ("f2fs: fix potential deadloop in prepare_compress_overwrite()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c | 2 +-
 fs/f2fs/f2fs.h       | 6 ++++--
 fs/f2fs/node.c       | 2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 84fc60d843bc2..3d3b0e313af8f 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -102,7 +102,7 @@ static struct page *__get_meta_page(struct f2fs_sb_info *sbi, pgoff_t index,
 	}
 
 	if (unlikely(!PageUptodate(page))) {
-		f2fs_handle_page_eio(sbi, page->index, META);
+		f2fs_handle_page_eio(sbi, page_folio(page), META);
 		f2fs_put_page(page, 1);
 		return ERR_PTR(-EIO);
 	}
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 6d22c18f948d3..5b63b92a10276 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4581,9 +4581,11 @@ static inline void f2fs_io_schedule_timeout(long timeout)
 	io_schedule_timeout(timeout);
 }
 
-static inline void f2fs_handle_page_eio(struct f2fs_sb_info *sbi, pgoff_t ofs,
-					enum page_type type)
+static inline void f2fs_handle_page_eio(struct f2fs_sb_info *sbi,
+				struct folio *folio, enum page_type type)
 {
+	pgoff_t ofs = folio->index;
+
 	if (unlikely(f2fs_cp_error(sbi)))
 		return;
 
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 8b4e8e251649c..e69791dd74354 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1512,7 +1512,7 @@ static struct page *__get_node_page(struct f2fs_sb_info *sbi, pgoff_t nid,
 out_put_err:
 	/* ENOENT comes from read_node_page which is not an error. */
 	if (err != -ENOENT)
-		f2fs_handle_page_eio(sbi, page->index, NODE);
+		f2fs_handle_page_eio(sbi, page_folio(page), NODE);
 	f2fs_put_page(page, 1);
 	return ERR_PTR(err);
 }
-- 
2.53.0



