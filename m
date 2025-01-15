Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFBF248BBD;
	Wed, 15 Jan 2025 10:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938168; cv=none; b=XS/eUdklhFGS7OpfW4C++6uXaUnKIjFoCcBtE5s/Fiswh4ALqkJATDlZH5w9nXpF2QPqWETDermtb17jeIjdvTnzf41bz+bF/fwbR7lmyvXTB6x1fQdzdPS9HIiXsydB0hld2Y5l9oVwsrMAil2Xmt7xN3ObVRv9uahnAypXEsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938168; c=relaxed/simple;
	bh=yuC9lPRUEw3U4c1M++U8YqHLZ36i0vBKwcH8WmtqX04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvYMunHFUt37APQU0gz8XMkQmByJXGySrw6wd21bn1U2KIbWpxmw1+u6Sbyz7x6ehiwsa0GpzWSTh9c8z8SB6peKKNdzNV1jiv1EZubsQ7r0FyQs3buCXYz8BHEmc+FKz0X9C3CAG131cP2lCYFvLXIEQF+SK2BeFxiHlEdTbBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tyhE+2JU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tyhE+2JU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2EEC4CEDF;
	Wed, 15 Jan 2025 10:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938168;
	bh=yuC9lPRUEw3U4c1M++U8YqHLZ36i0vBKwcH8WmtqX04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tyhE+2JUkpKX/LM6uvKpl0/E3nXB65rNo99vRa7+5iTGeOUaxE5nddSh4fHs8Jhi/
	 4rqKkhy1A/02GWQw5jj0C2ZO6jMA5dyjY62xQmB8nQCvFVkjbvKxnVOrsP3WHYOW6i
	 SUbHheWFs37ehLzIoUFR5ZMN08glfNBCboCZd7Es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Alex Hung <alex.hung@amd.com>
Subject: [PATCH 6.12 104/189] drm/amd/display: Remove unnecessary amdgpu_irq_get/put
Date: Wed, 15 Jan 2025 11:36:40 +0100
Message-ID: <20250115103610.597089506@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

commit 5009628d8509dbb90e1b88e01eda00430fa24b4b upstream.

[WHY & HOW]
commit 7fb363c57522 ("drm/amd/display: Let drm_crtc_vblank_on/off manage interrupts")
lets drm_crtc_vblank_* to manage interrupts in amdgpu_dm_crtc_set_vblank,
and amdgpu_irq_get/put do not need to be called here.  Part of that
patch got lost somehow, so fix it up.

Fixes: 7fb363c57522 ("drm/amd/display: Let drm_crtc_vblank_on/off manage interrupts")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3782305ce5807c18fbf092124b9e8303cf1723ae)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   31 ----------------------
 1 file changed, 31 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8393,16 +8393,6 @@ static void manage_dm_interrupts(struct
 				 struct amdgpu_crtc *acrtc,
 				 struct dm_crtc_state *acrtc_state)
 {
-	/*
-	 * We have no guarantee that the frontend index maps to the same
-	 * backend index - some even map to more than one.
-	 *
-	 * TODO: Use a different interrupt or check DC itself for the mapping.
-	 */
-	int irq_type =
-		amdgpu_display_crtc_idx_to_irq_type(
-			adev,
-			acrtc->crtc_id);
 	struct drm_vblank_crtc_config config = {0};
 	struct dc_crtc_timing *timing;
 	int offdelay;
@@ -8428,28 +8418,7 @@ static void manage_dm_interrupts(struct
 
 		drm_crtc_vblank_on_config(&acrtc->base,
 					  &config);
-
-		amdgpu_irq_get(
-			adev,
-			&adev->pageflip_irq,
-			irq_type);
-#if defined(CONFIG_DRM_AMD_SECURE_DISPLAY)
-		amdgpu_irq_get(
-			adev,
-			&adev->vline0_irq,
-			irq_type);
-#endif
 	} else {
-#if defined(CONFIG_DRM_AMD_SECURE_DISPLAY)
-		amdgpu_irq_put(
-			adev,
-			&adev->vline0_irq,
-			irq_type);
-#endif
-		amdgpu_irq_put(
-			adev,
-			&adev->pageflip_irq,
-			irq_type);
 		drm_crtc_vblank_off(&acrtc->base);
 	}
 }


