Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022853;
	b=MCmiaezvI9e47qam++WZzt7fcg5RIuR/KHTzCjKJKaiMsF1MQeALeE2+YyyF2XyMNb5C
	 SIXXwZAH922Fzm/2vRdvGaZF0AXZGDEQCwtBpwpQc/COEcjbQSbrYGD2I6uwf5Rs108bX
	 pB6r3cdv1XuAdZad0bXI04kDLh1FZT0QA4VPN7e8DIim3f2xio/bBAPe8GIifuiuJP9GL
	 zzrKq9v4f+vv7BQB1joAEu6EWCxSU0IdMgPiw1Ux54t3RhIBEE1T43EYMCCgIxSCX9h8A
	 qlNksNkkxjkG8/9LKMcBdc0f6mTH0qkMZrN/9d2qXRNY7tnJggBVzVLGx5nlmNat2Gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bbeA16nV4SKGQURg6uZwd7JbcwRKNvNkI4w1YVH9dqs=;
	b=Xw8+XLay8x4U/2xefxntZpe8bVWhjjE5QZTFBw0fTZmV1ttg/0/g+ttkmqSx0vu9yWUs
	 0pq1d4iGJ2gLGzx9V1YLp/8aNm+Po+V7r4/wD+r0nefTfT+YPvxZOtpz5NGlwP8iGqgx9
	 1p9qfUxdk81iS4u5PDi17emtcy3G/Yw0s+bC5KdaVHfmP65WG9Yl9qb8NeggfkOU1T6gF
	 GkbrThBWqSW/rHusjOPicwyn8Olc2w82Kox1TyJW2cCoWoOzK5dyZNIvOZaWhHmmrwhnb
	 DOAPWjLeuKPw1tjBBah7m+TnxYbtUYxfK1ffFRsyFsB2P8ERX+xtjjPOZ3NDGG1GRCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="K/uBBapn";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B664606B3E2;
	Wed, 18 Nov 2026 17:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K/uBBapn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1A71F000C6;
	Wed, 18 Nov 2026 17:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022853;
	bh=bbeA16nV4SKGQURg6uZwd7JbcwRKNvNkI4w1YVH9dqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K/uBBapnvsPl9GZj5XsAvLNqVAF6Gp0vzse6vKQ84+LXLQiYVNLGTR2AH/APjOrso
	 T5DaININKEIYua8TsH8YwEGa4rg+A5+emy13RDozpjCGubh2dVAUOfy2LSDWJUjEMX
	 zNjlduHfeAX8sWXT/Od/I5NxwzV2AWXWVtRA+31Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0161/2151] perf jitdump: Validate code_size against total_size in code load
Date: Wed, 18 Nov 2026 15:31:36 +0100
Message-ID: <20261118150127.611571620@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ed489d22c2fd9..dedbfec2ecf1f 100644
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
@@ -451,6 +452,16 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
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



