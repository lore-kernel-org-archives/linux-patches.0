Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18F218E37C;
	Mon, 28 Oct 2024 06:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097608; cv=none; b=MsNTp6jWV1NmxY1v5xkDKEhP+9n9W86Evu6k9cvUAPNvpxpARpF4KjQkCp5xPX0zbhRxjfpTaRKRrhd+7EKFW1thnfPVfisOXx3JbKFxBIJLzXTHAnc/PzSbBHrr7e3bRYXmuNbJaJsWeHhJcH0kJL60kUvHXzbTpxQvVqzX3Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097608; c=relaxed/simple;
	bh=Rr/T9s1Qf9qRBt5MpoQFC79LoBiiRA3jnbenYpvE+FI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pC3ChoPrVI9UeSIpt3MM0zqFHJMkyY6Sx10AIsQD/+1zmODAVA3CKROPciBQRy7yXqjqTubnSrdyRNHq8YgxnOxCcs4AYNcT23/IK9jYe/cftSrc1LyhNhHBhVLpCJm5p5+gwqpgzVXfs9txEA/3bJFbhFfzJ+edrv4KOWNK/34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wqvFV6qZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wqvFV6qZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732C9C4CEE3;
	Mon, 28 Oct 2024 06:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097608;
	bh=Rr/T9s1Qf9qRBt5MpoQFC79LoBiiRA3jnbenYpvE+FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wqvFV6qZht9omITvSgd9wEWtpscAI38WCladyDa9w8dv898xUit8G7MDqbFbSfl8P
	 42mdH3AdKtBL8Pma6hHaXD56kteFkJPyyaGzIoR9j9U0zqegL4Tytssjt9CIJJgDBD
	 dejGx3g7Ls37Z5U0k7BBCbcri/I1NoIMA709HT9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/208] irqchip/renesas-rzg2l: Document structure members
Date: Mon, 28 Oct 2024 07:24:01 +0100
Message-ID: <20241028062308.157728017@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit b94f455372ad6e6b4da8e8ed9864d9c7daaf54b8 ]

Document structure members to follow the requirements specified in
maintainer-tip, section 4.3.7. Struct declarations and initializers.

Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20231120111820.87398-5-claudiu.beznea.uj@bp.renesas.com
Stable-dep-of: d038109ac1c6 ("irqchip/renesas-rzg2l: Fix missing put_device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-renesas-rzg2l.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/irqchip/irq-renesas-rzg2l.c b/drivers/irqchip/irq-renesas-rzg2l.c
index 3ea312a27492b..ac925da17876c 100644
--- a/drivers/irqchip/irq-renesas-rzg2l.c
+++ b/drivers/irqchip/irq-renesas-rzg2l.c
@@ -55,6 +55,12 @@
 #define TINT_EXTRACT_HWIRQ(x)           FIELD_GET(GENMASK(15, 0), (x))
 #define TINT_EXTRACT_GPIOINT(x)         FIELD_GET(GENMASK(31, 16), (x))
 
+/**
+ * struct rzg2l_irqc_priv - IRQ controller private data structure
+ * @base:	Controller's base address
+ * @fwspec:	IRQ firmware specific data
+ * @lock:	Lock to serialize access to hardware registers
+ */
 struct rzg2l_irqc_priv {
 	void __iomem			*base;
 	struct irq_fwspec		fwspec[IRQC_NUM_IRQ];
-- 
2.43.0



