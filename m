Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266F413AA4F;
	Tue, 27 Feb 2024 13:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040805; cv=none; b=eKl8z94ntASJ64AyYLtwea3i5kjgi+YeO6PA3L+NZII3OnOoLlybZVxKIciZdyMD2q2MhBZxJIzq6LZRpBJBbAFrLfsP66m0sPIH9coQdKFLtSvLvAdn3qWSi4zT5z14PQ2fhtDGixAqIij/ALs+5zKI+wAh0rLFpaZcX1ptt5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040805; c=relaxed/simple;
	bh=S/ySuIUXavN5MiPkgTHSqU8bA2wDmNSSidVW4SmtMms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pg+E0le1A435BGcE8Kz/t0rBmwlLAHtWR9XByrAutiU1G+uUr1PzudLpkgyNGITNfAXuLKKKhRqkaNtCTpDiFaACQCj4UCvN1sxI4KBRMMqP1nI0438Lj3U07/9MsrIz7P1x2VvpghGi7cGHftZKUglg8LmNc/ONhb6fM9iory4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dDpUZUGC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dDpUZUGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65653C433C7;
	Tue, 27 Feb 2024 13:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040804;
	bh=S/ySuIUXavN5MiPkgTHSqU8bA2wDmNSSidVW4SmtMms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dDpUZUGCwgvx9zMPGUwQ75PXi6qLTl16SBmEFS/hwPEfkeTqZ856ucsXEd77BaFyw
	 K62ypP9xoTVcPf3bmaaVBGAZW4akyuKRu/d0Et4bAkq2/500aHX60yMF9h+K21GzC9
	 5HktwRPnzOafNdtkesLTKJOaezUADRqOZVsoPM1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 114/334] LoongArch: Select ARCH_ENABLE_THP_MIGRATION instead of redefining it
Date: Tue, 27 Feb 2024 14:19:32 +0100
Message-ID: <20240227131634.155347824@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index ee123820a4760..709af7096acb8 100644
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
@@ -643,10 +644,6 @@ config ARCH_SPARSEMEM_ENABLE
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



