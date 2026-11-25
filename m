Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619875;
	b=4nWAmPQT6xi/sf05KGikiTo+juGyOEL3RprdfzJyOjVOA82zTCYzemjjpaxBYrEXUEn1
	 EQqplI6RrDsK1lfBqOjDYyivBEciKmrEag9xftT9VsfVf0oHUU/0WB1Zudcs87kWbD38Z
	 JmLGHd3F+gBXA2QULCIPcmv9imx7e082KuK/wTeEPalhckp88rpyxO0avp87CUfBJ+AbI
	 KLr+FvvOsddpPkfPuub3/Fx7GdVyuNnfZVGyN5sH5hGuWz8E/J+1b6eao9uaBLLYDf401
	 Af3uA9a8hr9DnpJOdas0PSNDrVu7smYXNkf++3aJCR18xIUB+PvM5C/2o53YctLWTsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619875;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NIPNR8pARlu6+VFKTYFMfcwAMU6+fU6qen/wlL5Ux7I=;
	b=PUYLEWpu2odHmMG4SG5fxgJiN9Pfa3pAhXwynqyY5xxTGgzdO8IRuol/Cdzl3VedrndO
	 hxjkExZMys/PlIPgWQVaLSnZKWTRiWq/wvvO+l2sZ4BZ96UPgifXmyIeJOJC6SZM5SsfG
	 zSg0Ch4hyb8AA/xn2//Asf5zrn6SqR013qDqaudiots3JVMQBNaIPw1lSk4OF/a91qyXD
	 MLP3XH0ZcCChxoN2QcWNlEwU2DCGnCSbYg4v/mblLyQ5arv2qxyEAP5++NW72+uLXymCl
	 2tJ2i7tKN93Hy8at5OC2ac29Hz7scIDEBwSzFDxa03S/TPwmzAI1F8538O7v43KkNLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="R/6JbMfC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919AF606A329;
	Wed, 25 Nov 2026 15:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R/6JbMfC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3911F000C0;
	Wed, 25 Nov 2026 15:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619875;
	bh=NIPNR8pARlu6+VFKTYFMfcwAMU6+fU6qen/wlL5Ux7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R/6JbMfCI3aLbK+fUiLlVjGwYrNd88Y1CWXhIN/affA7Ar8OQtK0nrJb5V7e03v8j
	 99/HbdZk63Vpj4uSeKRk9U9SgTLlXenpkygjHcWMRYxabfVVFQkh/bGYxsMigdxPa3
	 fR4uDNWrayEuZrvwrMaLtFQnm7TFVzMcSPI/rOJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Aleksandrov <lightofmysoul@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.3 0733/1005] watchdog: gunyah_wdt: Re-enable the watchdog on resume
Date: Wed, 25 Nov 2026 15:34:31 +0100
Message-ID: <20261125143838.931969212@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Aleksandrov <lightofmysoul@gmail.com>

commit f0dfc756bb46235068279755249131c2a7130111 upstream.

gunyah_wdt_suspend() disables an active watchdog, and
gunyah_wdt_resume() enables it again with gunyah_wdt_start(). start()
first disables the watchdog, which fails with -EINVAL when it is
already disabled. start() ignores that only while the watchdog is
inactive, but on resume it is still active for the watchdog core, so
start() returns before it enables the watchdog:

  gunyah-wdt gunyah-wdt: gunyah_wdt_start: Failed to stop gunyah wdt -22

So after every system suspend, the watchdog is left disabled.

Move setting the timeout and enabling the watchdog into
gunyah_wdt_enable(), and call it on resume, where the watchdog is
already disabled.

Tested on the Samsung Galaxy XR (Qualcomm Halliday) with s2idle and
deep suspend.

Fixes: ca316e145c35 ("watchdog: Add driver for Gunyah Watchdog")
Cc: stable@vger.kernel.org
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Link: https://patch.msgid.link/20261109-gunyah-wdt-resume-v1-1-fbd84545ce92@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/gunyah_wdt.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/watchdog/gunyah_wdt.c b/drivers/watchdog/gunyah_wdt.c
index e3c2a2131624..35958594e17c 100644
--- a/drivers/watchdog/gunyah_wdt.c
+++ b/drivers/watchdog/gunyah_wdt.c
@@ -62,19 +62,12 @@ static int gunyah_wdt_call(unsigned long func_id, unsigned long arg1,
 	return gunyah_error_remap(res.a0);
 }
 
-static int gunyah_wdt_start(struct watchdog_device *wdd)
+static int gunyah_wdt_enable(struct watchdog_device *wdd)
 {
-	unsigned int timeout_ms;
+	unsigned int timeout_ms = wdd->timeout * 1000;
 	struct device *dev = wdd->parent;
 	int ret;
 
-	ret = gunyah_wdt_call(GUNYAH_WDT_CONTROL, WDT_CTRL_DISABLE, 0);
-	if (ret && watchdog_active(wdd)) {
-		dev_err(dev, "%s: Failed to stop gunyah wdt %d\n", __func__, ret);
-		return ret;
-	}
-
-	timeout_ms = wdd->timeout * 1000;
 	ret = gunyah_wdt_call(GUNYAH_WDT_SET_TIME, timeout_ms, timeout_ms);
 	if (ret) {
 		dev_err(dev, "%s: Failed to set timeout for gunyah wdt %d\n",
@@ -89,6 +82,20 @@ static int gunyah_wdt_start(struct watchdog_device *wdd)
 	return ret;
 }
 
+static int gunyah_wdt_start(struct watchdog_device *wdd)
+{
+	struct device *dev = wdd->parent;
+	int ret;
+
+	ret = gunyah_wdt_call(GUNYAH_WDT_CONTROL, WDT_CTRL_DISABLE, 0);
+	if (ret && watchdog_active(wdd)) {
+		dev_err(dev, "%s: Failed to stop gunyah wdt %d\n", __func__, ret);
+		return ret;
+	}
+
+	return gunyah_wdt_enable(wdd);
+}
+
 static int gunyah_wdt_stop(struct watchdog_device *wdd)
 {
 	return gunyah_wdt_call(GUNYAH_WDT_CONTROL, WDT_CTRL_DISABLE, 0);
@@ -224,7 +231,7 @@ static int gunyah_wdt_resume(struct device *dev)
 	struct watchdog_device *wdd = dev_get_drvdata(dev);
 
 	if (watchdog_active(wdd))
-		gunyah_wdt_start(wdd);
+		gunyah_wdt_enable(wdd);
 
 	return 0;
 }
-- 
2.56.1



