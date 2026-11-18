Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039307;
	b=47ytW4ua+eI4OH9Qemlu3WYqyYxRZZsQS7mm60cdJSiim2Jwxanr0HChkG0mV2UXwCFD
	 FsL7DBc1Y8PnqzI4C61CLMUFI+vDJLuXcXJI/1F4topfkbPONzdSC+IKC4qrJ11eUEoA+
	 z1J92DiP9MjuMxq31hDlid6hzh7xVGFHVc8QPzGI606iSlMRiV6fGkOOi+xRtDSZts95O
	 3naFMNhj9w/YubBhrlgiCNEDrqbrOhfm17zj0RDTBhlydD6CkdNxoxJre87tI0ZvKY9D1
	 W4xcmM52s2EQk6ojK1xoc5FZVNF/d3kSbp5eadtCf7siImFBcVNU73kE4zljS889mtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=BYkX7YB941Vcv3Pu1gVUKFkC2ZjW6T0it8z+lYo+43U=;
	b=HHuiWKZmjEl6+TPTdGvJQlLPrWk6e/dvXV4hfdMeAoJdIUS+zf+MAj+BB47Wd0ldHb/W
	 FeATJ9UTiFEl/XjadA6T8CbwoonuOUSODibjlKBQrL6NtSwMcH6qdEJ2fOPIuvXeVM0S+
	 nr9dh0RpG7zeSa1Iz58ts/Ng9xX3VAwya1krKzFhPLsog8X5OARzOATZlp11/fiop366y
	 Kkl0DhrIrL+XB/wL2OymY/7trssYbDcLTAGVg9BNy/sTFgghNhR0IGROIP11oRVNYbOMs
	 xeo+JIV+KacGWbDKIH4iDFFE8nncaVhC4vqp3JeQCTt7CLDmX2/XzmN22WXDe6JDx/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gPFn6D+K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D895A606A325;
	Wed, 18 Nov 2026 22:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gPFn6D+K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41DB21F000C4;
	Wed, 18 Nov 2026 22:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039307;
	bh=BYkX7YB941Vcv3Pu1gVUKFkC2ZjW6T0it8z+lYo+43U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gPFn6D+K5iKTEftAah7XpRzRWkZGEDYmvwfJ2xCxQOR6ajFP21KgX14/0UqNaFnJ7
	 G7Vhh9FDcp+c+R7RALjTaSjmnDsZl92C+a5VM0pGz1qXjQHBPsKxuvHhSyOa4XgKbK
	 t66BfDIESDnx2bpRYU4ishIs2BTDKwVQzUOFou8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stefano Sanfilippo <ssanfilippo@chromium.org>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2013/3318] perf jitdump: Validate unwinding sizes against record payload
Date: Wed, 18 Nov 2026 15:43:55 +0100
Message-ID: <20261118150422.430839747@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 92d50319b4f0c0bbee8a236a09063272cd22faab ]

jit_repipe_unwinding_info() copies unwinding_size and eh_frame_hdr_size
from the jitdump record into jd-> fields without checking them against
the actual payload size.  Downstream, jit_add_eh_frame_info() in
genelf.c computes unwinding_table_size = unwinding_size -
eh_frame_hdr_size, which underflows when eh_frame_hdr_size >
unwinding_size.  The result is passed as d->d_size to libelf, causing
an OOB heap read into the output ELF file.

Validate that unwinding_size fits within the record payload and that
eh_frame_hdr_size does not exceed unwinding_size before allocating or
storing the values, so a bogus record cannot force a large allocation
that is then discarded.

mapped_size is likewise taken from the record and was narrowed into an
int for the mmap2 len computation in jit_repipe_code_load() and
jit_repipe_code_move(); values above INT_MAX would turn negative,
producing a wrong mmap2 length.  Use uint64_t for usize so the value
cannot truncate.

Fixes: 0284fecd13b6db3e ("perf jit: Add unwinding support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stefano Sanfilippo <ssanfilippo@chromium.org>
Cc: Stephane Eranian <eranian@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index 12daa9cece627..58ba7d6806c4b 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -461,7 +461,8 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
 	u16 idr_size;
 	const char *sym;
 	uint64_t count;
-	int ret, csize, usize;
+	int ret, csize;
+	uint64_t usize;
 	pid_t nspid, pid, tid;
 	struct {
 		u32 pid, tid;
@@ -542,7 +543,7 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
 
 	event->mmap2.pgoff = GEN_ELF_TEXT_OFFSET;
 	event->mmap2.start = addr;
-	event->mmap2.len   = usize ? ALIGN_8(csize) + usize : csize;
+	event->mmap2.len   = usize ? ALIGN_8((uint64_t)csize) + usize : (uint64_t)csize;
 	event->mmap2.pid   = pid;
 	event->mmap2.tid   = tid;
 	event->mmap2.ino   = st.st_ino;
@@ -595,7 +596,7 @@ static int jit_repipe_code_move(struct jit_buf_desc *jd, union jr_entry *jr)
 	char *filename;
 	size_t size;
 	struct stat st;
-	int usize;
+	uint64_t usize;
 	u16 idr_size;
 	int ret;
 	pid_t nspid, pid, tid;
@@ -742,6 +743,18 @@ jit_repipe_unwinding_info(struct jit_buf_desc *jd, union jr_entry *jr)
 		return -1;
 
 	unwinding_data_size  = jr->prefix.total_size - sizeof(jr->unwinding);
+
+	/*
+	 * Validate sizes before allocating — jit_add_eh_frame_info()
+	 * computes unwinding_size - eh_frame_hdr_size and uses the
+	 * result as a buffer length for libelf.
+	 */
+	if (jr->unwinding.unwinding_size > unwinding_data_size ||
+	    jr->unwinding.eh_frame_hdr_size > jr->unwinding.unwinding_size) {
+		pr_warning("jitdump: invalid unwinding sizes in unwinding_info record\n");
+		return -1;
+	}
+
 	unwinding_data = malloc(unwinding_data_size);
 	if (!unwinding_data)
 		return -1;
-- 
2.53.0



