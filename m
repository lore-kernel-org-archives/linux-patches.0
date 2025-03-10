Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B55E1B395F;
	Mon, 10 Mar 2025 18:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630548; cv=none; b=eOZ4VishOYda5INDg0vkqVOU7wWgqKok+ydLoLS87Whfr52LFE/vqyiFug261ksT5H7Zo9tK+Q8LuSPFLLu5kBcSCQ5LIWBMjQKHHgxmB4Quc1XZb4xTJlOw1FgwzWnLWEEs1hVgR9kvuoiaIa4kmzgTnaA1doIzl0CkZpUbg84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630548; c=relaxed/simple;
	bh=R9ydNzQz7gndgdRH5TRTH6jaW3ekFff6+G68y3pZwvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aTAbjEBSuGUnCEGtV0pmVJkw1dTom1zwb/VtG08nyX4x1FVMLs/LGNUthoXx2BKCdPbnRM4WmciiJZn0JVR3uY112tiBXGcK/4RfB1g4xObz3uU0v0AR0IMDBWhidShHZ7AXFn1KL5f3gEXg1XqkQpWHltLYdyNQS0c8UfwDWR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6lODSxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6lODSxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A79AC4CEE5;
	Mon, 10 Mar 2025 18:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630548;
	bh=R9ydNzQz7gndgdRH5TRTH6jaW3ekFff6+G68y3pZwvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6lODSxd9UpPS/6f+dy3i857LeDe8v0gL5t1p0sCNyVo6AccMwgcfbaZxClBUvdkR
	 xFDw5/mgBlpI+GuXex3kwX0dopYDpHTocyR2PKZx43qCMOyib27uXbF5HoQBPfugr3
	 or+TEB2mySLFs6NhdbCntaHHGPDTK+v9cZez0dpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 451/620] soc/mediatek: mtk-devapc: Convert to platform remove callback returning void
Date: Mon, 10 Mar 2025 18:04:57 +0100
Message-ID: <20250310170603.393582044@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 552726456fa2f..da075918424d3 100644
--- a/drivers/soc/mediatek/mtk-devapc.c
+++ b/drivers/soc/mediatek/mtk-devapc.c
@@ -285,18 +285,16 @@ static int mtk_devapc_probe(struct platform_device *pdev)
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



