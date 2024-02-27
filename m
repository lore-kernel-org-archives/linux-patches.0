Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8A613A26F;
	Tue, 27 Feb 2024 14:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042970; cv=none; b=DPK3/qdH97vD/otbxh8JHX6aKGFp2u60qkS+DjVivRE9sLomxRF1o4J54YpOg5/uqVLeZVr1g2l0wfR1gUIBcCDubMQsHdIhiLO+9CP9yuPf0u5J4dcP3XeW8eVa112WbzKg9N4L8MC0K2e89tc9yBdwcwnavv81hIeaJU2u7MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042970; c=relaxed/simple;
	bh=thprR5L4e98Z4wTBgl5+p9rf63ccWm8MYxctGbxd6HA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hv+EyLCdVUR10QFpc//0hdXBFaYSc/o+CW/IZlLMbsBIQi4afNv1G49Nho3fISOMUjJXrVLV7q6X3R+cyTAS2TXM3gNcQMuOr7SNFKBBmxngvskGK4ny8fJWS/n4Nj029ey+mCs193Vh93I5JqNv4PlS1vqpYfLjBrKHinl6fB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+VuVHhJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+VuVHhJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B84C433C7;
	Tue, 27 Feb 2024 14:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042969;
	bh=thprR5L4e98Z4wTBgl5+p9rf63ccWm8MYxctGbxd6HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r+VuVHhJJ5h/u0qeMOCxpZek8hSzZo00j/t9JAGn+qB9MH1RJoqEKWaKdP1/pEoEC
	 bcrv9L1Ou/PBop0Hlnr/dzvxO2RpzEUsyJcFspOyjyOYV/3Nytddp6RyeoSQ4HQTBG
	 LlcYpBoAFBrjAJN5AVnd7txpSLXI0OY1Hb64nv40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cercueil <paul@crapouillou.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 158/245] mmc: mxc: Use the new PM macros
Date: Tue, 27 Feb 2024 14:25:46 +0100
Message-ID: <20240227131620.349480231@linuxfoundation.org>
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

[ Upstream commit 2cdbd92c2d1dff07ad56c39f5857ee644bbd2c8a ]

Use DEFINE_SIMPLE_DEV_PM_OPS() instead of the SIMPLE_DEV_PM_OPS()
macro, along with using pm_sleep_ptr() as this driver doesn't handle
runtime PM.

This makes it possible to remove the #ifdef CONFIG_PM guard around
the suspend/resume functions.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 18ab69c8ca56 ("Input: iqs269a - do not poll during suspend or resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mxcmmc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index 97227ad717150..b5f65f39ced1c 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -1185,7 +1185,6 @@ static int mxcmci_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM_SLEEP
 static int mxcmci_suspend(struct device *dev)
 {
 	struct mmc_host *mmc = dev_get_drvdata(dev);
@@ -1212,9 +1211,8 @@ static int mxcmci_resume(struct device *dev)
 
 	return ret;
 }
-#endif
 
-static SIMPLE_DEV_PM_OPS(mxcmci_pm_ops, mxcmci_suspend, mxcmci_resume);
+DEFINE_SIMPLE_DEV_PM_OPS(mxcmci_pm_ops, mxcmci_suspend, mxcmci_resume);
 
 static struct platform_driver mxcmci_driver = {
 	.probe		= mxcmci_probe,
@@ -1222,7 +1220,7 @@ static struct platform_driver mxcmci_driver = {
 	.driver		= {
 		.name		= DRIVER_NAME,
 		.probe_type	= PROBE_PREFER_ASYNCHRONOUS,
-		.pm	= &mxcmci_pm_ops,
+		.pm	= pm_sleep_ptr(&mxcmci_pm_ops),
 		.of_match_table	= mxcmci_of_match,
 	}
 };
-- 
2.43.0



