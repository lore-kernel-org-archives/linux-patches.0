Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034518;
	b=KoOpZ1HaOk+jw+n/uNEZ+VYBBjpDcvnGFRJ/LAL9dMYK9KpR70aoBfsy34NR/DzfutJ/
	 9+IW/MLHLMO9FKdEChXnHmPTwYsVw8EGV9GA93U5WHUWkygNHReN+NY9ob4HS/XmgJmj4
	 E6pQqclKK5PBUYjRgQAt2BIT82Juqf0qUQzS/BB1S6o2ONTRRY440XOKdPpfMTbGrIcH7
	 UUd0k98goC7uV+9l8YpqVnExa/QlGGj+++qKSZxSGry2V3fXuKudWH21RFjZMnGmot7yC
	 yxtIHH6UROPNsQwetfpSyo6axtpuLGRYuKb81xOP/81cQogLwdlCAUoLJxcPDyoKq0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034518;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7ObzYtGudFpQqEIHRhCRCnR1ZQ/SogTAmeihnTREMMo=;
	b=C+z2jr+F+K5gjqZ73Z6ILcwzAHJ/SUHWGopVl5tGdTl+f2JLSqbM2CUdNiapdtqjqgDM
	 bloaj7yA3yx3bVfKepUlAF5vrvSr83RFqQraogwwGIQbqt22Cwek+hPX+gWYI7uFk3U2q
	 2wzKaNtso265yDAKyC/bUPH8knzxS1zRWEyuBUUgbWiKngEKkpPMCI5XV2e1zXSezT2aQ
	 6OKkMkJTmFFyoof+gLFhzqTV0Zq8UY5YeUKAAOK5tUoioebo9R6WKhuAbt++sCJ/VONDn
	 AzJ8baQmvRn9R+gupUP00o4y5QtSzKgIQODRFD9epa1ybhOmYeZiLcjhvHPP3RypUCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BqaRONfN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C43606A31C;
	Wed, 18 Nov 2026 20:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BqaRONfN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D995F1F000C4;
	Wed, 18 Nov 2026 20:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034518;
	bh=7ObzYtGudFpQqEIHRhCRCnR1ZQ/SogTAmeihnTREMMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BqaRONfN3DsRb6X99L9RUT4um0nlY0u0XtZm8to5wYPNvNWNwCIO0BFstL5KMgvL9
	 twcxZRzgaC2c2/kq/NQGk46ncrZZXfA5j9OgMw+fMD0N4HqDFs82hwerT4Tozz2QYD
	 86O+V3LbWJKm6LoLJNzqzE/5TTT3RfBmoH/G6ZiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Maurer <mmaurer@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0398/3318] module: Factor out elf_validity_cache_index_info
Date: Wed, 18 Nov 2026 15:17:00 +0100
Message-ID: <20261118150328.336127448@linuxfoundation.org>
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

[ Upstream commit fbc0e4e482aac7f2b0d20f0a11f6d5eeda346fda ]

Centralize .modinfo detection and property validation.

Signed-off-by: Matthew Maurer <mmaurer@google.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Stable-dep-of: 9a5ff4568932 ("module: validate string table section types")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/main.c | 82 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 68 insertions(+), 14 deletions(-)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index c1163cab7bcae..4048174f7160c 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -193,6 +193,38 @@ static unsigned int find_sec(const struct load_info *info, const char *name)
 	return 0;
 }
 
+/**
+ * find_any_unique_sec() - Find a unique section index by name
+ * @info: Load info for the module to scan
+ * @name: Name of the section we're looking for
+ *
+ * Locates a unique section by name. Ignores SHF_ALLOC.
+ *
+ * Return: Section index if found uniquely, zero if absent, negative count
+ *         of total instances if multiple were found.
+ */
+static int find_any_unique_sec(const struct load_info *info, const char *name)
+{
+	unsigned int idx;
+	unsigned int count = 0;
+	int i;
+
+	for (i = 1; i < info->hdr->e_shnum; i++) {
+		if (strcmp(info->secstrings + info->sechdrs[i].sh_name,
+			   name) == 0) {
+			count++;
+			idx = i;
+		}
+	}
+	if (count == 1) {
+		return idx;
+	} else if (count == 0) {
+		return 0;
+	} else {
+		return -count;
+	}
+}
+
 /* Find a module section, or NULL. */
 static void *section_addr(const struct load_info *info, const char *name)
 {
@@ -1845,6 +1877,39 @@ static int elf_validity_cache_secstrings(struct load_info *info)
 	return 0;
 }
 
+/**
+ * elf_validity_cache_index_info() - Validate and cache modinfo section
+ * @info: Load info to populate the modinfo index on.
+ *        Must have &load_info->sechdrs and &load_info->secstrings populated
+ *
+ * Checks that if there is a .modinfo section, it is unique.
+ * Then, it caches its index in &load_info->index.info.
+ * Finally, it tries to populate the name to improve error messages.
+ *
+ * Return: %0 if valid, %-ENOEXEC if multiple modinfo sections were found.
+ */
+static int elf_validity_cache_index_info(struct load_info *info)
+{
+	int info_idx;
+
+	info_idx = find_any_unique_sec(info, ".modinfo");
+
+	if (info_idx == 0)
+		/* Early return, no .modinfo */
+		return 0;
+
+	if (info_idx < 0) {
+		pr_err("Only one .modinfo section must exist.\n");
+		return -ENOEXEC;
+	}
+
+	info->index.info = info_idx;
+	/* Try to find a name early so we can log errors with a module name */
+	info->name = get_modinfo(info, "name");
+
+	return 0;
+}
+
 /*
  * Check userspace passed ELF module against our expectations, and cache
  * useful variables for further processing as we go.
@@ -1871,13 +1936,15 @@ static int elf_validity_cache_copy(struct load_info *info, int flags)
 	Elf_Shdr *shdr;
 	int err;
 	unsigned int num_mod_secs = 0, mod_idx;
-	unsigned int num_info_secs = 0, info_idx;
 	unsigned int num_sym_secs = 0, sym_idx;
 
 	err = elf_validity_cache_sechdrs(info);
 	if (err < 0)
 		return err;
 	err = elf_validity_cache_secstrings(info);
+	if (err < 0)
+		return err;
+	err = elf_validity_cache_index_info(info);
 	if (err < 0)
 		return err;
 
@@ -1903,24 +1970,11 @@ static int elf_validity_cache_copy(struct load_info *info, int flags)
 				   ".gnu.linkonce.this_module") == 0) {
 				num_mod_secs++;
 				mod_idx = i;
-			} else if (strcmp(info->secstrings + shdr->sh_name,
-				   ".modinfo") == 0) {
-				num_info_secs++;
-				info_idx = i;
 			}
 			break;
 		}
 	}
 
-	if (num_info_secs > 1) {
-		pr_err("Only one .modinfo section must exist.\n");
-		goto no_exec;
-	} else if (num_info_secs == 1) {
-		/* Try to find a name early so we can log errors with a module name */
-		info->index.info = info_idx;
-		info->name = get_modinfo(info, "name");
-	}
-
 	if (num_sym_secs != 1) {
 		pr_warn("%s: module has no symbols (stripped?)\n",
 			info->name ?: "(missing .modinfo section or name field)");
-- 
2.53.0



