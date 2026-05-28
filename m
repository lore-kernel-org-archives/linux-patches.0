Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03051223328;
	Thu, 28 May 2026 20:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000395; cv=none; b=g6E8cE1zO4TuQ/WUD91JG74J2yEc1UAif+8xGotz//HthNRNbgubmwHTUYOkt0r8MZzEtvQGYdrM7Xlovqk99p/P45W34FBVLJlapeg/FgCelY1TV7wslcJEpBQlRi/w0rqneclpECYu0lOhkoxCZCz0pMnvWQ+08QD5XIIqe/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000395; c=relaxed/simple;
	bh=VUpgoCm0mrsL7o2t3QzO+wfWpITukjc9g6+SroksGYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+8qBb32VN2QuD8sfVknHMGz0y7bjkIasmf00+mQJEKUHrPQzPi2y1a/ctfNw2Daya+LagWyyTUq0SafvTChz+vqAetl2Sa5ZS3Qr1/JR9ObROxkCdC8Z4wyb5EMQ3GIBEyPg278Bnmv3Jp+mtt7dN8Csgy0k6IWb77qkRfON1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7dpG6Ai; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7dpG6Ai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614811F000E9;
	Thu, 28 May 2026 20:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000393;
	bh=/QzahyJtnyC5xAeL9QXoiLMU1mjlnegM2FtQmR8BvtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F7dpG6Ai82cJzuyg/yabbEHnbo//GEmOq+ciGCi+4d7rlA9CQDcrVwwReyYalmmM6
	 2jz4N2iS+L9HCiBE32hMJsehdZisfPFmTgcmIUU6xGgLGT8+IpvvkAVa1WHixGxAeJ
	 f1JuwT5OH8vAQ+2Go9e7orSHafgxDc81/czvQeLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/272] perf parse-events: Expose/rename config_term_name
Date: Thu, 28 May 2026 21:46:43 +0200
Message-ID: <20260528194630.204788372@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit d2f3ecb0ca2099d13bf8bf69219214c1425dc453 ]

Expose config_term_name as parse_events__term_type_str so that PMUs not
in pmu.c may access it.

Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20241002032016.333748-4-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/parse-events.c | 20 +++++++++++---------
 tools/perf/util/parse-events.h |  2 ++
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index fcc4dab618bee..3d221608b13a5 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -801,7 +801,7 @@ static int check_type_val(struct parse_events_term *term,
 
 static bool config_term_shrinked;
 
-static const char *config_term_name(enum parse_events__term_type term_type)
+const char *parse_events__term_type_str(enum parse_events__term_type term_type)
 {
 	/*
 	 * Update according to parse-events.l
@@ -887,7 +887,7 @@ config_term_avail(enum parse_events__term_type term_type, struct parse_events_er
 
 		/* term_type is validated so indexing is safe */
 		if (asprintf(&err_str, "'%s' is not usable in 'perf stat'",
-			     config_term_name(term_type)) >= 0)
+			     parse_events__term_type_str(term_type)) >= 0)
 			parse_events_error__handle(err, -1, err_str, NULL);
 		return false;
 	}
@@ -1011,7 +1011,7 @@ do {									   \
 	case PARSE_EVENTS__TERM_TYPE_HARDWARE:
 	default:
 		parse_events_error__handle(err, term->err_term,
-					strdup(config_term_name(term->type_term)),
+					strdup(parse_events__term_type_str(term->type_term)),
 					parse_events_formats_error_string(NULL));
 		return -EINVAL;
 	}
@@ -1135,8 +1135,9 @@ static int config_term_tracepoint(struct perf_event_attr *attr,
 	default:
 		if (err) {
 			parse_events_error__handle(err, term->err_term,
-						   strdup(config_term_name(term->type_term)),
-				strdup("valid terms: call-graph,stack-size\n"));
+					strdup(parse_events__term_type_str(term->type_term)),
+					strdup("valid terms: call-graph,stack-size\n")
+				);
 		}
 		return -EINVAL;
 	}
@@ -2581,7 +2582,7 @@ int parse_events_term__num(struct parse_events_term **term,
 	struct parse_events_term temp = {
 		.type_val  = PARSE_EVENTS__TERM_TYPE_NUM,
 		.type_term = type_term,
-		.config    = config ? : strdup(config_term_name(type_term)),
+		.config    = config ? : strdup(parse_events__term_type_str(type_term)),
 		.no_value  = no_value,
 		.err_term  = loc_term ? loc_term->first_column : 0,
 		.err_val   = loc_val  ? loc_val->first_column  : 0,
@@ -2615,7 +2616,7 @@ int parse_events_term__term(struct parse_events_term **term,
 			    void *loc_term, void *loc_val)
 {
 	return parse_events_term__str(term, term_lhs, NULL,
-				      strdup(config_term_name(term_rhs)),
+				      strdup(parse_events__term_type_str(term_rhs)),
 				      loc_term, loc_val);
 }
 
@@ -2722,7 +2723,8 @@ int parse_events_terms__to_strbuf(const struct parse_events_terms *terms, struct
 				if (ret < 0)
 					return ret;
 			} else if ((unsigned int)term->type_term < __PARSE_EVENTS__TERM_TYPE_NR) {
-				ret = strbuf_addf(sb, "%s=", config_term_name(term->type_term));
+				ret = strbuf_addf(sb, "%s=",
+						  parse_events__term_type_str(term->type_term));
 				if (ret < 0)
 					return ret;
 			}
@@ -2742,7 +2744,7 @@ static void config_terms_list(char *buf, size_t buf_sz)
 
 	buf[0] = '\0';
 	for (i = 0; i < __PARSE_EVENTS__TERM_TYPE_NR; i++) {
-		const char *name = config_term_name(i);
+		const char *name = parse_events__term_type_str(i);
 
 		if (!config_term_avail(i, NULL))
 			continue;
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 2b52f8d6aa29a..ac1feaaeb8d5d 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -168,6 +168,8 @@ struct parse_events_state {
 	bool			   wild_card_pmus;
 };
 
+const char *parse_events__term_type_str(enum parse_events__term_type term_type);
+
 bool parse_events__filter_pmu(const struct parse_events_state *parse_state,
 			      const struct perf_pmu *pmu);
 void parse_events__shrink_config_terms(void);
-- 
2.53.0



