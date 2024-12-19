Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCB619E7F8;
	Thu, 19 Dec 2024 17:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734628365; cv=none; b=siht+7SIvotaoFbhRuQkUVCURuxUXd0EcO4ts4goitleQahWAMVImWjx49bWUX9o/6okra6RML1PAEIlh8/r58to1n9hZDBA527w/92T66nBbDJgoEKAgI4Py+lMVHam9oIKKgBIQprIiJtCV3+CjdOq/h7eU20myvwUD/R4Yrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734628365; c=relaxed/simple;
	bh=MpqPn06almC1w7AKhIWoa4Ja+d2HKNexfyEQuKVEwGA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=lV2MhfWvZ6eTDlmb5Gc/Sn5SKEKtaGkb1EtX5XmZCgMmv8k8VVbtpzadzUjF33XT0j8F91lex61uwBjoOvrLXsZJcyK1jNt5QuVnFKtOUN4H2/n2VJQYAMyhYK2IEp/2jEy8jXAjxMMcodxD2tJjlul9TKqMFqhQETorBsTK6Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M8VHGVs4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M8VHGVs4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AADC4CECE;
	Thu, 19 Dec 2024 17:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734628364;
	bh=MpqPn06almC1w7AKhIWoa4Ja+d2HKNexfyEQuKVEwGA=;
	h=From:Date:Subject:To:Cc:From;
	b=M8VHGVs4H5v7Nfk8+7GME1RH4pX2cA6x5VJArmiYYpUzRuKMn384x8RKEFjFUZlZU
	 wUnXWhGZ2LA8mEik95iGWk18wEjnjQn1nPsjHW1IodC10G/GD2SjqoRTirExpWD87F
	 V2MJrjB95v9z1eUtmnUTHUJlJGR+ITe8/Q2Xn50jNCW2HSctPxr9JUiUIfib0W5rVE
	 bQoIQMlpiAGxDEnCJddOFFl6CuBKMpYEkqBys63PYObgYuIV9YIQsfc4sqaP2ksQ+j
	 TqnCvgaCSnmiaJjc7AV1+r47NEQwNpqryQdm60gk8nlQmosuNILzYhIeDmXvctwGrK
	 u5xPk2TUZNQFA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 19 Dec 2024 10:12:31 -0700
Subject: [PATCH] drm/amd/display: Disable -Wenum-float-conversion for
 dml2_dpmm_dcn4.c
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241219-amdgpu-fix-enum-float-conversion-again-again-v1-1-ef2c619724b1@kernel.org>
X-B4-Tracking: v=1; b=H4sIAP5TZGcC/zWNQQrDIBBFrxJmnYEqbYq9SsliqqMZaDRoDIGQu
 9cWuvnwFu/9Awpn4QKP7oDMmxRJsYHqO7ATxcAorjHoi74qrQzS7MJS0cuOHOuM/p1oRZvixvk
 rIwWS/9qXd0bdjL8PDlpyydzE391zPM8PilMQuH4AAAA=
X-Change-ID: 20241219-amdgpu-fix-enum-float-conversion-again-again-cbfd9159f76d
To: Chaitanya Dhere <chaitanya.dhere@amd.com>, Jun Lei <jun.lei@amd.com>, 
 Harry Wentland <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>, 
 Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>, 
 Alex Deucher <alexander.deucher@amd.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Xinhui Pan <Xinhui.Pan@amd.com>, Austin Zheng <Austin.Zheng@amd.com>
Cc: Dillon Varone <dillon.varone@amd.com>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, amd-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2673; i=nathan@kernel.org;
 h=from:subject:message-id; bh=MpqPn06almC1w7AKhIWoa4Ja+d2HKNexfyEQuKVEwGA=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOkpIZx5PxTOzXhyjTvigruC+UJfYYdX9hu+FZelS8o0/
 uoxz53RUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACbyfw7D/7J75sm3tx6b9ts1
 Vpz//doP6hqmUZpFexgvvq056L/tcwDDP+NGvzVRfxNSHHZbzV/soVIk4jpPUO4aB6eZw+q9jGm
 3OQA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Commit be4e3509314a ("drm/amd/display: DML21 Reintegration For Various
Fixes") blew away commit fdedd77b0eb3 ("drm/amd/display: Reapply
2fde4fdddc1f"), which itself was a reapplication for the same reason,
which results in that compiler warning returning:

  drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/dml21/src/dml2_dpmm/dml2_dpmm_dcn4.c:215:58: error: arithmetic between enumeration type 'enum dentist_divider_range' and floating-point type 'double' [-Werror,-Wenum-float-conversion]
    215 |         divider = (unsigned int)(DFS_DIVIDER_RANGE_SCALE_FACTOR * (vco_freq_khz / clock_khz));
        |                                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~

Just disable the warning for the whole file via Makefile to avoid having
to reapply the same fix every time the code syncs from wherever it is
actually maintained.

Fixes: be4e3509314a ("drm/amd/display: DML21 Reintegration For Various Fixes")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
If you would prefer reapplying the local fix, feel free to do so, but I
would like for it to be in the upstream source so it does not have to
keep being applied.
---
 drivers/gpu/drm/amd/display/dc/dml2/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/Makefile b/drivers/gpu/drm/amd/display/dc/dml2/Makefile
index d9c27ebe12ee08d6330eb199cd8ca9c8489fa5b2..5c0f93644c5d43c8a0bc12713fc400712d8de50b 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dml2/Makefile
@@ -78,7 +78,7 @@ CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_top/dml2_top_soc15.o := $(dml2_ccfla
 CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4.o := $(dml2_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.o := $(dml2_ccflags) $(frame_warn_flag)
 CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_core/dml2_core_factory.o := $(dml2_ccflags)
-CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_dpmm/dml2_dpmm_dcn4.o := $(dml2_ccflags)
+CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_dpmm/dml2_dpmm_dcn4.o := $(dml2_ccflags) $(call cc-disable-warning,enum-float-conversion)
 CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_dpmm/dml2_dpmm_factory.o := $(dml2_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_mcg/dml2_mcg_dcn4.o := $(dml2_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/dml2/dml21/src/dml2_mcg/dml2_mcg_factory.o := $(dml2_ccflags)

---
base-commit: 695c2c745e5dff201b75da8a1d237ce403600d04
change-id: 20241219-amdgpu-fix-enum-float-conversion-again-again-cbfd9159f76d

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

