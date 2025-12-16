Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0BF35F8D7;
	Tue, 16 Dec 2025 12:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886864; cv=none; b=MP6Ea8uzJCLCge3YrpZyKw3J5kBHOzEZwuablZySBllCNVYZtywdtffh4if/sMJe03ubrb4oPLtai3HMZHPSPDnhQkMH4lflkSDDgffel2lKJu1HduMo2KBhVvt6lfzvW+e3NoT3JhKAYX8pQPNt6geEGPDatWC3xfLIMibWWlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886864; c=relaxed/simple;
	bh=W+z/8EITrAaRVXjIZ5iGbyN6OnqpM7kCehx4j2YU1gQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zj/+bVxvTsGJQ6A0HnGlOPg36OVvhj2LFBzl72oJtaze920ZMF/mN3TUBNOgiGaGmkYZup+j12wwrXIYoC8f+RMDZiFRBCyNZjr+F6h0lPBGMSs0go6VjmOvtqenpg0gu0861ISLgE9kpqTnu5wIsUfmuIsoWjXWg3UY5wnT2uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=to2PMzKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="to2PMzKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D52C4CEF1;
	Tue, 16 Dec 2025 12:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886864;
	bh=W+z/8EITrAaRVXjIZ5iGbyN6OnqpM7kCehx4j2YU1gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=to2PMzKKRubRg8j41T2ofCm8038ooUgRInm6Aw24vh5dd9zkXfIhYRUtlR/AG3TCc
	 HfoXrajXUGcXnvVTNC0EKWmqNChoUASl6vZCfgC4GEU0QIrvexH62Uenh0W6lVKatO
	 2crAdDKxzTAwGCFruRPii8NJmy94pWOsJhd/BE04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 054/614] irqchip: Drop leftover brackets
Date: Tue, 16 Dec 2025 12:07:01 +0100
Message-ID: <20251216111403.266400338@linuxfoundation.org>
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

[ Upstream commit 3540d99c03a88d4ebf65026f1f1926d3af658fb1 ]

Drop some unnecessary brackets in platform_irqchip_probe() mistakenly
left by commit 9322d1915f9d ("irqchip: Plug a OF node reference leak in
platform_irqchip_probe()").

Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Stable-dep-of: 1e3e330c0707 ("irqchip: Pass platform device to platform drivers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irqchip.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irqchip.c b/drivers/irqchip/irqchip.c
index 0ee7b6b71f5fa..652d20d2b07f1 100644
--- a/drivers/irqchip/irqchip.c
+++ b/drivers/irqchip/irqchip.c
@@ -38,9 +38,8 @@ int platform_irqchip_probe(struct platform_device *pdev)
 	struct device_node *par_np __free(device_node) = of_irq_find_parent(np);
 	of_irq_init_cb_t irq_init_cb = of_device_get_match_data(&pdev->dev);
 
-	if (!irq_init_cb) {
+	if (!irq_init_cb)
 		return -EINVAL;
-	}
 
 	if (par_np == np)
 		par_np = NULL;
@@ -53,9 +52,8 @@ int platform_irqchip_probe(struct platform_device *pdev)
 	 * interrupt controller. The actual initialization callback of this
 	 * interrupt controller can check for specific domains as necessary.
 	 */
-	if (par_np && !irq_find_matching_host(par_np, DOMAIN_BUS_ANY)) {
+	if (par_np && !irq_find_matching_host(par_np, DOMAIN_BUS_ANY))
 		return -EPROBE_DEFER;
-	}
 
 	return irq_init_cb(np, par_np);
 }
-- 
2.51.0



