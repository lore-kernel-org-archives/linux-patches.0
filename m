Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB6F55C3B;
	Tue, 14 May 2024 10:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682508; cv=none; b=vGDc6HH/pWkKQxEKgQ+Z6p+ETVPRZMt1CqdBK1C1ZaZDFcOWhLVU3vmKIEVO5lXlstCROrpbnVkatEeW8zu0VFPx0TR9T1EJSNv9lQt1hZJ6E6RZatklhtf+Cb3yjxQjzymsUK4QOq1JtHYE/hla40fDdnqTmuQaUpdU6OJMoYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682508; c=relaxed/simple;
	bh=UgBSqk7EVh+5stuiDMaKJD9pi1yq0YhgcXry6bvybM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMpVPKyv146jeFIi8pRbIURJC7N689nEqFb/GUq1giTP2h/i42HVEf15p3WHyvVoVsfd43Dcj9iX8+cnnTmB8ufistJ80xiB8B5cfLEIkz8Yc4fM0efx+YCWzOni0hEr/ieEmMyJlVolvXL5yAxiFY0mKNymskkEahhJXVC2Mr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O5QGOfHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O5QGOfHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB53CC2BD10;
	Tue, 14 May 2024 10:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682508;
	bh=UgBSqk7EVh+5stuiDMaKJD9pi1yq0YhgcXry6bvybM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O5QGOfHJOpAoWwQ7rKGpFUQphoCGvhHZOVnensTS80tifTiHiJsqzNguLy4ofiSNf
	 spR/D4VAp8uhrPn21hfeSa2qJDltYqhhP5/VXls5mu3Hya+ZqXXEOrbU33yAZR0Ggu
	 myVErVOVLTX6Ulld67GH/WrvnkS26G7vhno4LgS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Koenig <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Shashank Sharma <shashank.sharma@amd.com>,
	Arvind Yadav <arvind.yadav@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 072/336] drm/amdgpu: fix doorbell regression
Date: Tue, 14 May 2024 12:14:36 +0200
Message-ID: <20240514101041.324302630@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shashank Sharma <shashank.sharma@amd.com>

[ Upstream commit 705d0480e6ae5a73ca3a9c04316d0678e19a46ed ]

This patch adds a missed handling of PL domain doorbell while
handling VRAM faults.

Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Fixes: a6ff969fe9cb ("drm/amdgpu: fix visible VRAM handling during faults")
Reviewed-by: Christian Koenig <christian.koenig@amd.com>
Signed-off-by: Shashank Sharma <shashank.sharma@amd.com>
Signed-off-by: Arvind Yadav <arvind.yadav@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index 851509c6e90eb..8d5413ffad301 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -424,7 +424,7 @@ bool amdgpu_res_cpu_visible(struct amdgpu_device *adev,
 		return false;
 
 	if (res->mem_type == TTM_PL_SYSTEM || res->mem_type == TTM_PL_TT ||
-	    res->mem_type == AMDGPU_PL_PREEMPT)
+	    res->mem_type == AMDGPU_PL_PREEMPT || res->mem_type == AMDGPU_PL_DOORBELL)
 		return true;
 
 	if (res->mem_type != TTM_PL_VRAM)
-- 
2.43.0



