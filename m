Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043812;
	b=JXyBT0bDv70e+KMbOPKYNAxg8oaxFesSSWbUAXM4fW6eYBTJN5XFANNGu6obTPZaDpc6
	 giAmc/3/HfAlmkx1+gfW/+m0GjR6mRmuH3fPX0bytdCUdERd1R/szfcWIB6XolqkneeGH
	 aj9AS1WcYC6RPF2o86ZHsa/VgfQmh4bulVDDNzoDSvXi0wyVPUQIpUpZCXK6UzkS62eqq
	 m7cZIvmNoSTYmR3OeNruY0pgefDCRd+diSoCqXo1e5l6qjgE/XKKyQth7pOM1gQGp2Zox
	 pm0cei590EuXiRzdsINJeTS/80lKq8fSOGwHVpPdYQg4hWTInTEyxZcz+/dSqHMUAYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043812;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=As9kQK7UIzR7UjiQsRYJidba4LzJSgwq4ZQnrnlSPQ8=;
	b=Xfy0rJ4LjMwOO+LrEhWZFGORcvV24fY0lIu4YsIgfVc2MzdKnRRWdQZuOBQTrmdw/Kyu
	 +JlEhGrayi5gf0RdxNmh9l9YvAr0LF9RKU/FhUp7MWZtAr2MgDzspB3FIPiRFZsTO9Ivn
	 LduLtzo23FhBs2ODBVKOGm1HpTkoYsYQ/dt4hi5Q4CSv+LYacS+CeX2WFSjP7PigWK79K
	 56coHcFl/DAz2ZS8E4e6ktfiM0jrKsnst7WMWKkBiYggMT/fbduRXwvHcXN6wM43dtOE8
	 IlpH/0J9RpHTjKOalEcrE4LYH8vSuFJmFNEcjEdrWS9M+VW+f+lYnGLX4vrJLjljy8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YKjlWS7t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A412B606A31C;
	Wed, 18 Nov 2026 23:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YKjlWS7t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014E51F000C5;
	Wed, 18 Nov 2026 23:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043812;
	bh=As9kQK7UIzR7UjiQsRYJidba4LzJSgwq4ZQnrnlSPQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YKjlWS7tjNhOGz7BHL7fIVMB/2wQfxVANesM04rBZeWd+SpAzPbrVOJo0Zd5wXLVA
	 WPpiblhvXhdWFdpTLGPWNIjH0KkV7Vf4fiSrTNBolL/yVM/0a1bGIqecUmZf49LiVR
	 2S/ZGOcCwuItAfizV4ILepit0KzX7DiGPgEBtiH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thi=C3=A9baud=20Weksteen?= <tweek@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0344/2857] module: validate string table section types
Date: Wed, 18 Nov 2026 15:22:58 +0100
Message-ID: <20261118150213.826539256@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Added the two string-table type checks inline in the monolithic elf_validity_check() using goto no_exec, since the split elf_validity_cache_*() helpers don't exist here; kernel-doc edits were omitted. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index e83e84f699ded..3b0063fcea7a7 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1722,6 +1722,11 @@ static int elf_validity_check(struct load_info *info)
 	}
 
 	strhdr = &info->sechdrs[info->hdr->e_shstrndx];
+	if (strhdr->sh_type != SHT_STRTAB) {
+		pr_err("Invalid ELF section name table type: %u\n", strhdr->sh_type);
+		goto no_exec;
+	}
+
 	err = validate_section_offset(info, strhdr);
 	if (err < 0) {
 		pr_err("Invalid ELF section hdr(type %u)\n", strhdr->sh_type);
@@ -1769,6 +1774,11 @@ static int elf_validity_check(struct load_info *info)
 				       info->hdr->e_shnum);
 				goto no_exec;
 			}
+			if (info->sechdrs[shdr->sh_link].sh_type != SHT_STRTAB) {
+				pr_err("Invalid ELF symbol string table type: %u\n",
+				       info->sechdrs[shdr->sh_link].sh_type);
+				goto no_exec;
+			}
 			fallthrough;
 		default:
 			err = validate_section_offset(info, shdr);
-- 
2.53.0



