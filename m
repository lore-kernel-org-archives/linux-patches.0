Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A3F268C66;
	Tue,  8 Apr 2025 12:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116016; cv=none; b=KwEhq4m0M2cfq5QJTTb+1aak4VJN6fGgAIMAF58tYtDid2BTIZnINBDbLU86UJhSenrqeuty1AlqDxCXxCa2xhYJj0gd7FRd1fkV7lFmNvZHXNjKGURgEFB4iU778Wt2WXpOM2CbaFaSK/OplqOKPamPFtPLzv2IipzNifMtm7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116016; c=relaxed/simple;
	bh=u91TgpPDZExhg0i7mpctC+iTDHWq3DN3xnu1mdVoK9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZiKnFV2xUZRJ0S/jrvhxWGq9wkGMDxIDjbEnnsfKSbKuUqWIwsxWoeVR0En90gJn8MTvd+7z1+BoTKOtE0bSPTpjU6FuJgYz33fBfaSFYtK9U5XGYUMIGtO6HM4U5VLFr6iQ2WBqD/vSurNaiJhxlbou8/v1FfXOnaDGWvf4lDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6KaTnSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6KaTnSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE5FC4CEE5;
	Tue,  8 Apr 2025 12:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116015;
	bh=u91TgpPDZExhg0i7mpctC+iTDHWq3DN3xnu1mdVoK9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T6KaTnSr2M04mqTlocapUT2XAy2o8g2n4WdAQUwmD6DLnuL/a3961Np2pdsf6tF2S
	 ZzzmxNYau84uHk7IJmDRTmZI92UgJrXGG0ssaPsNwxSqzdOosn5f6zySpkNJHdWsxL
	 oVKb89Qv9X5dFnb/c+W0KBcbK6OvmasrJhIPKSSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Owens <daowens01@gmail.com>,
	Romain Naour <romain.naour@smile.fr>,
	Robert Nelson <robertcnelson@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Tony Lindgren <tony@atomide.com>
Subject: [PATCH 6.1 188/204] mmc: sdhci-omap: Disable MMC_CAP_AGGRESSIVE_PM for eMMC/SD
Date: Tue,  8 Apr 2025 12:51:58 +0200
Message-ID: <20250408104825.829707880@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulf Hansson <ulf.hansson@linaro.org>

commit 49d162635151d0dd04935070d7cf67137ab863aa upstream.

We have received reports about cards can become corrupt related to the
aggressive PM support. Let's make a partial revert of the change that
enabled the feature.

Reported-by: David Owens <daowens01@gmail.com>
Reported-by: Romain Naour <romain.naour@smile.fr>
Reported-by: Robert Nelson <robertcnelson@gmail.com>
Tested-by: Robert Nelson <robertcnelson@gmail.com>
Fixes: 3edf588e7fe0 ("mmc: sdhci-omap: Allow SDIO card power off and enable aggressive PM")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20250312121712.1168007-1-ulf.hansson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-omap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/sdhci-omap.c
+++ b/drivers/mmc/host/sdhci-omap.c
@@ -1340,8 +1340,8 @@ static int sdhci_omap_probe(struct platf
 	/* R1B responses is required to properly manage HW busy detection. */
 	mmc->caps |= MMC_CAP_NEED_RSP_BUSY;
 
-	/* Allow card power off and runtime PM for eMMC/SD card devices */
-	mmc->caps |= MMC_CAP_POWER_OFF_CARD | MMC_CAP_AGGRESSIVE_PM;
+	/*  Enable SDIO card power off. */
+	mmc->caps |= MMC_CAP_POWER_OFF_CARD;
 
 	ret = sdhci_setup_host(host);
 	if (ret)


