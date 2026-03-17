Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A454F3EDADB;
	Tue, 17 Mar 2026 16:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766406; cv=none; b=aaiOmf/QypoLZWW1ulMdsyucbQPEA8ScUTERRpcmm78rK4u1FZqAElanRrz3fi0YuAEZ+bqn6rToyjhxHJpPrM3VKG+5dHULWo4QSlW949WRo+58+P9ESx/fvIXIr4uwLWFpamVijDPeQ0d+/59dmJ13tz3dbanWR0cPze+OyjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766406; c=relaxed/simple;
	bh=tYikkOo/XuJk7S/7esOMMKqRDVLFJmyvIRHpOsCXl60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tyFcVrOhfX0MjW193ww35Bo3k/qn4mk8UfdqKdrFVlOWqOHsg2pexD2pKDXlbW1egPHYQ5a4GP9xfn4C6yI53f+YxIYk99tG7QDngzcsiBYrkDFQDhgDgE38JeVNp1pbz+KqyTY1g1yjzQewWNdflidfbSN/IWZs7/FKx3hGDkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGmkPdQl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGmkPdQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B8CC4CEF7;
	Tue, 17 Mar 2026 16:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766406;
	bh=tYikkOo/XuJk7S/7esOMMKqRDVLFJmyvIRHpOsCXl60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pGmkPdQlK3ZCg2pZzJmttkuo2MHZchiXSUaQgZHFn88YkstUS7mTc6y2N/ro9gwj0
	 alLnUX2YljEABrGygtyS5y9CnLes5YSQ3eZsH8CBV8nZiIoD+ibVSlzUoP0Uv2jKKN
	 khL9xrJuqnY4mlP/xuIXyML09YIRgtVRQzXd33e4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.19 197/378] mmc: sdhci-brcmstb: use correct register offset for V1 pin_sel restore
Date: Tue, 17 Mar 2026 17:32:34 +0100
Message-ID: <20260317163014.251540604@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kamal Dasu <kamal.dasu@broadcom.com>

commit 79ad471530e0baef0dce991816013df55e401d9c upstream.

The restore path for SDIO_CFG_CORE_V1 was incorrectly using
SDIO_CFG_SD_PIN_SEL (offset 0x44) instead of SDIO_CFG_V1_SD_PIN_SEL
(offset 0x54), causing the wrong register to be written on resume.
The save path already uses the correct V1-specific offset. This
affects BCM7445 and BCM72116 platforms which use the V1 config core.

Fixes: b7e614802e3f ("mmc: sdhci-brcmstb: save and restore registers during PM")
Signed-off-by: Kamal Dasu <kamal.dasu@broadcom.com>
Cc: stable@vger.kernel.org
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-brcmstb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-brcmstb.c b/drivers/mmc/host/sdhci-brcmstb.c
index c9442499876c..57e45951644e 100644
--- a/drivers/mmc/host/sdhci-brcmstb.c
+++ b/drivers/mmc/host/sdhci-brcmstb.c
@@ -116,7 +116,7 @@ static void sdhci_brcmstb_restore_regs(struct mmc_host *mmc, enum cfg_core_ver v
 		writel(sr->boot_main_ctl, priv->boot_regs + SDIO_BOOT_MAIN_CTL);
 
 	if (ver == SDIO_CFG_CORE_V1) {
-		writel(sr->sd_pin_sel, cr + SDIO_CFG_SD_PIN_SEL);
+		writel(sr->sd_pin_sel, cr + SDIO_CFG_V1_SD_PIN_SEL);
 		return;
 	}
 
-- 
2.53.0



