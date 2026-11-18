Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023215;
	b=iNnymj5BVkADiKrHUOVM5Hu7DZotYz3zVUaHRaSQ8qTNtkJ8pYdrFVV0VqL/JoaUltgo
	 Y4rlFCfis+sc1VktV6R4kj+ZnrQ9aKioA+mn4EzdVd4TADfpAB1QREPAjQeEgdab0ArgP
	 KzxudBV8N32QUdAAoKtg0e1bCph9A+KRLQ75jRJvBAYUW3R+tVFDxiG5Q3kuh+nLAC/MT
	 BR9cpNZZCxEg/AiUgHRbc3PrsGWCnhY5J5mjK2BxM8lohsHNDGvq1ARF8HY8UVeNTM35D
	 OsinSf+dhSl0mHOgZzUTXP4HBBBBhJu/fGWQOtCeSZvMDW5pEoMJbXqon2CA2bSooSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023215;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KOtcuj+Gjb2cIpKaUnC8Jcu45/MEJsnjpZevJmEr7JA=;
	b=O0q93/ARsdAo80uRA7fXvc89DsK0xLOuiXbBuTwCEteab2sBzWxi6beHXNQPIJPmdP5B
	 dks6SeNT/iF3WOCJ79pDF4dQQfoJbMjCDDJi9UotIMymLmAT8Ud4LFbsAYFkX0QJVkcOa
	 /+WCV3+KEWam4W8ew1SPpDQkVDIaD94Pkr/h0poLBYQfw1ihw7iujN2n4XqHNbU5aHSYH
	 3fH0xfzFH2L2dqn8v6YLeJNs9q3YG1Mlm2DmD5v7AzhAUTR+2lsNGLDAZsbwDfsD4r9sl
	 WxnjjT6eHi4+3U0eOLR6kr/XcmmnacyfvIYBZJR+hnAPF9k/YdX/LC3Z9FjxwxjmyAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WEMmK+1A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB63606A33E;
	Wed, 18 Nov 2026 17:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WEMmK+1A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524A41F000CC;
	Wed, 18 Nov 2026 17:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023214;
	bh=KOtcuj+Gjb2cIpKaUnC8Jcu45/MEJsnjpZevJmEr7JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WEMmK+1AA8sjyID6RltveOrL6mHNDALHCwwEOb6aW5V9zKX0U/ECq/9yo+g2ouwQ5
	 HWbF8Yhg3CZJnFvICHlFlTQVW7tAoqAdoqbG/djMw2zfCh+os57EpA3gDagnYF/8sx
	 DpSjcfCW/dRZ3gi+haF05txhlWqw58ZRfIMG6taE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Tomlin <atomlin@atomlin.com>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0288/2151] perf trace: Enhance BTF type formatting to symbolise kernel function pointers
Date: Wed, 18 Nov 2026 15:33:43 +0100
Message-ID: <20261118150132.386793726@linuxfoundation.org>
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

From: Aaron Tomlin <atomlin@atomlin.com>

[ Upstream commit c6dd6161815d0c10ed24ad13fdad847bec63d961 ]

When BTF (BPF Type Format) metadata is loaded from vmlinux, 'perf trace'
can inspect the precise C types of tracepoint and system call parameters.
However, function pointer arguments are currently not recognised during
BTF pretty-printing and default to hexadecimal output.

Introduce btf_is_func_ptr() to inspect BTF type hierarchies
(i.e., traversing pointers, typedefs, and type modifiers) to determine
whether a parameter resolves to a function prototype
(BTF_KIND_FUNC_PROTO).

