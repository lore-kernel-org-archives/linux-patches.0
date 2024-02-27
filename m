Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F1213A87C;
	Tue, 27 Feb 2024 13:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040810; cv=none; b=ACIw12Mv7N1MibPwAU+pTSstTl4M0zALDh1K0WPLHuAXC5iyjzH0JFw1XHxIBjl7k5rwy+p7Wx12ME8Tv+Ct+tRi18gdXO+RHdKlZe/WK54QQjcJBQQuCC/FycBFJXvFvFIXRiE6bEfgaTxA9WlKT0OWKTHp/u6ddAdPdHjTcYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040810; c=relaxed/simple;
	bh=kIc0IWFYLkUnBx+4hnkMn4oG2Lcl7BlZi5pYv2HNjUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbUZPlLgYVvJbf48JCyXTzNHzz2E+glGfz2GmZJkDlCQpDETwKL7oee0/8Cvh0fulwoD1Nw9w7QxkwekoGalZZgHtSpItPRrE9Vbf9P/oAipmjy+Brj/5zENTWZwu1BFWG/nOO227bLyb7tCKfKhe5pYPr9FS74mEe3JQafynz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=duI00DBf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="duI00DBf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAAE5C433F1;
	Tue, 27 Feb 2024 13:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040810;
	bh=kIc0IWFYLkUnBx+4hnkMn4oG2Lcl7BlZi5pYv2HNjUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=duI00DBfaYvIN3wvQ6jzX372LpU1MYuEO+qMitBugno2tvI+Xk6QuE5Kzm/3tedEX
	 hY/NaRFvhHh7av46Ho7+yCAQzJ1eWIlpnqm/vwo0OxjZgyvBzGTINjJq/CEbSchoWH
	 +zt5doV6AguCs+xI9hoQBVxSBeuMoEnCTNSTBCv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 115/334] LoongArch: Select HAVE_ARCH_SECCOMP to use the common SECCOMP menu
Date: Tue, 27 Feb 2024 14:19:33 +0100
Message-ID: <20240227131634.185037635@linuxfoundation.org>
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
index 709af7096acb8..205956041d7d0 100644
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
@@ -609,23 +610,6 @@ config RANDOMIZE_BASE_MAX_OFFSET
 
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



