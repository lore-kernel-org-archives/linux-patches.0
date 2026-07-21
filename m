Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5851946AA6B;
	Tue, 21 Jul 2026 15:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648440; cv=none; b=QQH0WEiAXDc9rrkrcMvPI0DD4MzcLm3FMmoHphDwzNAYwDBLGjw/VjUvr1YF9Ekc2jLpA4G5J7qthe4Xbw6DrRSJnTicaklIWf5kn0lm6hGiW0x/+miCMSG7QTCT3H8c3qnFGW3bQLuK3xhsAtBCP3c1m8AfbUJ3bP9bCop4e8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648440; c=relaxed/simple;
	bh=KmxN9aTjVaPGktDL5kS0eYVlNSpHgJ8v46iKQYeEPwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxlhnRZFBKPZH3dK8PKbW61+SIPcW/EeVPEe3MC6JNittg9E3fAG0Q+p/f8EZH6PbJrIJxh4qiFEP+vsnEFfl+lVpEMZt5CrRLNfBKnYa7oOeVXOCQ+y8c+k4184yEN1d55/7r4ZcC0fvt471H1Di+ZAFoF0TNKCX9Zi/cKI0Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZnlA0qQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZnlA0qQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63FB1F000E9;
	Tue, 21 Jul 2026 15:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648439;
	bh=4itYFG2euTvRK1rqUK4XWdpha5TvBbGCUQrSaItQOS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZnlA0qQUg/LG9isBqftU9YBiFOFXv/lxgpHfHA9oQnd2pcDhJX4m1Fdbo15XYl2k
	 SMCeILYTPfQ9Pqu1w2hchIxVmmERkBEA2QLWUZk6/QrkpcOxSvEmzACKn3bWphQfwP
	 bSE+mtJvB+8EsCnLejwRzn8QWuc7/CYHs6g+XtGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0200/2077] platform/chrome: wilco_ec: event: Check ACPI_COMPANION()
Date: Tue, 21 Jul 2026 16:57:53 +0200
Message-ID: <20260721152557.398074086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 51dcff9796fd486d7abf01081ca62e4072789e9d ]

Every platform driver can be forced to match a device that doesn't match
its list of device IDs because of device_match_driver_override(), so
platform drivers that rely on the existence of a device's ACPI companion
object need to verify its presence.

Accordingly, add a requisite ACPI_COMPANION() check against NULL to the
wilco_ec event driver.

Fixes: 27d58498f690 ("platform/chrome: wilco_ec: event: Convert to a platform driver")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/2076666.usQuhbGJ8B@rafael.j.wysocki
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/wilco_ec/event.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/chrome/wilco_ec/event.c b/drivers/platform/chrome/wilco_ec/event.c
index b6e935badc0e94..1b5cb89839e084 100644
--- a/drivers/platform/chrome/wilco_ec/event.c
+++ b/drivers/platform/chrome/wilco_ec/event.c
@@ -452,8 +452,13 @@ static void hangup_device(struct event_device_data *dev_data)
 static int event_device_probe(struct platform_device *pdev)
 {
 	struct event_device_data *dev_data;
+	struct acpi_device *adev;
 	int error, minor;
 
+	adev = ACPI_COMPANION(&pdev->dev);
+	if (!adev)
+		return -ENODEV;
+
 	minor = ida_alloc_max(&event_ida, EVENT_MAX_DEV-1, GFP_KERNEL);
 	if (minor < 0) {
 		error = minor;
@@ -494,8 +499,7 @@ static int event_device_probe(struct platform_device *pdev)
 		goto free_dev_data;
 
 	/* Install an ACPI notify handler. */
-	error = acpi_dev_install_notify_handler(ACPI_COMPANION(&pdev->dev),
-						ACPI_DEVICE_NOTIFY,
+	error = acpi_dev_install_notify_handler(adev, ACPI_DEVICE_NOTIFY,
 						event_device_notify, &pdev->dev);
 	if (error)
 		goto free_cdev;
-- 
2.53.0



