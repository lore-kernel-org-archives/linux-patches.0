Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056724;
	b=FgCmLB6URQiP7hdCSmZHLFdPl6sRGGFlM0BmtF4rqxc8NhJgmS/tcCfkEsNTcBg54PNU
	 8FHROKlVd3Gu6raMBkb7LGGjAyoXjNlk01rczg3UjXjFOKKHVewsIDXwUNteGlB9s3ZpT
	 Rz5+jCG9KcFAqgDt3YvhEEZpv6TWsHlY+gU51dWnJLKNEEuqC5/YfOgC+br1lPkIuZz5A
	 J5oX67SKY6Ooqh4Z3XC8NDxD4ijEcrYaidhoB5dlRhAM0t+30p0HOVtjyznP0WwarDhMV
	 d7jynVOxy9r/7RxwLyk3N75CH8vw+sZeiwNerqpmGshKW0UyyJf24h20B8ChkXMEavg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056724;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LUqBzoEbICu2gGjrUri7BM8sDQgcxBg8NEGSqd5VzHY=;
	b=EDAQHgWAeu0BHOW6KzZXa+jhEmTdJqGNXpTlozhOBzY+W040uNVU29kFqW4foTDCN08g
	 fjXg5iylIgWLZUkUFLqWWATZghrZ+yCSTw15UZllGMUcQRbMdca9f8cJSlg6f/Vdy2uew
	 z6WL2h5H+0RfbKJxRl9i0cvTA0aegtye7VdFB8GwvEj91xZqlAANhoEa2aGELdf2YF+E2
	 Nvi5HXO5+/0rjx00DNjCGmeiFUlRpfKSrLDSVR7/NPso9AnVSBjNx6bP+ck33JxUQQ9aC
	 Jr417qw2yfSG7Cfd1WHNnFfalvPzejHDLh/JaZTsesXFDQ1U2SagoLf7eL3j/+kYmcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FQdPA5Pb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDF8606A32A;
	Thu, 19 Nov 2026 02:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FQdPA5Pb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5DD1F000C7;
	Thu, 19 Nov 2026 02:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056724;
	bh=LUqBzoEbICu2gGjrUri7BM8sDQgcxBg8NEGSqd5VzHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FQdPA5PbR62M2KAUFLRVkIscuP9wUmqDrYhtPCKCT/droV2whyPJ4S+rF3HIVG1/3
	 HZf4fk27zjIkcFnHzezfDhECvkL9QTHZqf8lCqfL8zTDfljgQVeIRScpwNhq5ctwgV
	 mA0FTD62gThyNH651CfsoTB4ptlwsJS/OeA1maPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Saidi <alisaidi@amazon.com>,
	Leo Yan <leo.yan@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	German Gomez <german.gomez@arm.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	John Garry <john.garry@huawei.com>,
	Kajol Jain <kjain@linux.ibm.com>,
	Like Xu <likexu@tencent.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Timothy Hayes <timothy.hayes@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2091/2214] perf c2c: Use peer as default display for Arm64
Date: Wed, 18 Nov 2026 16:02:47 +0100
Message-ID: <20261118150134.267021741@linuxfoundation.org>
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

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit ead42a0f9b93c3447a24be08a9e80941e99b8a50 ]

Since Arm64 arch doesn't support HITMs flags, this patch changes to use
'peer' as default display if user doesn't specify any type; for other
arches, it still uses 'tot' as default display type if user doesn't
specify it.

This patch changes to call perf_session__new() in an earlier place, so
session environment can be initialized ahead and arch info can be used
for setting display type.

Suggested-by: Ali Saidi <alisaidi@amazon.com>
Reviewed-by: Ali Saidi <alisaidi@amazon.com>
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Tested-by: Ali Saidi <alisaidi@amazon.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: German Gomez <german.gomez@arm.com>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.garry@huawei.com>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Like Xu <likexu@tencent.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Timothy Hayes <timothy.hayes@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Link: https://lore.kernel.org/r/20220811062451.435810-15-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 7d0fe18bc905 ("perf c2c: Fix memory leaks on output fields")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-c2c.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index e6f900c3accb0..75fe1f4c6dd03 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -2602,7 +2602,7 @@ static int setup_callchain(struct evlist *evlist)
 
 static int setup_display(const char *str)
 {
-	const char *display = str ?: "tot";
+	const char *display = str;
 
 	if (!strcmp(display, "tot"))
 		c2c.display = DISPLAY_TOT;
@@ -2776,27 +2776,39 @@ static int perf_c2c__report(int argc, const char **argv)
 	data.path  = input_name;
 	data.force = symbol_conf.force;
 
+	session = perf_session__new(&data, &c2c.tool);
+	if (IS_ERR(session)) {
+		err = PTR_ERR(session);
+		pr_debug("Error creating perf session\n");
+		goto out;
+	}
+
+	/*
+	 * Use the 'tot' as default display type if user doesn't specify it;
+	 * since Arm64 platform doesn't support HITMs flag, use 'peer' as the
+	 * default display type.
+	 */
+	if (!display) {
+		if (!strcmp(perf_env__arch(&session->header.env), "arm64"))
+			display = "peer";
+		else
+			display = "tot";
+	}
+
 	err = setup_display(display);
 	if (err)
-		goto out;
+		goto out_session;
 
 	err = setup_coalesce(coalesce, no_source);
 	if (err) {
 		pr_debug("Failed to initialize hists\n");
-		goto out;
+		goto out_session;
 	}
 
 	err = c2c_hists__init(&c2c.hists, "dcacheline", 2);
 	if (err) {
 		pr_debug("Failed to initialize hists\n");
-		goto out;
-	}
-
-	session = perf_session__new(&data, &c2c.tool);
-	if (IS_ERR(session)) {
-		err = PTR_ERR(session);
-		pr_debug("Error creating perf session\n");
-		goto out;
+		goto out_session;
 	}
 
 	session->itrace_synth_opts = &itrace_synth_opts;
@@ -2804,7 +2816,7 @@ static int perf_c2c__report(int argc, const char **argv)
 	err = setup_nodes(session);
 	if (err) {
 		pr_err("Failed setup nodes\n");
-		goto out;
+		goto out_session;
 	}
 
 	err = mem2node__init(&c2c.mem2node, &session->header.env);
-- 
2.53.0



