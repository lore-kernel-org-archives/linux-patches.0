Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060147;
	b=Q41xsGUVx/SnC6QzICXHrmVIpWsdSqG6S/SZaadn6WVN/aZMiMdt0nLW/aWDe+y13GSZ
	 Lm9yYXXwvVHJTfWAx6H6mwJoj8yq7nMuMwf3S5YJQgNWaW+Ri1aAtwjuPf/fqDNJF6JTY
	 a5U/LTDlEVW4yJDebXVo2JvuJ4CUCFqdAng1xV589Y48/x/rao+Ezxe8LXBi2OSwkhCYR
	 F87Wqo5JSKcwecZotPNlEX09kfRexhmj4taUMlG/YLaV6MidjrkxPGKqbkO5+5oj2Zi0A
	 RUAaCA2Rg7zoyJ8eqwdlmsxXKAwAFuI71B72L3gOtTGEb1wIKj3ewYKxSRCb2EAYwLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=METmJIiJpDmyOdwRD7rUEuI3ELXrEBrC4BrK/kmXIX8=;
	b=cDi6M7ODYKr+D3hNhG6dgjHrhlhnirczX2LzbuzZc7jZjhSFqqAjWi8IW+fB91xoEfam
	 pw33vF/bBNMBxbkRu3CZxpxT0ZG3oRZahbHLEoYr6ibKazkal97fZtk2htCn15/kCja0l
	 ZIxZG1f2wmb8so982iPoaDbE764uZ6TwdlOKvqRp1lbI27QVbOOMPEkF0NinCLPcI+uiq
	 xkro2GXsN46FNORK8J4+no03AikprgcmCqdsRpsP5a4ZEc9lO5lruz7SdjJZBHTXPliNI
	 Aq+ZvEW6RW1qunh6THkueAxY2jtRFhPveen8JiIIKwuB8e6K7bRZC1uXny2Fuwwomgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SZkylWOq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DBA606A320;
	Thu, 19 Nov 2026 03:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SZkylWOq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7381F000C4;
	Thu, 19 Nov 2026 03:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060147;
	bh=METmJIiJpDmyOdwRD7rUEuI3ELXrEBrC4BrK/kmXIX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SZkylWOqYNR3nZj5lcZs6UDzejQFVhdAbkk+F+Zoa0udvCuBtYKadLMlF5G8T9FK3
	 gnR6mIVkLTZvRpYNDeuuIam6p9LAglITQlKMvFuVOj/hfsJQJk+aB5bobkhg6h32vk
	 5ILLmF6GLWlGO5ypA7Onf8o4h92SY2mWU9GqOjdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1094/1848] mm/shmem: make shmem_file() check the files inode
Date: Wed, 18 Nov 2026 15:52:12 +0100
Message-ID: <20261118150004.708371204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
[ sashal: Adjusted patch context to fit the older shmem helper layout. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/shmem_fs.h | 15 ++++++---------
 mm/khugepaged.c          |  2 +-
 mm/shmem.c               |  5 +++++
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index a5a5d1d4d7b1d..fe9063e9b2ee1 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -67,8 +67,14 @@ extern unsigned long shmem_get_unmapped_area(struct file *, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 extern int shmem_lock(struct file *file, int lock, struct user_struct *user);
 #ifdef CONFIG_SHMEM
+bool shmem_file(struct file *file);
 extern bool shmem_mapping(struct address_space *mapping);
 #else
+static inline bool shmem_file(struct file *file)
+{
+	return false;
+}
+
 static inline bool shmem_mapping(struct address_space *mapping)
 {
 	return false;
@@ -106,15 +112,6 @@ static inline struct page *shmem_read_mapping_page(
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
 extern bool shmem_charge(struct inode *inode, long pages);
 extern void shmem_uncharge(struct inode *inode, long pages);
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e523bb9381189..bf70c3bbf91ec 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1690,13 +1690,13 @@ static void collapse_file(struct mm_struct *mm,
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
 
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
 	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
diff --git a/mm/shmem.c b/mm/shmem.c
index 8858db132090c..bd91e3e9fb5a6 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -254,6 +254,11 @@ static const struct inode_operations shmem_special_inode_operations;
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



