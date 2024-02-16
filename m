Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B136C1350F4;
	Fri, 16 Feb 2024 19:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708113362; cv=none; b=nNo6m48fnAd52+MSKkSBi9pDnS+6BTdhPGV9mU6kE3+3xjv9fz/hr2vxjbAh3IsxkfwZmik3cnxRpQyAU1JmqzYoAkS7VviStzwkqXwsnEGyg35KNBZblm4EIIumDJPwJpdhCflDXSN/ZfxA4S2LuDMB9T3nIjqhavVNyK0UFbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708113362; c=relaxed/simple;
	bh=T1UbgkGOJwrEIoiF1stukcNe2NTIBEUIQmqKJruW/dg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=lwoR3+/WzLevtPUpM8Y5PsVkM50/t7FUSHQxHI2kOcikTzkkOWOGbdM3phHTrCkjanjo2yxE2eOVxyWbeshNGQ43SGdmccO9RH6CehTlLicMsUtywhR4sClEOguMkPI3RuHWrWsqIZ7bAj1zC0z2IgvPK6fA00PXupr6UEwODFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KecpzTTx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KecpzTTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD31DC433F1;
	Fri, 16 Feb 2024 19:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708113362;
	bh=T1UbgkGOJwrEIoiF1stukcNe2NTIBEUIQmqKJruW/dg=;
	h=From:Date:Subject:To:Cc:From;
	b=KecpzTTxQsYYMW6aGOoSccWrNxaSqKEZGTQnMBjuxFpk8MQ0C2c0AjTjksT3kN0T5
	 sLZyWMyHnCmYLiBMsAciMvuzmicSLuinWLs/w3SDuftuIHU/fDHXrkiOBKBc1JJLTZ
	 +pfGOIY9d4ZZH1/mUryM7Y925hkk8a+z2cnLNrhrPYllHtNImYr/uH7nh1/+AgaK5g
	 lfvKSaK5mIu9A/8B4R+TJqwsIWyEoxJoJd5JA9kllXOCeUDlUwpT9rcpQqS8RyHSvN
	 nWr6jqyZMIfbsijr4PMf8kRioup3Hky2Apm/mnRse+4i6BxFpKJdcVPOljhx10W8OX
	 rIoATcXVAw+sQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 16 Feb 2024 12:55:53 -0700
Subject: [PATCH] s390/boot: Add 'alloc' to info.bin .vmlinux.info section
 flags
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240216-s390-fix-boot-with-llvm-objcopy-v1-1-0ac623daf42b@kernel.org>
X-B4-Tracking: v=1; b=H4sIAMi9z2UC/x2NywqDMBAAf0X23IUkPlr7K+Ihiatusa4koi3iv
 xs8DgwzB0QKTBHe2QGBNo4scwL9yMCPdh4IuUsMRplCGV1hzGuFPf/Qiay48zriNG1fFPfxsvx
 R6do+q/xFpeshVZZAyb4PTXueFzcwHxZxAAAA
To: hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Cc: borntraeger@linux.ibm.com, svens@linux.ibm.com, morbo@google.com, 
 justinstitt@google.com, linux-s390@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Ulrich Weigand <ulrich.weigand@de.ibm.com>, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4039; i=nathan@kernel.org;
 h=from:subject:message-id; bh=T1UbgkGOJwrEIoiF1stukcNe2NTIBEUIQmqKJruW/dg=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKnn917USnvtm732yfWcfK/ENIFf1vPNWk0cXnteF/tdy
 jSzRHx3RykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZjI/D0Mv9nnXbyxOdFv91tn
 +wkmhZnZdnqsQvFJJ5q3/zA75Vinnc3wvzD2jHOu+J6g+/uPaekmeu2a8ixIZImN/qQnJ49Pzl4
 ayQAA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When attempting to boot a kernel compiled with OBJCOPY=llvm-objcopy,
there is a crash right at boot:

  Out of memory allocating 6d7800 bytes 8 aligned in range 0:20000000
  Reserved memory ranges:
  0000000000000000 a394c3c30d90cdaf DECOMPRESSOR
  Usable online memory ranges (info source: sclp read info [3]):
  0000000000000000 0000000020000000
  Usable online memory total: 20000000 Reserved: a394c3c30d90cdaf Free: 0
  Call Trace:
  (sp:0000000000033e90 [<0000000000012fbc>] physmem_alloc_top_down+0x5c/0x104)
   sp:0000000000033f00 [<0000000000011d56>] startup_kernel+0x3a6/0x77c
   sp:0000000000033f60 [<00000000000100f4>] startup_normal+0xd4/0xd4

