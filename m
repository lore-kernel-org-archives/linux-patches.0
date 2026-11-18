Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023278;
	b=MLIw2YMANZsJ19G30rQeKDjdPXNUF6w+8Tbq/p9NLkz7KNYmkXH3MQKkB039A00ExVmM
	 wLBjRe4zWe1m/L+n9VLxaJD3zrO8d8xgTecXPrAipNwyHlpEe7Z+VuI8ZjsDMEcWaF7+L
	 DRoJE6TzCnivKgr0pEkgylv9l2Nfvsg0AiEM90Ja9kgRm/Z1LbXWZ0kf28ahr8HuvHUc5
	 s8BUqTI0wW7vaOJzTT7lzXlhbkDGaeTbRdzoEfs6r5JY+RX1yo0H2L2immJ3u7Zb21lYg
	 tD42jtf1Osz55raw1osm4UyTzF/BAzPVnFe18Y2vb0iwOx1QL9iWE7xueseQnY4W+AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023278;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bubfI6Qc8ji3R0bRjnZZN6auFWfUKnB1HJexoFX5ejE=;
	b=OT/5NxCiA9dAUnjQov+C1Bk5ZrvVjA2RLalhhv8FrBWab4R8KcUqwaJjWNas67E/7QsF
	 nPwqahDF+3XFQVPgEspVG/N7ZDuhsz1qKkynvMJnGJDB+xfwPFo97K6EXrXHi4m22Eg9u
	 g24gB+9ao5M4ojXwLA6nO8zQflsDxDX2x/dNfg9mqVst81xCc30akocEZphRddkJUiNUz
	 0+rVj36aigaYP90Zy0OYaLK227acZBOWjp+fYQjzZGACwwr2qC8CsOgioH4fSsO7tjO1P
	 Jv1aTvzpiKjwhQ/TNESYr0ZffLd8rDM9rA2R0xb8u3mtHgrccz+zzcI9qtxqiJo+zJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mplYJYK3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17A3606A31C;
	Wed, 18 Nov 2026 17:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mplYJYK3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2B11F000C4;
	Wed, 18 Nov 2026 17:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023278;
	bh=bubfI6Qc8ji3R0bRjnZZN6auFWfUKnB1HJexoFX5ejE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mplYJYK323qZC9nk+p6dpRaEA7mtTVm1d0VT3sqNl21ChDlrFxKoB4MUQTtmr3DJT
	 J99tyz/azrkChvKigqstpTKFLCWbetCURhWBpzg7ZPuh7qWLjGrYzYsahwfgnwmHTJ
	 qiR9cOaMOxvHVL/VNtKM5H3MmEEO+1j7TKF8J3N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0312/2151] ACPI: glue: Reduce debug noise from acpi_device_notify()
Date: Wed, 18 Nov 2026 15:34:07 +0100
Message-ID: <20261118150133.315927995@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: aef7792cddca ("ACPI: glue: Rework the success message in acpi_device_notify()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/glue.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index a194f30876c59..2a782ba508f7b 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -354,22 +354,27 @@ void acpi_device_notify(struct device *dev)
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
@@ -391,11 +396,6 @@ void acpi_device_notify(struct device *dev)
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



