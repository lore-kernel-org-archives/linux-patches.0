Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3D61419AE;
	Tue, 27 Feb 2024 13:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041884; cv=none; b=tp+E891fPpjyu2V/th5NgKeRa2sLwqgPseIjWF2b26RxtCezJg1vjLSIWj5IINQIjuALOHqemkbOcImziDWXyFOAiCDI26SroeGu3+nEWZd0SQKkQXBrnQ9jF9RKIfs1lLFUgL225eJaUUsisZ84aFrLFhGIQJS7tuREnES3mJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041884; c=relaxed/simple;
	bh=l1endiXnyGbBIWnhJWsASqrtkHWI3Ci4a6aDqQHm7P4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqjnZXWAkonXGZKLchuKeqdP3VU4GrzrBKedW0Y6bbLtoBdSZ5eFnvudAE1oOjJ/P0/c29KYZnx5EP+AXKX/nplHYCHXFMOpdgBp8iDE0RCRnzuMMj11/XAW77MNAOTitt1n/Bke25FIhnZjLeZ8Y+aYI85kgHY56f/MvAv63LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IM02fJen; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IM02fJen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37F2C433C7;
	Tue, 27 Feb 2024 13:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041884;
	bh=l1endiXnyGbBIWnhJWsASqrtkHWI3Ci4a6aDqQHm7P4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IM02fJenheRB0aa1nfxFGqkxSyuqeCXTIH9JIW7H5VODWrRWJ2aYI7OTuEfRkmA2/
	 WEd08ud7vea1dgMpJhwaIm6Fd3ln6yrPFys48hyWLybVGhM3nfM9dXfwZ4PUBUHvIM
	 kP5weah6zyUhox1oDyVG2uLTRF2WaWlmlrSVc++U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/299] LoongArch: Select HAVE_ARCH_SECCOMP to use the common SECCOMP menu
Date: Tue, 27 Feb 2024 14:23:34 +0100
Message-ID: <20240227131629.201727257@linuxfoundation.org>
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

[ Upstream commit 6b79ecd084c99b31c8b4d0beda08893716d5558e ]

LoongArch missed the refactoring made by commit 282a181b1a0d ("seccomp:
Move config option SECCOMP to arch/Kconfig") because LoongArch was not
mainlined at that time.

The 'depends on PROC_FS' statement is stale as described in that commit.
Select HAVE_ARCH_SECCOMP, and remove the duplicated config entry.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/Kconfig | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index f29a0f2a4f187..9fd8644a9a4c6 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -98,6 +98,7 @@ config LOONGARCH
 	select HAVE_ARCH_KFENCE
 	select HAVE_ARCH_KGDB if PERF_EVENTS
 	select HAVE_ARCH_MMAP_RND_BITS if MMU
+	select HAVE_ARCH_SECCOMP
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
@@ -604,23 +605,6 @@ config RANDOMIZE_BASE_MAX_OFFSET
 
 	  This is limited by the size of the lower address memory, 256MB.
 
-config SECCOMP
-	bool "Enable seccomp to safely compute untrusted bytecode"
-	depends on PROC_FS
-	default y
-	help
-	  This kernel feature is useful for number crunching applications
-	  that may need to compute untrusted bytecode during their
-	  execution. By using pipes or other transports made available to
-	  the process as file descriptors supporting the read/write
-	  syscalls, it's possible to isolate those applications in
-	  their own address space using seccomp. Once seccomp is
-	  enabled via /proc/<pid>/seccomp, it cannot be disabled
-	  and the task is only allowed to execute a few safe syscalls
-	  defined by each seccomp mode.
-
-	  If unsure, say Y. Only embedded should say N here.
-
 endmenu
 
 config ARCH_SELECT_MEMORY_MODEL
-- 
2.43.0



