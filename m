Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE1512F5A7;
	Tue, 23 Jan 2024 00:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969037; cv=none; b=YcWCmer/Fq8RmbCgRIUd2lcq6Utw5U0z89T1G2ebYD6KKQiKvAo56g/lu9I5jdm5OQT9yWT/vpQAMvpMTBAwLDvpwDs2KDDiYE7gDEO5zXvHHTY+FFk11kE/VhCz9P5MsMK1xKAQt2hmqixx8UQUCAmyEWiJcytrFuRix4RUBiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969037; c=relaxed/simple;
	bh=gR9zfSbwt9R6QZ22rLBA+swck9t4OIdZxfgvRz2FE9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+6jkvtZzQwxhbzMKOWMlmFZv72Ctz69jcWVfa3i1/c/plBv16VSQuGjbHpa1UQUBUGXJqC1+7pCXfXTtAHL37JWo2eyuutqx0Iv3tCVCZEFK2Xh4GLcsh1yRB2Q7w9yc8v7eHv1d8dBHRVakT20tH3ow6Qru/kVVAhH4AjrtKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TdshVh+K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TdshVh+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF68C433C7;
	Tue, 23 Jan 2024 00:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969036;
	bh=gR9zfSbwt9R6QZ22rLBA+swck9t4OIdZxfgvRz2FE9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TdshVh+KhvpUyutdv+RLCeZ0pcMKU7Q3Yj3XoM50tZJ3QPA87i6aJfFJzrEcTAXd2
	 1sf2HSR0tMyZ+r2fNA4BI4yiR82yAkFp8m03nuBayjFDumAjwXJeERB0+JldcmIrbQ
	 p1qlhbHHBlFn1yEgbZaFtmaXsa1SJ4FE98ZEQFTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alexey Budankov <alexey.budankov@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Joe Mario <jmario@redhat.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Michael Petlan <mpetlan@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 173/194] perf env: Add perf_env__numa_node()
Date: Mon, 22 Jan 2024 15:58:23 -0800
Message-ID: <20240122235726.632008692@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 389799a7a1e86c55f38897e679762efadcc9dedd ]

To speed up cpu to node lookup, add perf_env__numa_node(), that creates
cpu array on the first lookup, that holds numa nodes for each stored
cpu.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexey Budankov <alexey.budankov@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Joe Mario <jmario@redhat.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20190904073415.723-3-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 9c51f8788b5d ("perf env: Avoid recursively taking env->bpf_progs.lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/env.c | 40 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/env.h |  6 ++++++
 2 files changed, 46 insertions(+)

diff --git a/tools/perf/util/env.c b/tools/perf/util/env.c
index ef64e197bc8d..2d517f377053 100644
--- a/tools/perf/util/env.c
+++ b/tools/perf/util/env.c
@@ -183,6 +183,7 @@ void perf_env__exit(struct perf_env *env)
 	zfree(&env->sibling_threads);
 	zfree(&env->pmu_mappings);
 	zfree(&env->cpu);
+	zfree(&env->numa_map);
 
 	for (i = 0; i < env->nr_numa_nodes; i++)
 		perf_cpu_map__put(env->numa_nodes[i].map);
@@ -342,3 +343,42 @@ const char *perf_env__arch(struct perf_env *env)
 
 	return normalize_arch(arch_name);
 }
+
+
+int perf_env__numa_node(struct perf_env *env, int cpu)
+{
+	if (!env->nr_numa_map) {
+		struct numa_node *nn;
+		int i, nr = 0;
+
+		for (i = 0; i < env->nr_numa_nodes; i++) {
+			nn = &env->numa_nodes[i];
+			nr = max(nr, perf_cpu_map__max(nn->map));
+		}
+
+		nr++;
+
+		/*
+		 * We initialize the numa_map array to prepare
+		 * it for missing cpus, which return node -1
+		 */
+		env->numa_map = malloc(nr * sizeof(int));
+		if (!env->numa_map)
+			return -1;
+
+		for (i = 0; i < nr; i++)
+			env->numa_map[i] = -1;
+
+		env->nr_numa_map = nr;
+
+		for (i = 0; i < env->nr_numa_nodes; i++) {
+			int tmp, j;
+
+			nn = &env->numa_nodes[i];
+			perf_cpu_map__for_each_cpu(j, tmp, nn->map)
+				env->numa_map[j] = i;
+		}
+	}
+
+	return cpu >= 0 && cpu < env->nr_numa_map ? env->numa_map[cpu] : -1;
+}
diff --git a/tools/perf/util/env.h b/tools/perf/util/env.h
index 37028215d4a5..ceddddace5cc 100644
--- a/tools/perf/util/env.h
+++ b/tools/perf/util/env.h
@@ -87,6 +87,10 @@ struct perf_env {
 		struct rb_root		btfs;
 		u32			btfs_cnt;
 	} bpf_progs;
+
+	/* For fast cpu to numa node lookup via perf_env__numa_node */
+	int			*numa_map;
+	int			 nr_numa_map;
 };
 
 enum perf_compress_type {
@@ -119,4 +123,6 @@ struct bpf_prog_info_node *perf_env__find_bpf_prog_info(struct perf_env *env,
 							__u32 prog_id);
 bool perf_env__insert_btf(struct perf_env *env, struct btf_node *btf_node);
 struct btf_node *perf_env__find_btf(struct perf_env *env, __u32 btf_id);
+
+int perf_env__numa_node(struct perf_env *env, int cpu);
 #endif /* __PERF_ENV_H */
-- 
2.43.0



