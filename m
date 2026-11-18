Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029286;
	b=A9i7DF+a2grFoIeDoUZgH+s+xMspsJkZheEEVLxzZgDWB1XiLrPsF/3IP+vjNQQofKYe
	 EpjGWjmBImGgpuM3dDTxr4kJZs0Zo0a/NWipl1BpFJzSu6Hyz3NDzqEgCg0V7bCGVWEOS
	 dApaFmD6A3Ag0DvGSylaHgSCj8DynLWLCYji+pJOiu7Uvmx85mA6mwLbntQKhJ6CwmTh/
	 dUkHet5KDEqyy1yLuxPs6azhTL/JIrDfSWJXzEpDeQMQSrEf+kH5Pz8XNZ/NOEYN+LWVF
	 gu8hjSkOKkxanSuJ4ZoARBG6zlNv9YYuB6drMKcGW82cxraJtPVh70XmHFuXT44dn9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MxZDGljvhH8KMpDAhRov/bqSFlztglThVlhFbq1VYK0=;
	b=3FR7YvL/AVRqYoubNHh9vIwqIS8FvRPrH1TZFjvfQR/gvd3v/kpmSikokNgrznzt7HYs
	 nmPN0viSAxPOhk5gidWpK0cKk8nGt7pCm+Jl42uJxa3stUe2+mtT4qDjc51C/1La3McV8
	 /M0TPBa1zjAY/228c86XAYEUUpjKCCeP7nx2OHdbm5ndwcnGX/FNXmIbiuwQWA2CBoJkL
	 u8/GwQDor5E4hqzzFjPP8WVe2C6jTKuGnmfQ2b+gB3cYbnCkJxovEpSgf6YFVsxmbW1x1
	 7g/CawLSiIowUcUHtYuxU2qUuXnDfbA3ZFtVEL2j+ngkcMlUiqIMlwKwtwXGNGEoroA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KW7382yr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD3B606A31C;
	Wed, 18 Nov 2026 19:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KW7382yr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FC31F000C4;
	Wed, 18 Nov 2026 19:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029286;
	bh=MxZDGljvhH8KMpDAhRov/bqSFlztglThVlhFbq1VYK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KW7382yrLGRmIpBAtcz0YqQIW2Jda0GNCnWcjRiQsn9KyEgDTFawiQvyZ+odcPva/
	 F6R255mDciKLq40RnLYsh9vcEsVoMc6H4pWV+tftyvexG4VJKK7yvJoMJB5y/2l/lU
	 VAdHkmRx27Dvy1pND0gefm/O9wu+xaGu5tet/Ejo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Tomlin <atomlin@atomlin.com>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0269/1756] perf trace: Enhance BTF type formatting to symbolise kernel function pointers
Date: Wed, 18 Nov 2026 15:39:56 +0100
Message-ID: <20261118150019.126750709@linuxfoundation.org>
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
index f0d7d9b53f9b2..d701836f62819 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -122,6 +122,7 @@ struct syscall_arg_fmt {
 #ifdef HAVE_LIBBPF_SUPPORT
 	const struct btf_type *type;
 	int	   type_id; /* used in btf_dump */
+	bool	   btf_type_cached;
 #endif
 };
 
@@ -928,21 +929,68 @@ static size_t syscall_arg__scnprintf_getrandom_flags(char *bf, size_t size,
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
@@ -976,10 +1024,8 @@ static bool syscall_arg__strtoul_btf_type(char *bf, size_t size, struct syscall_
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
@@ -987,19 +1033,22 @@ static bool syscall_arg__strtoul_btf_type(char *bf, size_t size, struct syscall_
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
@@ -1026,14 +1075,19 @@ static size_t btf_struct_scnprintf(const struct btf_type *type, struct btf *btf,
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
@@ -1044,8 +1098,10 @@ static size_t btf_struct_scnprintf(const struct btf_type *type, struct btf *btf,
 		return 0;
 
 	/* pretty print the struct data here */
-	if (btf_dump__dump_type_data(btf_dump, type_id, arg->augmented.args->value, type->size, &dump_data_opts) <= 0)
+	if (btf_dump__dump_type_data(btf_dump, type_id, arg->augmented.args->value, type->size, &dump_data_opts) <= 0) {
+		btf_dump__free(btf_dump);
 		return 0;
+	}
 
 	consumed = sizeof(*augmented_arg) + augmented_arg->size;
 	arg->augmented.args = ((void *)arg->augmented.args) + consumed;
@@ -1057,33 +1113,40 @@ static size_t btf_struct_scnprintf(const struct btf_type *type, struct btf *btf,
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
@@ -2377,7 +2440,8 @@ static size_t syscall__scnprintf_args(struct syscall *sc, char *bf, size_t size,
 
 			default_scnprintf = sc->arg_fmt[arg.idx].scnprintf;
 
-			if (trace->force_btf || default_scnprintf == NULL || default_scnprintf == SCA_PTR) {
+			if (trace->force_btf || default_scnprintf == NULL ||
+			    default_scnprintf == SCA_PTR || default_scnprintf == SCA_KSYM) {
 				btf_printed = trace__btf_scnprintf(trace, &arg, bf + printed,
 								   size - printed, val, field->type);
 				if (btf_printed) {
-- 
2.53.0



