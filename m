Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054503;
	b=stSU6X9Algod8WrIcg1IuZznPwvKGxaC59VdB0SVd+zq5mY3VXxQvsOdLKsUx+qxkB/7
	 FBiUiCyUoO+FyDxmMx4LeKBeeOXNaVLKBRBVACDPhG1kD5G7rSh3QEeqXLU9Fb3PyDBpT
	 Wi726vGjIEMnLn09zqjHwV513MTq1hpzqiAua8zap0for/2MgNGgibwqd4mw3C+paWOz6
	 A6lS0jtvCR1jqSG6xoLrqklJKOPRmdp7p2EuiVm5aNz+PKuFahTXFRRADkHb/OQ7+h2Rj
	 M9vSxh/9ibH4vzLK4VB2I8JHEGy2dz2HysInyStW2pPmvHesTXXOveuV++oU1Kb6Siw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054503;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SCtu3mz9V/2DqLbdT9Nboe83dH8hIn919HIq34ndPv8=;
	b=DQ8Pgyz/4zntwvmv7K24RDimLDkmXS1nIyW8l9bbEvPg2+3U+FNJ+9aE6Xi6v0txrc1r
	 /5ba0tNsZqu7GHz/DUcBwG2nBVwhyhH0/mBrR+fDB1R/HR4sBxKyVjEuouQGtcSXrWVHr
	 YK5xuGLHuKiwN9ZsGIHPeRzgvecd51LOS7+ziunJhLwb1wqZKdrjrlHPrbGjuBXEmsET6
	 Sxz/pAh3XLhZMaOPyP+qeVEJvwz21F9mXAsyWloCJtqcdlZpRm0xGt6DGnAZBt+OVkhXG
	 1zzX9y9xkl4KzMqYiK9E0jwLB49udpjYc4rJ2qVRx9vFWiMS4meAlieuOGYVgN+YEcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ZpOaNO3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C672606A31C;
	Thu, 19 Nov 2026 02:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ZpOaNO3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA631F000C4;
	Thu, 19 Nov 2026 02:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054503;
	bh=SCtu3mz9V/2DqLbdT9Nboe83dH8hIn919HIq34ndPv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ZpOaNO3cft6BBu+v3qOULNjVNzwdBeKAtD2dNXBwZnrpwjfwaEevlGYjVsznpusF
	 3gINTa9HuzxdgDJ1QfQNyYGnKTqGtrSwSDTDMumhd4Rsa2hyA/fzs+yWPDPV2aprlE
	 aQxDfZW5OZ+aZuBK6tlLpTj8IsAVgrroSWZNtWVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1298/2214] mm/shmem: make shmem_file() check the files inode
Date: Wed, 18 Nov 2026 15:49:34 +0100
Message-ID: <20261118150103.459654581@linuxfoundation.org>
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

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit d3710111839d11339e414b1bb3fea3d05ab83f6e ]

shmem_file() only checks if file->f_mapping is a shmem mapping. This
mapping can belong to another file, however, as with a Coda file backed
by a tmpfs container after mmap().

So it does not guarantee that the file inode is an actual shmem inode.

Seal handling and memfd preservation use this check before accessing
shmem inode state, so they can access an inode of the wrong type.

Let's make shmem_file() check the inode's file operations instead, to
identify shmem inodes reliably. This will identify regular shmem inodes,
including memfds and ordinary tmpfs files, independently of wrapper file
operations.

Use shmem_mapping() in collapse_file() instead to not change the behavior
of collapse_file(): it operates on the page cache and uses mapping->host
for shmem inode operations. Focusing on the file does not seem relevant.

Fixes: c49fcfcda8b5 ("mm/shmem: update file sealing comments and file checking")
Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Cc: stable@vger.kernel.org
Reported-by: Chris Mason <mason@kernel.org>
Suggested-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Link: https://patch.msgid.link/20261031-fixes_core-v3-3-d6437171ecc3@kernel.org
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: Adjusted context to retain the existing inline shmem_mapping() helper. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/shmem_fs.h | 15 ++++++---------
 mm/khugepaged.c          |  2 +-
 mm/shmem.c               |  5 +++++
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 166158b6e917a..d6aeccd1d22a0 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -68,12 +68,18 @@ extern unsigned long shmem_get_unmapped_area(struct file *, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 extern int shmem_lock(struct file *file, int lock, struct ucounts *ucounts);
 #ifdef CONFIG_SHMEM
+bool shmem_file(struct file *file);
 extern const struct address_space_operations shmem_aops;
 static inline bool shmem_mapping(struct address_space *mapping)
 {
 	return mapping->a_ops == &shmem_aops;
 }
 #else
+static inline bool shmem_file(struct file *file)
+{
+	return false;
+}
+
 static inline bool shmem_mapping(struct address_space *mapping)
 {
 	return false;
@@ -115,15 +121,6 @@ static inline struct page *shmem_read_mapping_page(
 					mapping_gfp_mask(mapping));
 }
 
-static inline bool shmem_file(struct file *file)
-{
-	if (!IS_ENABLED(CONFIG_SHMEM))
-		return false;
-	if (!file || !file->f_mapping)
-		return false;
-	return shmem_mapping(file->f_mapping);
-}
-
 /*
  * If fallocate(FALLOC_FL_KEEP_SIZE) has been used, there may be pages
  * beyond i_size's notion of EOF, which fallocate has committed to reserving:
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index a7a8e6bc70b01..bd909aa4b8fee 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1694,13 +1694,13 @@ static void collapse_file(struct mm_struct *mm,
 		struct page **hpage, int node)
 {
 	struct address_space *mapping = file->f_mapping;
+	const bool is_shmem = shmem_mapping(mapping);
 	gfp_t gfp;
 	struct page *new_page;
 	pgoff_t index, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
 	int nr_none = 0, result = SCAN_SUCCEED;
-	bool is_shmem = shmem_file(file);
 	int nr;
 
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
diff --git a/mm/shmem.c b/mm/shmem.c
index 04363ece9ecf6..58a12931d2149 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -250,6 +250,11 @@ static const struct inode_operations shmem_special_inode_operations;
 static const struct vm_operations_struct shmem_vm_ops;
 static struct file_system_type shmem_fs_type;
 
+bool shmem_file(struct file *file)
+{
+	return file && file_inode(file)->i_fop == &shmem_file_operations;
+}
+
 bool vma_is_shmem(struct vm_area_struct *vma)
 {
 	return vma->vm_ops == &shmem_vm_ops;
-- 
2.53.0



