Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704989;
	b=sP0BGXSz5Yr6ITGT0psRNzWKebqmaY1r0p1qIvXjnv74fn1DoV0qdudVHZmK5qOJLz1o
	 kLitKxts5ehEl8fgJXI/7dp4RfuMPNWb8b/cjnsJ7KmR/w6/Ia9WSFJaLXmRp21gAyfUE
	 QhXRj6pBuFrcCYt2VnkSLPER4MLrZra5aXcsKVUGyznRex9AZL6VNZP+j4CFJmdUBzd+B
	 B48BCmTC/x81ybPPkmT7zDAmmYMamToUpV3MybBr+paxVf5A1EdkqfMqx57RdepbluLz8
	 Iyg0c4TlowdnJN0NlWGwxtwLxpOgFWcHNpbVpcACZN42g7Pyg4WGAFfyotZh0r4puyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mg3+rsBMir8Rkn3mNzIAZkIEWJUrKurMudlPQ0rsThk=;
	b=WfVsJ+CJTrWAWqfYSgKz6z4CEO63UNuEEXTuEKnWF6jqY2d/5KEu66jjwnkX4clQYYWc
	 nRh6pldayikkT6PNoDY6tipxnID8Qqmky9gJIbgBMkNJvVCEh+CFu6wwhqpvepUggCCZa
	 fgD3KdWwjtqA2xXkKZ2m3YE8Z9KPVvU8kZY28YtAdFm/cVYOaTqGB5L36fDWE2O/PkIQJ
	 YYUrBFHDN7g6+DsWoagtxnB2itFvMmogoCjnjF8jQ5IB5df+DghHmGappmidE4B53xrlw
	 T+rl8QXRa2RjpVwaE6gRaOB+oLzfLnZ4k0qM7ZsBvvpw03b3kUqB6ATa1SA9ZwiocKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZjYY7aq/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090AD606A31C;
	Thu, 26 Nov 2026 14:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZjYY7aq/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93BE1F000C4;
	Thu, 26 Nov 2026 14:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704988;
	bh=mg3+rsBMir8Rkn3mNzIAZkIEWJUrKurMudlPQ0rsThk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZjYY7aq/gYSmZGW1YpMm02iDPGkapLd0jtNHipeUa7JIBhR/cIe2btIq7v9IP0Ofn
	 Hv8AxDkN/lj/L3DnxutVLcEKx4OJ3ULvbuLpK/LuSgFRoRK1ih6RyBG4+3lV3s+tff
	 O72rXeA4DszY8Fj/nuQ9B61lGRQ0mMYYsVyMhskk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/319] spi: Create helper API to lookup ACPI info for spi device
Date: Thu, 26 Nov 2026 15:36:53 +0100
Message-ID: <20261126144007.753736607@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 70dd264bc07aee4f89e65138db11e908701388dd ]

This can then be used to find a spi resource inside an
ACPI node, and allocate a spi device.

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220121172431.6876-3-sbinding@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 2d0953ab69d3 ("spi: acpi: only look up the IRQ of confirmed SPI devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c       | 46 ++++++++++++++++++++++++++++++++---------
 include/linux/spi/spi.h |  6 ++++++
 2 files changed, 42 insertions(+), 10 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index a23fa86493299..45175348b75ea 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2367,8 +2367,18 @@ static int acpi_spi_add_resource(struct acpi_resource *ares, void *data)
 	return 1;
 }
 
-static acpi_status acpi_register_spi_device(struct spi_controller *ctlr,
-					    struct acpi_device *adev)
+/**
+ * acpi_spi_device_alloc - Allocate a spi device, and fill it in with ACPI information
+ * @ctlr: controller to which the spi device belongs
+ * @adev: ACPI Device for the spi device
+ *
+ * This should be used to allocate a new spi device from and ACPI Node.
+ * The caller is responsible for calling spi_add_device to register the spi device.
+ *
+ * Return: a pointer to the new device, or ERR_PTR on error.
+ */
+struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
+					 struct acpi_device *adev)
 {
 	acpi_handle parent_handle = NULL;
 	struct list_head resource_list;
@@ -2376,10 +2386,6 @@ static acpi_status acpi_register_spi_device(struct spi_controller *ctlr,
 	struct spi_device *spi;
 	int ret;
 
-	if (acpi_bus_get_status(adev) || !adev->status.present ||
-	    acpi_device_enumerated(adev))
-		return AE_OK;
-
 	lookup.ctlr		= ctlr;
 	lookup.irq		= -1;
 
@@ -2390,7 +2396,7 @@ static acpi_status acpi_register_spi_device(struct spi_controller *ctlr,
 
 	if (ret < 0)
 		/* found SPI in _CRS but it points to another controller */
-		return AE_OK;
+		return ERR_PTR(-ENODEV);
 
 	if (!lookup.max_speed_hz &&
 	    ACPI_SUCCESS(acpi_get_parent(adev->handle, &parent_handle)) &&
@@ -2400,16 +2406,15 @@ static acpi_status acpi_register_spi_device(struct spi_controller *ctlr,
 	}
 
 	if (!lookup.max_speed_hz)
-		return AE_OK;
+		return ERR_PTR(-ENODEV);
 
 	spi = spi_alloc_device(ctlr);
 	if (!spi) {
 		dev_err(&ctlr->dev, "failed to allocate SPI device for %s\n",
 			dev_name(&adev->dev));
-		return AE_NO_MEMORY;
+		return ERR_PTR(-ENOMEM);
 	}
 
-
 	ACPI_COMPANION_SET(&spi->dev, adev);
 	spi->max_speed_hz	= lookup.max_speed_hz;
 	spi->mode		|= lookup.mode;
@@ -2417,6 +2422,27 @@ static acpi_status acpi_register_spi_device(struct spi_controller *ctlr,
 	spi->bits_per_word	= lookup.bits_per_word;
 	spi->chip_select	= lookup.chip_select;
 
+	return spi;
+}
+EXPORT_SYMBOL_GPL(acpi_spi_device_alloc);
+
+static acpi_status acpi_register_spi_device(struct spi_controller *ctlr,
+					    struct acpi_device *adev)
+{
+	struct spi_device *spi;
+
+	if (acpi_bus_get_status(adev) || !adev->status.present ||
+	    acpi_device_enumerated(adev))
+		return AE_OK;
+
+	spi = acpi_spi_device_alloc(ctlr, adev);
+	if (IS_ERR(spi)) {
+		if (PTR_ERR(spi) == -ENOMEM)
+			return AE_NO_MEMORY;
+		else
+			return AE_OK;
+	}
+
 	acpi_set_modalias(adev, acpi_device_hid(adev), spi->modalias,
 			  sizeof(spi->modalias));
 
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index da88bbc7e9982..0951a67293c7b 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -17,6 +17,7 @@
 #include <linux/ptp_clock_kernel.h>
 
 #include <uapi/linux/spi/spi.h>
+#include <linux/acpi.h>
 
 struct dma_chan;
 struct software_node;
@@ -763,6 +764,11 @@ extern int devm_spi_register_controller(struct device *dev,
 					struct spi_controller *ctlr);
 extern void spi_unregister_controller(struct spi_controller *ctlr);
 
+#if IS_ENABLED(CONFIG_ACPI)
+extern struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
+						struct acpi_device *adev);
+#endif
+
 /*
  * SPI resource management while processing a SPI message
  */
-- 
2.53.0



