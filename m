Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022730;
	b=r+mR8wx6oMXAZebjkBulKNGgYltUCXJIG1RfTfJxxdlqqNG19I1aImryPt1jM3hUrXsp
	 1ahxP0o+Sv+EHGCfKTwaf0EpSC00bFu/7KQbrpCno3IUaf8kSBVE0BkT0mlNuXzAQeAZo
	 grkVBNXQUuUU11ihJQYXI6ATuFsdDztn/pS//szajVQnpNb9gVhHmPynN10DUxxe3uxW+
	 lfpea9lL69CZhtbEqgpb05C+5s/k4qDkGUQ8LsRpvfwI4p9lzSgWwquXRThiqIgB+jZZJ
	 +2sDLhu2sX3H5dD6ttZEhKBWMa0/vXDCe3zM4Sd8AfVgHXNa9h7tfVFvj9J3UAMSXOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gMToeS9Y28Js0yN6kCpK526pOxI43B7tC4siORb+VSo=;
	b=la9+M9uONwim0m8hUnpEO1cAoOwP5Hlqw1jbUAGpLjOCXBvC/KTVePVA6bVX8rxf3O42
	 CUr6USLwNR1R8fng8qFozr9F1T0AeSYv1cQW7PHIO9Dp8hDTxs95tAeepdcvecd9xaVFT
	 epgsT/5vPKa6F6A+T4kAjAhf2/EWeJxuW/66nS5F+hGzuVFcwxKl+k1DekXO+m7sm5tqb
	 iC7tPoigtpQLe5W3M2cM471gfm9yMbATABSFL47qjIF2OnEugORF0JUKijXt9e4rZ2l73
	 a0GQF0/zPTCS76UKOyupxsE+7oRTDFQ/zeg543TNdR0PM6kx2lMZwFAnS4Ivv8cMc0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A2ioj5HL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D4D606A32F;
	Wed, 18 Nov 2026 17:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A2ioj5HL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732AE1F000C9;
	Wed, 18 Nov 2026 17:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022730;
	bh=gMToeS9Y28Js0yN6kCpK526pOxI43B7tC4siORb+VSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A2ioj5HLiS+LEyblv3LcDip0LFpvjeeu3g4AgTuex5LbL4hXBxOpajSp2ARvGIgj5
	 feIWfZeXgDmn8UN+jyXmeB97CSfXAbCGtqi13LifFXEo5aDB7CeHFMSVP2zVE5JQQQ
	 Il0xg8bP0+4xvhu0+8utdk2HQdS6nNv8qrrSnPAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0117/2151] mm/shmem: make shmem_file() check the files inode
Date: Wed, 18 Nov 2026 15:30:52 +0100
Message-ID: <20261118150126.053233200@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context for the missing shmem_freeze() helper and combined integer declarations in collapse_file() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/shmem_fs.h | 15 ++++++---------
 mm/khugepaged.c          |  2 +-
 mm/shmem.c               |  5 +++++
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 0e47465ef0fd5..2b49d4d1426ff 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -99,8 +99,14 @@ extern unsigned long shmem_get_unmapped_area(struct file *, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 extern int shmem_lock(struct file *file, int lock, struct ucounts *ucounts);
 #ifdef CONFIG_SHMEM
+bool shmem_file(struct file *file);
 bool shmem_mapping(const struct address_space *mapping);
 #else
+static inline bool shmem_file(struct file *file)
+{
+	return false;
+}
+
 static inline bool shmem_mapping(const struct address_space *mapping)
 {
 	return false;
@@ -171,15 +177,6 @@ static inline struct page *shmem_read_mapping_page(
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
index 6fa4d9b7e0129..7ca1772c5aa8b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1860,6 +1860,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 			 struct collapse_control *cc)
 {
 	struct address_space *mapping = file->f_mapping;
+	const bool is_shmem = shmem_mapping(mapping);
 	struct page *dst;
 	struct folio *folio, *tmp, *new_folio;
 	unsigned long new_pfn = -1;
@@ -1867,7 +1868,6 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
 	int nr_none = 0, result = SCAN_SUCCEED;
-	bool is_shmem = shmem_file(file);
 	bool do_readahead = false;
 	bool readahead_done = false;
 
diff --git a/mm/shmem.c b/mm/shmem.c
index e7c4d134b8255..63286a727fe4e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -275,6 +275,11 @@ static const struct vm_operations_struct shmem_vm_ops;
 static const struct vm_operations_struct shmem_anon_vm_ops;
 static struct file_system_type shmem_fs_type;
 
+bool shmem_file(struct file *file)
+{
+	return file && file_inode(file)->i_fop == &shmem_file_operations;
+}
+
 bool shmem_mapping(const struct address_space *mapping)
 {
 	return mapping->a_ops == &shmem_aops;
-- 
2.53.0



