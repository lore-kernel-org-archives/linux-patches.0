Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618084;
	b=erpCRo/Y3SS24x1Lu7ATubAReiTShGb9aDxMG4k3nl8cp5APFRIbL1oLaBLkWKEbDkB2
	 SMJ+Xwf7YqNtMS+7D/hT1LhUWn/by6phEtPSNL+zWaJfzev3bUXkfR8aiDpFePQXyotE6
	 Adw0ux9c2bKBfeLDf9zKCys+QO1wAdUifmUhNP1l0npGQ5PPXRh3o+164KHKzchUgzzlS
	 8obLwlFa7MDUuDT+4fDr/Cx2SdJJZ3VSFVWaCqNrYSFfgN4zp+hwiflmhpMJHlIW59BNh
	 4BqatxS+dpPj8hZGBNJ/ck5d6RHP6aM4TfBqkF64rhO9B0AtlaZy74hkGJSC1MjyP8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8cwoEFSuzNiuC5qsxedJL1Fp7UEC+nBu5Ig2tgrgxzk=;
	b=mCXtA7aNmF9Tcd36oJUMpew0DK70xm2LfXbydSzFigvMRWA/hzO7KckdLBATb8c2n3cA
	 oezZD9iMx19FDd2M8Tbj7BM/oYrrb9VXfuqMwWQrQApK7Y+FzCWE63XFzZgz2xebr6Ajw
	 UrcaUklApysjcMuUMVcxrjPK97yfFkVvSBiyWRJqrHrIurz0W6zrMMD3PU8FQydyoGHVh
	 bh4nS2/9CcIioXtX0xQA4h/0duBsP7eHvkskpt5p9gsOFEoz1Db2FlAEaZ93Wdk0yj2KV
	 l28HOEYzWc19dJ9dXkq07ByVptLaLPzUbnuIGQTFDC6pSKy/74+RUlMQJbr3bLzgSng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vIBs2vGi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D86F606A31E;
	Wed, 25 Nov 2026 14:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vIBs2vGi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7611F000E6;
	Wed, 25 Nov 2026 14:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618083;
	bh=8cwoEFSuzNiuC5qsxedJL1Fp7UEC+nBu5Ig2tgrgxzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vIBs2vGiRCypDem0cVJ7E+3XJRPRUmx5VeX1GbpQdi6gjaTu/efFT8/dmvTt3VGdP
	 m5GxRmyTw9emQdJ1WQIry7UtWNcZdUejn6LT9OgqvTYWRva0Z5pvo1cT/JMYIyIpEF
	 D9yRgQTqozJJdhhzIhT0rne3bpCnuAhmi9G/9X+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0121/1005] spi: acpi: only look up the IRQ of confirmed SPI devices
Date: Wed, 25 Nov 2026 15:24:19 +0100
Message-ID: <20261125143824.575422318@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 2d0953ab69d316589624b0517fdce01f8e630bf0 ]

When an SPI controller is registered, acpi_register_spi_device() is
called for every present ACPI device in the namespace and
acpi_spi_device_alloc() walks each device's _CRS. While doing so,
acpi_spi_add_resource() converts the first interrupt resource it finds,
even for devices that have no SpiSerialBus resource at all and are
discarded right afterwards. Converting an interrupt resource registers
its GSI, so this maps IRQs for arbitrary unrelated ACPI devices.

On a Dell Precision M4800 (Lynx Point, 24-pin IOAPIC) the DSDT reports
Haswell-ULT LPSS child devices (\_SB.PCI0.I2C0.ACD0 and
\_SB.PCI0.SDHC.WI01) as present with interrupts on GSI 37 and 38.
Registering the intel-spi controller then results in:

  ERROR: Unable to locate IOAPIC for GSI 37
  ERROR: Unable to locate IOAPIC for GSI 38

Do what the I2C core does and only parse the interrupt resource once the
device has been identified as an SPI device on this controller.

Fixes: 4c3c59544f33 ("spi/acpi: enumerate all SPI slaves in the namespace")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://patch.msgid.link/20261101200155.15740-1-rosenp@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index e5ef3ca769d53..b201165279236 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2986,7 +2986,6 @@ struct acpi_spi_lookup {
 	acpi_handle		device_handle;
 	u32			max_speed_hz;
 	u32			mode;
-	int			irq;
 	u8			bits_per_word;
 	u8			chip_select;
 	int			n;
@@ -3129,17 +3128,25 @@ static int acpi_spi_add_resource(struct acpi_resource *ares, void *data)
 			if (sb->device_polarity == ACPI_SPI_ACTIVE_HIGH)
 				lookup->mode |= SPI_CS_HIGH;
 		}
-	} else if (lookup->irq < 0) {
-		struct resource r;
-
-		if (acpi_dev_resource_interrupt(ares, 0, &r))
-			lookup->irq = r.start;
 	}
 
 	/* Always tell the ACPI core to skip this resource */
 	return 1;
 }
 
+static int acpi_spi_add_irq_resource(struct acpi_resource *ares, void *data)
+{
+	int *irq = data;
+	struct resource r;
+
+	if (*irq < 0 && ares->type != ACPI_RESOURCE_TYPE_SERIAL_BUS &&
+	    acpi_dev_resource_interrupt(ares, 0, &r))
+		*irq = r.start;
+
+	/* Always tell the ACPI core to skip this resource */
+	return 1;
+}
+
 /**
  * acpi_spi_device_alloc - Allocate a spi device, and fill it in with ACPI information
  * @ctlr: controller to which the spi device belongs
@@ -3164,6 +3171,7 @@ struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
 	struct list_head resource_list;
 	struct acpi_spi_lookup lookup = {};
 	struct spi_device *spi;
+	int irq = -1;
 	int ret;
 
 	if (!ctlr && index == -1)
@@ -3171,7 +3179,6 @@ struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
 
 	lookup.ctlr		= ctlr;
 	lookup.device_handle	= acpi_device_handle(adev);
-	lookup.irq		= -1;
 	lookup.index		= index;
 	lookup.n		= 0;
 
@@ -3194,6 +3201,19 @@ struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
 	if (!lookup.max_speed_hz)
 		return ERR_PTR(-ENODEV);
 
+	/*
+	 * Only look up the IRQ once we know this is an SPI device for us.
+	 * Parsing an interrupt resource maps its GSI, which must not be done
+	 * for every unrelated ACPI device walked during enumeration.
+	 */
+	INIT_LIST_HEAD(&resource_list);
+	ret = acpi_dev_get_resources(adev, &resource_list,
+				     acpi_spi_add_irq_resource, &irq);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	acpi_dev_free_resource_list(&resource_list);
+
 	spi = spi_alloc_device(lookup.ctlr);
 	if (!spi) {
 		dev_err(&lookup.ctlr->dev, "failed to allocate SPI device for %s\n",
@@ -3206,7 +3226,7 @@ struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
 	ACPI_COMPANION_SET(&spi->dev, adev);
 	spi->max_speed_hz	= lookup.max_speed_hz;
 	spi->mode		|= lookup.mode;
-	spi->irq		= lookup.irq;
+	spi->irq		= irq;
 	spi->bits_per_word	= lookup.bits_per_word;
 	/*
 	 * By default spi->chip_select[0] will hold the physical CS number,
-- 
2.53.0



