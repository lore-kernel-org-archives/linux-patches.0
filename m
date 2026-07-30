Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B156C43F4BC;
	Thu, 30 Jul 2026 14:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421811; cv=none; b=asGs1KOcAnGaDczcyle4QWNZ/4jy3vHvoOT3WD0k24jD6ispb+05XVhdes/85WoK6HkG/sFBM7CRBRYu66l/C3E/XauWK9DA8nCBYqn6a4i6laBO9GAA7ROiPVvl9yJUJvWlco5dJjsaMPwhv93ATcNUCVVVX/xZoMxoVHaVAGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421811; c=relaxed/simple;
	bh=TTm4iJPgFOfMV0WTJ0gJx3iBVrnoLSGhS+hcSH58PUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qzlZvQXDWhzLI0F4HE249slxRRFW0sfTuk70RWXopwzE/xa7Jv9r6KnQNRuINSr6wjnCAZfrMGIl1aOHMYZRhOIZfR3ccXFn370AKumg+kTHqLwnREyPDTy0MzQZxIEzAIfRtU1xD/t5vp2QEUUvBdH2SbgbBZtVe4fjsDkNFbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVPhhwFb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVPhhwFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AC51F000E9;
	Thu, 30 Jul 2026 14:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421810;
	bh=ecj9Klkx1HvmLw89J+9Bv5PlSNqderWoKd5GejjRFro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VVPhhwFbWSqrPAsCEojUPUKDLjTAV0kQZWPM7BlsXZkPVfVDqmEP90bgjaxlx2D+x
	 I9LETM61ILTKccBeF84xzqm2iY4PmxhfNr6OBhkRMYXL17c5RpsFN8pBzNzo+GK8vi
	 Z7L8xqLoW6+1gLvvO1Lm1hReSN0qoq/m2o4DS70Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Grzelak?= <michal.grzelak@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 221/744] drm/i915/backlight: Remove DP_EDP_BACKLIGHT_AUX_ENABLE_CAP check for DPCD backlight
Date: Thu, 30 Jul 2026 16:08:14 +0200
Message-ID: <20260730141448.980760670@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suraj Kandpal <suraj.kandpal@intel.com>

[ Upstream commit a411ea4a87162898d2a0547fdfb721ddb7626be3 ]

Turns out some panels allow only AUX based backlight
by just setting the DP_EDP_BACKLIGHT_BRIGHTNESS_AUX_SET_CAP and
not setting the DP_EDP_BACKLIGHT_AUX_ENABLE_CAP.
If we make DP_EDP_BACKLIGHT_AUX_ENABLE_CAP a necessity for AUX
based DPCD backlight these panels loose the ability to manipulate
backlight via AUX, especially ones with no PWM controller.
Remove this check from function so that panels who do not advertise
DP_EDP_BACKLIGHT_AUX_ENABLE_CAP but advertise
DP_EDP_BACKLIGHT_BRIGHTNESS_AUX_SET_CAP are able to manipulate
backlight again.

Fixes: ed8be780bdbc ("drm/i915/backlight: Fix VESA backlight possible check condition")
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/work_items/16507
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Michał Grzelak <michal.grzelak@intel.com>
Link: https://patch.msgid.link/20260716030959.436430-1-suraj.kandpal@intel.com
(cherry picked from commit 7d594b24c915afb4b0c5fb8875403253daef5b24)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c b/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
index 7a6c07f6aaeb4b..266e042e00237c 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c
@@ -615,12 +615,7 @@ check_if_vesa_backlight_possible(struct intel_dp *intel_dp)
 	int ret;
 	u8 bit_min, bit_max;
 
-	/*
-	 * Since we only support Fully AUX Based VESA Backlight interface make sure
-	 * backlight enable is possible via AUX along with backlight adjustment
-	 */
-	if (!(intel_dp->edp_dpcd[1] & DP_EDP_BACKLIGHT_AUX_ENABLE_CAP &&
-	      intel_dp->edp_dpcd[2] & DP_EDP_BACKLIGHT_BRIGHTNESS_AUX_SET_CAP))
+	if (!(intel_dp->edp_dpcd[2] & DP_EDP_BACKLIGHT_BRIGHTNESS_AUX_SET_CAP))
 		return false;
 
 	ret = drm_dp_dpcd_read_byte(&intel_dp->aux, DP_EDP_PWMGEN_BIT_COUNT_CAP_MIN, &bit_min);
-- 
2.53.0



