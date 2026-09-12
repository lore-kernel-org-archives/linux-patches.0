Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD37047277D;
	Sat, 12 Sep 2026 16:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229030; cv=none; b=QLS8k/pvJ2SsLk+WPNX7y/1w8gvQJXaInCJSlNmwB3T09Yl3zNljFly+L6lntGLwBBNXeNYSI3G7wQ5pZc2bCUdjh8a/i297nqrJna4HO1BLLNZosvsUeOZc92uYFyW581gdDKOusmnLZtD0jzCETFNaUqPw5XGgYytT7sqyH44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229030; c=relaxed/simple;
	bh=ZIRq3jM9Eex6sScKmq6v4geTD0bN+GOJ4Pim8KPCJQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itTCH2J+fNhA1VSQ2qnRzRVihdhlfrPbzjlCcEmM39NFcKMzuF60AJgbPWth3ih9m3BspaHtZRgA38jbkT5Z/naUUAWi4DxJNISpj0cAIUgcAQ0xyxYce0Xd5a3VFAVy/1pg2rlKrffYtvikO3J1I+Vd93NyY9gzRL6PAaD4b6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SiZvMhz6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SiZvMhz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E471F000FF;
	Sat, 12 Sep 2026 16:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229027;
	bh=UAmMxKZR36sb7J8hfZvcjzfBOU67w+Ekc9d18ERe0mI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SiZvMhz6bta8EbtAeghaN7/g8hH8U5uBpHvpdPTzxgf0QlwAoAvxVbuo8bkl1RAFD
	 XcCs5D8e3G/64FZ4eIlAYPEAQ+6WsmI1HlpQcvGOiUl9wRzedISPQeXxQhEnbvrZdK
	 kwr9qjb5jj/w1JKyBFfimvu8+Ct1vWKRIZ4r+sTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahid Orentino Ferdjaoui <sahid.ferdjaoui@industrialdiscipline.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0504/1191] bpftool: clean-up usage of libbpf_get_error()
Date: Sat, 12 Sep 2026 08:53:52 +0200
Message-ID: <20260912065559.559173708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sahid Orentino Ferdjaoui <sahid.ferdjaoui@industrialdiscipline.com>

[ Upstream commit d1313e01271d2d8f33d6c82f1afb77e820a3540d ]

bpftool is now totally compliant with libbpf 1.0 mode and is not
expected to be compiled with pre-1.0, let's clean-up the usage of
libbpf_get_error().

The changes stay aligned with returned errors always negative.

- In tools/bpf/bpftool/btf.c This fixes an uninitialized local
variable `err` in function do_dump() because it may now be returned
without having been set.
- This also removes the checks on NULL pointers before calling
btf__free() because that function already does the check.

Signed-off-by: Sahid Orentino Ferdjaoui <sahid.ferdjaoui@industrialdiscipline.com>
Link: https://lore.kernel.org/r/20221120112515.38165-5-sahid.ferdjaoui@industrialdiscipline.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: f7f540e19751 ("tools/bpf/bpftool: Reset vmlinux BTF after struct_ops commands")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/btf.c        | 19 ++++++++-----------
 tools/bpf/bpftool/btf_dumper.c |  2 +-
 tools/bpf/bpftool/gen.c        | 10 ++++------
 tools/bpf/bpftool/iter.c       | 10 ++++++----
 tools/bpf/bpftool/main.c       |  7 +++----
 tools/bpf/bpftool/map.c        | 15 +++++++--------
 tools/bpf/bpftool/prog.c       | 10 +++++-----
 tools/bpf/bpftool/struct_ops.c | 11 +++++------
 8 files changed, 39 insertions(+), 45 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 68a70ac03c80a..19f5bdbebcf3d 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -467,9 +467,8 @@ static int dump_btf_c(const struct btf *btf,
 	int err = 0, i;
 
 	d = btf_dump__new(btf, btf_dump_printf, NULL, NULL);
-	err = libbpf_get_error(d);
-	if (err)
-		return err;
+	if (!d)
+		return -errno;
 
 	printf("#ifndef __VMLINUX_H__\n");
 	printf("#define __VMLINUX_H__\n");
@@ -512,11 +511,9 @@ static struct btf *get_vmlinux_btf_from_sysfs(void)
 	struct btf *base;
 
 	base = btf__parse(sysfs_vmlinux, NULL);
-	if (libbpf_get_error(base)) {
-		p_err("failed to parse vmlinux BTF at '%s': %ld\n",
-		      sysfs_vmlinux, libbpf_get_error(base));
-		base = NULL;
-	}
+	if (!base)
+		p_err("failed to parse vmlinux BTF at '%s': %d\n",
+		      sysfs_vmlinux, -errno);
 
 	return base;
 }
@@ -559,7 +556,7 @@ static int do_dump(int argc, char **argv)
 	__u32 btf_id = -1;
 	const char *src;
 	int fd = -1;
