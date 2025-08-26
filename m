Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E4C35AABB;
	Tue, 26 Aug 2025 14:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217514; cv=none; b=qwQIsJ1BxvQedGMrBkWZlVSDELfY4BJ9VGJH6rw7g8xtfLfY8L/CsgeDW0pdTTE4NLtm6n8CSobdnn8wiUkUmMjO6/prepl5rNaFGCAbXyIuj8ySuimtvv/yVdWTCfnWcQQNcTL1+dsH7yJjBeV1szXLvog8Xvu99O7RL9Qg1Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217514; c=relaxed/simple;
	bh=i1RHUSfKF9TeWunGcND9WYhknd5HY2fYFXs5KQG8T0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EkejGYDaayBaW4pTGSPrVohv0t02h30yTI+kToRoEQX0aF/pyDXQZ2kDQLJT7x/qtac++btd/kTO9Wr8rWCmaUQgXu/Wchl6whgevyLWIg6//RysxsDiuTs40XjWQNGvmMbCNOC7tGepoglrypGlFNhHfcHmCshOxbhT4xULRno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XFnaX0u7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XFnaX0u7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA0EC113D0;
	Tue, 26 Aug 2025 14:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217513;
	bh=i1RHUSfKF9TeWunGcND9WYhknd5HY2fYFXs5KQG8T0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XFnaX0u7xRUHSU92K5RswsJI5tzDdnOFunmDMam34uhzlaiiINQGE3EAaRJB5bdSY
	 X/bm/1czukcLaPDIn4AGBFLWtauZjHReMInnXprBHx++E40nVCEIFMQM7XhqUoj5TN
	 uqcCE4Ejg6hJpaTIjz7c+kMqONtk+DkaJIvOGBVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <benh@debian.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/523] sh: Do not use hyphen in exported variable name
Date: Tue, 26 Aug 2025 13:05:50 +0200
Message-ID: <20250826110927.952968663@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2faebfd72eca..8e8e24227fff 100644
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
 
 head-y	:= arch/sh/kernel/head_32.o
 
diff --git a/arch/sh/boot/compressed/Makefile b/arch/sh/boot/compressed/Makefile
index 589d2d8a573d..d4baaaace17f 100644
--- a/arch/sh/boot/compressed/Makefile
+++ b/arch/sh/boot/compressed/Makefile
@@ -30,7 +30,7 @@ endif
 
 ccflags-remove-$(CONFIG_MCOUNT) += -pg
 
-LDFLAGS_vmlinux := --oformat $(ld-bfd) -Ttext $(IMAGE_OFFSET) -e startup \
+LDFLAGS_vmlinux := --oformat $(ld_bfd) -Ttext $(IMAGE_OFFSET) -e startup \
 		   -T $(obj)/../../kernel/vmlinux.lds
 
 #
@@ -68,7 +68,7 @@ $(obj)/vmlinux.bin.lzo: $(vmlinux.bin.all-y) FORCE
 
 OBJCOPYFLAGS += -R .empty_zero_page
 
-LDFLAGS_piggy.o := -r --format binary --oformat $(ld-bfd) -T
+LDFLAGS_piggy.o := -r --format binary --oformat $(ld_bfd) -T
 
 $(obj)/piggy.o: $(obj)/vmlinux.scr $(obj)/vmlinux.bin.$(suffix-y) FORCE
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



