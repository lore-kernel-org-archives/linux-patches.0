Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D4D33EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB472C433D2;
	Mon, 16 Jan 2023 15:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884631;
	bh=9S49RvK0Myy6KGTNRM2Bz2WXdLcMqxKuDPtAr1jYYAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xaYWXwwi8GyDcjfOXxJMEEs2J8jfjHvn60Hedx7M6zaznKPRmzt9rFDPrxJZys9jN
	 h744CC4WPg05f0JBI30GqOTugCDKUS/HxCMHPhmcx/wgun52JR7zx8HFgy0dUdf5KN
	 b1lKFQyra2nJ5X9LpCh4hbiYdiAFraztPtwkEr6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saleemkhan Jamadar <saleemkhan.jamadar@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Aaron Liu <aaron.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/183] drm/amdgpu: Enable pg/cg flags on GC11_0_4 for VCN
Date: Mon, 16 Jan 2023 16:50:03 +0100
Message-Id: <20230116154806.812464496@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Saleemkhan Jamadar <saleemkhan.jamadar@amd.com>

[ Upstream commit 2a0fe2ca6e9c9bf9c47a9f9f0d67c13281a13f8c ]

This enable VCN PG, CG and JPEG PG, CG

Signed-off-by: Saleemkhan Jamadar <saleemkhan.jamadar@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: e1d900df63ad ("drm/amdgpu: enable VCN DPG for GC IP v11.0.4")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/soc21.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc21.c b/drivers/gpu/drm/amd/amdgpu/soc21.c
index 26f1e4edb4d5..599ddc28d8e1 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -654,8 +654,11 @@ static int soc21_common_early_init(void *handle)
 		adev->external_rev_id = adev->rev_id + 0x20;
 		break;
 	case IP_VERSION(11, 0, 4):
-		adev->cg_flags = 0;
-		adev->pg_flags = 0;
+		adev->cg_flags = AMD_CG_SUPPORT_VCN_MGCG |
+			AMD_CG_SUPPORT_JPEG_MGCG;
+		adev->pg_flags = AMD_PG_SUPPORT_VCN |
+			AMD_PG_SUPPORT_GFX_PG |
+			AMD_PG_SUPPORT_JPEG;
 		adev->external_rev_id = adev->rev_id + 0x1;
 		break;
 
-- 
2.35.1



