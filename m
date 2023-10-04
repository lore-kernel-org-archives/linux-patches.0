Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2A31D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOZfM0IM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94475C433C9;
	Wed,  4 Oct 2023 18:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443295;
	bh=K9boJeA3QJ/nFmTjEFf0hdlrFBO4A9+j17j9s6/Ead0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tOZfM0IMkY/0665qhFHElbJ/u4vX1iC/3pbD9+CtWKNrhgLRkMoTVTfoM5gvqc8mA
	 GRXktIsatdNnozlf7EFYIXWXyg6GJEMkuk2Jc/noa6XR5tj/zSi2gq4wIhIbPy8u0m
	 ELJ3LRteRtHNugoCieKnfViQfdU9p3KOpKGADNRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 106/259] drm/amdkfd: Insert missing TLB flush on GFX10 and later
Date: Wed,  4 Oct 2023 19:54:39 +0200
Message-ID: <20231004175222.207278421@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

From: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>

[ Upstream commit edcfe22985d09ee8e2346c9217f5a52ab150099f ]

Heavy-weight TLB flush is required after unmap on all GPUs for
correctness and security.

Signed-off-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index f374f112f7b71..ec8a576ac5a9e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -1349,8 +1349,7 @@ void kfd_flush_tlb(struct kfd_process_device *pdd, enum TLB_FLUSH_TYPE type);
 
 static inline bool kfd_flush_tlb_after_unmap(struct kfd_dev *dev)
 {
-	return KFD_GC_VERSION(dev) == IP_VERSION(9, 4, 3) ||
-	       KFD_GC_VERSION(dev) == IP_VERSION(9, 4, 2) ||
+	return KFD_GC_VERSION(dev) > IP_VERSION(9, 4, 2) ||
 	       (KFD_GC_VERSION(dev) == IP_VERSION(9, 4, 1) && dev->sdma_fw_version >= 18) ||
 	       KFD_GC_VERSION(dev) == IP_VERSION(9, 4, 0);
 }
-- 
2.40.1



