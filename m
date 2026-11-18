Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039175;
	b=BxDqW3uKtxHe1TKftTCCINNSFs3uugC6wa25OHMC88ejGF3AD7X3lR1371vzpPq/9eox
	 TnMclTfJB9U0J0t6ObxiNoolXGhUKoIjVkCP8UKjnociV2Q3WPJbw2kxv2XQ0DyXg6q2t
	 uYP/Qtn7zqTeU6hqwDz752l4RjpRX6JU+mkWJSbbMe69kpoyZPZ8Vc7+N8Xe7d7rsqb0J
	 aU9c8VlT+n7n1h2oOcaiemB3yZqbj53rqhZqLca1EClvmagzNU95dxxkLPbmH+ZZM/Rlm
	 KdLS4i+w6jG6Lg+DDnDGkOhmmha76XN61NPfcZhB2NUYsvyVrpKxbejHZrz+TwEaXqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yEXRCG9OQZFL7Em2fgskH/vXybtsKb7+Kq5J474S6Ps=;
	b=PBQ/erDEm+wayZv4BYoz0EyOWZnZ5Nk//uf/MDI7yNK5AwLl8lEh7BetlP4evvEWZc2m
	 CR/4ZsiirCy6YCgWMtUSD28hKhHhzrnK1QuZsj8XnD9Xqx4ZEc+NCIOpwkgJWCFi8Ov7A
	 E6VM5xg7FpJwMqmzvIfhSuxl4aSWX1dk+PwEnKfBuzK6vpEQhB2CvAA5xitXLKtotUSqI
	 yF7SYPo64QFOWmG3VSSypuPccM9TCwoTm9nyCs8TNrlhpcwa4QUdz8GrOiPThGV3aZvqj
	 5wX7tDjzu2KivnAxsiiZe9b9svi/gIK8r2kM6JqfrOeYXPfmml1U84F6pZNyuEkUmCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vlCEqhpw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681A2606A31C;
	Wed, 18 Nov 2026 21:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vlCEqhpw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8EF01F000CA;
	Wed, 18 Nov 2026 21:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039175;
	bh=yEXRCG9OQZFL7Em2fgskH/vXybtsKb7+Kq5J474S6Ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vlCEqhpw9jR0GRVlMvBOwg3wLgRu8TznGWPwLHwmc4mPAx0qCGpqZT9P8ApHQcpWY
	 MlNiYT+jC0etPFwJUYP44xtRcn3Ak0UXT0TulZaRpmD1wDaNrVqDF4wp0pY1NnbdZZ
	 ARUQu0VOEAtluT0L+qDeIuq9IdLwKWOQ96GNlyDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2004/3318] perf jitdump: Validate code_size against total_size in code load
Date: Wed, 18 Nov 2026 15:43:46 +0100
Message-ID: <20261118150422.170145256@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a6bb6aa00c7bd..ed306582388fa 100644
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
@@ -450,6 +451,16 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
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



