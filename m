Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76313151988;
	Wed,  5 Feb 2025 14:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766045; cv=none; b=k3e+yZ096YIb3FKBnU39paNUgYRR/6hJ/FHNPhLUnjkJwcVzVSev0xuszxBFYaGEEoyKYS8D7FRZN2T2KthTmVreViAQXFpRGDXRq6762XypcIExGLqhHV6giLy2QAPsRhlgvlPH90oiW552vFwMp0qdcCIaKSU+n9ri9x3SxKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766045; c=relaxed/simple;
	bh=B806445Yvdd2e7MnvVffvuqJHW1/ERT1bP3QKPDgIVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1ryQN3m+Y1BCu5oLxdTKPwU4ZIxGSBo15/fKt8+MoZ2IggdeXPF/+2Bp8vQMnpOMuaVk2Htl5B8KJPVwLbodl1HyYNi8JN6Zu3Y4730i2WvwTtGIoH3I1rM8n1PlOJQJhupTDcuwmWqCyRnAAQFOpS38GXqVPD/8+8vZfu5DKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7YWwSo/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7YWwSo/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1C2C4CED1;
	Wed,  5 Feb 2025 14:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766045;
	bh=B806445Yvdd2e7MnvVffvuqJHW1/ERT1bP3QKPDgIVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7YWwSo/sRPxvttCyNNl6Spp0OKbRlGfD/JTMnIEXAinFjCfYKXgzQiYvbc1iud0e
	 cS9YASOUrhAgCw0eFFmy/vtSg+USAYtYaRZw1QOKEeuv12k1Qxy8c63Fh3Lmr6OAK5
	 benYY3Y3dfsquOOXkeyi+U3+YL3sf1kxyw3HPoNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 282/590] perf inject: Fix use without initialization of local variables
Date: Wed,  5 Feb 2025 14:40:37 +0100
Message-ID: <20250205134506.067431390@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 8e246a1b2a75e187c7d22c9aec4299057f87d19e ]

Local variables were missing initialization and command line
processing didn't provide default values.

Fixes: 64eed019f3fce124 ("perf inject: Lazy build-id mmap2 event insertion")
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20241211060831.806539-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-inject.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index d6989195a061f..11e49cafa3af9 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -2367,10 +2367,10 @@ int cmd_inject(int argc, const char **argv)
 	};
 	int ret;
 	const char *known_build_ids = NULL;
-	bool build_ids;
-	bool build_id_all;
-	bool mmap2_build_ids;
-	bool mmap2_build_id_all;
+	bool build_ids = false;
+	bool build_id_all = false;
+	bool mmap2_build_ids = false;
+	bool mmap2_build_id_all = false;
 
 	struct option options[] = {
 		OPT_BOOLEAN('b', "build-ids", &build_ids,
-- 
2.39.5



