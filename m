Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947DB35E55C;
	Tue, 16 Dec 2025 12:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886833; cv=none; b=RJJ/2p3/wyYnj1B4ME7vGZkt9A2we8iUS6T8Eg65qJ8jGcEkra3p8DZo7/mjqe1swwVqbzpht2fk3Ry7mBqOlh7Ct/oDxSi62YJFB8VsehZegRpYWMqCjKACKsoM3cLZ+lMbwzFg/VJltHH3eZfiaQ+EtM1J7G9z2eVBreGPsyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886833; c=relaxed/simple;
	bh=vYjQu7On3d6KqzhUeM48MhLReNA7Ijvq+BOGqqEwcPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtDfaC5vDybUXVKum5S+zf1t4u7zodhPxYmrI4xybbv6MAqFxmasfE4e8GoVDtGK4n7r0MY47tceMTDTcdsn80o6OP9hv3tKZuBKcTKwV6cR0/44zHFGvg8Z5mb3zZ3XFrQHBWmFThNAdfcvFNWgvCOgGUElU2EbAM3613lZhyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p4Vjx1W+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p4Vjx1W+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF7AC4CEF1;
	Tue, 16 Dec 2025 12:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886833;
	bh=vYjQu7On3d6KqzhUeM48MhLReNA7Ijvq+BOGqqEwcPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p4Vjx1W+3Ulbb6ew/skRpv5ZkG4wbUPsBmQ4oh0+kt9jS/gz1JjHTkIwe2Fa5ML4m
	 gn+9WgELKIbzKxe0GrTGw1xgRjSms1DghFDUDO9xEbNI4BGugl4x+8hc17Q4CjULNL
	 LV3lfS4eX1XFXE2q5TxI0CTo3dORCO93Dk74+oSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 046/614] irqchip/bcm2712-mip: Fix section mismatch
Date: Tue, 16 Dec 2025 12:06:53 +0100
Message-ID: <20251216111402.978090451@linuxfoundation.org>
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

[ Upstream commit a8452d1d59d46066051e676d5daa472cd08cb304 ]

Platform drivers can be probed after their init sections have been
discarded so the irqchip init callback must not live in init.

Fixes: 32c6c054661a ("irqchip: Add Broadcom BCM2712 MSI-X interrupt controller")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-bcm2712-mip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-bcm2712-mip.c b/drivers/irqchip/irq-bcm2712-mip.c
index 256c2d59f717d..8466646e5a2da 100644
--- a/drivers/irqchip/irq-bcm2712-mip.c
+++ b/drivers/irqchip/irq-bcm2712-mip.c
@@ -232,7 +232,7 @@ static int mip_parse_dt(struct mip_priv *mip, struct device_node *np)
 	return ret;
 }
 
-static int __init mip_of_msi_init(struct device_node *node, struct device_node *parent)
+static int mip_of_msi_init(struct device_node *node, struct device_node *parent)
 {
 	struct platform_device *pdev;
 	struct mip_priv *mip;
-- 
2.51.0



