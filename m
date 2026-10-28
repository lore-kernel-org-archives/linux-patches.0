Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216800;
	b=GDqRVPiAFoe52RikkXL2S7SzyCPmoTEhRR/aQaRHfkVJviDO9U5YW1/L56VNl8nDWpGF
	 LRU67QN595foNRa2gHnmjTCpfgyBk9zdpfR5sBDmiP8OU+3n0FilMhCDVq3DESxwEG7NI
	 B5Gwr0Kj1VcpdAE7iiwfbShPgh8AQ2zWOfFgu5Uq4D2oR3CagHGmoxV78c+hXC3/LUv+/
	 ecPqhnr/ARCn6tsaP6wvHqr4lZ4dK5Saizf/kXfjUf8Wgu9uajSlRLYcOjPTyu4jqxHBC
	 9czMkObgGjqMdQ71FAbkZdmEsPiy2apnoQZ/cBSSCc+jMrb5p+6qjtFOxf7Sr0ZZ+Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=LQzg0cj35JkCkQKcAWLwhOJ12ByVF0CNZqFlKBOMRSQ=;
	b=aVcnlUIeSihxkTXhN1uKCqqkDH5d3lj5pWNbKPdmMtxpgazDVl5RSinfnmne09IILuFd
	 fxSxbo+Ft0yvoBZ7WtZhwA5N2AJyTCYw19i7jKbCWEFnpBVXOWYRKApRv9XLnm7/svSdg
	 jeKW4EcSzFaujQw7POPlgQrz5CejudKNAdAUtUV28Qs94+gTZJrj8zdiAgqGWospNvWxE
	 UiZojVveGsmgsEHp38jaSpK1Acnxhu36y+VDktE0F3eQN1Sl9uqh6HqZ/qCcccFXv4mH7
	 CRY1c6HCstGJayNywhAMiwlsrzowtsoxeeWKGQR0rnqYpyivQMDnCdK/L8F9UKZDT2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bWXiit4B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05C0606A31A;
	Wed, 28 Oct 2026 19:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bWXiit4B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EEB1F01825;
	Wed, 28 Oct 2026 19:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216799;
	bh=LQzg0cj35JkCkQKcAWLwhOJ12ByVF0CNZqFlKBOMRSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bWXiit4BBke/J6qlcWwoRuUD9hTMYcLeG4HklL4leqVwzgXmlXiZAzHJxTvFxXTWI
	 wus/qBDLOCfv34EHH4BhZWYachK5T8tjRgZL0Kxjnp2R1wH+5s2GsfDwLh+GknT8cl
	 lrTk3RLLr69fYeDwwCyxFRs7cDBje1L3zklH9Hy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1682/1887] PCI/sysfs: Demacrofy pci_dev_resource_resize_attr(n) functions
Date: Wed, 28 Oct 2026 18:02:58 +0100
Message-ID: <20261028170537.734716123@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit f6c73999837820f98519bf0146df44e58f20f89c ]

pci_dev_resource_resize_attr(n) macro is invoked for six resources,
creating a large footprint function for each resource.

Rework the macro to only create a function that calls a helper function so
the compiler can decide if it warrants to inline the function or not.

With x86_64 defconfig, this saves roughly 2.5kB:

  $ scripts/bloat-o-meter drivers/pci/pci-sysfs.o{.old,.new}
  add/remove: 1/0 grow/shrink: 0/6 up/down: 512/-2934 (-2422)
  Function                                     old     new   delta
  __resource_resize_store                        -     512    +512
  resource5_resize_store                       503      14    -489
  resource4_resize_store                       503      14    -489
  resource3_resize_store                       503      14    -489
  resource2_resize_store                       503      14    -489
  resource1_resize_store                       503      14    -489
  resource0_resize_store                       500      11    -489
  Total: Before=13399, After=10977, chg -18.08%

(The compiler seemingly chose to still inline __resource_resize_show()
which is fine, those functions are not very complex/large.)

Link: https://lore.kernel.org/r/20240222114607.1837-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Stable-dep-of: 25ec7f57dece ("PCI/sysfs: Add CAP_SYS_ADMIN check to __resource_resize_store()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-sysfs.c | 122 ++++++++++++++++++++++------------------
 1 file changed, 66 insertions(+), 56 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index d0ec908908303..f6bf0b99ce63c 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1433,71 +1433,81 @@ static const struct attribute_group pci_dev_reset_attr_group = {
 	.is_visible = pci_dev_reset_attr_is_visible,
 };
 
