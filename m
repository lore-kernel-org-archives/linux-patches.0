Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918EE4CB40;
	Wed, 29 Nov 2023 22:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DgKRw0Wc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9A3C433C8;
	Wed, 29 Nov 2023 22:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701296280;
	bh=x4TBp4Z9XhIDLhh0xttndJ/PopPagvhZ0Lb2IMMCW4U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=DgKRw0WcZAGYG6wH2WUqROmzHkf+woNvutMXXI8fghOo3fmrd7MvoqIFR1ntnbhRe
	 438ZPSoguk3VbBFQkIvvNb4oG4jexfiXAZ9X9DRnPUGSs+WG5muABqId2ZOhJFXMZx
	 V2NAQk+g+qfLPher6FKc1PoxXkDsnqxD2+fwKsZLvDDmi9XOVW6cU0Yk8SuT+NTn3s
	 OAnjn8KhEjzc+i1z1aT/iWJkguGGrFd/JAXR72xCt/vpRBuY7cVoP4XaUn0tJPcqXX
	 uZ8ujdu1DtAGZR9DPDKHd7xFEk6LaliHetyFbSEZKp+NipFuwvlRu98bwI6DvASNED
	 IIWikr5ga4PiQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 29 Nov 2023 15:17:43 -0700
Subject: [PATCH v3 3/3] x86/tools: Remove chkobjdump.awk
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231129-objdump-reformat-llvm-v3-3-0d855e79314d@kernel.org>
References: <20231129-objdump-reformat-llvm-v3-0-0d855e79314d@kernel.org>
In-Reply-To: <20231129-objdump-reformat-llvm-v3-0-0d855e79314d@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
 dave.hansen@linux.intel.com
Cc: x86@kernel.org, ndesaulniers@google.com, keescook@chromium.org, 
 samuelzeter@gmail.com, mhiramat@kernel.org, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2562; i=nathan@kernel.org;
 h=from:subject:message-id; bh=x4TBp4Z9XhIDLhh0xttndJ/PopPagvhZ0Lb2IMMCW4U=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKnpO6acFV/52cUv7O85hTX/f2uwvFNNe1awYMVhnWQ91
 wOZGkpTO0pZGMS4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBEZA0Z/see2H/ywST2UN5r
 Suy9ctuEt148t0Fjl2C976+3H1Ll5n9j+CvI0Zbz5dC3TNHZVe2NCtdyly570pC7bvPN1ut9jpF
 bn/MBAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

This check is superfluous now that the minimum version of binutils to
build the kernel is 2.25. This also fixes an error seen with
llvm-objdump because it does not support '-v' prior to LLVM 13:

  llvm-objdump: error: unknown argument '-v'

Closes: https://github.com/ClangBuiltLinux/linux/issues/1362
Link: https://github.com/llvm/llvm-project/commit/dde24a87c55f82d8c7b3bf3eafb10f2b9b2b9a01
Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/x86/tools/Makefile       |  2 +-
 arch/x86/tools/chkobjdump.awk | 34 ----------------------------------
 2 files changed, 1 insertion(+), 35 deletions(-)

diff --git a/arch/x86/tools/Makefile b/arch/x86/tools/Makefile
index 90e820ac9771..7278e2545c35 100644
--- a/arch/x86/tools/Makefile
+++ b/arch/x86/tools/Makefile
@@ -17,7 +17,7 @@ reformatter = $(srctree)/arch/x86/tools/objdump_reformat.awk
 chkobjdump = $(srctree)/arch/x86/tools/chkobjdump.awk
 
 quiet_cmd_posttest = TEST    $@
-      cmd_posttest = ($(OBJDUMP) -v | $(AWK) -f $(chkobjdump)) || $(OBJDUMP) -d -j .text $(objtree)/vmlinux | $(AWK) -f $(reformatter) | $(obj)/insn_decoder_test $(posttest_64bit) $(posttest_verbose)
+      cmd_posttest = $(OBJDUMP) -d -j .text $(objtree)/vmlinux | $(AWK) -f $(reformatter) | $(obj)/insn_decoder_test $(posttest_64bit) $(posttest_verbose)
 
 quiet_cmd_sanitytest = TEST    $@
       cmd_sanitytest = $(obj)/insn_sanity $(posttest_64bit) -m 1000000
diff --git a/arch/x86/tools/chkobjdump.awk b/arch/x86/tools/chkobjdump.awk
deleted file mode 100644
index a4cf678cf5c8..000000000000
--- a/arch/x86/tools/chkobjdump.awk
+++ /dev/null
@@ -1,34 +0,0 @@
-# GNU objdump version checker
-#
-# Usage:
-# objdump -v | awk -f chkobjdump.awk
-BEGIN {
-	# objdump version 2.19 or later is OK for the test.
-	od_ver = 2;
-	od_sver = 19;
-}
-
-/^GNU objdump/ {
-	verstr = ""
-	gsub(/\(.*\)/, "");
-	for (i = 3; i <= NF; i++)
-		if (match($(i), "^[0-9]")) {
-			verstr = $(i);
-			break;
-		}
-	if (verstr == "") {
-		printf("Warning: Failed to find objdump version number.\n");
-		exit 0;
-	}
-	split(verstr, ver, ".");
-	if (ver[1] > od_ver ||
-	    (ver[1] == od_ver && ver[2] >= od_sver)) {
-		exit 1;
-	} else {
-		printf("Warning: objdump version %s is older than %d.%d\n",
-		       verstr, od_ver, od_sver);
-		print("Warning: Skipping posttest.");
-		# Logic is inverted, because we just skip test without error.
-		exit 0;
-	}
-}

-- 
2.43.0

