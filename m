Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED7835F8D7;
	Tue, 16 Dec 2025 12:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886854; cv=none; b=XgDi0BpWE7GL4jZhhP3P31I4TwU/u+YvTGVH41oO+KVh+KAeCONqgdE9dXk8JwfduvkK8pThMfl7QBhKZpwV40ZURlue9TzebGtkz2VfOZh/LgCYfyYHbGOPxt9n0VyXGqqJ6xYcn//iPm5vk/4hfZF9xHhBfLgDS/fqFBQJEfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886854; c=relaxed/simple;
	bh=S4EDc7mti7ODFVFnikHZ/Ie69AzGxMKhe0XedECiqX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kEGSY1t0kjpGHOc/kqlzLV7Ny5UZjZX6qoNddHZH4IfqJMD76urrI5ziJWC0YOuXLaZnGcdsURQgTPyal5CPvyzYV+Mq5mjPc54FN6ukUARjvaMYFTVdDsqp2H0XO4ARl8WQ1sm+LUq3CcqmgYgeZalK1ZUrtTfy1RBrwXQK0ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+wzkLvT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+wzkLvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9296C4CEF1;
	Tue, 16 Dec 2025 12:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886854;
	bh=S4EDc7mti7ODFVFnikHZ/Ie69AzGxMKhe0XedECiqX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+wzkLvTUVZGKFJwqcpiKsa3ag0oYQnPkCiRES7EbA9sSWI6KMyoTSfS1UC3QDZR+
	 voccVZwshfza2M9b8Va1U7uejtrcHdFgv8OIM2i9zM/dvRlUiC1LJuGwK5S6VCgzIg
	 N10gtXLTD5FiHwpyHiX1JiuxNXge4VqkPBQO5mfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Changhuang Liang <changhuang.liang@starfivetech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 052/614] irqchip/starfive-jh8100: Fix section mismatch
Date: Tue, 16 Dec 2025 12:06:59 +0100
Message-ID: <20251216111403.194412238@linuxfoundation.org>
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



