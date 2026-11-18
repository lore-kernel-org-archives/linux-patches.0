Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040095;
	b=1VpCNgGj93tee1u2DZV29W26XJSS3t37lwzBAUMfukwmU1rk9LOc3/dKeuHG/6amQP6F
	 HG5sHWZtGR6dcMJyrP9w0T4Gt4ItzfMcNp5mlA4MwSD7L9KPpQFQg5q9h6AMIpVE62Tzv
	 TL4/k886fjNC1beVzS7NgPM0Qd5R/J2NsTM1yHgrqaI9HZqwcdhhCo6bAoBofEqoyRXFv
	 rXntoz6JleGJ+PjVyONXrsbzOZpMAnWU5x8KPwzi9g2Ho7uQCfHU1tZYN1tNOES4Ltlko
	 kMNqiob8flP/rcYMvwNCfhKl0d2xrojQT+e8FpgjEhWYPb5mY9EjuBcYySOFiwWc6sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040095;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5edVYuexRXkNhaXc0qU1VrKM7HigWE0zzFm/9nkPESE=;
	b=GmOAAtmF+ZDhMhNpTZyaoAVnnKegt8i8RHH+M3fxcWqHDd+XN/z694pHndtxBmwttFjN
	 uBw2Hrpev6Mu3OLfHBY0/8qwSAzNjEVtlLq47GIw33Qgh8CWFhQ8XXWwdJgsTTWAX/AMA
	 2D2AxMGxe8reX/au31WdD/A828OZGA6uIcTcqrzAr6YF3y8o/+FMxME2XW7mSm2u7N3+I
	 422UNz1J8AzGgwelZ7ukw6RBw+aS5BPV/54N7bC/1u2m6ahvVtdEj4KNftNHxhtquSFnb
	 M02fLGTdO7x2nzipDYBwXSynayV4eP9bpQxt38S/kyVKm10c6OdiytwBkfEHDH8vE8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tLpx0Aj+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D04606A325;
	Wed, 18 Nov 2026 22:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tLpx0Aj+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350711F000C4;
	Wed, 18 Nov 2026 22:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040095;
	bh=5edVYuexRXkNhaXc0qU1VrKM7HigWE0zzFm/9nkPESE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tLpx0Aj+YxlOIVRi4+jp3lbZDKM0aVrLT2DJq5dUaf3z5LQSe4EVQFevd2wV6kEC+
	 GBVkCME25RxS3n7MP4ihF4sMqWNaw5Gzu6RQPri5/qxxH2BOmTOUiN34NNoihGqoF4
	 pserZ2OC1uvHJV3EB3wbid0Yi6n8tbDCu/E2H/sY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <mrpre@163.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2335/3318] bpftool: Using the right format specifiers
Date: Wed, 18 Nov 2026 15:49:17 +0100
Message-ID: <20261118150431.693783555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <mrpre@163.com>

[ Upstream commit 17c3dc50294ba445ddc7d50020df6452e93d38b2 ]

Fixed some formatting specifiers errors, such as using %d for int and %u
for unsigned int, as well as other byte-length types.

Signed-off-by: Jiayuan Chen <mrpre@163.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/bpf/20250207123706.727928-2-mrpre@163.com
Stable-dep-of: dbf8cef936c7 ("bpftool: Fix CPU IDs in per-CPU map output")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/gen.c  | 12 ++++++------
 tools/bpf/bpftool/link.c | 14 +++++++-------
 tools/bpf/bpftool/main.c |  8 ++++----
 tools/bpf/bpftool/map.c  | 10 +++++-----
 4 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 34515fbe9414e..7a75da8bbbb08 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -654,7 +654,7 @@ static void codegen_destroy(struct bpf_object *obj, const char *obj_name)
 			continue;
 		if (bpf_map__is_internal(map) &&
 		    (bpf_map__map_flags(map) & BPF_F_MMAPABLE))
