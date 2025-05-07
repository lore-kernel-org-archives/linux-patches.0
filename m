Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CA41DDC23;
	Wed,  7 May 2025 18:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643716; cv=none; b=C5eNoLOm9t6I5npewx/YLUsoA7K8q/hc+28mpCzwdUKx89oOvdukihP7E07sbumNypXFKWANl5ZJW88shVWRIHfU6v0xwvcMGenGLAtYx5RucUVKtb2QSeHjvjEDsU4E5yjmGKzH5PeAn8SCPdcZLmmtUL1/L8xw1WfMwrrRnMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643716; c=relaxed/simple;
	bh=RHEzQ4H6kEh2Vo5smBm6kZ7miV76Le7/PEHn9FjqibQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HsW9h0VCHidIpNIXdsYc28Ya0EiYvmxN74KKFV5tvpN8FrzWmxnB4ZQ/CkOqRZkvQqgkir0DH6oP+FY7f4XbmEAGn+cMZPODKayFf9wjjuOK3u82tQ/vxsiS0XelOag+m2E0pRwbU/Edotkxz2Hs2tr4aMu40VIfIZqjiLs3qbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mUItf0p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mUItf0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E521FC4CEE2;
	Wed,  7 May 2025 18:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643716;
	bh=RHEzQ4H6kEh2Vo5smBm6kZ7miV76Le7/PEHn9FjqibQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mUItf0p7lDTWm8h2oiT5ecFn2M+aHNZJeJUFf9gzUxYQdCD8pl1lL/Y167H9ykfC
	 ytOBKnewj3v59qGhtQr8nODy2DxtEVc6S9LK88+STX5xeW93ROXPMt1JUlOjNwOdzS
	 Z6Vqj3AtezWBQ4udbYPyvcCoh6unNhYBnI5CMW0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 85/97] irqchip/gic-v2m: Mark a few functions __init
Date: Wed,  7 May 2025 20:40:00 +0200
Message-ID: <20250507183810.396962869@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 414cd925064f4..c2e52c9a38546 100644
--- a/drivers/irqchip/irq-gic-v2m.c
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -262,7 +262,7 @@ static struct msi_domain_info gicv2m_pmsi_domain_info = {
 	.chip	= &gicv2m_pmsi_irq_chip,
 };
 
-static void gicv2m_teardown(void)
+static void __init gicv2m_teardown(void)
 {
 	struct v2m_data *v2m, *tmp;
 
@@ -277,7 +277,7 @@ static void gicv2m_teardown(void)
 	}
 }
 
-static int gicv2m_allocate_domains(struct irq_domain *parent)
+static __init int gicv2m_allocate_domains(struct irq_domain *parent)
 {
 	struct irq_domain *inner_domain, *pci_domain, *plat_domain;
 	struct v2m_data *v2m;
@@ -404,7 +404,7 @@ static int __init gicv2m_init_one(struct fwnode_handle *fwnode,
 	return ret;
 }
 
-static const struct of_device_id gicv2m_device_id[] = {
+static __initconst struct of_device_id gicv2m_device_id[] = {
 	{	.compatible	= "arm,gic-v2m-frame",	},
 	{},
 };
@@ -454,7 +454,7 @@ static int __init gicv2m_of_init(struct fwnode_handle *parent_handle,
 #ifdef CONFIG_ACPI
 static int acpi_num_msi;
 
-static struct fwnode_handle *gicv2m_get_fwnode(struct device *dev)
+static __init struct fwnode_handle *gicv2m_get_fwnode(struct device *dev)
 {
 	struct v2m_data *data;
 
@@ -469,7 +469,7 @@ static struct fwnode_handle *gicv2m_get_fwnode(struct device *dev)
 	return data->fwnode;
 }
 
-static bool acpi_check_amazon_graviton_quirks(void)
+static __init bool acpi_check_amazon_graviton_quirks(void)
 {
 	static struct acpi_table_madt *madt;
 	acpi_status status;
-- 
2.39.5



