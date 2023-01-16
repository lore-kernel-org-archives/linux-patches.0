Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174736FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC1DC433D2;
	Mon, 16 Jan 2023 17:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673889155;
	bh=NJ3egBCaytDsuzH7PX5b8qsmsCf8nLRqStSTw5U1Azc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jd0S1iLThdPppo2Wqg5us1vhs55t6rB3w5kJ5TvLuSchAU51fT5E0iwAuO1kPj5VA
	 G2w4dYQ4WfqLF1AmVfiLNo+Q3zZpt1axkH7DEDJQDPGhCYFrZnD2xXc+eZLzey4SQ+
	 a6pMq/nUejUvoH0M1tkEB8/4sWqTz/or7rpJpj44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Jingjin <wangjingjin1@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 250/338] ASoC: rockchip: pdm: Add missing clk_disable_unprepare() in rockchip_pdm_runtime_resume()
Date: Mon, 16 Jan 2023 16:52:03 +0100
Message-Id: <20230116154831.964136873@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang Jingjin <wangjingjin1@huawei.com>

[ Upstream commit ef0a098efb36660326c133af9b5a04a96a00e3ca ]

The clk_disable_unprepare() should be called in the error handling of
rockchip_pdm_runtime_resume().

Fixes: fc05a5b22253 ("ASoC: rockchip: add support for pdm controller")
Signed-off-by: Wang Jingjin <wangjingjin1@huawei.com>
Link: https://lore.kernel.org/r/20221205032802.2422983-1-wangjingjin1@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_pdm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/rockchip/rockchip_pdm.c b/sound/soc/rockchip/rockchip_pdm.c
index ad16c8310dd3..7dfd1e6b2c25 100644
--- a/sound/soc/rockchip/rockchip_pdm.c
+++ b/sound/soc/rockchip/rockchip_pdm.c
@@ -303,6 +303,7 @@ static int rockchip_pdm_runtime_resume(struct device *dev)
 
 	ret = clk_prepare_enable(pdm->hclk);
 	if (ret) {
+		clk_disable_unprepare(pdm->clk);
 		dev_err(pdm->dev, "hclock enable failed %d\n", ret);
 		return ret;
 	}
-- 
2.35.1



