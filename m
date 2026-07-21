Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DA322B8DF;
	Tue, 21 Jul 2026 18:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660172; cv=none; b=UPy3/hBZBSwhhWi9ytlmULU/aSwpC2fsJeiLwuZx6dk4uE97d57e+fVgdIE4p+T3bjlTyk2Mug6t6YsZdb43AUTjsF91CwE/9ixmjTUhcJSVTdfCfCMLekPFXgfiGRtyHO2D2TQhyovW2tHT/3c+HaSp2HNkmwsqxhCvWxPdSAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660172; c=relaxed/simple;
	bh=h7t7TgaIeuRSdqG4+84HAqw6PT/eoCKjvtlZ/tzjrK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQO7qm6y5FXlotZYfasnpuZHRC+5QRzdv9WoM2FViLkI8BikebUy5bHHQw3bz64IToBOyzSzK0o/1t0100KwJeWU6ZBbFkQ5bF4FJbu58e9eNJsWw2jKImLV0UuZImWiZUKsEpYUuoidc43v4cNYAQXk6xYPDkVGYnOQwa6+DoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7/fAmvi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7/fAmvi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549861F000E9;
	Tue, 21 Jul 2026 18:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660171;
	bh=DTsGWoVKDLLHeyEbcY7mICw8s9NtQhjlFHFJEPLu6Jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t7/fAmviCwUzBEvI29LG3du77mzIVK/c0wEd54hmJzIJFqGKKxoSPPUA3JfDxbsGV
	 ZCRDP07//sWLvPKi0J7haUNCvOkw5VoSxvml2Vhq4iw3Pr2yyaTt6yE/HHjLyJ05ZL
	 WyONrmORq3oOfbWE7vWS5w+C9vOl0z/byvOHxt2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0872/2077] iio: light: acpi-als: Check ACPI_COMPANION() against NULL
Date: Tue, 21 Jul 2026 17:09:05 +0200
Message-ID: <20260721152613.358948811@linuxfoundation.org>
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

[ Upstream commit ff29241030eb6f4505d903d87c29f51c1866a95d ]

Every platform driver can be forced to match a device that doesn't match
its list of device IDs because of device_match_driver_override(), so
platform drivers that rely on the existence of a device's ACPI companion
object need to verify its presence.

Accordingly, add a requisite ACPI_COMPANION() check against NULL to the
acpi-als IIO driver.

Fixes: d4243cb08a27 ("iio: light: acpi-als: Convert ACPI driver to a platform one")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/acpi-als.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/light/acpi-als.c b/drivers/iio/light/acpi-als.c
index ab229318dce94c..1983a7f17aa930 100644
--- a/drivers/iio/light/acpi-als.c
+++ b/drivers/iio/light/acpi-als.c
@@ -179,11 +179,15 @@ static irqreturn_t acpi_als_trigger_handler(int irq, void *p)
 static int acpi_als_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct acpi_device *device = ACPI_COMPANION(dev);
+	struct acpi_device *device;
 	struct iio_dev *indio_dev;
 	struct acpi_als *als;
 	int ret;
 
+	device = ACPI_COMPANION(dev);
+	if (!device)
+		return -ENODEV;
+
 	indio_dev = devm_iio_device_alloc(dev, sizeof(*als));
 	if (!indio_dev)
 		return -ENOMEM;
-- 
2.53.0



