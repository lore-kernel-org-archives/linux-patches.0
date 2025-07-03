Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114EB126BFF;
	Thu,  3 Jul 2025 14:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554404; cv=none; b=Z+MQ3hTcNHDAt2raRo8DWZ6PBKz+X5zqttVhES8WTjHCUtIfK9GPWTPPD1K7cs2f3g8iVKABEsb9jx6wDoaG8Qo9z2fLHsd9DZK77qgu5YH2v8B8rcUaKBo915L+JjAaxR43I85rlFgzNEwZRg5O9XwCeDJwR9+/zcp9rSxeQRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554404; c=relaxed/simple;
	bh=1+Gd7yZsNBidR2BvOb4gWHiHgK2yQZHfao2Q40+qQ5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dUec3pFyhNOmz9NUlDIys5XKaJbLrm5XsEE2HTAPf3Xu9ufJMsNCNBUWf7F3NTL/NQXkl3uzg+JzaCsd6VgFSrzYN1wBVOwxojVgQoK3Yh9SQbJHzgttzGonu67UJETzfwoaSVUJolBTAvssxCZyFG1JsVhKvciyONekw17xPOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SVDnTzh4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SVDnTzh4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9594EC4CEE3;
	Thu,  3 Jul 2025 14:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554403;
	bh=1+Gd7yZsNBidR2BvOb4gWHiHgK2yQZHfao2Q40+qQ5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SVDnTzh4YwavL6zLGDmZS8eyw+9LkY5npnk8rLkw+ECWhlc14Txb9/L9UXvyULKUl
	 xX/Ph+NboVaVOI1uRnQ8nyfQ99EWO1QRlxyLCaEToyJgBtBzJcv5ySXPNYWjflJ+1C
	 oJpXMGF1QTmeo2MRowe6zuIrtjlzQ31EEXIuqsag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Austin Zheng <austin.zheng@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.12 176/218] drm/amd/display: Fix mpv playback corruption on weston
Date: Thu,  3 Jul 2025 16:42:04 +0200
Message-ID: <20250703144003.216713847@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

commit 8724a5380c4390eed81e271d22f34ff06453ded9 upstream.

[WHAT]
Severe video playback corruption is observed in the following setup:

weston 14.0.90 (built from source) + mpv v0.40.0 with command:
mpv bbb_sunflower_1080p_60fps_normal.mp4 --vo=gpu

[HOW]
ABGR16161616 needs to be included in dml2/2.1 translation.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Austin Zheng <austin.zheng@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d023de809f85307ca819a9dbbceee6ae1f50e2ad)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_translation_helper.c |    1 +
 drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c        |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_translation_helper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_translation_helper.c
@@ -762,6 +762,7 @@ static void populate_dml21_plane_config_
 		plane->pixel_format = dml2_420_10;
 		break;
 	case SURFACE_PIXEL_FORMAT_GRPH_ARGB16161616:
+	case SURFACE_PIXEL_FORMAT_GRPH_ABGR16161616:
 	case SURFACE_PIXEL_FORMAT_GRPH_ARGB16161616F:
 	case SURFACE_PIXEL_FORMAT_GRPH_ABGR16161616F:
 		plane->pixel_format = dml2_444_64;
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
@@ -909,6 +909,7 @@ static void populate_dml_surface_cfg_fro
 		out->SourcePixelFormat[location] = dml_420_10;
 		break;
 	case SURFACE_PIXEL_FORMAT_GRPH_ARGB16161616:
+	case SURFACE_PIXEL_FORMAT_GRPH_ABGR16161616:
 	case SURFACE_PIXEL_FORMAT_GRPH_ARGB16161616F:
 	case SURFACE_PIXEL_FORMAT_GRPH_ABGR16161616F:
 		out->SourcePixelFormat[location] = dml_444_64;


