Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704994;
	b=dDAuxXAjzJB3OVI5OA6r8Yp1TQHvD8a8cMLpE/rgKOpEvpqgGZIOIXjPz9jBNVW9h5WT
	 AB0hhwJtXVHmZjIMpJbUs+2WLKfSFo2mdkzNtrAznFbAEqxDp92XlP0OIn9uit1fLddVw
	 wL+4ZrlDIl4cwvjXByXHs3juoHK1o+V/WP3rBykZ+P+oUOcKOh+g5WypVSw4BfT8nsKji
	 9FMNaPQNSg1T87usgFOxXqfk7OJDU67ZHZLP0zn2fqlKCBBEB/wYI07cjY2GlvgCtffJR
	 L5AFouqrRHqoMmVaeG9ObsBj882OF9ONNV2vqnokuNNeCX08OAbGlfBkqlWV4qF8SYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pa5ElcGCOeBII7mRtbP8Zme5ztjPPLQtWGCIPQi/eeM=;
	b=ovCRvXD+BqL+1m/UXwKixTXf+VVYbHwaFJU9xzbBM/T9FTiNr/g93e4WsjtnYZ/QYkQ0
	 9uA8pWwKcz6SaJe0CeOQtv05gBZy2dK3Swyxac+zSqFARXTcMc/yEuwvTE+Kq6KM5v36j
	 EcWJLv/dLTxBAO+wJLnSbksckikc5VNOYwKq3JP9XNlqsyvtIrMdb+VxA+55hRO9EMQsD
	 k3VKfCkwiBEdB0KQ+TIXoy6q66/zGWa5HJVhAwkRU8Av9gPnZudPB8z2mGVysU8O2U9zJ
	 YgGB2NaRkF8xa2iT9mnUr/R8j6EWT9uAHkj964Ln8B3ASzi+XzphG0yCHgCpNtWkb2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=do+vdxJ7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC435606A31E;
	Thu, 26 Nov 2026 14:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=do+vdxJ7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DBE1F000C0;
	Thu, 26 Nov 2026 14:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704994;
	bh=Pa5ElcGCOeBII7mRtbP8Zme5ztjPPLQtWGCIPQi/eeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=do+vdxJ7CUyB2Sy/pVsN4YCzCVv8sCki0PzMu6s8c8vJQVHYtwnykA4U1db0iCQ2J
	 JtB05dR0XRolQR5kQ56QUUGoM8EinsDWksrHgk3FknZxf8n6620WCCnHMzQJ4vaPtr
	 VfKKcHgAPwAfaxBlFdDFwQe3JytLwPo6h/fkHuQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/319] spi: Support selection of the index of the ACPI Spi Resource before alloc
Date: Thu, 26 Nov 2026 15:36:54 +0100
Message-ID: <20261126144007.775982325@linuxfoundation.org>
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

[ Upstream commit 92640f98a78c6a3ea1ca32143144241eceb129bd ]

