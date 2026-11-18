Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023129;
	b=XlQNKbe0CeAPyvdJGcmD8Tj72VX+WgCUAva3ivIfs3upPu9TwUpgy2hJ/RLQFEzYcX0D
	 J33YfUrcOo+w/7UphMHw2uYTDLZC9wPY5T34Mw6zxeHyjlbJ3rZO6V2VktJF/+a+ClfIW
	 oP2OlGABii0ftIsOskhwBh/0+37XbnjSQNyZ3R1nVOQZL+fyq7LjHnDeyV01f9MexV3G/
	 b/VZSlfUh0de+BlAW4RrN0+1HRB9Ag7TewVaXaA/lIWjK2t8dxwj28tCYUhmHhxFC42nl
	 vpl5UekWkvV8Pk8fiqfGqKeFxtV7j7D9zenEZeeyPBpotY8gyhFjTAD6YQbdUMoEyAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023129;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PLjLGdmEJwxpC1mtVswkJslbJFAnLBUi61uv02rO88I=;
	b=oVe+M6oVWto6M8K4BEWCLAPgt+OYGk9/D7s5AI6Qx4MYwcjMdZgIIPfLWsFwj8hyKsC0
	 RiVVkOd9CCQJ7dEKPArmpqaASUzsSR92CI3Lz74Lc0KS43y/X5d/6sz1uwrXHpodBP2lS
	 hm483cIRaS5WhruOPiLQA4Oj0mo0SNIJrH8HI1D4ZQIfjG5qFrcr7SMJg0TEFQTCdHL9o
	 b+p9BEUsWzcSFzLthIYSGclCwJS1Vdt7PWALcgIlMsGZcE+nIraF0ygp5xWVFM4aVLGyq
	 qEs1zznE25kx5PGvy115JIG+BIB6PIL4bSea6SXjh0HHKXs+QUBTCl1UukvBzwkL8wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1u18T1gr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CE5606A33E;
	Wed, 18 Nov 2026 17:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1u18T1gr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B40A1F000C6;
	Wed, 18 Nov 2026 17:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023129;
	bh=PLjLGdmEJwxpC1mtVswkJslbJFAnLBUi61uv02rO88I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1u18T1grhBN38pEHtcyKLQSot10YuxZqTFDTVUSqpePr0016+YKqhNoz0gGpBGmbH
	 wwSGBOO3UnJYHdq2ZxGu3mPqVkLzRl+cU0XCFvaRGtUaeQoUp3uW07vvFbeCj89f5p
	 gxhvD2flHFljBxcs47kBI+Cx8nostvzpMckQc2Xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Mark Amirkan <markdamirkan@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0259/2151] perf evsel: Validate branch stack before byte swapping
Date: Wed, 18 Nov 2026 15:33:14 +0100
Message-ID: <20261118150131.220083311@linuxfoundation.org>
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

From: Mark Amirkan <markdamirkan@gmail.com>

[ Upstream commit 2148e094671b0f6a44f033787b7da4ed14e96c27 ]

When perf reads an opposite-endian branch stack, __evsel__parse_sample()
swaps each entry before checking whether all entries fit in the event. A
truncated sample can therefore make the swap loop read and write past the
event boundary.

A truncated perf.data file makes perf report crash with SIGSEGV. ASan
reports an out-of-bounds read. A regression test puts an entry just past
the declared end and shows that its flags are changed before the parser
returns -EFAULT.

Move the bounds check before the byte-swap loop. Valid samples are handled
as before.

Fixes: 63c12ae2f246dcdc ("perf evsel: Add bitfield_swap() to handle branch_stack endian issue")
Reviewed-by: Ian Rogers <irogers@google.com>
Assisted-by: Symbolic
Signed-off-by: Mark Amirkan <markdamirkan@gmail.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/sample-parsing.c | 48 +++++++++++++++++++++++++++++++
 tools/perf/util/evsel.c           |  3 +-
 2 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/sample-parsing.c b/tools/perf/tests/sample-parsing.c
index a7327c942ca20..09853246efc38 100644
--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <stdbool.h>
+#include <errno.h>
 #include <inttypes.h>
 #include <stdlib.h>
 #include <string.h>
@@ -384,6 +385,49 @@ static int do_test(u64 sample_type, u64 sample_regs, u64 read_format)
 	return ret;
 }
 
+static int test_truncated_branch_stack(void)
+{
+	struct perf_event_attr attr = {
+		.sample_type = PERF_SAMPLE_BRANCH_STACK,
+	};
+	struct {
+		struct perf_event_header header;
+		u64 nr;
+		struct branch_entry entry;
+	} input = {
+		.header = {
+			.type = PERF_RECORD_SAMPLE,
+			.size = sizeof(input.header) + sizeof(input.nr),
+		},
+		.nr = 1,
+	};
+	struct perf_sample sample;
+	struct evsel *evsel;
+	u64 flags = 1;
+	int err;
+
+	input.entry.flags.value = flags;
+	evsel = evsel__new(&attr);
+	if (!evsel)
+		return -1;
+
+	evsel->sample_size = __evsel__sample_size(attr.sample_type);
+	err = __evsel__parse_sample(evsel, (union perf_event *)&input,
+				    &sample, /*needs_swap=*/true);
+	perf_sample__exit(&sample);
+	evsel__put(evsel);
+
+	if (err != -EFAULT) {
+		pr_debug("truncated branch stack returned %d, expected -EFAULT\n", err);
+		return -1;
+	}
+	if (input.entry.flags.value != flags) {
+		pr_debug("truncated branch stack modified data past the event\n");
+		return -1;
+	}
+	return 0;
+}
+
 /**
  * test__sample_parsing - test sample parsing.
  *
@@ -400,6 +444,10 @@ static int test__sample_parsing(struct test_suite *test __maybe_unused, int subt
 	size_t i;
 	int err;
 
+	err = test_truncated_branch_stack();
+	if (err)
+		return err;
+
 	/*
 	 * Fail the test if it has not been updated when new sample format bits
 	 * were added.  Please actually update the test rather than just change
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 654e9bbd66f98..3a96f174fcc2a 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -3291,6 +3291,8 @@ int evsel__parse_sample(struct evsel *evsel, union perf_event *event,
 			e = (struct branch_entry *)&data->branch_stack->hw_idx;
 		}
 
+		OVERFLOW_CHECK(array, sz, max_size);
+
 		if (swapped) {
 			/*
 			 * struct branch_flag does not have endian
@@ -3306,7 +3308,6 @@ int evsel__parse_sample(struct evsel *evsel, union perf_event *event,
 				e->flags.value = evsel__bitfield_swap_branch_flags(e->flags.value);
 		}
 
-		OVERFLOW_CHECK(array, sz, max_size);
 		array = (void *)array + sz;
 
 		if (evsel__has_branch_counters(evsel)) {
-- 
2.53.0



