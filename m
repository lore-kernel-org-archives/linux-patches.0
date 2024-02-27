Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AAB13AA2F;
	Tue, 27 Feb 2024 13:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041881; cv=none; b=MIYxKso0fam+CogSzx4UCsnTSa7pmDnL5F3gnU0eUPb6VXCNyf8NOiwWMlj/aefunjoc5QdW6skJ0ahmKgrN0gnXlGfIc3xtaLCtaeTZiNEFe6RD5rL4oslwxre0GzV96FfXqHQC+09cYwZeGHBmbXilPO8wAVXEposfCU2LLFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041881; c=relaxed/simple;
	bh=dZ4vlyrlEZW2fH2BGw1pg5E5KA8JaFLgPFpxVpvEgbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mVvLMuAYwfxf/9nBLOghCJ07pFZBvXN6Kqk8Uf9/262yxa3vtJSuxw48xiaBN0ntAqZf9tIAxv+fsDnFmxcfoWvwrataDD1h1tg/nqnzF5f5KtZ7chR/O9JC1Ql3+vJs3faugvUgR8ItUZk5AY1Ul4nVlOejtdBJMcDd3dfMkvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kguplizU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kguplizU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179BDC433C7;
	Tue, 27 Feb 2024 13:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041881;
	bh=dZ4vlyrlEZW2fH2BGw1pg5E5KA8JaFLgPFpxVpvEgbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kguplizUmgm+PwZ+cjg1Leu3cnzOjJXZgbDvkX+c/OZVs/60yaNLfqGsJMb2H62L6
	 7AyBv1n4GJeAlOjrYdhDbpIqeBNG4XF+dQKZ4rna07SHr+hBRDEG4yxtFrw/M3/qo1
	 uwxLKZcSYBf+pb1XDQMFzgrqUY8tP15WnTU2hrkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/299] LoongArch: Select ARCH_ENABLE_THP_MIGRATION instead of redefining it
Date: Tue, 27 Feb 2024 14:23:33 +0100
Message-ID: <20240227131629.171607468@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit b3ff2d9c3a9c64cd0a011cdd407ffc38a6ea8788 ]

ARCH_ENABLE_THP_MIGRATION is supposed to be selected by arch Kconfig.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/Kconfig | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index e14396a2ddcbf..f29a0f2a4f187 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -11,6 +11,7 @@ config LOONGARCH
 	select ARCH_DISABLE_KASAN_INLINE
 	select ARCH_ENABLE_MEMORY_HOTPLUG
 	select ARCH_ENABLE_MEMORY_HOTREMOVE
+	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
 	select ARCH_HAS_CPU_FINALIZE_INIT
 	select ARCH_HAS_FORTIFY_SOURCE
@@ -638,10 +639,6 @@ config ARCH_SPARSEMEM_ENABLE
 	  or have huge holes in the physical address space for other reasons.
 	  See <file:Documentation/mm/numa.rst> for more.
 
-config ARCH_ENABLE_THP_MIGRATION
-	def_bool y
-	depends on TRANSPARENT_HUGEPAGE
-
 config ARCH_MEMORY_PROBE
 	def_bool y
 	depends on MEMORY_HOTPLUG
-- 
2.43.0



