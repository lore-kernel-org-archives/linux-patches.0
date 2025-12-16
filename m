Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6E7346FA2;
	Tue, 16 Dec 2025 11:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885101; cv=none; b=DrSiirMWjb6pdfp7eebQ6XEyhby1R4GHhXL9nej+jH/FLyMyzYu17VcOQTf+P3WyeePyxoc6cyKr3Fr6eurbgZnQu3OsiUQZDbHCZt3vQJArgAk91qLJWoUhV7UCQfh/1Mjx395tkFmHPLWIhVNHqrDP4I6n77rigXg5jDNtz6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885101; c=relaxed/simple;
	bh=vHdTMfShfQSRAcafIB6jAfW4r4fNoS7xkZnDcGok1hI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SI5uI4vmdDZFhBSSUahfs9eGReU1uGxzZYumq2CLtCPawGYTBcDd9yK97nbgdYbufNONclumhKagsJSifhlejhoGoPrYWD/D7RRayzLrWStnXdSDC+FMgy9KvxP5CFngq2K1RvYBhBfdx71X5b/aSeI3+9+QOiK93e9ow7ds7EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QuV+cKqh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QuV+cKqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1AAC4CEF1;
	Tue, 16 Dec 2025 11:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885101;
	bh=vHdTMfShfQSRAcafIB6jAfW4r4fNoS7xkZnDcGok1hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QuV+cKqhKej3hyMmi8PGjkMrd1NA6z5kQnlYx1IjZfinGzTbfKAbmalfswCSPT11j
	 AhCUzXfiCR/Oxun/MB+vleDl462q7Gh3SRbkud0qwF/KbeQtMVFwtjmyXpC5nJUDLB
	 53RFcc1xF+FTT/y+o18q3QLrpyJwbl2FOWeZ+JT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 039/507] irqchip/bcm2712-mip: Fix section mismatch
Date: Tue, 16 Dec 2025 12:08:00 +0100
Message-ID: <20251216111346.957439678@linuxfoundation.org>
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



