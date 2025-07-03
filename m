Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC832D6622;
	Thu,  3 Jul 2025 15:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555308; cv=none; b=VXcqq6P9UzDhR2eogTbjujZPGh/2/ZZVMb+BHAsZYPxA1yzTEKOqDkdBweFx/VjR/ephW1k2vG2jKkerSbegK2RNN0C+RrSdv/FDF6srIIOA8jWHEvqeyvpuwnfOTLyWHxoihZu9Lxc5Wr58KtGCJFxiqh4YT3t6hoOoxP0rwoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555308; c=relaxed/simple;
	bh=trsU+wI57Bo7wBal9hYM4aqvoIxRfjbKImfyUwvGyX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMEla0dPl1zX5E1TFL//IOalnCqZ+mK4eP8O+FY3rexzxTj1oq4OwEpqnb4Ug0/P0QiIkC9xn3OhrIeyfeQG5xKDNNIQPFEyG7erG9B14SadYzItwWaCms978OD1ZPRlAiICxxeyNClwaaY3VKjDwId9bfndfLJxz1jsBgLKQQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iiiITPgf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iiiITPgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7B0C4CEE3;
	Thu,  3 Jul 2025 15:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555308;
	bh=trsU+wI57Bo7wBal9hYM4aqvoIxRfjbKImfyUwvGyX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iiiITPgffiOnX+ohB5j3iwatfFGZ1ARYCN+NGj4dJa66HAyvZASZT2JFacU4+Wwfk
	 D7ehi0uW/W5Q0vjizJrEOHtUiBG3r/VdAax6zZI7wvMcud3eK08BGcFlqrfyb7/E6R
	 RlBw2UjeVyHMLEUeFXO0KP+xjnAmeibo1/y/y6VA=
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
Subject: [PATCH 6.15 239/263] drm/amd/display: Fix mpv playback corruption on weston
Date: Thu,  3 Jul 2025 16:42:39 +0200
Message-ID: <20250703144013.992886309@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -785,6 +785,7 @@ static void populate_dml21_plane_config_
 		plane->pixel_format = dml2_420_10;
 		break;
 	case SURFACE_PIXEL_FORMAT_GRPH_ARGB16161616:
+	case SURFACE_PIXEL_FORMAT_GRPH_ABGR16161616:
 	case SURFACE_PIXEL_FORMAT_GRPH_ARGB16161616F:
 	case SURFACE_PIXEL_FORMAT_GRPH_ABGR16161616F:
 		plane->pixel_format = dml2_444_64;
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
@@ -953,6 +953,7 @@ static void populate_dml_surface_cfg_fro
 		out->SourcePixelFormat[location] = dml_420_10;
 		break;
 	case SURFACE_PIXEL_FORMAT_GRPH_ARGB16161616:
+	case SURFACE_PIXEL_FORMAT_GRPH_ABGR16161616:
 	case SURFACE_PIXEL_FORMAT_GRPH_ARGB16161616F:
 	case SURFACE_PIXEL_FORMAT_GRPH_ABGR16161616F:
 		out->SourcePixelFormat[location] = dml_444_64;


