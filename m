Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D721364BA;
	Fri, 24 Nov 2023 18:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qYe6hCy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CF1C433C7;
	Fri, 24 Nov 2023 18:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851130;
	bh=gSjgBrteNljjN8p8PpKpjvxz4vvb5fPUBbBnrn6t2QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qYe6hCy2V6g71sHhgTLNr/lV9DxS06GCy7zvdpapaphR9XOBQxvjaLmbq42Nu68V4
	 acLxzTyZYOXClPQ262uTCH9bIikQ9EWyKvOtK7Y3leteDddEbDlcMisoX++qKY3zWU
	 pGLHej0wxQx07DYe4YfMFZa0H+aZYfMD+UNI/kFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Yadav <n-yadav@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.5 301/491] mmc: sdhci_am654: fix start loop index for TAP value parsing
Date: Fri, 24 Nov 2023 17:48:57 +0000
Message-ID: <20231124172033.619706391@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nitin Yadav <n-yadav@ti.com>

commit 71956d0cb56c1e5f9feeb4819db87a076418e930 upstream.

ti,otap-del-sel-legacy/ti,itap-del-sel-legacy passed from DT
are currently ignored for all SD/MMC and eMMC modes. Fix this
by making start loop index to MMC_TIMING_LEGACY.

Fixes: 8ee5fc0e0b3b ("mmc: sdhci_am654: Update OTAPDLY writes")
Signed-off-by: Nitin Yadav <n-yadav@ti.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231026061458.1116276-1-n-yadav@ti.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci_am654.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -598,7 +598,7 @@ static int sdhci_am654_get_otap_delay(st
 		return 0;
 	}
 
-	for (i = MMC_TIMING_MMC_HS; i <= MMC_TIMING_MMC_HS400; i++) {
+	for (i = MMC_TIMING_LEGACY; i <= MMC_TIMING_MMC_HS400; i++) {
 
 		ret = device_property_read_u32(dev, td[i].otap_binding,
 					       &sdhci_am654->otap_del_sel[i]);


