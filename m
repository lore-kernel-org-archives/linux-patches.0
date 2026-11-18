Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017088;
	b=uAQ8QjbLo9NP/f0BeLFh1egerQFj12EgV/9qOcjqUQ5B1mgR2W/VldbrFJVcLnAShjUX
	 233JGq/bpvUbsx9eeD9kKtluIRo6qBDJjxTcfJzuB2lzgErvvwGyOOMRllMjmWw1YiX2/
	 wC5ts/1n+GTGf+eAaW/toWSlEkreF26g6/GuAX77ITn2w0eK7ExE7IZ+fe+V/gEtKf7/r
	 OJgZbJIC61XqHyIy/K8EvbSDH6esKEWWFGhXxTHvTIOdvayowYhQZthx7SHGJ8TD/Rwrx
	 9HI5alYxtehfePtMqBcW3C6J3FRtCDJjOzXqt7InrbO0tNOcQYWgVYrx8QfgvGiAryw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aYS6bRd2klINXhqIVgAnKhee2xLuCa6LEj2MI6Xuznk=;
	b=RGaS4tbZOqcxWnKoMrKe/ARKh8kYnYo27Oh8YY7fvs/PefZWFVl2ClGr8CZtXJXTMuzZ
	 ssh2x9gAya4rmJaY5H9EVyMsG0qTG5u2GT0HamoLT7hAB+RScz4bB7ufBdWJqb4q49YWV
	 P10E9pgWIThzSip2ve/prw8J6xwarLepVvwCQbrGiP5lI0z47Av9YJ8zVIbJXN8HGiWYw
	 ae1lTZXzhJguPpz+UUKya8GBgk2n6BnSdTPkfbcNIhWqRrWf4TBp/kzxkJpgP9NS7CM/2
	 XSVkVTeSc7tE+e0t/pRzty5089NKIu92QnErINsPi+QBOkzpw6BVWOU/iZGcUis5o8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ujdtkGr4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93C0606A33D;
	Wed, 18 Nov 2026 15:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ujdtkGr4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378841F000C4;
	Wed, 18 Nov 2026 15:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017088;
	bh=aYS6bRd2klINXhqIVgAnKhee2xLuCa6LEj2MI6Xuznk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ujdtkGr4uSceEtvzEMjvVDrQef1Bp2HZvM95Gt316DcK0IOWorn1/OH2OM4uSELSP
	 BreRbmmjoX12Mmtu/aQKFWlOVBUGcXvoFhGBfsqLkkjY6xQVbNlNiBK8Qq41DcF+tz
	 9ieydXp9NK66KZ+LsqnOE9nF0DYbdkcaRW9GHZp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0760/2651] bpftool: Accept zero perf counter snapshots
Date: Wed, 18 Nov 2026 15:33:20 +0100
Message-ID: <20261118150315.240248696@linuxfoundation.org>
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



