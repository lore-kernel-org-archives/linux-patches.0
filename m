Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484B113A26F;
	Tue, 27 Feb 2024 14:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042967; cv=none; b=oOhhGFei+E7Pr4Fz6fHhrxKrTB1EHi6zy5owVGbDhN4M9RG9lxXrk26hguXmX4MvTgZh7nd7l4iSkDwySaM74GJUxU1cg0QldV2jHSNh1lUyC+dBL7UNzhA8JEQC5oSe+0RnRrYfoBqy4vAbZ8Cm+tQ/j0qkl8qgdOb34JGzYFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042967; c=relaxed/simple;
	bh=za2jDYKUGxvZoaNh1DvPwW4OYFGeAWPlCILgnlwdXQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cz0IUKMFKvD3LNOOsb3dgaQ+OA4BZqhM2OcQ3Ah2QcU0sLk0Lrr0NdoRIAhKGk2ayZhHwBNhAp5xUsmjZli7/bWhPW28B/m65moTvgKbK9DpJvk4lM3GrvdpLADIk2me2UUqouyDzBy6im9MMmhUu1x8IFB3UHgRaUaMcMLtGuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GoKbtrMH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GoKbtrMH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9ABEC43394;
	Tue, 27 Feb 2024 14:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042967;
	bh=za2jDYKUGxvZoaNh1DvPwW4OYFGeAWPlCILgnlwdXQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GoKbtrMHkaqE/8SFyluEcbmaoJgjNiI31ArPA0JAa54EvE9sLgYhBOgHtwQKACnH0
	 LE4xoRDyaP7q/zzxMKC8i9hydE7ivO9NLpGVulFFBeWlDBaxuXHLsmvoWW15DY6Vja
	 7fVA3O/h6jVjfmqZzBjw1uHmLmFLHA8L+v+5g4PU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cercueil <paul@crapouillou.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 157/245] mmc: jz4740: Use the new PM macros
Date: Tue, 27 Feb 2024 14:25:45 +0100
Message-ID: <20240227131620.319375563@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit e0d64ecc621715e9c7807e952b68475c62bbf630 ]

 - Use DEFINE_SIMPLE_DEV_PM_OPS() instead of the SIMPLE_DEV_PM_OPS()
   macro. This makes it possible to remove the __maybe_unused flags
   on the callback functions.

 - Since we only have callbacks for suspend/resume, we can conditionally
   compile the dev_pm_ops structure for when CONFIG_PM_SLEEP is enabled;
   so use the pm_sleep_ptr() macro instead of pm_ptr().

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 18ab69c8ca56 ("Input: iqs269a - do not poll during suspend or resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/jz4740_mmc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/jz4740_mmc.c b/drivers/mmc/host/jz4740_mmc.c
index 8586447d4b4f2..ef3fe837b49d2 100644
--- a/drivers/mmc/host/jz4740_mmc.c
+++ b/drivers/mmc/host/jz4740_mmc.c
@@ -1133,17 +1133,17 @@ static int jz4740_mmc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static int __maybe_unused jz4740_mmc_suspend(struct device *dev)
+static int jz4740_mmc_suspend(struct device *dev)
 {
 	return pinctrl_pm_select_sleep_state(dev);
 }
 
-static int __maybe_unused jz4740_mmc_resume(struct device *dev)
+static int jz4740_mmc_resume(struct device *dev)
 {
 	return pinctrl_select_default_state(dev);
 }
 
-static SIMPLE_DEV_PM_OPS(jz4740_mmc_pm_ops, jz4740_mmc_suspend,
+DEFINE_SIMPLE_DEV_PM_OPS(jz4740_mmc_pm_ops, jz4740_mmc_suspend,
 	jz4740_mmc_resume);
 
 static struct platform_driver jz4740_mmc_driver = {
@@ -1153,7 +1153,7 @@ static struct platform_driver jz4740_mmc_driver = {
 		.name = "jz4740-mmc",
 		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
 		.of_match_table = of_match_ptr(jz4740_mmc_of_match),
-		.pm = pm_ptr(&jz4740_mmc_pm_ops),
+		.pm = pm_sleep_ptr(&jz4740_mmc_pm_ops),
 	},
 };
 
-- 
2.43.0



