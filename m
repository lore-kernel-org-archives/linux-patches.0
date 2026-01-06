Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B812036CDEF;
	Tue,  6 Jan 2026 17:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722311; cv=none; b=lLIMwtc6bC+NqaQkavmghsVDC72j1+66xaqFwKozpyF179pPlALyHGdIzZWCuFaAJi0KJN2+PD4aSbuf4xOEDQoIBNtIHOn7wfYzxcQBOO750Fe4E/mrTGukU6cx9t4lr6Hal3kKKN+nnPWDz8N8aCoudWsLyeLwzClKU8472D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722311; c=relaxed/simple;
	bh=F//olfWLEpSlAsWGzw48FNIS4x/yg/y80nOHLA/liOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0ivJFDorfbsW4B8KXKbka3usCMN5bgWD9uknou/6gHnmNz9DR50n1LndgnP56FeANDr5tYkGiE1dp4N5NyADdYkLMpyZr7bsXY+rTZvT995XaP5b6fqQ7MqOhxXByCIo12MfScM6MCuLKSs8F2KKv+2keaHLufxjq+aseamIDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N/k9e7hu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N/k9e7hu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A71C116C6;
	Tue,  6 Jan 2026 17:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722311;
	bh=F//olfWLEpSlAsWGzw48FNIS4x/yg/y80nOHLA/liOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N/k9e7huSOdu7bIJh6qf5XhgZY/but+llBHW3Z/VBkNNXmnu+I/+1O0vMZYVnQiJR
	 NaWd74WXqS5HIbHBzt2e8zKq/ZMuc8VasrykifD/tSbA1o0SO2cX525xXBbKHfMaWV
	 rRTMhU+sNe1GlZaN/41oNaT4mlQcem8bvehrc1/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pingfan Liu <piliu@redhat.com>,
	Baoquan He <bhe@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Alexander Graf <graf@amazon.com>,
	Steven Chen <chenste@linux.microsoft.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 225/312] kernel/kexec: change the prototype of kimage_map_segment()
Date: Tue,  6 Jan 2026 18:04:59 +0100
Message-ID: <20260106170555.993286416@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pingfan Liu <piliu@redhat.com>

commit fe55ea85939efcbf0e6baa234f0d70acb79e7b58 upstream.

The kexec segment index will be required to extract the corresponding
information for that segment in kimage_map_segment().  Additionally,
kexec_segment already holds the kexec relocation destination address and
size.  Therefore, the prototype of kimage_map_segment() can be changed.

Link: https://lkml.kernel.org/r/20251216014852.8737-1-piliu@redhat.com
Fixes: 07d24902977e ("kexec: enable CMA based contiguous allocation")
Signed-off-by: Pingfan Liu <piliu@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: Roberto Sassu <roberto.sassu@huawei.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Steven Chen <chenste@linux.microsoft.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kexec.h              |    4 ++--
 kernel/kexec_core.c                |    9 ++++++---
 security/integrity/ima/ima_kexec.c |    4 +---
 3 files changed, 9 insertions(+), 8 deletions(-)

--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -530,7 +530,7 @@ extern bool kexec_file_dbg_print;
 #define kexec_dprintk(fmt, arg...) \
         do { if (kexec_file_dbg_print) pr_info(fmt, ##arg); } while (0)
 
-extern void *kimage_map_segment(struct kimage *image, unsigned long addr, unsigned long size);
+extern void *kimage_map_segment(struct kimage *image, int idx);
 extern void kimage_unmap_segment(void *buffer);
 #else /* !CONFIG_KEXEC_CORE */
 struct pt_regs;
@@ -540,7 +540,7 @@ static inline void __crash_kexec(struct
 static inline void crash_kexec(struct pt_regs *regs) { }
 static inline int kexec_should_crash(struct task_struct *p) { return 0; }
 static inline int kexec_crash_loaded(void) { return 0; }
-static inline void *kimage_map_segment(struct kimage *image, unsigned long addr, unsigned long size)
+static inline void *kimage_map_segment(struct kimage *image, int idx)
 { return NULL; }
 static inline void kimage_unmap_segment(void *buffer) { }
 #define kexec_in_progress false
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -960,17 +960,20 @@ int kimage_load_segment(struct kimage *i
 	return result;
 }
 
-void *kimage_map_segment(struct kimage *image,
-			 unsigned long addr, unsigned long size)
+void *kimage_map_segment(struct kimage *image, int idx)
 {
+	unsigned long addr, size, eaddr;
 	unsigned long src_page_addr, dest_page_addr = 0;
-	unsigned long eaddr = addr + size;
 	kimage_entry_t *ptr, entry;
 	struct page **src_pages;
 	unsigned int npages;
 	void *vaddr = NULL;
 	int i;
 
+	addr = image->segment[idx].mem;
+	size = image->segment[idx].memsz;
+	eaddr = addr + size;
+
 	/*
 	 * Collect the source pages and map them in a contiguous VA range.
 	 */
--- a/security/integrity/ima/ima_kexec.c
+++ b/security/integrity/ima/ima_kexec.c
@@ -250,9 +250,7 @@ void ima_kexec_post_load(struct kimage *
 	if (!image->ima_buffer_addr)
 		return;
 
-	ima_kexec_buffer = kimage_map_segment(image,
-					      image->ima_buffer_addr,
-					      image->ima_buffer_size);
+	ima_kexec_buffer = kimage_map_segment(image, image->ima_segment_index);
 	if (!ima_kexec_buffer) {
 		pr_err("Could not map measurements buffer.\n");
 		return;


