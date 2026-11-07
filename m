Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061164;
	b=vzMaOeBe1LDTx+JF8emu+LmfnPN8qgfRLq3Ri2pmi7YM+oYZg9Q3fJYNru24JMUd1Vj7
	 Tx9Y/5/LxlvsNqjs9ydazGW9KTR0FBtgJxC960r96Kz0ltBlQRusrVtTnkUgQTfjoPhQA
	 p4EMChNwrlvhA/VWfVAUF/NeCCVEoNNfB8+8kS42lAUXxEbgv8MxEHJU7ivUEjPSLbIbC
	 VwgYmq+oqOfA02QlM2dh2m+R/58v7QGiLsyFV3R4lprGr7EACk5pWCzHHlIfbFqu0XRmo
	 XvJ8+J8Q4dUyy/aXsjJIU5SxedaA9exr9tXJSw/XA+mhnF0DrDZxa/o0ne/8sLCljQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061164;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v/Ts0D0eBc97SpxQN4xcRCzAK157gtN+OxgX0aXb6W0=;
	b=tV8S12UmsZR5a4n9qtOPkZ3rqrws1EHWMH1UjCtJN6yfvyJIVj6zAfFYUd1cA+MWXz5f
	 HFtPJCz/6Cp2jdAo9Yy4T8IarprghLRaPtTxe6MYeKyxBD+9hBs+LFJ6ku7H4o0qoweJ6
	 Z8kv3IwjOzwwPeQLiVCvXTiSe1+h1z0DHDNl/oZBy3Y3iFEjPEmcSrULejfm1X2LtlxLK
	 UXVfSJKHwnQqQxWrZUkb6StXOEYclF53uev8/YNJf+sjVt9+KkzesZQizAuT1qphoD2xZ
	 oM6V93Ad2oXCQ5lYnqCpuYECbCvPsB0MFUuWFb9IqpoRzxognlKn+5QWXE+t79VDTcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AOefdpDL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EDF606EEBE;
	Sat,  7 Nov 2026 14:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AOefdpDL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3A11F0089F;
	Sat,  7 Nov 2026 14:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061164;
	bh=v/Ts0D0eBc97SpxQN4xcRCzAK157gtN+OxgX0aXb6W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AOefdpDLME+2Gqf7Nk0OVuLrsx0E0JocUPT0A6xFnAyYURS9eEl13Nh0StnaAsJxn
	 iQ04e8JsBo8/kEOPQNQLv//C/b9llEpjps/38QO35XTA4IjWb6gr8OOE75VTg2IWFY
	 MNepphCCsl6cQ4TBJXS91VxImZASSCy63L0kdcV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Maurer <mmaurer@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0470/1536] module: Factor out elf_validity_cache_index_mod
Date: Sat,  7 Nov 2026 08:41:26 -0500
Message-ID: <20261107135010.714348255@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Matthew Maurer <mmaurer@google.com>

[ Upstream commit 0be41a9367d1fbb16b4b57d81082341af114bad7 ]

Centralize .gnu.linkonce.this_module detection and property validation.

Signed-off-by: Matthew Maurer <mmaurer@google.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Stable-dep-of: 9a5ff4568932 ("module: validate string table section types")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/main.c | 129 ++++++++++++++++++++++---------------------
 1 file changed, 67 insertions(+), 62 deletions(-)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index 87ce807015b30..d77bb2cf7a0e6 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1928,6 +1928,68 @@ static int elf_validity_cache_index_info(struct load_info *info)
 	return 0;
 }
 
