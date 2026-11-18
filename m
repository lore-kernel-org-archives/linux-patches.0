Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023614;
	b=rHiH+zP/KNj81lEY36pu9uwYPfFozmc7j2dzyspixl2LW0nEINmhZqJz3tmWX8jzyXkI
	 6Jh0xq4fVtoexCrfeox1d5H3iTAr6zKSSNNuPhS9pT71S14rL6pJkzV6vF+2xCXDvxckz
	 7ApAS2xyMgxL4G59AiKA0Gccwmn6JyV/G5dB9tPh8Sn1QDZfNT24tPnBM8Txvs4nrRQ04
	 QofEX2FCMdS8QZbK9qYZV8hHy9gJ68cobvYNnbmQXqeWHGKOQf1fB5sjMPOOmW6eM0FNf
	 IDInQFZZ/xHPyFkXHn2DXbxqZpNz/be2WO5m+M7RQJmCFeiD2Iwp46vOgL0rJQ+uhNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QeD0GqnWXNNEeFuhnAtEcEhkKczKQZ1wHxLu+3srWLc=;
	b=Lzh2YxKrAvl8kBHtNigBnfm3gxq5qnzn4kbUPBY/xCjBOZ9Omut/Vdo/5RpXEeNGIydj
	 yB+C8+LN7n7Dp9tagMRjmj6kz8Uwu5NUZLvPbEfpGJEorwTVHe8iM300UZaKpKYR/8WXg
	 wsgVK9xJW6XEpdhRPfmm9gp/nT3+QwlIvRgK+j1r0cbCC50DezsqRRX/W2V1DQVXZJPYx
	 hpgUPW1VhkwJAkg9MUzeHNC0TZp+9x3ojAOW4CAoPUG/A9hqNozDDqVRSwx4ujA6xJnEc
	 2jMNFRl2fQU48jtvbJOtfxdLRVSz7BM0RVMzGEgiS9uvmcL2eXS9zH/NW5qCMN8P9MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="p2GKR9/J";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0798606A31C;
	Wed, 18 Nov 2026 17:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p2GKR9/J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21FEE1F000C4;
	Wed, 18 Nov 2026 17:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023614;
	bh=QeD0GqnWXNNEeFuhnAtEcEhkKczKQZ1wHxLu+3srWLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p2GKR9/JwpUYjI8nBVi9gDmEaF2ZZ6LQ/vYSEK0jCWuDu9sNxfnaAJI+AYCjjRlt2
	 dYzicZX67x+q1q3M+wdl8YoSjdOe4BbqVQANVXlm9rOxjSASzPPeFgqyiUGp3gXRAG
	 nAFf2i4+LnGyU6owmS2TShxCqAgKphUIRadZPv10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0391/2151] ACPI: glue: Fix up and adjust acpi_unbind_one()
Date: Wed, 18 Nov 2026 15:35:26 +0100
Message-ID: <20261118150136.310842765@linuxfoundation.org>
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
index 271eac337506a..e2a40847d24b6 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -331,13 +331,13 @@ int acpi_bind_one(struct device *dev, struct acpi_device *acpi_dev)
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
 
@@ -352,15 +352,17 @@ int acpi_unbind_one(struct device *dev)
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
index 53aad501458f8..d6b449c6ecd3a 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -720,7 +720,7 @@ struct acpi_bus_type {
 int register_acpi_bus_type(struct acpi_bus_type *);
 int unregister_acpi_bus_type(struct acpi_bus_type *);
 int acpi_bind_one(struct device *dev, struct acpi_device *adev);
-int acpi_unbind_one(struct device *dev);
+void acpi_unbind_one(struct device *dev);
 
 enum acpi_bridge_type {
 	ACPI_BRIDGE_TYPE_PCIE = 1,
-- 
2.53.0



