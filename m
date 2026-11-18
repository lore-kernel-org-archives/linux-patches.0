Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034526;
	b=wCXnfPS8IjRu1f1H9I5zgSHWjNK9bkcUO4oICVl7OBQyAyI6XpQYJ3d3QzR+w88Ee2JQ
	 VPDhv27y5yeyullxQ6Hiyiy2eM2mqQ939Oct6cTF5Te1ZYIPl0ih6l9xDUOqmKPwUlguG
	 bdufAqEZRMFm5n6BqT7YIpG/mtqkABX3tm8yeTNWMJKiLIU86tTftxVCIRL+zFv2ycRaZ
	 E30OTf1gip/wxxHLrvimvKru01db4b0nBg04cMFlKMcYRKy1gGzIen78SNlz16x1xORhC
	 1eO76B/rSWK/O6QeREUDbGuqp8fkpPAislczMzbf/S+U30M1vb8ouj9yUZdKMkBQLnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034526;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=33JtkiGj4LpKaLPpPzCFhAz/eYjbKVNc6zIvC4gq0hA=;
	b=yEId5aqlRM3DP/OSY+lqRYyq6C1n+UpmBGs5F0sB/6xp6MRMqGWcIQ2fzz7BSOSBrWXF
	 qQa/hNfiE7Zsh7oAQ0IXIsfUivpvA0pYRSsUaJEJBh/ZP7azieRUlRowxlNAwueWjX/Uj
	 5e++xpYxK15LLUSKagv/fVavl+NFx1fLVySP7c2Tabu/8Qvywr4Z3+V6I0oLhvyY4Jgxy
	 ji1A7/KwkbcTn6hZF35NPGPb81epE8btabebI+HPw1wjPqe0oB+7Wi4Zy8S+nQwkl4tEh
	 IgemUndVNcg4zBk/tdJT6M9azhYRdZWxfCDHKR9+Kigv6yFkEV/uqYIR4VBhd9nUKxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r5OrcYRH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD30606A31C;
	Wed, 18 Nov 2026 20:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r5OrcYRH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3A11F000C4;
	Wed, 18 Nov 2026 20:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034526;
	bh=33JtkiGj4LpKaLPpPzCFhAz/eYjbKVNc6zIvC4gq0hA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r5OrcYRHTAlLrNolgdTlyUsWXf5Wj/fC4Hgq4yE3n31/ihtQbACcvvdWrDvgVPgTZ
	 FJp3Lg0zR1HWFsoSmcmaOjEsC7DXEe06HnJypnNIyGRDhufEdD1F44cCISQwieEm8S
	 woFRZMPrNEe5ccVHoNXh86SQYuueJcy7nH0lpOAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Maurer <mmaurer@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0401/3318] module: Factor out elf_validity_cache_index_str
Date: Wed, 18 Nov 2026 15:17:03 +0100
Message-ID: <20261118150328.447525504@linuxfoundation.org>
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

[ Upstream commit 0a9395334496d3be8bde491e46087540cb8f141d ]

Pull out index validation for the symbol string section.

Note that this does not validate the *contents* of the string table,
only shape and presence of the section.

Signed-off-by: Matthew Maurer <mmaurer@google.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Stable-dep-of: 9a5ff4568932 ("module: validate string table section types")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/main.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index da90817c711dc..0127adf7d7d5a 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -2005,6 +2005,31 @@ static int elf_validity_cache_index_sym(struct load_info *info)
 	return 0;
 }
 
+/**
+ * elf_validity_cache_index_str() - Validate and cache strtab index
+ * @info: Load info to cache strtab index in.
+ *        Must have &load_info->sechdrs and &load_info->secstrings populated.
+ *        Must have &load_info->index.sym populated.
+ *
+ * Looks at the symbol table's associated string table, makes sure it is
+ * in-bounds, and caches it.
+ *
+ * Return: %0 if valid, %-ENOEXEC on failure.
+ */
+static int elf_validity_cache_index_str(struct load_info *info)
+{
+	unsigned int str_idx = info->sechdrs[info->index.sym].sh_link;
+
+	if (str_idx == SHN_UNDEF || str_idx >= info->hdr->e_shnum) {
+		pr_err("Invalid ELF sh_link!=SHN_UNDEF(%d) or (sh_link(%d) >= hdr->e_shnum(%d)\n",
+		       str_idx, str_idx, info->hdr->e_shnum);
+		return -ENOEXEC;
+	}
+
+	info->index.str = str_idx;
+	return 0;
+}
+
 /*
  * Check userspace passed ELF module against our expectations, and cache
  * useful variables for further processing as we go.
@@ -2028,7 +2053,6 @@ static int elf_validity_cache_index_sym(struct load_info *info)
 static int elf_validity_cache_copy(struct load_info *info, int flags)
 {
 	int err;
-	int str_idx;
 
 	err = elf_validity_cache_sechdrs(info);
 	if (err < 0)
@@ -2045,16 +2069,11 @@ static int elf_validity_cache_copy(struct load_info *info, int flags)
 	err = elf_validity_cache_index_sym(info);
 	if (err < 0)
 		return err;
-
-	str_idx = info->sechdrs[info->index.sym].sh_link;
-	if (str_idx == SHN_UNDEF || str_idx >= info->hdr->e_shnum) {
-		pr_err("Invalid ELF sh_link!=SHN_UNDEF(%d) or (sh_link(%d) >= hdr->e_shnum(%d)\n",
-				str_idx, str_idx, info->hdr->e_shnum);
-		return -ENOEXEC;
-	}
+	err = elf_validity_cache_index_str(info);
+	if (err < 0)
+		return err;
 
 	/* Sets internal strings. */
-	info->index.str = str_idx;
 	info->strtab = (char *)info->hdr + info->sechdrs[info->index.str].sh_offset;
 
 	/* This is temporary: point mod into copy of data. */
-- 
2.53.0



