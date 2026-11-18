Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029472;
	b=ag8hUc1yoAm3fgf8pAVbBJWCHHgr7WEkXucKEi028yBvnnKV6p6vTCdwjI0yTxT2qDfF
	 011SncQCLG6z4f989rHnUlHIkJ7+4peSBNhjy3O9uWK2mn/EXqTAGb74vaotTCEdYNnRt
	 Df8iT++MczTU07dPvX9wBLFV1Yt7awfOcS/XCyjNUGSDVsmJJDh0Y3LxbUgHOXyuOLW1n
	 k65/R18kq24GROTGHNnyGKJdQNybVSq2pLTOyCpn/X8/umciwSpvKk744oLIznmtRvfy1
	 mc3Aw95X9sPVSs7hEq0o69VR9YGuM4Gd9sNdP3PCNqrUJD/J/PlWhNP0k97xSw9exPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ydK8oh5dTt8N5ElyOcVpGApy0x9d+zowubGgu5cY5zs=;
	b=yUekKKQwXXxiuw2FwgmBxPDNgsTepeTVNbaJZ/M3BnzQAlMJ7ZWh2Z6CEqOHUDUZ1ZAO
	 Vl7WOxShGMOG13xgkaQKYfEwcORL+xv3WPR7d58QHenvboOLOqsGQbybL9EGnKlZfql0G
	 adQ2PpGCvUC3sCl8uGfcskgJfkHkcRWiYe9wM3F17SvpMIqith8ZNOgUyWY1cxqGlqS5l
	 Wh9XIot/N/p0fEhVXVHob4gR2NIxj91K0tmrnpPx5ZS2MpqPGSkAXfDw65CdetjRGdrVA
	 OAONxiv7CFDZIsrffp7isnm0qZuC0RZRYAuuZW/lzKcnqCmSDEFCNTk1KGK1sxB1l4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aZ25xC4q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D78E606A325;
	Wed, 18 Nov 2026 19:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aZ25xC4q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4261F000C4;
	Wed, 18 Nov 2026 19:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029472;
	bh=ydK8oh5dTt8N5ElyOcVpGApy0x9d+zowubGgu5cY5zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aZ25xC4ql/uVe6GGsIwAWFKbMVWy8dBSGTHO7ailOs5FSkDgwWjV+NUjgLQlWNjXI
	 UoyRhdirEDy3TlZBkdz3ouBkUE0dWGfDsL9NiKMDacTq9otLhDD/IQnFqyfRNnA6BJ
	 aMLwA4RQ3bDuzPG7UKQgQms/YZncc0sdOU7CcdWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0360/1756] ACPI: glue: Fix up and adjust acpi_unbind_one()
Date: Wed, 18 Nov 2026 15:41:27 +0100
Message-ID: <20261118150022.658408698@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index a194f30876c59..cc9ee8cb820fc 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -316,13 +316,13 @@ int acpi_bind_one(struct device *dev, struct acpi_device *acpi_dev)
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
 
@@ -337,15 +337,17 @@ int acpi_unbind_one(struct device *dev)
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
index f46464d1430a2..0f1a84481279e 100644
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