+/**
+ * elf_validity_cache_index_mod() - Validates and caches this_module section
+ * @info: Load info to cache this_module on.
+ *        Must have &load_info->sechdrs and &load_info->secstrings populated
+ *
+ * The ".gnu.linkonce.this_module" ELF section is special. It is what modpost
+ * uses to refer to __this_module and let's use rely on THIS_MODULE to point
+ * to &__this_module properly. The kernel's modpost declares it on each
+ * modules's *.mod.c file. If the struct module of the kernel changes a full
+ * kernel rebuild is required.
+ *
+ * We have a few expectations for this special section, this function
+ * validates all this for us:
+ *
+ * * The section has contents
+ * * The section is unique
+ * * We expect the kernel to always have to allocate it: SHF_ALLOC
+ * * The section size must match the kernel's run time's struct module
+ *   size
+ *
+ * If all checks pass, the index will be cached in &load_info->index.mod
+ *
+ * Return: %0 on validation success, %-ENOEXEC on failure
+ */
+static int elf_validity_cache_index_mod(struct load_info *info)
+{
+	Elf_Shdr *shdr;
+	int mod_idx;
+
+	mod_idx = find_any_unique_sec(info, ".gnu.linkonce.this_module");
+	if (mod_idx <= 0) {
+		pr_err("module %s: Exactly one .gnu.linkonce.this_module section must exist.\n",
+		       info->name ?: "(missing .modinfo section or name field)");
+		return -ENOEXEC;
+	}
+
+	shdr = &info->sechdrs[mod_idx];
+
+	if (shdr->sh_type == SHT_NOBITS) {
+		pr_err("module %s: .gnu.linkonce.this_module section must have a size set\n",
+		       info->name ?: "(missing .modinfo section or name field)");
+		return -ENOEXEC;
+	}
+
+	if (!(shdr->sh_flags & SHF_ALLOC)) {
+		pr_err("module %s: .gnu.linkonce.this_module must occupy memory during process execution\n",
+		       info->name ?: "(missing .modinfo section or name field)");
+		return -ENOEXEC;
+	}
+
+	if (shdr->sh_size != sizeof(struct module)) {
+		pr_err("module %s: .gnu.linkonce.this_module section size must match the kernel's built struct module size at run time\n",
+		       info->name ?: "(missing .modinfo section or name field)");
+		return -ENOEXEC;
+	}
+
+	info->index.mod = mod_idx;
+
+	return 0;
+}
+
+
 /*
  * Check userspace passed ELF module against our expectations, and cache
  * useful variables for further processing as we go.
@@ -1953,7 +2015,6 @@ static int elf_validity_cache_copy(struct load_info *info, int flags)
 	unsigned int i;
 	Elf_Shdr *shdr;
 	int err;
-	unsigned int num_mod_secs = 0, mod_idx;
 	unsigned int num_sym_secs = 0, sym_idx;
 
 	err = elf_validity_cache_sechdrs(info);
@@ -1963,16 +2024,15 @@ static int elf_validity_cache_copy(struct load_info *info, int flags)
 	if (err < 0)
 		return err;
 	err = elf_validity_cache_index_info(info);
+	if (err < 0)
+		return err;
+	err = elf_validity_cache_index_mod(info);
 	if (err < 0)
 		return err;
 
 	for (i = 1; i < info->hdr->e_shnum; i++) {
 		shdr = &info->sechdrs[i];
-		switch (shdr->sh_type) {
-		case SHT_NULL:
-		case SHT_NOBITS:
-			continue;
-		case SHT_SYMTAB:
+		if (shdr->sh_type == SHT_SYMTAB) {
 			if (shdr->sh_link == SHN_UNDEF
 			    || shdr->sh_link >= info->hdr->e_shnum) {
 				pr_err("Invalid ELF sh_link!=SHN_UNDEF(%d) or (sh_link(%d) >= hdr->e_shnum(%d)\n",
@@ -1982,14 +2042,6 @@ static int elf_validity_cache_copy(struct load_info *info, int flags)
 			}
 			num_sym_secs++;
 			sym_idx = i;
-			fallthrough;
-		default:
-			if (strcmp(info->secstrings + shdr->sh_name,
-				   ".gnu.linkonce.this_module") == 0) {
-				num_mod_secs++;
-				mod_idx = i;
-			}
-			break;
 		}
 	}
 
@@ -2005,55 +2057,8 @@ static int elf_validity_cache_copy(struct load_info *info, int flags)
 	info->index.str = shdr->sh_link;
 	info->strtab = (char *)info->hdr + info->sechdrs[info->index.str].sh_offset;
 
-	/*
-	 * The ".gnu.linkonce.this_module" ELF section is special. It is
-	 * what modpost uses to refer to __this_module and let's use rely
-	 * on THIS_MODULE to point to &__this_module properly. The kernel's
-	 * modpost declares it on each modules's *.mod.c file. If the struct
-	 * module of the kernel changes a full kernel rebuild is required.
-	 *
-	 * We have a few expectaions for this special section, the following
-	 * code validates all this for us:
-	 *
-	 *   o Only one section must exist
-	 *   o We expect the kernel to always have to allocate it: SHF_ALLOC
-	 *   o The section size must match the kernel's run time's struct module
-	 *     size
-	 */
-	if (num_mod_secs != 1) {
-		pr_err("module %s: Only one .gnu.linkonce.this_module section must exist.\n",
-		       info->name ?: "(missing .modinfo section or name field)");
-		goto no_exec;
-	}
-
-	shdr = &info->sechdrs[mod_idx];
-
-	/*
-	 * This is already implied on the switch above, however let's be
-	 * pedantic about it.
-	 */
-	if (shdr->sh_type == SHT_NOBITS) {
-		pr_err("module %s: .gnu.linkonce.this_module section must have a size set\n",
-		       info->name ?: "(missing .modinfo section or name field)");
-		goto no_exec;
-	}
-
-	if (!(shdr->sh_flags & SHF_ALLOC)) {
-		pr_err("module %s: .gnu.linkonce.this_module must occupy memory during process execution\n",
-		       info->name ?: "(missing .modinfo section or name field)");
-		goto no_exec;
-	}
-
-	if (shdr->sh_size != sizeof(struct module)) {
-		pr_err("module %s: .gnu.linkonce.this_module section size must match the kernel's built struct module size at run time\n",
-		       info->name ?: "(missing .modinfo section or name field)");
-		goto no_exec;
-	}
-
-	info->index.mod = mod_idx;
-
 	/* This is temporary: point mod into copy of data. */
-	info->mod = (void *)info->hdr + shdr->sh_offset;
+	info->mod = (void *)info->hdr + info->sechdrs[info->index.mod].sh_offset;
 
 	/*
 	 * If we didn't load the .modinfo 'name' field earlier, fall back to
-- 
2.53.0