+static ssize_t __resource_resize_show(struct device *dev, int n, char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	ssize_t ret;
+
+	pci_config_pm_runtime_get(pdev);
+
+	ret = sysfs_emit(buf, "%016llx\n",
+			 (u64)pci_rebar_get_possible_sizes(pdev, n));
+
+	pci_config_pm_runtime_put(pdev);
+
+	return ret;
+}
+
+static ssize_t __resource_resize_store(struct device *dev, int n,
+				       const char *buf, size_t count)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	unsigned long size;
+	int ret;
+	u16 cmd;
+
+	if (kstrtoul(buf, 0, &size) < 0)
+		return -EINVAL;
+
+	device_lock(dev);
+	if (dev->driver) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	pci_config_pm_runtime_get(pdev);
+
+	if ((pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA) {
+		ret = aperture_remove_conflicting_pci_devices(pdev,
+						"resourceN_resize");
+		if (ret)
+			goto pm_put;
+	}
+
+	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
+	pci_write_config_word(pdev, PCI_COMMAND,
+			      cmd & ~PCI_COMMAND_MEMORY);
+
+	pci_remove_resource_files(pdev);
+
+	ret = pci_resize_resource(pdev, n, size, 0);
+
+	pci_assign_unassigned_bus_resources(pdev->bus);
+
+	if (pci_create_resource_files(pdev))
+		pci_warn(pdev, "Failed to recreate resource files after BAR resizing\n");
+
+	pci_write_config_word(pdev, PCI_COMMAND, cmd);
+pm_put:
+	pci_config_pm_runtime_put(pdev);
+unlock:
+	device_unlock(dev);
+
+	return ret ? ret : count;
+}
+
 #define pci_dev_resource_resize_attr(n)					\
 static ssize_t resource##n##_resize_show(struct device *dev,		\
 					 struct device_attribute *attr,	\
-					 char * buf)			\
+					 char *buf)			\
 {									\
-	struct pci_dev *pdev = to_pci_dev(dev);				\
-	ssize_t ret;							\
-									\
-	pci_config_pm_runtime_get(pdev);				\
-									\
-	ret = sysfs_emit(buf, "%016llx\n",				\
-			 (u64)pci_rebar_get_possible_sizes(pdev, n));	\
-									\
-	pci_config_pm_runtime_put(pdev);				\
-									\
-	return ret;							\
+	return __resource_resize_show(dev, n, buf);			\
 }									\
-									\
 static ssize_t resource##n##_resize_store(struct device *dev,		\
 					  struct device_attribute *attr,\
 					  const char *buf, size_t count)\
 {									\
-	struct pci_dev *pdev = to_pci_dev(dev);				\
-	unsigned long size;						\
-	int ret;							\
-	u16 cmd;							\
-									\
-	if (kstrtoul(buf, 0, &size) < 0)				\
-		return -EINVAL;						\
-									\
-	device_lock(dev);						\
-	if (dev->driver) {						\
-		ret = -EBUSY;						\
-		goto unlock;						\
-	}								\
-									\
-	pci_config_pm_runtime_get(pdev);				\
-									\
-	if ((pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA) {		\
-		ret = aperture_remove_conflicting_pci_devices(pdev,	\
-						"resourceN_resize");	\
-		if (ret)						\
-			goto pm_put;					\
-	}								\
-									\
-	pci_read_config_word(pdev, PCI_COMMAND, &cmd);			\
-	pci_write_config_word(pdev, PCI_COMMAND,			\
-			      cmd & ~PCI_COMMAND_MEMORY);		\
-									\
-	pci_remove_resource_files(pdev);				\
-									\
-	ret = pci_resize_resource(pdev, n, size, 0);			\
-									\
-	pci_assign_unassigned_bus_resources(pdev->bus);			\
-									\
-	if (pci_create_resource_files(pdev))				\
-		pci_warn(pdev, "Failed to recreate resource files after BAR resizing\n");\
-									\
-	pci_write_config_word(pdev, PCI_COMMAND, cmd);			\
-pm_put:									\
-	pci_config_pm_runtime_put(pdev);				\
-unlock:									\
-	device_unlock(dev);						\
-									\
-	return ret ? ret : count;					\
+	return __resource_resize_store(dev, n, buf, count);		\
 }									\
 static DEVICE_ATTR_RW(resource##n##_resize)
 
-- 
2.53.0



