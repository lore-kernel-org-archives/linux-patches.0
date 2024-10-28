Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0E515B10D;
	Mon, 28 Oct 2024 06:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097694; cv=none; b=HutvcvgYDVszgdWXnxn3WimsE1z8rM8U0kfYz5SEdoXyv6lQOakoAjQBLYE0v530fE66ekeao53nwQTYfoDWyraf9n9twyilTPQt2eLt/fp3RPAobH+9h51VBK5ydTXDyvBt7BsBysyZHwi1QcWljXKyemT4rb96uBgaPAJ4FPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097694; c=relaxed/simple;
	bh=WuX0ZQIua3u+qJOF2b2beFng56v0BMtMRS3UQJPxmKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLt78Tgk8mrBQBvOwOZEci25aq6clWBp+Q86+a0aLpi5z4KT13FRO8RRExT8LcND3uVki7PVna6zPNdw0fn9f+WUlYwNkVuycnl2SxPzdkPoix2ZGdFhqo1iUBrlUAqHneHU0yK1kqYw1NPmxzLkYdnh6DrAgk7nJJlPFExS5wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TqP7jNmi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TqP7jNmi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF825C4CEC3;
	Mon, 28 Oct 2024 06:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097694;
	bh=WuX0ZQIua3u+qJOF2b2beFng56v0BMtMRS3UQJPxmKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TqP7jNmiWGkmA/ZoPYAY/QBEXHXtmZRIK4FjfiAFAqA6qx/REkhob8s+MoZ4UTQpj
	 aYXQWakO58B9dtKUZy+Ng0tJyF+Kqmy05YYR6orlm+aFKoXUf+XFaDdTAOlMMJreOz
	 Y7shS2kvypg2uB+W50QFUaDNPEfVPpukjh3Y23mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/208] irqchip/renesas-rzg2l: Align struct member names to tabs
Date: Mon, 28 Oct 2024 07:24:00 +0100
Message-ID: <20241028062308.134492519@linuxfoundation.org>
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

[ Upstream commit 02f6507640173addeeb3af035d2c6f0b3cff1567 ]

Align struct member names to tabs to follow the requirements from
maintainer-tip file. 3 tabs were used at the moment as the next commits
will add a new member which requires 3 tabs for a better view.

Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20231120111820.87398-4-claudiu.beznea.uj@bp.renesas.com
Stable-dep-of: d038109ac1c6 ("irqchip/renesas-rzg2l: Fix missing put_device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-renesas-rzg2l.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-renesas-rzg2l.c b/drivers/irqchip/irq-renesas-rzg2l.c
index ea4b921e5e158..3ea312a27492b 100644
--- a/drivers/irqchip/irq-renesas-rzg2l.c
+++ b/drivers/irqchip/irq-renesas-rzg2l.c
@@ -56,9 +56,9 @@
 #define TINT_EXTRACT_GPIOINT(x)         FIELD_GET(GENMASK(31, 16), (x))
 
 struct rzg2l_irqc_priv {
-	void __iomem *base;
-	struct irq_fwspec fwspec[IRQC_NUM_IRQ];
-	raw_spinlock_t lock;
+	void __iomem			*base;
+	struct irq_fwspec		fwspec[IRQC_NUM_IRQ];
+	raw_spinlock_t			lock;
 };
 
 static struct rzg2l_irqc_priv *irq_data_to_priv(struct irq_data *data)
-- 
2.43.0



