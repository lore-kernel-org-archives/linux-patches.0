Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3D86FBE
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83799C433C1;
	Wed, 30 Nov 2022 18:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833662;
	bh=be7RItbymvFf9t9+XrPeDGdWk6wnSf3Lociabth5Pj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8zz3CZUCRuWJ2Dymon0+HGjuaXwvPsmdVlTjUebpj2v72J8i7ix+HlTJYfuDSQAA
	 /ltmWIjg0jPBZf3km+ESuCsfuycVp8SwBgktaaxRQK0MVrvCMjpG690b1TpVkpEwkv
	 khBbJ4IqNuw6KIs6seCLwsyDor9OFNRovIlIZCvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guchun Chen <guchun.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 177/206] drm/amdgpu: disable BACO support on more cards
Date: Wed, 30 Nov 2022 19:23:49 +0100
Message-Id: <20221130180537.526328168@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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

[ Upstream commit 192039f12233c9063d040266e7c98188c7c89dec ]

Otherwise, some unexpected PCIE AER errors will be observed
in runtime suspend/resume cycle.

Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index ca6fa133993c..82a8c184526d 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -368,6 +368,10 @@ static void sienna_cichlid_check_bxco_support(struct smu_context *smu)
 		    ((adev->pdev->device == 0x73BF) &&
 		    (adev->pdev->revision == 0xCF)) ||
 		    ((adev->pdev->device == 0x7422) &&
+		    (adev->pdev->revision == 0x00)) ||
+		    ((adev->pdev->device == 0x73A3) &&
+		    (adev->pdev->revision == 0x00)) ||
+		    ((adev->pdev->device == 0x73E3) &&
 		    (adev->pdev->revision == 0x00)))
 			smu_baco->platform_support = false;
 
-- 
2.35.1



