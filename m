Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA1A347FEE;
	Tue, 16 Dec 2025 11:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885125; cv=none; b=blT8d8jXUIfUME6FnzHXkgnhe25tJXmg4+DPBi4KXr+yv9wxlI3PvNO/ECnzSCfF2RvmkA85Lq5SPi0T6XIJnhTS9QXc2UmZ6M2dZwGxJ3+0W9YcbMPoRbH1M/qF5mdc/mt/5yjK3hcQmFmafsqhzbP4f5NBxNr3sTn2/RAxd/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885125; c=relaxed/simple;
	bh=eigKj6dMQiES1hjzsZBoB9mViFoaCkNpB2Y+HDwQmqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDI2cmS5Cvyr4tZLoHhQvfFOGiMhoR3ZC5pBCy7k8hzEEWdAn/+O2j9NR51RfBjp3wfL4Iz9XWqOE4k7uRhSlTUEq9aImCqrlWNZgbEM8l6HKD535RO5TQrhYdPzBpOam5R0fQY3Rd0U87uW/+cf0LtWfaPtkw9Sg416zoe1tkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rHpGOLhd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rHpGOLhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892C9C4CEF1;
	Tue, 16 Dec 2025 11:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885125;
	bh=eigKj6dMQiES1hjzsZBoB9mViFoaCkNpB2Y+HDwQmqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rHpGOLhdUBytIs/qWkKNb44RnovW1EnCZhTFcY3BMuetyo94I2GLGK42y0A+QJlCt
	 2V0LIIDfhk8qTxFEh6Lkuyt42YJDciPc9jCZcLLRR8F+tYSl1bcb7dpx48g1IwNXC8
	 ZFSedpDeAblN1MzPTy3+bqVJPhdemVADk0XHqQo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Changhuang Liang <changhuang.liang@starfivetech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 045/507] irqchip/starfive-jh8100: Fix section mismatch
Date: Tue, 16 Dec 2025 12:08:06 +0100
Message-ID: <20251216111347.176272704@linuxfoundation.org>
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

[ Upstream commit f798bdb9aa81c425184f92e3d0b44d3b53d10da7 ]

Platform drivers can be probed after their init sections have been
discarded so the irqchip init callback must not live in init.

Fixes: e4e535036173 ("irqchip: Add StarFive external interrupt controller")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Changhuang Liang <changhuang.liang@starfivetech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-starfive-jh8100-intc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-starfive-jh8100-intc.c b/drivers/irqchip/irq-starfive-jh8100-intc.c
index 2460798ec158b..117f2c651ebd0 100644
--- a/drivers/irqchip/irq-starfive-jh8100-intc.c
+++ b/drivers/irqchip/irq-starfive-jh8100-intc.c
@@ -114,8 +114,7 @@ static void starfive_intc_irq_handler(struct irq_desc *desc)
 	chained_irq_exit(chip, desc);
 }
 
-static int __init starfive_intc_init(struct device_node *intc,
-				     struct device_node *parent)
+static int starfive_intc_init(struct device_node *intc, struct device_node *parent)
 {
 	struct starfive_irq_chip *irqc;
 	struct reset_control *rst;
-- 
2.51.0



