Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024303;
	b=ucokaYps9OkhM3HwB/96OxDi8JzRZoOsnbjE9TTFFDHQ48snnQcCnoWqASzMz3zg9e+d
	 HEs5mi9lNW9L4re9jyD0I+Cyirn4oxvn30iU7v0fPuAgSUXjhzzPuRLQCkLxJCRYh6D5M
	 NpVYhQ8KrYLReG+tTbl3b6Jdg4Rukw3VyHUs8TynBMHnNyJBBPDUnSpGiMLm+hfhc5wTE
	 9b1m2ivEPfpbPK+jUI2FBfaYUnEU3JtY1Gt6z9C/pF90PXvnixvNJRv75H0NqfDMKNjRT
	 VEeCVGXvZsEgGabiy7iUcYdZvuK+sO+PT35PcBYOJ8eTYD2mxOhsNZhIRPg+bzETHjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MEKzhDC7mXCBcB8vr6h12Fsr4DlF3rb7/QDzFFV7g84=;
	b=iCHWCAOfdNrmFfY0Sh+BEq8RXkg3RW0LCDtnRj6xtlPAKh6LKfLBVIvLMIZuYrlsBnJ5
	 jpE1WKktFE0iCVxiyArZOFhlLDH7vramRN44WCtxWO7KpGTU+Sa38HglVBDmYwx34fasp
	 dF4dTqGYSWwG9eJWpleShgaU67cZt0WhySJJl4pLZmsKrU79xZ1IiyYzZWAXxHvFOIs/n
	 MY95ycFW3XGH/Q0f+y6ZFeQOPgILCluACy4Ojb2vuYzxDbT0RpiWjRVdcxQWtqob64uRN
	 YeToiG1ghEzeU3S7hZVgC0iLLKfnZ7Q4/e66epqj2deY2YdMTXdB9gQoBgd59kgVNGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=txxhYcKO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E040A606A31C;
	Wed, 18 Nov 2026 17:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=txxhYcKO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A231F000C4;
	Wed, 18 Nov 2026 17:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024302;
	bh=MEKzhDC7mXCBcB8vr6h12Fsr4DlF3rb7/QDzFFV7g84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=txxhYcKOwJMzYLQ0wTPbtqHXUQkuLA/xXZSfeGT20gjg37FEomeOatkiB2vMWjmDa
	 FO3h/CdC5l3qObsdb4AkaZxduRE6mgm/Aa0U8KSvx1JFevePh/J6u84wZBcjwKN3Nx
	 3bsCh3hWhAKDS0LlEb2o0jq1zOKJtzmJdh4Eyf34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0676/2151] bpftool: Accept zero perf counter snapshots
Date: Wed, 18 Nov 2026 15:40:11 +0100
Message-ID: <20261118150146.434781520@linuxfoundation.org>
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

From: Mykyta Yatsenko <yatsenko@meta.com>

[ Upstream commit b2cf39f53478fd4b04d2f04585c21b3d91d7042f ]

A perf counter can be zero at fentry when PMU multiplexing has
not scheduled the event. Do not reject that sample.

Use enabled time to distinguish a successful snapshot. Read
directly into the per-CPU map value.

Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260916-bpftool_cyles_per_run-v4-1-f2de02c480d5@meta.com
Stable-dep-of: edc071d7b3aa ("bpftool: Fix sparse CPU IDs in prog profile")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/skeleton/profiler.bpf.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/tools/bpf/bpftool/skeleton/profiler.bpf.c b/tools/bpf/bpftool/skeleton/profiler.bpf.c
index f48c783cb9f7f..6685e7252fb52 100644
--- a/tools/bpf/bpftool/skeleton/profiler.bpf.c
+++ b/tools/bpf/bpftool/skeleton/profiler.bpf.c
@@ -45,28 +45,21 @@ const volatile __u32 num_metric = 1;
 SEC("fentry/XXX")
 int BPF_PROG(fentry_XXX)
 {
-	struct bpf_perf_event_value___local *ptrs[MAX_NUM_METRICS];
 	u32 key = bpf_get_smp_processor_id();
 	u32 i;
 
-	/* look up before reading, to reduce error */
 	for (i = 0; i < num_metric && i < MAX_NUM_METRICS; i++) {
+		struct bpf_perf_event_value___local *reading;
 		u32 flag = i;
-
-		ptrs[i] = bpf_map_lookup_elem(&fentry_readings, &flag);
-		if (!ptrs[i])
-			return 0;
-	}
-
-	for (i = 0; i < num_metric && i < MAX_NUM_METRICS; i++) {
-		struct bpf_perf_event_value___local reading;
 		int err;
 
-		err = bpf_perf_event_read_value(&events, key, (void *)&reading,
-						sizeof(reading));
+		reading = bpf_map_lookup_elem(&fentry_readings, &flag);
+		if (!reading)
+			return 0;
+		err = bpf_perf_event_read_value(&events, key, (void *)reading,
+						sizeof(*reading));
 		if (err)
 			return 0;
-		*(ptrs[i]) = reading;
 		key += num_cpu;
 	}
 
@@ -80,7 +73,7 @@ fexit_update_maps(u32 id, struct bpf_perf_event_value___local *after)
 
 	before = bpf_map_lookup_elem(&fentry_readings, &id);
 	/* only account samples with a valid fentry_reading */
-	if (before && before->counter) {
+	if (before && before->enabled) {
 		struct bpf_perf_event_value___local *accum;
 
 		diff.counter = after->counter - before->counter;
-- 
2.53.0



