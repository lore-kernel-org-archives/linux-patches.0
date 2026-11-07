Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061169;
	b=u9/DtQa4Row8MrL7OqFpSEfIImDOw6DqGtPYRMt17ooPEaica2gZHLyMlFeQ4S+TUUQ3
	 wKEqgDDB+cDV4pM3V8BCt28GEGQwvVQrmhAnSjiqE2jRaVVvyfwVtIV6mdwv/E9dOnbP7
	 2I0+ukzdQ8aIN5qjfn0MboOHMOIwZl2ljZUHDQVjestJKD8pBdo3/FsUxmNccg2RRTxpX
	 sWemkpTl/HBsr8ngTl9NaJ3Bw06tS+ba/4bepCNEK8985bz3+OT1FCz5P9fNy+5d97uc1
	 g3S43JhmwSM04szuEk8tmhElBba8KrI0jhVnv6h30t5V89LRBuQM1fXS+7z4tyoDj9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061169;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JnN2dlaWv1cE6ekrVMZsJe3OVkJtZBeIJ0lQGu07M34=;
	b=D+N3Ul2+nVhnr0TZ/M7lWAi94pO8bN3WaTZlsmw/F5yCkecK6/EZ3vk2UGOCCNbxR5fS
	 59N9w/j5YIk8jC3buH/y1wH7pcnVW0iszV3vaSzpbLjxh0LzC0+viTm+pRaMj8CGWKnyC
	 lF21S1cLjixYKRPfvXMZaXIjdT0WPDB2u9WmFLaOUcd4aRiKD1R1B20RfKjiXY+u9MuO1
	 WKLrYrG66ixajWy79PWmGJrsikL3uFC8vgJKL62A1wYa6XRgKwuCPzqsbf7hthXa0VlaL
	 RfSsG+z/xjjF6ddhTgprgfJhiwFonEDEYZoKDOupTzdmFhHuC9IUhQO3vuMUBwUU8qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OXyQ2YTw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBCA606A33A;
	Sat,  7 Nov 2026 14:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OXyQ2YTw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD5F1F0089F;
	Sat,  7 Nov 2026 14:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061169;
	bh=JnN2dlaWv1cE6ekrVMZsJe3OVkJtZBeIJ0lQGu07M34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OXyQ2YTw4YD8zO19xx2//cuv6Ah5ru+3a46Ev8GgJuHJMvEFev7BE391SBDRv+avB
	 7Q2eY0ZNMSE8UlAECr4dY5A32GGjjZA4M+amR6lRPycs7H4jkKuYyJ0Rbjl6uiGQ2y
	 piGH7IYzwzp5Vtd+/6LXZ+K+HxsgPdgB1C0TZlOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thi=C3=A9baud=20Weksteen?= <tweek@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0473/1536] module: validate string table section types
Date: Sat,  7 Nov 2026 08:41:29 -0500
Message-ID: <20261107135010.789991843@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thiébaud Weksteen <tweek@google.com>

[ Upstream commit 9a5ff45689329835f874cefe5174e577d141d423 ]

In elf_validity_cache_sechdrs, section sizes and offsets are validated,
unless the section type is SHT_NULL or SHT_NOBITS.

Later, elf_validity_cache_secstrings and elf_validity_cache_index_str
access the section name table (.shstrtab) and symbol string table
(.strtab) headers without first ensuring that their types are
SHT_STRTAB. If a section type is SHT_NULL or SHT_NOBITS, sh_offset has
not been validated and may reference out-of-bounds memory when
dereferenced in elf_validity_cache_secstrings or
elf_validity_cache_strtab.

Validate that both string section headers are of type SHT_STRTAB before
caching them.

Cc: stable@vger.kernel.org
Signed-off-by: Thiébaud Weksteen <tweek@google.com>
Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/main.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index c6ca520b5fd59..c6d07c8c0b4a9 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1837,6 +1837,7 @@ static int elf_validity_cache_sechdrs(struct load_info *info)
  * Specifically checks:
  *
  * * Section name table index is inbounds of section headers
+ * * Section name table type is SHT_STRTAB
  * * Section name table is not empty
  * * Section name table is NUL terminated
  * * All section name offsets are inbounds of the section
@@ -1864,6 +1865,11 @@ static int elf_validity_cache_secstrings(struct load_info *info)
 
 	strhdr = &info->sechdrs[info->hdr->e_shstrndx];
 
+	if (strhdr->sh_type != SHT_STRTAB) {
+		pr_err("Invalid ELF section name table type: %u\n", strhdr->sh_type);
+		return -ENOEXEC;
+	}
+
 	/*
 	 * The section name table must be NUL-terminated, as required
 	 * by the spec. This makes strcmp and pr_* calls that access
@@ -2030,7 +2036,7 @@ static int elf_validity_cache_index_sym(struct load_info *info)
  *        Must have &load_info->index.sym populated.
  *
  * Looks at the symbol table's associated string table, makes sure it is
- * in-bounds, and caches it.
+ * in-bounds and of type SHT_STRTAB, and caches it.
  *
  * Return: %0 if valid, %-ENOEXEC on failure.
  */
@@ -2044,6 +2050,12 @@ static int elf_validity_cache_index_str(struct load_info *info)
 		return -ENOEXEC;
 	}
 
+	if (info->sechdrs[str_idx].sh_type != SHT_STRTAB) {
+		pr_err("Invalid ELF symbol string table type: %u\n",
+		       info->sechdrs[str_idx].sh_type);
+		return -ENOEXEC;
+	}
+
 	info->index.str = str_idx;
 	return 0;
 }
-- 
2.53.0



