Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DD915CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE84AC433C1;
	Tue,  8 Nov 2022 14:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916443;
	bh=qEThPl82gZzpcJCNnMaXWytKZcvpHFYvyCgxS7xecFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eNMeD2iXQcuV2milNlhBJ6nCB5OE++y1krL1R0DeNrn+hnqqSN2TrJ3D3QwpPe2ex
	 3Bp5A3kPD1bzeqqw7Irn7L+TDKHoSNQ5QjT7Z+DDU63+PLnFdS2oWO9TKW8zNK0dka
	 919/6FXzBliL+gTAlcVwuirP8v/NK6A+fvTZGOS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 003/197] drm/i915/gvt: Add missing vfio_unregister_group_dev() call
Date: Tue,  8 Nov 2022 14:37:21 +0100
Message-Id: <20221108133354.938359604@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit f423fa1bc9fe1978e6b9f54927411b62cb43eb04 ]

When converting to directly create the vfio_device the mdev driver has to
put a vfio_register_emulated_iommu_dev() in the probe() and a pairing
vfio_unregister_group_dev() in the remove.

This was missed for gvt, add it.

Cc: stable@vger.kernel.org
Fixes: 978cf586ac35 ("drm/i915/gvt: convert to use vfio_register_emulated_iommu_dev")
Reported-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/0-v1-013609965fe8+9d-vfio_gvt_unregister_jgg@nvidia.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index e3cd58946477..dacd57732dbe 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1595,6 +1595,7 @@ static void intel_vgpu_remove(struct mdev_device *mdev)
 
 	if (WARN_ON_ONCE(vgpu->attached))
 		return;
+	vfio_unregister_group_dev(&vgpu->vfio_device);
 	intel_gvt_destroy_vgpu(vgpu);
 }
 
-- 
2.35.1