GNU objcopy does not have any issues. Looking at differences between the
object files in each build reveals info.bin does not get properly
populated with llvm-objcopy, which results in an empty .vmlinux.info
section.

  $ file {gnu,llvm}-objcopy/arch/s390/boot/info.bin
  gnu-objcopy/arch/s390/boot/info.bin:  data
  llvm-objcopy/arch/s390/boot/info.bin: empty

  $ llvm-readelf --section-headers {gnu,llvm}-objcopy/arch/s390/boot/vmlinux | rg 'File:|\.vmlinux\.info|\.decompressor\.syms'
  File: gnu-objcopy/arch/s390/boot/vmlinux
    [12] .vmlinux.info     PROGBITS        0000000000034000 035000 000078 00  WA  0   0  1
    [13] .decompressor.syms PROGBITS       0000000000034078 035078 000b00 00  WA  0   0  1
  File: llvm-objcopy/arch/s390/boot/vmlinux
    [12] .vmlinux.info     PROGBITS        0000000000034000 035000 000000 00  WA  0   0  1
    [13] .decompressor.syms PROGBITS       0000000000034000 035000 000b00 00  WA  0   0  1

Ulrich points out that llvm-objcopy only copies sections marked as alloc
with a binary output target, whereas the .vmlinux.info section is only
marked as load. Add 'alloc' in addition to 'load', so that both objcopy
implementations work properly:

  $ file {gnu,llvm}-objcopy/arch/s390/boot/info.bin
  gnu-objcopy/arch/s390/boot/info.bin:  data
  llvm-objcopy/arch/s390/boot/info.bin: data

  $ llvm-readelf --section-headers {gnu,llvm}-objcopy/arch/s390/boot/vmlinux | rg 'File:|\.vmlinux\.info|\.decompressor\.syms'
  File: gnu-objcopy/arch/s390/boot/vmlinux
    [12] .vmlinux.info     PROGBITS        0000000000034000 035000 000078 00  WA  0   0  1
    [13] .decompressor.syms PROGBITS       0000000000034078 035078 000b00 00  WA  0   0  1
  File: llvm-objcopy/arch/s390/boot/vmlinux
    [12] .vmlinux.info     PROGBITS        0000000000034000 035000 000078 00  WA  0   0  1
    [13] .decompressor.syms PROGBITS       0000000000034078 035078 000b00 00  WA  0   0  1

Closes: https://github.com/ClangBuiltLinux/linux/issues/1996
Link: https://github.com/llvm/llvm-project/commit/3c02cb7492fc78fb678264cebf57ff88e478e14f
Suggested-by: Ulrich Weigand <ulrich.weigand@de.ibm.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
No fixes tag because I have not tested to see if there are other issues
on older kernel versions yet (so I don't think prioritizing a backport
is necessary yet) but I think commit 5a2e1853d689 ("s390: avoid vmlinux
segments overlap") introduced this.
---
 arch/s390/boot/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/boot/Makefile b/arch/s390/boot/Makefile
index ace0bda1ad24..d40135efdec4 100644
--- a/arch/s390/boot/Makefile
+++ b/arch/s390/boot/Makefile
@@ -94,7 +94,7 @@ OBJCOPYFLAGS_syms.o := -I binary -O elf64-s390 -B s390:64-bit --rename-section .
 $(obj)/syms.o: $(obj)/syms.bin FORCE
 	$(call if_changed,objcopy)
 
-OBJCOPYFLAGS_info.bin := -O binary --only-section=.vmlinux.info --set-section-flags .vmlinux.info=load
+OBJCOPYFLAGS_info.bin := -O binary --only-section=.vmlinux.info --set-section-flags .vmlinux.info=alloc,load
 $(obj)/info.bin: vmlinux FORCE
 	$(call if_changed,objcopy)
 

---
base-commit: 03325e9b64c48313527f0373c4688d393b1edaf3
change-id: 20240216-s390-fix-boot-with-llvm-objcopy-019a7638e5bf

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