If a node contains more than one SPI resource it may be necessary to
use an index to select which one you want to allocate a spi device for.

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220121172431.6876-4-sbinding@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 2d0953ab69d3 ("spi: acpi: only look up the IRQ of confirmed SPI devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c       | 51 +++++++++++++++++++++++++++++++++++------
 include/linux/spi/spi.h |  3 ++-
 2 files changed, 46 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 45175348b75ea..f582dc4ac176e 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2277,6 +2277,8 @@ struct acpi_spi_lookup {
 	int			irq;
 	u8			bits_per_word;
 	u8			chip_select;
+	int			n;
+	int			index;
 };
 
 static void acpi_spi_parse_apple_properties(struct acpi_device *dev,
@@ -2308,6 +2310,8 @@ static void acpi_spi_parse_apple_properties(struct acpi_device *dev,
 		lookup->mode |= SPI_CPHA;
 }
 
+static struct spi_controller *acpi_spi_find_controller_by_adev(struct acpi_device *adev);
+
 static int acpi_spi_add_resource(struct acpi_resource *ares, void *data)
 {
 	struct acpi_spi_lookup *lookup = data;
@@ -2321,14 +2325,35 @@ static int acpi_spi_add_resource(struct acpi_resource *ares, void *data)
 		sb = &ares->data.spi_serial_bus;
 		if (sb->type == ACPI_RESOURCE_SERIAL_TYPE_SPI) {
 
+			if (lookup->index != -1 && lookup->n++ != lookup->index)
+				return 1;
+
+			if (lookup->index == -1 && !ctlr)
+				return -ENODEV;
+
 			status = acpi_get_handle(NULL,
 						 sb->resource_source.string_ptr,
 						 &parent_handle);
 
-			if (ACPI_FAILURE(status) ||
-			    ACPI_HANDLE(ctlr->dev.parent) != parent_handle)
+			if (ACPI_FAILURE(status))
 				return -ENODEV;
 
+			if (ctlr) {
+				if (ACPI_HANDLE(ctlr->dev.parent) != parent_handle)
+					return -ENODEV;
+			} else {
+				struct acpi_device *adev;
+
+				if (acpi_bus_get_device(parent_handle, &adev))
+					return -ENODEV;
+
+				ctlr = acpi_spi_find_controller_by_adev(adev);
+				if (!ctlr)
+					return -ENODEV;
+
+				lookup->ctlr = ctlr;
+			}
+
 			/*
 			 * ACPI DeviceSelection numbering is handled by the
 			 * host controller driver in Windows and can vary
@@ -2371,14 +2396,21 @@ static int acpi_spi_add_resource(struct acpi_resource *ares, void *data)
  * acpi_spi_device_alloc - Allocate a spi device, and fill it in with ACPI information
  * @ctlr: controller to which the spi device belongs
  * @adev: ACPI Device for the spi device
+ * @index: Index of the spi resource inside the ACPI Node
  *
  * This should be used to allocate a new spi device from and ACPI Node.
  * The caller is responsible for calling spi_add_device to register the spi device.
  *
+ * If ctlr is set to NULL, the Controller for the spi device will be looked up
+ * using the resource.
+ * If index is set to -1, index is not used.
+ * Note: If index is -1, ctlr must be set.
+ *
  * Return: a pointer to the new device, or ERR_PTR on error.
  */
 struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
-					 struct acpi_device *adev)
+					 struct acpi_device *adev,
+					 int index)
 {
 	acpi_handle parent_handle = NULL;
 	struct list_head resource_list;
@@ -2386,8 +2418,13 @@ struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
 	struct spi_device *spi;
 	int ret;
 
+	if (!ctlr && index == -1)
+		return ERR_PTR(-EINVAL);
+
 	lookup.ctlr		= ctlr;
 	lookup.irq		= -1;
+	lookup.index		= index;
+	lookup.n		= 0;
 
 	INIT_LIST_HEAD(&resource_list);
 	ret = acpi_dev_get_resources(adev, &resource_list,
@@ -2400,7 +2437,7 @@ struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
 
 	if (!lookup.max_speed_hz &&
 	    ACPI_SUCCESS(acpi_get_parent(adev->handle, &parent_handle)) &&
-	    ACPI_HANDLE(ctlr->dev.parent) == parent_handle) {
+	    ACPI_HANDLE(lookup.ctlr->dev.parent) == parent_handle) {
 		/* Apple does not use _CRS but nested devices for SPI slaves */
 		acpi_spi_parse_apple_properties(adev, &lookup);
 	}
@@ -2408,9 +2445,9 @@ struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
 	if (!lookup.max_speed_hz)
 		return ERR_PTR(-ENODEV);
 
-	spi = spi_alloc_device(ctlr);
+	spi = spi_alloc_device(lookup.ctlr);
 	if (!spi) {
-		dev_err(&ctlr->dev, "failed to allocate SPI device for %s\n",
+		dev_err(&lookup.ctlr->dev, "failed to allocate SPI device for %s\n",
 			dev_name(&adev->dev));
 		return ERR_PTR(-ENOMEM);
 	}
@@ -2435,7 +2472,7 @@ static acpi_status acpi_register_spi_device(struct spi_controller *ctlr,
 	    acpi_device_enumerated(adev))
 		return AE_OK;
 
-	spi = acpi_spi_device_alloc(ctlr, adev);
+	spi = acpi_spi_device_alloc(ctlr, adev, -1);
 	if (IS_ERR(spi)) {
 		if (PTR_ERR(spi) == -ENOMEM)
 			return AE_NO_MEMORY;
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 0951a67293c7b..c7d865ffcc90a 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -766,7 +766,8 @@ extern void spi_unregister_controller(struct spi_controller *ctlr);
 
 #if IS_ENABLED(CONFIG_ACPI)
 extern struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
-						struct acpi_device *adev);
+						struct acpi_device *adev,
+						int index);
 #endif
 
 /*
-- 
2.53.0



