Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D33242F0B;
	Thu, 12 Dec 2024 15:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019161; cv=none; b=gXaLvZYkNyKcJcSQJO3OroRe/hlJmsXnY6UKXa+nwKnDxGpuHdsHCs71R8yCcRNF/SREov1b7FUb+OnVpB1+qC+3pESrekRFyA7tmJNuWYhxdHhr2hoztwQmmhmfEfCspMe2z69Iy2ZIY6cyMZcefpBwvX6OwqSH5Sm+9SA9zas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019161; c=relaxed/simple;
	bh=SBDrN0e6t9pWuVfMMgyHcqM+FHGBKXoF2gxWgla4Uos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpbGRQuhQjEy/2ab+7F0a8dfbVaf9ni2Tc/JLdcZbAYsgQRoGFyXii3LtGz3XU9aLI3cB8v74h7HBwBnGFQV8k2RLQByawNTqyXZPIbtykoviBNyM7hjjFoWhBjseR6ACDTLJGSRGUkJMHxxEfbBz3IbUkRVn/1nw3/Tl2jyHVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e49yiE5v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e49yiE5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79E6C4CED3;
	Thu, 12 Dec 2024 15:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019161;
	bh=SBDrN0e6t9pWuVfMMgyHcqM+FHGBKXoF2gxWgla4Uos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e49yiE5vmteqp4FCN9a2EdshUObY5XAInXzkpMbGA5m0GzU+MLDATkNhQqzpQrr4b
	 uVrXhoWkFGlJOJUCqmUxYPjbcjJc3fI7XHU9hEF6WWJzSYEZR3r4zjDLvzlEQxi3b3
	 eWYKuHahJVA+WEk5fywUTjQyqSFfTrwrxL9BrPvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Brian Norris <briannorris@chromium.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 135/772] wifi: mwifiex: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Thu, 12 Dec 2024 15:51:20 +0100
Message-ID: <20241212144355.517486813@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 9a98dd48b6d834d7a3fe5e8e7b8c3a1d006f9685 ]

disable_irq() after request_irq() still has a time gap in which
interrupts can come. request_irq() with IRQF_NO_AUTOEN flag will
disable IRQ auto-enable when request IRQ.

Fixes: 853402a00823 ("mwifiex: Enable WoWLAN for both sdio and pcie")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Acked-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20240910124314.698896-3-ruanjinjie@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index da2e6557e6841..59225fcacd59a 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1638,7 +1638,8 @@ static void mwifiex_probe_of(struct mwifiex_adapter *adapter)
 	}
 
 	ret = devm_request_irq(dev, adapter->irq_wakeup,
-			       mwifiex_irq_wakeup_handler, IRQF_TRIGGER_LOW,
+			       mwifiex_irq_wakeup_handler,
+			       IRQF_TRIGGER_LOW | IRQF_NO_AUTOEN,
 			       "wifi_wake", adapter);
 	if (ret) {
 		dev_err(dev, "Failed to request irq_wakeup %d (%d)\n",
@@ -1646,7 +1647,6 @@ static void mwifiex_probe_of(struct mwifiex_adapter *adapter)
 		goto err_exit;
 	}
 
-	disable_irq(adapter->irq_wakeup);
 	if (device_init_wakeup(dev, true)) {
 		dev_err(dev, "fail to init wakeup for mwifiex\n");
 		goto err_exit;
-- 
2.43.0



