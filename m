Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054773;
	b=RORlhJNt7xfM3BN//P9AETfcYYNrGScuzWZfaerxRvdD/vCpWd3kiNkGOLaZVYIFKSAu
	 9QMThLKf8hiV8Y0PC54Vy5khIVgBAn8T8OZDC9xsAqwXwEclXXL+iMQ2+tipcLIxmLZ9k
	 4TCyUDcEuVh0ThGito+yzBGX5nxF7cN3pzGg6zGqYhdH4+Amb8rjOkbv0z1fl5n2ER4Qw
	 4HSocIJhXMF/deOJNWr2LrhycP2UEuIBxPRxHedYs2XGvXc62F+JVDqRBhIDsGU66tbhz
	 xH+EFxA/sIiQtKw+LFdnE/rZdLRE3nPpeEB0Ba6/AzNe7AfxSq+Y3mkX/Dno6YfUsxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054773;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4UbrTMET0lF1f2z6RxxgGgRMBEZsOtGgDGWfcgbj5Eo=;
	b=EoKBIna67YpwvxpTATm3kZhrfA7paLCfZIS+HHBWqkYjyI1c6lRBl9Mz439i1KHkdJkE
	 W71q6f57UbZIqIGoj41Nc+bJuMP3MGR7ZMcfIgijGJldrvqrjeEM2ZZPeqklPcqnM8cuC
	 0cAQj6DIHblcn66/kCmrQFxRrhUBlcvoMUpepQNpaKLXGJC3PVTf9vcpkFESDHH0SXmkW
	 XX+UVk9Y/nW95WZ5df4xAiuTCmUljMEhtKhkW8QaTfKknQFjiGOgGt+DqNx+DjLcuBt/j
	 z8ZZgMuhizzaysJUvfjb7V70qvG3otXiRdSJHW0NW0vfCIROoQbVvTq4QvuKW5MgMFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tMPIFeaJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6141606A32C;
	Thu, 19 Nov 2026 02:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tMPIFeaJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090531F000C5;
	Thu, 19 Nov 2026 02:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054773;
	bh=4UbrTMET0lF1f2z6RxxgGgRMBEZsOtGgDGWfcgbj5Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tMPIFeaJucFuj4qu/8hC/PgSZ1xvWZWAxYz2Rj9tLH6+DSe8rtL9x3lO+CykWNfhO
	 HQoO7oCdqgsnc2TaVl5MWf55fBCJxQRvKvU75FxjpPliBtSr8quBhmtyPfnnhQlKM/
	 wUSEchFn9wg/agNJEXNVoP28ESZmf0XjRqz/e0b0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Mark Amirkan <markdamirkan@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1394/2214] perf evsel: Validate branch stack before byte swapping
Date: Wed, 18 Nov 2026 15:51:10 +0100
Message-ID: <20261118150107.071491534@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 02f6847e1822 ("perf evsel: Validate RAW sample before byte swapping")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/sample-parsing.c | 48 +++++++++++++++++++++++++++++++
 tools/perf/util/evsel.c           |  3 +-
 2 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/sample-parsing.c b/tools/perf/tests/sample-parsing.c
index 8fd8a4ef97da1..b2c408b8b7820 100644
--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <stdbool.h>
+#include <errno.h>
 #include <inttypes.h>
 #include <stdlib.h>
 #include <string.h>
@@ -327,6 +328,49 @@ static int do_test(u64 sample_type, u64 sample_regs, u64 read_format)
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
@@ -343,6 +387,10 @@ int test__sample_parsing(struct test *test __maybe_unused, int subtest __maybe_u
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
index 3c9637a991971..365effb524b32 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2497,6 +2497,8 @@ int evsel__parse_sample(struct evsel *evsel, union perf_event *event,
 			e = (struct branch_entry *)&data->branch_stack->hw_idx;
 		}
 
+		OVERFLOW_CHECK(array, sz, max_size);
+
 		if (swapped) {
 			/*
 			 * struct branch_flag does not have endian
@@ -2512,7 +2514,6 @@ int evsel__parse_sample(struct evsel *evsel, union perf_event *event,
 				e->flags.value = evsel__bitfield_swap_branch_flags(e->flags.value);
 		}
 
-		OVERFLOW_CHECK(array, sz, max_size);
 		array = (void *)array + sz;
 	}
 
-- 
2.53.0



