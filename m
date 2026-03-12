Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD4A184;
	Thu, 12 Mar 2026 00:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773276008; cv=none; b=XeE7PHzodEu8+y+7Ws3EdWdd4sYLDMz8+IXG+ROQq6udZDmoZcIA6FQMsfw0l3S4GhNdp6o16whlFOFzff2RJNIPoVMpCFd2hwksqrVa5j2GMvoCUYpOoxCnlUj6WlnQLNT3SJ/Uvg8vghDiuPV0ytXOOoMLCMB6fxd9cy8wx44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773276008; c=relaxed/simple;
	bh=nQbnEBithESt6CWLnUtQicYUaszVzxppnpWJix1YO4c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Q2N+nYghd+ePGEpd2bbDQYF9IrULanBHvjoD836OP70w53ZQALValdz2fwFcUU8mAJ1TfSj9eT1extb5NtQVB5bJukWp6aQeeBBvPzMWBcP073FWWsVCBBEkbJ9JZYR7/JM8h0I/u5e41sKg+soRBL3wrNws3hHKeHKajvHrLKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mycyTdB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mycyTdB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51DBBC4CEF7;
	Thu, 12 Mar 2026 00:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773276008;
	bh=nQbnEBithESt6CWLnUtQicYUaszVzxppnpWJix1YO4c=;
	h=From:Date:Subject:To:Cc:From;
	b=mycyTdB0jUEBRJxMCkU9s2dIJp8qM2LyFyXSqjinha7qnpewU7pSnFDftq4TrEf/H
	 W1CqMhZHFofopo6AlQr0AjOqLQvfZ4Ot7kB0Lb0Z1HX5dCFG8jDQsNvlfc6OzdY2P+
	 TbTzXdKE9P3Yz9Ow0byFIgf/ghWMV77mogaHbnPfkwCTtc+cyYcgTMGhd/KCl1vlIy
	 c6jjjcQmWYIGKoTnJWxf8yR/MVP6YFxdnK4TM5mfa1ztfCsd2uLT30dT3wo/C4pJPO
	 w+IWParo2OHLKWYOWze2/NVC69sDI4nZjfnnywCeuLHpXSuY3Qo/8fMAdUdu4UDas3
	 Lu+s23amTNCsg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 11 Mar 2026 17:39:56 -0700
Subject: [PATCH] powerpc/vdso: Drop -DCC_USING_PATCHABLE_FUNCTION_ENTRY
 from 32-bit flags with clang
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-ppc-vdso-drop-cc-using-pfe-define-clang-v1-1-66c790e22650@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWNQQrCMBBFr1Jm7UBS0yy8irjQyaSOSBIytgild
 3fU5ePx399AuQsrnIYNOq+iUouBPwxA92uZGSUZw+jG6I7eY2uEa9KKqdeGRLiolBlbZkycpTD
 S03YYYop5csFPIYDVWjf7/j2dL3/W5fZgen3zsO8fescys4sAAAA=
X-Change-ID: 20260311-ppc-vdso-drop-cc-using-pfe-define-clang-46d6f5041544
To: Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Hari Bathini <hbathini@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2955; i=nathan@kernel.org;
 h=from:subject:message-id; bh=nQbnEBithESt6CWLnUtQicYUaszVzxppnpWJix1YO4c=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDJmbuFPffHHdcnzStz/ZYr1zUnJestRtvXTi2QXzTf/vK
 /Sa9My52VHKwiDGxSArpshS/Vj1uKHhnLOMN05NgpnDygQyhIGLUwAmcjmV4b+LIrc5w1+lWd4/
 ircvUrrFz9qX1cv5PrbdUqiS+XFaCDPD//QrrpsWmCbtmtP+/c820Y/Xs8sf1Z848UfMcDvLbid
 fNVYA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After commit 73cdf24e81e4 ("powerpc64: make clang cross-build
friendly"), building 64-bit little endian + CONFIG_COMPAT=y with clang
results in many warnings along the lines of:

  $ cat arch/powerpc/configs/compat.config
  CONFIG_COMPAT=y

  $ make -skj"$(nproc)" ARCH=powerpc LLVM=1 ppc64le_defconfig compat.config arch/powerpc/kernel/vdso/
  ...
  In file included from <built-in>:4:
  In file included from lib/vdso/gettimeofday.c:6:
  In file included from include/vdso/datapage.h:15:
  In file included from include/vdso/cache.h:5:
  arch/powerpc/include/asm/cache.h:77:8: warning: unknown attribute 'patchable_function_entry' ignored [-Wunknown-attributes]
     77 | static inline u32 l1_icache_bytes(void)
        |        ^~~~~~
  include/linux/compiler_types.h:235:58: note: expanded from macro 'inline'
    235 | #define inline inline __gnu_inline __inline_maybe_unused notrace
        |                                                          ^~~~~~~
  include/linux/compiler_types.h:215:34: note: expanded from macro 'notrace'
    215 | #define notrace                 __attribute__((patchable_function_entry(0, 0)))
        |                                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ...

arch/powerpc/Makefile adds -DCC_USING_PATCHABLE_FUNCTION_ENTRY to
KBUILD_CPPFLAGS, which is inherited by the 32-bit vDSO. However, the
32-bit little endian target does not support
'-fpatchable-function-entry', resulting in the warnings above.

Remove -DCC_USING_PATCHABLE_FUNCTION_ENTRY from the 32-bit vDSO flags
when building with clang to avoid the warnings.

Fixes: 73cdf24e81e4 ("powerpc64: make clang cross-build friendly")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/powerpc/kernel/vdso/Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/kernel/vdso/Makefile b/arch/powerpc/kernel/vdso/Makefile
index 8834dfe9d727..368759f81708 100644
--- a/arch/powerpc/kernel/vdso/Makefile
+++ b/arch/powerpc/kernel/vdso/Makefile
@@ -62,6 +62,12 @@ CC32FLAGSREMOVE += -fno-stack-clash-protection
 # 32-bit one. clang validates the values passed to these arguments during
 # parsing, even when -fno-stack-protector is passed afterwards.
 CC32FLAGSREMOVE += -mstack-protector-guard%
+# ftrace is disabled for the vdso but arch/powerpc/Makefile adds this define to
+# KBUILD_CPPFLAGS, which enables use of the 'patchable_function_entry'
+# attribute in the 'inline' define via 'notrace'. This attribute is not
+# supported for the powerpcle target, resulting in many instances of
+# -Wunknown-attributes.
+CC32FLAGSREMOVE += -DCC_USING_PATCHABLE_FUNCTION_ENTRY
 endif
 LD32FLAGS := -Wl,-soname=linux-vdso32.so.1
 AS32FLAGS := -D__VDSO32__

---
base-commit: 35e4f2a17eb40288f9bcdb09549fa04a63a96279
change-id: 20260311-ppc-vdso-drop-cc-using-pfe-define-clang-46d6f5041544

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

