Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034524;
	b=2QBc+B63kBUDg6OiBsT0NbBjXhF34uNKzQVGjbxTH5OwPlc8R3j4VBxv3+pmwI1ac3hA
	 zH01z9Aa7TRsU41qp3aJGNbBFrsXm+q/ueKNjkYkEux5ovlLSnFxbvnX3TvRWzOiiUpnz
	 6Lb4Af3BTXDhMIqs2CsyaWCPKZLrL+jXu1ZRigIYilhvNzJHx+QEpFvM7vV0ViwMiyiGd
	 QALNPmnZT4TUJD4zOQP5rcM7dVP90F/ckHBOrdXZyb1cCT0SksHPpNY91u8EzGZ4BAA92
	 ILG6lg5D6kmD8BnsLtE3wUX+05T/fVnpht/8u1+088KdXJ9dChh1WQVlK4mVBKI5Crg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mqnKhbBZzbs9YhaJ5Yj7MxIh802SR05rNVhCgMPugng=;
	b=5pQTOMcBTtnD79CyJM/l81YOu9xSJ1kXTqu3ZcJ7zt9PLQP+6CakpK6dSDi79/IVLuRt
	 hYSkQJ3Msy0lh2s8x+ohZ3IMkEECecN0vCgd3o46mgvd5F9qYggGXi2gRmlzuqhy0Phkf
	 0RG31GxeK0mdrzcYtEc9t0L1sYhlZzVazqd67qLvOIJZkX93vN53UE/eYeLEcZ8bj8mCx
	 RxviGd2KqDUuv61k0CtPjCvZBs9cUZeiXgOPhB7mi1DRpw9vlB3h0LkIb1TeAZNZXO3iP
	 t9ntSUkLPgzN/aPf+D/M2KGeB81hSmmUNk8gMW8Hl8Qb50onV5ybkAXrfGwkhy+I8QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AvrmyWOO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058CF606A31C;
	Wed, 18 Nov 2026 20:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AvrmyWOO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9971F000C4;
	Wed, 18 Nov 2026 20:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034523;
	bh=mqnKhbBZzbs9YhaJ5Yj7MxIh802SR05rNVhCgMPugng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AvrmyWOOoi/1bnvaDxndt6rq0uvNXr1yl+iSGoPq0CLbGWTDrLfjycZhdMAdJbJkh
	 t1HX8HeW1CY/Cj6QuwZHOUZoZ6NILR+KjY+2Xy6vuCHN71eAZ0JbSE5gv50kMRLzno
	 fUh6AjZW6gMiDrd534rlvhkwYlq5qvP5sPNbvTz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Maurer <mmaurer@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0400/3318] module: Factor out elf_validity_cache_index_sym
Date: Wed, 18 Nov 2026 15:17:02 +0100
Message-ID: <20261118150328.409617424@linuxfoundation.org>
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

From: Matthew Maurer <mmaurer@google.com>

[ Upstream commit 9bd4982cf7d65f4c9e0793d5a8fda6ad838e8554 ]

Centralize symbol table detection and property validation.

Signed-off-by: Matthew Maurer <mmaurer@google.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Stable-dep-of: 9a5ff4568932 ("module: validate string table section types")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/main.c | 73 ++++++++++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 29 deletions(-)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index 75a543d6aa9f6..da90817c711dc 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1971,6 +1971,39 @@ static int elf_validity_cache_index_mod(struct load_info *info)
 	return 0;
 }
 
+/**
+ * elf_validity_cache_index_sym() - Validate and cache symtab index
+ * @info: Load info to cache symtab index in.
+ *        Must have &load_info->sechdrs and &load_info->secstrings populated.
+ *
+ * Checks that there is exactly one symbol table, then caches its index in
+ * &load_info->index.sym.
+ *
+ * Return: %0 if valid, %-ENOEXEC on failure.
+ */
+static int elf_validity_cache_index_sym(struct load_info *info)
+{
+	unsigned int sym_idx;
+	unsigned int num_sym_secs = 0;
+	int i;
+
+	for (i = 1; i < info->hdr->e_shnum; i++) {
+		if (info->sechdrs[i].sh_type == SHT_SYMTAB) {
+			num_sym_secs++;
+			sym_idx = i;
+		}
+	}
+
+	if (num_sym_secs != 1) {
+		pr_warn("%s: module has no symbols (stripped?)\n",
+			info->name ?: "(missing .modinfo section or name field)");
+		return -ENOEXEC;
+	}
+
+	info->index.sym = sym_idx;
+
+	return 0;
+}
 
 /*
  * Check userspace passed ELF module against our expectations, and cache
@@ -1994,10 +2027,8 @@ static int elf_validity_cache_index_mod(struct load_info *info)
  */
 static int elf_validity_cache_copy(struct load_info *info, int flags)
 {
-	unsigned int i;
-	Elf_Shdr *shdr;
 	int err;
-	unsigned int num_sym_secs = 0, sym_idx;
+	int str_idx;
 
 	err = elf_validity_cache_sechdrs(info);
 	if (err < 0)
@@ -2009,34 +2040,21 @@ static int elf_validity_cache_copy(struct load_info *info, int flags)
 	if (err < 0)
 		return err;
 	err = elf_validity_cache_index_mod(info);
+	if (err < 0)
+		return err;
+	err = elf_validity_cache_index_sym(info);
 	if (err < 0)
 		return err;
 
-	for (i = 1; i < info->hdr->e_shnum; i++) {
-		shdr = &info->sechdrs[i];
-		if (shdr->sh_type == SHT_SYMTAB) {
-			if (shdr->sh_link == SHN_UNDEF
-			    || shdr->sh_link >= info->hdr->e_shnum) {
-				pr_err("Invalid ELF sh_link!=SHN_UNDEF(%d) or (sh_link(%d) >= hdr->e_shnum(%d)\n",
-				       shdr->sh_link, shdr->sh_link,
-				       info->hdr->e_shnum);
-				goto no_exec;
-			}
-			num_sym_secs++;
-			sym_idx = i;
-		}
-	}
-
-	if (num_sym_secs != 1) {
-		pr_warn("%s: module has no symbols (stripped?)\n",
-			info->name ?: "(missing .modinfo section or name field)");
-		goto no_exec;
+	str_idx = info->sechdrs[info->index.sym].sh_link;
+	if (str_idx == SHN_UNDEF || str_idx >= info->hdr->e_shnum) {
+		pr_err("Invalid ELF sh_link!=SHN_UNDEF(%d) or (sh_link(%d) >= hdr->e_shnum(%d)\n",
+				str_idx, str_idx, info->hdr->e_shnum);
+		return -ENOEXEC;
 	}
 
-	/* Sets internal symbols and strings. */
-	info->index.sym = sym_idx;
-	shdr = &info->sechdrs[sym_idx];
-	info->index.str = shdr->sh_link;
+	/* Sets internal strings. */
+	info->index.str = str_idx;
 	info->strtab = (char *)info->hdr + info->sechdrs[info->index.str].sh_offset;
 
 	/* This is temporary: point mod into copy of data. */
@@ -2057,9 +2075,6 @@ static int elf_validity_cache_copy(struct load_info *info, int flags)
 	info->index.pcpu = find_pcpusec(info);
 
 	return 0;
-
-no_exec:
-	return -ENOEXEC;
 }
 
 #define COPY_CHUNK_SIZE (16*PAGE_SIZE)
-- 
2.53.0



