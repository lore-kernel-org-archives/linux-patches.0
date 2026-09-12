Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D5A3F23BE;
	Sat, 12 Sep 2026 10:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209861; cv=none; b=N8vRZfs4Z3Kf63Nb9Dmbv3rqVgcW2Xvcx1z4A5WmcK2Qb+bfHP3nnCvL1cSC8awyuk1vMgSssp2Qx3wwWGpDs/N5O2ugSJDVO1Ag6SRZe/dBPFTsGLvB2MpMDXJZ1rLkZYEjw1TtnDY1EvkoF831aPM3mWEWpj3c6EQZwq+z7y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209861; c=relaxed/simple;
	bh=G0XM68SM+4lbYQBW3/EA0ZF0cIDVwh1W1reUBjJ8kWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgKemrSYYLMJJCqJ0ZdDFGxuWjNZqWp2QN1Ei+w329zghcmF4H/9uCHMx/r9q65cs66p0ZieRIUGO7yfsknFxVgWemwIcUeTnVxFJh8GtfzecFaayumdFCNHZ40KNNDoM7ZIxRDjvH8ou5gM2uXDf8voErYPBIj20FmynJhrxO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YBPflxSx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YBPflxSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37ADF1F000FF;
	Sat, 12 Sep 2026 10:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209859;
	bh=R/2yAqhMgvAt0Qzc756PmmcHNDtOazH11R2EBAmy4GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YBPflxSxxZwQrWqE/vYXfG3SvTKf8gGZQoi8BevEF9YLq6k7nrKxRHjcKvVbMdcjS
	 2uuwZ8YDhBr6UvgHWSRCenp/6QHWwGBR/yx8Qp9FmmEO1vD8qEbtVZqbCiZnqLpYWb
	 SMSGPP0jVXMXCKSsF1hxolFRon95HVKevlEV4hks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0907/1518] perf report: Update sort key state from -F option
Date: Sat, 12 Sep 2026 08:51:16 +0200
Message-ID: <20260912065643.971044918@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit cbd41c6d4c26c161a2b0e70ad411d3885ff13507 ]

