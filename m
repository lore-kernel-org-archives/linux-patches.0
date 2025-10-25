Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAB9301022;
	Sat, 25 Oct 2025 16:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409115; cv=none; b=uaQbRS+A9H3djFAYP4oTL32rLmUvnVwkcUWYPW/DqMDiRSLlhn5yCtFB5r54m+4jwWRoPnLA6/6evNxfpuCiqHsS+iPK59KIDbb0wH6DxIzTLntjwKI+xVT0TbKhxZVFvAdO8C+caDiQdnfQaK+ZrsydQh+yMz4p3cf7FV/opKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409115; c=relaxed/simple;
	bh=jcfeNa3Lv5n/fUsc80GUXPu6/riZaxFyuE/HINiZp8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gBXMrVCC40eXq51cdMY6pFBhPQT4tOrvZqmy1W7152cKYQiRAJM08Jgvt6ORXm3D+YkQ/E9Z5KC9qYt5OK+Me6BVgE/dyqmdatyoXuGYcf6L1EdSRubHteUaBVuRRYYNdCjn/5wZ0YbvGT/paNIqjdW29CAp6rR+kmSM78ABjiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TyOUPOuA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TyOUPOuA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B548C4CEF5;
	Sat, 25 Oct 2025 16:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409115;
	bh=jcfeNa3Lv5n/fUsc80GUXPu6/riZaxFyuE/HINiZp8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TyOUPOuAw2hrOR5fv1P8q2Kevn/mUPxlaH80Ma+CmotYzbC5SI5hUo0/3xVvtFfYo
	 Ff88EZcFP2HcR1aw2ZD+dFx8uAsPDbgfrz1lI42p3c2Tr5NadqsdPh16KeSibePXjT
	 7lIQ+RCMcHjs1BROKSDiFqZ+AnSalfWgaOmGiJ1dBOS2+x+MWLhnvsneDWfTUjErxg
	 dbcrKLOIlDYTyMMGdMlX652WtQ0dIAk7/wi4/apGAfHwnicoAcyI9wd39ABeVRqrMS
	 +xkhPZanSdOWTAiav/1xNhcc/pGheyg/tfqwXt/tot+xcQrFg1Bhg3XoOea61vcgfL
	 HIZEgWC+41Akg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	alvin.lee2@amd.com,
	alex.hung@amd.com,
	chiahsuan.chung@amd.com,
	PeiChen.Huang@amd.com,
	chris.park@amd.com,
	karthi.kandasamy@amd.com,
	dillon.varone@amd.com,
	alexandre.f.demers@gmail.com,
	rvojvodi@amd.com,
	martin.leung@amd.com,
	Syed.Hassan@amd.com,
	Wayne.Lin@amd.com
Subject: [PATCH AUTOSEL 6.17-6.1] drm/amd/display: add more cyan skillfish devices
Date: Sat, 25 Oct 2025 11:57:15 -0400
Message-ID: <20251025160905.3857885-204-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 3cf06bd4cf2512d564fdb451b07de0cebe7b138d ]

Add PCI IDs to support display probe for cyan skillfish
family of SOCs.

Acked-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it changes
  - Adds additional Cyan Skillfish PCI IDs in
    `drivers/gpu/drm/amd/display/include/dal_asic_id.h` next to the
    existing ones: currently only `DEVICE_ID_NV_13FE` and
    `DEVICE_ID_NV_143F` exist at
    drivers/gpu/drm/amd/display/include/dal_asic_id.h:214-215; the
    commit introduces `DEVICE_ID_NV_13F9`, `DEVICE_ID_NV_13FA`,
    `DEVICE_ID_NV_13FB`, `DEVICE_ID_NV_13FC`, and `DEVICE_ID_NV_13DB`.
  - Extends the NV-family DC version mapping in
    `drivers/gpu/drm/amd/display/dc/core/dc_resource.c` so that these
    new IDs are treated as DCN 2.01 devices. Today, NV defaults to DCN
    2.0 and only switches to DCN 2.01 for `13FE` and `143F`
    (drivers/gpu/drm/amd/display/dc/core/dc_resource.c:166-171). The
    patch adds the new IDs to that conditional.

