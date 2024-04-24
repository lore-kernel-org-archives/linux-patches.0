Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D9716D9BD;
	Wed, 24 Apr 2024 18:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982772; cv=none; b=UADmxySKKy1Xaz52lrlBWwki2FkV8rZiU6x/rjyvA0H2FgOOio+gJZoSqL5Gs9Dm/Ew8jUoEQo9kQHbPSYJj0AvT8+RVnvx3Ymq16DWLe/yFZAAEHxqRvuoQuu/cMcnDh7Gb4/ZtZlZNKEikzH+6TrcQapf4DLvzHibnFXjwEVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982772; c=relaxed/simple;
	bh=YYFsl4yWYluQbj6hGHIa+U6qnF0kf+kUvDNxTFeSZL4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SBpFcg0vW65DfUFy3AQwpHAjjcG2aQ5XUQ02fjrImZDPTGpwJJfsqvwp6wLSE89tWyMallaHe/s2Ix/QMqe7Er84zJ2kMgjtPLRagDHWreoypSWMcTPUeRiT6vGRMtmMQGw0aFQibr4Ckda9fTvRMIEtd7F35Y+jR01AQdwEPII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OM1S5iZs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OM1S5iZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDEF1C3277B;
	Wed, 24 Apr 2024 18:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713982771;
	bh=YYFsl4yWYluQbj6hGHIa+U6qnF0kf+kUvDNxTFeSZL4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=OM1S5iZswnjg8bsR5F3c8MBe53USpnTDkmHXFDtOIiUq6Qc9+FzOqyVxmxtmkP1Gu
	 QOLhVZcDI8kFqQG92y3NcPG4Jch2m0WMpwh/KdXpCZRkVejmMhZTFH150mwOnf7OfM
	 F8llzH8Q+E57+fQ0V33Gy1KZZyHxVT26jhVty6tUr8nDJtWGP0Jg2h28eAkObkZKbM
	 h5xDG2+qyNrq9c3bG4NhBsumwMVE88Cw5C6XLxup/D90TO4WFP4SbiuC+OnrMTPUTi
	 EgiRIsY7vKju3j2fpmKkHHtak7zK6RYjI7WvUnryZ2kFCT4svEzR70mUmySUgL3Hnf
	 7MA5VyYD09LKQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 24 Apr 2024 11:19:26 -0700
Subject: [PATCH 1/2] drm/amd/display: Add frame_warn_flag to
 dml2_core_shared.o
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240424-amdgpu-dml2-fix-frame-larger-than-dcn401-v1-1-5659f8fa8816@kernel.org>
References: <20240424-amdgpu-dml2-fix-frame-larger-than-dcn401-v1-0-5659f8fa8816@kernel.org>
In-Reply-To: <20240424-amdgpu-dml2-fix-frame-larger-than-dcn401-v1-0-5659f8fa8816@kernel.org>
To: harry.wentland@amd.com, sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com, 
 alexander.deucher@amd.com, christian.koenig@amd.com, Xinhui.Pan@amd.com
Cc: aurabindo.pillai@amd.com, amd-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2500; i=nathan@kernel.org;
 h=from:subject:message-id; bh=YYFsl4yWYluQbj6hGHIa+U6qnF0kf+kUvDNxTFeSZL4=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGmavob8ebcse49PL17xKLFsxzKBVeUuv6b//PhXmt0rj
 umlU1ZRRykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZjI600M/9MfX3lRvuzqSr36
 4s/RPtX1Ube5dZ9bP3X28rm97udDCS5Ghstsut07z30w2sAWeFLhyP5TVXNaXRea1bwNjhfPb33
 5iRkA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building with tip of tree Clang, there are some new instances of
-Wframe-larger-than from the new display code (which become fatal with
CONFIG_WERROR=y):

  drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/dml21/src/dml2_core/dml2_core_shared.c:754:6: error: stack frame size (2488) exceeds limit (2048) in 'dml2_core_shared_mode_support' [-Werror,-Wframe-larger-than]
    754 | bool dml2_core_shared_mode_support(struct dml2_core_calcs_mode_support_ex *in_out_params)
        |      ^
  drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/dml21/src/dml2_core/dml2_core_shared.c:9834:6: error: stack frame size (2152) exceeds limit (2048) in 'dml2_core_shared_mode_programming' [-Werror,-Wframe-larger-than]
   9834 | bool dml2_core_shared_mode_programming(struct dml2_core_calcs_mode_programming_ex *in_out_params)
        |      ^
  2 errors generated.

These warnings do not occur when CONFIG_K{A,C,M}SAN are disabled, so add
$(frame_warn_flag) to dml2_core_shared.o's CFLAGS, which was added in
commit 6740ec97bcdb ("drm/amd/display: Increase frame warning limit with
KASAN or KCSAN in dml2") to account for this situation.

Fixes: d546a39c6b10 ("drm/amd/display: Add misc DC changes for DCN401")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/Makefile b/drivers/gpu/drm/amd/display/dc/dml2/Makefile
index 6c76f346b237..c35212a4a968 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dml2/Makefile
@@ -113,7 +113,7 @@ CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_top/dml2_top_optimization := $(dml2_
 CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4.o := $(dml2_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.o := $(dml2_ccflags) -Wframe-larger-than=2048
 CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_core/dml2_core_factory.o := $(dml2_ccflags)
-CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_core/dml2_core_shared.o := $(dml2_ccflags)
+CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_core/dml2_core_shared.o := $(dml2_ccflags) $(frame_warn_flag)
 CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_dpmm/dml2_dpmm_dcn4.o := $(dml2_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_dpmm/dml2_dpmm_factory.o := $(dml2_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_mcg/dml2_mcg_dcn4.o := $(dml2_ccflags)

-- 
2.44.0

