Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024311;
	b=YId4rz7Fer4fh5p7IheHkga136ZKQ3r3AgGKUQ4ZSK1EW1PYNtxde/Hb/mu9G+OtXg8x
	 +H15KdFq4RaddNPceZ72UIpILBLGs08kD9jHX0LQV3TZvTEJBpL5QNtwVScmVC7Qxanrd
	 BEGgbRiyh6eYcMweuYJcbI5vLJPa2Lo0YKV37i7egP6lb4VSZz5qK2ZRQf7edH18jBDwL
	 ceYVEr/WYNfDGQ2BoXdv1hoKOebgJepJsEi7XF/m/KF2BkLhioNQUQDYaRLntu85UisAw
	 caUb0BAyOEjHu4B+3hQded8xzDWAaItCh+tebhVoDwhUNkICiE0UY+J1K0Y4XquZQHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4d3QULYwHI5kaYj3U67bU3bW7BHNrL41VuTm//sg+Zo=;
	b=tMdD5ZCBtzqSokh0wZggx1I25p5MJ6WFjH8fGZQ9c387L8YGOgGIt7vdb4x8tPG0PySp
	 eB5aV6wUq83Zntx4PbeBRmKepysqmOyzggVYXe8egTGJkdupVTbdDtUeZcMWc+/hKdc3S
	 F3iAPAJW5Vkm6XmNf1vCA4wccaf2Yi9vS36gbsjOp4dE00FViCiMdqM4MkGKuJPxn8Sey
	 7r9iWdPy2LKQZwN5xXfRv0E6UBh11N8BM2pveO64mOBrasLZXOsEBjkzufu14v7RnlVaS
	 DllABdqnz51v+NvkB+1wxaTPxbnk+BHEVKLph83onuSLOR5Km514SRYTgieK5H7vciw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q2u4JF69;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC6D606A320;
	Wed, 18 Nov 2026 17:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q2u4JF69
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844821F000C4;
	Wed, 18 Nov 2026 17:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024311;
	bh=4d3QULYwHI5kaYj3U67bU3bW7BHNrL41VuTm//sg+Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q2u4JF69hMCp1i4p6aAl5vfr7f8XrFkpUXmK6+oTnje0G7Qp3Frwkm/ZRzWaXuKhF
	 AHmCAVHq+jJRI3tR7xbjtkUwzTv/mbxduVTwV6XrmPEBrdmqQlVRH99pCfXJFrAWMK
	 222aC4ml1/uaimu0ONu4Vw5iO13a9ZjVpPwRXXVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0679/2151] bpftool: Fix sparse CPU IDs in prog profile
Date: Wed, 18 Nov 2026 15:40:14 +0100
Message-ID: <20261118150146.548455860@linuxfoundation.org>
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

From: Hui Su <sh_def@163.com>

[ Upstream commit edc071d7b3aaae8047a12c21b02cc537557aacee ]

bpftool prog profile currently treats the number of possible CPUs as
both the logical CPU ID range and the stride of the perf event array.
That misses valid logical CPUs when the possible CPU mask is sparse,
such as 0,2-3, and can use incorrect PERF_EVENT_ARRAY keys.

Keep the compact possible CPU count for per-CPU result buffers, while
enumerating the actual logical CPU IDs when creating per-CPU perf event
groups. Use the maximum logical CPU ID plus one as the metric stride in
the PERF_EVENT_ARRAY.

This keeps the current per-CPU event grouping intact while separating
the compact per-CPU buffer index from the logical CPU ID and event-array
key. Report the logical CPU ID when a per-CPU event was not counted.

