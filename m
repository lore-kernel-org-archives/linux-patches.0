Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65BB1EB21;
	Wed,  2 Oct 2024 14:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879822; cv=none; b=b6mO/CQDWfM5sAjfUFJq39aTntmbblEIsreSwq9EFzyail37X8mwIRennRMea7vQqFpOVCvZRyHnCjqFPQMpwh0168ha4Uwb59eFeSuJ8VGj1Jwz4VLvAAB9oUZIEjBQ7aDAHwdVnAfkSrPoz491ePRLemuvDyqB+CJhT9uhMi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879822; c=relaxed/simple;
	bh=pw4pW51ueLNms/BqGFDbRqlSYeaqI0otLmCvUa6Z1/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WetpKA+zkjqSalEejo++C81xTRDfjAhXUL6L3bsGg6eMgYSnDRX+4LMIIrmFlMtY3WaRh0pGKcnEMe+Ae60rF2WIESnI0J04uBl1s1lV+KO22X4hCHZkhCb7O3mTZoYr/JAyvXiWcdWwIxIN1DJ8nm9OMXjT7kt4FXRZzt3t1Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c8r51CVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c8r51CVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44082C4CEC2;
	Wed,  2 Oct 2024 14:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879822;
	bh=pw4pW51ueLNms/BqGFDbRqlSYeaqI0otLmCvUa6Z1/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c8r51CVlsCSF8P5zgF6I7UmMKE1yKIx0RwpabVPAiQfYqhakdwW1b8aAuu4nU95QJ
	 j1Vlpg6K1rgJMjcM30xQzcVNsOikkOPQl7n2IrCymNtvvaspbkMO/qR56jWOkPHqji
	 TRvV4IPg/mRNCEEtZzRXLT+NhOn60nOJEtkgcPLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 250/538] perf annotate: Move some source code related fields from struct annotation to struct annotated_source
Date: Wed,  2 Oct 2024 14:58:09 +0200
Message-ID: <20241002125802.123578020@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 0aae4c99c5f8f748c6cb5ca03bb3b3ae8cfb10df ]

Some fields in the 'struct annotation' are only used with 'struct
annotated_source' so better to be moved there in order to reduce memory
consumption for other symbols.

Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20231103191907.54531-5-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 3ef44458071a ("perf report: Fix --total-cycles --stdio output error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/ui/browsers/annotate.c | 12 ++++++------
 tools/perf/util/annotate.c        | 17 +++++++++--------
 tools/perf/util/annotate.h        | 14 +++++++-------
 3 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index d9f9fa254a71f..1fb7118ef5077 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -384,7 +384,7 @@ static bool annotate_browser__toggle_source(struct annotate_browser *browser)
 		if (al->idx_asm < offset)
 			offset = al->idx;
 
-		browser->b.nr_entries = notes->nr_entries;
+		browser->b.nr_entries = notes->src->nr_entries;
 		notes->options->hide_src_code = false;
 		browser->b.seek(&browser->b, -offset, SEEK_CUR);
 		browser->b.top_idx = al->idx - offset;
@@ -402,7 +402,7 @@ static bool annotate_browser__toggle_source(struct annotate_browser *browser)
 		if (al->idx_asm < offset)
 			offset = al->idx_asm;
 
-		browser->b.nr_entries = notes->nr_asm_entries;
+		browser->b.nr_entries = notes->src->nr_asm_entries;
 		notes->options->hide_src_code = true;
 		browser->b.seek(&browser->b, -offset, SEEK_CUR);
 		browser->b.top_idx = al->idx_asm - offset;
@@ -435,7 +435,7 @@ static void ui_browser__init_asm_mode(struct ui_browser *browser)
 {
 	struct annotation *notes = browser__annotation(browser);
 	ui_browser__reset_index(browser);
-	browser->nr_entries = notes->nr_asm_entries;
+	browser->nr_entries = notes->src->nr_asm_entries;
 }
 
 static int sym_title(struct symbol *sym, struct map *map, char *title,
@@ -860,7 +860,7 @@ static int annotate_browser__run(struct annotate_browser *browser,
 					   browser->b.height,
 					   browser->b.index,
 					   browser->b.top_idx,
-					   notes->nr_asm_entries);
+					   notes->src->nr_asm_entries);
 		}
 			continue;
 		case K_ENTER:
@@ -991,8 +991,8 @@ int symbol__tui_annotate(struct map_symbol *ms, struct evsel *evsel,
 
 	ui_helpline__push("Press ESC to exit");
 
-	browser.b.width = notes->max_line_len;
-	browser.b.nr_entries = notes->nr_entries;
+	browser.b.width = notes->src->max_line_len;
+	browser.b.nr_entries = notes->src->nr_entries;
 	browser.b.entries = &notes->src->source,
 	browser.b.width += 18; /* Percentage */
 
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index e594be2b71340..6dfe11cbf30e2 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -2825,19 +2825,20 @@ void annotation__mark_jump_targets(struct annotation *notes, struct symbol *sym)
 void annotation__set_offsets(struct annotation *notes, s64 size)
 {
 	struct annotation_line *al;
+	struct annotated_source *src = notes->src;
 
-	notes->max_line_len = 0;
-	notes->nr_entries = 0;
-	notes->nr_asm_entries = 0;
+	src->max_line_len = 0;
+	src->nr_entries = 0;
+	src->nr_asm_entries = 0;
 
-	list_for_each_entry(al, &notes->src->source, node) {
+	list_for_each_entry(al, &src->source, node) {
 		size_t line_len = strlen(al->line);
 
-		if (notes->max_line_len < line_len)
-			notes->max_line_len = line_len;
-		al->idx = notes->nr_entries++;
+		if (src->max_line_len < line_len)
+			src->max_line_len = line_len;
+		al->idx = src->nr_entries++;
 		if (al->offset != -1) {
-			al->idx_asm = notes->nr_asm_entries++;
+			al->idx_asm = src->nr_asm_entries++;
 			/*
 			 * FIXME: short term bandaid to cope with assembly
 			 * routines that comes with labels in the same column
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index dd612f9f04c98..238e7ef289a82 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -269,10 +269,13 @@ struct cyc_hist {
  * returns.
  */
 struct annotated_source {
-	struct list_head   source;
-	int    		   nr_histograms;
-	size_t		   sizeof_sym_hist;
-	struct sym_hist	   *histograms;
+	struct list_head	source;
+	size_t			sizeof_sym_hist;
+	struct sym_hist		*histograms;
+	int    			nr_histograms;
+	int			nr_entries;
+	int			nr_asm_entries;
+	u16			max_line_len;
 };
 
 struct annotated_branch {
@@ -290,9 +293,6 @@ struct LOCKABLE annotation {
 	struct annotation_line	**offsets;
 	int			nr_events;
 	int			max_jump_sources;
-	int			nr_entries;
-	int			nr_asm_entries;
-	u16			max_line_len;
 	struct {
 		u8		addr;
 		u8		jumps;
-- 
2.43.0



