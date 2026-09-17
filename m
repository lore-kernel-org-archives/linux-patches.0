Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709964E9C04;
	Thu, 17 Sep 2026 16:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664026; cv=none; b=JfHS0gKsvuuxXXRcqpfxm3378QqB8W1lkOrQ88oNkZijJZB3fMbcQqQ+cPyo88i8VbOqQ4hc34+SvJK8zz5DxUcGiAH/j6EAqIf+R1QqLoKnxeHxqes6zxnYFhVL1Om82KBSXx+1euUM/XMUAgtA+DyDq/PnQcIk5u/GQMN19l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664026; c=relaxed/simple;
	bh=lFw+L4CINhJZ2l2B5PuNAbcHMKsYhSSSjzyNaP5huSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fcLdzI9XJy8n+W9L83MwCyYYKtYrXKeZrp0uTx3z/WYZ98OK249t8N+pTF9uOubYd/IyOSlQeyxyGcy5BKNZl4b4lc769yiDQ47M4hzPB/dETECH9rPGWB+ZPpfpb0qTPp7BXiRXpGdJIa+Oqxm3vhVsMnXyR3jcr3bRF1kaAvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2cA0gbc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2cA0gbc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77161F000FF;
	Thu, 17 Sep 2026 16:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664025;
	bh=DwjkfrcCUBIslF+Cgb3+dalayRJkjkbgF6Jy7bJWhks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M2cA0gbcJYcHkzl8GToXTUBNoKJXimH9R6dXlZxiEY0BzQ/Gm0jUpblpAfxaP40Nc
	 hZI1Ifx/2Vu5PEpZJYwXRFNph+OfyO8MjJOtnLPQxlofjLGDM+L6ENUi6D6BYpdDuu
	 /v03PLdMByoISP0P502cemC37vLIG9L64ecGSxlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0234/1250] drm/amd/display: Initialize dsc_caps to 0
Date: Thu, 17 Sep 2026 16:00:29 +0100
Message-ID: <20260917151558.484460644@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Lipski <ivan.lipski@amd.com>

[ Upstream commit d18ecfee5187e3b2dbff7e67dda8b2f54ff5231c ]

[Why&How]
If we don't do that we make DSC decisions based on random
inputs, which might result in disallowing DSC when the
monitor and HW support it.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 06eb499f13637..ba4d0f68df6ea 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7183,7 +7183,7 @@ create_stream_for_sink(struct drm_connector *connector,
 	int preferred_refresh = 0;
 	enum color_transfer_func tf = TRANSFER_FUNC_UNKNOWN;
 #if defined(CONFIG_DRM_AMD_DC_FP)
-	struct dsc_dec_dpcd_caps dsc_caps;
+	struct dsc_dec_dpcd_caps dsc_caps = {0};
 #endif
 	struct dc_link *link = NULL;
 	struct dc_sink *sink = NULL;
-- 
2.53.0



