Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079DE1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69DCBC433C1;
	Wed, 23 Nov 2022 09:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195356;
	bh=8tovvFtYlQS7L70a2sddBlZdZaw4CVNxdFEtp/EZrPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mr458mA+06BLHcyx8/DXhCFPw5P4wYyyxngz28imu8o8YK+6GjBb3/uyKsdNugQWO
	 6aSyN0/+A/YgUYYQzGUV+HT25YQyrCpo2wGkAZBKdkC/dvzl6EgpJUvnptJmS3nv9K
	 ++CO1HyWPDlEdhFSlH7iOfP6u6ZlKtENuj+rJk68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guchun Chen <guchun.chen@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Evan Quan <evan.quan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/149] drm/amdgpu: disable BACO on special BEIGE_GOBY card
Date: Wed, 23 Nov 2022 09:50:14 +0100
Message-Id: <20221123084559.120060188@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guchun Chen <guchun.chen@amd.com>

[ Upstream commit 0c85c067c9d9d7a1b2cc2e01a236d5d0d4a872b5 ]

Still avoid intermittent failure.

Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Acked-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index 91026d0c1c79..45c815262200 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -317,7 +317,9 @@ static void sienna_cichlid_check_bxco_support(struct smu_context *smu)
 		if (((adev->pdev->device == 0x73A1) &&
 		    (adev->pdev->revision == 0x00)) ||
 		    ((adev->pdev->device == 0x73BF) &&
-		    (adev->pdev->revision == 0xCF)))
+		    (adev->pdev->revision == 0xCF)) ||
+		    ((adev->pdev->device == 0x7422) &&
+		    (adev->pdev->revision == 0x00)))
 			smu_baco->platform_support = false;
 
 	}
-- 
2.35.1



