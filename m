Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABB963BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212FAC433D2;
	Mon, 20 Feb 2023 13:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901564;
	bh=R3HKuJABYKwoQftJOBb4X6UcJr6mq7bO3rodLXAVxCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kn2aQovoUhcwtcU8nFavJPWU+qEuJtzp5N8Go+9eNwijxsxmAIs1OLflMIXYx/yri
	 lVV4zXIPTH1bKPZpvZWaaaaIv+Tk8Wtu7SD1LP7jOtBwB4VPFqegVZ0ZFHd/Uf/IrR
	 9xcVkXxjjMm4HjV+wqgt6gVzo6TQWXIs77nSEYTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Quan <evan.quan@amd.com>,
	Feifei Xu <Feifei.Xu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/118] drm/amdgpu: enable HDP SD for gfx 11.0.3
Date: Mon, 20 Feb 2023 14:35:53 +0100
Message-Id: <20230220133601.928242640@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit bb25849c0fa550b26cecc9c476c519a927c66898 ]

Enable HDP clock gating control for gfx 11.0.3.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/soc21.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc21.c b/drivers/gpu/drm/amd/amdgpu/soc21.c
index 9bc9852b9cda9..230e15fed755c 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -643,7 +643,8 @@ static int soc21_common_early_init(void *handle)
 			AMD_CG_SUPPORT_GFX_CGCG |
 			AMD_CG_SUPPORT_GFX_CGLS |
 			AMD_CG_SUPPORT_REPEATER_FGCG |
-			AMD_CG_SUPPORT_GFX_MGCG;
+			AMD_CG_SUPPORT_GFX_MGCG |
+			AMD_CG_SUPPORT_HDP_SD;
 		adev->pg_flags = AMD_PG_SUPPORT_VCN |
 			AMD_PG_SUPPORT_VCN_DPG |
 			AMD_PG_SUPPORT_JPEG;
-- 
2.39.0



