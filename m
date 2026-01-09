Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737032737EE;
	Fri,  9 Jan 2026 12:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961544; cv=none; b=mFRqwR85574QpS3HGksTrnuajicxBT82H6g+HWcHLjXXu68xRq2y9ORnmvyiZ4FgQ3w+Gl++DInVK0nnhwLclaJbZUe/bvEUiN0ce7wbK/tIyYQPwpmoxvJcDMmnX/f4kzbbkKk4utuWXqUBK/UhqxXqa5Ql0waFFpJGLqSTmn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961544; c=relaxed/simple;
	bh=bwemejVHCMJe6XHRyM+2o6pt8dmWC56pwa8gxL+mYm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzcjJnWRJ6uAAMx4oD0g1fGnocEb4EW4qNGe1+2bjOqP2vCwE68yUMZj8DuS23JHq0+n5BofUw+0IYaTnwZa8nzOvB9hEjiQmkHeb/Qr7dUSXDHd6KNJs//eS2IDTHHrw/BUSoC3YmpJdf2YLuJ3vv91MLHuKGQhqlvO3WlB6Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtEl58Sk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtEl58Sk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F7CC4CEF1;
	Fri,  9 Jan 2026 12:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961544;
	bh=bwemejVHCMJe6XHRyM+2o6pt8dmWC56pwa8gxL+mYm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wtEl58SkcFYJ0gYDLCcS3ZxOogWAAMgnGAXX+WZl7eNTYxXIvJ/tOV7+NORtDc1TM
	 7e5eEiCuAGL/V9GpV5sJgCSoFbAuVfITi8sLGcAhm7UeYetdfKMIBhBxkSj1SoB7nF
	 GHNNypOk/M//BXxwgQt22Z0Z8/q95gjX/TWHCeWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/634] irqchip/irq-brcmstb-l2: Fix section mismatch
Date: Fri,  9 Jan 2026 12:35:29 +0100
Message-ID: <20260109112119.365834163@linuxfoundation.org>
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

[ Upstream commit bbe1775924478e95372c2f896064ab6446000713 ]

Platform drivers can be probed after their init sections have been
discarded so the irqchip init callbacks must not live in init.

Fixes: 51d9db5c8fbb ("irqchip/irq-brcmstb-l2: Switch to IRQCHIP_PLATFORM_DRIVER")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-brcmstb-l2.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/irqchip/irq-brcmstb-l2.c b/drivers/irqchip/irq-brcmstb-l2.c
index 5d4421f75b43a..f1e244e1ba3bb 100644
--- a/drivers/irqchip/irq-brcmstb-l2.c
+++ b/drivers/irqchip/irq-brcmstb-l2.c
@@ -158,10 +158,8 @@ static void brcmstb_l2_intc_resume(struct irq_data *d)
 	irq_gc_unlock_irqrestore(gc, flags);
 }
 
-static int __init brcmstb_l2_intc_of_init(struct device_node *np,
-					  struct device_node *parent,
-					  const struct brcmstb_intc_init_params
-					  *init_params)
+static int brcmstb_l2_intc_of_init(struct device_node *np, struct device_node *parent,
+				   const struct brcmstb_intc_init_params *init_params)
 {
 	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
 	unsigned int set = 0;
@@ -277,14 +275,12 @@ static int __init brcmstb_l2_intc_of_init(struct device_node *np,
 	return ret;
 }
 
-static int __init brcmstb_l2_edge_intc_of_init(struct device_node *np,
-	struct device_node *parent)
+static int brcmstb_l2_edge_intc_of_init(struct device_node *np, struct device_node *parent)
 {
 	return brcmstb_l2_intc_of_init(np, parent, &l2_edge_intc_init);
 }
 
-static int __init brcmstb_l2_lvl_intc_of_init(struct device_node *np,
-	struct device_node *parent)
+static int brcmstb_l2_lvl_intc_of_init(struct device_node *np, struct device_node *parent)
 {
 	return brcmstb_l2_intc_of_init(np, parent, &l2_lvl_intc_init);
 }
-- 
2.51.0



