Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017091;
	b=sH2JrblsHvALEqIFJurR7Ct6/bW+SRZleqHbMLmK3Ix9Bc0Pzc7QBoRPAQ5KJ5gqizPE
	 WQE7QHyDiwKlz6tXAG3UZBhQwQR6JsnQC3+o1I7OJrIxFWBH4wWjLIoZu+C/W9BiGuGNo
	 8rhZuYAxoCbzNp/jSHNsax952rNgFJRus/Zv216A00bKZD9NylTPlKiYmjifN/UBImpey
	 sjMkFsb+hZlz1+R2foe7bD2bRKlMXrsao87+wMZEdd5m+gZaygHjGG6HYW0ErM2zHktkG
	 XoEzlH9s1gn//4T/m3yAHLLfYBdgkAw8nkK9/YSxhNr6vhTdoXGVe57Pd/V2JBL/9ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6fWJdIGRbsuJZpHuOQFEvYsYjEO6xQ8pIVSTuVfNJbA=;
	b=XfEceGAsj2EMN01D8Omt3fOSA9wNFRySet+ar25G1QzTzVDu24XJsC4E1u22hmGbE+/u
	 G3YjQO8l20hfuVBKAVD69IT8KJWILXkdrTVW7O72uA55Ptc61Qmd/q4ViqeFdiMNxiiLF
	 0W72541Z9P6VOZH9vQxQaQqDbtY60Vaad/UV39CAKwdXQWXYfOXCinUVZs7ljAH0gAPhl
	 8L7jLy1sOya8ncZataeqcw6mbKigWqGn6cqoBebsfvT26pLxBV01Uh4s/a++hGB4WEBf8
	 MnTzajSufQczu2+QjkWikOgv+mShQrWTtjaf5Dym2W+QfRWmT6zQJS0StGzz/ExTC5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OMaKzN20;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9AF606A320;
	Wed, 18 Nov 2026 15:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OMaKzN20
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A78B1F000C4;
	Wed, 18 Nov 2026 15:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017091;
	bh=6fWJdIGRbsuJZpHuOQFEvYsYjEO6xQ8pIVSTuVfNJbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OMaKzN20cCWuywVzk/0TB4naRey+Y+Vyk9qFDpsKVKoch6+cE9KAkMxE44V6pOL4Y
	 9WVzXiSBPDclUxEfwBN/D8a2nXWzPy2TcEpctS3AiIbV52xqzDVengGma0h/4SdLei
	 TxbCeYbeOA5G5+8qOYa+lvqf5NIRccws5VheGJ6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0761/2651] bpftool: Group profile events by CPU
Date: Wed, 18 Nov 2026 15:33:21 +0100
Message-ID: <20261118150315.277177745@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mykyta Yatsenko <yatsenko@meta.com>

[ Upstream commit 6b5fe4b6d5ae5fac328416b061e5416d68aec762 ]

Independently scheduled perf events can cover different intervals,
making derived ratios inconsistent.

Open one event group per CPU and enable it only after all selected
metrics have joined.

