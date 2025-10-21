Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C5926738B;
	Tue, 21 Oct 2025 19:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076447; cv=none; b=c4NVpSosDfuP7TKzgNLpKLsVLP+l5PeWgwYPTTMDaY8ZfMtfwBt8NL0SjRIfLLsEvzrVokV8Lma8P4T2krfZaVMglF6zxo7kijY7a4OYsVjBW//+SbrtOEE3xaEXUeMoqzTcXFIe7AbxhaNkdxdm4b4AAguEnIYHJczYgox+LZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076447; c=relaxed/simple;
	bh=WFdroiBYogNRKrHRAnfAZAuGWaijCZKzJof47kXhMC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+uIc0/BxFNkoP7ezZRBeM0Ofm9bKJD4d+MVG+2+2syOg5NuYtr2YvyKFlFPLOLkALSdAC0qzfWd5Pw4k1HuAC+UOUNGuqQPEdGGqOORWzVYFMLZylRMvWW/U1ilu23c1H8fAHeONOlPt4JqV8OLFmCPjVggmNTKUvZOAl4DXno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNIW2093; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNIW2093"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BD9C4CEF7;
	Tue, 21 Oct 2025 19:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076447;
	bh=WFdroiBYogNRKrHRAnfAZAuGWaijCZKzJof47kXhMC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YNIW2093MPCAXL9XJLIgM4/US2gdOQ5exTwABkVjx9hfR54Sk/GmmG1NyKC3pcxhY
	 QA30H3uH4+XHCsGpYhxc492xyjl1gRjBRvCXLl5k6X40RuGNIg9+PR6ftpYqDbzVW1
	 6uQSa9bR5fpCDQsa4jnnpwsTV55IfshPX9joARKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrik Flykt <patrik.flykt@linux.intel.com>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/105] can: m_can: m_can_plat_remove(): add missing pm_runtime_disable()
Date: Tue, 21 Oct 2025 21:50:45 +0200
Message-ID: <20251021195022.550879315@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit ba569fb07a7e9e9b71e9282e27e993ba859295c2 ]

Commit 227619c3ff7c ("can: m_can: move runtime PM enable/disable to
m_can_platform") moved the PM runtime enable from the m_can core
driver into the m_can_platform.

That patch forgot to move the pm_runtime_disable() to
m_can_plat_remove(), so that unloading the m_can_platform driver
causes an "Unbalanced pm_runtime_enable!" error message.

Add the missing pm_runtime_disable() to m_can_plat_remove() to fix the
problem.

Cc: Patrik Flykt <patrik.flykt@linux.intel.com>
Fixes: 227619c3ff7c ("can: m_can: move runtime PM enable/disable to m_can_platform")
Reviewed-by: Markus Schneider-Pargmann <msp@baylibre.com>
Link: https://patch.msgid.link/20250929-m_can-fix-state-handling-v4-1-682b49b49d9a@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can_platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index cdb28d6a092c6..e5477775992e6 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -183,7 +183,7 @@ static void m_can_plat_remove(struct platform_device *pdev)
 	struct m_can_classdev *mcan_class = &priv->cdev;
 
 	m_can_class_unregister(mcan_class);
-
+	pm_runtime_disable(mcan_class->dev);
 	m_can_class_free_dev(mcan_class->net);
 }
 
-- 
2.51.0



