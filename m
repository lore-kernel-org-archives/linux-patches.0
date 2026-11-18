Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034529;
	b=rhUeNTmPH6ycOuSr/Nhqx/b2QFKX4hsjVGA4mi63rSXWjO995Oj2qnlGQ8PmD5nXOCGw
	 95vdiwInfX3bzOj2xW3vzaErxyYmvowwGLl7PZOWIKz0dIrQhlT2VQ/8mq9N5xS3CL8Nh
	 O0rVk8EfZv7kkZepbRwEgnFjJV/vwdC1lS6d1JrYhZtUXCcD4V0MVSIDIt5DADacqPfOY
	 ZbIw6Kjjsa02MQNW5Epdzd3R10faGAI7cPLCIgnF+u7UquUtEhVHk5P0F00BhI7IupzyE
	 yAlaC0K5eNAHtT5aCjRrrPI4HgL9pKpmgX/3SVrDyScjyWT1BDn928KP/BAY/J24hWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034529;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=be/+nvS3vIjdv7z8eRJN+2iFfflgHpHd3hOgVB3lhKU=;
	b=gRhnKVnsQHSuRSdYpVp2bZX0qXbNiPKBogJY3GTy4728M2ItWXD6dJ6FJgVTn1QRSK+V
	 QRL7HovZXATful0d9+AUSDfWY8EsDR1z5ga6TEwueNw0oEq6JH7SKhFHbXBna203Jfw5o
	 MGl9dNKOm3FM/cJn4SFFcPw0HXkaRiC3rgYmkZJzQVWZLant50QwHXjnPCJTzhDJqssqy
	 4WWIwmTplomVsZ1m7qZdfFFAim8iSqezLO94DApE3vV8JOh/7Ya6Yxb3zkbKA9IdlQ2QH
	 1anv1wa8Bq0JnQfZ7toDSAKZSGWd+A17O886kOnnGTZyTd95itrzJ3BrfI7mcgpasUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=znJaCJ9V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54272606A320;
	Wed, 18 Nov 2026 20:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=znJaCJ9V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4D11F000C4;
	Wed, 18 Nov 2026 20:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034529;
	bh=be/+nvS3vIjdv7z8eRJN+2iFfflgHpHd3hOgVB3lhKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=znJaCJ9VBKx93nnl8jeUBwufKumLJBNNUKjxGm0lXZnk41dM3jqvQR2xWJhwnEJqH
	 F+ZfZW6sKOuXlwC4J4frhTNwspvn34gkmZWg3cel5aMoqkFBJsU24VZnNk2Um6aEgW
	 TXBrjRKOLemshRUUMXP26VgqFr4VmsjSek3gnXUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thi=C3=A9baud=20Weksteen?= <tweek@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0402/3318] module: validate string table section types
Date: Wed, 18 Nov 2026 15:17:04 +0100
Message-ID: <20261118150328.486120286@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0127adf7d7d5a..b0f4203d6f402 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1819,6 +1819,7 @@ static int elf_validity_cache_sechdrs(struct load_info *info)
  * Specifically checks:
  *
  * * Section name table index is inbounds of section headers
+ * * Section name table type is SHT_STRTAB
  * * Section name table is not empty
  * * Section name table is NUL terminated
  * * All section name offsets are inbounds of the section
@@ -1846,6 +1847,11 @@ static int elf_validity_cache_secstrings(struct load_info *info)
 
 	strhdr = &info->sechdrs[info->hdr->e_shstrndx];
 
+	if (strhdr->sh_type != SHT_STRTAB) {
+		pr_err("Invalid ELF section name table type: %u\n", strhdr->sh_type);
+		return -ENOEXEC;
+	}
+
 	/*
 	 * The section name table must be NUL-terminated, as required
 	 * by the spec. This makes strcmp and pr_* calls that access
@@ -2012,7 +2018,7 @@ static int elf_validity_cache_index_sym(struct load_info *info)
  *        Must have &load_info->index.sym populated.
  *
  * Looks at the symbol table's associated string table, makes sure it is
- * in-bounds, and caches it.
+ * in-bounds and of type SHT_STRTAB, and caches it.
  *
  * Return: %0 if valid, %-ENOEXEC on failure.
  */
@@ -2026,6 +2032,12 @@ static int elf_validity_cache_index_str(struct load_info *info)
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



