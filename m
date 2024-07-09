Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE3715886A;
	Tue,  9 Jul 2024 11:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524035; cv=none; b=u4HKnsfPuqglGNmeFeqHAaUZrbhi9jr+kMohAZc8kO0ll1QIq26Ylua0CHMVoV7X8h0TSJ0QcGi5NIWlj5Cj0N+/9Ea5n581aTHmSDUasGF2+Udk0/txpJy9PE5sNXl4u7TgEInOv3ygHl7b4PwqqzEboClVN7Yy882FWrX8Muk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524035; c=relaxed/simple;
	bh=Pqrtx7cJ36F32RxIlvOSFzp1SKx4u22xoVAbV5h6LCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Syw7QRWDR15pkC7UppNfug2zuxaeWlXOjY2Hn2Aq0BDm2O6RRSuywxVWvCnsJt5NaR9xCH1gzxEpz+7V9UZGYa9k7S0niMKoi/XoZmh3foKvVRicpOb0p7NwYtaNI1BoZ2dMvwnotYRionWjzdl4qYfF1C8wqGcxBLf63N/+yDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FdIvYV4o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FdIvYV4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95863C3277B;
	Tue,  9 Jul 2024 11:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524035;
	bh=Pqrtx7cJ36F32RxIlvOSFzp1SKx4u22xoVAbV5h6LCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FdIvYV4ouhndiBdv8E0M7EkVzHvMIJMrz+eGs0K2ocDHUHWaCa1o2HpCaSryIs8J2
	 L1b7BjZ+SeTCFo/Rda0JBeG6pwCtX4ZabWldi464XAB7eRkkWSHIHx+WPA6TWTJZdf
	 fwzaMjoM2hN42S9DdcnegudHwQkGlVftl3MFnQnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julien Panis <jpanis@baylibre.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 049/197] thermal/drivers/mediatek/lvts_thermal: Check NULL ptr on lvts_data
Date: Tue,  9 Jul 2024 13:08:23 +0200
Message-ID: <20240709110710.861758056@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julien Panis <jpanis@baylibre.com>

[ Upstream commit a1191a77351e25ddf091bb1a231cae12ee598b5d ]

Verify that lvts_data is not NULL before using it.

Signed-off-by: Julien Panis <jpanis@baylibre.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20240502-mtk-thermal-lvts-data-v1-1-65f1b0bfad37@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/mediatek/lvts_thermal.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/thermal/mediatek/lvts_thermal.c b/drivers/thermal/mediatek/lvts_thermal.c
index 6b9422bd8795d..25f836c00e226 100644
--- a/drivers/thermal/mediatek/lvts_thermal.c
+++ b/drivers/thermal/mediatek/lvts_thermal.c
@@ -1250,6 +1250,8 @@ static int lvts_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	lvts_data = of_device_get_match_data(dev);
+	if (!lvts_data)
+		return -ENODEV;
 
 	lvts_td->clk = devm_clk_get_enabled(dev, NULL);
 	if (IS_ERR(lvts_td->clk))
-- 
2.43.0



