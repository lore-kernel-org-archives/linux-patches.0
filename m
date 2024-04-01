Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E29C129;
	Mon,  1 Apr 2024 16:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988921; cv=none; b=BGZqjbthJ81XH/7E0UqeZgdhqia27EfL82XZZweKHvMEFRg1suZI6xSHySURO9lVLWDGV6wznBSQYS0rPJ7qGw1N60s/A9GOzr5fRK2qpGh7Zv+gB4hjhmRvIeF0z1uoNWICC+jfgza9eOR/CFYkz1hB3h9/Fh7qkaSuTacKj4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988921; c=relaxed/simple;
	bh=uS+/yUye4EVZ7QhdPkgoLZwsCzzqnzkBtxx6/rzJ6Rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U46Ve81VjAdJu7viIEUkn1yaCm4R9TlBnYTl3ZefZmwXpmuS/zmAQAQOdkSQbti3El7uX4TzfHKVmRKJx72jf0xjsh79Fq7HhwGmvacZ8a0B6CKmPkJq+9PT/pel21CWcL9vSWodJ1rZvsilz+etULi5esaRijJJbJNrpPx1QaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFT2D71B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFT2D71B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C86C433C7;
	Mon,  1 Apr 2024 16:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988921;
	bh=uS+/yUye4EVZ7QhdPkgoLZwsCzzqnzkBtxx6/rzJ6Rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFT2D71BOUsb1TZXWgHQHEZW7Fhdu9f5xPyDf0GV4np7ge1K461wYjjpFOA1y7XxM
	 4gf0Ongkx9RZGpgLDXUIBvAtU+0b8KNUzrQiyfmHW0D2LgWZP2YE45CMMmmVQ0kXGK
	 Qvazp32RtjEmBJwqvP/QGAvMigjjUnne3P9zW+nE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.7 329/432] drm/i915: Include the PLL name in the debug messages
Date: Mon,  1 Apr 2024 17:45:16 +0200
Message-ID: <20240401152603.026731094@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit d283ee5662c6bf2f3771a36b926f6988e6dddfc6 upstream.

Make the log easier to parse by including the name of the PLL
in the debug prints regarding said PLL.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240123093137.9133-1-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dpll_mgr.c |   39 +++++++++++++-------------
 1 file changed, 20 insertions(+), 19 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
+++ b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
@@ -4476,25 +4476,25 @@ verify_single_dpll_state(struct drm_i915
 	u8 pipe_mask;
 	bool active;
 
-	drm_dbg_kms(&i915->drm, "%s\n", pll->info->name);
-
 	active = intel_dpll_get_hw_state(i915, pll, &dpll_hw_state);
 
 	if (!(pll->info->flags & INTEL_DPLL_ALWAYS_ON)) {
 		I915_STATE_WARN(i915, !pll->on && pll->active_mask,
-				"pll in active use but not on in sw tracking\n");
+				"%s: pll in active use but not on in sw tracking\n",
+				pll->info->name);
 		I915_STATE_WARN(i915, pll->on && !pll->active_mask,
-				"pll is on but not used by any active pipe\n");
+				"%s: pll is on but not used by any active pipe\n",
+				pll->info->name);
 		I915_STATE_WARN(i915, pll->on != active,
-				"pll on state mismatch (expected %i, found %i)\n",
-				pll->on, active);
+				"%s: pll on state mismatch (expected %i, found %i)\n",
+				pll->info->name, pll->on, active);
 	}
 
 	if (!crtc) {
 		I915_STATE_WARN(i915,
 				pll->active_mask & ~pll->state.pipe_mask,
-				"more active pll users than references: 0x%x vs 0x%x\n",
-				pll->active_mask, pll->state.pipe_mask);
+				"%s: more active pll users than references: 0x%x vs 0x%x\n",
+				pll->info->name, pll->active_mask, pll->state.pipe_mask);
 
 		return;
 	}
@@ -4503,21 +4503,22 @@ verify_single_dpll_state(struct drm_i915
 
 	if (new_crtc_state->hw.active)
 		I915_STATE_WARN(i915, !(pll->active_mask & pipe_mask),
-				"pll active mismatch (expected pipe %c in active mask 0x%x)\n",
-				pipe_name(crtc->pipe), pll->active_mask);
+				"%s: pll active mismatch (expected pipe %c in active mask 0x%x)\n",
+				pll->info->name, pipe_name(crtc->pipe), pll->active_mask);
 	else
 		I915_STATE_WARN(i915, pll->active_mask & pipe_mask,
-				"pll active mismatch (didn't expect pipe %c in active mask 0x%x)\n",
-				pipe_name(crtc->pipe), pll->active_mask);
+				"%s: pll active mismatch (didn't expect pipe %c in active mask 0x%x)\n",
+				pll->info->name, pipe_name(crtc->pipe), pll->active_mask);
 
 	I915_STATE_WARN(i915, !(pll->state.pipe_mask & pipe_mask),
-			"pll enabled crtcs mismatch (expected 0x%x in 0x%x)\n",
-			pipe_mask, pll->state.pipe_mask);
+			"%s: pll enabled crtcs mismatch (expected 0x%x in 0x%x)\n",
+			pll->info->name, pipe_mask, pll->state.pipe_mask);
 
 	I915_STATE_WARN(i915,
 			pll->on && memcmp(&pll->state.hw_state, &dpll_hw_state,
 					  sizeof(dpll_hw_state)),
-			"pll hw state mismatch\n");
+			"%s: pll hw state mismatch\n",
+			pll->info->name);
 }
 
 void intel_shared_dpll_state_verify(struct intel_atomic_state *state,
@@ -4539,11 +4540,11 @@ void intel_shared_dpll_state_verify(stru
 		struct intel_shared_dpll *pll = old_crtc_state->shared_dpll;
 
 		I915_STATE_WARN(i915, pll->active_mask & pipe_mask,
-				"pll active mismatch (didn't expect pipe %c in active mask (0x%x))\n",
-				pipe_name(crtc->pipe), pll->active_mask);
+				"%s: pll active mismatch (didn't expect pipe %c in active mask (0x%x))\n",
+				pll->info->name, pipe_name(crtc->pipe), pll->active_mask);
 		I915_STATE_WARN(i915, pll->state.pipe_mask & pipe_mask,
-				"pll enabled crtcs mismatch (found pipe %c in enabled mask (0x%x))\n",
-				pipe_name(crtc->pipe), pll->state.pipe_mask);
+				"%s: pll enabled crtcs mismatch (found pipe %c in enabled mask (0x%x))\n",
+				pll->info->name, pipe_name(crtc->pipe), pll->state.pipe_mask);
 	}
 }
 


