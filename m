Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6CC13B78F;
	Tue, 27 Feb 2024 14:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043420; cv=none; b=Ax02ze1apCidV3C15IQF9t8UuVn6AT3fKHuycBHsNQApmO8n1jRxaKFHZnrYvkOFULVAA+md1SLigWMRuxTNE5HOS8e2zr9togwfHooc686bdRiw89rHN4u9+/6w/5vtXeG6hWOSYMcn4IEwJuHfTRpTUDd+b2u/Kcr0n7w2kf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043420; c=relaxed/simple;
	bh=kjQ0gNpmhU0GqCDxZ83zDmZIaoUoIyciHy5GsNuj7lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUG9eDUfADUI9HlEmGZVSi8qsj3LIgSreMFieis9Z82KnWr8JiNvAsSmvLqeb4jJz8f1VYr8Z5v8PL9mwNtqnEbNJNuX9kFwm56tsDs8wYKSEhVUs43LRhdERyoQrrc0eYhbVnv9rbFJ2iYHoHpEGuzf5HLeq/ogkO0bQCl9y2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tP5OrgZ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tP5OrgZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB06C433F1;
	Tue, 27 Feb 2024 14:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043420;
	bh=kjQ0gNpmhU0GqCDxZ83zDmZIaoUoIyciHy5GsNuj7lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tP5OrgZ5YjmvvOLi8shh6NY5H3sXHkJByosK3moQ+TYssEQZbVJhfSz00UwadIsJE
	 8sVObuCqc9cKo7/zJpgsUZ1mlabvUukqEbiCJ/kTdtH6nLqOTWixemvUpsLlpgLkuF
	 9PmsK7EXxDqd4BmAw5QeJgN15g3pIH6QtcOED408=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/195] LoongArch: Select ARCH_ENABLE_THP_MIGRATION instead of redefining it
Date: Tue, 27 Feb 2024 14:25:34 +0100
Message-ID: <20240227131612.908362800@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e737dc8cd660c..b1b4396dbac6c 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -9,6 +9,7 @@ config LOONGARCH
 	select ARCH_BINFMT_ELF_STATE
 	select ARCH_ENABLE_MEMORY_HOTPLUG
 	select ARCH_ENABLE_MEMORY_HOTREMOVE
+	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_PTE_SPECIAL
@@ -495,10 +496,6 @@ config ARCH_SPARSEMEM_ENABLE
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