Fail the profile setup when a selected event cannot join its group.

Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260916-bpftool_cyles_per_run-v4-2-f2de02c480d5@meta.com
Stable-dep-of: edc071d7b3aa ("bpftool: Fix sparse CPU IDs in prog profile")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/prog.c | 87 ++++++++++++++++++++++++----------------
 1 file changed, 52 insertions(+), 35 deletions(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 8c2f9255b36d7..8cd10186826dc 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -2350,7 +2350,7 @@ static char *profile_tgt_name;
 static int *profile_perf_events;
 static int profile_perf_event_cnt;
 
-static void profile_close_perf_events(struct profiler_bpf *obj)
+static void profile_close_perf_events(void)
 {
 	int i;
 
@@ -2361,61 +2361,78 @@ static void profile_close_perf_events(struct profiler_bpf *obj)
 	profile_perf_event_cnt = 0;
 }
 
-static int profile_open_perf_event(int mid, int cpu, int map_fd)
+static int profile_open_perf_event(int mid, int cpu,
+				   int map_fd, int group_fd, __u32 map_key)
 {
+	struct perf_event_attr attr = metrics[mid].attr;
+	bool group_leader = group_fd < 0;
 	int pmu_fd;
+	int err;
 
-	pmu_fd = syscall(__NR_perf_event_open, &metrics[mid].attr,
-			 -1 /*pid*/, cpu, -1 /*group_fd*/, 0);
+	attr.disabled = group_leader;
+	pmu_fd = syscall(__NR_perf_event_open, &attr, -1 /* pid */, cpu,
+			 group_fd, 0);
 	if (pmu_fd < 0) {
-		if (errno == ENODEV) {
-			p_info("cpu %d may be offline, skip %s profiling.",
-				cpu, metrics[mid].name);
-			profile_perf_event_cnt++;
-			return 0;
-		}
-		return -1;
+		err = -errno;
+		if (errno == ENODEV && group_leader)
+			p_info("cpu %d may be offline, skip profiling.", cpu);
+		return err;
 	}
 
-	if (bpf_map_update_elem(map_fd,
-				&profile_perf_event_cnt,
-				&pmu_fd, BPF_ANY) ||
-	    ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0)) {
+	if (bpf_map_update_elem(map_fd, &map_key, &pmu_fd, BPF_ANY)) {
+		err = -errno;
 		close(pmu_fd);
-		return -1;
+		return err;
 	}
 
 	profile_perf_events[profile_perf_event_cnt++] = pmu_fd;
-	return 0;
+	return pmu_fd;
 }
 
 static int profile_open_perf_events(struct profiler_bpf *obj)
 {
+	__u32 num_cpu = obj->rodata->num_cpu;
+	__u32 map_key;
 	unsigned int cpu, m;
-	int map_fd;
+	int group_fd, map_fd, pmu_fd;
+	int err;
 
-	profile_perf_events = calloc(
-		obj->rodata->num_cpu * obj->rodata->num_metric, sizeof(int));
+	profile_perf_events = calloc(num_cpu * obj->rodata->num_metric,
+				     sizeof(*profile_perf_events));
 	if (!profile_perf_events) {
 		p_err("failed to allocate memory for perf_event array: %s",
 		      strerror(errno));
-		return -1;
+		return -ENOMEM;
 	}
+
 	map_fd = bpf_map__fd(obj->maps.events);
-	if (map_fd < 0) {
-		p_err("failed to get fd for events map");
-		return -1;
-	}
+	for (cpu = 0; cpu < num_cpu; cpu++) {
+		group_fd = -1;
+		map_key = cpu;
+		for (m = 0; m < ARRAY_SIZE(metrics); m++) {
+			if (!metrics[m].selected)
+				continue;
 
-	for (m = 0; m < ARRAY_SIZE(metrics); m++) {
-		if (!metrics[m].selected)
-			continue;
-		for (cpu = 0; cpu < obj->rodata->num_cpu; cpu++) {
-			if (profile_open_perf_event(m, cpu, map_fd)) {
-				p_err("failed to create event %s on cpu %u",
-				      metrics[m].name, cpu);
-				return -1;
+			pmu_fd = profile_open_perf_event(m, cpu, map_fd, group_fd,
+						     map_key);
+			if (pmu_fd == -ENODEV && group_fd < 0)
+				break;
+			if (pmu_fd < 0) {
+				p_err("failed to add event %s to group on CPU %u: %s",
+				      metrics[m].name, cpu, strerror(-pmu_fd));
+				return pmu_fd;
 			}
+			if (group_fd < 0)
+				group_fd = pmu_fd;
+			map_key += num_cpu;
+		}
+		if (group_fd < 0)
+			continue;
+		if (ioctl(group_fd, PERF_EVENT_IOC_ENABLE, PERF_IOC_FLAG_GROUP)) {
+			err = -errno;
+			p_err("failed to enable perf event group on CPU %u: %s",
+			      cpu, strerror(-err));
+			return err;
 		}
 	}
 	return 0;
@@ -2423,7 +2440,7 @@ static int profile_open_perf_events(struct profiler_bpf *obj)
 
 static void profile_print_and_cleanup(void)
 {
-	profile_close_perf_events(profile_obj);
+	profile_close_perf_events();
 	profile_read_values(profile_obj);
 	profile_print_readings();
 	profiler_bpf__destroy(profile_obj);
@@ -2529,7 +2546,7 @@ static int do_profile(int argc, char **argv)
 	return 0;
 
 out:
-	profile_close_perf_events(profile_obj);
+	profile_close_perf_events();
 	if (profile_obj)
 		profiler_bpf__destroy(profile_obj);
 	close(profile_tgt_fd);
-- 
2.53.0



