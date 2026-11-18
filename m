Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047741;
	b=bGwNJ+X6pvbyX/z/DKVznosgzwBkPWPxMSkqbbA+pFxB7ddqj5/nE8QF+u2LwpBxoNEy
	 Z9d0aauiPTI4Kik+Rj+MkInqsKRicUb/eCm1v0c7zYJSX4QX5URM/yGmVrjuZK4fAUSn5
	 nmLrEQLMP46ir2tm8T7vipMz7tt3GkzTmWZEh8HH4J1kea7aqNn0OvV55i6fBtTmdsOeK
	 v1ahohxYwGPG8tIbLx4iIJne7b3xI5/TT8m+yDYEsYZNNlfyfWTCL4yl2RYaRiT6v/Fii
	 BrekwX/U0qFEn1guWqXHai0ddhH1TSYXC705fVuSs35FLUODsbK9oKL/DqD7DPMgbSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047741;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GQdJ4KCgRIB5/sMD+vxfrJzzDF/7HD7MhWF+yiDi4wA=;
	b=nyqowL97vs2ExHf751Sv0DqSPAhOHVdawHOD4bXgJ8vjoxyeNTYBKWkusLzkSlWjtAAO
	 XTxTW5TlN87ApSDyLuLHxSmYs6hbkUe7yutl9rhm37Xc9PzDRq5rhDZUt0u9ckffbJl92
	 S+7MKflBmiCserQ9EFXzY2SMi2ivCmmB0wouvs+M954DCUt/OTSlJDNp0ojieNB6ePhFs
	 dRiib9ocLOBlwo8MZMd45p+PLhp/zd62WQ/As00YBa8zw+4ecOO9IBZ7pWXC7MYJdlVXm
	 kUhZDy/NR6CIDCTzidkd0hKJODeViKKiZhcC4NuOYOQkdxxLYB8yMHpNdUUJrapHiuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cFRhEq7u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091CB606A325;
	Thu, 19 Nov 2026 00:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cFRhEq7u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6CA1F000C4;
	Thu, 19 Nov 2026 00:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047740;
	bh=GQdJ4KCgRIB5/sMD+vxfrJzzDF/7HD7MhWF+yiDi4wA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cFRhEq7u+6A2m4/C87byIKFngLlO0COe01A3eCaRAfL7KYuzvhRowq4e5s5VvDcIP
	 NLKS8YL39/J9mjUaWmKcLB5zUBB7fRAjIIpDth1uR61q7o6+wEbMdKbZ8k8rYxCPU6
	 +TpKxwsxXl/4Mf7v5W7ekL1sdKqhj3WVFo5v4sW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1747/2857] perf jitdump: Validate code_size against total_size in code load
Date: Wed, 18 Nov 2026 15:46:21 +0100
Message-ID: <20261118150304.199617069@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 06c7cf7a072fcd52e68471628c56630d2bdcc650 ]

jit_repipe_code_load() reads code_size from the jitdump record and uses
it to compute a pointer to the code blob:

  code = (unsigned long)jr + jr->load.p.total_size - csize;

An oversized code_size underflows the pointer arithmetic, causing OOB
reads into earlier heap memory.  Validate that code_size fits within the
record (total_size - sizeof(jr->load)) before the pointer computation.

code_size is uint64_t but csize is int; values above INT_MAX wrap
negative when narrowed into csize, which defeats the bounds check and
sends the code pointer past the end of the record.  Reject those too.

Fixes: 9b07e27f88b9 ("perf inject: Add jitdump mmap injection support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stephane Eranian <eranian@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index fc90ec12a53b6..e10b16625a20e 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -9,6 +9,7 @@
 #include <fcntl.h>
 #include <unistd.h>
 #include <inttypes.h>
+#include <limits.h>
 #include <byteswap.h>
 #include <sys/stat.h>
 #include <sys/mman.h>
@@ -448,6 +449,16 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
 	csize = jr->load.code_size;
 	usize = jd->unwinding_mapped_size;
 	addr  = jr->load.code_addr;
+
+	/* code blob lives at the end of the record, validate it fits */
+	if (jr->load.p.total_size < sizeof(jr->load) ||
+	    jr->load.code_size > jr->load.p.total_size - sizeof(jr->load) ||
+	    jr->load.code_size > INT_MAX) {
+		pr_warning("jitdump: invalid code_size %" PRIu64 " (total_size=%u) in code_load record\n",
+			   (uint64_t)jr->load.code_size, jr->load.p.total_size);
+		return -1;
+	}
+
 	sym   = (void *)((unsigned long)jr + sizeof(jr->load));
 	code  = (unsigned long)jr + jr->load.p.total_size - csize;
 	count = jr->load.code_index;
-- 
2.53.0



