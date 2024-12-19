Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E721EE7D3;
	Thu, 19 Dec 2024 23:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734652009; cv=none; b=mkQEG6P0vdMSmdduW+TAeAolocKUL8VvuskcbhJfESXr7Krj/HDFasKN7g2vAz4eQOYQsHpamuC8Cz3MIu5OFnwctEXs7eX2AX3zQYVDkJdCuZJlGGzx9OVh/+8J1U9l6j3WxCUo3F9kr0Q2Nur4NsH8V9clwnUedPENdFZ/Mp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734652009; c=relaxed/simple;
	bh=VlgIxjX59zEAgQYr06DoizAEZuBLCR+PtLTOfL+NXJw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=AyxCrJ7XTlTBRlrITDF4P8N31AvRKcHbaVbMxAu4nhX3OMfy1C5C7l19f8gGaYha2QhrxbAy8tl3lM79+BzPOvAwBSXz/BKA8x+b9uAzsC3qmD33e1FOFb3UQQot6dcT5FC9TzdeKrZ8bUWSz13tCW1ydiy4sQwXWtXqGRiysd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uziCFrfE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uziCFrfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86459C4CED4;
	Thu, 19 Dec 2024 23:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734652009;
	bh=VlgIxjX59zEAgQYr06DoizAEZuBLCR+PtLTOfL+NXJw=;
	h=From:Date:Subject:To:Cc:From;
	b=uziCFrfEeAh8k+2m+V9C/N36gBo4Jn29A1NYTu9fcDAa87m9o7r/n/1+Fi1NwypHy
	 Emv/qVcNACtrMkU/P3KKu2mxfSs0pk3gF0ARII+rR0O8uIWKFNS4ot8y7lduqhRhO4
	 msmOe95d7sTkRcgIiKyRLBDwF9etdrLDA9CS0s+gEkAAVqbFTpD4BVKcoEwPM8ke3V
	 8AmQhxPE0BQFV4+iicZ7Ff+mfWJDEc8y2u4R/rO6t0JN2Od3PtCX7hEgr/xKZEbumC
	 sPrgN+xqxHn76GNwsjqubiHp7lLC0/cVqVJd49viYdg1r9nKF4cN2CBWdG2QZCPTWm
	 oUkMuhIbyKW/A==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 19 Dec 2024 16:46:35 -0700
Subject: [PATCH] drm/amd/display: Increase sanitizer frame larger than
 limit when compile testing with clang
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241219-amdgpu-dml2-address-clang-frame-larger-than-allconfig-v1-1-8c53a644d486@kernel.org>
X-B4-Tracking: v=1; b=H4sIAFqwZGcC/x2N0QrCMAxFf2Xk2cBaJzh/RXwITVoD7TZSFWHs3
 w0+Hu499+7QxVQ63IYdTD7adV0cwmmA9KSlCCo7QxzjFGKYkRqX7Y3cakRiNukdU/UmZqMmWMm
 KGL5cRqo1rUtWz8bzxHO6hHAV8O3NJOv3/3t/HMcPwaEKSYcAAAA=
X-Change-ID: 20241219-amdgpu-dml2-address-clang-frame-larger-than-allconfig-f034d9c5118e
To: Chaitanya Dhere <chaitanya.dhere@amd.com>, Jun Lei <jun.lei@amd.com>, 
 Harry Wentland <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>, 
 Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>, 
 Alex Deucher <alexander.deucher@amd.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Xinhui Pan <Xinhui.Pan@amd.com>
Cc: amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 kernel test robot <lkp@intel.com>, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3854; i=nathan@kernel.org;
 h=from:subject:message-id; bh=VlgIxjX59zEAgQYr06DoizAEZuBLCR+PtLTOfL+NXJw=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOkpG9KSRZ5tMNrsnDf3up++trOTeLpqh/b+034S29esU
 VWS33G4o5SFQYyLQVZMkaX6sepxQ8M5ZxlvnJoEM4eVCWQIAxenAExk6m9Ghlu3bC5ZOf9kclF0
 OsFnqnljfdjd+YILG/j7orwNrjw0lWX4X/45xv60ZWn0bG4dBaX5Kf/Y5d9OKLy0/832A+FnD/+
 qZgQA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Commit 24909d9ec7c3 ("drm/amd/display: Overwriting dualDPP UBF values
before usage") added a new warning in dml2/display_mode_core.c when
building allmodconfig with clang:

  drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/display_mode_core.c:6268:13: error: stack frame size (3128) exceeds limit (3072) in 'dml_prefetch_check' [-Werror,-Wframe-larger-than]
   6268 | static void dml_prefetch_check(struct display_mode_lib_st *mode_lib)
        |             ^

Commit be4e3509314a ("drm/amd/display: DML21 Reintegration For Various
Fixes") introduced one in dml2_core/dml2_core_dcn4_calcs.c with the same
configuration:

  drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c:7236:13: error: stack frame size (3256) exceeds limit (3072) in 'dml_core_mode_support' [-Werror,-Wframe-larger-than]
   7236 | static bool dml_core_mode_support(struct dml2_core_calcs_mode_support_ex *in_out_params)
        |             ^

In the case of the first warning, the stack usage was already at the
limit at the parent change, so the offending change was rather
innocuous. In the case of the second warning, there was a rather
dramatic increase in stack usage compared to the parent:

  drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c:7032:13: error: stack frame size (2696) exceeds limit (2048) in 'dml_core_mode_support' [-Werror,-Wframe-larger-than]
   7032 | static bool dml_core_mode_support(struct dml2_core_calcs_mode_support_ex *in_out_params)
        |             ^

This is an unfortunate interaction between an issue with stack slot
reuse in LLVM that gets exacerbated by sanitization (which gets enabled
with all{mod,yes}config) and function calls using a much higher number
of parameters than is typical in the kernel, necessitating passing most
of these values on the stack.

While it is possible that there should be source code changes to address
these warnings, this code is difficult to modify for various reasons, as
has been noted in other changes that have occurred for similar reasons,
such as commit 6740ec97bcdb ("drm/amd/display: Increase frame warning
limit with KASAN or KCSAN in dml2").

Increase the frame larger than limit when compile testing with clang and
the sanitizers enabled to avoid this breakage in all{mod,yes}config, as
they are commonly used and valuable testing targets. While it is not the
best to hide this issue, it is not really relevant when compile testing,
as the sanitizers are commonly stressful on optimizations and they are
only truly useful at runtime, which COMPILE_TEST states will not occur
with the current build.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202412121748.chuX4sap-lkp@intel.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/Makefile b/drivers/gpu/drm/amd/display/dc/dml2/Makefile
index d9c27ebe12ee08d6330eb199cd8ca9c8489fa5b2..91c4f3b4bd5f46ac5c1c74f665b06dbe61081917 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dml2/Makefile
@@ -29,7 +29,11 @@ dml2_rcflags := $(CC_FLAGS_NO_FPU)
 
 ifneq ($(CONFIG_FRAME_WARN),0)
 ifeq ($(filter y,$(CONFIG_KASAN)$(CONFIG_KCSAN)),y)
+ifeq ($(CONFIG_CC_IS_CLANG)$(CONFIG_COMPILE_TEST),yy)
+frame_warn_flag := -Wframe-larger-than=4096
+else
 frame_warn_flag := -Wframe-larger-than=3072
+endif
 else
 frame_warn_flag := -Wframe-larger-than=2048
 endif

---
base-commit: 695c2c745e5dff201b75da8a1d237ce403600d04
change-id: 20241219-amdgpu-dml2-address-clang-frame-larger-than-allconfig-f034d9c5118e

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

