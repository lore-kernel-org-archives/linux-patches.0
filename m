Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F786346FCF;
	Tue, 16 Dec 2025 11:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885104; cv=none; b=MoFKEKuHg0ll4bSEooJWaDML3Um510iuQ5ROcOc/hWlkDsJcn3n3OSWuSDGfDP6fcSBVMEPbRE7HS0+eMqjfVyFi0iqCEnb42tKQTm53nd7K07RQNEHU0IhQkCquWuE9B0KjqT0Pp6riWtNb9u92mATKHQRHdtDvwsQlvpfVI34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885104; c=relaxed/simple;
	bh=Phis65EvhH70HGI+vUCMCfCpBi+9tPNsEDZvgZkSAnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HX9URVVuFLYssCmMNfNwcgoD1KLmhf2CaRjZlvoGPtnuem2iTmAqv61WMxciizXuavX1zxDX8qmktDysrrEcOj8/sMaY1lNsb8XG+NB3hcwqeoNs0H9umpdoSIzfp7Oga+nMT4ce8hGbDLc3T4O+R9GbDEqpPwEERJW/ITbMG0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mkd2VPJb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mkd2VPJb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1F2C19423;
	Tue, 16 Dec 2025 11:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885104;
	bh=Phis65EvhH70HGI+vUCMCfCpBi+9tPNsEDZvgZkSAnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mkd2VPJbcbb0JfUoWdaYn8QAmecGwMTzIXS5lryoE/Ej1acqXzcxWQyPeFBpQnzw7
	 bH2BF2pIe5xyQpdtsC6LikgdV4xCtI8opDfHRhtG5xEUOaM3d2VEjjgyvzUeRBlIkz
	 yrZNXTObDlAXfaOWa/wmlKw+8wTZ/DfxgHumI2vA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 040/507] irqchip/irq-bcm7038-l1: Fix section mismatch
Date: Tue, 16 Dec 2025 12:08:01 +0100
Message-ID: <20251216111346.993509372@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit e9db5332caaf4789ae3bafe72f61ad8e6e0c2d81 ]

Platform drivers can be probed after their init sections have been
discarded so the irqchip init callback must not live in init.

Fixes: c057c799e379 ("irqchip/irq-bcm7038-l1: Switch to IRQCHIP_PLATFORM_DRIVER")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-bcm7038-l1.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-bcm7038-l1.c b/drivers/irqchip/irq-bcm7038-l1.c
index 04fac0cc857fd..eda33bd5d080c 100644
--- a/drivers/irqchip/irq-bcm7038-l1.c
+++ b/drivers/irqchip/irq-bcm7038-l1.c
@@ -219,9 +219,8 @@ static int bcm7038_l1_set_affinity(struct irq_data *d,
 }
 #endif
 
-static int __init bcm7038_l1_init_one(struct device_node *dn,
-				      unsigned int idx,
-				      struct bcm7038_l1_chip *intc)
+static int bcm7038_l1_init_one(struct device_node *dn, unsigned int idx,
+			       struct bcm7038_l1_chip *intc)
 {
 	struct resource res;
 	resource_size_t sz;
@@ -395,8 +394,7 @@ static const struct irq_domain_ops bcm7038_l1_domain_ops = {
 	.map			= bcm7038_l1_map,
 };
 
-static int __init bcm7038_l1_of_init(struct device_node *dn,
-			      struct device_node *parent)
+static int bcm7038_l1_of_init(struct device_node *dn, struct device_node *parent)
 {
 	struct bcm7038_l1_chip *intc;
 	int idx, ret;
-- 
2.51.0



