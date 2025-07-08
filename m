Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919122E540B;
	Tue,  8 Jul 2025 16:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993575; cv=none; b=rNueC3kZ521LzJAtz00pfjuTB96we4eY0gBNBZLk4UYNypH7CeIyVx7n+NkURC5l2WIIWkawV6mlorhcgF8gAN+qGomtXgYpEPo4eNFE5LgSeYlvL5DkF3+C4jt3Qlji/M3JXLu7rd/Kwqji3C+6ONhEw90kWhGngf7p9QZfOAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993575; c=relaxed/simple;
	bh=MnrCui42+pUpBcVYtM6xHKtwRgEqUVUno61jvfZsaFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANYkRA1xTkC8v2gODreprR95xmu1pqmgrHhdIlVMCXZV1GlbhIE9gtU3Lhl9BBWlgZI3n5e/oHEsm0BmKhUSAfge+/zUUWAXsduT/UqHgSuaA7vY/9OoExVQkqv0Vn+DGN4yuZc+/O4Ge84m3Sgr+8PNeltzT2PNK2+FPOBxDYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZFnNfeR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZFnNfeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A0BC4CEED;
	Tue,  8 Jul 2025 16:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993575;
	bh=MnrCui42+pUpBcVYtM6xHKtwRgEqUVUno61jvfZsaFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZFnNfeR2pk96BCEX26CXZ7sEWOgyYyX9rCFFicPOD30z6TmeVhUBcrgAS0hZWrUB
	 c5mKudr7K2DwKCK++iDqsyyhAnHF1RqiKyG8AY7S/If1TicHU8kPndzTV/f/iqrMGT
	 fXbUm702V4wT0deTqUQr/aOrnsWCudsGeY8IW/Kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Harrison <John.C.Harrison@Intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 104/178] drm/xe/guc: Enable w/a 16026508708
Date: Tue,  8 Jul 2025 18:22:21 +0200
Message-ID: <20250708162239.360196339@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Harrison <John.C.Harrison@Intel.com>

[ Upstream commit d3e8349edf7ed9eaf076ab3d9973331ccc20e26c ]

The workaround is only relevant to SRIOV but does affect all platforms.

Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://lore.kernel.org/r/20250403185619.1555853-2-John.C.Harrison@Intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Stable-dep-of: 84c0b4a00610 ("drm/xe/bmg: Update Wa_22019338487")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/abi/guc_klvs_abi.h | 1 +
 drivers/gpu/drm/xe/xe_guc_ads.c       | 5 +++++
 drivers/gpu/drm/xe/xe_wa_oob.rules    | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/xe/abi/guc_klvs_abi.h b/drivers/gpu/drm/xe/abi/guc_klvs_abi.h
index d633f1c739e43..7de8f827281fc 100644
--- a/drivers/gpu/drm/xe/abi/guc_klvs_abi.h
+++ b/drivers/gpu/drm/xe/abi/guc_klvs_abi.h
@@ -367,6 +367,7 @@ enum xe_guc_klv_ids {
 	GUC_WA_KLV_NP_RD_WRITE_TO_CLEAR_RCSM_AT_CGP_LATE_RESTORE			= 0x9008,
 	GUC_WORKAROUND_KLV_ID_BACK_TO_BACK_RCS_ENGINE_RESET				= 0x9009,
 	GUC_WA_KLV_WAKE_POWER_DOMAINS_FOR_OUTBOUND_MMIO					= 0x900a,
+	GUC_WA_KLV_RESET_BB_STACK_PTR_ON_VF_SWITCH					= 0x900b,
 };
 
 #endif
diff --git a/drivers/gpu/drm/xe/xe_guc_ads.c b/drivers/gpu/drm/xe/xe_guc_ads.c
index 7031542a70ceb..1fccdef9e532e 100644
--- a/drivers/gpu/drm/xe/xe_guc_ads.c
+++ b/drivers/gpu/drm/xe/xe_guc_ads.c
@@ -376,6 +376,11 @@ static void guc_waklv_init(struct xe_guc_ads *ads)
 					GUC_WORKAROUND_KLV_ID_BACK_TO_BACK_RCS_ENGINE_RESET,
 					&offset, &remain);
 
+	if (GUC_FIRMWARE_VER(&gt->uc.guc) >= MAKE_GUC_VER(70, 44, 0) && XE_WA(gt, 16026508708))
+		guc_waklv_enable_simple(ads,
+					GUC_WA_KLV_RESET_BB_STACK_PTR_ON_VF_SWITCH,
+					&offset, &remain);
+
 	size = guc_ads_waklv_size(ads) - remain;
 	if (!size)
 		return;
diff --git a/drivers/gpu/drm/xe/xe_wa_oob.rules b/drivers/gpu/drm/xe/xe_wa_oob.rules
index 9b9e176992a83..9efc5accd43d1 100644
--- a/drivers/gpu/drm/xe/xe_wa_oob.rules
+++ b/drivers/gpu/drm/xe/xe_wa_oob.rules
@@ -57,3 +57,5 @@ no_media_l3	MEDIA_VERSION(3000)
 		GRAPHICS_VERSION(1260), GRAPHICS_STEP(A0, B0)
 16023105232	GRAPHICS_VERSION_RANGE(2001, 3001)
 		MEDIA_VERSION_RANGE(1301, 3000)
+16026508708	GRAPHICS_VERSION_RANGE(1200, 3001)
+		MEDIA_VERSION_RANGE(1300, 3000)
-- 
2.39.5



