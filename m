Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A65156F45;
	Tue,  9 Jul 2024 11:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523602; cv=none; b=HxdixCrnlR06ZgkjW1+RfGcj8Xxq2NGdJToqTJ4/xwPTSyIfLpRgN+lPIRPeQTa0dxQOVobG+bvalZahPxN/AlJqI2/0CDwxLvb8H+B6W+d3LiDDBhhpKrrkU6DhnU8ai8X+qehqnBrlAiZDm5bj599as7EMrxQR1e9h6HMagZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523602; c=relaxed/simple;
	bh=L7i6+5TjzfhzPh+ocgemEjnI4iFa/sdwVHCd7BUnOTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NsY9XMkY1qeeTT2c8yq3WZTuum+tn08ALrFbpInrfH48r+ih0Nc83JRJko+eOMsSJOV7ANMBPzrsjiSuuq1iAduCpBcCoh6X2/Sy3HVp1gUhVFwQlc8NDRCNBcCPrFeiYKU4dQhGLZGprigwglNItOjW2mQpM4kJPJsjYS5rm2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZTxidU12; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTxidU12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF002C3277B;
	Tue,  9 Jul 2024 11:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523602;
	bh=L7i6+5TjzfhzPh+ocgemEjnI4iFa/sdwVHCd7BUnOTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTxidU12qgOK4DmHDNVNb9uAi1pB/IwcD+jHRcM13pAd7iOXLiolzfCrdgWsBUqAi
	 B1Bup8+DkZLpQWyFtrzawOfx9ux8HPBKO/AtZpx4H5bctyNSTBMPO5lxo2POTc9ZA8
	 lX+oeD50bL6QajC09+EnmAtGhkautxEFUGlWiR3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/139] drm/amdgpu: Fix uninitialized variable warnings
Date: Tue,  9 Jul 2024 13:08:37 +0200
Message-ID: <20240709110658.827829070@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit 60c448439f3b5db9431e13f7f361b4074d0e8594 ]

return 0 to avoid returning an uninitialized variable r

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/aldebaran.c      | 2 +-
 drivers/gpu/drm/amd/amdgpu/sienna_cichlid.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/aldebaran.c b/drivers/gpu/drm/amd/amdgpu/aldebaran.c
index fa6193535d485..7fea4f0f495a3 100644
--- a/drivers/gpu/drm/amd/amdgpu/aldebaran.c
+++ b/drivers/gpu/drm/amd/amdgpu/aldebaran.c
@@ -100,7 +100,7 @@ static int aldebaran_mode2_suspend_ip(struct amdgpu_device *adev)
 		adev->ip_blocks[i].status.hw = false;
 	}
 
-	return r;
+	return 0;
 }
 
 static int
diff --git a/drivers/gpu/drm/amd/amdgpu/sienna_cichlid.c b/drivers/gpu/drm/amd/amdgpu/sienna_cichlid.c
index 8b8086d5c864b..896c7e434d3bc 100644
--- a/drivers/gpu/drm/amd/amdgpu/sienna_cichlid.c
+++ b/drivers/gpu/drm/amd/amdgpu/sienna_cichlid.c
@@ -93,7 +93,7 @@ static int sienna_cichlid_mode2_suspend_ip(struct amdgpu_device *adev)
 		adev->ip_blocks[i].status.hw = false;
 	}
 
-	return r;
+	return 0;
 }
 
 static int
-- 
2.43.0



