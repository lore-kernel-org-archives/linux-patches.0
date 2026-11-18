Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054002;
	b=rFTBrMBHHWdzkLFcgJ8nOQ9gnee7Zy+Ry504XR95BrpI6qkNn8QErKK455JMDxbHjFTa
	 ljxBIdGFIy4H+vcz4I1VdWqmuOzb5rHZqeA8Twg5KzfKBKo4gKmWkrZTyWnb6GOqh7gXK
	 2rN1L6uU5q1HhctxmNc0Jwed0Puzs+BwOSeoSYDFOvjajSuJNnzR6+f7IadLtKx7QWzrl
	 zLhjGk1V7fISMNUdeft1pyMt00vAGQ0nKpqPs0cwtF6b358Yemeqks/hPOSUP1R5AMCpl
	 YyqpDgjyXh1xu5bEjo8duybL+3bXFztbQJZzAx3+Wtu4ipqGoViS20Yup+vWFIFf3jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QW3J4hFnCUyLZWkCiBKn9LwHxej83BqNUmcU9PtU1Wo=;
	b=wEmiM0r4mCo/AZuqg+24LWH/NibWtnmVVnbP+JeGJzR4hUoEYKYyoP0zJ4crDA1T3W9B
	 60j0FeBL1O1LvgbUoMWOsI3drA1lXApKdfual8BaPUnDNNzoJUHSOPrJaijEsC2KWsDgB
	 ZfpzRbSIvPkQuIIRsv2qBeJ6u/DvLgMO8fDsvapmhxtP4WHGffrEoEVvsz6+gNY6csIC7
	 E0l8mFz6L8nBp15DJL8zSeqBfyDopKKb7q4j2LZm8Xlrr72RsBmTBQVQmuCKhupN4jOur
	 MW+SZ2C0zvgbzTxpGqoLgQ1fcT0fsHflS1cUnUfeNLPnnlciQjPfyCaD8PaqxYIVPOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=knfEKIiW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7BC606A31C;
	Thu, 19 Nov 2026 02:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=knfEKIiW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AF01F000C4;
	Thu, 19 Nov 2026 02:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054001;
	bh=QW3J4hFnCUyLZWkCiBKn9LwHxej83BqNUmcU9PtU1Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=knfEKIiWfGNwzDdnwo+hB+uwKi6Dqer9ykerTUVzkbbYBekIvrvL2EPSJ/yRTdfLV
	 2km0g7u1kD8HK5YxdCCNYeFtKuRSZORTDvkX7ZstrQDox/1hVhTVop3p6hSeDjyfUI
	 eTM/wwIYZn1ehAaP+h3ipcm6knrklOSOR6+AD+DI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Wolfram Sang <wsa@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1121/2214] i2c: acpi: Add i2c_acpi_new_device_by_fwnode() function
Date: Wed, 18 Nov 2026 15:46:37 +0100
Message-ID: <20261118150056.940056893@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit c537be0bfad6337f2afd618fe252c03217191405 ]

Change i2c_acpi_new_device() into i2c_acpi_new_device_by_fwnode() and
add a static inline wrapper providing the old i2c_acpi_new_device()
behavior.

