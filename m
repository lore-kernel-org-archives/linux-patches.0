Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AE2BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB19C433A1;
	Tue,  7 Mar 2023 18:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215252;
	bh=6a4tawKrlqKX9aM44ALDeOQNJcx+i17BeLx7xTO4vzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ESJf4O5mAOFzVP0CW8XwMYXt7bcjmX3HIt+6m8HVSf7Fa0l/elHVaE+F22OvwQGr
	 F7eezY1V/NFtqkccaKod04jRaepWBmd+lThyuRcJ9wziWTjwRW9xL6z51k96+7vhX1
	 ru266m0zWqFIYdzVaNHEaDtR6utVbWZ9wcnR0Mok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 201/567] drm/msm/dsi: Allow 2 CTRLs on v2.5.0
Date: Tue,  7 Mar 2023 17:58:57 +0100
Message-Id: <20230307165914.634110740@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 1ae654ded7c5a19dc13f57a4fe4434fef879b6f9 ]

v2.5.0 support was originally added for SC7280, but this hw is also
present on SM8350, which has one more DSI host. Bump up the dsi count
and fill in the register of the secondary host to allow it to probe.

This should not have any adverse effects on SC7280, as the secondary
CTRL will only be touched if it's defined, anyway.

Fixes: 65c391b31994 ("drm/msm/dsi: Add DSI support for SC7280")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/519513/
Link: https://lore.kernel.org/r/20230120210101.2146852-1-konrad.dybcio@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_cfg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_cfg.c b/drivers/gpu/drm/msm/dsi/dsi_cfg.c
index ce3901439c69c..68a3f8fea9fe6 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_cfg.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_cfg.c
@@ -209,8 +209,8 @@ static const struct msm_dsi_config sc7280_dsi_cfg = {
 	},
 	.bus_clk_names = dsi_sc7280_bus_clk_names,
 	.num_bus_clks = ARRAY_SIZE(dsi_sc7280_bus_clk_names),
-	.io_start = { 0xae94000 },
-	.num_dsi = 1,
+	.io_start = { 0xae94000, 0xae96000 },
+	.num_dsi = 2,
 };
 
 static const struct msm_dsi_host_cfg_ops msm_dsi_v2_host_ops = {
-- 
2.39.2



