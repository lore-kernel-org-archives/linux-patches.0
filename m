Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263DE1537AA;
	Mon, 14 Oct 2024 15:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919842; cv=none; b=kELiLLry14Qhy50CgqUWjDOVJeQSBbvyxPkkbRktAfUr2I75d+xqUevJSRwmLHIfnsPy5OA8LHtX7GahtrPZa93nz4m72+lnBjB58L3Q2nXIHJdEytN8Owa+QCW4uofhIL99rY3X7BTtshBYaZ/A/slT4olU7UQcaDznK1F6AP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919842; c=relaxed/simple;
	bh=ejvLoxXSt1N5U+0Ojrvm/G58eyV7rbEa/FWPtOoZACY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpEalEzQAbRHri0VIYIpgGAjQV+LDX2/qHfwkVMOqNqSdwCukm4VXIDS4q5ULkvsUjoftX76VQXQ01jwKL+C+vk0hXLKVmToIX7SoWnH7rJSX/mOJNugK2MlE+SE5Kv2S51jCQpkUK9SA5ln7hLcvbzJphTg7A574Mfl69fdFfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iAculUbc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iAculUbc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB1CC4CEC3;
	Mon, 14 Oct 2024 15:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919842;
	bh=ejvLoxXSt1N5U+0Ojrvm/G58eyV7rbEa/FWPtOoZACY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAculUbcqyjeoN7ztHrG6rkCtAza7shXJ13nm/IN95VzidkxIygZxBN7IDiFu1e/L
	 87BCXYEsbXwSHWVuxWl0UTa2Q4NeHgA/h7tONQoouV1avO5zMWcMql8ReP1G/r1a5w
	 ga7/mmAlczQgUwS7GrFPQwTrWkyZGWm1nDqLTVf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 722/798] drm/amd/display: Check null pointer before dereferencing se
Date: Mon, 14 Oct 2024 16:21:16 +0200
Message-ID: <20241014141246.436337525@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit ff599ef6970ee000fa5bc38d02fa5ff5f3fc7575 ]

[WHAT & HOW]
se is null checked previously in the same function, indicating
it might be null; therefore, it must be checked when used again.

This fixes 1 FORWARD_NULL issue reported by Coverity.

Acked-by: Alex Hung <alex.hung@amd.com>
Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 2d514e2e91a04..2721842af8067 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1659,7 +1659,7 @@ bool dc_validate_boot_timing(const struct dc *dc,
 		if (crtc_timing->pix_clk_100hz != pix_clk_100hz)
 			return false;
 
-		if (!se->funcs->dp_get_pixel_format)
+		if (!se || !se->funcs->dp_get_pixel_format)
 			return false;
 
 		if (!se->funcs->dp_get_pixel_format(
-- 
2.43.0



