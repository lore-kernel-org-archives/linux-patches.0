Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE7C4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61737C433EF;
	Wed, 15 Mar 2023 12:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678884120;
	bh=8Wvl78oYKTDixm6CaR2PVovQWWqAXwBl1pvUdz+zKFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wrBR51+E5vcZ79tw+DqZ30BczDh5tKY1Rg0EhC1dafCrFn8vNdhBWl4WTGUCQDE9t
	 v2riuaFxD62OMuKgb79Cbe0RvsBHi+JwUv3Tjr1fwVyChp8reVCR/i9Sajotwj356h
	 fd/2T8MrhEhJbM9OR/DH1yhkZIOTtwxv355Nbfo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Veerabadhran Gopalakrishnan <veerabadhran.gopalakrishnan@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 115/141] drm/amdgpu/soc21: Add video cap query support for VCN_4_0_4
Date: Wed, 15 Mar 2023 13:13:38 +0100
Message-Id: <20230315115743.500356691@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Veerabadhran Gopalakrishnan <veerabadhran.gopalakrishnan@amd.com>

[ Upstream commit 6ce2ea07c5ff0a8188eab0e5cd1f0e4899b36835 ]

Added the video capability query support for VCN version 4_0_4

Signed-off-by: Veerabadhran Gopalakrishnan <veerabadhran.gopalakrishnan@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/soc21.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc21.c b/drivers/gpu/drm/amd/amdgpu/soc21.c
index e51a7bdb1eb75..3d938b52178e3 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -110,6 +110,7 @@ static int soc21_query_video_codecs(struct amdgpu_device *adev, bool encode,
 	switch (adev->ip_versions[UVD_HWIP][0]) {
 	case IP_VERSION(4, 0, 0):
 	case IP_VERSION(4, 0, 2):
+	case IP_VERSION(4, 0, 4):
 		if (adev->vcn.harvest_config & AMDGPU_VCN_HARVEST_VCN0) {
 			if (encode)
 				*codecs = &vcn_4_0_0_video_codecs_encode_vcn1;
-- 
2.39.2



