Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A4EFBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3BEC433D2;
	Mon, 15 May 2023 17:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170551;
	bh=WPRvh9EdTZrvcrIOkKXhG/b7YF90yvizuQqLRz7qAnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P9JV44YE1AwDuCPddXE58Ixcdtghr+hpldqwseQtTbSIfB07NbpsFF7C2o+p7QLad
	 vRnUaO5FAaA56ReKfoxvCbnbNgWxte11+bXY+U2EOdimTAHsmX9JczoNv1kjpFQMG0
	 XpASPxEbFc4vIy/VBV2gfv0qVcPrUJWe/W4ubUEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 166/239] drm/amdgpu: fix an amdgpu_irq_put() issue in gmc_v9_0_hw_fini()
Date: Mon, 15 May 2023 18:27:09 +0200
Message-Id: <20230515161726.655043357@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hamza Mahfooz <hamza.mahfooz@amd.com>

commit 922a76ba31adf84e72bc947267385be420c689ee upstream.

As made mention of in commit 08c677cb0b43 ("drm/amdgpu: fix
amdgpu_irq_put call trace in gmc_v10_0_hw_fini") and commit 13af556104fa
("drm/amdgpu: fix amdgpu_irq_put call trace in gmc_v11_0_hw_fini"). It
is meaningless to call amdgpu_irq_put() for gmc.ecc_irq. So, remove it
from gmc_v9_0_hw_fini().

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2522
Fixes: 3029c855d79f ("drm/amdgpu: Fix desktop freezed after gpu-reset")
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -1898,7 +1898,6 @@ static int gmc_v9_0_hw_fini(void *handle
 	if (adev->mmhub.funcs->update_power_gating)
 		adev->mmhub.funcs->update_power_gating(adev, false);
 
-	amdgpu_irq_put(adev, &adev->gmc.ecc_irq, 0);
 	amdgpu_irq_put(adev, &adev->gmc.vm_fault, 0);
 
 	return 0;


