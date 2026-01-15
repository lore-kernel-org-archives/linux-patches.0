Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DCB3B8D5F;
	Thu, 15 Jan 2026 17:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498569; cv=none; b=HQIIO36CiwZAusBD3VCihfyuK4NFKAbSl3iJWrdeX7qmeUcqn6vcvEQgTGFI/BFIx34TqK4djGXUzGiw+7d5lBghmrQVTD1p1FDp0zo6yDDyuoYyp5Ccp3x6XiEXtIHG8Dh6KNTb6H3m5pNLdmakV3aeI9l9VPM6SLuzJWc8Cyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498569; c=relaxed/simple;
	bh=7Jizwr6EYJEZyISnnN2ihaINrXS3GUtx0oS96yf/Km0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pBPEk1jZRrxWVYJv72GD9IN5p2WYgUmawrU342KCBxT4mG39PwKF/fhoHaK61rgoBbGHjdYoP5WaP1evwYLmup1U+1u3zAjnXu5MGhrp2zBf5u+V+CIJ6EWYKnYIThI8M7WRjdDA2QYc0R/v0JJm+jjsKGqpiZQfyYtmyEdQUCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wtd4+dI+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wtd4+dI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B94AC19425;
	Thu, 15 Jan 2026 17:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498568;
	bh=7Jizwr6EYJEZyISnnN2ihaINrXS3GUtx0oS96yf/Km0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wtd4+dI+1l5Mu0UCjJ2Co2R1ormQmG4+8MVFcTn3++tnQXYDO0GzpxdT7tOW60j0Q
	 mCQW2BaSFHdcGCgQE7FFMkVVtREfSq+sBdWwUy68eUxYL/qS/n2qshwbyKSig8uyHv
	 bXZAbPaNuEw09Xg2DuI0cjBU/MAStnvM3wnw3cTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Takashi Iwai <tiwai@suse.de>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 477/554] ASoC: stm: stm32_sai_sub: Convert to platform remove callback returning void
Date: Thu, 15 Jan 2026 17:49:03 +0100
Message-ID: <20260115164303.569810160@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1571,7 +1571,7 @@ err_unprepare_pclk:
 	return ret;
 }
 
-static int stm32_sai_sub_remove(struct platform_device *pdev)
+static void stm32_sai_sub_remove(struct platform_device *pdev)
 {
 	struct stm32_sai_sub_data *sai = dev_get_drvdata(&pdev->dev);
 
@@ -1579,8 +1579,6 @@ static int stm32_sai_sub_remove(struct p
 	snd_dmaengine_pcm_unregister(&pdev->dev);
 	snd_soc_unregister_component(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -1630,7 +1628,7 @@ static struct platform_driver stm32_sai_
 		.pm = &stm32_sai_sub_pm_ops,
 	},
 	.probe = stm32_sai_sub_probe,
-	.remove = stm32_sai_sub_remove,
+	.remove_new = stm32_sai_sub_remove,
 };
 
 module_platform_driver(stm32_sai_sub_driver);


