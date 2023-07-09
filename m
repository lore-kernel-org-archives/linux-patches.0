Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4382522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A70C433C8;
	Sun,  9 Jul 2023 11:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902277;
	bh=jd8eh5mCHdapOFeuX/Ed9AEhjfgFASK5s6LaFY5u4Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2dbnczcSNwcamPtyewyk3K+27+lUSkBOV3KqnuOtlpeevl5VGUbK+ZIlYLmSlzV0B
	 QAN5+dzB3yjxXwb5dGIP7D3D6g99YHTWVAnXj2QHjsv3hysRTJ9y52WYc0rFHdio3k
	 RXAjcP+nZbJXzlfVsuPW0OTLlBisWBX95+9/gcbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 319/431] clk: mediatek: clk-mt8173-apmixedsys: Fix return value for of_iomap() error
Date: Sun,  9 Jul 2023 13:14:27 +0200
Message-ID: <20230709111458.658462883@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 3dc265b369ee61db999d6d1588e888eb21dc421e ]

The of_iomap() function returns NULL in case of error so usage of
PTR_ERR() is wrong!
Change that to return -ENOMEM in case of failure.

Fixes: 41138fbf876c ("clk: mediatek: mt8173: Migrate to platform driver and common probe")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230615122051.546985-3-angelogioacchino.delregno@collabora.com
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Markus Schneider-Pargmann <msp@baylibre.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt8173-apmixedsys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/mediatek/clk-mt8173-apmixedsys.c b/drivers/clk/mediatek/clk-mt8173-apmixedsys.c
index a56c5845d07a5..a335d076d3f28 100644
--- a/drivers/clk/mediatek/clk-mt8173-apmixedsys.c
+++ b/drivers/clk/mediatek/clk-mt8173-apmixedsys.c
@@ -92,7 +92,7 @@ static int clk_mt8173_apmixed_probe(struct platform_device *pdev)
 
 	base = of_iomap(node, 0);
 	if (!base)
-		return PTR_ERR(base);
+		return -ENOMEM;
 
 	clk_data = mtk_alloc_clk_data(CLK_APMIXED_NR_CLK);
 	if (IS_ERR_OR_NULL(clk_data))
-- 
2.39.2



