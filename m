Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030596;
	b=PfxfxF/kSYgGEOR1etBhUNVlriYLeZpSuFlgHAoVMNR5Vk7o6gBV90AndVEj5xkGjUWm
	 vnoxjfl2HVIruqSAohTWQ3UZS6Z9M1YWg3WawbVJYBx06jTGcJLZ0gLS/bxdxrjnMoICr
	 w3XWLCM/OtAM8B51rneqMXuBALGXzgpuzpjb8LirSxkYQuTtStv4fZRlb6RXpECkSG9MY
	 Zheaa8QyhoYR4LjqKvkIAL81LHbVfm8vRG6M4hvvZPuOPULO0SPfxzWgZ9K5KvsMTDt4g
	 fcsy6M18GIhjpR2WiMmRJRaAbVlalS1L4tLe/b4idxIXvNbpZ6qhFS8iOiII5wRVrcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030596;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZWa05qOJTMQP4bl56WKF3GqK0uIImx85QGxSKbD46Zo=;
	b=hi4ktoSw6UmBnDMhbxH7xwgzWSuI7xG3LAIJx6On1mQRhfvzz7pntqHajxW9w20J/bsT
	 eFXSaWhcwUn/Clp2yMwENXEQECwSD9SmTgoQucADCfEW6iiIaOwy2YsCUfTP3h7Mmqinm
	 Slurmvng7wDsDiis97pS/G5olLaPzk4pzM1qsinkmkWIB04QTM0R7S49ftNCSoUKm614c
	 WqthiE5Nm6LDEjHd0KnpNLvHRBFYZidxN4PFsa2nxJqQS0pKWIZNUqf71AxnfAWeDVzuI
	 3JOKlkfjXpbihS14zhhCpupkkQFJBKazhdW06iV2xegmD8+DDpXBwYu9TqiZt9KW1EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WHrBdLa8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C2A60A5BC2;
	Wed, 18 Nov 2026 19:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WHrBdLa8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D774B1F000C7;
	Wed, 18 Nov 2026 19:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030596;
	bh=ZWa05qOJTMQP4bl56WKF3GqK0uIImx85QGxSKbD46Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WHrBdLa8JlRMO54I1AvMZ3iQ5RxJc1kQv7EkXm+pnn1eygJSPB8lziPyHLflEdGE3
	 kiSc+4Suw9ixlI0sp0IQTtfCyZfc8TGIR6Eskccl/wuSCQLWnMRlf+XGsRmO4JoT5w
	 6Gg0lQ7sLykRDUfsGB3kUw1JM5q82PBfFdhd+LlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0744/1756] perf thread_map: Add thread_map__tgid()
Date: Wed, 18 Nov 2026 15:47:51 +0100
Message-ID: <20261118150039.213563738@linuxfoundation.org>
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
index 535290000c447..3faa67206bc69 100644
--- a/tools/perf/util/bpf-filter.c
+++ b/tools/perf/util/bpf-filter.c
@@ -55,6 +55,7 @@
 #include "util/debug.h"
 #include "util/evsel.h"
 #include "util/target.h"
+#include "util/thread_map.h"
 #include "util/bpf-utils.h"
 
 #include "util/bpf-filter.h"
@@ -201,31 +202,6 @@ static int get_filter_entries(struct evsel *evsel, struct perf_bpf_filter_entry
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
@@ -406,14 +382,13 @@ static int create_idx_hash(struct evsel *evsel, struct perf_bpf_filter_entry *en
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
index b5f12390c3558..b3a188bcbab4f 100644
--- a/tools/perf/util/thread_map.c
+++ b/tools/perf/util/thread_map.c
@@ -427,3 +427,29 @@ int thread_map__remove(struct perf_thread_map *threads, int idx)
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
index 00ec05fc1656d..39592d8f53daa 100644
--- a/tools/perf/util/thread_map.h
+++ b/tools/perf/util/thread_map.h
@@ -26,4 +26,5 @@ size_t thread_map__fprintf(struct perf_thread_map *threads, FILE *fp);
 void thread_map__read_comms(struct perf_thread_map *threads);
 bool thread_map__has(struct perf_thread_map *threads, pid_t pid);
 int thread_map__remove(struct perf_thread_map *threads, int idx);
+pid_t thread_map__tgid(struct perf_thread_map *threads, int idx);
 #endif	/* __PERF_THREAD_MAP_H */
-- 
2.53.0