-			printf("\tskel_free_map_data(skel->%1$s, skel->maps.%1$s.initial_value, %2$zd);\n",
+			printf("\tskel_free_map_data(skel->%1$s, skel->maps.%1$s.initial_value, %2$zu);\n",
 			       ident, bpf_map_mmap_sz(map));
 		codegen("\
 			\n\
@@ -941,7 +941,7 @@ static int walk_st_ops_shadow_vars(struct btf *btf, const char *ident,
 
 		offset = m->offset / 8;
 		if (next_offset < offset)
-			printf("\t\t\tchar __padding_%d[%d];\n", i, offset - next_offset);
+			printf("\t\t\tchar __padding_%d[%u];\n", i, offset - next_offset);
 
 		switch (btf_kind(member_type)) {
 		case BTF_KIND_INT:
@@ -1009,7 +1009,7 @@ static int walk_st_ops_shadow_vars(struct btf *btf, const char *ident,
 	/* Cannot fail since it must be a struct type */
 	size = btf__resolve_size(btf, map_type_id);
 	if (next_offset < (__u32)size)
-		printf("\t\t\tchar __padding_end[%d];\n", size - next_offset);
+		printf("\t\t\tchar __padding_end[%u];\n", size - next_offset);
 
 out:
 	btf_dump__free(d);
@@ -2027,7 +2027,7 @@ btfgen_mark_type(struct btfgen_info *info, unsigned int type_id, bool follow_poi
 		break;
 	/* tells if some other type needs to be handled */
 	default:
-		p_err("unsupported kind: %s (%d)", btf_kind_str(btf_type), type_id);
+		p_err("unsupported kind: %s (%u)", btf_kind_str(btf_type), type_id);
 		return -EINVAL;
 	}
 
@@ -2079,7 +2079,7 @@ static int btfgen_record_field_relo(struct btfgen_info *info, struct bpf_core_sp
 			btf_type = btf__type_by_id(btf, type_id);
 			break;
 		default:
-			p_err("unsupported kind: %s (%d)",
+			p_err("unsupported kind: %s (%u)",
 			      btf_kind_str(btf_type), btf_type->type);
 			return -EINVAL;
 		}
@@ -2178,7 +2178,7 @@ static int btfgen_mark_type_match(struct btfgen_info *info, __u32 type_id, bool
 	}
 	/* tells if some other type needs to be handled */
 	default:
-		p_err("unsupported kind: %s (%d)", btf_kind_str(btf_type), type_id);
+		p_err("unsupported kind: %s (%u)", btf_kind_str(btf_type), type_id);
 		return -EINVAL;
 	}
 
diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index 00ecc67b54712..250d1cf82ed94 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -107,7 +107,7 @@ static int link_parse_fd(int *argc, char ***argv)
 
 		fd = bpf_link_get_fd_by_id(id);
 		if (fd < 0)
-			p_err("failed to get link with ID %d: %s", id, strerror(errno));
+			p_err("failed to get link with ID %u: %s", id, strerror(errno));
 		return fd;
 	} else if (is_prefix(**argv, "pinned")) {
 		char *path;
@@ -364,7 +364,7 @@ static char *perf_config_hw_cache_str(__u64 config)
 	if (hw_cache)
 		snprintf(str, PERF_HW_CACHE_LEN, "%s-", hw_cache);
 	else
-		snprintf(str, PERF_HW_CACHE_LEN, "%lld-", config & 0xff);
+		snprintf(str, PERF_HW_CACHE_LEN, "%llu-", config & 0xff);
 
 	op = perf_event_name(evsel__hw_cache_op, (config >> 8) & 0xff);
 	if (op)
@@ -372,7 +372,7 @@ static char *perf_config_hw_cache_str(__u64 config)
 			 "%s-", op);
 	else
 		snprintf(str + strlen(str), PERF_HW_CACHE_LEN - strlen(str),
-			 "%lld-", (config >> 8) & 0xff);
+			 "%llu-", (config >> 8) & 0xff);
 
 	result = perf_event_name(evsel__hw_cache_result, config >> 16);
 	if (result)
@@ -380,7 +380,7 @@ static char *perf_config_hw_cache_str(__u64 config)
 			 "%s", result);
 	else
 		snprintf(str + strlen(str), PERF_HW_CACHE_LEN - strlen(str),
-			 "%lld", config >> 16);
+			 "%llu", config >> 16);
 	return str;
 }
 
@@ -573,7 +573,7 @@ static void show_link_ifindex_plain(__u32 ifindex)
 	else
 		snprintf(devname, sizeof(devname), "(detached)");
 	if (ret)
-		snprintf(devname, sizeof(devname), "%s(%d)",
+		snprintf(devname, sizeof(devname), "%s(%u)",
 			 tmpname, ifindex);
 	printf("ifindex %s  ", devname);
 }
@@ -649,7 +649,7 @@ void netfilter_dump_plain(const struct bpf_link_info *info)
 	if (pfname)
 		printf("\n\t%s", pfname);
 	else
