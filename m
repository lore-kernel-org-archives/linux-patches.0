Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054660;
	b=eBLN3q35gHFOTRhepO3ProOEnDtpxjiAcOxXPh4AZnli2qyauarS7VkxklS+ZZ5QTHHW
	 smn0Z5zXWRNBCB1xe8IMpwFlrswACCPALimE3Sb5ue8v0SMQXqp92RSuRt69clvwBHTf8
	 1T3eXOIt0arUFfw/Seoiz5QhgjySuO9Vf/7Gvf2wm/yINfysrF0PH6QBhYbdNas2r/Bck
	 TF0zCXa6HxKP4SDrjQbVH9uh//ZJbulTT5AP+esfb+tjY3ug+Ul8k/CX0RBR/1rxcZzCD
	 nREn/eeu5RGIgp4/bbDMa7MgrzqbTyTPJ8H2hLy2WpwoXVO/7BNyke3igYtTXgmCXrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054660;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=A15BRFiPnWZR3R1YkPPgR4AhiGy4U10svoDgUVt1vMQ=;
	b=nT+kQCCsZI4kxb6uNl9NM8jBbSUec1jTsuzD7SaI/8P0d0DTj3uAJ0TbYGod/uRd1Ixd
	 FjRYeRhenlQDuIHpcB3fdw6PH7qKjUdD32FQYVujchvCm+pXVAKwYccD1mWoV7Dms807u
	 koCPsaNMlOxZ8AoJDoeXaKqa9MVaWDSg7SHcvIjODayQ0cEZrenBx5/buRTHH0cK91oit
	 A2qjn5Rao7zUgoQcN1XJEZkoan5tm2aSWGYVw66rKrMPraaain+mDRqLwFB28z6ZB8xND
	 3dQ0VIB9VJ7vBpJNWH2jXk9xxzk/XZ9fvXSaiccjSGNIgltXvVTiLWbHsHUk2/7UY0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jzazywe/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFE9606A32A;
	Thu, 19 Nov 2026 02:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jzazywe/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62C31F000C4;
	Thu, 19 Nov 2026 02:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054660;
	bh=A15BRFiPnWZR3R1YkPPgR4AhiGy4U10svoDgUVt1vMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jzazywe/w9Fs9VFNv5dyL30GwpBSeH5QI+bwl45nb8CiB8ueCIlYDzNCWi2HLeIN8
	 5mGg+fVC4TpxdsP4MB5fotYHkQ6eNVex97Q3At3fgGEEQZUTV//vm8WsurviSMHqc2
	 0l5EGjZGMaapxdjlBNbElrLWIjfvpY/76bEPj+dY=
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
Subject: [PATCH 5.15 1354/2214] perf jitdump: Validate unwinding sizes against record payload
Date: Wed, 18 Nov 2026 15:50:30 +0100
Message-ID: <20261118150105.592117870@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e23ba5866ffce..49b055313ea6a 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -469,7 +469,8 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
 	u16 idr_size;
 	const char *sym;
 	uint64_t count;
-	int ret, csize, usize;
+	int ret, csize;
+	uint64_t usize;
 	pid_t nspid, pid, tid;
 	struct {
 		u32 pid, tid;
@@ -550,7 +551,7 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
 
 	event->mmap2.pgoff = GEN_ELF_TEXT_OFFSET;
 	event->mmap2.start = addr;
-	event->mmap2.len   = usize ? ALIGN_8(csize) + usize : csize;
+	event->mmap2.len   = usize ? ALIGN_8((uint64_t)csize) + usize : (uint64_t)csize;
 	event->mmap2.pid   = pid;
 	event->mmap2.tid   = tid;
 	event->mmap2.ino   = st.st_ino;
@@ -603,7 +604,7 @@ static int jit_repipe_code_move(struct jit_buf_desc *jd, union jr_entry *jr)
 	char *filename;
 	size_t size;
 	struct stat st;
-	int usize;
+	uint64_t usize;
 	u16 idr_size;
 	int ret;
 	pid_t nspid, pid, tid;
@@ -750,6 +751,18 @@ jit_repipe_unwinding_info(struct jit_buf_desc *jd, union jr_entry *jr)
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