Factor out __sort_dimension__update() so that it can be called from -s
and -F option parsing logics.  Otherwise the following command cannot go
into the annotation mode.

  $ perf report -F overhead,type,sym

  Warning: Annotation is only available for symbolic views, include "sym*" in --sort to use it.

Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: f53f5c2437c1 ("perf c2c: Fix error masking, OOM, and unchecked caller errors in hpp_list__parse()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/sort.c | 100 ++++++++++++++++++++++-------------------
 1 file changed, 54 insertions(+), 46 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 3d4b68fd6e445..f963d61ac166f 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -3538,6 +3538,56 @@ static int add_dynamic_entry(struct evlist *evlist, const char *tok,
 	return ret;
 }
 
+static int __sort_dimension__update(struct sort_dimension *sd,
+				    struct perf_hpp_list *list)
+{
+	if (sd->entry == &sort_parent && parent_pattern) {
+		int ret = regcomp(&parent_regex, parent_pattern, REG_EXTENDED);
+		if (ret) {
+			char err[BUFSIZ];
+
+			regerror(ret, &parent_regex, err, sizeof(err));
+			pr_err("Invalid regex: %s\n%s", parent_pattern, err);
+			return -EINVAL;
+		}
+		list->parent = 1;
+	} else if (sd->entry == &sort_sym) {
+		list->sym = 1;
+		/*
+		 * perf diff displays the performance difference amongst
+		 * two or more perf.data files. Those files could come
+		 * from different binaries. So we should not compare
+		 * their ips, but the name of symbol.
+		 */
+		if (sort__mode == SORT_MODE__DIFF)
+			sd->entry->se_collapse = sort__sym_sort;
+
+	} else if (sd->entry == &sort_sym_offset) {
+		list->sym = 1;
+	} else if (sd->entry == &sort_dso) {
+		list->dso = 1;
+	} else if (sd->entry == &sort_socket) {
+		list->socket = 1;
+	} else if (sd->entry == &sort_thread) {
+		list->thread = 1;
+	} else if (sd->entry == &sort_comm) {
+		list->comm = 1;
+	} else if (sd->entry == &sort_type_offset) {
+		symbol_conf.annotate_data_member = true;
+	} else if (sd->entry == &sort_sym_from || sd->entry == &sort_sym_to) {
+		list->sym = 1;
+	} else if (sd->entry == &sort_mem_dcacheline && cacheline_size() == 0) {
+		return -EINVAL;
+	} else if (sd->entry == &sort_mem_daddr_sym) {
+		list->sym = 1;
+	}
+
+	if (sd->entry->se_collapse)
+		list->need_collapse = 1;
+
+	return 0;
+}
+
 static int __sort_dimension__add(struct sort_dimension *sd,
 				 struct perf_hpp_list *list,
 				 int level)
@@ -3548,8 +3598,8 @@ static int __sort_dimension__add(struct sort_dimension *sd,
 	if (__sort_dimension__add_hpp_sort(sd, list, level) < 0)
 		return -1;
 
-	if (sd->entry->se_collapse)
-		list->need_collapse = 1;
+	if (__sort_dimension__update(sd, list) < 0)
+		return -1;
 
 	sd->taken = 1;
 
@@ -3585,8 +3635,8 @@ static int __sort_dimension__add_output(struct perf_hpp_list *list,
 	if (__sort_dimension__add_hpp_output(sd, list, level) < 0)
 		return -1;
 
-	if (sd->entry->se_collapse)
-		list->need_collapse = 1;
+	if (__sort_dimension__update(sd, list) < 0)
+		return -1;
 
 	sd->taken = 1;
 	return 0;
@@ -3651,39 +3701,6 @@ int sort_dimension__add(struct perf_hpp_list *list, const char *tok,
 				sort_dimension_add_dynamic_header(sd, env);
 		}
 
-		if (sd->entry == &sort_parent && parent_pattern) {
-			int ret = regcomp(&parent_regex, parent_pattern, REG_EXTENDED);
-			if (ret) {
-				char err[BUFSIZ];
-
-				regerror(ret, &parent_regex, err, sizeof(err));
-				pr_err("Invalid regex: %s\n%s", parent_pattern, err);
-				return -EINVAL;
-			}
-			list->parent = 1;
-		} else if (sd->entry == &sort_sym) {
-			list->sym = 1;
-			/*
-			 * perf diff displays the performance difference amongst
-			 * two or more perf.data files. Those files could come
-			 * from different binaries. So we should not compare
-			 * their ips, but the name of symbol.
-			 */
-			if (sort__mode == SORT_MODE__DIFF)
-				sd->entry->se_collapse = sort__sym_sort;
-
-		} else if (sd->entry == &sort_dso) {
-			list->dso = 1;
-		} else if (sd->entry == &sort_socket) {
-			list->socket = 1;
-		} else if (sd->entry == &sort_thread) {
-			list->thread = 1;
-		} else if (sd->entry == &sort_comm) {
-			list->comm = 1;
-		} else if (sd->entry == &sort_type_offset) {
-			symbol_conf.annotate_data_member = true;
-		}
-
 		return __sort_dimension__add(sd, list, level);
 	}
 
@@ -3702,9 +3719,6 @@ int sort_dimension__add(struct perf_hpp_list *list, const char *tok,
 				    strlen(tok)))
 			return -EINVAL;
 
-		if (sd->entry == &sort_sym_from || sd->entry == &sort_sym_to)
-			list->sym = 1;
-
 		__sort_dimension__add(sd, list, level);
 		return 0;
 	}
@@ -3718,12 +3732,6 @@ int sort_dimension__add(struct perf_hpp_list *list, const char *tok,
 		if (sort__mode != SORT_MODE__MEMORY)
 			return -EINVAL;
 
-		if (sd->entry == &sort_mem_dcacheline && cacheline_size() == 0)
-			return -EINVAL;
-
-		if (sd->entry == &sort_mem_daddr_sym)
-			list->sym = 1;
-
 		__sort_dimension__add(sd, list, level);
 		return 0;
 	}
-- 
2.53.0



