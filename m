Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2421C5D44;
	Fri, 15 Aug 2025 01:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755221516; cv=none; b=ZvsIMqhIF/mvC6G2eT/6Lsh1khZ1/xGvo5hZ6SGtALIdBD6GdI4Y/s2AvCctT7BomkNQQUfU4OwUxDdjWjI0yde5W/7fEDGJU84UzyrGkfOM5PyP9b6DvWn5UBEta9hWxEwJjhhNXULgadzpLpeblsN3Ppy8t7tceASCWVxOmo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755221516; c=relaxed/simple;
	bh=wsYRUWlX9PDsovfpyWwlin/E7wFWkuTbNk77f6srOmc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dtK2J7bkiu9/c9LyZleJvN93RpElmtSjvKyhw7RJiZUxRuusPkPRGg9i6X4gU93ZpegkZDses4BW3RESamgjgm61kWAqNTD5R+H988y5GoQsLdpM99yTxDZD/SWvcPhTnCkGqIhbr1UoNyvqftzpgCuCSiTF0Dx8JDYgFxrGP3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cn2SvjDG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cn2SvjDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75DC9C4CEF1;
	Fri, 15 Aug 2025 01:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755221516;
	bh=wsYRUWlX9PDsovfpyWwlin/E7wFWkuTbNk77f6srOmc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=cn2SvjDGcZkggmUfYcXLxTPeqGoT+6pGl+7mAOfG3bDzW+h0Uq14qgto34ga/qa+G
	 yrMxQCn+g/lW/7ciOS+xvjQxB9nOHMtR3gW9PRISa/vlmmpwg8n9PcgmdNlh9Z5Vru
	 0KRFdm1Zy1g7XbBmMlddK3RWN6KLiDxq0z0Hct8n6imPVdAecaes22+xVxU3FdkGGT
	 G6ZaYB8pBeXX28CSKigpebu18LCnmnewZ27juT849qR1pskQotv2BQ8puVgR9S7gSe
	 Owt8lQxgxQ5pRf6Y8U1KjODzvSqMiSh/Fj4BCpKJw1dYu67oQRcshoCFHPrVM/d8xO
	 CrDKzg16mmJoQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 14 Aug 2025 18:31:39 -0700
Subject: [PATCH 3/6] x86/build: Clean up stack alignment flags in
 CC_FLAGS_FPU
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250814-x86-min-ver-cleanups-v1-3-ff7f19457523@kernel.org>
References: <20250814-x86-min-ver-cleanups-v1-0-ff7f19457523@kernel.org>
In-Reply-To: <20250814-x86-min-ver-cleanups-v1-0-ff7f19457523@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org
Cc: linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1679; i=nathan@kernel.org;
 h=from:subject:message-id; bh=wsYRUWlX9PDsovfpyWwlin/E7wFWkuTbNk77f6srOmc=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBnz+pgFdjh2p2+rbJt5js/7c/YDXr30hJbPmlnGn6aGX
 rg97eeLjlIWBjEuBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjARdx9GhhnbHvSavPyatjwj
 qD/ffLLr3MnG/5S3vlI5zTD3IP+mx3MZ/llnX94wX926+Xwph9DF+/KVwe+2uVbk71zdkMrEZHP
 dhgcA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

The minimum supported version of GCC to build the x86 kernel was bumped
to GCC 8.1 in commit a3e8fe814ad1 ("x86/build: Raise the minimum GCC
version to 8.1").

Prior to GCC 7.1, '-mpreferred-stack-boundary=3' was not allowed with
'-msse', so areas of the kernel that needed floating point had a
different alignment. Now that GCC > 7.1 is mandatory, there is no need
to have a different value of '-mpreferred-stack-boundary' from the rest
of the kernel, so remove this handling from CC_FLAGS_FPU.

Link: https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=34fac449e121be97dd073c5428cc855367b2872c
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/x86/Makefile | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index f0aa58d2ec17..0c82a610fb54 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -84,19 +84,7 @@ KBUILD_RUSTFLAGS += -Ctarget-feature=-sse,-sse2,-sse3,-ssse3,-sse4.1,-sse4.2,-av
 #
 CC_FLAGS_FPU := -msse -msse2
 ifdef CONFIG_CC_IS_GCC
-# Stack alignment mismatch, proceed with caution.
-# GCC < 7.1 cannot compile code using `double` and -mpreferred-stack-boundary=3
-# (8B stack alignment).
-# See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=53383
-#
-# The "-msse" in the first argument is there so that the
-# -mpreferred-stack-boundary=3 build error:
-#
-#  -mpreferred-stack-boundary=3 is not between 4 and 12
-#
-# can be triggered. Otherwise gcc doesn't complain.
 CC_FLAGS_FPU += -mhard-float
-CC_FLAGS_FPU += $(call cc-option,-msse -mpreferred-stack-boundary=3,-mpreferred-stack-boundary=4)
 endif
 
 ifeq ($(CONFIG_X86_KERNEL_IBT),y)

-- 
2.50.1

