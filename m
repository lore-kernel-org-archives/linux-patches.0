Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029153;
	b=CnQXy//GETHc0vT0oDg19KO1Xvpzt2Y6YrZeUL9xN+xPbJ+6o7CaxBMzd38i5YM5Y2i5
	 o4FJNGHdzxQpgTVfFYfINctEgnz1RVOtYN3Ln/TiYvVJXZLXDfZj0Q1qWrukeaSLRzUrG
	 WexjgWKwpNpbDcdYwi8dGV/tpcSYSCyxqACRvdBU9kqgVHTTlr+sPigQ+EiXK6EkcUd46
	 FafDbI4NmlS4RlJPRwsf8tZM0ChKkbggFuBIXXzzNR62aC6hZ46UtLxfVYnVqUGsoVRgy
	 q+F790pBxo0Ebp8JTh8v4eLPhMuI9LxVg65ZZAo2YUnv1+ZMZSwL0DtS2Jwpfz8/RKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029153;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8vRpFZcFD5gepo48Sf5zCA8TqgGuTaHbNtTnwdaF+xU=;
	b=rlEEGrlbIvYTvOFCbcvGhfUfTZaD+c1owojpqWyONNMWyTJXzQsaZpc481+f40efUHI+
	 IqRCNXB92ep9YOKootMe/NqW9m/8xUlSSv4MhC1Uu+Ag5yuVpmDL77QTyXbhksq54P35Q
	 D6q0u1+3E1YyKR6VZIiwC6ZP/PZdhLoZsWMm7M1o26ZEHeOGhi+CUpwJ6E1dMnyJcy1lf
	 ffqqc3M8JhD3vaDa763egLAsiGnteAGRcNF7YhlVQ+a9TMdcesr4YjWF04ErWviqDETPl
	 CD1DmD7spe3hUZk8fQTwI9XhH8trDhmW79PllmloDvqevXxoZ/9TbaEkl41rhUGNxfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ee6AFAb0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D175660A2600;
	Wed, 18 Nov 2026 19:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ee6AFAb0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A671F000C6;
	Wed, 18 Nov 2026 19:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029153;
	bh=8vRpFZcFD5gepo48Sf5zCA8TqgGuTaHbNtTnwdaF+xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ee6AFAb00LaNwHWuTaVehH6b2BIK2ueUaaNVVk3ETeIPIU09/9htnj2+RF9tq5pOu
	 Pe+x932CEVX6QjXp5W/oV7PaWRW2R8dT+XqGBn4x80vsuhXjo2JJEjCJKPH/M92tlf
	 WMpxjwTXCjZ/ZQsBeUQ74pKeQoXb9v4HOaYyFlzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Mark Amirkan <markdamirkan@gmail.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0248/1756] perf evsel: Validate RAW sample before byte swapping
Date: Wed, 18 Nov 2026 15:39:35 +0100
Message-ID: <20261118150018.261910633@linuxfoundation.org>
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

[ Upstream commit 02f6847e1822714a4201b87e42f92b0d43e8549d ]

For an opposite-endian RAW sample, __evsel__parse_sample() passes the
input-controlled size to mem_bswap_64() before checking whether the
payload fits in the event. A truncated record can therefore make the helper
read and write past the event boundary.

A crafted perf.data file makes perf report crash with SIGSEGV. ASan
reports the out-of-bounds access. A regression test puts backed data past
the declared end and shows that it is changed before the parser returns
-EFAULT.

Move the bounds checks before mem_bswap_64(). Check the rounded length too,
because the helper accesses complete 64-bit words. Complete records are
handled as before.

Fixes: f9d8adb345d7adbb ("perf evsel: Fix swap for samples with raw data")
Reviewed-by: Ian Rogers <irogers@google.com>
Assisted-by: Symbolic
Signed-off-by: Mark Amirkan <markdamirkan@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/sample-parsing.c | 61 +++++++++++++++++++++++++++++++
 tools/perf/util/evsel.c           | 17 +++++----
 2 files changed, 70 insertions(+), 8 deletions(-)

diff --git a/tools/perf/tests/sample-parsing.c b/tools/perf/tests/sample-parsing.c
index 5af2c1a0c376f..0602c4be32975 100644
--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -420,6 +420,55 @@ static int test_truncated_branch_stack(void)
 	return 0;
 }
 
+static int test_truncated_swapped_raw(u16 event_size, u32 raw_size)
+{
+	struct perf_event_attr attr = {
+		.sample_type = PERF_SAMPLE_RAW,
+	};
+	struct {
+		struct perf_event_header header;
+		union {
+			u64 value;
+			u32 words[2];
+		} raw;
+		u64 canary;
+	} input = {
+		.header = {
+			.type = PERF_RECORD_SAMPLE,
+			.size = event_size,
+		},
+		/* Parsing a pre-swapped word exchanges these two u32 values. */
+		.raw.words = { 0x12345678, raw_size },
+		.canary = 0x8877665544332211ULL,
+	};
+	struct perf_sample sample;
+	struct evsel *evsel;
+	u64 raw = input.raw.value;
+	u64 canary = input.canary;
+	int err;
+
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
+		pr_debug("truncated swapped RAW sample (size %u, raw %u) returned %d, expected -EFAULT\n",
+			 event_size, raw_size, err);
+		return -1;
+	}
+	if (input.raw.value != raw || input.canary != canary) {
+		pr_debug("truncated swapped RAW sample modified data before validation\n");
+		return -1;
+	}
+	return 0;
+}
+
 /**
  * test__sample_parsing - test sample parsing.
  *
@@ -440,6 +489,18 @@ static int test__sample_parsing(struct test_suite *test __maybe_unused, int subt
 	if (err)
 		return err;
 
+	/* The declared RAW payload extends past an otherwise aligned event. */
+	err = test_truncated_swapped_raw(sizeof(struct perf_event_header) +
+					 sizeof(u64), 16);
+	if (err)
+		return err;
+
+	/* The final complete word touched by mem_bswap_64() extends past it. */
+	err = test_truncated_swapped_raw(sizeof(struct perf_event_header) +
+					 sizeof(u32) + 9, 9);
+	if (err)
+		return err;
+
 	/*
 	 * Fail the test if it has not been updated when new sample format bits
 	 * were added.  Please actually update the test rather than just change
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index ab808f0754055..2e8bfd4ea5c8b 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2843,7 +2843,10 @@ int evsel__parse_sample(struct evsel *evsel, union perf_event *event,
 	}
 
 	if (type & PERF_SAMPLE_RAW) {
+		const __u64 *raw;
+
 		OVERFLOW_CHECK_u64(array);
+		raw = array;
 		u.val64 = *array;
 
 		/*
@@ -2859,16 +2862,14 @@ int evsel__parse_sample(struct evsel *evsel, union perf_event *event,
 		}
 		data->raw_size = u.val32[0];
 
-		/*
-		 * The raw data is aligned on 64bits including the
-		 * u32 size, so it's safe to use mem_bswap_64.
-		 */
-		if (swapped)
-			mem_bswap_64((void *) array, data->raw_size);
-
 		array = (void *)array + sizeof(u32);
-
 		OVERFLOW_CHECK(array, data->raw_size, max_size);
+		if (swapped) {
+			/* mem_bswap_64() accesses complete 64-bit words. */
+			sz = roundup((u64)data->raw_size, sizeof(u64));
+			OVERFLOW_CHECK(raw, sz, max_size);
+			mem_bswap_64((void *)raw, data->raw_size);
+		}
 		data->raw_data = (void *)array;
 		array = (void *)array + data->raw_size;
 	}
-- 
2.53.0



