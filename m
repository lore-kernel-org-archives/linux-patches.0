Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6417274FDC;
	Sat, 30 May 2026 18:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165584; cv=none; b=h4GoN4nM+oy+LwFF1WZHDD70NYwJLzsOdPhIpa+sJgDBoWVnaxkPNWKXTfbVm0Vw8mRAhcVvn2Xv7z4kNHQYB2dREOISC959D6ZBsI3rteXJ33TYCH4XQ4hsfhUHxqJjceTDRG3G6rERgT5CfqM5+oQc0sJMHM5RG6S2A/W3Zwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165584; c=relaxed/simple;
	bh=qmnLCE0sX+b2wpOZORLQST2ZMGP82pngkbi8+w5740U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=czh7nIM71tWgTNMS+I7gnP7yo2YC+1sv0f0cJ5/XuZb7/qNI+c1V4tVTtJxaNVOWwRZIsiUT8wOaa4+xGTehBnaDmlQt+DI9Lhgf0jGLPkQ1gSu4QgggCCzpMYkiaWCRLD7L88v4vPkWd6Kqeupc80d3DmhiMCRRC/cTaTkGvPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iRded4xZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iRded4xZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184311F00893;
	Sat, 30 May 2026 18:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165583;
	bh=QlH9x+8CcJPmYYAddptbowV8K4uGRWk+NYXTesb/0bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iRded4xZ6U3ofUmVmpnZsaIZUYqUQrED4cOSgN2RYPlQ9+d5kOztOf9WMx0F7kQQg
	 RJpKFF8LnqURSM1+0ydIMy7EMVLMkzHUKk/nVYYGXOpxc00+jJDOLjCPcOR9qKFKBz
	 Yun79T5fr/17wfTlsbJjihJTWFALbgAdN8XkwuB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.10 121/589] drm/amd/display: Do not add -mhard-float to calcs, dsc, and dcn30 FP files for clang
Date: Sat, 30 May 2026 18:00:02 +0200
Message-ID: <20260530160227.943828059@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Nathan Chancellor <nathan@kernel.org>

This patch is for linux-5.10.y only. It is functionally equivalent to
upstream commit 7db038d9790e ("drm/amd/display: Do not add
'-mhard-float' to dml_ccflags for clang"), which was created after all
files that require '-mhard-float' were moved under the dml folder. In
linux-5.10.y, which does not contain upstream commits

  b4bab46400a0 ("drm/amd/display: move calcs folder into DML")
  27e01f10d183 ("drm/amd/display: move FPU associated DSC code to DML folder")
  40b31e5355ba ("drm/amd/display: Remove FPU flags from DCN30 Makefile")

clang-21 or newer errors with

  clang: error: unsupported option '-mhard-float' for target 'x86_64-pc-linux-gnu'
  make[6]: *** [scripts/Makefile.build:286: drivers/gpu/drm/amd/amdgpu/../display/dc/calcs/dcn_calc_math.o] Error 1
  clang: error: unsupported option '-mhard-float' for target 'x86_64-pc-linux-gnu'
  make[6]: *** [scripts/Makefile.build:286: drivers/gpu/drm/amd/amdgpu/../display/dc/calcs/dcn_calcs.o] Error 1
  clang: error: unsupported option '-mhard-float' for target 'x86_64-pc-linux-gnu'
  make[6]: *** [scripts/Makefile.build:286: drivers/gpu/drm/amd/amdgpu/../display/dc/calcs/dcn_calc_auto.o] Error 1
  clang: error: unsupported option '-mhard-float' for target 'x86_64-pc-linux-gnu'
  make[6]: *** [scripts/Makefile.build:286: drivers/gpu/drm/amd/amdgpu/../display/dc/dsc/rc_calc.o] Error 1
  clang: error: unsupported option '-mhard-float' for target 'x86_64-pc-linux-gnu'
  make[6]: *** [scripts/Makefile.build:286: drivers/gpu/drm/amd/amdgpu/../display/dc/dcn30/dcn30_optc.o] Error 1
  clang: error: unsupported option '-mhard-float' for target 'x86_64-pc-linux-gnu'
  make[6]: *** [scripts/Makefile.build:286: drivers/gpu/drm/amd/amdgpu/../display/dc/dcn30/dcn30_resource.o] Error 1

Apply a functionally equivalent change to prevent adding '-mhard-float'
with clang for these files.

Closes: https://github.com/ClangBuiltLinux/linux/issues/2156
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/calcs/Makefile |    3 ++-
 drivers/gpu/drm/amd/display/dc/dcn30/Makefile |    4 ++--
 drivers/gpu/drm/amd/display/dc/dsc/Makefile   |    3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/calcs/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/calcs/Makefile
@@ -26,7 +26,8 @@
 #
 
 ifdef CONFIG_X86
-calcs_ccflags := -mhard-float -msse
+calcs_ccflags-$(CONFIG_CC_IS_GCC) := -mhard-float
+calcs_ccflags := $(calcs_ccflags-y) -msse
 endif
 
 ifdef CONFIG_PPC64
--- a/drivers/gpu/drm/amd/display/dc/dcn30/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/Makefile
@@ -32,8 +32,8 @@ DCN30 = dcn30_init.o dcn30_hubbub.o dcn3
 
 
 ifdef CONFIG_X86
-CFLAGS_$(AMDDALPATH)/dc/dcn30/dcn30_resource.o := -mhard-float -msse
-CFLAGS_$(AMDDALPATH)/dc/dcn30/dcn30_optc.o := -mhard-float -msse
+CFLAGS_$(AMDDALPATH)/dc/dcn30/dcn30_resource.o := $(if $(CONFIG_CC_IS_GCC),-mhard-float) -msse
+CFLAGS_$(AMDDALPATH)/dc/dcn30/dcn30_optc.o := $(if $(CONFIG_CC_IS_GCC),-mhard-float) -msse
 endif
 
 ifdef CONFIG_PPC64
--- a/drivers/gpu/drm/amd/display/dc/dsc/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dsc/Makefile
@@ -3,7 +3,8 @@
 # Makefile for the 'dsc' sub-component of DAL.
 
 ifdef CONFIG_X86
-dsc_ccflags := -mhard-float -msse
+dsc_ccflags-$(CONFIG_CC_IS_GCC) := -mhard-float
+dsc_ccflags := $(dsc_ccflags-y) -msse
 endif
 
 ifdef CONFIG_PPC64


