Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029151;
	b=ysWmwR/UigpMJvUtFd5XtLa2Esd4gpcsP0io7jrpd+pEwUMoooYovAF3Oe76HyK4uRR+
	 QygDk+vnYnjYAIZ9y4+AhfrxFT30lWOH9hzEcBrIqC8iA4o8Csx75w/JNLtgE6FqBnlGA
	 NHWiyXNiVGRX90QAREW3Mbgom/7TugWNhR29OsGkl5E6MqEHGKasR+9HOS02cTdpDK9RR
	 uNXifYNaFpU+RwAG6TYIMWjcCgyOiC5ScK8IWzoF4EaG64c5qbIDi4HtYKdbXltDzl8hz
	 R1YBAIEzDlFgJjsUrauHyPuSxemQvhyhpk9uic5z9fI6psuSU/WUFZpzKODnIEJcvug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029151;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fqrfNL9eDEZmcWcL9KnJU3eNKEo4GRn9hCr+8qSOjfY=;
	b=0iz5GUaCf9ns/LxJHLWwTmxggPC/PwdP43VGz8JqnMyZMuIUByxRIym++BNE4nHfr3HR
	 p7FCVucFPgLASS8MlsWVfN95z5jSw2RUc1Bit7Zk+Wu0MOteVPEZX1zjDDN0JImqeM679
	 GB3fG54+ETEojtxPF5AqnNJ12RZvhwx+KfgkIwhcrp29tK/PIoLo4KXaPhIt5M8N85IXc
	 /yujkax3uDdTXIChnzkQAg7xSFikYxUU/tGJf2t5xIG4DSVbS1095TYtpf9fUnGpIDCy7
	 fsHVRhrjZaHGLXtGJJe2XWmary8vS+I6oWr18V9Eid+Uiq23wB5yArzyhecV5HInZSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ocVwzM3S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5E2606A32F;
	Wed, 18 Nov 2026 19:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ocVwzM3S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEFE1F000C4;
	Wed, 18 Nov 2026 19:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029151;
	bh=fqrfNL9eDEZmcWcL9KnJU3eNKEo4GRn9hCr+8qSOjfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ocVwzM3Sb0Abk+1tb/P8YOF0UsirCkseNAR4LEar3MxF6ZN8rpiGGb9Ttcm5lXx8I
	 ZcP5ToBL8FL/l7osGaPMCq150HUFlYaV444thxz8V2fkloxrWw1RZGYcGmlYH6dunT
	 FBFXvgVz4+7X4INZQkXTgti+FLxw1JFY2omxO5hU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Mark Amirkan <markdamirkan@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0247/1756] perf evsel: Validate branch stack before byte swapping
Date: Wed, 18 Nov 2026 15:39:34 +0100
Message-ID: <20261118150018.227775185@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 72411580f8698..5af2c1a0c376f 100644
--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <stdbool.h>
+#include <errno.h>
 #include <inttypes.h>
 #include <stdlib.h>
 #include <string.h>
@@ -376,6 +377,49 @@ static int do_test(u64 sample_type, u64 sample_regs, u64 read_format)
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
@@ -392,6 +436,10 @@ static int test__sample_parsing(struct test_suite *test __maybe_unused, int subt
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
index e84dacb5627b6..ab808f0754055 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2898,6 +2898,8 @@ int evsel__parse_sample(struct evsel *evsel, union perf_event *event,
 			e = (struct branch_entry *)&data->branch_stack->hw_idx;
 		}
 
+		OVERFLOW_CHECK(array, sz, max_size);
+
 		if (swapped) {
 			/*
 			 * struct branch_flag does not have endian
@@ -2913,7 +2915,6 @@ int evsel__parse_sample(struct evsel *evsel, union perf_event *event,
 				e->flags.value = evsel__bitfield_swap_branch_flags(e->flags.value);
 		}
 
-		OVERFLOW_CHECK(array, sz, max_size);
 		array = (void *)array + sz;
 
 		if (evsel__has_branch_counters(evsel)) {
-- 
2.53.0



