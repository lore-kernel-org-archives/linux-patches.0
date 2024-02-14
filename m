Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE90250F6;
	Wed, 14 Feb 2024 22:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707951244; cv=none; b=JlThhxwHTg59DSzkQkfFZ7JCOqNpLSRmdSiyEZ2VIh6TVKWqnpMZiaBOqb91qhk1INCoIiqmhclppxmyKv4As0aNN/VUVVW3mLDCmp6c7I8GKmcLx/HlbAG3agq5DvI95meeH6NuzG/aja6Dej7f5xCfWVerThVMyvmPeILtitQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707951244; c=relaxed/simple;
	bh=7zPvpgdu9M/4TgZk75pw4da+3dcufuwAo9LaXXY4FSY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=cjIFffVZFZOSG3L4mJj/SmsrqPwauVxqAAW0z9ksXa+5GWgmmIMzVLNj0itCnM/GnbQEuCyw5agx/nYrt5NyCEiS5C+kTzRNYsRdlVmil63lOvSiIhP7JIEOuxgDuEt9P/9a7z0MBizfOH6DDXm55rgV3qcvXz3aKEQKj9cRtUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wi2jXtFf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wi2jXtFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081B4C433C7;
	Wed, 14 Feb 2024 22:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707951243;
	bh=7zPvpgdu9M/4TgZk75pw4da+3dcufuwAo9LaXXY4FSY=;
	h=From:Date:Subject:To:Cc:From;
	b=Wi2jXtFfLTZr0F2by/Ac4uNb+L7cx/kycnaH9Z7cuPnCALbL6rCSNFz/8N42AKCzm
	 BtsJ9v9OCjm9K0DnnDYGY4frmUyMyBmpO7/bsnlFPI/I0/s2FNB/Mr4lr0fn+H/6zl
	 NDEf0nlGUNwOWz8Ev5RDzmTz0iNz/Ef+X2Nf1K5Cn87mrqJXoAYHtmh03eGurX2viD
	 RFZBnI2Ekl1Fubfnu8Pqvn/Azo+QTp/Su/ztRJaQuZrM8dbvFRi6SG+n3j8qSWVuS8
	 qzX1U34ua3HG3o485UJSbXRlFLrzG/ZyHFAmunXz+2h7kVj5RDD5vvR0g05v5G7RVq
	 slqwXsxM+ocXA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 14 Feb 2024 15:53:48 -0700
Subject: [PATCH] s390: Don't allow CONFIG_COMPAT with LD=ld.lld
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240214-s390-compat-lld-dep-v1-1-abf1f4b5e514@kernel.org>
X-B4-Tracking: v=1; b=H4sIAHtEzWUC/x3MywqAIBBA0V+JWTdgZs9fiRamUw30EI0IpH9PW
 p7FvRECeaYAfRbB082BzyOhyDMwqz4WQrbJIIVUQhYKQ9kJNOfu9IXbZtGSw7apdG06NVFTQSq
 dp5mf/zqM7/sBpcGjtmUAAAA=
To: hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Cc: borntraeger@linux.ibm.com, svens@linux.ibm.com, morbo@google.com, 
 justinstitt@google.com, linux-s390@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1251; i=nathan@kernel.org;
 h=from:subject:message-id; bh=7zPvpgdu9M/4TgZk75pw4da+3dcufuwAo9LaXXY4FSY=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKlnXbreXk45+qN2+vcD2/TunfzMt//loXf6y94aHXl0I
 cdHMuhFVEcpC4MYF4OsmCJL9WPV44aGc84y3jg1CWYOKxPIEAYuTgGYyN9IRoazfs0bikq3na3a
 tmN5S+oHh4rOGZwBouvFIqUbG4+cbFBiZNgke3rPZIt0F9bkwvel4QeWTtE0eqwZvCI4c90/t0X
 LzVgA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building 'ARCH=s390 defconfig compat.config' with GCC and
LD=ld.lld, there is an error when attempting to link the compat vDSO:

  ld.lld: error: unknown emulation: elf_s390
  make[4]: *** [arch/s390/kernel/vdso32/Makefile:48: arch/s390/kernel/vdso32/vdso32.so.dbg] Error 1

Much like clang, ld.lld only supports the 64-bit s390 emulation. Add a
dependency on not using LLD to CONFIG_COMPAT to avoid breaking the build
with this toolchain combination.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/s390/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 771235aee6bf..39e937309fc2 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -449,7 +449,7 @@ config COMPAT
 	select COMPAT_OLD_SIGACTION
 	select HAVE_UID16
 	depends on MULTIUSER
-	depends on !CC_IS_CLANG
+	depends on !CC_IS_CLANG && !LD_IS_LLD
 	help
 	  Select this option if you want to enable your system kernel to
 	  handle system-calls from ELF binaries for 31 bit ESA.  This option

---
base-commit: 616c4ea9bce426aa6efd6dc333bdd479ce352df0
change-id: 20240214-s390-compat-lld-dep-875a6c94be75

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

