Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF671C9EAC;
	Mon, 14 Oct 2024 14:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917497; cv=none; b=nWF0ZRaqHisbMRBXLTxILGaX8X6KaWYWmK2cvf3SZ4pI1luMDyQTKWPVFc8OiEwvQvG+HP8PPHmrP5iLmDKEMd3UnRl/F4iLI6FIgqalwBW/zK7GpupDv+71pLhv98ok3XgyHYIX3aTT3bDY5/oAdrKCit1iNuv4o5/97+lvEoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917497; c=relaxed/simple;
	bh=YOhvgcTVntF9+G2iDv25YlLzusm8oewdBUf0wLyC4o4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGgGFscKRd/fIhEkn99jrwG4fVqKB93l1z/wmMYTFlLYFb8AMZTmq/GWBCBDaomdBmhuWTS4YzNWswnGiQJutO4Afs02LCb3lVMh0fQKjJCdZGtN0OEsKdiRg7VLr7fpZq0Ax0FogVSPgb/f5eqTZjd+H8UXxQZwPGkqSAbjO9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yGURYbO8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yGURYbO8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E01C4CED1;
	Mon, 14 Oct 2024 14:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917497;
	bh=YOhvgcTVntF9+G2iDv25YlLzusm8oewdBUf0wLyC4o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yGURYbO8LerHe8jucoSlgi74Z3bgV9VwKHM5quiAQTuYh/R3rfCT6P5fmScUXJICJ
	 b7K1cOi0DqRvD1u/iXBs/LwEeaqSWq1hTWEOh3sCW3PcdR1GpVTIy9Zrvtfas4eoX9
	 SeEKlI75dYZd4Mh84seeZHcl+VXlUxhn3HgBnvf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Simon Horman <simon.horman@corigine.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/798] can: m_can: Remove repeated check for is_peripheral
Date: Mon, 14 Oct 2024 16:10:05 +0200
Message-ID: <20241014141219.949678087@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Schneider-Pargmann <msp@baylibre.com>

[ Upstream commit 73042934e4a30d9f45ff9cb0b3b029a01dbe7130 ]

Merge both if-blocks to fix this.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/all/20230315110546.2518305-2-msp@baylibre.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: 801ad2f87b0c ("can: m_can: enable NAPI before enabling interrupts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 561f25cdad3fb..ead8321ed3bfc 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1566,10 +1566,8 @@ static int m_can_close(struct net_device *dev)
 		cdev->tx_skb = NULL;
 		destroy_workqueue(cdev->tx_wq);
 		cdev->tx_wq = NULL;
-	}
-
-	if (cdev->is_peripheral)
 		can_rx_offload_disable(&cdev->offload);
+	}
 
 	close_candev(dev);
 
-- 
2.43.0



