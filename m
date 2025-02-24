Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392D718E34A;
	Mon, 24 Feb 2025 14:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407941; cv=none; b=IDidx8eAB6KRVc1IX2LdIouTHBLbbrdvhgJhYzgecYDyLHFfnElAjVtXOOdK16Be0PK4XXvrpcIxo7GOIiEr2SHarkFGf1kjeZQWrLeEfcAxQNFKHdY6NFtEK+F67Wy4yTuthxL5IupTjZROB3rzJLOlTEOlvaEpcIYYx6A7sP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407941; c=relaxed/simple;
	bh=FopeIlChfvqR0fLLqaCTlQx8AWeHyTkxjwUWMBCd4Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p5VNdHs1OGZsO45aa0geCqsmL+tAE6ZRbwHes1lRKDTe76HNhKoreGovlFLlDoNtRAwNyWSANwJG1Gn8IboxRJM5qdG4XkjJu79zL8YVjEce2NHkDXWORBTaQVZRyNTqEVjkeLlsmjjHaiBjyX5IBCp4zw3yEdVAqhmTvQcdKis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=huVaT+Ug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="huVaT+Ug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDBEC4CEE6;
	Mon, 24 Feb 2025 14:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407941;
	bh=FopeIlChfvqR0fLLqaCTlQx8AWeHyTkxjwUWMBCd4Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=huVaT+UgOaTteRrocig0IBAfkNpzzRM8rgEd0pYIq4MkoLke+GwJRe22jrimfflEn
	 /j+uOJCvAhKqLZUQlVuSB48kLaB7F+Zfjjk4E1OuDivVnLNcy7xI/bZ46kF7B18CN9
	 DgzBNs5sbQ6cJ4n6CvEWN3kkP+1ZzFPeU878phgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/140] soc/mediatek: mtk-devapc: Convert to platform remove callback returning void
Date: Mon, 24 Feb 2025 15:34:12 +0100
Message-ID: <20250224142605.099208309@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0dfc1da9471cb..eb8f92f585882 100644
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



