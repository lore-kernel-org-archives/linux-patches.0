Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D3A85274;
	Tue, 23 Apr 2024 21:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908570; cv=none; b=esUvN5NHKVmWd9KG4dfcAUpnC4Tv7pqbL1ekA5d1acxY8uwiZ45aT3ulK+Moxm/a0KEUusrrWicdqI3kDqDOva72wGaNAsOBTIY0Quc3vyZuEXy6q39A+9XTlhYLFSXQ/tZPHDP59gd9utfKFF/YiWTj5tyfaTaRc1HFHN8uO50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908570; c=relaxed/simple;
	bh=HmyfBRrYOEEA/ex9BCHDIjv5uFnGre5tmX3yqO00Ep8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sEaea9SM3kZFEySuHgZedYosX4SvZOTHJseGUEUY53AFoqfKCZISCZEHHLx9pOE7YjKlqqQiFXHXzW/Ley0TKf4cTJe5KfvaZ0zv8E03bw9f3i6jlTdpQ+Sof6oaE1Asq8x7eLOj1IQDqi0jyjBf3ZBvy9bySq4wlClQWyCk/+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLHSOMAc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLHSOMAc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9290DC32782;
	Tue, 23 Apr 2024 21:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908570;
	bh=HmyfBRrYOEEA/ex9BCHDIjv5uFnGre5tmX3yqO00Ep8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xLHSOMAcLl+5lavtB/PaUgaDmvH57VzA/0CQqx/dYZqX/vs2qnuWn9Ic1bfEx0uaK
	 NS40yrTyziurt9EaRRqW0NOZm+TRHKh+XDG+79PKS1JqAfa2i8bDGfra/iCfLV7L2S
	 GG6OTtJmS1wyOBxosVhD3sN1PTXhp3e9E222WoNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uma Shankar <uma.shankar@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/158] drm/i915/mst: Reject FEC+MST on ICL
Date: Tue, 23 Apr 2024 14:37:24 -0700
Message-ID: <20240423213855.936087997@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 99f855082f228cdcecd6ab768d3b8b505e0eb028 ]

ICL supposedly doesn't support FEC on MST. Reject it.

Cc: stable@vger.kernel.org
Fixes: d51f25eb479a ("drm/i915: Add DSC support to MST path")
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240402135148.23011-7-ville.syrjala@linux.intel.com
(cherry picked from commit b648ce2a28ba83c4fa67c61fcc5983e15e9d4afb)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index fff008955cb2c..d712cb9b81e1e 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -1316,7 +1316,8 @@ static bool intel_dp_source_supports_fec(struct intel_dp *intel_dp,
 	if (DISPLAY_VER(dev_priv) >= 12)
 		return true;
 
-	if (DISPLAY_VER(dev_priv) == 11 && encoder->port != PORT_A)
+	if (DISPLAY_VER(dev_priv) == 11 && encoder->port != PORT_A &&
+	    !intel_crtc_has_type(pipe_config, INTEL_OUTPUT_DP_MST))
 		return true;
 
 	return false;
-- 
2.43.0



