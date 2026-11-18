Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060261;
	b=p064yA08tAuYsiV9IR2uLxLb+rJ2jkrQ/IO9Wsr/EqLZTmWMPdTvIPtPedx2cdyDNbXT
	 XDB5R3keWm9Lved34ir840QKzwbcYjSn/lHmzojluE6OsAIa0N/p83sFxGfoZvNKxA5U7
	 zG2abSgjB3NFc2NqsdKTxpllKGRMG6cVeuwMCXT9g0GjFIjrLXfPxYvJA0+mIPDEYPa65
	 8oU8lv2DdouKRP0dQr9FXjsScOTwe6+UAEQVQb7eHrRo1Oao4D9p24/6sWAM0OKB/36Py
	 ZbzYz7L7282EbnIA+7uG2kcmwBdBnQE83KCp/LXgu0KBbfyXkFVZ1pA+RexeNAOtW8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nZVrJrq/3bvtYzDxm+2U2ZFPZJbAIIa5km0XAfDouYM=;
	b=ufnp/+3G0BMzPUx8CzM8Qv76a0rJtp6RDUFmMO7ic8up6xkzFH5wyEuvGW106bjfElBT
	 Muz5uWdZbCNy/uqe8PZoTKALmZ5AkIqpw00gAz6o33nsWPPBnMe1C2Y+HpdhtQ85VD5c+
	 YogZBzeVA9xuttEjKiOsxI1Ov//u35VyyJK2MEhbNqoJWdq2PLrAZ4hn+sBlb3/CAG0/t
	 kZ/kjDT2cj0J4Hp/0pd2RqSLtaAmAxqpFJV/2knQmv7JUrI1KnAniLsqmhH5Cff4bbzN6
	 gP+sRiA/M2NiGJZj3YvmaZxZpQ7ZazORjihDeua2egcWzqTcVCq+zktgwI3L7q88bYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="J/8rThlO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5C9606A320;
	Thu, 19 Nov 2026 03:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J/8rThlO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AE01F000C4;
	Thu, 19 Nov 2026 03:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060261;
	bh=nZVrJrq/3bvtYzDxm+2U2ZFPZJbAIIa5km0XAfDouYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J/8rThlOmckrmawLYk7ZmUNS2fZ2VcGtSmfAlKyt1vnVQMA9Q9GcqbvrDlt/ieFSC
	 qZxNPRaN5w+Ul9gGzxFpFkab+t7zOCq+jFManhuVk55addENyEMxpVfaHBYaAv2moZ
	 /j4BDPhGSj6TK72DEty3NzLj/477sJuy/nl0YDJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1135/1848] perf jitdump: Validate code_size against total_size in code load
Date: Wed, 18 Nov 2026 15:52:53 +0100
Message-ID: <20261118150007.070400715@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0ca3024622a6a..f11499e3a1989 100644
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
@@ -427,6 +428,16 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
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



