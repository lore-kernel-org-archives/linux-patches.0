Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203F19440
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96ECCC433C8;
	Sun, 16 Jul 2023 20:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539431;
	bh=alhPmWnxX2SKdzdLPUEndglOkhWiAl+v9QuOf2zGjdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=biYIVLu2UCeA4Rx/OujIeDa9jvxfrmUeFo0r3N3MF+gF1h6bsC5lDiVjvP86xqXx3
	 uzv4OGOjmUyZay1nafQpBxpW2JKW+fyjW6CUy8VPoGeTad4B9AeaDG/yahGOcaALcG
	 RQ9kCB1ncwUGSSaSwhCIEXOYlS8uRDMMgzge5BRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Zhou <tao.zhou1@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.4 793/800] drm/amdgpu: check RAS irq existence for VCN/JPEG
Date: Sun, 16 Jul 2023 21:50:46 +0200
Message-ID: <20230716195007.569745397@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tao Zhou <tao.zhou1@amd.com>

commit 4ff96bcc0d40b66bf3ddd6010830e9a4f9b85d53 upstream

No RAS irq is allowed.

Signed-off-by: Tao Zhou <tao.zhou1@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c |    3 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c  |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c
@@ -251,7 +251,8 @@ int amdgpu_jpeg_ras_late_init(struct amd
 
 	if (amdgpu_ras_is_supported(adev, ras_block->block)) {
 		for (i = 0; i < adev->jpeg.num_jpeg_inst; ++i) {
-			if (adev->jpeg.harvest_config & (1 << i))
+			if (adev->jpeg.harvest_config & (1 << i) ||
+			    !adev->jpeg.inst[i].ras_poison_irq.funcs)
 				continue;
 
 			r = amdgpu_irq_get(adev, &adev->jpeg.inst[i].ras_poison_irq, 0);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
@@ -1191,7 +1191,8 @@ int amdgpu_vcn_ras_late_init(struct amdg
 
 	if (amdgpu_ras_is_supported(adev, ras_block->block)) {
 		for (i = 0; i < adev->vcn.num_vcn_inst; i++) {
-			if (adev->vcn.harvest_config & (1 << i))
+			if (adev->vcn.harvest_config & (1 << i) ||
+			    !adev->vcn.inst[i].ras_poison_irq.funcs)
 				continue;
 
 			r = amdgpu_irq_get(adev, &adev->vcn.inst[i].ras_poison_irq, 0);


