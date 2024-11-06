Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548D01DFE27;
	Wed,  6 Nov 2024 12:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896534; cv=none; b=FJEfEHjH7cjGzP0j2ngUoWpMU7G1vYHieIvVmzTp89G+lQy8Y3kS1DT7+CPwukYPqh5AWMXls+0SGWvFR0t1LY9Jj7U8gWV4kkVbAEJbYlE0haAzNGXPcnrvIe2MufwiYSxcdw+Ktyq0rOCGSPtif6mpM8nBTaia7hM8qtYjeM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896534; c=relaxed/simple;
	bh=IUtj5XcgFuCZSOMnk1tjhNtNDI9HC5U55Kj01M2H3js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kll98d2Brta+gaVlDy2NiCezQx+3Thfesenqdp5ZAdmliidO1r2z/gw5qpNI1N5scusGXDCRIyhrG/ILdrlMZoLzAIHsry/u1ZDUcVOWbYAQhhABn1Gj7YK8jHNHrkJ+9xNGBcexasSoNKl4qKm+WNy5efcnbWJ5/RENvofUVpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pM/ZyubK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pM/ZyubK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE67C4CED7;
	Wed,  6 Nov 2024 12:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896534;
	bh=IUtj5XcgFuCZSOMnk1tjhNtNDI9HC5U55Kj01M2H3js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pM/ZyubKiRa/242j7WUoDRQ1XCgloCTI//Fnx2Be/RBwQus5CJpjRF3Plg9vJxtqr
	 UIGH3h9W4o6+jdVnl/lwbcHdKdeinK+TtdCfL7wuimUyztbENU8r+4PuokBxcJlIhj
	 FqXw2XhL9Ny81Sf83JWO22rIM2C+IDH4wuebUbpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 233/245] drm/i915/display: Dont enable decompression on Xe2 with Tile4
Date: Wed,  6 Nov 2024 13:04:46 +0100
Message-ID: <20241106120324.998510651@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>

commit 4cce34b3835b6f7dc52ee2da95c96b6364bb72e5 upstream.

>>From now on expect Tile4 not to be using compression

Signed-off-by: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240816115229.531671-2-juhapekka.heikkila@gmail.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/skl_universal_plane.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/gpu/drm/i915/display/skl_universal_plane.c
+++ b/drivers/gpu/drm/i915/display/skl_universal_plane.c
@@ -1085,11 +1085,6 @@ static u32 skl_plane_ctl(const struct in
 	if (DISPLAY_VER(dev_priv) == 13)
 		plane_ctl |= adlp_plane_ctl_arb_slots(plane_state);
 
-	if (GRAPHICS_VER(dev_priv) >= 20 &&
-	    fb->modifier == I915_FORMAT_MOD_4_TILED) {
-		plane_ctl |= PLANE_CTL_RENDER_DECOMPRESSION_ENABLE;
-	}
-
 	return plane_ctl;
 }
 


