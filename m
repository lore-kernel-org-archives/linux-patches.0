Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88CA18E37C;
	Mon, 28 Oct 2024 06:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097219; cv=none; b=N5Ax/gef6pudfrq2vjrsMcT+8H9gKnfQ98vX8o3cvzhDUbgf9KR11Pc7dLritcz6+slKiU62HpB1x8FwM5t6Z/LYC0s3gGafZUX9gO89QY8z9JfeK44boQYtw8s1jPQe/eQDP0JPSHQuXzcJRz5yRlmlz1+lPUUVR6+DGKeDVcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097219; c=relaxed/simple;
	bh=YUcrdvQjPTAmtmQxoYiE7PWc0DMWJYq0r+JLMxmyDRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEhjQ/gviRQZ52StDMX3HqpU54nKFXC82BBhydfoNWeYSmAObyH75YXB+Vow7o0U4P0lZ7bNNT6jwJPgWispfTTzHNkh+xVjGaFHl55dKywsxNMecjIY93Ys0ZkWzEfY3irJDiA8KEAfluWIg4rbvpbMMnrCtLMClSX+X/WiyfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n8rCs/RK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8rCs/RK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 754D2C4CEC7;
	Mon, 28 Oct 2024 06:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097219;
	bh=YUcrdvQjPTAmtmQxoYiE7PWc0DMWJYq0r+JLMxmyDRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n8rCs/RKEDSW2E5wHe7WOOlurPqA7m3j89ts0y5jh1fixu9w5ayRkwkBo2RhAC6Kj
	 SfbkjlRg0QC5EdCC/MsFNhI1ljJp3ykKZzUcwpbhFD9Koi/AZfuDUM5jHwIp+I7ECR
	 L0rAXKK8HUtyAd6Ll+H7+1Xy4lkIrT/Bxn2ubuyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/137] irqchip/renesas-rzg2l: Align struct member names to tabs
Date: Mon, 28 Oct 2024 07:24:33 +0100
Message-ID: <20241028062259.733443782@linuxfoundation.org>
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
index 70279ca7e6278..884379f207d50 100644
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



