Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C56C33ADB8;
	Fri,  9 Jan 2026 12:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961541; cv=none; b=SjpE5vj2zqpzA+RrDhRiXanoh2impdCUbxlJTAa60bsL3br0HUAY0xpD+2wpDjkciVrq+kTU9xag0MGygf5Bz3FMtwjS9nEBXzxh/xFPybeeG8nSXUQ6JHsVtfa/KxmoTebOodCqqqizNYpp0io4Pv+W7jpZWTHh9J4+aU02CqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961541; c=relaxed/simple;
	bh=JqH2ngMffk5ONLhjhHVpHId4kXIX9gtg8YOwXSF/crw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6/lM63jJMiGI2BSPHljf9A1Tus9mMqNNHE6ERLkfWryJqecs642w+B9eC8xErmAu5a9wz7/mD4ZthGPi1qadkBNMxt65AB4Q75AHnsY88R7u/arc4wfa2l/MhYPAuMuePWmGIn0f+OOOD6Q3irgK2PICgzI/SALsj2MGd/n5tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9/DPlXI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9/DPlXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C922BC4CEF1;
	Fri,  9 Jan 2026 12:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961541;
	bh=JqH2ngMffk5ONLhjhHVpHId4kXIX9gtg8YOwXSF/crw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X9/DPlXIN9D6O7w9+GPdd3c7vT2NJ4aBEyi0oy0MU1KVsXEz+QmgSvF47f6gA7CuN
	 nGmpLaIffqh94ltzuS+xevQPRItr1eZPL2EOq1WXkXJ99jCeBclULmEIlffud38kFP
	 TDMEVgE/5zhh8TL9z3pE2NccjAWBjalp2qV6mQSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/634] irqchip/irq-bcm7120-l2: Fix section mismatch
Date: Fri,  9 Jan 2026 12:35:28 +0100
Message-ID: <20260109112119.328511735@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit bfc0c5beab1fde843677923cf008f41d583c980a ]

Platform drivers can be probed after their init sections have been
discarded so the irqchip init callbacks must not live in init.

Fixes: 3ac268d5ed22 ("irqchip/irq-bcm7120-l2: Switch to IRQCHIP_PLATFORM_DRIVER")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-bcm7120-l2.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/irqchip/irq-bcm7120-l2.c b/drivers/irqchip/irq-bcm7120-l2.c
index 1e9dab6e0d86f..bb6e56629e532 100644
--- a/drivers/irqchip/irq-bcm7120-l2.c
+++ b/drivers/irqchip/irq-bcm7120-l2.c
@@ -147,8 +147,7 @@ static int bcm7120_l2_intc_init_one(struct device_node *dn,
 	return 0;
 }
 
-static int __init bcm7120_l2_intc_iomap_7120(struct device_node *dn,
-					     struct bcm7120_l2_intc_data *data)
+static int bcm7120_l2_intc_iomap_7120(struct device_node *dn, struct bcm7120_l2_intc_data *data)
 {
 	int ret;
 
@@ -181,8 +180,7 @@ static int __init bcm7120_l2_intc_iomap_7120(struct device_node *dn,
 	return 0;
 }
 
-static int __init bcm7120_l2_intc_iomap_3380(struct device_node *dn,
-					     struct bcm7120_l2_intc_data *data)
+static int bcm7120_l2_intc_iomap_3380(struct device_node *dn, struct bcm7120_l2_intc_data *data)
 {
 	unsigned int gc_idx;
 
@@ -212,10 +210,9 @@ static int __init bcm7120_l2_intc_iomap_3380(struct device_node *dn,
 	return 0;
 }
 
-static int __init bcm7120_l2_intc_probe(struct device_node *dn,
-				 struct device_node *parent,
+static int bcm7120_l2_intc_probe(struct device_node *dn, struct device_node *parent,
 				 int (*iomap_regs_fn)(struct device_node *,
-					struct bcm7120_l2_intc_data *),
+						      struct bcm7120_l2_intc_data *),
 				 const char *intc_name)
 {
 	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
@@ -343,15 +340,13 @@ static int __init bcm7120_l2_intc_probe(struct device_node *dn,
 	return ret;
 }
 
-static int __init bcm7120_l2_intc_probe_7120(struct device_node *dn,
-					     struct device_node *parent)
+static int bcm7120_l2_intc_probe_7120(struct device_node *dn, struct device_node *parent)
 {
 	return bcm7120_l2_intc_probe(dn, parent, bcm7120_l2_intc_iomap_7120,
 				     "BCM7120 L2");
 }
 
-static int __init bcm7120_l2_intc_probe_3380(struct device_node *dn,
-					     struct device_node *parent)
+static int bcm7120_l2_intc_probe_3380(struct device_node *dn, struct device_node *parent)
 {
 	return bcm7120_l2_intc_probe(dn, parent, bcm7120_l2_intc_iomap_3380,
 				     "BCM3380 L2");
-- 
2.51.0



