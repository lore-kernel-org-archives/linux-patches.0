Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0168930EF9B;
	Mon, 13 Oct 2025 15:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369669; cv=none; b=oNu8HfqVGHGEDIExoefRE3OYrF4pd7FHYFXtWDf2oqMCqjgpHqx0nc3+QLMm71S7BWg7z+qK+l6BrHAS0Nqx4pCDTaabLsxWqq+FCCeFZlsmnWh0Yl37QcOKKdxICxuj7zLSUzVZgisc9gcUBaA0yk1llJA57kYCn/bY939vfms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369669; c=relaxed/simple;
	bh=4Mmd0n/8k09Yup6TStkwKgQbKwu9n/7cYGKJNHd/Eow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQ9nLWjEjGd7QdW22N6/Q+EG7XvLFLRVkUTCIB6nN0dRSNAjRyRTG+1uIsXqxqUuLjTSxvzJT5NZiunkKEtnRDMs741qbBe22yJfPeY/UTQxwePeJrqTxv5LcwIkmpa9mHrM5C8KWNDz+w9zSvE4ifCGuZ5k0u5FJyo3PQlOWB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4zjBFdZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4zjBFdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFE9C4CEFE;
	Mon, 13 Oct 2025 15:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369668;
	bh=4Mmd0n/8k09Yup6TStkwKgQbKwu9n/7cYGKJNHd/Eow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4zjBFdZ1l2iitirDKNSzixwq2/AQpUuyYKqX92WenR+Mv/I4kmX9bFa8mg7wFZmY
	 WZx0S/V5+Xzg3uVoLhQhRQ//8S06EPvd304f+WgIi+Yk0p/Soz6BcxXRGnoX4vSJdK
	 vkYWVybbfVpauBd2ec8E7tcpStCenYWT9P1JvC0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 327/563] drm/msm/mdp4: stop supporting no-IOMMU configuration
Date: Mon, 13 Oct 2025 16:43:08 +0200
Message-ID: <20251013144423.108559617@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit cc64568b522b64fb8f8c607da9eb4e2d9f72d0cf ]

With the switch to GPUVM the msm driver no longer supports the no-IOMMU
configurations (even without the actual GPU). Return an error in case we
face the lack of the IOMMU for an MDP4 device.

Fixes: 111fdd2198e6 ("drm/msm: drm_gpuvm conversion")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/672557/
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
index 0952c7f18abdc..4d1ea9b261917 100644
--- a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
+++ b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
@@ -463,9 +463,9 @@ static int mdp4_kms_init(struct drm_device *dev)
 		ret = PTR_ERR(mmu);
 		goto fail;
 	} else if (!mmu) {
-		DRM_DEV_INFO(dev->dev, "no iommu, fallback to phys "
-				"contig buffers for scanout\n");
-		vm = NULL;
+		DRM_DEV_INFO(dev->dev, "no IOMMU, bailing out\n");
+		ret = -ENODEV;
+		goto fail;
 	} else {
 		vm  = msm_gem_vm_create(dev, mmu, "mdp4",
 					0x1000, 0x100000000 - 0x1000,
-- 
2.51.0



