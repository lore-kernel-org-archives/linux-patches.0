Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BB430C344;
	Mon, 13 Oct 2025 15:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369640; cv=none; b=CAgn3ihjCTIMWPV5iAqIIcHkZQMd+9FfoyQPADzgtidCyZ7b1j+86f36I6liyHzCiYu633munU/qopgo/GhErNPdTFUVcORLSOsnC5NclxfITtcKOXGl4xCzrr4cTjnwN092nwVUinduQi8blD2VfO4i3hz8kI0sVFlx7qCoN5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369640; c=relaxed/simple;
	bh=ClPOrrXWkDCds6teY3NsDc9smLg80KnLmOE2ySE9N1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jiSungqp+8K28SLB9ePYQaK+KP6E6bV5BcovR5yEecYaUQi7r9BJyJ05rPNv0lPWJvpbyRmV1nqOzPttj0p2api1WvaIMB7OPhp/yGKfSk+uYgEV5Rwn/4q68QeBW3psM9gcWZFd7Y6PR/xvrD4IvKthOJhK4iGGzHEL4f2d2C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QbsAhp3d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QbsAhp3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77094C4CEE7;
	Mon, 13 Oct 2025 15:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369639;
	bh=ClPOrrXWkDCds6teY3NsDc9smLg80KnLmOE2ySE9N1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbsAhp3d1mfYx9EGhqkmznYui2zqOHdko5ZXGOxLCh52AzRMlyzjq4FcrFBMVaNBI
	 7m5F8TvoZDu0dOtRNiYyCnjNEk6e9+xcKnKk8X6do50/RhKGlaDd+PrK67NCDmzehr
	 uj7LawPthZE9rrlCc4XcBQ3/VvvnQBTdM4oADJuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 318/563] drm/amdkfd: Fix error code sign for EINVAL in svm_ioctl()
Date: Mon, 13 Oct 2025 16:42:59 +0200
Message-ID: <20251013144422.786537787@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit cbda64f3f58027f68211dda8ea94d52d7e493995 ]

Use negative error code -EINVAL instead of positive EINVAL in the default
case of svm_ioctl() to conform to Linux kernel error code conventions.

Fixes: 42de677f7999 ("drm/amdkfd: register svm range")
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index a0f22ea6d15af..3d8b20828c068 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -4239,7 +4239,7 @@ svm_ioctl(struct kfd_process *p, enum kfd_ioctl_svm_op op, uint64_t start,
 		r = svm_range_get_attr(p, mm, start, size, nattrs, attrs);
 		break;
 	default:
-		r = EINVAL;
+		r = -EINVAL;
 		break;
 	}
 
-- 
2.51.0



