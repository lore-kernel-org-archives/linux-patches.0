Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCDF2D4B5E;
	Tue, 12 Aug 2025 19:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026341; cv=none; b=EmGts99ztiWw/Yv3gQWXZlfWSVWiy3T++wPUopx+WcpozrYdCHu9uDQNf5ny9HWJFEXGBIzq8wZZFw2vtWtN4/hw7Vj5ly5XO/7Y7nhBPz4UoIWtWvvrVwjyCFv2DnRaPaiHEWm9Abl2SASzYx+uhy5KdtZ+6IojDWbURIUtvQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026341; c=relaxed/simple;
	bh=GaOQ8XcOTg1qO9aDHZ3oNtNv0k3hbxqUFerdK5pfQ80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkx9k0raEFcBhTNTPxo/pN3M4Jntk5cSI4POeHJaL4vnxB+lBrbMxTFwGNuix7t8JYQBeZ5ESUkkJ+O74D07+YCg/CTn/uNRs3NdRtznjtfcJQd0PZA1SOYfATh+a1PCxThpqsiii4dvQDPfZxI0LBZdTWAZCx4QQ/jm9M1auYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BEMpvG4s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BEMpvG4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B144C4CEF0;
	Tue, 12 Aug 2025 19:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026340;
	bh=GaOQ8XcOTg1qO9aDHZ3oNtNv0k3hbxqUFerdK5pfQ80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BEMpvG4sCBRZmv0NJGdhdcF3MPuJe2OQ239hSjBSDLHGzxcm1rCzoNMsfzcnHdh9g
	 Ena0L+MHSbp1TBVZZVbZhqWfK/UtHQkWoIkFjfKbTljPpWgQCC8V6P3HcYejxHbl/S
	 VGpqW8P33IGcXk974RIFhugy7eJa6qQifg4HaGyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <benh@debian.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 309/480] sh: Do not use hyphen in exported variable name
Date: Tue, 12 Aug 2025 19:48:37 +0200
Message-ID: <20250812174410.174150616@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <benh@debian.org>

[ Upstream commit c32969d0362a790fbc6117e0b6a737a7e510b843 ]

arch/sh/Makefile defines and exports ld-bfd to be used by
arch/sh/boot/compressed/Makefile and arch/sh/boot/romimage/Makefile.
However some shells, including dash, will not pass through environment
variables whose name includes a hyphen.  Usually GNU make does not use
a shell to recurse, but if e.g. $(srctree) contains '~' it will use a
shell here.

Other instances of this problem were previously fixed by commits
2bfbe7881ee0 "kbuild: Do not use hyphen in exported variable name"
and 82977af93a0d "sh: rename suffix-y to suffix_y".

Rename the variable to ld_bfd.

References: https://buildd.debian.org/status/fetch.php?pkg=linux&arch=sh4&ver=4.13%7Erc5-1%7Eexp1&stamp=1502943967&raw=0
Fixes: 7b022d07a0fd ("sh: Tidy up the ldscript output format specifier.")
Signed-off-by: Ben Hutchings <benh@debian.org>
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/Makefile                 | 10 +++++-----
 arch/sh/boot/compressed/Makefile |  4 ++--
 arch/sh/boot/romimage/Makefile   |  4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/sh/Makefile b/arch/sh/Makefile
index cab2f9c011a8..7b420424b6d7 100644
--- a/arch/sh/Makefile
+++ b/arch/sh/Makefile
@@ -103,16 +103,16 @@ UTS_MACHINE		:= sh
 LDFLAGS_vmlinux		+= -e _stext
 
 ifdef CONFIG_CPU_LITTLE_ENDIAN
-ld-bfd			:= elf32-sh-linux
-LDFLAGS_vmlinux		+= --defsym jiffies=jiffies_64 --oformat $(ld-bfd)
+ld_bfd			:= elf32-sh-linux
+LDFLAGS_vmlinux		+= --defsym jiffies=jiffies_64 --oformat $(ld_bfd)
 KBUILD_LDFLAGS		+= -EL
 else
-ld-bfd			:= elf32-shbig-linux
-LDFLAGS_vmlinux		+= --defsym jiffies=jiffies_64+4 --oformat $(ld-bfd)
+ld_bfd			:= elf32-shbig-linux
+LDFLAGS_vmlinux		+= --defsym jiffies=jiffies_64+4 --oformat $(ld_bfd)
 KBUILD_LDFLAGS		+= -EB
 endif
 
-export ld-bfd
+export ld_bfd
 
 # Mach groups
 machdir-$(CONFIG_SOLUTION_ENGINE)		+= mach-se
diff --git a/arch/sh/boot/compressed/Makefile b/arch/sh/boot/compressed/Makefile
index 8bc319ff54bf..58df491778b2 100644
--- a/arch/sh/boot/compressed/Makefile
+++ b/arch/sh/boot/compressed/Makefile
@@ -27,7 +27,7 @@ endif
 
 ccflags-remove-$(CONFIG_MCOUNT) += -pg
 
-LDFLAGS_vmlinux := --oformat $(ld-bfd) -Ttext $(IMAGE_OFFSET) -e startup \
+LDFLAGS_vmlinux := --oformat $(ld_bfd) -Ttext $(IMAGE_OFFSET) -e startup \
 		   -T $(obj)/../../kernel/vmlinux.lds
 
 KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
@@ -51,7 +51,7 @@ $(obj)/vmlinux.bin.lzo: $(obj)/vmlinux.bin FORCE
 
 OBJCOPYFLAGS += -R .empty_zero_page
 
-LDFLAGS_piggy.o := -r --format binary --oformat $(ld-bfd) -T
+LDFLAGS_piggy.o := -r --format binary --oformat $(ld_bfd) -T
 
 $(obj)/piggy.o: $(obj)/vmlinux.scr $(obj)/vmlinux.bin.$(suffix_y) FORCE
 	$(call if_changed,ld)
diff --git a/arch/sh/boot/romimage/Makefile b/arch/sh/boot/romimage/Makefile
index c7c8be58400c..17b03df0a8de 100644
--- a/arch/sh/boot/romimage/Makefile
+++ b/arch/sh/boot/romimage/Makefile
@@ -13,7 +13,7 @@ mmcif-obj-$(CONFIG_CPU_SUBTYPE_SH7724)	:= $(obj)/mmcif-sh7724.o
 load-$(CONFIG_ROMIMAGE_MMCIF)		:= $(mmcif-load-y)
 obj-$(CONFIG_ROMIMAGE_MMCIF)		:= $(mmcif-obj-y)
 
-LDFLAGS_vmlinux := --oformat $(ld-bfd) -Ttext $(load-y) -e romstart \
+LDFLAGS_vmlinux := --oformat $(ld_bfd) -Ttext $(load-y) -e romstart \
 		   -T $(obj)/../../kernel/vmlinux.lds
 
 $(obj)/vmlinux: $(obj)/head.o $(obj-y) $(obj)/piggy.o FORCE
@@ -24,7 +24,7 @@ OBJCOPYFLAGS += -j .empty_zero_page
 $(obj)/zeropage.bin: vmlinux FORCE
 	$(call if_changed,objcopy)
 
-LDFLAGS_piggy.o := -r --format binary --oformat $(ld-bfd) -T
+LDFLAGS_piggy.o := -r --format binary --oformat $(ld_bfd) -T
 
 $(obj)/piggy.o: $(obj)/vmlinux.scr $(obj)/zeropage.bin arch/sh/boot/zImage FORCE
 	$(call if_changed,ld)
-- 
2.39.5



