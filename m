Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868E11A08DD;
	Thu, 15 Aug 2024 13:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728904; cv=none; b=U1jHtMjdvaHN2fmXXhPihSMMqxGdktUej2hw3uq1SNyeT7x3gZlwsyTJsAT8jhJCv6SQn6AnO9NaI7T6Qek69ahKLJ8O0c6q2I2uVh3wRCVZ7YCT7mySaMd7NJST8RfzA5Kw/kZZw16PllCJxireEs5AL6I8+1EZkF+kx9/c19w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728904; c=relaxed/simple;
	bh=1NFIO2lOCy7gMB/8DOnD7sNGy2Z5fFQL4jK8nzMfGNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwPliw6q12aHEH7swSF2gKKCmTjnts99LI5AbriYpS+zA6yHMscfB0gKAmvMAEyiJoXh0oFvGijZAuJ/pyM7Y9TzA7SItP4m4xAyin6sC33gDlKS1iYcE/29QqUqTTZwop18WVXU2QKcdcN2C5lE43rNk7fAvWqptSqTlIfAsh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3ZfeRPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3ZfeRPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5F3C32786;
	Thu, 15 Aug 2024 13:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728904;
	bh=1NFIO2lOCy7gMB/8DOnD7sNGy2Z5fFQL4jK8nzMfGNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3ZfeRPSGXPRE3vNad6qY31te2F1PSRB91LAuylQTIS6T9mi7rQb4OaNhSh5jy5AE
	 FwinBJoISpSPqn1eWU/esvbFaGlXkE1UTP48KyBiGnS7JFRBaAgnzfMYVrkQ/BWUSd
	 Y9twJR2mS41g4DCijipzp0M5MHBIGKG1TP+I63/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jiri Olsa <jolsa@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Peter Zijlstra <peterz@infradead.org>,
	Stephane Eranian <eranian@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vince Weaver <vincent.weaver@maine.edu>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 116/196] perf/x86/intel/pt: Use helpers to obtain ToPA entry size
Date: Thu, 15 Aug 2024 15:23:53 +0200
Message-ID: <20240815131856.515264452@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

[ Upstream commit fffec50f541ace292383c0cbe9a2a97d16d201c6 ]

There are a few places in the PT driver that need to obtain the size of
a ToPA entry, some of them for the current ToPA entry in the buffer.
Use helpers for those, to make the lines shorter and more readable.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Link: http://lkml.kernel.org/r/20190821124727.73310-3-alexander.shishkin@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Stable-dep-of: ad97196379d0 ("perf/x86/intel/pt: Fix a topa_entry base address calculation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/pt.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 62ef4b68f04c6..b8a2408383d0c 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -573,6 +573,7 @@ struct topa {
 
 /* make -1 stand for the last table entry */
 #define TOPA_ENTRY(t, i) ((i) == -1 ? &(t)->table[(t)->last] : &(t)->table[(i)])
+#define TOPA_ENTRY_SIZE(t, i) (sizes(TOPA_ENTRY((t), (i))->size))
 
 /**
  * topa_alloc() - allocate page-sized ToPA table
@@ -772,7 +773,7 @@ static void pt_update_head(struct pt *pt)
 
 	/* offset of the current output region within this table */
 	for (topa_idx = 0; topa_idx < buf->cur_idx; topa_idx++)
-		base += sizes(buf->cur->table[topa_idx].size);
+		base += TOPA_ENTRY_SIZE(buf->cur, topa_idx);
 
 	if (buf->snapshot) {
 		local_set(&buf->data_size, base);
@@ -801,7 +802,7 @@ static void *pt_buffer_region(struct pt_buffer *buf)
  */
 static size_t pt_buffer_region_size(struct pt_buffer *buf)
 {
-	return sizes(buf->cur->table[buf->cur_idx].size);
+	return TOPA_ENTRY_SIZE(buf->cur, buf->cur_idx);
 }
 
 /**
@@ -831,7 +832,7 @@ static void pt_handle_status(struct pt *pt)
 		 * know.
 		 */
 		if (!intel_pt_validate_hw_cap(PT_CAP_topa_multiple_entries) ||
-		    buf->output_off == sizes(TOPA_ENTRY(buf->cur, buf->cur_idx)->size)) {
+		    buf->output_off == pt_buffer_region_size(buf)) {
 			perf_aux_output_flag(&pt->handle,
 			                     PERF_AUX_FLAG_TRUNCATED);
 			advance++;
@@ -926,8 +927,7 @@ static int pt_buffer_reset_markers(struct pt_buffer *buf,
 	unsigned long idx, npages, wakeup;
 
 	/* can't stop in the middle of an output region */
-	if (buf->output_off + handle->size + 1 <
-	    sizes(TOPA_ENTRY(buf->cur, buf->cur_idx)->size)) {
+	if (buf->output_off + handle->size + 1 < pt_buffer_region_size(buf)) {
 		perf_aux_output_flag(handle, PERF_AUX_FLAG_TRUNCATED);
 		return -EINVAL;
 	}
@@ -1033,7 +1033,7 @@ static void pt_buffer_reset_offsets(struct pt_buffer *buf, unsigned long head)
 	buf->cur = (struct topa *)((unsigned long)buf->topa_index[pg] & PAGE_MASK);
 	buf->cur_idx = ((unsigned long)buf->topa_index[pg] -
 			(unsigned long)buf->cur) / sizeof(struct topa_entry);
-	buf->output_off = head & (sizes(buf->cur->table[buf->cur_idx].size) - 1);
+	buf->output_off = head & (pt_buffer_region_size(buf) - 1);
 
 	local64_set(&buf->head, head);
 	local_set(&buf->data_size, 0);
-- 
2.43.0



