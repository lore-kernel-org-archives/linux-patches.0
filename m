Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640E046B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB60CC433D2;
	Mon, 16 Jan 2023 16:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886451;
	bh=z1wvUinEIXw7zwzQFl1VEaeCR8kX7OngFqVNw4BDvYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TMRkO4IeIuX8zCib6DSKbqZyZ2qvkNzKbMjCx5J6IHRta2/T6ub0ONPFLDiLEGxjA
	 UQIMfUnzbXeLhYflJvsuKaZ1QOHTXT8t784it26pHtaQdWf9iYg7PdN7bqHuwHCRWv
	 CT95ci2JZMfx+JWtrZwP7oCUJNkpIJDv5V6TlXWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Jingjin <wangjingjin1@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 435/658] ASoC: rockchip: pdm: Add missing clk_disable_unprepare() in rockchip_pdm_runtime_resume()
Date: Mon, 16 Jan 2023 16:48:43 +0100
Message-Id: <20230116154929.449378797@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 1707414cfa92..9f6cbaf3c0e9 100644
--- a/sound/soc/rockchip/rockchip_pdm.c
+++ b/sound/soc/rockchip/rockchip_pdm.c
@@ -368,6 +368,7 @@ static int rockchip_pdm_runtime_resume(struct device *dev)
 
 	ret = clk_prepare_enable(pdm->hclk);
 	if (ret) {
+		clk_disable_unprepare(pdm->clk);
 		dev_err(pdm->dev, "hclock enable failed %d\n", ret);
 		return ret;
 	}
-- 
2.35.1



