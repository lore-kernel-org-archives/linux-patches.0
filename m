Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F28357A29;
	Tue, 16 Dec 2025 12:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886587; cv=none; b=UqsD+b1SYSXWihbIRT4u3lkVpXj1xDjJG5K5ygZww2ii6qxd49MoWP9/bUHLhP8d1NKgOUnqSi1uo/3lk2PNgd7oorQgqpQB+miLkm1WRVMvPIk/vVVzw6oq+4W/818ClfavFe0lgmes293fjHLc7ubHm5G23/7KWahsi7i9bvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886587; c=relaxed/simple;
	bh=FXVh8cHOicl4Gik0NeMaSNhxQF+S6EhMn4RVN5HLJvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R+qHNFqdw9TZJfnQsGpdRpchhU6xGYdlqn80rfEIrkw0PcUUFtR2V8Ir7Yi9EPPGOf0n7ryl1TmPhH6UKYSiZp8sRlKNSoNfzNLKt8Y1vTHqvx6dXLYO+hW+osWOJ25eNZtcDaxXIK78CbUzVkdeVjJuJCUgGDGQRZPbJYicR5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oo+aSVuc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oo+aSVuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D4AC4CEF5;
	Tue, 16 Dec 2025 12:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886586;
	bh=FXVh8cHOicl4Gik0NeMaSNhxQF+S6EhMn4RVN5HLJvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oo+aSVuc2DjN8O1dhmOrot4RoqwjHDxHUp6771fISKyw/sZBq7kGIb2YFyBLHZi6O
	 BQIuHOjUf4UCUVt8LafpZJkicCOeMsRVfkAQEk32TJEp0YtTM+hIs193TAuB43QuTN
	 O2SXHJjP3nx1VCtNlh/cK35hFB+nVfcsNFPqVfGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 480/507] drm/xe/fbdev: use the same 64-byte stride alignment as i915
Date: Tue, 16 Dec 2025 12:15:21 +0100
Message-ID: <20251216111402.832458513@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 4a36b339a14ae6f2a366125e3d64f0c165193293 ]

For reasons unknown, xe uses XE_PAGE_SIZE alignment for
stride. Presumably it's just a confusion between stride alignment and bo
allocation size alignment. Switch to 64 byte alignment to, uh, align
with i915.

This will also be helpful in deduplicating and unifying the xe and i915
framebuffer allocation.

Link: https://lore.kernel.org/r/aLqsC87Ol_zCXOkN@intel.com
Suggested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://lore.kernel.org/r/7f4972104de8b179d5724ae83892ee294d3f3fd3.1758184771.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Stable-dep-of: 460b31720369 ("drm/i915/fbdev: Hold runtime PM ref during fbdev BO creation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/display/intel_fbdev_fb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/display/intel_fbdev_fb.c b/drivers/gpu/drm/xe/display/intel_fbdev_fb.c
index fba9617a75a53..37a48c6f2d531 100644
--- a/drivers/gpu/drm/xe/display/intel_fbdev_fb.c
+++ b/drivers/gpu/drm/xe/display/intel_fbdev_fb.c
@@ -33,7 +33,7 @@ struct intel_framebuffer *intel_fbdev_fb_alloc(struct drm_fb_helper *helper,
 	mode_cmd.height = sizes->surface_height;
 
 	mode_cmd.pitches[0] = ALIGN(mode_cmd.width *
-				    DIV_ROUND_UP(sizes->surface_bpp, 8), XE_PAGE_SIZE);
+				    DIV_ROUND_UP(sizes->surface_bpp, 8), 64);
 	mode_cmd.pixel_format = drm_mode_legacy_fb_format(sizes->surface_bpp,
 							  sizes->surface_depth);
 
-- 
2.51.0



