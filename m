Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5174919884A;
	Thu,  5 Sep 2024 09:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529623; cv=none; b=NkNC0yl3b1Zy/FpeXoRCPJahjjOjG3LzCslHd2L6TWqB5Zx+/FtvFBHmKXhDDsO1hASlJseggWS+rt6oi3hCSdNIBF9V6M/hEQOlD0uDdTrSggZyrZnHyUyy5tADzoqiuHaEmfqwqg3+95V53bUjIUwT6p0iJShNLGpI5T5LDHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529623; c=relaxed/simple;
	bh=1Eo4kPsGJ+9PvsnFNnfIUapdg1W7XRdzrW/bChY/WIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDY9Cd6lJVZPQOZvWGKgmCGxLXSYC21OhYKivY6YfuVLVBHj1PXX70sd3S2jfIR15QpF4Z2OEB17HIUvnoz6XvcLVaDDmgt4BS+gMDXpZwMAY4mhchZ07ohV1hKCoDVQixCs8Fgcz8gX/1LX19j2vKlYFy9z3Us6A7SwPYSxy7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tLtmUyV9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tLtmUyV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0A8C4CEC6;
	Thu,  5 Sep 2024 09:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529622;
	bh=1Eo4kPsGJ+9PvsnFNnfIUapdg1W7XRdzrW/bChY/WIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tLtmUyV9HBVklVaRGJ0OzfiBTy0e0HbnKosGuxRHilbNcdiM1PKKl+h4vNKnwUTiL
	 bTX7R/ws0PvFbahXadFxhaGZZvPGaqIEI0Q552488M2GIZl760xKDNte2mtBFiYeSf
	 rbKILF5+SfEzflY9IgKoNS6+q5RKICDvI69rWf18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 060/184] drm/amd/display: Stop amdgpu_dm initialize when link nums greater than max_links
Date: Thu,  5 Sep 2024 11:39:33 +0200
Message-ID: <20240905093734.582406919@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hersen Wu <hersenxs.wu@amd.com>

[ Upstream commit cf8b16857db702ceb8d52f9219a4613363e2b1cf ]

[Why]
Coverity report OVERRUN warning. There are
only max_links elements within dc->links. link
count could up to AMDGPU_DM_MAX_DISPLAY_INDEX 31.

[How]
Make sure link count less than max_links.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index b6228847b797..9cf9c8f917a1 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4587,17 +4587,17 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 		}
 	}
 
+	if (link_cnt > MAX_LINKS) {
+		DRM_ERROR(
+			"KMS: Cannot support more than %d display indexes\n",
+				MAX_LINKS);
+		goto fail;
+	}
+
 	/* loops over all connectors on the board */
 	for (i = 0; i < link_cnt; i++) {
 		struct dc_link *link = NULL;
 
-		if (i > AMDGPU_DM_MAX_DISPLAY_INDEX) {
-			DRM_ERROR(
-				"KMS: Cannot support more than %d display indexes\n",
-					AMDGPU_DM_MAX_DISPLAY_INDEX);
-			continue;
-		}
-
 		link = dc_get_link_at_index(dm->dc, i);
 
 		if (link->connector_signal == SIGNAL_TYPE_VIRTUAL) {
-- 
2.43.0



