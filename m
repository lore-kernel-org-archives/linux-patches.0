Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87651C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:08:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688D9C433EF;
	Mon, 20 Mar 2023 15:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324914;
	bh=d81WpvGHXcAaGO6+jdo5a6M6e5BWfqqEcbhXTx3AZ70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x/2CwO1/HTuYJQSdAEObumHmlz7dNHRb3tryU3/WKU0fCIcVbMI7HP9TRW//zdLMa
	 JuBBpzMRxW+TvNm6K8rMSFf/+YUYNUX5hCkdTfGpFxAvz0FLsrV+a1NVkYaMmHe31f
	 lJ8LYsz8VfFS982hIfCZNlRMp+DBBjnQEURXgzn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 72/99] mmc: sdhci_am654: lower power-on failed message severity
Date: Mon, 20 Mar 2023 15:54:50 +0100
Message-Id: <20230320145446.408487821@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Francesco Dolcini <francesco.dolcini@toradex.com>

commit 11440da77d6020831ee6f9ce4551b545dea789ee upstream.

Lower the power-on failed message severity from warn to info when the
controller does not power-up. It's normal to have this situation when
the SD card slot is empty, therefore we should not warn the user about
it.

Fixes: 7ca0f166f5b2 ("mmc: sdhci_am654: Add workaround for card detect debounce timer")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230306162751.163369-1-francesco@dolcini.it
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci_am654.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -369,7 +369,7 @@ static void sdhci_am654_write_b(struct s
 					MAX_POWER_ON_TIMEOUT, false, host, val,
 					reg);
 		if (ret)
-			dev_warn(mmc_dev(host->mmc), "Power on failed\n");
+			dev_info(mmc_dev(host->mmc), "Power on failed\n");
 	}
 }
 