-		printf("\n\tpf: %d", pf);
+		printf("\n\tpf: %u", pf);
 
 	if (hookname)
 		printf(" %s", hookname);
@@ -716,7 +716,7 @@ static void show_uprobe_multi_plain(struct bpf_link_info *info)
 	printf("func_cnt %u  ", info->uprobe_multi.count);
 
 	if (info->uprobe_multi.pid)
-		printf("pid %d  ", info->uprobe_multi.pid);
+		printf("pid %u  ", info->uprobe_multi.pid);
 
 	printf("\n\t%-16s   %-16s   %-16s", "offset", "ref_ctr_offset", "cookies");
 	for (i = 0; i < info->uprobe_multi.count; i++) {
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index be60478b4692d..1120dbcaf66b2 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -152,7 +152,7 @@ static int do_version(int argc, char **argv)
 			     BPFTOOL_MINOR_VERSION, BPFTOOL_PATCH_VERSION);
 #endif
 		jsonw_name(json_wtr, "libbpf_version");
-		jsonw_printf(json_wtr, "\"%d.%d\"",
+		jsonw_printf(json_wtr, "\"%u.%u\"",
 			     libbpf_major_version(), libbpf_minor_version());
 
 		jsonw_name(json_wtr, "features");
@@ -374,7 +374,7 @@ static int do_batch(int argc, char **argv)
 		while ((cp = strstr(buf, "\\\n")) != NULL) {
 			if (!fgets(contline, sizeof(contline), fp) ||
 			    strlen(contline) == 0) {
-				p_err("missing continuation line on command %d",
+				p_err("missing continuation line on command %u",
 				      lines);
 				err = -1;
 				goto err_close;
@@ -385,7 +385,7 @@ static int do_batch(int argc, char **argv)
 				*cp = '\0';
 
 			if (strlen(buf) + strlen(contline) + 1 > sizeof(buf)) {
-				p_err("command %d is too long", lines);
+				p_err("command %u is too long", lines);
 				err = -1;
 				goto err_close;
 			}
@@ -427,7 +427,7 @@ static int do_batch(int argc, char **argv)
 		err = -1;
 	} else {
 		if (!json_output)
-			printf("processed %d commands\n", lines);
+			printf("processed %u commands\n", lines);
 	}
 err_close:
 	if (fp != stdin)
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index a89a0cdb90e21..223502883db22 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -285,7 +285,7 @@ static void print_entry_plain(struct bpf_map_info *info, unsigned char *key,
 		}
 		if (info->value_size) {
 			for (i = 0; i < n; i++) {
-				printf("value (CPU %02d):%c",
+				printf("value (CPU %02u):%c",
 				       i, info->value_size > 16 ? '\n' : ' ');
 				fprint_hex(stdout, value + i * step,
 					   info->value_size, " ");
@@ -316,7 +316,7 @@ static char **parse_bytes(char **argv, const char *name, unsigned char *val,
 	}
 
 	if (i != n) {
-		p_err("%s expected %d bytes got %d", name, n, i);
+		p_err("%s expected %u bytes got %u", name, n, i);
 		return NULL;
 	}
 
@@ -462,7 +462,7 @@ static void show_map_header_json(struct bpf_map_info *info, json_writer_t *wtr)
 		jsonw_string_field(wtr, "name", info->name);
 
 	jsonw_name(wtr, "flags");
-	jsonw_printf(wtr, "%d", info->map_flags);
+	jsonw_printf(wtr, "%u", info->map_flags);
 }
 
 static int show_map_close_json(int fd, struct bpf_map_info *info)
@@ -588,7 +588,7 @@ static int show_map_close_plain(int fd, struct bpf_map_info *info)
 			if (prog_type_str)
 				printf("owner_prog_type %s  ", prog_type_str);
 			else
-				printf("owner_prog_type %d  ", prog_type);
+				printf("owner_prog_type %u  ", prog_type);
 		}
 		if (owner_jited)
 			printf("owner%s jited",
@@ -615,7 +615,7 @@ static int show_map_close_plain(int fd, struct bpf_map_info *info)
 		printf("\n\t");
 
 	if (info->btf_id)
-		printf("btf_id %d", info->btf_id);
+		printf("btf_id %u", info->btf_id);
 
 	if (frozen)
 		printf("%sfrozen", info->btf_id ? "  " : "");
-- 
2.53.0



