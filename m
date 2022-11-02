Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11647E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4423C433C1;
	Wed,  2 Nov 2022 02:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357548;
	bh=4eMOYVj/hw8QO0cj2EawLvH34UX1IxtChndlLS8Qh4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwtBU0DcZdsaUD+soePO0J26OaRneiino+Op1x96jS6E+afq3RflP8EKI0xDqMx1U
	 MorfSaYBFrOz1Vb87z6WaEm+iGDsFSSn84LHy7RcNTRNeHYbtBbqSmkDjUQ4OvG83X
	 wCKKaeUA330zCEQ3EKNJqf8K89PXJni6MAlhBrYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Swati Sharma <swati2.sharma@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Uma Shankar <uma.shankar@intel.com>
Subject: [PATCH 6.0 181/240] drm/i915/dp: Reset frl trained flag before restarting FRL training
Date: Wed,  2 Nov 2022 03:32:36 +0100
Message-Id: <20221102022115.480922794@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ankit Nautiyal <ankit.k.nautiyal@intel.com>

[ Upstream commit 63720a561b3c98199adf0c73e152807f15cc3b7f ]

For cases where DP has HDMI2.1 sink and FRL Link issues are detected,
reset the flag to state FRL trained status before restarting FRL
training.

Fixes: 9488a030ac91 ("drm/i915: Add support for enabling link status and recovery")
Cc: Swati Sharma <swati2.sharma@intel.com>
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Cc: Uma Shankar <uma.shankar@intel.com> (v2)
Cc: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221011063447.904649-2-ankit.k.nautiyal@intel.com
(cherry picked from commit 47e1a59e60c688c5f95b67277202f05b7e84c189)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 3ed7eeacc706..d4492b6d23d2 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -3923,6 +3923,8 @@ intel_dp_handle_hdmi_link_status_change(struct intel_dp *intel_dp)
 
 		drm_dp_pcon_hdmi_frl_link_error_count(&intel_dp->aux, &intel_dp->attached_connector->base);
 
+		intel_dp->frl.is_trained = false;
+
 		/* Restart FRL training or fall back to TMDS mode */
 		intel_dp_check_frl_training(intel_dp);
 	}
-- 
2.35.1



