Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591477;
	b=Rh8MxDeHokpm/K4uOCJ87buYHS9+0CXjzI0brK7/GZcTRIGwkcKDBP4EdRUC2DX+5wRA
	 vbyexZrr6DLq0izuSmGYMU1HPUDXSAvsFLa9lL8lSqN0NKt5tjCVTlQaDAPkxBzVDJuLu
	 zuYLdvho1Cm6C0EwnhiXqgk0l3H0A1UcHW45IUFf0HDWjRmMQFwDtrRYltPiieipIGHm4
	 Uy4xbMAJRD7ykY54NkJLinGBg6ZqTwwCPpgmWCX2V6DwUqCNWADEfD6B53jX3S6nrGGu+
	 7n5E8eC/s+VUplTHLtbtmRfVndEMlcmVBU+69oXLNq/vtyOTtetg5VIMlC9I0C2T0Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591477;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NOYrAHs7CtBVgc1kgmI9pF4/xb4lU45GNcTCIDPvexU=;
	b=lsYXk/LMa83eFGgVIsXuSba9/NIQul8dI46HOJiXzpkgjpLTOnpkEzIB2ek2NwL1YYag
	 EjXjP2KqT21CuiJUUUtoSgQT1IG/3bpky7qx+VRTxHhvxGVNJ1mWwsKcMS3HrQeSq0+db
	 LH9P2QmaJ7DgJC+bMNbGiVzsnfPlvVwGTZk5EqIzljkrnqi6hJKRE7cxCCJ3eNoyNYp58
	 7BWeixfxYFMdFRMrqBeKJZPVUHSaOnIlxFMxLIaffoMdT75MndIi+FbtcjPO6n67HEbLc
	 mM3DZ1ZXrbYBTlQ8xO1PKVbZsOa7F7P6QCseYbH7XwAhWxEdCS13TLv5DvVjd/Lu8cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EfKNMjOj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B1E606E212;
	Fri, 13 Nov 2026 17:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EfKNMjOj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36C91F000C4;
	Fri, 13 Nov 2026 17:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591476;
	bh=NOYrAHs7CtBVgc1kgmI9pF4/xb4lU45GNcTCIDPvexU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EfKNMjOje6hXyfLCL74J47UcAkq/q40op2ubnubLHPquS8xnGKlCArkc0LLP4EGbC
	 NRbXzL+Syh0GCnvkqKWqNUiunu2+saR1lrVd35tICUdApnmoc2Lo98IDE2Ido/ti5U
	 OrGAwe7Hr3KtgXnA+1IQkRYlGF9A4i8PlnBSWPKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 558/670] nilfs2: remove nilfs_writepage
Date: Fri, 13 Nov 2026 10:52:02 -0500
Message-ID: <20261113153830.791280812@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 310293201ed242e466b0e9f10f53b4a4abccffec ]

Since nilfs2 has a ->writepages operation already, ->writepage is only
called by the migration code.  If we add a ->migrate_folio operation, it
won't even be used for that and so it can be deleted.

[konishi.ryusuke@gmail.com: fixed panic by using buffer_migrate_folio_norefs]
Link: https://lkml.kernel.org/r/20241002150036.1339475-2-willy@infradead.org
Link: https://lkml.kernel.org/r/20241024092602.13395-10-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: cb6702e63e0a ("nilfs2: force clear dirty state when restoring from the shadow map")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/inode.c | 33 +--------------------------------
 1 file changed, 1 insertion(+), 32 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index ab1dd89de538f..52f783f90d9e1 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -170,37 +170,6 @@ static int nilfs_writepages(struct address_space *mapping,
 	return err;
 }
 
-static int nilfs_writepage(struct page *page, struct writeback_control *wbc)
-{
-	struct folio *folio = page_folio(page);
-	struct inode *inode = folio->mapping->host;
-	int err;
-
-	if (sb_rdonly(inode->i_sb)) {
-		/*
-		 * It means that filesystem was remounted in read-only
-		 * mode because of error or metadata corruption. But we
-		 * have dirty pages that try to be flushed in background.
-		 * So, here we simply discard this dirty page.
-		 */
-		nilfs_clear_folio_dirty(folio);
-		folio_unlock(folio);
-		return -EROFS;
-	}
-
-	folio_redirty_for_writepage(wbc, folio);
-	folio_unlock(folio);
-
-	if (wbc->sync_mode == WB_SYNC_ALL) {
-		err = nilfs_construct_segment(inode->i_sb);
-		if (unlikely(err))
-			return err;
-	} else if (wbc->for_reclaim)
-		nilfs_flush_segment(inode->i_sb, inode->i_ino);
-
-	return 0;
-}
-
 static bool nilfs_dirty_folio(struct address_space *mapping,
 		struct folio *folio)
 {
@@ -295,7 +264,6 @@ nilfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 }
 
 const struct address_space_operations nilfs_aops = {
-	.writepage		= nilfs_writepage,
 	.read_folio		= nilfs_read_folio,
 	.writepages		= nilfs_writepages,
 	.dirty_folio		= nilfs_dirty_folio,
@@ -304,6 +272,7 @@ const struct address_space_operations nilfs_aops = {
 	.write_end		= nilfs_write_end,
 	.invalidate_folio	= block_invalidate_folio,
 	.direct_IO		= nilfs_direct_IO,
+	.migrate_folio		= buffer_migrate_folio_norefs,
 	.is_partially_uptodate  = block_is_partially_uptodate,
 };
 
-- 
2.53.0