Fixes: 47c09d6a9f67 ("bpftool: Introduce "prog profile" command")
Signed-off-by: Hui Su <sh_def@163.com>
Link: https://lore.kernel.org/bpf/20260813160858.1042834-3-sh_def@163.com/
Link: https://lore.kernel.org/bpf/20260923004243.969919-3-sh_def@163.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/prog.c                  | 51 +++++++++++++++--------
 tools/bpf/bpftool/skeleton/profiler.bpf.c |  8 ++--
 2 files changed, 37 insertions(+), 22 deletions(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 00c161f9ee61e..5b9c736731085 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -2164,6 +2164,9 @@ struct profile_metric {
 };
 
 static __u64 profile_total_count;
+static int profile_cpu_cnt;
+static int *profile_cpu_ids;
+static int profile_cpu_id_span;
 
 #define MAX_NUM_PROFILE_METRICS 4
 
@@ -2200,7 +2203,7 @@ static int profile_parse_metrics(int argc, char **argv)
 
 static int profile_read_values(struct profiler_bpf *obj)
 {
-	__u32 m, cpu, num_cpu = obj->rodata->num_cpu;
+	__u32 m, cpu, num_cpu = profile_cpu_cnt;
 	int reading_map_fd, count_map_fd;
 	__u64 counts[num_cpu];
 	__u32 key = 0;
@@ -2235,8 +2238,8 @@ static int profile_read_values(struct profiler_bpf *obj)
 		for (cpu = 0; cpu < num_cpu; cpu++) {
 			val = &values[cpu];
 			if (counts[cpu] && !val->running) {
-				p_err("perf event %s was not counted on CPU %u",
-				      metrics[m].name, cpu);
+				p_err("perf event %s was not counted on CPU %d",
+				      metrics[m].name, profile_cpu_ids[cpu]);
 				return -EAGAIN;
 			}
 			metrics[m].val.enabled += val->enabled;
@@ -2394,6 +2397,7 @@ static void profile_close_perf_events(void)
 		close(profile_perf_events[i]);
 
 	free(profile_perf_events);
+	profile_perf_events = NULL;
 	profile_perf_event_cnt = 0;
 }
 
@@ -2427,13 +2431,12 @@ static int profile_open_perf_event(int mid, int cpu,
 
 static int profile_open_perf_events(struct profiler_bpf *obj)
 {
-	__u32 num_cpu = obj->rodata->num_cpu;
 	__u32 map_key;
 	unsigned int cpu, m;
 	int group_fd, map_fd, pmu_fd;
 	int err;
 
-	profile_perf_events = calloc(num_cpu * obj->rodata->num_metric,
+	profile_perf_events = calloc(profile_cpu_cnt * obj->rodata->num_metric,
 				     sizeof(*profile_perf_events));
 	if (!profile_perf_events) {
 		p_err("failed to allocate memory for perf_event array: %s",
@@ -2442,32 +2445,34 @@ static int profile_open_perf_events(struct profiler_bpf *obj)
 	}
 
 	map_fd = bpf_map__fd(obj->maps.events);
-	for (cpu = 0; cpu < num_cpu; cpu++) {
+	for (cpu = 0; cpu < (unsigned int)profile_cpu_cnt; cpu++) {
+		int cpu_id = profile_cpu_ids[cpu];
+
 		group_fd = -1;
-		map_key = cpu;
+		map_key = cpu_id;
 		for (m = 0; m < ARRAY_SIZE(metrics); m++) {
 			if (!metrics[m].selected)
 				continue;
 
-			pmu_fd = profile_open_perf_event(m, cpu, map_fd, group_fd,
+			pmu_fd = profile_open_perf_event(m, cpu_id, map_fd, group_fd,
 						     map_key);
 			if (pmu_fd == -ENODEV && group_fd < 0)
 				break;
 			if (pmu_fd < 0) {
-				p_err("failed to add event %s to group on CPU %u: %s",
-				      metrics[m].name, cpu, strerror(-pmu_fd));
+				p_err("failed to add event %s to group on CPU %d: %s",
+				      metrics[m].name, cpu_id, strerror(-pmu_fd));
 				return pmu_fd;
 			}
 			if (group_fd < 0)
 				group_fd = pmu_fd;
-			map_key += num_cpu;
+			map_key += profile_cpu_id_span;
 		}
 		if (group_fd < 0)
 			continue;
 		if (ioctl(group_fd, PERF_EVENT_IOC_ENABLE, PERF_IOC_FLAG_GROUP)) {
 			err = -errno;
-			p_err("failed to enable perf event group on CPU %u: %s",
-			      cpu, strerror(-err));
+			p_err("failed to enable perf event group on CPU %d: %s",
+			      cpu_id, strerror(-err));
 			return err;
 		}
 	}
@@ -2486,6 +2491,10 @@ static int profile_print_and_cleanup(void)
 
 	close(profile_tgt_fd);
 	free(profile_tgt_name);
+	free(profile_cpu_ids);
+	profile_cpu_ids = NULL;
+	profile_cpu_cnt = 0;
+	profile_cpu_id_span = 0;
 	return err;
 }
 
@@ -2496,7 +2505,7 @@ static void int_exit(int signo)
 
 static int do_profile(int argc, char **argv)
 {
-	int num_metric, num_cpu, err = -1;
+	int num_metric, err = -1;
 	struct bpf_program *prog;
 	unsigned long duration;
 	char *endptr;
@@ -2527,11 +2536,12 @@ static int do_profile(int argc, char **argv)
 	if (num_metric <= 0)
 		goto out;
 
-	num_cpu = libbpf_num_possible_cpus();
-	if (num_cpu <= 0) {
+	profile_cpu_cnt = get_possible_cpu_ids(&profile_cpu_ids);
+	if (profile_cpu_cnt <= 0) {
 		p_err("failed to identify number of CPUs");
 		goto out;
 	}
+	profile_cpu_id_span = profile_cpu_ids[profile_cpu_cnt - 1] + 1;
 
 	profile_obj = profiler_bpf__open();
 	if (!profile_obj) {
@@ -2539,11 +2549,12 @@ static int do_profile(int argc, char **argv)
 		goto out;
 	}
 
-	profile_obj->rodata->num_cpu = num_cpu;
 	profile_obj->rodata->num_metric = num_metric;
+	profile_obj->rodata->cpu_id_span = profile_cpu_id_span;
 
 	/* adjust map sizes */
-	bpf_map__set_max_entries(profile_obj->maps.events, num_metric * num_cpu);
+	bpf_map__set_max_entries(profile_obj->maps.events,
+				 num_metric * profile_cpu_id_span);
 	bpf_map__set_max_entries(profile_obj->maps.fentry_readings, num_metric);
 	bpf_map__set_max_entries(profile_obj->maps.accum_readings, num_metric);
 	bpf_map__set_max_entries(profile_obj->maps.counts, 1);
@@ -2589,6 +2600,10 @@ static int do_profile(int argc, char **argv)
 		profiler_bpf__destroy(profile_obj);
 	close(profile_tgt_fd);
 	free(profile_tgt_name);
+	free(profile_cpu_ids);
+	profile_cpu_ids = NULL;
+	profile_cpu_cnt = 0;
+	profile_cpu_id_span = 0;
 	return err;
 }
 
diff --git a/tools/bpf/bpftool/skeleton/profiler.bpf.c b/tools/bpf/bpftool/skeleton/profiler.bpf.c
index 6685e7252fb52..0d47a9bdc5b43 100644
--- a/tools/bpf/bpftool/skeleton/profiler.bpf.c
+++ b/tools/bpf/bpftool/skeleton/profiler.bpf.c
@@ -10,7 +10,7 @@ struct bpf_perf_event_value___local {
 	__u64 running;
 } __attribute__((preserve_access_index));
 
-/* map of perf event fds, num_cpu * num_metric entries */
+/* map of perf event fds, cpu_id_span * num_metric entries */
 struct {
 	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
 	__uint(key_size, sizeof(u32));
@@ -38,8 +38,8 @@ struct {
 	__uint(value_size, sizeof(u64));
 } counts SEC(".maps");
 
-const volatile __u32 num_cpu = 1;
 const volatile __u32 num_metric = 1;
+const volatile __u32 cpu_id_span = 1;
 #define MAX_NUM_METRICS 4
 
 SEC("fentry/XXX")
@@ -60,7 +60,7 @@ int BPF_PROG(fentry_XXX)
 						sizeof(*reading));
 		if (err)
 			return 0;
-		key += num_cpu;
+		key += cpu_id_span;
 	}
 
 	return 0;
@@ -100,7 +100,7 @@ int BPF_PROG(fexit_XXX)
 
 	/* read all events before updating the maps, to reduce error */
 	for (i = 0; i < num_metric && i < MAX_NUM_METRICS; i++) {
-		err = bpf_perf_event_read_value(&events, cpu + i * num_cpu,
+		err = bpf_perf_event_read_value(&events, cpu + i * cpu_id_span,
 						(void *)(readings + i),
 						sizeof(*readings));
 		if (err)
-- 
2.53.0



