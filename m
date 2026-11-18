Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029254;
	b=u/6K4TbI0g1S0evO8GkO1ELHlexIEti4MH4fkJrTwdMT6z4ipQ7SlGLYEoy4Yem16eXk
	 kplB/FGVJU6/HA9CKBZp+KdSsPPtrn6dubyPJlVWqf9oNUgB6mQCYxaS/6qfPiMM4lb0A
	 28kricBtjK8QgAePxJhX9iTznkr/s2fA6attvN5yVwP535mHV4jasgVnKhsS80BKYei5z
	 iWKkR7Dm8PqJ0aV4DDC794r0dbiAJAUdas1pEOwFdPvhBjMKhhvGCcuomP1qY7nqZf2Ll
	 we96XKmYLWYWL0PhcBph7X2sRKbsv5KKnW2tKs+Z0PBG8l4cJb7y6mey7vBZfMhjGKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029254;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NdcGtK49c70z1O8WUEMo8vYL4W0cXVp8X/ScbLx7Ge8=;
	b=xM/WwZ1/nGftT/poX6ePRDtqr199mun0svAisrshN01Yq3do2UyCYcPIVxD+oTR+pVG6
	 grsoqXLvU/ud9SjN2WGdYC56Cs5cSkLw+SdjgZRM+ZJTmp3romWj1PaixHDMG3VMg8pG9
	 aaA4F1DEhok2PLMeFwMleDFjlQ5ctYihF+kbMMXmUmPNWp6AukQOYi/UfeCl//pi77wPU
	 P/+yYm0r5vNqQS+uqSnNqLbBl8wLUvO0T4wvmGi1+Q95zzUVLYdPQ9GfmuUjbOfeHI+h8
	 FEKfKATLb4pTAhDDJzWgaoJFBx1qRGlzuEZlY5SXfmSeo9SwghgfglJu56fSPrKuxEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bAXmxCvB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB87C606A320;
	Wed, 18 Nov 2026 19:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bAXmxCvB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25FFD1F000C5;
	Wed, 18 Nov 2026 19:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029254;
	bh=NdcGtK49c70z1O8WUEMo8vYL4W0cXVp8X/ScbLx7Ge8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bAXmxCvBZsmgbsLlNDgrE45Gngo6H0qM6/K2Qarsymn1T/keeV6hjaK/ZDsvnr+xp
	 SB28oAHJy30czOw/EyJAguaf3QYkvjGH3b9BngcqJW2rmoFSimp3yguxZCogkxYuYK
	 DHG/cwo1xssq6DVM4VPUKWteL+29jsuQetoGUkcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Maguire <alan.maguire@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0268/1756] perf bpf: Fix up build failure due to change of btf_vlen() return type
Date: Wed, 18 Nov 2026 15:39:55 +0100
Message-ID: <20261118150019.042464094@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 3287a1881ca528b89b964d9fa6d28880d277d9e2 ]

Fix:

util/btf.c: In function '__btf_type__find_member_by_name':
util/btf.c:19:43: error: comparison of integer expressions of different signedness: 'int' and '__u32' {aka 'unsigned int'} [-Werror=sign-compare]
   19 |         for (i = 0, m = btf_members(t); i < btf_vlen(t); i++, m++) {
      |                                           ^

builtin-trace.c: In function 'syscall_arg__strtoul_btf_enum':
builtin-trace.c:967:27: error: comparison of integer expressions of different signedness: 'int' and '__u32' {aka 'unsigned int'} [-Werror=sign-compare]
  967 |         for (int i = 0; i < btf_vlen(bt); ++i, ++be) {
      |                           ^

by making the variable the same type as the function.

Committer note:

Add an extra hunk from Alan Maguire, fixing btf_enum_scnprintf().

Reviewed-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 024b219744a9 ("perf trace: Add upper bound checks for augmented BTF struct printing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 6 +++---
 tools/perf/util/btf.c      | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 385686a93ab8f..f0d7d9b53f9b2 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -951,7 +951,7 @@ static bool syscall_arg__strtoul_btf_enum(char *bf, size_t size, struct syscall_
 	struct btf *btf = arg->trace->btf;
 	struct btf_enum *be = btf_enum(bt);
 
-	for (int i = 0; i < btf_vlen(bt); ++i, ++be) {
+	for (u32 i = 0; i < btf_vlen(bt); ++i, ++be) {
 		const char *name = btf__name_by_offset(btf, be->name_off);
 		int max_len = max(size, strlen(name));
 
@@ -996,9 +996,9 @@ static bool syscall_arg__strtoul_btf_type(char *bf, size_t size, struct syscall_
 static size_t btf_enum_scnprintf(const struct btf_type *type, struct btf *btf, char *bf, size_t size, int val)
 {
 	struct btf_enum *be = btf_enum(type);
-	const int nr_entries = btf_vlen(type);
+	const unsigned int nr_entries = btf_vlen(type);
 
-	for (int i = 0; i < nr_entries; ++i, ++be) {
+	for (unsigned int i = 0; i < nr_entries; ++i, ++be) {
 		if (be->val == val) {
 			return scnprintf(bf, size, "%s",
 					 btf__name_by_offset(btf, be->name_off));
diff --git a/tools/perf/util/btf.c b/tools/perf/util/btf.c
index bb163fe87767c..50d98f3e83bf0 100644
--- a/tools/perf/util/btf.c
+++ b/tools/perf/util/btf.c
@@ -14,7 +14,7 @@ const struct btf_member *__btf_type__find_member_by_name(struct btf *btf,
 {
 	const struct btf_type *t = btf__type_by_id(btf, type_id);
 	const struct btf_member *m;
-	int i;
+	u32 i;
 
 	for (i = 0, m = btf_members(t); i < btf_vlen(t); i++, m++) {
 		const char *current_member_name = btf__name_by_offset(btf, m->name_off);
-- 
2.53.0



