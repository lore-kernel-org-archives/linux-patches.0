Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DE462148;
	Mon,  8 Apr 2024 13:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582358; cv=none; b=mIHU8b/vwUhgy0Q06waHlQ8aJYHk5QwdjHQQli71HieBWcXFlUws4s8ye7A7BjtmQ371Jfc6COwaaHrUCZkJC42DTaGOwSViGXla8YZi1aphQtBeJc3DBlXDdnS9Qjg6p9nEPUWw1EqzKXBkWRiCtYLNu4c8Jg1T1ggYkp305E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582358; c=relaxed/simple;
	bh=1+BYkAjRX/xVWZfPaCBn6fAEoMKRfBdSwrGlVykpMZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TbzLEaydonQm9BI4cwUC3FwEavQqy5s4o+WToONPQJSgM7wzfIj3IF9JBYeTwFpz+7d8LpWAcx3JmNjWYLhABT7kRxsmT1HAjowumjOg7QGgHNDCsJN9njnJOIvGCYah/qXDEGHzAPmntTu1CzoV5WSVkGjP6UnmPpcDIIV3Tw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nt65xDo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nt65xDo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF64C433C7;
	Mon,  8 Apr 2024 13:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582357;
	bh=1+BYkAjRX/xVWZfPaCBn6fAEoMKRfBdSwrGlVykpMZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nt65xDo0/TWCkVEVKNYffPnDNXdJ3emZrt5bGBwRTFN0O9lkgDDxl+aYxMLyO9SMd
	 LeDMEBTV2/sP3djLQ9Gv6z3Tx2kzxwcemBJq8fZ7wuasE9T3/zHyMHIiN1K+X6D1No
	 yBowFc1HtYzyPhowq3V24JgoaFzy8IoSQ0JQwfH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>,
	=?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 054/273] drm/i915/display: Disable AuxCCS framebuffers if built for Xe
Date: Mon,  8 Apr 2024 14:55:29 +0200
Message-ID: <20240408125310.981064634@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>

[ Upstream commit cf48bddd31deefb9ab07de9a4d0150da6610198a ]

AuxCCS framebuffers don't work on Xe driver hence disable them
from plane capabilities until they are fixed. FlatCCS framebuffers
work and they are left enabled. CCS is left untouched for i915
driver.

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/933
Signed-off-by: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Tested-by: José Roberto de Souza <jose.souza@intel.com>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Fixes: 44e694958b95 ("drm/xe/display: Implement display support")
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240228140225.858145-1-juhapekka.heikkila@gmail.com
(cherry picked from commit b7232a730fbf043f54fb46fbf4a6e92936770e79)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/skl_universal_plane.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/skl_universal_plane.c b/drivers/gpu/drm/i915/display/skl_universal_plane.c
index 511dc1544854f..8bba6c2e50989 100644
--- a/drivers/gpu/drm/i915/display/skl_universal_plane.c
+++ b/drivers/gpu/drm/i915/display/skl_universal_plane.c
@@ -2290,6 +2290,9 @@ static u8 skl_get_plane_caps(struct drm_i915_private *i915,
 	if (HAS_4TILE(i915))
 		caps |= INTEL_PLANE_CAP_TILING_4;
 
+	if (!IS_ENABLED(I915) && !HAS_FLAT_CCS(i915))
+		return caps;
+
 	if (skl_plane_has_rc_ccs(i915, pipe, plane_id)) {
 		caps |= INTEL_PLANE_CAP_CCS_RC;
 		if (DISPLAY_VER(i915) >= 12)
-- 
2.43.0



