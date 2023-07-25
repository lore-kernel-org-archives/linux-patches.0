Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD9F1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F974C433C8;
	Tue, 25 Jul 2023 11:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283635;
	bh=p6eTEuxRQqs4/oEWPiI34h7jtdKCMAynNdwRStcd1fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p+ywWKc6EsGf6syQU9CNndT62P7u3TJgKdEIk3OosqaDOHocDfKD91tTY5waJJFrm
	 BhOsiUnJTUr4a3U44N+oyDtsSWwftzkMGLFUTOeO+5ggd9y7TMDyI653ZidC1vbYaA
	 ITRv7qDNSsWBfZdvldXlwjFG4ph+a2VRT0ROTG6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Simon Horman <simon.horman@corigine.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/509] wifi: rsi: Do not set MMC_PM_KEEP_POWER in shutdown
Date: Tue, 25 Jul 2023 12:40:07 +0200
Message-ID: <20230725104556.809823232@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marex@denx.de>

[ Upstream commit e74f562328b03fbe9cf438f958464dff3a644dfc ]

It makes no sense to set MMC_PM_KEEP_POWER in shutdown. The flag
indicates to the MMC subsystem to keep the slot powered on during
suspend, but in shutdown the slot should actually be powered off.
Drop this call.

Fixes: 063848c3e155 ("rsi: sdio: Add WOWLAN support for S5 shutdown state")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230527222859.273768-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 2c26376faeacc..b1d3aea10d7df 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1479,9 +1479,6 @@ static void rsi_shutdown(struct device *dev)
 	if (sdev->write_fail)
 		rsi_dbg(INFO_ZONE, "###### Device is not ready #######\n");
 
-	if (rsi_set_sdio_pm_caps(adapter))
-		rsi_dbg(INFO_ZONE, "Setting power management caps failed\n");
-
 	rsi_dbg(INFO_ZONE, "***** RSI module shut down *****\n");
 }
 
-- 
2.39.2



