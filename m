Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A6C1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DA0C433C8;
	Mon, 11 Sep 2023 14:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442473;
	bh=XK2pJ0tu36OttgdUCty2/wAOvIUdXUwg1FOpwaru6Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=seQGoh+jvXNYfuuhvo95LpYfztMm7o69QeGDCQJJC7UdwpS/f2Bimzqy8ltX055SR
	 0OdzFkqLBMkZ2J115IMd1jUH41Y+AiYTQ6ouZfOfLRMEdXVGLTtlv6MYJXvYBFdMHz
	 9ERRZl0U0tuaOS+iWcJ4sf+sQBkkm+dPNrna1UNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jane Jian <Jane.Jian@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 038/737] drm/amd/smu: use AverageGfxclkFrequency* to replace previous GFX Curr Clock
Date: Mon, 11 Sep 2023 15:38:17 +0200
Message-ID: <20230911134651.485709588@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jane Jian <Jane.Jian@amd.com>

[ Upstream commit 4a37c55b859a69f429bfa7fab4fc43ee470b60ed ]

Report current GFX clock also from average clock value as the original
CurrClock data is not valid/accurate any more as per FW team

Signed-off-by: Jane Jian <Jane.Jian@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index d7f09af2fb018..419a247dfbbf2 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -1323,7 +1323,7 @@ static ssize_t smu_v13_0_0_get_gpu_metrics(struct smu_context *smu,
 	gpu_metrics->average_vclk1_frequency = metrics->AverageVclk1Frequency;
 	gpu_metrics->average_dclk1_frequency = metrics->AverageDclk1Frequency;
 
-	gpu_metrics->current_gfxclk = metrics->CurrClock[PPCLK_GFXCLK];
+	gpu_metrics->current_gfxclk = gpu_metrics->average_gfxclk_frequency;
 	gpu_metrics->current_socclk = metrics->CurrClock[PPCLK_SOCCLK];
 	gpu_metrics->current_uclk = metrics->CurrClock[PPCLK_UCLK];
 	gpu_metrics->current_vclk0 = metrics->CurrClock[PPCLK_VCLK_0];
-- 
2.40.1



