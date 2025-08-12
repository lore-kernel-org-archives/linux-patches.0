Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3F82F7461;
	Tue, 12 Aug 2025 17:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020502; cv=none; b=nkVkLo4UC6VrK4noMii2oj8422SBIbf1B6LjuyEc4UVIV+t+SG5jAwjV2Xnml0/F+1jWu9cAcThc0pcS5UbnZT0dAiHQdkDG0X5AGxvym0pQjnV/UUPhzZ/UYUfhqMc8NBi2XK07ANY78bqp495IlwiKzeRlk15V2rTtHpc7w2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020502; c=relaxed/simple;
	bh=jQtx+Y2xXgOYbUjwJakuEDN45mjbT38A4KUS4kcsMlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WhSoGIdYjxMHB+TxdCqrIB1F2OBFpDYpeLxyo41bU5GF7L2Lfq4/ipIKmewMolQ4m4AJrxgs+0RojURsbNzyxYs4hWgLMGf9S097ErHnVT/zbOqQnVlrPcBlV7wnMqLPAvvzxzfBx+/umhDV80JT0YgXEi+SqcX9R5sfqZDS8F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zGL1lFYj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zGL1lFYj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A1CC4CEF0;
	Tue, 12 Aug 2025 17:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020502;
	bh=jQtx+Y2xXgOYbUjwJakuEDN45mjbT38A4KUS4kcsMlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zGL1lFYjQontnigDScFB1uE69FzvJkSLR0Uo1SXic3+2wjKcPjnMdwjF8MXBZ4GM/
	 jKRFApEijEsDbTc61CsPUKEgN+rXYjJFNej6ci5ZqLOWc5fHTVkUvV9A/thQqWkrtU
	 hmXp2uks5L08vShd9WjDVaJC2IhXUH7seTitC5Vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Chao Yu <chao@kernel.org>
Subject: [PATCH 6.1 055/253] erofs: sunset erofs_dbg()
Date: Tue, 12 Aug 2025 19:27:23 +0200
Message-ID: <20250812172951.068422959@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

commit 10656f9ca60ed85f4cfc06bcbe1f240ee310fa8c upstream.

Such debug messages are rarely used now.  Let's get rid of these,
and revert locally if they are needed for debugging.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20230414083027.12307-1-hsiangkao@linux.alibaba.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/inode.c    |    3 ---
 fs/erofs/internal.h |    2 --
 fs/erofs/namei.c    |    9 +++------
 fs/erofs/zdata.c    |    5 -----
 fs/erofs/zmap.c     |    3 ---
 5 files changed, 3 insertions(+), 19 deletions(-)

--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -26,9 +26,6 @@ static void *erofs_read_inode(struct ero
 	blkaddr = erofs_blknr(sb, inode_loc);
 	*ofs = erofs_blkoff(sb, inode_loc);
 
-	erofs_dbg("%s, reading inode nid %llu at %u of blkaddr %u",
-		  __func__, vi->nid, *ofs, blkaddr);
-
 	kaddr = erofs_read_metabuf(buf, sb, blkaddr, EROFS_KMAP);
 	if (IS_ERR(kaddr)) {
 		erofs_err(sb, "failed to get inode (nid: %llu) page, err %ld",
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -32,10 +32,8 @@ __printf(3, 4) void _erofs_info(struct s
 #define erofs_info(sb, fmt, ...) \
 	_erofs_info(sb, __func__, fmt "\n", ##__VA_ARGS__)
 #ifdef CONFIG_EROFS_FS_DEBUG
-#define erofs_dbg(x, ...)       pr_debug(x "\n", ##__VA_ARGS__)
 #define DBG_BUGON               BUG_ON
 #else
-#define erofs_dbg(x, ...)       ((void)0)
 #define DBG_BUGON(x)            ((void)(x))
 #endif	/* !CONFIG_EROFS_FS_DEBUG */
 
--- a/fs/erofs/namei.c
+++ b/fs/erofs/namei.c
@@ -203,16 +203,13 @@ static struct dentry *erofs_lookup(struc
 
 	err = erofs_namei(dir, &dentry->d_name, &nid, &d_type);
 
-	if (err == -ENOENT) {
+	if (err == -ENOENT)
 		/* negative dentry */
 		inode = NULL;
-	} else if (err) {
+	else if (err)
 		inode = ERR_PTR(err);
-	} else {
-		erofs_dbg("%s, %pd (nid %llu) found, d_type %u", __func__,
-			  dentry, nid, d_type);
+	else
 		inode = erofs_iget(dir->i_sb, nid);
-	}
 	return d_splice_alias(inode, dentry);
 }
 
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -818,8 +818,6 @@ repeat:
 
 	if (offset + cur < map->m_la ||
 	    offset + cur >= map->m_la + map->m_llen) {
-		erofs_dbg("out-of-range map @ pos %llu", offset + cur);
-
 		if (z_erofs_collector_end(fe))
 			fe->backmost = false;
 		map->m_la = offset + cur;
@@ -935,9 +933,6 @@ out:
 	if (err)
 		z_erofs_page_mark_eio(page);
 	z_erofs_onlinepage_endio(page);
-
-	erofs_dbg("%s, finish page: %pK spiltted: %u map->m_llen %llu",
-		  __func__, page, spiltted, map->m_llen);
 	return err;
 }
 
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -603,9 +603,6 @@ static int z_erofs_do_map_blocks(struct
 
 unmap_out:
 	erofs_unmap_metabuf(&m.map->buf);
-	erofs_dbg("%s, m_la %llu m_pa %llu m_llen %llu m_plen %llu m_flags 0%o",
-		  __func__, map->m_la, map->m_pa,
-		  map->m_llen, map->m_plen, map->m_flags);
 	return err;
 }
 


