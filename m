Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E2D1E521E;
	Mon, 23 Jun 2025 21:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713478; cv=none; b=UabPRuEAv4tT1lCk6Q3C82pvmBLd/T68gwEx8osuykkP4rVTJPBr39vJakzCllgSpkq1VcuFcbZCr+KyZ6wvZVAGiAr0VbaLav2zF7QNkiz7G8soE63y0N6AkGd+lHTIvQ9eaRJtPdxgzGMQQH7tZjRMsg0DT+h69z0PGD3YP5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713478; c=relaxed/simple;
	bh=LgP7cRZhjuavTIgAegKaZWqkDagbH9iBXQF1Tiv9mKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYCSyfrpTzCjHrbBiN0LMiVUnDEkt7AMH5tRCpTUyVTLXnqISrdDPBPdfo/xRC941s5bVemmq+X6+qXt7zpMJkE6o5C2StQQ7FRbTqtsNV7EDwf59Kif3nzxrAu34RbosL0WSdFbna8VP3FuCr7hr5dekUDLtl4IbpHXVXFg/4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gft9OGag; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gft9OGag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFF4C4CEEA;
	Mon, 23 Jun 2025 21:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713477;
	bh=LgP7cRZhjuavTIgAegKaZWqkDagbH9iBXQF1Tiv9mKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gft9OGagMJx+PkNTBj9aIuCtToErejXSiGM4epSfSvr7lf5788WbtJXQFr8UI/VOu
	 7Ipiebe5R84HghC2zwo/EdtSvHkiLzDM76nGAIAhd2RLY5WN6h39durPqoKXxMnF3e
	 YzWyBFtaitSIezDTCJArFB6ORVU/vPFz8qzKtzH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.10 150/355] drm/amd/display: Do not add -mhard-float to dcn2{1,0}_resource.o for clang
Date: Mon, 23 Jun 2025 15:05:51 +0200
Message-ID: <20250623130631.216659861@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

This patch is for linux-5.15.y and earlier only. It is functionally
equivalent to upstream commit 7db038d9790e ("drm/amd/display: Do not add
'-mhard-float' to dml_ccflags for clang"), which was created after all
files that require '-mhard-float' were moved under the dml folder. In
kernels older than 5.18, which do not contain upstream commits

  22f87d998326 ("drm/amd/display: move FPU operations from dcn21 to dml/dcn20 folder")
  cf689e869cf0 ("drm/amd/display: move FPU-related code from dcn20 to dml folder")

newer versions of clang error with

  clang: error: unsupported option '-mhard-float' for target 'x86_64-linux-gnu'
  make[6]: *** [scripts/Makefile.build:289: drivers/gpu/drm/amd/amdgpu/../display/dc/dcn20/dcn20_resource.o] Error 1
  clang: error: unsupported option '-mhard-float' for target 'x86_64-linux-gnu'
  make[6]: *** [scripts/Makefile.build:289: drivers/gpu/drm/amd/amdgpu/../display/dc/dcn21/dcn21_resource.o] Error 1

Apply a functionally equivalent change to prevent adding '-mhard-float'
with clang for these files.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/Makefile |    2 +-
 drivers/gpu/drm/amd/display/dc/dcn21/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn20/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/Makefile
@@ -10,7 +10,7 @@ DCN20 = dcn20_resource.o dcn20_init.o dc
 DCN20 += dcn20_dsc.o
 
 ifdef CONFIG_X86
-CFLAGS_$(AMDDALPATH)/dc/dcn20/dcn20_resource.o := -mhard-float -msse
+CFLAGS_$(AMDDALPATH)/dc/dcn20/dcn20_resource.o := $(if $(CONFIG_CC_IS_GCC), -mhard-float) -msse
 endif
 
 ifdef CONFIG_PPC64
--- a/drivers/gpu/drm/amd/display/dc/dcn21/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/Makefile
@@ -6,7 +6,7 @@ DCN21 = dcn21_init.o dcn21_hubp.o dcn21_
 	 dcn21_hwseq.o dcn21_link_encoder.o
 
 ifdef CONFIG_X86
-CFLAGS_$(AMDDALPATH)/dc/dcn21/dcn21_resource.o := -mhard-float -msse
+CFLAGS_$(AMDDALPATH)/dc/dcn21/dcn21_resource.o := $(if $(CONFIG_CC_IS_GCC), -mhard-float) -msse
 endif
 
 ifdef CONFIG_PPC64


