Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213FA1CA8F;
	Mon,  1 Apr 2024 16:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988999; cv=none; b=GDk3CDAKyv7UyNi4503YvNazNOROrgrk0GY7/pdQzCRqMNETxUosajRR8DMg3lF42NAOJLdvBBO1ZjkeJI1DFE79INIf39kkH8U9beAsV9Ou0KankRTi5/gm9R/Xf7HVtPV5R6rfa3E8pOVVTO+sTbMVSoerED1CxWd1xc80//w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988999; c=relaxed/simple;
	bh=ZKS4Jzkz4HKQEFM4jDkSSt47Hrz2y9OTtHZRxVp4jqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BN51/OxOI2rvpl+EwnRpd9YZbJoaa1dmyo7E2RCSuviVt6BOnfro4JJBrT7ddLR2ZJuYAV8REz8WcIeoBjgqru5tigiijDW1J5/eEYjHMwdiQLtBVkd7NQsWg1rkJVlJ4UYE5ZoNNDGw8BYTUtTY4+ogUozHhitL4oS3fYyUx1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iBHwCjU1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iBHwCjU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5308DC43390;
	Mon,  1 Apr 2024 16:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988999;
	bh=ZKS4Jzkz4HKQEFM4jDkSSt47Hrz2y9OTtHZRxVp4jqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iBHwCjU1pvn1VrpL5KXOOeD4HslsqkqM5g7xO5dV7Yfb2EEAhUC8bPHoJ8mY78BN4
	 3Zwf/objVISJMlvraafYB3kVDNWLhqO13d+4VILmq71NOUJQ3Dy70gTCEaJCqRACgG
	 EC1G/Udw9NbROCtrvLXYhAjASInAXX3h82uwAm5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandrs Vinarskis <alex.vinarskis@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.7 323/432] mfd: intel-lpss: Introduce QUIRK_CLOCK_DIVIDER_UNITY for XPS 9530
Date: Mon,  1 Apr 2024 17:45:10 +0200
Message-ID: <20240401152602.832783067@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandrs Vinarskis <alex.vinarskis@gmail.com>

commit 1d8c51ed2ddcc4161e6496cf14fcd83921c50ec8 upstream.

Some devices (eg. Dell XPS 9530, 2023) due to a firmware bug have a
misconfigured clock divider, which should've been 1:1. This introduces
quirk which conditionally re-configures the clock divider to 1:1.

Signed-off-by: Aleksandrs Vinarskis <alex.vinarskis@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20231221185142.9224-3-alex.vinarskis@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/intel-lpss-pci.c |    5 +++++
 drivers/mfd/intel-lpss.c     |    7 +++++++
 drivers/mfd/intel-lpss.h     |    5 +++++
 3 files changed, 17 insertions(+)

--- a/drivers/mfd/intel-lpss-pci.c
+++ b/drivers/mfd/intel-lpss-pci.c
@@ -29,6 +29,11 @@ static const struct pci_device_id quirk_
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_INTEL, 0x9d64, 0x152d, 0x1237),
 		.driver_data = QUIRK_IGNORE_RESOURCE_CONFLICTS,
 	},
+	{
+		/* Dell XPS 9530 (2023) */
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_INTEL, 0x51fb, 0x1028, 0x0beb),
+		.driver_data = QUIRK_CLOCK_DIVIDER_UNITY,
+	},
 	{ }
 };
 
--- a/drivers/mfd/intel-lpss.c
+++ b/drivers/mfd/intel-lpss.c
@@ -292,6 +292,7 @@ static int intel_lpss_register_clock_div
 {
 	char name[32];
 	struct clk *tmp = *clk;
+	int ret;
 
 	snprintf(name, sizeof(name), "%s-enable", devname);
 	tmp = clk_register_gate(NULL, name, __clk_get_name(tmp), 0,
@@ -308,6 +309,12 @@ static int intel_lpss_register_clock_div
 		return PTR_ERR(tmp);
 	*clk = tmp;
 
+	if (lpss->info->quirks & QUIRK_CLOCK_DIVIDER_UNITY) {
+		ret = clk_set_rate(tmp, lpss->info->clk_rate);
+		if (ret)
+			return ret;
+	}
+
 	snprintf(name, sizeof(name), "%s-update", devname);
 	tmp = clk_register_gate(NULL, name, __clk_get_name(tmp),
 				CLK_SET_RATE_PARENT, lpss->priv, 31, 0, NULL);
--- a/drivers/mfd/intel-lpss.h
+++ b/drivers/mfd/intel-lpss.h
@@ -19,6 +19,11 @@
  * Set to ignore resource conflicts with ACPI declared SystemMemory regions.
  */
 #define QUIRK_IGNORE_RESOURCE_CONFLICTS BIT(0)
+/*
+ * Some devices have misconfigured clock divider due to a firmware bug.
+ * Set this to force the clock divider to 1:1 ratio.
+ */
+#define QUIRK_CLOCK_DIVIDER_UNITY		BIT(1)
 
 struct device;
 struct resource;


