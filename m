Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023212;
	b=31adJ77tBSe6VlUh+jAKUaHAwMkAKaIUGlO8PPg6zvUufXXJrXo/UcmjiQ9kYPT4LdLV
	 SwkRem1ElS4O97oyyRfrjYn6eUoEcVKHQzoN/KcIDwvAnF6vahfsLzoEiUs6BOjBzFqLY
	 sh7OI47MTylFK/og3OX2DgDda1TGE6uOHb2G+ul2PiEXLiO6PWkA4ploQ/DnU/GXd4XV1
	 OctFflgodD+2vW9ScNJQNh8zuRcc2vi1yaaRUgjT7JvVLJujjOVTpkbmUv+hwLkjiMaKK
	 dAlEsuiGSChxCqLfXu2s+cnXThu74kxsky4xBCQRQD1faDxceyDnicHhPsM+FC7Dlxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023212;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q4495yhJUmHZEhqV4q4rIq7NT1HsGQd3gb0JWaJ5DkY=;
	b=QxjxWaC5qDJsjfNbKEgTzlxRB1b/bsoITNbArgC+fXanHQ58gz9V+rn6f3j3LHhmRc9A
	 5YcXquOHqFEy2tEr2vHBNS7cov1KSVq3Pl6wQzTjbelW9IetHfR1gfcv5v+vJTI9QPzfr
	 XaUCu/5XV+/r5ZBdmvaEKCWa77TqqMIAUWpVf9BJp3y3xgr2DTUCJEGqDSB9q8n0V/xZH
	 lLHCv8o+4cnC/HHpDyechjeuejcgPIiX5awdthr//9whDgGq+bobWzLqTP/TL701PpbLx
	 PJuOVVGYvEen9Hi7xy0f5V0QYXso6R6NyVwYEoa9qQTf1A4nbExoWNS4VWIYrf3sigg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fx18QF+I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FE5606A320;
	Wed, 18 Nov 2026 17:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fx18QF+I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A831F00926;
	Wed, 18 Nov 2026 17:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023212;
	bh=Q4495yhJUmHZEhqV4q4rIq7NT1HsGQd3gb0JWaJ5DkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fx18QF+IBVLjhVmeNnaFrxwGjGTSUsNDq+DxpJ4cLtL+c3Bvh84TLeeknkng00tAn
	 9agq07IKiYWo8a5t+WDm/NDB/HjA93d2gstFCbfmK94OnwVxkW5CCwM+DbBWWfS3b9
	 aAdVCePZp6xKzKlao60JML7/kl+60pze1NOe6j0k=
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
Subject: [PATCH 6.18 0287/2151] perf bpf: Fix up build failure due to change of btf_vlen() return type
Date: Wed, 18 Nov 2026 15:33:42 +0100
Message-ID: <20261118150132.351270319@linuxfoundation.org>
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
index 046db6fcd7f7f..19ff67424c5d5 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -970,7 +970,7 @@ static bool syscall_arg__strtoul_btf_enum(char *bf, size_t size, struct syscall_
 	struct btf *btf = arg->trace->btf;
 	struct btf_enum *be = btf_enum(bt);
 
-	for (int i = 0; i < btf_vlen(bt); ++i, ++be) {
+	for (u32 i = 0; i < btf_vlen(bt); ++i, ++be) {
 		const char *name = btf__name_by_offset(btf, be->name_off);
 		int max_len = max(size, strlen(name));
 
@@ -1015,9 +1015,9 @@ static bool syscall_arg__strtoul_btf_type(char *bf, size_t size, struct syscall_
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



