Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7722A1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8492C433C7;
	Tue, 25 Jul 2023 11:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283503;
	bh=vyQf+3mZIAmgjmDHAkm5GOb2K8UQZzMp9IVJpSJqyGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qB+YCa5XIaPrC/2hdmolZ1YnDyvY9sOvMxmEcy6eZC18Y0PZFOiOb8p73kxq8fc0e
	 8isy3CzhC8KzmSUC5Gc/0pNHmPJQdMfh4GeCrDuRcSuoAP1444ZWHoD/4L3agtcC2/
	 qbYqSajL/vthQ9P+FFVd0oyH92iLMmW7UAaU8Jhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/509] irqchip/jcore-aic: Kill use of irq_create_strict_mappings()
Date: Tue, 25 Jul 2023 12:39:19 +0200
Message-ID: <20230725104554.575847023@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 5f8b938bd790cff6542c7fe3c1495c71f89fef1b ]

irq_create_strict_mappings() is a poor way to allow the use of
a linear IRQ domain as a legacy one. Let's be upfront about it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210406093557.1073423-4-maz@kernel.org
Stable-dep-of: 4848229494a3 ("irqchip/jcore-aic: Fix missing allocation of IRQ descriptors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-jcore-aic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-jcore-aic.c b/drivers/irqchip/irq-jcore-aic.c
index 033bccb41455c..5f47d8ee4ae39 100644
--- a/drivers/irqchip/irq-jcore-aic.c
+++ b/drivers/irqchip/irq-jcore-aic.c
@@ -100,11 +100,11 @@ static int __init aic_irq_of_init(struct device_node *node,
 	jcore_aic.irq_unmask = noop;
 	jcore_aic.name = "AIC";
 
-	domain = irq_domain_add_linear(node, dom_sz, &jcore_aic_irqdomain_ops,
+	domain = irq_domain_add_legacy(node, dom_sz - min_irq, min_irq, min_irq,
+				       &jcore_aic_irqdomain_ops,
 				       &jcore_aic);
 	if (!domain)
 		return -ENOMEM;
-	irq_create_strict_mappings(domain, min_irq, min_irq, dom_sz - min_irq);
 
 	return 0;
 }
-- 
2.39.2



