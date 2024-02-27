Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994BE78B61;
	Tue, 27 Feb 2024 14:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043423; cv=none; b=R+VjySH3LeNny38kJCc2LNlrzKs0st1nYlIULYKBuVuiJf6REI/oxmHGQf/hCeo10BRe9AXXMTeOJIsKhQxpmIfcEHBUVawfneFho+BwHbnFCsn8PBBAgYElbdH+ptpOIRXt2x6QoxVbQVPzb5DdMxseZfoZRbVX0KSJWtbdsVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043423; c=relaxed/simple;
	bh=D6KjqZOOjaUVW6vL0f5mS27fniWlqx2hiXgBxflsBfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEBXWh/LcElU6is1G5HsBD9yM3n1iLIbs5xCBigKph2mpelVfqIurwpY5SHYDxfAePKsbUnN/i/Ym3tTYvB3Hr317vKal26YCWfwlqVHBtN+UUn4aXX4ex4PJQdY3jRe4st+HekVBKG6Vm+ijFtcJBp6j832ElHG3XQsToGRztI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iwAHvuBU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iwAHvuBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25EF8C433F1;
	Tue, 27 Feb 2024 14:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043423;
	bh=D6KjqZOOjaUVW6vL0f5mS27fniWlqx2hiXgBxflsBfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iwAHvuBUbZnhUwc0SpbGek5J7WS10eh+LiiXxK0L8Ff2QZ//3gx2+ovyIkDpGhRsX
	 tpMhT5OGaAKFLkl5H9z5EMF5fnXK9kJgVwBX1cttAyadCDbLD6xq2nRII4zJzbyBLR
	 4QxpvK/jhQNKHkghMRdLp4BJpP76/+enfJQmtfFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/195] LoongArch: Select HAVE_ARCH_SECCOMP to use the common SECCOMP menu
Date: Tue, 27 Feb 2024 14:25:35 +0100
Message-ID: <20240227131612.940561541@linuxfoundation.org>
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
index b1b4396dbac6c..fa3171f563274 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -81,6 +81,7 @@ config LOONGARCH
 	select GPIOLIB
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_MMAP_RND_BITS if MMU
+	select HAVE_ARCH_SECCOMP
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
@@ -462,23 +463,6 @@ config PHYSICAL_START
 	  specified in the "crashkernel=YM@XM" command line boot parameter
 	  passed to the panic-ed kernel).
 
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



