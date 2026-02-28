Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1ED43590A9
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300903; cv=none; b=oZlG1G95a+un9VEUVpoib9LKEmfxDDRPIJInWcwfMR3p6DiFcI5oD/sI+T9hRfZp56PCLEStgjGoZTCkDRgIkY/gM2Ot5JYPulvN6QDw162P53w5xuEDapySFy1clEBLD1q3/aTPetbVlQk1p/emKDWWMPNfOFhLYAKsrq/3HNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300903; c=relaxed/simple;
	bh=4v/jkcwMX4aKXsZ+r8zzm511JZmxrAC1mBESUCphHVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPQd1DepdU6e4jT0M58MgdN0l44/hCde0Kh8Yja5rJcnXpgxK6Hz7RMUwP7YabUST2hnsb0vyE07hXQIcdKLnNhL0bK5QiH1x45BPClboDl7JWtaZwXw2WqgiXa+Xm6VNlVCQRLPNozybaCPbDeUeVMu/xiN6C5S865If0TvCjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZZqt5aTo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZZqt5aTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDA5C19423;
	Sat, 28 Feb 2026 17:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300903;
	bh=4v/jkcwMX4aKXsZ+r8zzm511JZmxrAC1mBESUCphHVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZqt5aTo+JFl+0Izr+Q+eZJZgmrKYGN74cbCi7bR3RzGnS67FXnx8iLdZ9rcttlpT
	 oo1XpcfQEoiJReXkaP9Tw+ijLZPhdBRnlhvp8r9kSTWA9+WUisAHVDMiuNdg+uVO8F
	 H/rkc4fg36eKyO+YmZx2RIkJuO2g5cwt/xTRRnc8q1vQAWgJBtNJlmcE1MHO+caAGc
	 9GA813mrUU8N5S3+mzqdS7cbyjAQ4rGCq9qLJpE8nISxLM+TuMjpMZGgB09QJJNr54
	 nmepYJM2WactPyC38qp5PQI0vR0Bs3/kQVv0bbFE4unMH4kt86ugO82FoE1+IkCICG
	 dHX4jZL2n9GBw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 018/752] perf build: Remove NO_LIBCAP that controls nothing
Date: Sat, 28 Feb 2026 12:35:29 -0500
Message-ID: <20260228174750.1542406-18-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ian Rogers <irogers@google.com>

[ Upstream commit 169343cc8ff2bd59758760d867bd26adae866a2b ]

Using libcap was removed in commit e25ebda78e230283 ("perf cap: Tidy up
and improve capability testing") and improve capability testing"),
however, some build documentation and a use of the NO_LIBCAP=1 were
lingering.

Remove these left over bits.

Fixes: e25ebda78e230283 ("perf cap: Tidy up and improve capability testing")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Makefile.perf | 2 --
 tools/perf/tests/make    | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index da7434b385d18..562b9d356d2a2 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -88,8 +88,6 @@ include ../scripts/utilities.mak
 #
 # Define NO_LIBBPF if you do not want BPF support
 #
-# Define NO_LIBCAP if you do not want process capabilities considered by perf
-#
 # Define NO_SDT if you do not want to define SDT event in perf tools,
 # note that it doesn't disable SDT scanning support.
 #
diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index b650ce8864ed5..fa4500c65949a 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -123,7 +123,7 @@ make_minimal        += NO_DEMANGLE=1 NO_LIBELF=1 NO_BACKTRACE=1
 make_minimal        += NO_LIBNUMA=1 NO_LIBBIONIC=1 NO_LIBDW=1
 make_minimal        += NO_LIBDW_DWARF_UNWIND=1 NO_AUXTRACE=1 NO_LIBBPF=1
 make_minimal        += NO_SDT=1 NO_JVMTI=1 NO_LIBZSTD=1
-make_minimal        += NO_LIBCAP=1 NO_CAPSTONE=1
+make_minimal        += NO_CAPSTONE=1
 
 # $(run) contains all available tests
 run := make_pure
-- 
2.51.0

