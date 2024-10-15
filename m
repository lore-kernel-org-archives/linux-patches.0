Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262151CFEA9;
	Tue, 15 Oct 2024 11:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992881; cv=none; b=rpZEEcoWHGB+MlbyzCnKRg1Qtem/e1GdgwHCQZsuyVzwD0UA6kqwzWfiCXU/sb6TSmeJyL1LupuPprChc68z4GfEyghm8zl57k0voDpIt/pK0J+Bo/LSMkMK5kci7WhD0KncJypje72X47CXngco9cXk3unVG9fP5dlgpY8zGhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992881; c=relaxed/simple;
	bh=34YdgWGAkb09MRHlEWyH+yhUI7+4H7MWeznjwgN0TiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tk7HDHMR4gN/1Xmp/eodVAWplRAYXuWbRddEvB/tFdADHIThSe52tiSo9++HIrWTVL1MTndFEjrh3mswQPEKZAFf2Yn08R6BlpRyitcqEDSRlcIlmE90njgppMS0QmiSUnIIAm/Zw4kMxta1oP7bW54IsClvNcXXofF7jN5NKDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YIw64TI0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YIw64TI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F7BC4CEC6;
	Tue, 15 Oct 2024 11:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992881;
	bh=34YdgWGAkb09MRHlEWyH+yhUI7+4H7MWeznjwgN0TiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YIw64TI0LmOdnyU2PiLP7ZP2p/vfvA1vSA9sGvsJCVIp3ioIMevItK29fdjq0E5rd
	 ti83DzmYjqueLmyWMzpU+7MaZUAjEeVIQiDXg9PkePzvQdqXeoNdT8IBwW9jOAMTDB
	 1sM9gN4WPs0Th+vAVxryeYQEh5R12LfT0MSPEY3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Jiri Olsa <jolsa@redhat.com>,
	Athira Jajeev <atrajeev@linux.vnet.ibm.com>,
	Kajol Jain <kjain@linux.ibm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Michael Ellerman <michael@ellerman.id.au>,
	Namhyung Kim <namhyung@kernel.org>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 215/691] perf test sample-parsing: Add endian test for struct branch_flags
Date: Tue, 15 Oct 2024 13:22:43 +0200
Message-ID: <20241015112448.890763174@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Madhavan Srinivasan <maddy@linux.ibm.com>

[ Upstream commit 10269a2ca2b08cbdda9232771e59ba901b87a074 ]

Extend the sample-parsing test to include a branch_flag bitfield-endian
swap test.

This patch adds a include for "util/trace-event.h" in the sample-parsing
test for importing tep_is_bigendian() and extends samples_same() to
include "needs_swap" to detect/enable check for bitfield-endian swap.

Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20211028113714.600549-2-maddy@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 79bcd34e0f3d ("perf inject: Fix leader sampling inserting additional samples")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/sample-parsing.c | 43 +++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 5 deletions(-)

diff --git a/tools/perf/tests/sample-parsing.c b/tools/perf/tests/sample-parsing.c
index 8fd8a4ef97da1..c83a115141291 100644
--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -13,6 +13,7 @@
 #include "evsel.h"
 #include "debug.h"
 #include "util/synthetic-events.h"
+#include "util/trace-event.h"
 
 #include "tests.h"
 
@@ -30,9 +31,18 @@
 	}						\
 } while (0)
 
+/*
+ * Hardcode the expected values for branch_entry flags.
+ * These are based on the input value (213) specified
+ * in branch_stack variable.
+ */
+#define BS_EXPECTED_BE	0xa00d000000000000
+#define BS_EXPECTED_LE	0xd5000000
+#define FLAG(s)	s->branch_stack->entries[i].flags
+
 static bool samples_same(const struct perf_sample *s1,
 			 const struct perf_sample *s2,
-			 u64 type, u64 read_format)
+			 u64 type, u64 read_format, bool needs_swap)
 {
 	size_t i;
 
@@ -100,8 +110,14 @@ static bool samples_same(const struct perf_sample *s1,
 	if (type & PERF_SAMPLE_BRANCH_STACK) {
 		COMP(branch_stack->nr);
 		COMP(branch_stack->hw_idx);
-		for (i = 0; i < s1->branch_stack->nr; i++)
-			MCOMP(branch_stack->entries[i]);
+		for (i = 0; i < s1->branch_stack->nr; i++) {
+			if (needs_swap)
+				return ((tep_is_bigendian()) ?
+					(FLAG(s2).value == BS_EXPECTED_BE) :
+					(FLAG(s2).value == BS_EXPECTED_LE));
+			else
+				MCOMP(branch_stack->entries[i]);
+		}
 	}
 
 	if (type & PERF_SAMPLE_REGS_USER) {
@@ -248,7 +264,7 @@ static int do_test(u64 sample_type, u64 sample_regs, u64 read_format)
 		},
 	};
 	struct sample_read_value values[] = {{1, 5}, {9, 3}, {2, 7}, {6, 4},};
-	struct perf_sample sample_out;
+	struct perf_sample sample_out, sample_out_endian;
 	size_t i, sz, bufsz;
 	int err, ret = -1;
 
@@ -313,12 +329,29 @@ static int do_test(u64 sample_type, u64 sample_regs, u64 read_format)
 		goto out_free;
 	}
 
-	if (!samples_same(&sample, &sample_out, sample_type, read_format)) {
+	if (!samples_same(&sample, &sample_out, sample_type, read_format, evsel.needs_swap)) {
 		pr_debug("parsing failed for sample_type %#"PRIx64"\n",
 			 sample_type);
 		goto out_free;
 	}
 
+	if (sample_type == PERF_SAMPLE_BRANCH_STACK) {
+		evsel.needs_swap = true;
+		evsel.sample_size = __evsel__sample_size(sample_type);
+		err = evsel__parse_sample(&evsel, event, &sample_out_endian);
+		if (err) {
+			pr_debug("%s failed for sample_type %#"PRIx64", error %d\n",
+				 "evsel__parse_sample", sample_type, err);
+			goto out_free;
+		}
+
+		if (!samples_same(&sample, &sample_out_endian, sample_type, read_format, evsel.needs_swap)) {
+			pr_debug("parsing failed for sample_type %#"PRIx64"\n",
+				 sample_type);
+			goto out_free;
+		}
+	}
+
 	ret = 0;
 out_free:
 	free(event);
-- 
2.43.0



