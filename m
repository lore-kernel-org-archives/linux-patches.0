Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032303;
	b=m58qFj+++3H8lll7IUnDcmREOjdWnzgPEI4Z63aKHZKqvMfOEquKnwjts+6WHqyM1qvK
	 rt7zuH3gleUfOn466P1OCvD9f8gFIotBRESbH1OQQbOJxkunkvhD19tv2jMObG0w9G+ru
	 RvoZJA1Wwqjg3NzraLGGwylYUZqzD+EZZB+8S8ZXmNmN/PT/sogZQKt1/tVrP4vcnH+6c
	 hkLenXti8MMPKseogZ/zowBG6V9y+Re5UMux02zcd8xZb7nnXzufAWUbzRlr88V/3mKNE
	 L0dYmRqFMMP4WWy+/HvrIYL/bKxOl44JDVx1MNeNfXgIvJNWujLja7GbYw3FtmkHp7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1bBKSCxIcq1r887cpRK6dU3oS+U54SzLJAvRVPBvC5s=;
	b=GdFDewekoStVWtA5S7gFHahYHiZ6VfA9yS7CY90AWJ7Jq+hUQBf4RGLLBlD4/4dfc7M6
	 ip7ALzWFLLqqA3ZJwcw0M2zTQWwcPcCX5BGBnxOxG7wEWEtALF0ynNc6/lNwAd7/0YWZO
	 VLXYKkKnTvUijNSEF32nV5AhjVFXtV/A4MD70pYkBnsvFieXzf7AfmYCXM6jjriVqX50o
	 v6GBhnJkcxjwDnYc/dNh3LSHh6a7WNlw47SK0QwKv5kKFIBKqYl37WgpclPRikycY1OsK
	 79/20mNnoqmwzfQ81/VTessz/zwqNr4Mh1NUreuhhreYiLpELHdvoVAsgUD+Da2yGxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="VIt/84Tr";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9610606A33F;
	Wed, 18 Nov 2026 20:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VIt/84Tr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A531F000C4;
	Wed, 18 Nov 2026 20:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032302;
	bh=1bBKSCxIcq1r887cpRK6dU3oS+U54SzLJAvRVPBvC5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VIt/84TrOyys0k/d1bLGY7dq3Eo0NbgXztaXr9AOU3ERlVt1VQkW+b9WIQmXx08Lv
	 6rCzoR9FvJCehAtB3XUIZaSK8eigY5gk7bkAHKovR/LaDUVrO5Z3G8bQe1nxM+CHXA
	 Mn6uES30khobJD83LwcZ70ykluasDgZWXNbiYUik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1363/1756] bpf: Add show_fdinfo for perf_event
Date: Wed, 18 Nov 2026 15:58:10 +0100
Message-ID: <20261118150103.535221836@linuxfoundation.org>
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

From: Tao Chen <chen.dylane@linux.dev>

[ Upstream commit 97ebac58865dec1bca31140252386daefef1654f ]

After commit 1b715e1b0ec5 ("bpf: Support ->fill_link_info for perf_event") add
perf_event info, we can also show the info with the method of cat /proc/[fd]/fdinfo.

kprobe fdinfo:
link_type:	perf
link_id:	10
prog_tag:	bcf7977d3b93787c
prog_id:	20
name:	bpf_fentry_test1
offset:	0x0
missed:	0
addr:	0xffffffffa28a2904
event_type:	kprobe
cookie:	3735928559

uprobe fdinfo:
link_type:	perf
link_id:	13
prog_tag:	bcf7977d3b93787c
prog_id:	21
name:	/proc/self/exe
offset:	0x63dce4
ref_ctr_offset:	0x33eee2a
event_type:	uprobe
cookie:	3735928559

tracepoint fdinfo:
link_type:	perf
link_id:	11
prog_tag:	bcf7977d3b93787c
prog_id:	22
tp_name:	sched_switch
event_type:	tracepoint
cookie:	3735928559

perf_event fdinfo:
link_type:	perf
link_id:	12
prog_tag:	bcf7977d3b93787c
prog_id:	23
type:	1
config:	2
event_type:	event
cookie:	3735928559

Signed-off-by: Tao Chen <chen.dylane@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250606150258.3385166-1-chen.dylane@linux.dev
Stable-dep-of: 3ccd700543f1 ("bpf: Read the probe of a perf event under event_mutex")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 120 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 120 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 9ebb51a32ff36..a90f77da92368 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3663,6 +3663,32 @@ static int bpf_perf_link_fill_kprobe(const struct perf_event *event,
 	info->perf_event.kprobe.cookie = event->bpf_cookie;
 	return 0;
 }
