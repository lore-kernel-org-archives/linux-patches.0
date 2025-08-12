Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C07247287;
	Tue, 12 Aug 2025 18:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024724; cv=none; b=jtsvOmQN3Duwzvq7OPN81HHtpBoMDY1g/EgE9rDgF7H5jei4mway01fZQgDXNl/w52IvFP0A7g5Ys0QLorENafD/+ANxMblE/e/ZQUW+tj1EPbBgw09KGU1Jny8Jo15DxuGz+kq3UXh80LUWIngGzcAVBMuVxV/Flr52cimNO7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024724; c=relaxed/simple;
	bh=c8xsrbrSPTQE5kjtKg5kkZ4JEHciqYUPY02VQmjpWcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xy9uwb/kIG9Q70kBFTZN4umzNL8I2Zrmss7v9mCpjCaV2L6TjjLkcl7cvGSh79WiQTIuO7uW4kXqFrCZeeKqLAwTkywXEYtEK7kPh9Gs5qoXOEh6mZlVen5/6kHaZyJ00G5COkR0qSUJ/F+SLCiiH6OXOCtfvvWkTbjmP7VAPdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m4oalSM7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m4oalSM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BDBC4CEF0;
	Tue, 12 Aug 2025 18:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024724;
	bh=c8xsrbrSPTQE5kjtKg5kkZ4JEHciqYUPY02VQmjpWcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m4oalSM7dZSgoQz87VdzirV/ZDyO63EVOZ+CbBsXEXKCP1hJ3spv2D/+m3dbwPZ87
	 xZoUyT+kaDVO2iRqhfelrEWnKkTdy+kSJu/pTdd/p4lLlA97zm6EigYg0CBgexvTd+
	 0tA8q/QRwu2AfzHAOqPdWR37d3AQFUVLconNhB3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <benh@debian.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 425/627] sh: Do not use hyphen in exported variable name
Date: Tue, 12 Aug 2025 19:32:00 +0200
Message-ID: <20250812173435.436392043@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