Generalise BTF type caching via syscall_arg_fmt__cache_btf_type() to
handle structs, unions, enums, and function pointers alike. When a field
is identified as a kernel function pointer, trace__btf_scnprintf()
routes its value to syscall_arg__scnprintf_ksym(), enabling automatic
zero-config symbolisation of kernel function pointers whenever BTF is
available.

Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Tested-by: Ian Rogers <irogers@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 024b219744a9 ("perf trace: Add upper bound checks for augmented BTF struct printing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 106 +++++++++++++++++++++++++++++--------
 1 file changed, 85 insertions(+), 21 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 19ff67424c5d5..b0e14dfaae1ba 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -122,6 +122,7 @@ struct syscall_arg_fmt {
 #ifdef HAVE_LIBBPF_SUPPORT
 	const struct btf_type *type;
 	int	   type_id; /* used in btf_dump */
+	bool	   btf_type_cached;
 #endif
 };
 
@@ -947,21 +948,68 @@ static size_t syscall_arg__scnprintf_getrandom_flags(char *bf, size_t size,
 #define SCA_GETRANDOM_FLAGS syscall_arg__scnprintf_getrandom_flags
 
 #ifdef HAVE_LIBBPF_SUPPORT
-static void syscall_arg_fmt__cache_btf_enum(struct syscall_arg_fmt *arg_fmt, struct btf *btf, char *type)
+static bool btf_is_func_ptr(const struct btf *btf, const struct btf_type *type)
 {
+	int nr_ptrs = 0;
+
+	while (type) {
+		if (btf_is_ptr(type)) {
+			if (++nr_ptrs > 1)
+				return false;
+			type = btf__type_by_id(btf, type->type);
+		} else if (btf_is_typedef(type) || btf_is_mod(type)) {
+			type = btf__type_by_id(btf, type->type);
+		} else {
+			break;
+		}
+	}
+	return nr_ptrs == 1 && type && btf_is_func_proto(type);
+}
+
+static void syscall_arg_fmt__cache_btf_type(struct syscall_arg_fmt *arg_fmt,
+					    struct btf *btf, const char *type)
+{
+	char name[128];
+	const char *pos;
+	size_t len = 0;
 	int id;
 
-	type = strstr(type, "enum ");
+	arg_fmt->btf_type_cached = true;
+
 	if (type == NULL)
 		return;
 
-	type += 5; // skip "enum " to get the enumeration name
+	/* Pointers to enums are memory addresses, not scalar enums */
+	if (strstr(type, "enum ") && strchr(type, '*'))
+		return;
+
+	if ((pos = strstr(type, "enum ")) != NULL)
+		pos += 5;
+	else if ((pos = strstr(type, "struct ")) != NULL)
+		pos += 7;
+	else if ((pos = strstr(type, "union ")) != NULL)
+		pos += 6;
+	else
+		pos = type;
+
+	while (isspace(*pos))
+		pos++;
+
+	while ((isalnum(pos[len]) || pos[len] == '_') && len < sizeof(name) - 1) {
+		name[len] = pos[len];
+		len++;
+	}
+	name[len] = '\0';
+
+	if (len == 0)
+		return;
 
-	id = btf__find_by_name(btf, type);
+	id = btf__find_by_name(btf, name);
 	if (id < 0)
 		return;
 
 	arg_fmt->type = btf__type_by_id(btf, id);
+	arg_fmt->type_id = id;
 }
 
 static bool syscall_arg__strtoul_btf_enum(char *bf, size_t size, struct syscall_arg *arg, u64 *val)
@@ -995,10 +1043,8 @@ static bool syscall_arg__strtoul_btf_type(char *bf, size_t size, struct syscall_
 	if (btf == NULL)
 		return false;
 
-	if (arg->fmt->type == NULL) {
-		// See if this is an enum
-		syscall_arg_fmt__cache_btf_enum(arg->fmt, btf, type);
-	}
+	if (!arg->fmt->btf_type_cached)
+		syscall_arg_fmt__cache_btf_type(arg->fmt, btf, type);
 
 	// Now let's see if we have a BTF type resolved
 	bt = arg->fmt->type;
@@ -1006,19 +1052,22 @@ static bool syscall_arg__strtoul_btf_type(char *bf, size_t size, struct syscall_
 		return false;
 
 	// If it is an enum:
-	if (btf_is_enum(arg->fmt->type))
+	if (btf_is_enum(arg->fmt->type)) {
+		if (type && strchr(type, '*'))
+			return false;
 		return syscall_arg__strtoul_btf_enum(bf, size, arg, val);
+	}
 
 	return false;
 }
 
-static size_t btf_enum_scnprintf(const struct btf_type *type, struct btf *btf, char *bf, size_t size, int val)
+static size_t btf_enum_scnprintf(const struct btf_type *type, struct btf *btf, char *bf, size_t size, unsigned long val)
 {
 	struct btf_enum *be = btf_enum(type);
 	const unsigned int nr_entries = btf_vlen(type);
 
 	for (unsigned int i = 0; i < nr_entries; ++i, ++be) {
-		if (be->val == val) {
+		if ((unsigned long)(__u32)be->val == val || (unsigned long)be->val == val) {
 			return scnprintf(bf, size, "%s",
 					 btf__name_by_offset(btf, be->name_off));
 		}
@@ -1045,14 +1094,19 @@ static size_t btf_struct_scnprintf(const struct btf_type *type, struct btf *btf,
 		.bf   = bf,
 		.size = size,
 	};
-	struct augmented_arg *augmented_arg = arg->augmented.args;
+	struct augmented_arg *augmented_arg;
 	int type_id = arg->fmt->type_id, consumed;
 	struct btf_dump *btf_dump;
 
 	LIBBPF_OPTS(btf_dump_opts, dump_opts);
 	LIBBPF_OPTS(btf_dump_type_data_opts, dump_data_opts);
 
-	if (arg == NULL || arg->augmented.args == NULL)
+	if (arg == NULL || arg->augmented.args == NULL || arg->augmented.size <= 0 ||
+	    arg->fmt == NULL || !arg->fmt->from_user)
+		return 0;
+
+	augmented_arg = arg->augmented.args;
+	if (augmented_arg->size <= 0)
 		return 0;
 
 	dump_data_opts.compact	  = true;
@@ -1063,8 +1117,10 @@ static size_t btf_struct_scnprintf(const struct btf_type *type, struct btf *btf,
 		return 0;
 
 	/* pretty print the struct data here */
-	if (btf_dump__dump_type_data(btf_dump, type_id, arg->augmented.args->value, type->size, &dump_data_opts) <= 0)
+	if (btf_dump__dump_type_data(btf_dump, type_id, arg->augmented.args->value, type->size, &dump_data_opts) <= 0) {
+		btf_dump__free(btf_dump);
 		return 0;
+	}
 
 	consumed = sizeof(*augmented_arg) + augmented_arg->size;
 	arg->augmented.args = ((void *)arg->augmented.args) + consumed;
@@ -1076,33 +1132,40 @@ static size_t btf_struct_scnprintf(const struct btf_type *type, struct btf *btf,
 }
 
 static size_t trace__btf_scnprintf(struct trace *trace, struct syscall_arg *arg, char *bf,
-				   size_t size, int val, char *type)
+				   size_t size, unsigned long val, char *type)
 {
 	struct syscall_arg_fmt *arg_fmt = arg->fmt;
 
 	if (trace->btf == NULL)
 		return 0;
 
-	if (arg_fmt->type == NULL) {
-		// Check if this is an enum and if we have the BTF type for it.
-		syscall_arg_fmt__cache_btf_enum(arg_fmt, trace->btf, type);
-	}
+	if (!arg_fmt->btf_type_cached)
+		syscall_arg_fmt__cache_btf_type(arg_fmt, trace->btf, type);
 
 	// Did we manage to find a BTF type for the syscall/tracepoint argument?
 	if (arg_fmt->type == NULL)
 		return 0;
 
+	if (type && strchr(type, '*')) {
+		if (btf_is_enum(arg_fmt->type) || btf_is_func_ptr(trace->btf, arg_fmt->type))
+			return 0;
+	}
+
 	if (btf_is_enum(arg_fmt->type))
 		return btf_enum_scnprintf(arg_fmt->type, trace->btf, bf, size, val);
 	else if (btf_is_struct(arg_fmt->type) || btf_is_union(arg_fmt->type))
 		return btf_struct_scnprintf(arg_fmt->type, trace->btf, bf, size, arg);
+	else if (btf_is_func_ptr(trace->btf, arg_fmt->type)) {
+		arg->val = val;
+		return syscall_arg__scnprintf_ksym(bf, size, arg);
+	}
 
 	return 0;
 }
 
 #else // HAVE_LIBBPF_SUPPORT
 static size_t trace__btf_scnprintf(struct trace *trace __maybe_unused, struct syscall_arg *arg __maybe_unused,
-				   char *bf __maybe_unused, size_t size __maybe_unused, int val __maybe_unused,
+				   char *bf __maybe_unused, size_t size __maybe_unused, unsigned long val __maybe_unused,
 				   char *type __maybe_unused)
 {
 	return 0;
@@ -2445,7 +2508,8 @@ static size_t syscall__scnprintf_args(struct syscall *sc, char *bf, size_t size,
 
 			default_scnprintf = sc->arg_fmt[arg.idx].scnprintf;
 
-			if (trace->force_btf || default_scnprintf == NULL || default_scnprintf == SCA_PTR) {
+			if (trace->force_btf || default_scnprintf == NULL ||
+			    default_scnprintf == SCA_PTR || default_scnprintf == SCA_KSYM) {
 				btf_printed = trace__btf_scnprintf(trace, &arg, bf + printed,
 								   size - printed, val, field->type);
 				if (btf_printed) {
-- 
2.53.0



