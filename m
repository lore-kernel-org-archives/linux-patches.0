Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DE317BBF;
	Mon,  2 Jun 2025 14:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875222; cv=none; b=eLFfWFzUR29iUihzaGVKBwlrM52vMUwaveqGIU9sIZcPYAcf+vLEGVh4pke3hQD4QKd86BZgsTiyYZyhe00cEmsImHnkfOxIZZ1OyXGBZlL1F/GK9nC0GY0b3xNluPWsYM37tBv76FCzJ6hDg9FMrF/VbiAGE2tpOZWwMaJPIWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875222; c=relaxed/simple;
	bh=APWU9fXaElOJa7b1mSuwIVdt6T1tJy35mn8AYP4RJh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1TRivizYIWhV84CpbMGYcmVi+Pt/hyXlSgNrqVwWC/XyVESEy179pwjOnTdg2+HtokwzS+Jmo0FJAJVDBJjJZluyKNTkVD6DKpkRDT865rl+z5XMaLGGesbNQZBjmBTsywAB74kBA8wfT7cBfuPsmS2yQJutBFs2X6pOJiaxnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eGS2ivVj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eGS2ivVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F833C4CEF4;
	Mon,  2 Jun 2025 14:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875221;
	bh=APWU9fXaElOJa7b1mSuwIVdt6T1tJy35mn8AYP4RJh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGS2ivVjOsVx4eZtKc8F0BZ+rT56CnvpazJ7wfpM1CwMWYLdLov5BPEn43MNCYpM1
	 2Z311a27LQFNsy6OecbF+Z2pplz/A2oI7z5USLgzML12HF5MKwEPkkWUIxDx6ZfJBl
	 kQqwPTVACItryxJLE5MVpjl0r/VZ9/A2UDbrAvjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/270] irqchip/gic-v2m: Mark a few functions __init
Date: Mon,  2 Jun 2025 15:45:21 +0200
Message-ID: <20250602134308.669477104@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit d51a15af37ce8cf59e73de51dcdce3c9f4944974 ]

They are all part of the init sequence.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221121140048.534395323@linutronix.de
Stable-dep-of: 3318dc299b07 ("irqchip/gic-v2m: Prevent use after free of gicv2m_get_fwnode()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v2m.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v2m.c b/drivers/irqchip/irq-gic-v2m.c
index 6a7551fd91a05..0b57ac48e18b6 100644
--- a/drivers/irqchip/irq-gic-v2m.c
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -263,7 +263,7 @@ static struct msi_domain_info gicv2m_pmsi_domain_info = {
 	.chip	= &gicv2m_pmsi_irq_chip,
 };
 
-static void gicv2m_teardown(void)
+static void __init gicv2m_teardown(void)
 {
 	struct v2m_data *v2m, *tmp;
 
@@ -278,7 +278,7 @@ static void gicv2m_teardown(void)
 	}
 }
 
-static int gicv2m_allocate_domains(struct irq_domain *parent)
+static __init int gicv2m_allocate_domains(struct irq_domain *parent)
 {
 	struct irq_domain *inner_domain, *pci_domain, *plat_domain;
 	struct v2m_data *v2m;
@@ -408,7 +408,7 @@ static int __init gicv2m_init_one(struct fwnode_handle *fwnode,
 	return ret;
 }
 
-static const struct of_device_id gicv2m_device_id[] = {
+static __initconst struct of_device_id gicv2m_device_id[] = {
 	{	.compatible	= "arm,gic-v2m-frame",	},
 	{},
 };
@@ -458,7 +458,7 @@ static int __init gicv2m_of_init(struct fwnode_handle *parent_handle,
 #ifdef CONFIG_ACPI
 static int acpi_num_msi;
 
-static struct fwnode_handle *gicv2m_get_fwnode(struct device *dev)
+static __init struct fwnode_handle *gicv2m_get_fwnode(struct device *dev)
 {
 	struct v2m_data *data;
 
@@ -473,7 +473,7 @@ static struct fwnode_handle *gicv2m_get_fwnode(struct device *dev)
 	return data->fwnode;
 }
 
-static bool acpi_check_amazon_graviton_quirks(void)
+static __init bool acpi_check_amazon_graviton_quirks(void)
 {
 	static struct acpi_table_madt *madt;
 	acpi_status status;
-- 
2.39.5



