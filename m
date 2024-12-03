Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D704A1DFD91;
	Tue,  3 Dec 2024 15:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240639; cv=none; b=u6TQMmS1fNEq1/1dxqg0t1ookT5/w2X8lCjneGJyxtzqXZzl/Fyy+fCVukGGYW4GD7AQsNk2f7Iao2JHETRwV17+4KjTolrSJP+uYiFtn6Ja2btjZMSaAC4uwzYzfWqfurZNiweRS9U/J/2SFURioxMSVnZhnS/hcbMsOT8xgRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240639; c=relaxed/simple;
	bh=KIFuRYwIH+nR8V2hfUTNUx+AM08WzwdZc3eVsJLpqYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elvKrxdJ1K/BubyWX+46yyU6hOurSXWdAHAVk1RqyMpRKJciiG3rhfLwDFO8/mW3o9Jl5Q0r2gv6BRQmA1XpDsRWhu15DwJWn5Qx0jm6aNs9WpjNeFPsLIISJwiVqgjRbDaWZmDryHHYvf0BJv/T2cu9s6IeewzIuootqixU/Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q57wJDrx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q57wJDrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B311C4CED6;
	Tue,  3 Dec 2024 15:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240639;
	bh=KIFuRYwIH+nR8V2hfUTNUx+AM08WzwdZc3eVsJLpqYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q57wJDrxm7xQAaKxHNBSfFYkkS4DYzo+6Xs8BR3lRIQwnNnrNtoBK+1Kf7nn7NnSJ
	 VYsnOndpXNpvraZ89oj3Xd/jUCqXPCa17g6Rke48btpGSDtiLIUqSQ+IlpzDv0322y
	 EG36X3EpXPVHnyiYDirXIt7h6SKCh5uTfCKMGA+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Brian Norris <briannorris@chromium.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 194/826] wifi: mwifiex: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Tue,  3 Dec 2024 15:38:41 +0100
Message-ID: <20241203144751.315525675@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 96d1f6039fbca..855019fe54858 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1679,7 +1679,8 @@ static void mwifiex_probe_of(struct mwifiex_adapter *adapter)
 	}
 
 	ret = devm_request_irq(dev, adapter->irq_wakeup,
-			       mwifiex_irq_wakeup_handler, IRQF_TRIGGER_LOW,
+			       mwifiex_irq_wakeup_handler,
+			       IRQF_TRIGGER_LOW | IRQF_NO_AUTOEN,
 			       "wifi_wake", adapter);
 	if (ret) {
 		dev_err(dev, "Failed to request irq_wakeup %d (%d)\n",
@@ -1687,7 +1688,6 @@ static void mwifiex_probe_of(struct mwifiex_adapter *adapter)
 		goto err_exit;
 	}
 
-	disable_irq(adapter->irq_wakeup);
 	if (device_init_wakeup(dev, true)) {
 		dev_err(dev, "fail to init wakeup for mwifiex\n");
 		goto err_exit;
-- 
2.43.0



