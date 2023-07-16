Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D988F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8992CC433C7;
	Sun, 16 Jul 2023 20:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538335;
	bh=vVHK+l8xYGF9jGwPGB2WW5EOJE1MaVr2s+z2utRCfcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=byeY7bo3cxevYsO8Ht3Z+egJnlGULXwtGVGn7Sh+hHZWATyLQgZO/PzaydvDhT7xA
	 R1/I9YfHGh/U1ZeStSbPe2HjnFaOBBLc4RhNd5cSh/RJaldLH/sz4XrBdvPXgIlMec
	 cYBwLd4bdDUJV4EuAfH8FktistBzMFk/NMjRXdq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 414/800] clk: mediatek: clk-mt8173-apmixedsys: Fix return value for of_iomap() error
Date: Sun, 16 Jul 2023 21:44:27 +0200
Message-ID: <20230716194958.703383649@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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
index 8c2aa8b0f39ea..c7adcfcc12e27 100644
--- a/drivers/clk/mediatek/clk-mt8173-apmixedsys.c
+++ b/drivers/clk/mediatek/clk-mt8173-apmixedsys.c
@@ -148,7 +148,7 @@ static int clk_mt8173_apmixed_probe(struct platform_device *pdev)
 
 	base = of_iomap(node, 0);
 	if (!base)
-		return PTR_ERR(base);
+		return -ENOMEM;
 
 	clk_data = mtk_alloc_clk_data(CLK_APMIXED_NR_CLK);
 	if (IS_ERR_OR_NULL(clk_data))
-- 
2.39.2



