Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C503C1D6D;
	Thu, 30 Jul 2026 14:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421635; cv=none; b=YXbk9/Z6V1TffZYktKCmrTErDAwL3Ow/2S/wt7/5HCRej3Gw0TlX8J24wLJF+rA1qi/nQtWuo4lArrAdbzuAoFZ7WYBWRbJ7sGAAyctLhcqJpvbvFYFhNcHdLvlLqmTrR4+zmt3NQAD2Zn0kMQfF0fdBr/v4o8JtLLiJWmR3Gtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421635; c=relaxed/simple;
	bh=1KrNml6phLR1nW3z4WFaai/mxDy4LsNw+8CML8TMT3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4YAhnYAJ5zif+7uvaA4WFMwWulUaD4g3aSZRYTkZsvJSWwQcmJEA+TRLTP0XJOvZaf4rOqeXkHqsIOd6wZeBHSIBUf4ahT3AqOjnFoqw1QiL2RhpyepEUFYjKnH/1sdw7EW167xwA7J209EZuk9WHyvKERKB0IZH7yMjmdqTKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOPCwTLn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOPCwTLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2DE1F00A3A;
	Thu, 30 Jul 2026 14:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421634;
	bh=6mveiztV1l/s2XGCGiyED+GEVek7ool+SHz2SbwLsoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rOPCwTLnFxoMkVQ+mVVQ8p3B/WNlBDocgPyvk1TjbR/7DUt9Li+9C1IrPAniIqL1v
	 89S2LxpcIskt9NBIKgKVgVymnF2JIfEl02D84hbhaAqtRuQO7nGbJkC4N+OPi5TD09
	 j0YI4PO53nBEp+WdS0DeLuXsme7a6CGOyMGDRJxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 168/744] watchdog: ni903x_wdt: Check ACPI_COMPANION() against NULL
Date: Thu, 30 Jul 2026 16:07:21 +0200
Message-ID: <20260730141447.863903002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

[ Upstream commit 36e05e134ee44f9fbfcebcbcdadb5f765fccd9f0 ]

Every platform driver can be forced to match a device that doesn't match
its list of device IDs because of device_match_driver_override(), so
platform drivers that rely on the existence of a device's ACPI companion
object need to verify its presence.

Accordingly, add a requisite ACPI_COMPANION() check against NULL to the
ni903x_wdt watchdog driver.

Fixes: d37ec2fbab55 ("watchdog: ni903x_wdt: Convert to a platform driver")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/2280455.irdbgypaU6@rafael.j.wysocki
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/ni903x_wdt.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/ni903x_wdt.c b/drivers/watchdog/ni903x_wdt.c
index 8b1b9baa914e5f..c72a9ee9cb8e19 100644
--- a/drivers/watchdog/ni903x_wdt.c
+++ b/drivers/watchdog/ni903x_wdt.c
@@ -183,9 +183,14 @@ static int ni903x_acpi_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct watchdog_device *wdd;
 	struct ni903x_wdt *wdt;
+	acpi_handle handle;
 	acpi_status status;
 	int ret;
 
+	handle = ACPI_HANDLE(dev);
+	if (!handle)
+		return -ENODEV;
+
 	wdt = devm_kzalloc(dev, sizeof(*wdt), GFP_KERNEL);
 	if (!wdt)
 		return -ENOMEM;
@@ -193,7 +198,7 @@ static int ni903x_acpi_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, wdt);
 	wdt->dev = dev;
 
-	status = acpi_walk_resources(ACPI_HANDLE(dev), METHOD_NAME__CRS,
+	status = acpi_walk_resources(handle, METHOD_NAME__CRS,
 				     ni903x_resources, wdt);
 	if (ACPI_FAILURE(status) || wdt->io_base == 0) {
 		dev_err(dev, "failed to get resources\n");
-- 
2.53.0



