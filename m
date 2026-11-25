Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625083;
	b=JtSNCQed9ElBMeh8aYLn5spbvoAoaGV8pj4OOR4eTlgYqPDBmex1JZ4qNWQwN0OaT/ER
	 vT1/gDdAvS4dPZymTzI+4TXTmZP+D6sZOuy2JMfkuoX7Y0Pc7oYtIocU6J+uR1XI3jX0q
	 bqMaMWrKuy+MjEAOU0OQI4VyXtwfnVqWSlkITjUF8Bn8zR5CA0b5I7DmHHVykbK5GVXiE
	 kQxepJk/9P4tgURlAtyzX1N08r2SOzTANSsWaD56aZcsE5udopxrVQrG+dv4JZ4WDcUg5
	 RFu4RzS2fbbXAW6KIgmdh5aCy3pVY0ibmJfPaUnDUIiT/uxv7WduuV9cRpEgQczY+Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625083;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3enTMMqMdVSQxGVlr/XjRKUoVPlzxAHNm4l3OK51mB0=;
	b=HYKLw3Vur+q/fTfPupisN2z9g522/o34R8Ae7L7ahlaVdSflbaTRwqBM+1+QrW/gEzef
	 6Ceaq8F8vfkTMtC+Am2qoy8Z+E1+JM/XQ7y2U6W/qxD/fSLp+mkSneYqlN8DTl5MbbSLa
	 hbOGDaHTkWT2cQgjV62xzPxY9frHAgyB06cMqlaVNGmqtz7aYCPGA5t6xmS6X8s/L+fU4
	 gUBfd/kPDF4lzQ5KmnlsWyxBPsdOAlS1z8tnbXShUUXdTeMWvsbKvguyeA8FePitSs8uD
	 JQWOULEW3r4d8WWV42tmYRwqbpcWZRIM6a9tFuVEBdonnPMpmg3Br+0TRBDdcQ/zhwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mOe884dT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099A9606A31E;
	Wed, 25 Nov 2026 16:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mOe884dT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C4A1F000C4;
	Wed, 25 Nov 2026 16:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625082;
	bh=3enTMMqMdVSQxGVlr/XjRKUoVPlzxAHNm4l3OK51mB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mOe884dTDQVQE1ca49nU9KCJrJM5cMk9DFBw6hrt1Vg5hYDoL2d4BE0eJUK/5aQTJ
	 Knn5adx9tmA6y21skBD/CqxBMrgQAcpnLOIEGzsz2vOxabWAUCi1b908t4O5cgnc1s
	 qHWUUCaylA7E2n+Hftqh5RtB0aoP9Y/96AtNn5AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 400/816] ACPI: glue: Reduce debug noise from acpi_device_notify()
Date: Wed, 25 Nov 2026 15:32:28 +0100
Message-ID: <20261125143858.458127181@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 5bc1e72f80da4c20ce8b57851be4fad67e855ebd ]

When debug is enabled in the ACPI glue code that handles binding
devices to ACPI companions, acpi_device_notify() produces a lot of
message noise related to devices that have no ACPI companions.

Reduce that noise by checking the most obvious case, ACPI device
objects, directly and returning from acpi_device_notify() in that
case without printing any debug messages.  Also avoid printing a
debug message when there is no matching ACPI bus type definition for
the given device, which is the case for the vast majority of devices.

Additionally, make the debug messages that get printed more informative.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/6325978.lOV4Wx5bFT@rafael.j.wysocki
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: c94619c8a5b5 ("ACPI: glue: Carry out companion lookup under bus_type_sem")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/glue.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index cc9ee8cb820fc..54cc709be3166 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -356,22 +356,27 @@ void acpi_device_notify(struct device *dev)
 	struct acpi_device *adev;
 	int ret;
 
+	/* ACPI devices have no ACPI companions. */
+	if (dev->bus == &acpi_bus_type)
+		return;
+
 	ret = acpi_bind_one(dev, NULL);
 	if (ret) {
 		struct acpi_bus_type *type = acpi_get_bus_type(dev);
 
 		if (!type)
-			goto err;
+			return;
 
 		adev = type->find_companion(dev);
 		if (!adev) {
 			dev_dbg(dev, "ACPI companion not found\n");
-			goto err;
+			return;
 		}
 		ret = acpi_bind_one(dev, adev);
-		if (ret)
-			goto err;
-
+		if (ret) {
+			dev_dbg(dev, "Binding to ACPI companion failed\n");
+			return;
+		}
 		if (type->setup) {
 			type->setup(dev);
 			goto done;
@@ -393,11 +398,6 @@ void acpi_device_notify(struct device *dev)
 done:
 	acpi_handle_debug(ACPI_HANDLE(dev), "Bound to device %s\n",
 			  dev_name(dev));
-
-	return;
-
-err:
-	dev_dbg(dev, "No ACPI support\n");
 }
 
 void acpi_device_notify_remove(struct device *dev)
-- 
2.53.0



