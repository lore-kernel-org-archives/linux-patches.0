Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601C821CFEA;
	Thu, 12 Dec 2024 16:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020813; cv=none; b=YNLIXnlcX8xHHkxQZFFNIEuVbXJw6ozxxPaD/gjYtHW1d3u+5XR+yzuTurEDm3bLaRfH+qdHBh2kxyY7Y6HITd4QI/yRXjH0MWRU41aXbjliU1xuOO/5cquv51fpoN0yn2Uv/H/y8OCDluU0EmqscySsxplbqCIZAXCbt9sipyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020813; c=relaxed/simple;
	bh=+slE99/cKbOU11ehcIl2n/z/hVe4VvrWdRRcn0qnrEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mLKPFs/uqNG6TCQLOa58Dam+KrQZ/SC0/dJxMGRxE6rfJEGgvaur4gh8s8Deu7VmADZHDLwNmrxr20CkEDo8IrcPbUhMIrxy+oIzQQoEUZ0jDQaqoOJyRin/pdn8+raYwaga7uqHXvogSkCkVErTNoziYFaDD9L06AMPzJjBJjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VYm02etO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VYm02etO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04512C4CECE;
	Thu, 12 Dec 2024 16:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020812;
	bh=+slE99/cKbOU11ehcIl2n/z/hVe4VvrWdRRcn0qnrEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VYm02etOoNQh/wBdqnu76fr6FOlNYFDbK660Smm9qSpb8xpSYu56WcZzSlzn2gQDU
	 VgzBF+Vk81tEuXyhq/yZWjlRUPgpLdpHAvjoXfsqt5tA2rbmxcyjp1gk2S51SYNLbX
	 UAqXGbB0B3hf9yWyU0h2Yn/52/cuumEifgyScgZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 567/772] i3c: Make i3c_master_unregister() return void
Date: Thu, 12 Dec 2024 15:58:32 +0100
Message-ID: <20241212144413.389053943@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 0f74f8b6675cc36d689abb4d9b3d75ab4049b7d7 ]

The function returned zero unconditionally. Switch the return type to void
and simplify the callers accordingly.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20230318233311.265186-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 25bc99be5fe5 ("i3c: master: svc: Modify enabled_events bit 7:0 to act as IBI enable counter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c                   | 6 +-----
 drivers/i3c/master/dw-i3c-master.c     | 5 +----
 drivers/i3c/master/i3c-master-cdns.c   | 5 +----
 drivers/i3c/master/mipi-i3c-hci/core.c | 4 +++-
 drivers/i3c/master/svc-i3c-master.c    | 5 +----
 include/linux/i3c/master.h             | 2 +-
 6 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 2263bc066108f..c8aa0d27143cc 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2696,17 +2696,13 @@ EXPORT_SYMBOL_GPL(i3c_master_register);
  * @master: master used to send frames on the bus
  *
  * Basically undo everything done in i3c_master_register().
- *
- * Return: 0 in case of success, a negative error code otherwise.
  */
-int i3c_master_unregister(struct i3c_master_controller *master)
+void i3c_master_unregister(struct i3c_master_controller *master)
 {
 	i3c_master_i2c_adapter_cleanup(master);
 	i3c_master_unregister_i3c_devs(master);
 	i3c_master_bus_cleanup(master);
 	device_unregister(&master->dev);
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(i3c_master_unregister);
 
diff --git a/drivers/i3c/master/dw-i3c-master.c b/drivers/i3c/master/dw-i3c-master.c
index 51a8608203de7..b72f6dce18b48 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -1184,11 +1184,8 @@ static int dw_i3c_probe(struct platform_device *pdev)
 static int dw_i3c_remove(struct platform_device *pdev)
 {
 	struct dw_i3c_master *master = platform_get_drvdata(pdev);
-	int ret;
 
-	ret = i3c_master_unregister(&master->base);
-	if (ret)
-		return ret;
+	i3c_master_unregister(&master->base);
 
 	reset_control_assert(master->core_rst);
 
diff --git a/drivers/i3c/master/i3c-master-cdns.c b/drivers/i3c/master/i3c-master-cdns.c
index b9cfda6ae9ae5..35b90bb686ad3 100644
--- a/drivers/i3c/master/i3c-master-cdns.c
+++ b/drivers/i3c/master/i3c-master-cdns.c
@@ -1666,11 +1666,8 @@ static int cdns_i3c_master_probe(struct platform_device *pdev)
 static int cdns_i3c_master_remove(struct platform_device *pdev)
 {
 	struct cdns_i3c_master *master = platform_get_drvdata(pdev);
-	int ret;
 
-	ret = i3c_master_unregister(&master->base);
-	if (ret)
-		return ret;
+	i3c_master_unregister(&master->base);
 
 	clk_disable_unprepare(master->sysclk);
 	clk_disable_unprepare(master->pclk);
diff --git a/drivers/i3c/master/mipi-i3c-hci/core.c b/drivers/i3c/master/mipi-i3c-hci/core.c
index 6aef5ce43cc1f..f9bc58366a721 100644
--- a/drivers/i3c/master/mipi-i3c-hci/core.c
+++ b/drivers/i3c/master/mipi-i3c-hci/core.c
@@ -769,7 +769,9 @@ static int i3c_hci_remove(struct platform_device *pdev)
 {
 	struct i3c_hci *hci = platform_get_drvdata(pdev);
 
-	return i3c_master_unregister(&hci->master);
+	i3c_master_unregister(&hci->master);
+
+	return 0;
 }
 
 static const __maybe_unused struct of_device_id i3c_hci_of_match[] = {
diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index eca50705e9ce8..77bb7c0468250 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -1651,11 +1651,8 @@ static int svc_i3c_master_probe(struct platform_device *pdev)
 static int svc_i3c_master_remove(struct platform_device *pdev)
 {
 	struct svc_i3c_master *master = platform_get_drvdata(pdev);
-	int ret;
 
-	ret = i3c_master_unregister(&master->base);
-	if (ret)
-		return ret;
+	i3c_master_unregister(&master->base);
 
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
diff --git a/include/linux/i3c/master.h b/include/linux/i3c/master.h
index 604a126b78c83..4b7bb43bf4307 100644
--- a/include/linux/i3c/master.h
+++ b/include/linux/i3c/master.h
@@ -541,7 +541,7 @@ int i3c_master_register(struct i3c_master_controller *master,
 			struct device *parent,
 			const struct i3c_master_controller_ops *ops,
 			bool secondary);
-int i3c_master_unregister(struct i3c_master_controller *master);
+void i3c_master_unregister(struct i3c_master_controller *master);
 
 /**
  * i3c_dev_get_master_data() - get master private data attached to an I3C
-- 
2.43.0



