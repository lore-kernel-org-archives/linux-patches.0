Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A16332EA3;
	Fri, 21 Nov 2025 13:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733166; cv=none; b=j9+vm4HMOFHMJxBmFdOtZjbPNmDKgTroqlk0ch+6TKeDmjWiwxWhvJYDTPkSgL4LXFK3Yord8sMMk/y5noEvuzp0lXh9wjDp/OxFIMf2tbbtpbGxfR0UDZu0nNSwsz0yT8x8UHGpOT1xt5jH5nCL1GM4DXW2/V/p1Nje9PxnnvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733166; c=relaxed/simple;
	bh=TYaVbF2xC3nsnWw8qBi5WKMxIefdaix3UDCaiSR2fOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KOWxP0xbGl0F1bU0Y4NpjowwXiP08/SC0+h1p6MAHSopN2YYyZUHNjMmYnQ8GQ53cd5gxZUlRRWEpreX3r8N4xveV+Bst5gkK8VyfKnjbZhFZzwe0xEL9JI5si2ahIZHWPgvh8fjV1uVR9fhVBIPqaSc90EkHD81W3o98g+S/f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QpiebEnw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QpiebEnw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C8EC4CEF1;
	Fri, 21 Nov 2025 13:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733166;
	bh=TYaVbF2xC3nsnWw8qBi5WKMxIefdaix3UDCaiSR2fOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QpiebEnwHgnwhYkVQZYc0a3ieZgzE0tozu0TXWWL5T5YqXu+TGc+KUXJE/Q2Ov4aJ
	 C2y7BllpOPfbG8nMV07zOALpNCPTcO6f5WGbQrMpBFQe4R5UjPHXzHmfFdLKgbH9Ug
	 NJYG82/BbfRfsysHqhZ9VMf2t5+xU8d09pwnFBoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 374/529] drm/amd/display: Fix black screen with HDMI outputs
Date: Fri, 21 Nov 2025 14:11:13 +0100
Message-ID: <20251121130244.334057832@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

commit fdc93beeadc2439e5e85d056a8fe681dcced09da upstream.

[Why & How]
This fixes the black screen issue on certain APUs with HDMI,
accompanied by the following messages:

amdgpu 0000:c4:00.0: amdgpu: [drm] Failed to setup vendor info
                     frame on connector DP-1: -22
amdgpu 0000:c4:00.0: [drm] Cannot find any crtc or sizes [drm]
                     Cannot find any crtc or sizes

Fixes: 489f0f600ce2 ("drm/amd/display: Fix DVI-D/HDMI adapters")
Suggested-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 678c901443a6d2e909e3b51331a20f9d8f84ce82)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/link/link_detection.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/dc/link/link_detection.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_detection.c
@@ -1114,6 +1114,7 @@ static bool detect_link_and_local_sink(s
 		    !sink->edid_caps.edid_hdmi)
 			sink->sink_signal = SIGNAL_TYPE_DVI_SINGLE_LINK;
 		else if (dc_is_dvi_signal(sink->sink_signal) &&
+			 dc_is_dvi_signal(link->connector_signal) &&
 			 aud_support->hdmi_audio_native &&
 			 sink->edid_caps.edid_hdmi)
 			sink->sink_signal = SIGNAL_TYPE_HDMI_TYPE_A;


