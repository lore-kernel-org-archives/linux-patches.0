Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016090;
	b=abI4UO7vCf0xmOFMHDTOgb4ie/nlPHb30ObEa18niYmDynNKyEd/Dak63bFuysZ0zwGv
	 1pKqJwJ/Q3IVveAf5tcYcLqdmv6yPr47IhbJYf1LoJBJp1TkBkVDCaI3MkOAwPQWx2pTp
	 cUDgeDRf0FqT6dP5m5DGwZozVY13ksm5M4VRaaQXPKir7LCp4K/s+gSLA4nWhfH+J3sD4
	 WhA7c0b96fGKTLCjuNdU4Bju56eXtwwKt7zaRZe/0++DqUWs9ehLYKy7gfOmVP3q5VARx
	 q9mXOuzrGLnRExX5Gi2U5dKAxFgEhmjK+n/UQMn4LYD+JWzRVaZ942QWVh2AzCE9GTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016090;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uYSLVG09IfF6jwmGeqLsFZhepEwtWpJVhk7Fhs9NeuA=;
	b=nrj8ogoH04+Xp/yY3l8sFffcIayDkX4F8FIDV7il21znnyttrmT2NiSbKtdJfLNzTCN0
	 ZiyCnX4xvd4TcuOvbVQccKOL6fzFJbVQtLxuM4ebeoGXwAY6+xgFDtyRkM5JPn+PhaJXs
	 Gzyo8uXyTN5go+QxFsxNa0Gx3CeVYfQhEJI9q9NjluLacw7qYoUZ0kGpCBl8k4/miamGs
	 /zlxL+tlepqFpYjV4sMW0bJTChxMQJMa481o57TqOc+fZBupoDhvt6UbyieqNpeOTq/Go
	 UvvEI+ca782Tk94dpY/rgVgi9OZzokeE88H2a/C3IySw2GwNqdKaGPaq3Dsmsiy4sdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LvawQJ3F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1165606A33A;
	Wed, 18 Nov 2026 15:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LvawQJ3F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417471F000C4;
	Wed, 18 Nov 2026 15:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016089;
	bh=uYSLVG09IfF6jwmGeqLsFZhepEwtWpJVhk7Fhs9NeuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LvawQJ3FJ0BEb0QYBB7Bndp2cI6avPKqMMLJERqrbGr4Mq4BmDLTdodj5gRelBnT9
	 PApxIMggDSkokO/7H/R9sljhpy4uqPXQL6K6r90rccbkqlxd6/5UygM1e3caCNeKEZ
	 /jZFR2toIwVTPcV5LaCLV8D7V+JZ0nKKzIGFoU2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0405/2651] ACPI: glue: Fix up and adjust acpi_unbind_one()
Date: Wed, 18 Nov 2026 15:27:25 +0100
Message-ID: <20261118150302.414374955@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 693546852656075e0247ac637b05625ead134eff ]

Since none of the acpi_unbind_one() callers check its return value and
it always returns 0 anyway, make it void.

Also notice that unlocking physical_node_lock for the given ACPI device
should be carried out before dropping the reference to it in case that
reference is the last one (highly unlikely), so rearrange the code to
make that happen.

Fixes: 3e3327837c18 ("ACPI: Use list_for_each_entry() in acpi_unbind_one()")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/10940500.nUPlyArG6x@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/glue.c     | 10 ++++++----
 include/acpi/acpi_bus.h |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index 1e9e7150b95a7..e55daa4221da8 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -321,13 +321,13 @@ int acpi_bind_one(struct device *dev, struct acpi_device *acpi_dev)
 }
 EXPORT_SYMBOL_GPL(acpi_bind_one);
 
-int acpi_unbind_one(struct device *dev)
+void acpi_unbind_one(struct device *dev)
 {
 	struct acpi_device *acpi_dev = ACPI_COMPANION(dev);
 	struct acpi_device_physical_node *entry;
 
 	if (!acpi_dev)
-		return 0;
+		return;
 
 	mutex_lock(&acpi_dev->physical_node_lock);
 
@@ -342,15 +342,17 @@ int acpi_unbind_one(struct device *dev)
 			sysfs_remove_link(&acpi_dev->dev.kobj, physnode_name);
 			sysfs_remove_link(&dev->kobj, "firmware_node");
 			ACPI_COMPANION_SET(dev, NULL);
+
+			mutex_unlock(&acpi_dev->physical_node_lock);
+
 			/* Drop references taken by acpi_bind_one(). */
 			put_device(dev);
 			acpi_dev_put(acpi_dev);
 			kfree(entry);
-			break;
+			return;
 		}
 
 	mutex_unlock(&acpi_dev->physical_node_lock);
-	return 0;
 }
 EXPORT_SYMBOL_GPL(acpi_unbind_one);
 
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 8b1d329455f7b..40df037804a5d 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -672,7 +672,7 @@ struct acpi_bus_type {
 int register_acpi_bus_type(struct acpi_bus_type *);
 int unregister_acpi_bus_type(struct acpi_bus_type *);
 int acpi_bind_one(struct device *dev, struct acpi_device *adev);
-int acpi_unbind_one(struct device *dev);
+void acpi_unbind_one(struct device *dev);
 
 enum acpi_bridge_type {
 	ACPI_BRIDGE_TYPE_PCIE = 1,
-- 
2.53.0



