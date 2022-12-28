Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFFE1875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:56:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA949C433EF;
	Wed, 28 Dec 2022 15:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243001;
	bh=bJJ6Zp2quwahM0XtjAChBt0n2I78Wy17pydxmk6KLDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NolR8u5+0JLRNkZ/RBHzZO0ocTUU+Oxz3qnFFVbPOsjQkPxpA6MRy2Fe0ADk6TVwZ
	 eZTRDXWKTi58HOi78bkwMJ8MUWBypi8vS+oIGEPidSdxJ0z4XmWP0mqZk+ANKgKykj
	 z0Nh+4MogNg0jWZQ0zM/cCQA2+CWJEpEqpLlxemE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Meskhidze <konstantin.meskhidze@huawei.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0439/1146] drm/amdkfd: Fix memory leakage
Date: Wed, 28 Dec 2022 15:32:58 +0100
Message-Id: <20221228144342.105325202@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index 1f76e27f1a35..fe87b3402f06 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -2256,7 +2256,7 @@ int amdgpu_amdkfd_gpuvm_import_dmabuf(struct amdgpu_device *adev,
 
 	ret = drm_vma_node_allow(&obj->vma_node, drm_priv);
 	if (ret) {
-		kfree(mem);
+		kfree(*mem);
 		return ret;
 	}
 
-- 
2.35.1



