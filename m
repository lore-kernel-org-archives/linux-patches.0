Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015328;
	b=oRujgNe8uX5xrq9fv0xzwY/sB71DOy1YbjX0PHWPrIrshLYwNhbMkehsNB/Bc5YKT0o2
	 YZ+8JJ7+dYY06J4QxBLt5V0aKaaqX2u0nU7crR4ZmKfw31BM5EigGhPF2dCC4rmFd9T0u
	 WiB8rkv9NbH31GVdpOz8V+cLAE1vmQIvWo0TgAP208UAjTxhgHZdApWatp5gzXhW6g2Bu
	 ux78yKwPA2F9hwrGgt3u/7JjvxAKlRaW0kvxHaMcU2mT3S9HP7m4PNkJQbbZGJ5gdV2al
	 mKf42MJLzviJQo24aYz8iIOcSePv92C1riL12O821FLtWpvL1U7qy//+xcHcQf6PEww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=nnIpsB+oKxIn16FxtUFLjJyiVPtkJrmBvWR5mU62lAA=;
	b=ZKjOdoF8AEgyn/CYz5/9Kp3aD0bTw0wqIkbYkn1QQV+5Va0S8aSf+fp4gviH93SSPCIu
	 D81+03BllcnU7liUtl+rtSPV2wRO9xxFO8L21TjIytPm1Kj89lDU6l/q7gxA7o5nFUiYq
	 F0KXrFAoC2JChVVvQrcIRISoWoQSBxh1gLRRLdTTFh5BYOWKiGLvXyLqGV8aMwcF921s4
	 iIW7s/KN7EoTJHyJtB90uwOFg8jazQGqDMlmzpB3rbciz4KJZj9NDGkaKqe3fYUxBIYIh
	 pUqs1TK23i/WHFPsVedOVdR/oaLwVTwa9p+JpzfzLK7TQQINuY0JGJarkl+/Mv8Wngg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="YYx7bz/M";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39428606A31C;
	Wed, 18 Nov 2026 15:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YYx7bz/M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9183E1F000C4;
	Wed, 18 Nov 2026 15:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015328;
	bh=nnIpsB+oKxIn16FxtUFLjJyiVPtkJrmBvWR5mU62lAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YYx7bz/M37JJ+N8aNi/4WuYz+3HyMBAGZU5bQuM6kFfKlO+OLxN5bBmJVR2v+fvgK
	 +djKJweN/uhvd0IjyaCgmGsk7pN/1oi4Wz8os53k3oAlMEW9BCRfRvM/FHnSc6+8VS
	 n/iIgkMT9vsgfYf6Kj38MAyQdmWYjNdi/bHc3zHA=
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
Subject: [PATCH 7.3 0117/2651] perf jitdump: Validate unwinding sizes against record payload
Date: Wed, 18 Nov 2026 15:22:37 +0100
Message-ID: <20261118150252.087192928@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 5898a7d8eb962..d25a9fe9b020c 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -462,7 +462,8 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
 	u16 idr_size;
 	const char *sym;
 	uint64_t count;
-	int ret, csize, usize;
+	int ret, csize;
+	uint64_t usize;
 	pid_t nspid, pid, tid;
 	struct {
 		u32 pid, tid;
@@ -543,7 +544,7 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
 
 	event->mmap2.pgoff = GEN_ELF_TEXT_OFFSET;
 	event->mmap2.start = addr;
-	event->mmap2.len   = usize ? ALIGN_8(csize) + usize : csize;
+	event->mmap2.len   = usize ? ALIGN_8((uint64_t)csize) + usize : (uint64_t)csize;
 	event->mmap2.pid   = pid;
 	event->mmap2.tid   = tid;
 	event->mmap2.ino   = st.st_ino;
@@ -612,7 +613,7 @@ static int jit_repipe_code_move(struct jit_buf_desc *jd, union jr_entry *jr)
 	char *filename;
 	size_t size;
 	struct stat st;
-	int usize;
+	uint64_t usize;
 	u16 idr_size;
 	int ret;
 	pid_t nspid, pid, tid;
@@ -761,6 +762,18 @@ jit_repipe_unwinding_info(struct jit_buf_desc *jd, union jr_entry *jr)
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



