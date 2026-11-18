Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028911;
	b=Hlh+MyewWeNso08rtxo1JCtKWrGSf8dEs5JDuWg0drPSDVFF5sPIrFWAYIGoLcIq2KJm
	 fwuIU/P6axRTx3RB0C7okeaPXp8fWwSMij21JGys6A/r1DENAU1b/FFkYQxuhi1WnB2pB
	 mBz5YPPwkMdXYhpWKBaRvRJuT9MwVOa9RIAr1dL9SmOLRW/J5hurBSU6YqRjhmJZge8VB
	 foCzcxQ9P1ceH6hb/4xhPEMq1wu0qKe2N9NZeQ0d5XB7B4TMiSkxH3KnD27SndKgfRgSE
	 nAV6P9qFVaHcKVMsROp5Zow03usfvNvFwqPxoJDJCuMcSzsg/toeUvksEl0LY50ygjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028911;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=998hIOugqSMRBZ+ckCQXmiH8EjOiaSECG0lUw4TP754=;
	b=0wUtljuQSPrIR00qGuPGOkWuOHlLOL4xCR2gbueJSS3PVRzRAWP9unZulFRovwxI+/kQ
	 8CZM4Pt5c+V+zubrlC0IQjRnn6DFEe8oVI5EMw0kBtDYY+1MULGIzYmNmnq8hlI70b1y2
	 ijlxFrZNhafMUO9qMUNGKPqrKPpbh4skXztgHnRojcmgMm5JCDkDMOC+ydmHWH/r0/vE2
	 LTib4nDutO9GNRKe/z2Z9ApaHtK4WHwjWooue/z1HX+qc3FodcoBgjIZI37of159aZQZM
	 z3AaQaEeDQm3NJDAzsyTBSIhI+2dRtMnle6c3gRcRMB2YAc03tCObcldKDpHE0QbE5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=myNHytRr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF303606A33A;
	Wed, 18 Nov 2026 19:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=myNHytRr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDEF01F000C4;
	Wed, 18 Nov 2026 19:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028911;
	bh=998hIOugqSMRBZ+ckCQXmiH8EjOiaSECG0lUw4TP754=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=myNHytRrxGx5kGADPqIxlPrdX1YrdX/kqezmtxNDZNj8m4RJUqehS7hfr7vKorK/a
	 58ks1jJP5mKizme00DX4c/kK5LtGqp7dtvaVTAVKA2XSFfaLi3flYQp/0D3MbyDk6U
	 K4Pbv4mk0kkSU/AUulJ2YVNevoCgH8txsyRB08wA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0116/1756] mm/shmem: make shmem_file() check the files inode
Date: Wed, 18 Nov 2026 15:37:23 +0100
Message-ID: <20261118150012.807468588@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
[ sashal: Adjusted context to preserve the existing non-const shmem_mapping() interface. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/shmem_fs.h | 15 ++++++---------
 mm/khugepaged.c          |  2 +-
 mm/shmem.c               |  5 +++++
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 515a9a6a3c6f8..183975ead5cf6 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -97,8 +97,14 @@ extern unsigned long shmem_get_unmapped_area(struct file *, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 extern int shmem_lock(struct file *file, int lock, struct ucounts *ucounts);
 #ifdef CONFIG_SHMEM
+bool shmem_file(struct file *file);
 bool shmem_mapping(struct address_space *mapping);
 #else
+static inline bool shmem_file(struct file *file)
+{
+	return false;
+}
+
 static inline bool shmem_mapping(struct address_space *mapping)
 {
 	return false;
@@ -161,15 +167,6 @@ static inline struct page *shmem_read_mapping_page(
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
index 2e9d0e13b068a..9b8021d440289 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1809,6 +1809,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 			 struct collapse_control *cc)
 {
 	struct address_space *mapping = file->f_mapping;
+	const bool is_shmem = shmem_mapping(mapping);
 	struct page *dst;
 	struct folio *folio, *tmp, *new_folio;
 	unsigned long new_pfn = -1;
@@ -1816,7 +1817,6 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
 	int nr_none = 0, result = SCAN_SUCCEED;
-	bool is_shmem = shmem_file(file);
 	bool do_readahead = false;
 	bool readahead_done = false;
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 8de38d7a98f92..df6a57f227865 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -270,6 +270,11 @@ static const struct vm_operations_struct shmem_vm_ops;
 static const struct vm_operations_struct shmem_anon_vm_ops;
 static struct file_system_type shmem_fs_type;
 
+bool shmem_file(struct file *file)
+{
+	return file && file_inode(file)->i_fop == &shmem_file_operations;
+}
+
 bool shmem_mapping(struct address_space *mapping)
 {
 	return mapping->a_ops == &shmem_aops;
-- 
2.53.0



