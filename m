Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E217933EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F713C433EF;
	Mon, 16 Jan 2023 15:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884628;
	bh=JCMRyPwHT6S6S48XZwUaFaFghN65FGeJ6mT8jOCvCm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z54mivxhFxeBFyArGxFo5bOfKFvSTD7GtKP6/nbYygq+l+iXG0VYQmm6+6Po1q6Gx
	 AofLQdjSZOFlTtScZwJakCpR0H/8F1oloHCF+FHSQRKMX4znQqVTm1cWZH6rH1ySEp
	 0v6HAXEDRyaWpi9vfhj68ySp7OsP1eCfJwey48vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Aaron Liu <aaron.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/183] drm/amdgpu: add soc21 common ip block support for GC 11.0.4
Date: Mon, 16 Jan 2023 16:50:02 +0100
Message-Id: <20230116154806.763617188@linuxfoundation.org>
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

From: Yifan Zhang <yifan1.zhang@amd.com>

[ Upstream commit 311d52367d0a7985ee1132662bad46f09169eed2 ]

Add common soc21 ip block support for GC 11.0.4.

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: e1d900df63ad ("drm/amdgpu: enable VCN DPG for GC IP v11.0.4")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/soc21.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc21.c b/drivers/gpu/drm/amd/amdgpu/soc21.c
index f1913d879811..26f1e4edb4d5 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -653,6 +653,12 @@ static int soc21_common_early_init(void *handle)
 		}
 		adev->external_rev_id = adev->rev_id + 0x20;
 		break;
+	case IP_VERSION(11, 0, 4):
+		adev->cg_flags = 0;
+		adev->pg_flags = 0;
+		adev->external_rev_id = adev->rev_id + 0x1;
+		break;
+
 	default:
 		/* FIXME: not supported yet */
 		return -EINVAL;
-- 
2.35.1



