Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1157274B29;
	Tue, 21 Oct 2025 20:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077294; cv=none; b=G1eTkSnIUX5K7LWyHlL1MjuBlgvy88giWOYhKxmzvDEYCuY6/0HyP8aGZA2D1DOoIK9U0nrr391MI7JPiUIMUOB5anlez5N+ZIfH+8SZsWEFwemQRQ3bq3CJFOWIQv+VduiPaee4F0a5JhxCD1qfzAnQYbXB9J2qxFDqsl0ZyS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077294; c=relaxed/simple;
	bh=Jaj65oYTG900KevAcPRgvr+7Iyv6ZAY9s71HWtkPZ8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EGGV/D2niEEBAfIE5rmij1ewOU+lL0C3nZxWZkD8nJsYkCI0H0udcfkkHdN8LC7O/43rggab8yiKY8d4LrGI0nlGaf31R74raxuG+oJtaG7xqvfkjbRktigQBgMJbuYqmVG6WLSJXH5WPCKt4ASgi479zqW9b8Hy9b1zZwD6bZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uGZHiTgi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uGZHiTgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40ED6C4CEF1;
	Tue, 21 Oct 2025 20:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077294;
	bh=Jaj65oYTG900KevAcPRgvr+7Iyv6ZAY9s71HWtkPZ8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGZHiTgija98MMjjrM2LIv99wZ+5gwvViJBiOMjs8EmFMiOTeVxOGq22dVh7g15fP
	 AYWy7LC2ui84SxmkyWM17n/YP/5255hghnMlN9dF57dg7UIStJk3PvVVzTprWA6M8G
	 Bo8xa8M3iL+JSvtO8QglACEYKRh5Gy+aCHbMP3Es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrik Flykt <patrik.flykt@linux.intel.com>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 060/159] can: m_can: m_can_plat_remove(): add missing pm_runtime_disable()
Date: Tue, 21 Oct 2025 21:50:37 +0200
Message-ID: <20251021195044.658225664@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index b832566efda04..057eaa7b8b4b2 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -180,7 +180,7 @@ static void m_can_plat_remove(struct platform_device *pdev)
 	struct m_can_classdev *mcan_class = &priv->cdev;
 
 	m_can_class_unregister(mcan_class);
-
+	pm_runtime_disable(mcan_class->dev);
 	m_can_class_free_dev(mcan_class->net);
 }
 
-- 
2.51.0



