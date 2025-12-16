Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE5235F8D7;
	Tue, 16 Dec 2025 12:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886851; cv=none; b=o5UIWUzXig2wed3fNSY5WCEIacKLB159kIKG2qHR4OCuJ97N/G/QF5UwVTy/mfa/9NvEe9P8i91L+LOiWMa4kz2T2ArYss1B2ZkPWVfkXEkrSpfvxCsu4TzdKmSpZ82+/O7nFPEwYnGstXW5Y/H17m1E/kC1Iuc3lxDP/HfH61U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886851; c=relaxed/simple;
	bh=nURn1aKeaefGpQnRdvDKNV7BmOWbca8VkdIC/T9VjtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=reTW3c/xxM9HAw7So/l0ZpOH1FrxmIh60ZgDMcov+PIyD5fxjNW0Isvue0talmLspxnoaHnherYRwOaxVGvgN8rZ4BYb5r7BgACFqCqAn6ysTC0O/aKIXrLH6++fhgxj2UmTn2L9OJQ3tke4VFRNQKBKW0mAEqth/r5iQ0AY0m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPmJVhK8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPmJVhK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8AF8C4CEF1;
	Tue, 16 Dec 2025 12:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886851;
	bh=nURn1aKeaefGpQnRdvDKNV7BmOWbca8VkdIC/T9VjtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YPmJVhK8n98iPIj6HCrTcK8gNrtga9jSTlZrFFTNXgsr81Mk693ANff3kdwGVjoF4
	 XtsQrZ88jszXfdSoB3bOhxT9hUkHHdt6tmVAn0Std1JYfCRMTZDt4slw0XRUpU1mos
	 0RHHn+zGekCGkybTwyaKKgtKh8b9DGrJmfS/+qsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 051/614] irqchip/renesas-rzg2l: Fix section mismatch
Date: Tue, 16 Dec 2025 12:06:58 +0100
Message-ID: <20251216111403.158412624@linuxfoundation.org>
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

[ Upstream commit 5b338fbb2b5b21d61a9eaba14dcf43108de30258 ]

Platform drivers can be probed after their init sections have been
discarded so the irqchip init callbacks must not live in init.

Fixes: d011c022efe27579 ("irqchip/renesas-rzg2l: Add support for RZ/Five SoC")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-renesas-rzg2l.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-renesas-rzg2l.c b/drivers/irqchip/irq-renesas-rzg2l.c
index 2a54adeb4cc71..12b6eb1503016 100644
--- a/drivers/irqchip/irq-renesas-rzg2l.c
+++ b/drivers/irqchip/irq-renesas-rzg2l.c
@@ -597,14 +597,12 @@ static int rzg2l_irqc_common_init(struct device_node *node, struct device_node *
 	return 0;
 }
 
-static int __init rzg2l_irqc_init(struct device_node *node,
-				  struct device_node *parent)
+static int rzg2l_irqc_init(struct device_node *node, struct device_node *parent)
 {
 	return rzg2l_irqc_common_init(node, parent, &rzg2l_irqc_chip);
 }
 
-static int __init rzfive_irqc_init(struct device_node *node,
-				   struct device_node *parent)
+static int rzfive_irqc_init(struct device_node *node, struct device_node *parent)
 {
 	return rzg2l_irqc_common_init(node, parent, &rzfive_irqc_chip);
 }
-- 
2.51.0