- Why it matters
  - DC’s internal behavior depends on the detected `dce_version`. There
    are explicit code paths for DCN 2.01 that differ from DCN 2.0:
    - Clock manager constructs a DCN 2.01-specific manager when
      `ctx->dce_version == DCN_VERSION_2_01`
      (drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c:270-275).
    - GPIO factory initialization distinguishes DCN 2.01 from 2.0
      (drivers/gpu/drm/amd/display/dc/gpio/hw_factory.c:92-98).
    - BIOS command table helper includes DCN 2.01 handling (drivers/gpu/
      drm/amd/display/dc/bios/command_table_helper2.c:70-76).
    - DCN 2.01 has special bandwidth/cstate behavior
      (drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c:1231-1234).
  - Without mapping these new Cyan Skillfish device IDs to DCN 2.01,
    display probe and initialization may follow the wrong DC path (DCN
    2.0 default in `FAMILY_NV`) and fail or misconfigure the hardware.
    The commit message explicitly states it’s needed “to support display
    probe for cyan skillfish family of SOCs.”

- Scope and risk
  - Small, contained change: adds five ID macros and extends a single
    conditional check. No architectural refactors; no ABI or uAPI
    changes.
  - Regression risk is minimal: the new condition only triggers for the
    newly added PCI IDs; existing devices and code paths remain
    unchanged.
  - Security impact: none; this is purely device-ID-based
    enablement/mapping.

- Stable backport considerations
  - This is a targeted fix enabling correct display bring-up on
    additional SKUs of an already supported SOC family; it does not
    introduce features beyond enabling hardware that should have worked.
  - There is no “Cc: stable” or “Fixes:” tag, but DRM/amdgpu routinely
    backports safe device-ID additions.
  - Dependency note: For this to have practical effect, the
    corresponding PCI IDs must be present in the amdgpu PCI device table
    (see existing entries for Cyan Skillfish at
    drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c:2174-2176). If those new IDs
    are not yet present in the target stable branch, this change is
    inert but harmless; ideally backport together with the PCI table
    additions.

- Conclusion
  - It fixes a real user-visible issue (display probe on additional Cyan
    Skillfish variants) with minimal, low-risk changes confined to the
    AMD display subsystem. This is an appropriate and safe candidate for
    stable backport.

 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 8 +++++++-
 drivers/gpu/drm/amd/display/include/dal_asic_id.h | 5 +++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 4d6181e7c612b..d712548b1927d 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -165,7 +165,13 @@ enum dce_version resource_parse_asic_id(struct hw_asic_id asic_id)
 
 	case FAMILY_NV:
 		dc_version = DCN_VERSION_2_0;
-		if (asic_id.chip_id == DEVICE_ID_NV_13FE || asic_id.chip_id == DEVICE_ID_NV_143F) {
+		if (asic_id.chip_id == DEVICE_ID_NV_13FE ||
+		    asic_id.chip_id == DEVICE_ID_NV_143F ||
+		    asic_id.chip_id == DEVICE_ID_NV_13F9 ||
+		    asic_id.chip_id == DEVICE_ID_NV_13FA ||
+		    asic_id.chip_id == DEVICE_ID_NV_13FB ||
+		    asic_id.chip_id == DEVICE_ID_NV_13FC ||
+		    asic_id.chip_id == DEVICE_ID_NV_13DB) {
 			dc_version = DCN_VERSION_2_01;
 			break;
 		}
diff --git a/drivers/gpu/drm/amd/display/include/dal_asic_id.h b/drivers/gpu/drm/amd/display/include/dal_asic_id.h
index 5fc29164e4b45..8aea50aa95330 100644
--- a/drivers/gpu/drm/amd/display/include/dal_asic_id.h
+++ b/drivers/gpu/drm/amd/display/include/dal_asic_id.h
@@ -213,6 +213,11 @@ enum {
 #endif
 #define DEVICE_ID_NV_13FE 0x13FE  // CYAN_SKILLFISH
 #define DEVICE_ID_NV_143F 0x143F
+#define DEVICE_ID_NV_13F9 0x13F9
+#define DEVICE_ID_NV_13FA 0x13FA
+#define DEVICE_ID_NV_13FB 0x13FB
+#define DEVICE_ID_NV_13FC 0x13FC
+#define DEVICE_ID_NV_13DB 0x13DB
 #define FAMILY_VGH 144
 #define DEVICE_ID_VGH_163F 0x163F
 #define DEVICE_ID_VGH_1435 0x1435
-- 
2.51.0

