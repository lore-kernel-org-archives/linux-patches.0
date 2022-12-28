Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994BB1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199A6C433D2;
	Wed, 28 Dec 2022 15:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239680;
	bh=PE46jcV5/Eb6XVjfPOGWJle3O1NjZM7IpF0HWuBm72w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ibtvx8RFXZ2+p/m9r7RbJTm7jSZhkxix3hxl6wfD9AYqmTuy2M2cM1kxKOHEq8JEJ
	 oKdUNagnfLvsyNNq2n/gNFwPpPw7pRcm20Z6wEgNu0Sq9mo2N+TsOnzOpvGPmrTTE8
	 SKEipm/xDycggRCgX8/3oyPAbeMuVcSV7Zp1/Lw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Meskhidze <konstantin.meskhidze@huawei.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 257/731] drm/amdkfd: Fix memory leakage
Date: Wed, 28 Dec 2022 15:36:04 +0100
Message-Id: <20221228144304.010170225@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>

[ Upstream commit 75818afff631e1ea785a82c3e8bb82eb0dee539c ]

This patch fixes potential memory leakage and seg fault
in  _gpuvm_import_dmabuf() function

Fixes: d4ec4bdc0bd5 ("drm/amdkfd: Allow access for mmapping KFD BOs")
Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 477ab3551177..34303dd3ada9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1910,7 +1910,7 @@ int amdgpu_amdkfd_gpuvm_import_dmabuf(struct kgd_dev *kgd,
 
 	ret = drm_vma_node_allow(&obj->vma_node, drm_priv);
 	if (ret) {
-		kfree(mem);
+		kfree(*mem);
 		return ret;
 	}
 
-- 
2.35.1



