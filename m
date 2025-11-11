Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6D52DECDE;
	Tue, 11 Nov 2025 01:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824695; cv=none; b=n4sXbXIuoOyLTi2Nbtx75qTDPJ4Z9ZcQaPk8F7ZyOBVsZcvyFOkhvzmH/8q6CEoILTF92U1ovVkvwcAkMcTjWlMkvYjNRVSdqImnq70KP/ks+gl0VD0G57T76sZh5Fuv2UUhCa0QWLT311jntc45nnf9mm22yEQaFNrIQvaAGow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824695; c=relaxed/simple;
	bh=FLwNT6nK2ROqbiKjfuNCGBG3whTEOJAg++4hjo41GIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdTu22ufSeLXli6sBv9cFyPoubMDT2iQ+R3+EtByEMh2pT/OiuGlPfBklE+gIRWibsHCtVZ9oxhAeGqNJU6X25dtiQ+TfZJNc+DroYv0WXQ4fA5FWoNes+oKiXDxzo7D9bFl9Bxc6oytlzuX9LQcJx761lrHy5FVvF99R0tTgXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xTGNyKNY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xTGNyKNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B75C16AAE;
	Tue, 11 Nov 2025 01:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824695;
	bh=FLwNT6nK2ROqbiKjfuNCGBG3whTEOJAg++4hjo41GIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xTGNyKNYGQueU58aAwZDAIhlwaRhhkNOeSy8p9SqpYfv2Gx0UWA+bOowr+SQwl4eA
	 4+nLQg7Ok9JnBD7UJQ6F5CuuTHBsl8So0mWc0+G01zv46vGbXIa7DA2+e816KNAFf0
	 72FUlPTo0CxmNx5m+RNPzH6ReXk4pJGlgQOR4eHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauri Carvalho <mcarvalho3@lenovo.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Mario Limonciello <Mario.Limonciello@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 552/849] drm/amd/display: Set up pixel encoding for YCBCR422
Date: Tue, 11 Nov 2025 09:42:02 +0900
Message-ID: <20251111004549.753384176@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <Mario.Limonciello@amd.com>

[ Upstream commit 5e76bc677cb7c92b37d8bc66bb67a18922895be2 ]

[Why]
fill_stream_properties_from_drm_display_mode() will not configure pixel
encoding to YCBCR422 when the DRM color format supports YCBCR422 but not
YCBCR420 or YCBCR4444.  Instead it will fallback to RGB.

[How]
Add support for YCBCR422 in pixel encoding mapping.

Suggested-by: Mauri Carvalho <mcarvalho3@lenovo.com>
Reviewed-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Mario Limonciello <Mario.Limonciello@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 8eb2fc4133487..3762b3c0ef983 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6399,6 +6399,9 @@ static void fill_stream_properties_from_drm_display_mode(
 			&& aconnector
 			&& aconnector->force_yuv420_output)
 		timing_out->pixel_encoding = PIXEL_ENCODING_YCBCR420;
+	else if ((connector->display_info.color_formats & DRM_COLOR_FORMAT_YCBCR422)
+			&& stream->signal == SIGNAL_TYPE_HDMI_TYPE_A)
+		timing_out->pixel_encoding = PIXEL_ENCODING_YCBCR422;
 	else if ((connector->display_info.color_formats & DRM_COLOR_FORMAT_YCBCR444)
 			&& stream->signal == SIGNAL_TYPE_HDMI_TYPE_A)
 		timing_out->pixel_encoding = PIXEL_ENCODING_YCBCR444;
-- 
2.51.0



