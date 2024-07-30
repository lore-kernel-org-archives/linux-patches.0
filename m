Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E8C189505;
	Tue, 30 Jul 2024 16:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355819; cv=none; b=Sc3H1UfgJXA5GzKlGSFDvkFklE9ByCTXahnKR9XOJs/20xOqNJpFyR3GaFqRgvVNmr/FkezEGOwuHDCEMaiw/6VQg9SreupW1bxerl9aCBSLwlOXkRS+VqvmufWN4DwWjVyNqGggjOIfjUoGa3TsLCb6izABcgumjLSfX1UxM08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355819; c=relaxed/simple;
	bh=feB9LbGvMEGT7hAG9vyxlgxdq0Dc84HGDx5kb+jf22U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CH8W2M6+OFefHWYfwPwC8wZmpLbcCm/LNW3I6EP0osg7LXvfNKCNT0dLwFb/hmbnhlQjcRpPy9zRaYXupeLbRjhc0N3n1qe3tQbWMW1SiHY6SS+lzfXxOyWd6vBPNJy0OY2R/R7N2P7kjXBx3J23DdB+HWIgq4SACIMGToGv4Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNDUQS9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNDUQS9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3ABC32782;
	Tue, 30 Jul 2024 16:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355819;
	bh=feB9LbGvMEGT7hAG9vyxlgxdq0Dc84HGDx5kb+jf22U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HNDUQS9gKP+XIMTY9rJaZ7KE0qk374q0S2fSEvZMQWPhzy5OQMCBBNdrI0gQUEXNe
	 9sdpfpQg/Ul7jTqzTJgVvTRkBxcaagschMAM89S5NDgpNne24xSlGMyU5SNwaZWxu6
	 Y+0L1aPXizQ2iCs2fa9oFcYC8kJ7IEs80pQrMJ1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Van Patten <timvp@google.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 133/440] drm/amdgpu: Remove GC HW IP 9.3.0 from noretry=1
Date: Tue, 30 Jul 2024 17:46:06 +0200
Message-ID: <20240730151621.077656766@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Tim Van Patten <timvp@google.com>

[ Upstream commit 1446226d32a45bb7c4f63195a59be8c08defe658 ]

The following commit updated gmc->noretry from 0 to 1 for GC HW IP
9.3.0:

    commit 5f3854f1f4e2 ("drm/amdgpu: add more cases to noretry=1")

This causes the device to hang when a page fault occurs, until the
device is rebooted. Instead, revert back to gmc->noretry=0 so the device
is still responsive.

Fixes: 5f3854f1f4e2 ("drm/amdgpu: add more cases to noretry=1")
Signed-off-by: Tim Van Patten <timvp@google.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
index ea0fb079f942a..fd98d2508a22a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -583,7 +583,6 @@ void amdgpu_gmc_noretry_set(struct amdgpu_device *adev)
 	struct amdgpu_gmc *gmc = &adev->gmc;
 	uint32_t gc_ver = adev->ip_versions[GC_HWIP][0];
 	bool noretry_default = (gc_ver == IP_VERSION(9, 0, 1) ||
-				gc_ver == IP_VERSION(9, 3, 0) ||
 				gc_ver == IP_VERSION(9, 4, 0) ||
 				gc_ver == IP_VERSION(9, 4, 1) ||
 				gc_ver == IP_VERSION(9, 4, 2) ||
-- 
2.43.0



