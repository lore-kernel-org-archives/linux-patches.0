Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3503720F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:19:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACC3C433C8;
	Fri, 21 Jul 2023 19:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967196;
	bh=68pEZ1pTZPxaWtW5D943iOjbqWyyYL4ghyQKxgZ/3DU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MqIoouKbxI+5TnukwvSsA+9Kt1bQiyU8JcVup8Dk9KaPSdmSOXElae5AjVIZ8Otf6
	 Y+9tmTa7EO3bcQfsRNWfmBgOyHBgLZZ64uWWuSdiw2AUWFDR+LChJUeseQYs6Y485/
	 gwGzs4Wef3t+rF6TsFGLS2U8Kn+0nANnqI98SVD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/223] drm/i915: Dont preserve dpll_hw_state for slave crtc in Bigjoiner
Date: Fri, 21 Jul 2023 18:05:02 +0200
Message-ID: <20230721160522.948965763@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>

[ Upstream commit 5c413188c68da0e4bffc93de1c80257e20741e69 ]

If we are using Bigjoiner dpll_hw_state is supposed to be exactly
same as for master crtc, so no need to save it's state for slave crtc.

Signed-off-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Fixes: 0ff0e219d9b8 ("drm/i915: Compute clocks earlier")
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230628141017.18937-1-stanislav.lisovskiy@intel.com
(cherry picked from commit cbaf758809952c95ec00e796695049babb08bb60)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_display.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 455d9ae6c41c9..da9b995b54c8f 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -5133,7 +5133,6 @@ copy_bigjoiner_crtc_state_modeset(struct intel_atomic_state *state,
 	saved_state->uapi = slave_crtc_state->uapi;
 	saved_state->scaler_state = slave_crtc_state->scaler_state;
 	saved_state->shared_dpll = slave_crtc_state->shared_dpll;
-	saved_state->dpll_hw_state = slave_crtc_state->dpll_hw_state;
 	saved_state->crc_enabled = slave_crtc_state->crc_enabled;
 
 	intel_crtc_free_hw_state(slave_crtc_state);
-- 
2.39.2