-	int err;
+	int err = 0;
 
 	if (!REQ_ARGS(2)) {
 		usage();
@@ -634,8 +631,8 @@ static int do_dump(int argc, char **argv)
 			base = get_vmlinux_btf_from_sysfs();
 
 		btf = btf__parse_split(*argv, base ?: base_btf);
-		err = libbpf_get_error(btf);
 		if (!btf) {
+			err = -errno;
 			p_err("failed to load BTF from %s: %s",
 			      *argv, strerror(errno));
 			goto done;
@@ -681,8 +678,8 @@ static int do_dump(int argc, char **argv)
 		}
 
 		btf = btf__load_from_kernel_by_id_split(btf_id, base_btf);
-		err = libbpf_get_error(btf);
 		if (!btf) {
+			err = -errno;
 			p_err("get btf by id (%u): %s", btf_id, strerror(errno));
 			goto done;
 		}
diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
index 56100ad2fa0d2..522746f13fc63 100644
--- a/tools/bpf/bpftool/btf_dumper.c
+++ b/tools/bpf/bpftool/btf_dumper.c
@@ -75,7 +75,7 @@ static int dump_prog_id_as_func_ptr(const struct btf_dumper *d,
 		goto print;
 
 	prog_btf = btf__load_from_kernel_by_id(info.btf_id);
-	if (libbpf_get_error(prog_btf))
+	if (!prog_btf)
 		goto print;
 	func_type = btf__type_by_id(prog_btf, finfo.type_id);
 	if (!func_type || !btf_is_func(func_type))
diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index cf8b4e525c889..ac9886c80e046 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -252,9 +252,8 @@ static int codegen_datasecs(struct bpf_object *obj, const char *obj_name)
 	int err = 0;
 
 	d = btf_dump__new(btf, codegen_btf_dump_printf, NULL, NULL);
-	err = libbpf_get_error(d);
-	if (err)
-		return err;
+	if (!d)
+		return -errno;
 
 	bpf_object__for_each_map(map, obj) {
 		/* only generate definitions for memory-mapped internal maps */
@@ -976,13 +975,12 @@ static int do_skeleton(int argc, char **argv)
 		/* log_level1 + log_level2 + stats, but not stable UAPI */
 		opts.kernel_log_level = 1 + 2 + 4;
 	obj = bpf_object__open_mem(obj_data, file_sz, &opts);
-	err = libbpf_get_error(obj);
-	if (err) {
+	if (!obj) {
 		char err_buf[256];
 
+		err = -errno;
 		libbpf_strerror(err, err_buf, sizeof(err_buf));
 		p_err("failed to open BPF object file: %s", err_buf);
-		obj = NULL;
 		goto out;
 	}
 
diff --git a/tools/bpf/bpftool/iter.c b/tools/bpf/bpftool/iter.c
index a3e6b167153db..9a1d2365a2974 100644
--- a/tools/bpf/bpftool/iter.c
+++ b/tools/bpf/bpftool/iter.c
@@ -4,6 +4,7 @@
 #ifndef _GNU_SOURCE
 #define _GNU_SOURCE
 #endif
+#include <errno.h>
 #include <unistd.h>
 #include <linux/err.h>
 #include <bpf/libbpf.h>
@@ -48,8 +49,8 @@ static int do_pin(int argc, char **argv)
 	}
 
 	obj = bpf_object__open(objfile);
-	err = libbpf_get_error(obj);
-	if (err) {
+	if (!obj) {
+		err = -errno;
 		p_err("can't open objfile %s", objfile);
 		goto close_map_fd;
 	}
@@ -62,13 +63,14 @@ static int do_pin(int argc, char **argv)
 
 	prog = bpf_object__next_program(obj, NULL);
 	if (!prog) {
+		err = -errno;
 		p_err("can't find bpf program in objfile %s", objfile);
 		goto close_obj;
 	}
 
 	link = bpf_program__attach_iter(prog, &iter_opts);
-	err = libbpf_get_error(link);
-	if (err) {
+	if (!link) {
+		err = -errno;
 		p_err("attach_iter failed for program %s",
 		      bpf_program__name(prog));
 		goto close_obj;
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index ccd7457f92bff..b2441fcbc1dc2 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -490,10 +490,9 @@ int main(int argc, char **argv)
 			break;
 		case 'B':
 			base_btf = btf__parse(optarg, NULL);
-			if (libbpf_get_error(base_btf)) {
-				p_err("failed to parse base BTF at '%s': %ld\n",
-				      optarg, libbpf_get_error(base_btf));
-				base_btf = NULL;
+			if (!base_btf) {
+				p_err("failed to parse base BTF at '%s': %d\n",
+				      optarg, -errno);
 				return -1;
 			}
 			break;
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 1cbed8d7b2ba3..995675ef4dadf 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -794,18 +794,18 @@ static int get_map_kv_btf(const struct bpf_map_info *info, struct btf **btf)
 	if (info->btf_vmlinux_value_type_id) {
 		if (!btf_vmlinux) {
 			btf_vmlinux = libbpf_find_kernel_btf();
-			err = libbpf_get_error(btf_vmlinux);
-			if (err) {
+			if (!btf_vmlinux) {
 				p_err("failed to get kernel btf");
-				return err;
+				return -errno;
 			}
 		}
 		*btf = btf_vmlinux;
 	} else if (info->btf_value_type_id) {
 		*btf = btf__load_from_kernel_by_id(info->btf_id);
-		err = libbpf_get_error(*btf);
-		if (err)
+		if (!*btf) {
+			err = -errno;
 			p_err("failed to get btf");
+		}
 	} else {
 		*btf = NULL;
 	}
@@ -815,14 +815,13 @@ static int get_map_kv_btf(const struct bpf_map_info *info, struct btf **btf)
 
 static void free_map_kv_btf(struct btf *btf)
 {
-	if (!libbpf_get_error(btf) && btf != btf_vmlinux)
+	if (btf != btf_vmlinux)
 		btf__free(btf);
 }
 
 static void free_btf_vmlinux(void)
 {
-	if (!libbpf_get_error(btf_vmlinux))
-		btf__free(btf_vmlinux);
+	btf__free(btf_vmlinux);
 }
 
 static int
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 3f6b190b71d89..e212ecb5b3006 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -322,7 +322,7 @@ static void show_prog_metadata(int fd, __u32 num_maps)
 		return;
 
 	btf = btf__load_from_kernel_by_id(map_info.btf_id);
-	if (libbpf_get_error(btf))
+	if (!btf)
 		goto out_free;
 
 	t_datasec = btf__type_by_id(btf, map_info.btf_value_type_id);
@@ -728,7 +728,7 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode mode,
 
 	if (info->btf_id) {
 		btf = btf__load_from_kernel_by_id(info->btf_id);
-		if (libbpf_get_error(btf)) {
+		if (!btf) {
 			p_err("failed to get btf");
 			return -1;
 		}
@@ -1609,7 +1609,7 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 		open_opts.kernel_log_level = 1 + 2 + 4;
 
 	obj = bpf_object__open_file(file, &open_opts);
-	if (libbpf_get_error(obj)) {
+	if (!obj) {
 		p_err("failed to open object file");
 		goto err_free_reuse_maps;
 	}
@@ -1827,7 +1827,7 @@ static int do_loader(int argc, char **argv)
 		open_opts.kernel_log_level = 1 + 2 + 4;
 
 	obj = bpf_object__open_file(file, &open_opts);
-	if (libbpf_get_error(obj)) {
+	if (!obj) {
 		p_err("failed to open object file");
 		goto err_close_obj;
 	}
@@ -2144,7 +2144,7 @@ static char *profile_target_name(int tgt_fd)
 	}
 
 	btf = btf__load_from_kernel_by_id(info.btf_id);
-	if (libbpf_get_error(btf)) {
+	if (!btf) {
 		p_err("failed to load btf for prog FD %d", tgt_fd);
 		goto out;
 	}
diff --git a/tools/bpf/bpftool/struct_ops.c b/tools/bpf/bpftool/struct_ops.c
index e08a6ff2866c3..1106970f63dc8 100644
--- a/tools/bpf/bpftool/struct_ops.c
+++ b/tools/bpf/bpftool/struct_ops.c
@@ -32,7 +32,7 @@ static const struct btf *get_btf_vmlinux(void)
 		return btf_vmlinux;
 
 	btf_vmlinux = libbpf_find_kernel_btf();
-	if (libbpf_get_error(btf_vmlinux))
+	if (!btf_vmlinux)
 		p_err("struct_ops requires kernel CONFIG_DEBUG_INFO_BTF=y");
 
 	return btf_vmlinux;
@@ -45,7 +45,7 @@ static const char *get_kern_struct_ops_name(const struct bpf_map_info *info)
 	const char *st_ops_name;
 
 	kern_btf = get_btf_vmlinux();
-	if (libbpf_get_error(kern_btf))
+	if (!kern_btf)
 		return "<btf_vmlinux_not_found>";
 
 	t = btf__type_by_id(kern_btf, info->btf_vmlinux_value_type_id);
@@ -415,7 +415,7 @@ static int do_dump(int argc, char **argv)
 	}
 
 	kern_btf = get_btf_vmlinux();
-	if (libbpf_get_error(kern_btf))
+	if (!kern_btf)
 		return -1;
 
 	if (!json_output) {
@@ -498,7 +498,7 @@ static int do_register(int argc, char **argv)
 		open_opts.kernel_log_level = 1 + 2 + 4;
 
 	obj = bpf_object__open_file(file, &open_opts);
-	if (libbpf_get_error(obj))
+	if (!obj)
 		return -1;
 
 	set_max_rlimit();
@@ -593,8 +593,7 @@ int do_struct_ops(int argc, char **argv)
 
 	err = cmd_select(cmds, argc, argv, do_help);
 
-	if (!libbpf_get_error(btf_vmlinux))
-		btf__free(btf_vmlinux);
+	btf__free(btf_vmlinux);
 
 	return err;
 }
-- 
2.53.0



