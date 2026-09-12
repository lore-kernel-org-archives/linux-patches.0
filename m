Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2561F399356;
	Sat, 12 Sep 2026 18:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238256; cv=none; b=n+d1AEWGW62DoKYKa7OSx+FXam/AU+ELmlAw7Vq69DK0a7LD38m9zNA57D5/yXm6qgVJepEoe2Y9RUqcKaX4d8KcpCvQJ/tl8kCWqC7YmKV0p8BcwdorWsU1fpVmxlIV06lpdduQdolMg4CHaxrVLd0oeNr3a1ITaSGZeqx78rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238256; c=relaxed/simple;
	bh=gXsgov3MQLWQ0Df8bsT0oqapioVDhXHjHndHOA/7TY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SI/ASg5V4/96fAV3aiC+x8T3f27gLC6TnvjEuIjV4mhmwR6EC87z5Iv4WmgMho+dAWJJa9nF/W3jF1d6MEhgQsilAnPKkA3LEVDgpA9zpvOVDNdw8vdJc1dDyVhOAXR25wmxcJ0pW0btgYvJO8kzwVi7D97S4VtJtahA2MiY6Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=saeotf9K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="saeotf9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B316E1F000FF;
	Sat, 12 Sep 2026 18:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238252;
	bh=Y9VWe7bdHXGpVohvFBYOS9n5NUjZzFzHZ+Pe34NlDhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=saeotf9KeYKXcTzfSUXUv09IdbXGwH2hhIJTD6KVaYZKuKApQulYw6cz9vfIF5hv3
	 5Ts/jia8RkrfRn9uOEjFM9gO4cQP3e3WEKXnO0Ts8eoaLNKshM2CdBp4uSmcNbsn4i
	 ejDA7qKbUk6ybhe9abmG0pVWUaVvAVSU0qK6VqNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 424/935] bpftool: Update btf_dump__new() and perf_buffer__new_raw() calls
Date: Sat, 12 Sep 2026 08:57:34 +0200
Message-ID: <20260912065536.549009682@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 164b04f27fbd769f57905dfddd2a8953974eeef4 ]

Use v1.0-compatible variants of btf_dump and perf_buffer "constructors".
This is also a demonstration of reusing struct perf_buffer_raw_opts as
OPTS-style option struct for new perf_buffer__new_raw() API.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20211111053624.190580-10-andrii@kernel.org
Stable-dep-of: 66d7e39e49b0 ("tools/bpf/bpftool: Reset vmlinux BTF after map commands")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/btf.c           | 2 +-
 tools/bpf/bpftool/gen.c           | 2 +-
 tools/bpf/bpftool/map_perf_ring.c | 9 +++------
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index f7e5ff3586c9b..d4c7cd3025171 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -410,7 +410,7 @@ static int dump_btf_c(const struct btf *btf,
 	struct btf_dump *d;
 	int err = 0, i;
 
-	d = btf_dump__new(btf, NULL, NULL, btf_dump_printf);
+	d = btf_dump__new(btf, btf_dump_printf, NULL, NULL);
 	if (IS_ERR(d))
 		return PTR_ERR(d);
 
diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 07fa502a4ac15..25efbb868e9ea 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -197,7 +197,7 @@ static int codegen_datasecs(struct bpf_object *obj, const char *obj_name)
 	struct btf_dump *d;
 	int i, err = 0;
 
-	d = btf_dump__new(btf, NULL, NULL, codegen_btf_dump_printf);
+	d = btf_dump__new(btf, codegen_btf_dump_printf, NULL, NULL);
 	if (IS_ERR(d))
 		return PTR_ERR(d);
 
diff --git a/tools/bpf/bpftool/map_perf_ring.c b/tools/bpf/bpftool/map_perf_ring.c
index 825f29f93a57a..241dd3bafd24d 100644
--- a/tools/bpf/bpftool/map_perf_ring.c
+++ b/tools/bpf/bpftool/map_perf_ring.c
@@ -125,7 +125,7 @@ int do_event_pipe(int argc, char **argv)
 		.wakeup_events = 1,
 	};
 	struct bpf_map_info map_info = {};
-	struct perf_buffer_raw_opts opts = {};
+	LIBBPF_OPTS(perf_buffer_raw_opts, opts);
 	struct event_pipe_ctx ctx = {
 		.all_cpus = true,
 		.cpu = -1,
@@ -191,14 +191,11 @@ int do_event_pipe(int argc, char **argv)
 		ctx.idx = 0;
 	}
 
-	opts.attr = &perf_attr;
-	opts.event_cb = print_bpf_output;
-	opts.ctx = &ctx;
 	opts.cpu_cnt = ctx.all_cpus ? 0 : 1;
 	opts.cpus = &ctx.cpu;
 	opts.map_keys = &ctx.idx;
-
-	pb = perf_buffer__new_raw(map_fd, MMAP_PAGE_CNT, &opts);
+	pb = perf_buffer__new_raw(map_fd, MMAP_PAGE_CNT, &perf_attr,
+				  print_bpf_output, &ctx, &opts);
 	err = libbpf_get_error(pb);
 	if (err) {
 		p_err("failed to create perf buffer: %s (%d)",
-- 
2.53.0



