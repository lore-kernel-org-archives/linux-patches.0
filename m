Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A7D5237A3;
	Thu, 17 Sep 2026 15:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658958; cv=none; b=C/NWA5zaqbS3kdC0PHn2jfPu0quYAYmB+kSFvLX4X0CWlt29KbcG8+WT+iauhluXLiLrOlBBpSfpY5EFQPAUQFaPsVW+MdupiZ/zCbOyfv6L/hdbQOBlWKh813eXgs/juHpuyETqjIwIrz5W9XuIb9MptuzMXcnkoJXG5N5pMgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658958; c=relaxed/simple;
	bh=myhLJGGpuVtb425HqEvRB4QhTu7fAwnnXIYcZJWWBsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pss9LwMhthB4FTJ3M8QVHyfEsFhkJYwiMEAa7DakZGOT7bpblsqT9CUFziuyjuZ1KN4baUyibO+HRp0QeLtUUP1pZ9BWxXAmuLZq0WmyI9XlmbBOe/1YCqIpS7TwWndsxXM4nyTyh8WX86EPsWDqrV4kHSlZ2mbYd0IamK/hWQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OPyLB18b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OPyLB18b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0671F000FF;
	Thu, 17 Sep 2026 15:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658946;
	bh=NO9TvcIjxYUTBj+VC686TcdZ2tep4G37rdR/bB1JGwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OPyLB18bAl7llfxvLERjPkkDHDKWWG0JKnnFJr4U0pjoRvG5Gy7XIpxDE8GO5IXte
	 Dl195bd9JW/oQpNbxbeYLFz21NPmdpcEHTzJl4N/hUo5Yk90dBuxN7oSyWWNdI7BeX
	 94OZs1Mg76h10CUy9NgyWUEJSc7lz++Gw+ZqYpOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 093/733] drm/i915/cdclk: Fix dg2_power_well_count() return type
Date: Thu, 17 Sep 2026 16:06:41 +0100
Message-ID: <20260917151353.247506987@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit a154f2ae8eecbf2a4f97376d29b8d38c198b54e7 ]

dg2_power_well_count() is supposed to return an integer,
not a boolean. Make it so.

Fixes: 9112ce99c1d7 ("drm/i915/cdclk: Extract dg2_power_well_count()")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patch.msgid.link/20260826143100.19401-1-ville.syrjala@linux.intel.com
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit dcf423710d0253d7d729c3992bbae0c6197c9c22)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_cdclk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_cdclk.c b/drivers/gpu/drm/i915/display/intel_cdclk.c
index 7bc9b956554ba..44a6503b2be73 100644
--- a/drivers/gpu/drm/i915/display/intel_cdclk.c
+++ b/drivers/gpu/drm/i915/display/intel_cdclk.c
@@ -2697,8 +2697,8 @@ static void intel_set_cdclk(struct intel_display *display,
 	}
 }
 
-static bool dg2_power_well_count(struct intel_display *display,
-				 const struct intel_cdclk_state *cdclk_state)
+static int dg2_power_well_count(struct intel_display *display,
+				const struct intel_cdclk_state *cdclk_state)
 {
 	return display->platform.dg2 ? hweight8(cdclk_state->active_pipes) : 0;
 }
-- 
2.53.0