+
+static void bpf_perf_link_fdinfo_kprobe(const struct perf_event *event,
+					struct seq_file *seq)
+{
+	const char *name;
+	int err;
+	u32 prog_id, type;
+	u64 offset, addr;
+	unsigned long missed;
+
+	err = bpf_get_perf_event_info(event, &prog_id, &type, &name,
+				      &offset, &addr, &missed);
+	if (err)
+		return;
+
+	seq_printf(seq,
+		   "name:\t%s\n"
+		   "offset:\t%#llx\n"
+		   "missed:\t%lu\n"
+		   "addr:\t%#llx\n"
+		   "event_type:\t%s\n"
+		   "cookie:\t%llu\n",
+		   name, offset, missed, addr,
+		   type == BPF_FD_TYPE_KRETPROBE ?  "kretprobe" : "kprobe",
+		   event->bpf_cookie);
+}
 #endif
 
 #ifdef CONFIG_UPROBE_EVENTS
@@ -3690,6 +3716,31 @@ static int bpf_perf_link_fill_uprobe(const struct perf_event *event,
 	info->perf_event.uprobe.cookie = event->bpf_cookie;
 	return 0;
 }
+
+static void bpf_perf_link_fdinfo_uprobe(const struct perf_event *event,
+					struct seq_file *seq)
+{
+	const char *name;
+	int err;
+	u32 prog_id, type;
+	u64 offset, ref_ctr_offset;
+	unsigned long missed;
+
+	err = bpf_get_perf_event_info(event, &prog_id, &type, &name,
+				      &offset, &ref_ctr_offset, &missed);
+	if (err)
+		return;
+
+	seq_printf(seq,
+		   "name:\t%s\n"
+		   "offset:\t%#llx\n"
+		   "ref_ctr_offset:\t%#llx\n"
+		   "event_type:\t%s\n"
+		   "cookie:\t%llu\n",
+		   name, offset, ref_ctr_offset,
+		   type == BPF_FD_TYPE_URETPROBE ?  "uretprobe" : "uprobe",
+		   event->bpf_cookie);
+}
 #endif
 
 static int bpf_perf_link_fill_probe(const struct perf_event *event,
@@ -3758,10 +3809,79 @@ static int bpf_perf_link_fill_link_info(const struct bpf_link *link,
 	}
 }
 
+static void bpf_perf_event_link_show_fdinfo(const struct perf_event *event,
+					    struct seq_file *seq)
+{
+	seq_printf(seq,
+		   "type:\t%u\n"
+		   "config:\t%llu\n"
+		   "event_type:\t%s\n"
+		   "cookie:\t%llu\n",
+		   event->attr.type, event->attr.config,
+		   "event", event->bpf_cookie);
+}
+
+static void bpf_tracepoint_link_show_fdinfo(const struct perf_event *event,
+					    struct seq_file *seq)
+{
+	int err;
+	const char *name;
+	u32 prog_id;
+
+	err = bpf_get_perf_event_info(event, &prog_id, NULL, &name, NULL,
+				      NULL, NULL);
+	if (err)
+		return;
+
+	seq_printf(seq,
+		   "tp_name:\t%s\n"
+		   "event_type:\t%s\n"
+		   "cookie:\t%llu\n",
+		   name, "tracepoint", event->bpf_cookie);
+}
+
+static void bpf_probe_link_show_fdinfo(const struct perf_event *event,
+				       struct seq_file *seq)
+{
+#ifdef CONFIG_KPROBE_EVENTS
+	if (event->tp_event->flags & TRACE_EVENT_FL_KPROBE)
+		return bpf_perf_link_fdinfo_kprobe(event, seq);
+#endif
+
+#ifdef CONFIG_UPROBE_EVENTS
+	if (event->tp_event->flags & TRACE_EVENT_FL_UPROBE)
+		return bpf_perf_link_fdinfo_uprobe(event, seq);
+#endif
+}
+
+static void bpf_perf_link_show_fdinfo(const struct bpf_link *link,
+				      struct seq_file *seq)
+{
+	struct bpf_perf_link *perf_link;
+	const struct perf_event *event;
+
+	perf_link = container_of(link, struct bpf_perf_link, link);
+	event = perf_get_event(perf_link->perf_file);
+	if (IS_ERR(event))
+		return;
+
+	switch (event->prog->type) {
+	case BPF_PROG_TYPE_PERF_EVENT:
+		return bpf_perf_event_link_show_fdinfo(event, seq);
+	case BPF_PROG_TYPE_TRACEPOINT:
+		return bpf_tracepoint_link_show_fdinfo(event, seq);
+	case BPF_PROG_TYPE_KPROBE:
+		return bpf_probe_link_show_fdinfo(event, seq);
+	default:
+		return;
+	}
+}
+
 static const struct bpf_link_ops bpf_perf_link_lops = {
 	.release = bpf_perf_link_release,
 	.dealloc = bpf_perf_link_dealloc,
 	.fill_link_info = bpf_perf_link_fill_link_info,
+	.show_fdinfo = bpf_perf_link_show_fdinfo,
 };
 
 static int bpf_perf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
-- 
2.53.0



