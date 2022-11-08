Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF1D15CAD
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA631C433D7;
	Tue,  8 Nov 2022 13:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915738;
	bh=+MIp43ELtVsKBmsbjXvuCWEaUe1RgE6GKnlWRB6QD3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JRwRt+wOUEkNv5v+rYG7lSaJY8msC83/OZw3NJ/YMlJHh6PqcjYSBd3h1gfKzY0Yr
	 UCCvOmpYEElH+C3kRk+Z4f2RX7/OV4tNmaHd4I/qQ5enoqqwDTHpIfT6cJfizs4SxU
	 5cfTu+cCbBlZCvOQ5Qxa+lNDjc7sxBVoDEw8mXy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/118] mmc: sdhci-pci: Avoid comma separated statements
Date: Tue,  8 Nov 2022 14:38:48 +0100
Message-Id: <20221108133342.868021996@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

[ Upstream commit ba8734dfbe87b9dd68c9d525c0a3a52e8da42167 ]

Use semicolons.

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20210311181432.6385cd2b@xhacker.debian
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 9dc0033e4658 ("mmc: sdhci-pci-core: Disable ES for ASUS BIOS on Jasper Lake")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-pci-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-pci-core.c b/drivers/mmc/host/sdhci-pci-core.c
index a78b060ce847..422ea3a1817a 100644
--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -975,7 +975,7 @@ static int glk_emmc_probe_slot(struct sdhci_pci_slot *slot)
 		slot->host->mmc->caps2 |= MMC_CAP2_CQE;
 
 	if (slot->chip->pdev->device != PCI_DEVICE_ID_INTEL_GLK_EMMC) {
-		slot->host->mmc->caps2 |= MMC_CAP2_HS400_ES,
+		slot->host->mmc->caps2 |= MMC_CAP2_HS400_ES;
 		slot->host->mmc_host_ops.hs400_enhanced_strobe =
 						intel_hs400_enhanced_strobe;
 		slot->host->mmc->caps2 |= MMC_CAP2_CQE_DCMD;
-- 
2.35.1



