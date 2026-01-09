Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CB335A956;
	Fri,  9 Jan 2026 12:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961540; cv=none; b=hmNYy7Wvgo/5mV9cB6X5f0f+TN6VvLwujwPvZrA8YzHW+eR3DGasRZUsR6TwDq3rG1XKTug1Odf2VlruZIsh+GJS/ev4Nekr36XZe4S4nszbbUdwuoeClCgUqsXOuN/WWwwRJSIBlgE9o05+gV7KNqgZDAStbBHJhnoJmkv2zIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961540; c=relaxed/simple;
	bh=OQ5pNYShoDfX/kTKDCzEbD5ghO7CfTphpX3kmHMX1OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XSwNDsk/1YkH1LozrPENgAwjMLat9Jga5qpt6K5aBdPrn+oDHeu6Z8Woa38i4uWIKT1CyKkU6Per8RpE5+sI1FcWCzctqLIVwAck9e4Nmede8O9AP/hqbPO7iyGIT3khCSR+6OL3doYcUlAuFS0KjCJWRwCUyJfwIethBUPmw0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U5xIviHd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U5xIviHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA87C4CEF1;
	Fri,  9 Jan 2026 12:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961538;
	bh=OQ5pNYShoDfX/kTKDCzEbD5ghO7CfTphpX3kmHMX1OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U5xIviHdjkDzhWFGumbGBDykyKSLmnSNu9+qdg57b5NzaUMmVYCGbSb2OMp/TJ7oA
	 nqhbIqdPVDRWiHsrrmP7C8DeT96FZGMofO7fz7HkbQaOfIJr6VRpwWORfmCDtdYlLp
	 5h9rHeDfuuWtt66MbNW4WG27DzTR8UMKOWvJQb2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/634] irqchip/irq-bcm7038-l1: Fix section mismatch
Date: Fri,  9 Jan 2026 12:35:27 +0100
Message-ID: <20260109112119.290828121@linuxfoundation.org>
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
index a62b96237b826..187f535794461 100644
--- a/drivers/irqchip/irq-bcm7038-l1.c
+++ b/drivers/irqchip/irq-bcm7038-l1.c
@@ -220,9 +220,8 @@ static int bcm7038_l1_set_affinity(struct irq_data *d,
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
@@ -396,8 +395,7 @@ static const struct irq_domain_ops bcm7038_l1_domain_ops = {
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



