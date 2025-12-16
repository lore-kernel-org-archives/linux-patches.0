Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D0C341666;
	Tue, 16 Dec 2025 11:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885118; cv=none; b=JNjBE5opxpmc1qDyaSOwp+m5niK4jep8d+ec8T5VjdN2AUhiTzZGmjrWq0Ut9jKInSkxjVAEQ59EgWck+usIC5BIEsTQyGXjh7cPIbUSq4HB0UbFMQWx1uN9oUgKSfOWcmGOTUh1M8HyKXUn+YdY+IOZSjQ5pO2fMEIzMWUZ6/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885118; c=relaxed/simple;
	bh=2J3U9z8zxwwxL1eTCTTIlC8WHBqPP3yLM43Mv8BLUV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWisTUoQn/NJNywmi726dnPP+Eu7Qfrm9xjOFWRAwppeSKbYUAKiB0Q8Cxh+2eNqoaOUMwDMQvhba7sGVPdNQtpjAsPuCx8LJfCA/be9zxHIn0o+m6RMx244Z8V9cM6vBv8kZz1w4pc4bmCypYfFe4IZrDlaHNDVPKlX97oICr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7Lx/sEK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7Lx/sEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A87C4CEF1;
	Tue, 16 Dec 2025 11:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885118;
	bh=2J3U9z8zxwwxL1eTCTTIlC8WHBqPP3yLM43Mv8BLUV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G7Lx/sEKBBO249Q+rrsexftuPo+wuXKy6AKJAC8+/Cz44pdVGTA22T2/y7uVOPIqD
	 r3zM6UveUzYwg+MYzJ92Yp2acnfMRcrPW0ic0TE++EPIcOhD6OdbORrNe852C9iffL
	 rcajGa+r6DqCUtZHYClkCHRqVRdBFSPKdmDbg8TM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 044/507] irqchip/renesas-rzg2l: Fix section mismatch
Date: Tue, 16 Dec 2025 12:08:05 +0100
Message-ID: <20251216111347.140511938@linuxfoundation.org>
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
index 360d88687e4f5..32fec9aa37c49 100644
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



