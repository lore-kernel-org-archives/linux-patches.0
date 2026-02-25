Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AFE1D5141;
	Wed, 25 Feb 2026 01:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983510; cv=none; b=aI3SWy0QvFzKHAr5fmaxEw+/M9wU3XsZLwLTGWI+2p0QKaZq5W5SwUwvXwvsFOj2LJCC3Zxw/Bqohl6p5nyKWvvMZ9JLRZMEigqxOoTFQBBIQPy2H8YIaynA8fxkg28OZjrs1OMly3rUPYzAXfvf4gfo+ur87HeX1tk9dYIpegE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983510; c=relaxed/simple;
	bh=mLuIgX+DgIo2EonPi+f22iXG41F+CxSmZGC6RhaPb9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGcm+KF/Pmx8UsKPbum2roc4FPpdQ1HhecBkpLTJm5kzqgm+QKEAzVDA0PtgIe41J7M9FmIVZdhqTzxcR9/zMEy9pwPpNGVd9CTiP3ZA3AnfilD4rAsUvF4l1nmZI8oKckVd2H6cnqCWhS7j65Tx+eyq1DOJUZYh7e3veSiDcw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=COyqivjW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="COyqivjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78BC6C116D0;
	Wed, 25 Feb 2026 01:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983510;
	bh=mLuIgX+DgIo2EonPi+f22iXG41F+CxSmZGC6RhaPb9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=COyqivjWgfLMcDeCPAdAZMgEC8Cht20Lm4n1c6pB6Hw64ZHKFRYIUF/3d+ch6NWt7
	 yHMcdAT5AdchRVUWqMZMIWS3K7Q4nH+nFXiku47MaGf0dersLpe+40GHb2CMkjuFAi
	 jVs9/7bKAAxECtNzLLzurkLOTYJn7Uhg96KNShp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 617/781] fs/ntfs3: rename ni_readpage_cmpr into ni_read_folio_cmpr
Date: Tue, 24 Feb 2026 17:22:06 -0800
Message-ID: <20260225012414.937727392@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 4248f563f0b76f3fb74b2a28ee068bf66fcbbedf ]

The old "readpage" naming is still used in ni_readpage_cmpr(), even though
the vfs has transitioned to the folio-based read_folio() API.

This patch performs a straightforward renaming of the helper:
ni_readpage_cmpr() -> ni_read_folio_cmpr().

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: e37a75bb866c ("fs/ntfs3: fix deadlock in ni_read_folio_cmpr")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 8 ++++----
 fs/ntfs3/inode.c   | 2 +-
 fs/ntfs3/ntfs_fs.h | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 641ddaf8d4a07..7e3d61de2f8fa 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2046,18 +2046,18 @@ static struct page *ntfs_lock_new_page(struct address_space *mapping,
 }
 
 /*
- * ni_readpage_cmpr
+ * ni_read_folio_cmpr
  *
  * When decompressing, we typically obtain more than one page per reference.
  * We inject the additional pages into the page cache.
  */
-int ni_readpage_cmpr(struct ntfs_inode *ni, struct folio *folio)
+int ni_read_folio_cmpr(struct ntfs_inode *ni, struct folio *folio)
 {
 	int err;
 	struct ntfs_sb_info *sbi = ni->mi.sbi;
 	struct address_space *mapping = folio->mapping;
-	pgoff_t index = folio->index;
-	u64 frame_vbo, vbo = (u64)index << PAGE_SHIFT;
+	pgoff_t index;
+	u64 frame_vbo, vbo = folio_pos(folio);
 	struct page **pages = NULL; /* Array of at most 16 pages. stack? */
 	u8 frame_bits;
 	CLST frame;
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 0a9ac5efeb67c..1319b99dfeb41 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -736,7 +736,7 @@ static int ntfs_read_folio(struct file *file, struct folio *folio)
 
 	if (is_compressed(ni)) {
 		ni_lock(ni);
-		err = ni_readpage_cmpr(ni, folio);
+		err = ni_read_folio_cmpr(ni, folio);
 		ni_unlock(ni);
 		return err;
 	}
diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index a4559c9f64e68..7b619bb151ce9 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -568,7 +568,7 @@ int ni_write_inode(struct inode *inode, int sync, const char *hint);
 #define _ni_write_inode(i, w) ni_write_inode(i, w, __func__)
 int ni_fiemap(struct ntfs_inode *ni, struct fiemap_extent_info *fieinfo,
 	      __u64 vbo, __u64 len);
-int ni_readpage_cmpr(struct ntfs_inode *ni, struct folio *folio);
+int ni_read_folio_cmpr(struct ntfs_inode *ni, struct folio *folio);
 int ni_decompress_file(struct ntfs_inode *ni);
 int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 		  u32 pages_per_frame, int copy);
-- 
2.51.0



