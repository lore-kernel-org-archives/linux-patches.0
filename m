Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE5335BDB2;
	Fri,  9 Jan 2026 12:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963027; cv=none; b=u5bGByrBCcy5xa9ndrjyuXyvNdJdFj8LPdDyHS55lW6VWRHZ0cBkwF8SIv16hit1eV9eu43WY8ziRmguGWj9H8yfUrgFwAxzpn/Pjs+kESnomA3fKJPq6fV1wzbpIl25eUluOATnKH14OL8AWt5F9S/6iMYEYppHzYre40+EjBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963027; c=relaxed/simple;
	bh=wAKz5j7jCuUv2k7V0ONEfPx0jdxvGxEtLsb5lttMAfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kZtdz9EsTdD3vzvEiHjflcGp9kOVf0QTIcJDwS/NHlHBUL4HjUaHSG1CIOStPZxiObr2mckv7gFcFDHPinLstjr59/vNML7vrKRhzOuqGICBHN/jGLLi4ISsat0fn5ztX/7IbWKKZwSDYHcjNY7OIJldZiAL8hCjKJFltkIMsCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T0OdplOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T0OdplOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864BFC4CEF1;
	Fri,  9 Jan 2026 12:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963026;
	bh=wAKz5j7jCuUv2k7V0ONEfPx0jdxvGxEtLsb5lttMAfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T0OdplOzOEdXLQB0ooVV+5fJZrTsdzkN9P5wqehn6eLeGHM4uEJ28KPCHXDdXT4sG
	 G+4xDu5RdZPjybZHR7oYB6uR4rRyHW0PD2PoYynX7j/3e4pJmLDxjzM+LTkht49Fhb
	 sbCfwNaocShMGoh2MbLtpzL6AvH3ahObJMebNLtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Takashi Iwai <tiwai@suse.de>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 572/634] ASoC: stm: stm32_sai_sub: Convert to platform remove callback returning void
Date: Fri,  9 Jan 2026 12:44:10 +0100
Message-ID: <20260109112139.130729675@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit a3bd37e2e2bce4fb1757a940fa985d556662ba80 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Takashi Iwai <tiwai@suse.de>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20230315150745.67084-139-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 23261f0de094 ("ASoC: stm32: sai: fix OF node leak on probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/stm/stm32_sai_sub.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@ -1570,7 +1570,7 @@ err_unprepare_pclk:
 	return ret;
 }
 
-static int stm32_sai_sub_remove(struct platform_device *pdev)
+static void stm32_sai_sub_remove(struct platform_device *pdev)
 {
 	struct stm32_sai_sub_data *sai = dev_get_drvdata(&pdev->dev);
 
@@ -1578,8 +1578,6 @@ static int stm32_sai_sub_remove(struct p
 	snd_dmaengine_pcm_unregister(&pdev->dev);
 	snd_soc_unregister_component(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -1629,7 +1627,7 @@ static struct platform_driver stm32_sai_
 		.pm = &stm32_sai_sub_pm_ops,
 	},
 	.probe = stm32_sai_sub_probe,
-	.remove = stm32_sai_sub_remove,
+	.remove_new = stm32_sai_sub_remove,
 };
 
 module_platform_driver(stm32_sai_sub_driver);


