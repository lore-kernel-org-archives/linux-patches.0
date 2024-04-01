Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876D7C129;
	Mon,  1 Apr 2024 16:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988858; cv=none; b=Yw2C8HT1KCtdcFvRHRcK/fjdeD8pWFdRd95fHiNdH24dzwN8gvmcNaWveAzbDQAF0bYSR7KKbI/5DpKa7YTHst0oBXaRj0W2ne9RWGzwf7AkPnmMzWpL56ssTGamChxoM7iswIC5uBmVaNcSjqXrv9oNfE6w12UU6XnWLtjeeCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988858; c=relaxed/simple;
	bh=1C/mkq0sQWPksnO6NNeFKYZ8z3Fz6NA/UJJaQMmu9Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4AejG40TfOi5CGK1MH7k6tJ/4S26TbckwxtOZ4YoW0YJayB5xU83Bd/75BdnFFURzR+D5Q9YMuOURUNSbhUGEP1O/qOY5dnEEKTKi+f37Kt6y/Deqhop+iwGOjGLDwATbPkt9o69XAcqXy0iUgqi6OsBjXHDPu4gxx49pCWx0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R49LIvHH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R49LIvHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02116C433C7;
	Mon,  1 Apr 2024 16:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988858;
	bh=1C/mkq0sQWPksnO6NNeFKYZ8z3Fz6NA/UJJaQMmu9Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R49LIvHH2dBypmKhZm2Kc2R8GgBvUXUUkF7fGfQFM/DV2ahv1d4dC608uB9+Q5Don
	 vJYXdTX5XRtZcEHK9Hc49MhjCo1H104YE6IHwju3YxQls6Oxp1nGZgFYTGZa6aI59E
	 9197yK5JD915g+D5tTX5u5Yz2uTfm5+un199+pxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 309/432] irqchip/renesas-rzg2l: Add macro to retrieve TITSR register offset based on registers index
Date: Mon,  1 Apr 2024 17:44:56 +0200
Message-ID: <20240401152602.404578328@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit 2eca4731cc66563b3919d8753dbd74d18c39f662 ]

There are 2 TITSR registers available on the IA55 interrupt controller.

Add a macro that retrieves the TITSR register offset based on it's
index. This macro is useful in when adding suspend/resume support so both
TITSR registers can be accessed in a for loop.

Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20231120111820.87398-7-claudiu.beznea.uj@bp.renesas.com
Stable-dep-of: 853a6030303f ("irqchip/renesas-rzg2l: Prevent spurious interrupts when setting trigger type")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-renesas-rzg2l.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/irqchip/irq-renesas-rzg2l.c b/drivers/irqchip/irq-renesas-rzg2l.c
index d6514f2d51aff..3f2f4ebfe4da6 100644
--- a/drivers/irqchip/irq-renesas-rzg2l.c
+++ b/drivers/irqchip/irq-renesas-rzg2l.c
@@ -28,8 +28,7 @@
 #define ISCR				0x10
 #define IITSR				0x14
 #define TSCR				0x20
-#define TITSR0				0x24
-#define TITSR1				0x28
+#define TITSR(n)			(0x24 + (n) * 4)
 #define TITSR0_MAX_INT			16
 #define TITSEL_WIDTH			0x2
 #define TSSR(n)				(0x30 + ((n) * 4))
@@ -206,8 +205,7 @@ static int rzg2l_tint_set_edge(struct irq_data *d, unsigned int type)
 	struct rzg2l_irqc_priv *priv = irq_data_to_priv(d);
 	unsigned int hwirq = irqd_to_hwirq(d);
 	u32 titseln = hwirq - IRQC_TINT_START;
-	u32 offset;
-	u8 sense;
+	u8 index, sense;
 	u32 reg;
 
 	switch (type & IRQ_TYPE_SENSE_MASK) {
@@ -223,17 +221,17 @@ static int rzg2l_tint_set_edge(struct irq_data *d, unsigned int type)
 		return -EINVAL;
 	}
 
-	offset = TITSR0;
+	index = 0;
 	if (titseln >= TITSR0_MAX_INT) {
 		titseln -= TITSR0_MAX_INT;
-		offset = TITSR1;
+		index = 1;
 	}
 
 	raw_spin_lock(&priv->lock);
-	reg = readl_relaxed(priv->base + offset);
+	reg = readl_relaxed(priv->base + TITSR(index));
 	reg &= ~(IRQ_MASK << (titseln * TITSEL_WIDTH));
 	reg |= sense << (titseln * TITSEL_WIDTH);
-	writel_relaxed(reg, priv->base + offset);
+	writel_relaxed(reg, priv->base + TITSR(index));
 	raw_spin_unlock(&priv->lock);
 
 	return 0;
-- 
2.43.0



