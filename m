Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4AC11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD1EC433C8;
	Mon, 11 Sep 2023 15:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444571;
	bh=nohYH4mHOiNFabx7P/FNrG5z7GAPR2Z27JptxtyoSyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OOmxJxmEPNIQ1S8SEyqVhawow6/b5j1Y2PlhSa2uy0Ihvy1P+CfdYOTa7L5XnoN/M
	 BDKOHbe2bS6dW+BesH2S7x5Bnbw4kbWgWprjeU7eG5WtZIYmh85NHYvXCacj2tqqLj
	 4qD1+kFct5e2CYxpX0wdUow7I+BvoGmFA6JiGaAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jane Jian <Jane.Jian@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/600] drm/amd/smu: use AverageGfxclkFrequency* to replace previous GFX Curr Clock
Date: Mon, 11 Sep 2023 15:41:12 +0200
Message-ID: <20230911134634.753871802@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f7ac488a3da20..503e844baede2 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -1305,7 +1305,7 @@ static ssize_t smu_v13_0_0_get_gpu_metrics(struct smu_context *smu,
 	gpu_metrics->average_vclk1_frequency = metrics->AverageVclk1Frequency;
 	gpu_metrics->average_dclk1_frequency = metrics->AverageDclk1Frequency;
 
-	gpu_metrics->current_gfxclk = metrics->CurrClock[PPCLK_GFXCLK];
+	gpu_metrics->current_gfxclk = gpu_metrics->average_gfxclk_frequency;
 	gpu_metrics->current_socclk = metrics->CurrClock[PPCLK_SOCCLK];
 	gpu_metrics->current_uclk = metrics->CurrClock[PPCLK_UCLK];
 	gpu_metrics->current_vclk0 = metrics->CurrClock[PPCLK_VCLK_0];
-- 
2.40.1



