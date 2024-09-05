Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A7F154BFF;
	Thu,  5 Sep 2024 09:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530094; cv=none; b=kg3KT11IBrnSbLUF83pwcpTbb0DBMuLcKyJY/hWUDcsmKGZ3EtCipReX1n7s9Q7bd6mjW1Dha4QgWBnIH4A9y9iyK9xsZMTrIGqvl7/aYelDkGXthV86BEip8IoNto48QC7g3/1qyfoS6vxhdiKyB5zDvFgHiH7n1XZMedg8ikY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530094; c=relaxed/simple;
	bh=+DFEFbVQzSIniQXB98Rio89+sxQDTOqxBnEQLoJyFMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2s3dq6nVuBDcvUM6OMRR/6RRGBye/f+7Md+Au1zn2yhtIMxkYmFjoVzakwPWWUtx/myRiSER2WBTuqnuQ0vyxfo+dwxzK8VQNVaRlu3+xc0C3EIhmEUUYJ9ztnLUJQIK9C53m19jJDw/ajTsHANce6Y2ypL/9aoS/aEVjyLfTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/qXg1zv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/qXg1zv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2F1C4CEC3;
	Thu,  5 Sep 2024 09:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530094;
	bh=+DFEFbVQzSIniQXB98Rio89+sxQDTOqxBnEQLoJyFMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/qXg1zvrIXlT9StTY/bK4fJi5MGBKz3vfdZed+sDFnOiO4efXTWU69R5tRn+VqvR
	 0bgWXlkbHTKbbRSdPQ4Uj89qPiLUHFLyBUgUp2wHd+kLe+x+wTcCBYoMwjcnJGoSgG
	 v9CFraHSTYEW+p1QPHEKUPfDGXqwLzkpQo6ukNXI=
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
Subject: [PATCH 6.6 052/132] drm/amd/display: Stop amdgpu_dm initialize when stream nums greater than 6
Date: Thu,  5 Sep 2024 11:40:39 +0200
Message-ID: <20240905093724.281685973@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hersen Wu <hersenxs.wu@amd.com>

[ Upstream commit 84723eb6068c50610c5c0893980d230d7afa2105 ]

[Why]
Coverity reports OVERRUN warning. Should abort amdgpu_dm
initialize.

[How]
Return failure to amdgpu_dm_init.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 94059aef762b..37f79ae0b6c2 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4357,7 +4357,10 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 
 	/* There is one primary plane per CRTC */
 	primary_planes = dm->dc->caps.max_streams;
-	ASSERT(primary_planes <= AMDGPU_MAX_PLANES);
+	if (primary_planes > AMDGPU_MAX_PLANES) {
+		DRM_ERROR("DM: Plane nums out of 6 planes\n");
+		return -EINVAL;
+	}
 
 	/*
 	 * Initialize primary planes, implicit planes for legacy IOCTLS.
-- 
2.43.0



