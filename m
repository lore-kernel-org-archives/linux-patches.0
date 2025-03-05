Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B296ADD;
	Wed,  5 Mar 2025 17:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197101; cv=none; b=FD3GcAA8WP2N8tJ/XW9cGn38/7+NStScXP5yf/w0IJZR3XZsMk+dupS06v/NDsyqcuYGzngnasdW34dJMgCJcKK0I1DkaX3nepHtGlWnuzWpYig1vWNjnUNkeOLRMkvSVugQztOnW5VsR0BB8ILRtMY6jYm/ooXCNzVZ5JY5k6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197101; c=relaxed/simple;
	bh=CAGD6PEVIOi1fteZqr8xc5KOAkQE8jU/lzp0/cj1YgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XdCOosV94N+wagnMuIi8qEgJM/XA1Ls0nvLZpFkg2t/N3YnkXVnoCCUNbz01DZWSt9xmoX1nu4KWuPrA716CLKtaLskSALW5mdCJMudXNYc1/Xiw7NVmFrV/ztkmGWtq02u5Gbc9LkEYaOfEraClH9yy9DTHs3ig3Zh2BgHpCfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iuLjLYuJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iuLjLYuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59934C4CED1;
	Wed,  5 Mar 2025 17:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197100;
	bh=CAGD6PEVIOi1fteZqr8xc5KOAkQE8jU/lzp0/cj1YgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iuLjLYuJeBNAPrO5C7GK1sQWOawRsiTnmzsGMy1EjX/IL3kkAnP29L1BplJNV5P9h
	 uNmydBgFhaiF7X6tKRIv55EWIcUu+sIryw9d1YrfXxo2Q4Z0DVGnnesXrSWj4LAZZt
	 0etcVmQsSsrKHELMi/pgNRTpx5GY+kb8kjrkiTts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/176] soc/mediatek: mtk-devapc: Convert to platform remove callback returning void
Date: Wed,  5 Mar 2025 18:46:41 +0100
Message-ID: <20250305174506.753736943@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit a129ac3555c0dca6f04ae404dc0f0790656587fb ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.
To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new() which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230925095532.1984344-15-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Stable-dep-of: c9c0036c1990 ("soc: mediatek: mtk-devapc: Fix leaking IO map on driver remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-devapc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/mediatek/mtk-devapc.c b/drivers/soc/mediatek/mtk-devapc.c
index c72273aae7c64..226a79f43492f 100644
--- a/drivers/soc/mediatek/mtk-devapc.c
+++ b/drivers/soc/mediatek/mtk-devapc.c
@@ -300,18 +300,16 @@ static int mtk_devapc_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int mtk_devapc_remove(struct platform_device *pdev)
+static void mtk_devapc_remove(struct platform_device *pdev)
 {
 	struct mtk_devapc_context *ctx = platform_get_drvdata(pdev);
 
 	stop_devapc(ctx);
-
-	return 0;
 }
 
 static struct platform_driver mtk_devapc_driver = {
 	.probe = mtk_devapc_probe,
-	.remove = mtk_devapc_remove,
+	.remove_new = mtk_devapc_remove,
 	.driver = {
 		.name = "mtk-devapc",
 		.of_match_table = mtk_devapc_dt_match,
-- 
2.39.5



