Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061167;
	b=1R7QVHwrEiVZFudhhKXfpABuLGhlDwL3VLkqTmDSCPOzY9AfYjmeMiBQc2Rd1JyeMZnT
	 t9PWfEnp1DrWaypg3NXy59RBxsnzRTIhnWMKsUT/HC1ZS7r2JG5s654CzXHFbOFTqXVkA
	 Sf2pRFsveg4bllRK+rfzYhjLS2STWM9W9SJ3WCSLt9sje9ln8+hbvZSOlAhT5MBajl9E8
	 +k6FX72jUnpcfZ1uRUQguVm+xKVnjjlfTDRqQz1Pn2OzIhXavKeveH8lvd5ePmkotPVe9
	 VcYPYi8qIeaynuclkqCFkVUFpfX9alFgFNShPiLliVZYdqSRaTbeR3ulcPhk48DaHbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061167;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=97kggA0LO8FMCDq3kfg+i3FhAz2wLCzpQcwyJMBfRW4=;
	b=SsHDCL9u9bUZWMGnYWoNjLyGRDeyvadIC5q/kCCwi7PVROpeYdVouWjvyIhi5y93BUI3
	 sm1xqx6OOKUlqiBs41hV+jokNUr7DGpl6IYb0sQa3zj+h9ZJST0XDPEDELwb409oaXdZj
	 Fd8lHq8UZrkubjoGwF7a1owLJFsfCSlm0atVnh37uYnLQrZj97NXjszzw0gn7JJYLd2/S
	 W++GEdDsomJYx6OpKWC/yymv6MzY7+pabjIG0zDKsxhgrXSC9FUODAr9ZAo8mxaargG+m
	 JBDVzOyF9812urwXOw+V/qjFY2SalNwkNQlyX+AhbhznjftTsnCOIBwBoYFCmpymYKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XIndaSeM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BCA606A33A;
	Sat,  7 Nov 2026 14:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XIndaSeM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980C31F0089F;
	Sat,  7 Nov 2026 14:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061166;
	bh=97kggA0LO8FMCDq3kfg+i3FhAz2wLCzpQcwyJMBfRW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XIndaSeMQJS2hXC1KNDtjCt8I6GSrBMKhQBXVcmQmY66Bp1wuJxS8pZlVq+X6yF6n
	 nhYEFcbMbnPD4QdD2rhE6bhIBNSA46etVV+VPuZcMjaU2cFcq0Ku0SRPbuP4L6M4pD
	 JZmdrmEQGY21rMai4aM2k0WyYwTRylmvVzQ2RD+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Maurer <mmaurer@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0472/1536] module: Factor out elf_validity_cache_index_str
Date: Sat,  7 Nov 2026 08:41:28 -0500
Message-ID: <20261107135010.763283062@linuxfoundation.org>
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
index 0861682a36179..c6ca520b5fd59 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -2023,6 +2023,31 @@ static int elf_validity_cache_index_sym(struct load_info *info)
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
@@ -2046,7 +2071,6 @@ static int elf_validity_cache_index_sym(struct load_info *info)
 static int elf_validity_cache_copy(struct load_info *info, int flags)
 {
 	int err;
-	int str_idx;
 
 	err = elf_validity_cache_sechdrs(info);
 	if (err < 0)
@@ -2063,16 +2087,11 @@ static int elf_validity_cache_copy(struct load_info *info, int flags)
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



