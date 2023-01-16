Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184A933EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95CB8C433D2;
	Mon, 16 Jan 2023 16:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884858;
	bh=CAENawXkmGIikTgQaoNQNaa2aMRkxqXC9VP92b9laqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FyBTBwADKLm0ZLxzI8mza8t/ChFA4RmBCirPUy3V6uvd0t4a4IGm7sO9sFTC7KQBa
	 wYA3cHHzS+t6AF/7uz3Ej930SV71TAb5atshJ5zKZlJzFeBbPw+jL8YEyE9e6UQMVI
	 4blYPzlQxt9eMoQ9k9jGxx58s1LPwDu4cY6etyZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <Alexander.Deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	AMD Graphics <amd-gfx@lists.freedesktop.org>,
	Dan Carpenter <error27@gmail.com>,
	kernel test robot <lkp@intel.com>,
	Luben Tuikov <luben.tuikov@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 138/183] drm/amdgpu: Fix potential NULL dereference
Date: Mon, 16 Jan 2023 16:51:01 +0100
Message-Id: <20230116154809.201264284@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luben Tuikov <luben.tuikov@amd.com>

[ Upstream commit 0be7ed8e7eb15282b5d0f6fdfea884db594ea9bf ]

Fix potential NULL dereference, in the case when "man", the resource manager
might be NULL, when/if we print debug information.

Cc: Alex Deucher <Alexander.Deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: AMD Graphics <amd-gfx@lists.freedesktop.org>
Cc: Dan Carpenter <error27@gmail.com>
Cc: kernel test robot <lkp@intel.com>
Fixes: 7554886daa31ea ("drm/amdgpu: Fix size validation for non-exclusive domains (v4)")
Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index 3be3cba3a16d..cfd78c4a45ba 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -468,8 +468,9 @@ static bool amdgpu_bo_validate_size(struct amdgpu_device *adev,
 	return true;
 
 fail:
-	DRM_DEBUG("BO size %lu > total memory in domain: %llu\n", size,
-		  man->size);
+	if (man)
+		DRM_DEBUG("BO size %lu > total memory in domain: %llu\n", size,
+			  man->size);
 	return false;
 }
 
-- 
2.35.1



