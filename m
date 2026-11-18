Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025036;
	b=iwB6CODyivzChbiAyOc0n+WcGLxIdVelUfmBeAPXuxIXlUf+hm+ZcYaJ/jGPcVNIkiPD
	 YTEr0/J+NzMM9klAp9t0h77khELe+H1aml2xgEfxtbWI55CMqvG6eMJvbEQyPiPixo5+Z
	 9Z01UnXogIq1aZq+fYPas+vyJuD0ZeIYqbHt9wnk5OQtsxbR507RgNiHvqYbgoHFXB3CF
	 0WqKeolNW2052LapCLxtVzSvlddTB/wzy/xooMLDgYSOdolBYc0aFbLDEOVr6vfMz9t2g
	 ZhF8wyJQ95v8jcs9hjwe36nb05F/ceCrxMGgBvh3KVVxXWXqyjtClf7O9hp5cgVO5dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025036;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vdsCHSHg+2DtCxXT9l85X7iIBoFB750WWHlXRKW8dFs=;
	b=TlJQ2MWAfgSl6CeRwMPFQDj8ZrTqKfjh+Dw3+nwCJqU0tTFkHcvjWrSx5YCKyHQhylvO
	 xN8A+sRp/0RxzdAtacwdNqrIyp3qciO8NKPdWjnjW43yRHjU0g3lCKta3oOrR8Lv51YXy
	 g17/y24XXkvc/1/dyIlTB7FlCmbdlBqCuM/UDG6xz+bC2tN7CSx+jmq5dzsdKAjWX8RzI
	 TmUHlPCJNjXpi9eM9dDyr83d5KO/1sl2qEx0HWsquqgIQFR2DZYqQbHENnfYQZXcyWHvP
	 BGlvueK5uGh01pn1XXWT4BU6B7do13ZRcRTfBWwK92ypSU7pYTerqVsh8Kigv+m14KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WUZ63uFV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB97606A31C;
	Wed, 18 Nov 2026 18:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WUZ63uFV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFAC1F000C5;
	Wed, 18 Nov 2026 18:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025036;
	bh=vdsCHSHg+2DtCxXT9l85X7iIBoFB750WWHlXRKW8dFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WUZ63uFVZVm2LgotJCaW6Zp6TXYWZcJRLBMFbqhuodaYypQ5jhxVQfiWO+tXGHHtm
	 37uF4ZXheAkcDDwk1OvWMAh5oCuPChGbuNCDqLeuXjC0ia9EhUPMOmQySBp5tJkYGE
	 46scOcjY499mRDbWzU6V1qyIzgJTT+u7NFVBOQBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0938/2151] perf thread_map: Add thread_map__tgid()
Date: Wed, 18 Nov 2026 15:44:33 +0100
Message-ID: <20261118150156.650174297@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 1fdf657871b9240edcaaf1d15caaac5b78a84317 ]

bpf-filter reads the tgid of each thread in a thread map from /proc, to
key its BPF map by process, and perf trace is about to do the same. Move
convert_to_tgid() to thread_map.c as thread_map__tgid(), taking the
thread map and index both users have.

While moving it, fix two bugs. Match Tgid: at the start of a line, as a
task can set its comm, shown on the Name: line before it, to contain
"Tgid: <n>". And check the character after the number before freeing the
buffer it points into, rather than after.

Fixes: eb1693b1150d4b99 ("perf bpf-filter: Split per-task filter use case")
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf-filter.c | 29 ++---------------------------
 tools/perf/util/thread_map.c | 26 ++++++++++++++++++++++++++
 tools/perf/util/thread_map.h |  1 +
 3 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/tools/perf/util/bpf-filter.c b/tools/perf/util/bpf-filter.c
index bcd81084e3420..72e83ac1d6a4b 100644
--- a/tools/perf/util/bpf-filter.c
+++ b/tools/perf/util/bpf-filter.c
@@ -56,6 +56,7 @@
 #include "util/debug.h"
 #include "util/evsel.h"
 #include "util/target.h"
+#include "util/thread_map.h"
 #include "util/bpf-utils.h"
 
 #include "util/bpf-filter.h"
@@ -202,31 +203,6 @@ static int get_filter_entries(struct evsel *evsel, struct perf_bpf_filter_entry
 	return 0;
 }
 
-static int convert_to_tgid(int tid)
-{
-	char path[128];
-	char *buf, *p, *q;
-	int tgid;
-	size_t len;
-
-	scnprintf(path, sizeof(path), "%d/status", tid);
-	if (procfs__read_str(path, &buf, &len) < 0)
-		return -1;
-
-	p = strstr(buf, "Tgid:");
-	if (p == NULL) {
-		free(buf);
-		return -1;
-	}
-
-	tgid = strtol(p + 6, &q, 0);
-	free(buf);
-	if (*q != '\n')
-		return -1;
-
-	return tgid;
-}
-
 /*
  * The event might be closed already so we cannot get the list of ids using FD
  * like in create_event_hash() below, let's iterate the event_hash map and
@@ -407,14 +383,13 @@ static int create_idx_hash(struct evsel *evsel, struct perf_bpf_filter_entry *en
 	last = -1;
 	nr = perf_thread_map__nr(threads);
 	for (int i = 0; i < nr; i++) {
-		int pid = perf_thread_map__pid(threads, i);
 		int tgid;
 		struct idx_hash_key key = {
 			.evt_id = event_id,
 		};
 
 		/* it actually needs tgid, let's get tgid from /proc. */
-		tgid = convert_to_tgid(pid);
+		tgid = thread_map__tgid(threads, i);
 		if (tgid < 0) {
 			/* the thread may be dead, ignore. */
 			continue;
diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
index 48c70f149e920..918ab31802320 100644
--- a/tools/perf/util/thread_map.c
+++ b/tools/perf/util/thread_map.c
@@ -395,3 +395,29 @@ int thread_map__remove(struct perf_thread_map *threads, int idx)
 	threads->nr--;
 	return 0;
 }
+
+/* The tgid of the thread at idx, read from /proc, or -1 if it has exited. */
+pid_t thread_map__tgid(struct perf_thread_map *threads, int idx)
+{
+	char path[128];
+	char *buf, *p, *q;
+	pid_t tgid;
+	size_t len;
+
+	snprintf(path, sizeof(path), "%d/status", perf_thread_map__pid(threads, idx));
+	if (procfs__read_str(path, &buf, &len) < 0)
+		return -1;
+
+	/* From a line start, as the Name: line before it can contain "Tgid:". */
+	p = strstr(buf, "\nTgid:");
+	if (p == NULL) {
+		free(buf);
+		return -1;
+	}
+
+	tgid = strtol(p + 6, &q, 0);
+	if (*q != '\n')
+		tgid = -1;
+	free(buf);
+	return tgid;
+}
diff --git a/tools/perf/util/thread_map.h b/tools/perf/util/thread_map.h
index fc16d87f32fb8..d700a22b7ae46 100644
--- a/tools/perf/util/thread_map.h
+++ b/tools/perf/util/thread_map.h
@@ -24,4 +24,5 @@ size_t thread_map__fprintf(struct perf_thread_map *threads, FILE *fp);
 void thread_map__read_comms(struct perf_thread_map *threads);
 bool thread_map__has(struct perf_thread_map *threads, pid_t pid);
 int thread_map__remove(struct perf_thread_map *threads, int idx);
+pid_t thread_map__tgid(struct perf_thread_map *threads, int idx);
 #endif	/* __PERF_THREAD_MAP_H */
-- 
2.53.0



