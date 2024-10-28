Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3226618E34D;
	Mon, 28 Oct 2024 06:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097222; cv=none; b=He3LdTPfC8YEkS7vTFjjm//u5tZQGK4oeptw66kjfS5c1d+0y6WQMm2F1rfLvAukEDMXHm7wDh20jWrG6pPVCUdxhjxKqfhPowm1SKwqr5MDowkPiJhmATsbmQR9gDXYCOgOfB28GtmPLmRMJStzhpBCLC7oTvt4aVoXSSHgB+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097222; c=relaxed/simple;
	bh=1ygkXT6LKoIwKbaINFVyiY61aMmeVH7V/d+KY7AN0cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mI0KKR7ForUT/5VNTvVcICl/TmY5c7Qjh238Z8iNqK65C0fV8vVuOKUlpMgM3YA1kMm1fL5UeFUVwTXMqbmV62QPmDz0WMU4vxYsk7VaM/7CP28YKkZumwBGix+RJB/67P706SNINZYx8ERhJis4PSpeqkge7WCqdlEHhfNB7wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v7xM/CZr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v7xM/CZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1494C4CEC7;
	Mon, 28 Oct 2024 06:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097222;
	bh=1ygkXT6LKoIwKbaINFVyiY61aMmeVH7V/d+KY7AN0cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v7xM/CZrOxSMARxz0MZmF5Ar4jEN9yRSaQimt8OzEUH8t8ma78YM89Iq8mctUSHyj
	 /i4wOkvezNBe+SP2LlfzT00TUF8jV7pbQjDzw444YKG9OtMqVLe9qB6YOXphV5jS+X
	 2qmw9XvC8zOmce7Ks5oHf+zDRafq9jWomk4VYtg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/137] irqchip/renesas-rzg2l: Document structure members
Date: Mon, 28 Oct 2024 07:24:34 +0100
Message-ID: <20241028062259.758297571@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 884379f207d50..61502a81dbb54 100644
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



