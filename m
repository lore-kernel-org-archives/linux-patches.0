Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A44C2108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B781DC433D2;
	Mon, 24 Apr 2023 13:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343278;
	bh=f+RfwfcYOEofk3mFyHM16hFlSGfFoGNS42yTFlfIl4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wg6Ob4mAVgahNqqpMDgFiW6A6RU3+Ak1xABZhzqgOIllZHAS5eRAXEh6AmugkWBMY
	 A849WF5BmuLhnwsMfHFje/V/LySrOupgFtKNHUhhQKv5AJL4ifhVtpxBmUIFr1uqRG
	 20cWoL5DyzBCbElW2TCvRyx0B0XLtx5b1yoYOxW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhavya Kapoor <b-kapoor@ti.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 34/68] mmc: sdhci_am654: Set HIGH_SPEED_ENA for SDR12 and SDR25
Date: Mon, 24 Apr 2023 15:18:05 +0200
Message-Id: <20230424131128.975888004@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>
References: <20230424131127.653885914@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bhavya Kapoor <b-kapoor@ti.com>

commit 2265098fd6a6272fde3fd1be5761f2f5895bd99a upstream.

Timing Information in Datasheet assumes that HIGH_SPEED_ENA=1 should be
set for SDR12 and SDR25 modes. But sdhci_am654 driver clears
HIGH_SPEED_ENA register. Thus, Modify sdhci_am654 to not clear
HIGH_SPEED_ENA (HOST_CONTROL[2]) bit for SDR12 and SDR25 speed modes.

Fixes: e374e87538f4 ("mmc: sdhci_am654: Clear HISPD_ENA in some lower speed modes")
Signed-off-by: Bhavya Kapoor <b-kapoor@ti.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230317092711.660897-1-b-kapoor@ti.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci_am654.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -351,8 +351,6 @@ static void sdhci_am654_write_b(struct s
 		 */
 		case MMC_TIMING_SD_HS:
 		case MMC_TIMING_MMC_HS:
-		case MMC_TIMING_UHS_SDR12:
-		case MMC_TIMING_UHS_SDR25:
 			val &= ~SDHCI_CTRL_HISPD;
 		}
 	}


