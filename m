Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569E91EB45
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPXzGE6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3A4C433C7;
	Wed, 15 Nov 2023 19:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076346;
	bh=3oUvPTzSQPCA2Dnpx5H3RRXJ4gzbe3tu5kvWOdqWaXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPXzGE6ypTzrCp0kOAAIJcUQ5pwWm6x8c+dMJ7IUXUkXNL0KAbDNVE8Zgrf3qRc27
	 mMkjeGAihv6q98GtQLJLZFem/nxkbTgt/RmGQrrT+mSSe0ByXARpTEw9KrVG1dWTOS
	 vQpXIyr4W8fR1f0LVVu1oBlZUHPFF1Z2y/6PMyDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Liu <liucong2@kylinos.cn>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 234/550] drm/amd/display: Fix null pointer dereference in error message
Date: Wed, 15 Nov 2023 14:13:38 -0500
Message-ID: <20231115191616.931662814@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Liu <liucong2@kylinos.cn>

[ Upstream commit 0c3601a2fbfb265ce283651480e30c8e60459112 ]

This patch fixes a null pointer dereference in the error message that is
printed when the Display Core (DC) fails to initialize. The original
message includes the DC version number, which is undefined if the DC is
not initialized.

Fixes: 9788d087caff ("drm/amd/display: improve the message printed when loading DC")
Signed-off-by: Cong Liu <liucong2@kylinos.cn>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index c9959bd8147db..83d670f0d199b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1690,8 +1690,7 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 		DRM_INFO("Display Core v%s initialized on %s\n", DC_VER,
 			 dce_version_to_string(adev->dm.dc->ctx->dce_version));
 	} else {
-		DRM_INFO("Display Core v%s failed to initialize on %s\n", DC_VER,
-			 dce_version_to_string(adev->dm.dc->ctx->dce_version));
+		DRM_INFO("Display Core failed to initialize with v%s!\n", DC_VER);
 		goto error;
 	}
 
-- 
2.42.0



