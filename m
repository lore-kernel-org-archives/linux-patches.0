Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5CD38F658;
	Sat, 17 Oct 2026 17:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257046; cv=none; b=J9Qc/FHa5/hwFtub0Z9g85aURjNhkKI2XyNnKVeDMYQNmc4e5qkNNt7jXyxudRvlbtvxAbf8wZhZzWrpwXMIQSQkU0Y2DUrIUMOm8WU27cqzqrfnBIJ8K0ywjclCi0Kp8A8ZMKkSxFkqUHHp3WTPwzAMBtAyeGfN0NhKP8GF9SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257046; c=relaxed/simple;
	bh=QYFzRauagp+73QfP8fWZ5UMhxnhuakaxCB4NyBxEZd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mc4Jr+Y5V8sjD+w7bzkGAX5+gN90cwqRBACQhKz8YxhOibPBDERYpxm8YUNLIcpZRoz++bQ5WkLTYj95atwPyisV7y6YLMTSJD6JvOxVjALnZsqY/Pdp+HnoTbRFB1dlbMY+nuCEJ93VK7K2/Iusu5sXKQ9HXnaqKqay5mIBptU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZxsM7qos; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZxsM7qos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1541F000C4;
	Sat, 17 Oct 2026 17:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257045;
	bh=cQCibZPkO8neWJPvO1BBayOxx4JiltokcB/7CLD115I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZxsM7qosAKJcQaXe3FMEUmFQqujaX0xB0z+/rMNh/xihH9PU5l7TSCeC0x+lzmunO
	 ZImMZVJZ2aVM8zZJGYALpOhsJO/8xqFOz/GOIjdfXW4BPAGtSslOdQChwN8eqNcUK0
	 pZM+TpFF8ds+jfhGWi8YnTZCoxlfOF9dh89f2K1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0391/1674] usb: ohci-spear: Remove unnecessary NULL check before clk_disable_unprepare()
Date: Sat, 17 Oct 2026 17:44:23 +0200
Message-ID: <20261017160441.144978271@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit a891b9aebcc7406fe2f439d184bac3948fb08645 ]

clk_disable_unprepare() already checks NULL by using IS_ERR_OR_NULL.
Remove unneeded NULL check for clk here.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20250617042050.1930940-1-nichen@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: b1b0f8bdbbc8 ("usb: ohci-spear: disable controller wakeup on removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ohci-spear.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/host/ohci-spear.c b/drivers/usb/host/ohci-spear.c
index 993f347c5c288..3192d7ce04fec 100644
--- a/drivers/usb/host/ohci-spear.c
+++ b/drivers/usb/host/ohci-spear.c
@@ -103,8 +103,7 @@ static void spear_ohci_hcd_drv_remove(struct platform_device *pdev)
 	struct spear_ohci *sohci_p = to_spear_ohci(hcd);
 
 	usb_remove_hcd(hcd);
-	if (sohci_p->clk)
-		clk_disable_unprepare(sohci_p->clk);
+	clk_disable_unprepare(sohci_p->clk);
 
 	usb_put_hcd(hcd);
 }
-- 
2.53.0



