Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADCF35F8B4;
	Tue, 16 Dec 2025 12:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886837; cv=none; b=V7htVfyFEeEfRDiHlWW0vVjOeFPYNpAYpCVMV+xqCw2rJUGG5mxt/TGuvZDFzSJpkgVbKymaI8gd+04+2+BZQv9FkLb7QWTJgZNwgU3saIZ8+R1st6Y4GERWs7MNPOnsnDCmGLRXjpI4Ghf8aHG2EFBBkJB9cQUbgt8KqMQE1jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886837; c=relaxed/simple;
	bh=G598ZBpLNLQqXHRV0t2tY7FDA8azFLn+mrMhhwOIGKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDtGis/pS0l20zI69Qgorc1LqxMvKCioJCk0T3IHUVncjvHYLrhCFIVBXMvCOWVch8+6vaVWevA2xVwOXeWdH7V3duWPCul7xa5Fwq4CB6caD0Yz27fABwQMTFWsqNw3rcwUDsgum9fwzwg3oyjAc5xfdbUnZdRVlET2JfuwA+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UxEEazQe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UxEEazQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5D5C4CEF1;
	Tue, 16 Dec 2025 12:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886836;
	bh=G598ZBpLNLQqXHRV0t2tY7FDA8azFLn+mrMhhwOIGKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UxEEazQehCVaspsKk7/VlpqIGoKD6yGlMU5FhmGDgNEWvkS+x8qucG1mjjmX3rUsS
	 A4qGBe6IaRevLK+6tYdUJQ73NZ90IJUH050Wo7K9AVJqHM3RoA318V+4GlRnn4OjmG
	 IkLMEsccg+buYgeJJfS+oQMd1fegiy0l2Wt98pfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 047/614] irqchip/irq-bcm7038-l1: Fix section mismatch
Date: Tue, 16 Dec 2025 12:06:54 +0100
Message-ID: <20251216111403.013603680@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



