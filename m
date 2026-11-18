Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047910;
	b=ETCC8koXYR5RcWQ1XHPt1NmH8a2KOvGKN5gJDO8WHF1zKUUovxs8tJCFf/duSjT/eciw
	 HE+FwwgIY7tQXlw7fPH+arf8q6toe76wYYFPMRv8L9AF/Hdtmutji87ZamZ+3OxBjduhV
	 4h0UXHSFff+VNRB2sltcx6jg/5kuYLVi9WRI8d6seFcrf6ZS8Dw6/BxKqyi/9coencu7u
	 GQX6CmQM9DlOCNauwPTRIKSfqEOR5JAYxJKPAPivi6dUVuc4VHlS+taNIV0qFsvXtCUg5
	 KFXStwUwuOYj3k8ugaksHoFmMTRU4WMGpRdGFZWUxUiGzn/CcLr2WlNbn1ngDZLsskQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CkrHAWwhNxzupnA1tCETIyr+Y7Tj/uTfTGFwNlfHvEk=;
	b=rS+wxPMXwuODDTQeLxTc2zeXx+NtHEsCjeBQv78aobR7n1azR2lQi7gdpS4pvZTn63Ic
	 n/48I1kQ4VVTilYXV2OY/82FdxISlTDKWS7+MAe1RPFB7OzHT/lFMtLrPL/8cjTIZ3bXz
	 RRR/iu2Cdaic/RP3eTA3KiTh21QS7lOlFwnCyTeip9hDam1qyJgSH1QyKW4uZfV0+17tY
	 B4R8wCWDWX3Tvhcz2enMUH2s7+rCA+NMCJ19p5ZwrD58Fgj0aaNXaEbghzDcrx2XbduW6
	 16w/GO2Pvs/U0fQb+j60BStdke2/HKUNOeJ/3kUh4zw7bynlwWN75a1HV+34piv1ehw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aaRDvNNd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F063A606A325;
	Thu, 19 Nov 2026 00:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aaRDvNNd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E01E1F000C4;
	Thu, 19 Nov 2026 00:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047909;
	bh=CkrHAWwhNxzupnA1tCETIyr+Y7Tj/uTfTGFwNlfHvEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aaRDvNNd7QkzmW7K0BfoEogAJ45NFzygIza+ktwcVitmgH1dzO5ME/yBTerdeMWZe
	 022mUfSDdLomI9BXEAglmrrng5Xa8kTtQjMuLKh23sHCEUoCGe+WET3TlXUGnaH2nt
	 0hjN1gD/T4cr0KjUdxUuxgXJnMRDb/uPdn7WE8CI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Mark Amirkan <markdamirkan@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1806/2857] perf evsel: Validate branch stack before byte swapping
Date: Wed, 18 Nov 2026 15:47:20 +0100
Message-ID: <20261118150306.276296444@linuxfoundation.org>
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
index 20930dd48ee03..f2b59a3808e6c 100644
--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <stdbool.h>
+#include <errno.h>
 #include <inttypes.h>
 #include <stdlib.h>
 #include <string.h>
@@ -366,6 +367,49 @@ static int do_test(u64 sample_type, u64 sample_regs, u64 read_format)
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
@@ -382,6 +426,10 @@ static int test__sample_parsing(struct test_suite *test __maybe_unused, int subt
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
index 755da242f2670..332afd353d7d8 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2579,6 +2579,8 @@ int evsel__parse_sample(struct evsel *evsel, union perf_event *event,
 			e = (struct branch_entry *)&data->branch_stack->hw_idx;
 		}
 
+		OVERFLOW_CHECK(array, sz, max_size);
+
 		if (swapped) {
 			/*
 			 * struct branch_flag does not have endian
@@ -2594,7 +2596,6 @@ int evsel__parse_sample(struct evsel *evsel, union perf_event *event,
 				e->flags.value = evsel__bitfield_swap_branch_flags(e->flags.value);
 		}
 
-		OVERFLOW_CHECK(array, sz, max_size);
 		array = (void *)array + sz;
 	}
 
-- 
2.53.0



