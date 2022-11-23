Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3731F1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91105C433C1;
	Wed, 23 Nov 2022 09:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196498;
	bh=Ur+6ung+1Jg5W4OUPwgfM4XGfn/eozgws0JTSUiElDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fF5LONsmQd8TYq9UVZhMYOBsJlp6HU5z1BtZdE98+hyoiHwbkFcQ2ZbptngHKUBmD
	 AvOWgw0dneMCFybeqOK5HBHk9MTTb2lGFMiz1NyWX34gVDDQEpgN6m53R6nHBMDhZW
	 Sv3Qp4ylBeKzlL5201hyi4WEsNQbQnhmRmELBmtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Broadworth <mark.broadworth@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Fangzhi Zuo <Jerry.Zuo@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 049/314] drm/amd/display: Ignore Cable ID Feature
Date: Wed, 23 Nov 2022 09:48:14 +0100
Message-Id: <20221123084627.732434082@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

[ Upstream commit 14aed119942f6c2f1286022323139f7404db5d2b ]

Ignore cable ID for DP2 receivers that does not support the feature.

Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Reviewed-by: Roman Li <Roman.Li@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 3be70848b202..54c76ed1ad75 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1549,6 +1549,9 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 
 	adev->dm.dc->debug.visual_confirm = amdgpu_dc_visual_confirm;
 
+	/* TODO: Remove after DP2 receiver gets proper support of Cable ID feature */
+	adev->dm.dc->debug.ignore_cable_id = true;
+
 	r = dm_dmub_hw_init(adev);
 	if (r) {
 		DRM_ERROR("DMUB interface failed to initialize: status=%d\n", r);
-- 
2.35.1