This is necessary because in some cases we may only have access
to the fwnode / acpi_device and not to the matching physical-node
struct device *.

Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20211203102857.44539-4-hdegoede@redhat.com
Stable-dep-of: a65917d0a22f ("i2c: acpi: Fix adapter reference leak in i2c_acpi_new_device_by_fwnode()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-acpi.c | 17 +++++++++++------
 include/linux/i2c.h         | 17 +++++++++++++----
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/i2c/i2c-core-acpi.c b/drivers/i2c/i2c-core-acpi.c
index 93bd78137ea67..1ee80ada212c3 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -501,8 +501,8 @@ struct notifier_block i2c_acpi_notifier = {
 };
 
 /**
- * i2c_acpi_new_device - Create i2c-client for the Nth I2cSerialBus resource
- * @dev:     Device owning the ACPI resources to get the client from
+ * i2c_acpi_new_device_by_fwnode - Create i2c-client for the Nth I2cSerialBus resource
+ * @fwnode:  fwnode with the ACPI resources to get the client from
  * @index:   Index of ACPI resource to get
  * @info:    describes the I2C device; note this is modified (addr gets set)
  * Context: can sleep
@@ -518,15 +518,20 @@ struct notifier_block i2c_acpi_notifier = {
  * Returns a pointer to the new i2c-client, or error pointer in case of failure.
  * Specifically, -EPROBE_DEFER is returned if the adapter is not found.
  */
-struct i2c_client *i2c_acpi_new_device(struct device *dev, int index,
-				       struct i2c_board_info *info)
+struct i2c_client *i2c_acpi_new_device_by_fwnode(struct fwnode_handle *fwnode,
+						 int index,
+						 struct i2c_board_info *info)
 {
-	struct acpi_device *adev = ACPI_COMPANION(dev);
 	struct i2c_acpi_lookup lookup;
 	struct i2c_adapter *adapter;
+	struct acpi_device *adev;
 	LIST_HEAD(resource_list);
 	int ret;
 
+	adev = to_acpi_device_node(fwnode);
+	if (!adev)
+		return ERR_PTR(-ENODEV);
+
 	memset(&lookup, 0, sizeof(lookup));
 	lookup.info = info;
 	lookup.device_handle = acpi_device_handle(adev);
@@ -548,7 +553,7 @@ struct i2c_client *i2c_acpi_new_device(struct device *dev, int index,
 
 	return i2c_new_client_device(adapter, info);
 }
-EXPORT_SYMBOL_GPL(i2c_acpi_new_device);
+EXPORT_SYMBOL_GPL(i2c_acpi_new_device_by_fwnode);
 
 #ifdef CONFIG_ACPI_I2C_OPREGION
 static int acpi_gsb_i2c_read_bytes(struct i2c_client *client,
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index b115fb9e2071e..7910dad637d44 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -1038,8 +1038,9 @@ bool i2c_acpi_get_i2c_resource(struct acpi_resource *ares,
 			       struct acpi_resource_i2c_serialbus **i2c);
 int i2c_acpi_client_count(struct acpi_device *adev);
 u32 i2c_acpi_find_bus_speed(struct device *dev);
-struct i2c_client *i2c_acpi_new_device(struct device *dev, int index,
-				       struct i2c_board_info *info);
+struct i2c_client *i2c_acpi_new_device_by_fwnode(struct fwnode_handle *fwnode,
+						 int index,
+						 struct i2c_board_info *info);
 struct i2c_adapter *i2c_acpi_find_adapter_by_handle(acpi_handle handle);
 #else
 static inline bool i2c_acpi_get_i2c_resource(struct acpi_resource *ares,
@@ -1055,8 +1056,9 @@ static inline u32 i2c_acpi_find_bus_speed(struct device *dev)
 {
 	return 0;
 }
-static inline struct i2c_client *i2c_acpi_new_device(struct device *dev,
-					int index, struct i2c_board_info *info)
+static inline struct i2c_client *i2c_acpi_new_device_by_fwnode(
+					struct fwnode_handle *fwnode, int index,
+					struct i2c_board_info *info)
 {
 	return ERR_PTR(-ENODEV);
 }
@@ -1066,4 +1068,11 @@ static inline struct i2c_adapter *i2c_acpi_find_adapter_by_handle(acpi_handle ha
 }
 #endif /* CONFIG_ACPI */
 
+static inline struct i2c_client *i2c_acpi_new_device(struct device *dev,
+						     int index,
+						     struct i2c_board_info *info)
+{
+	return i2c_acpi_new_device_by_fwnode(dev_fwnode(dev), index, info);
+}
+
 #endif /* _LINUX_I2C_H */
-- 
2.53.0



