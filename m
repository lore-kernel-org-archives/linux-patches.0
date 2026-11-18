Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015257;
	b=KDdHXwvo5hAyl2p7XAgQDaauwXO7MDu8DfmMuzVOBDtKyatfnLEpCmb7zasMt9RAYKog
	 pGHcmb3DJmUg8M5ShOaujQ9zrE6ofkvpT85nx12EMjYe5mDWmzZe7/XvT+I6n1hd+Efvb
	 gA53fuZeRGvUvoqDajTNpZtNZ46yyCm/55eoax0/a6T5eVGbqdrOvhHa7mGnQQkgalWaq
	 y6Ndg+01sbP+iBQQmJ9+bD3/M6yK4klB+hDl6sxI3fu5OGTRcZIpPzNFK9zBNGNLGacsI
	 ODK1TaqwoxSMHEE58+f3r/4qypMejdNzJcTYWNRD6I79zQdNQf3yLCBScQiQlqWOXMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015257;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gFwDhzqdCVSK2b0C761xGEU3uxdGuGvB1vYVod8zXXU=;
	b=V+XcIzL7ZHxzlq7KfaRPiZUBgnc2ULQD5dftUS16evU1iwpV/qLQu280H3loQDGcd4Dg
	 2SowXfvuz5TlB+ajRsKVBz/uegLXUoxizazcxCCnwQmnIRPXF8zL7wp/coJFCKvz3kLXw
	 +qllIevbEEVrBDAh9VIgGe6oF9FAWbYB8u5Uc9MEQ2LudTI2Li9vP6Jo2fJmq+sw1p9Wd
	 WjWGeQscYahUZFUl1FSOLz6zpr1LOsPiuOcl7R/oPbLEFS2JGJQ7aVQ4xIz4lJauaxZjP
	 HUlFVXlB/29rIY2XZuaCMH/TzeMZWDTuyxN//iLtOnNmJaxDxpLyrvcZ4s6LwD8TGlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dmzoHkR5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77ABC606A331;
	Wed, 18 Nov 2026 15:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dmzoHkR5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6631F000C4;
	Wed, 18 Nov 2026 15:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015257;
	bh=gFwDhzqdCVSK2b0C761xGEU3uxdGuGvB1vYVod8zXXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dmzoHkR5QuarhlHSqKb/1S3obF3kKhL7coOrgU937EuV2LRYXbjqyr9tA18p/Namg
	 vk26BqYrPJGwDIJmN+j164Ci3NNwkwCAYepTrICXNX2N1I2B4T02z10RXckfpwXCem
	 TYtoPjNFWh4iENvb23oCtVseTZiIn6pkhKjCsXqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0108/2651] perf jitdump: Validate code_size against total_size in code load
Date: Wed, 18 Nov 2026 15:22:28 +0100
Message-ID: <20261118150251.772309112@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index dcb26d9c6c8fc..14bd23c8d1963 100644
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
@@ -452,6 +453,16 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
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



