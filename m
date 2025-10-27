Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00342D73B1;
	Mon, 27 Oct 2025 19:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592217; cv=none; b=M5foU5J/jdsdmAJRVUPaiYHuCFiw7Aiz6N+ofzCpiG6GTb8trHmrFPtoUkv9XQwqOFOw3l9V4RLsY14zZVlptSkWbwss98sxCMeQsZm083AL2p83/uWOfcR+JhXtV/OxeH7PLJLn+YPgzI3pD1SAKTsXSjMX50wvSoa6whtQ5Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592217; c=relaxed/simple;
	bh=gvoHcjmtt5MQZCB+65IuWpi/tKZ5Yyb70Zq6nuoZilU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTndCfCxiCrOPCIDq0D9vvHKqQWmB95zMoUBCP04AP+G1JdQkFcMUZSxa9ZNukOcOku0cLr/bAFK7oSaCHgGI09KNWBnzNHHgISZ2PSsYRToXc4xUkm8ZOthjThP6781n0+SVDhWLb4yze3dCzI8SZ8OkIk1fYaeQr+fX7cSHyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tFSivq5+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tFSivq5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA67C4CEF1;
	Mon, 27 Oct 2025 19:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592216;
	bh=gvoHcjmtt5MQZCB+65IuWpi/tKZ5Yyb70Zq6nuoZilU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tFSivq5+XHZAXXB6+nd+DPIc7X+TUDPAO8ITgN7SNO7Wg0PDHtoAltiMGKCBMhL7H
	 6qCDqobu/cwJtKmdplDPvIW1kCmj5O05u4P7nq0BseEg4P2WlX6bYwX1ua5LJyypzY
	 1o5AIiuLpAE0CZR8cMoeAD/fqFLrdRe16qW74iig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrik Flykt <patrik.flykt@linux.intel.com>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/157] can: m_can: m_can_plat_remove(): add missing pm_runtime_disable()
Date: Mon, 27 Oct 2025 19:34:58 +0100
Message-ID: <20251027183502.292551260@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index de6d8e01bf2e8..71cf3662128a1 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -170,7 +170,7 @@ static int m_can_plat_remove(struct platform_device *pdev)
 	struct m_can_classdev *mcan_class = &priv->cdev;
 
 	m_can_class_unregister(mcan_class);
-
+	pm_runtime_disable(mcan_class->dev);
 	m_can_class_free_dev(mcan_class->net);
 
 	return 0;
-- 
2.51.0



