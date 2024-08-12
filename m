Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C82183CD4;
	Mon, 12 Aug 2024 16:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480642; cv=none; b=LLK49nayhwri5f/585EPMF0Nyw2k/i8urZj8ts5p5f/tgwMWqA8KuKUxt8+FRqcA68y/dsJXx4vfOgAAoUAW7qvWjS7pB5bCGGsP0onJwJjJbcJHfW1qep5isFBGGZYALO3pHNTSJZt/6u2OE+wDHANPzsfoFIL7ZotSod2Vc0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480642; c=relaxed/simple;
	bh=htZ/LVA03gAibF8FVBQBdNdfoe0vV5/azTwX/j5sGwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMGWLfew5ygofv5RejQRofweAXe41DEVKglgUk41ukqITAYMmGGQoF5nvL5aIoX9+CGev8LTR/InK3dKb7HFn0DICIMAJQgBdT8FALk51ClivgeNNXaMyW5tzwPncHfgDG3cE1F5M0ExcI05HS73E/2vHn7smkTS6ZGqszhig8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xD7ryuC9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xD7ryuC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0453CC32782;
	Mon, 12 Aug 2024 16:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480642;
	bh=htZ/LVA03gAibF8FVBQBdNdfoe0vV5/azTwX/j5sGwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xD7ryuC9c8uzDSDjWl4HmWQtTv7ee83+j9zZjiBff80crVDY3YbCNWKcB2fUt40Kq
	 +yiRmg6evopvhkYZbq3FioJyXsAEQ+C7tv5SNL+0BMQrDVlpERX5QALOAf7XUuaMGV
	 hoTBz5tjKPUb3iaoGl9Qi7CBn4Onc9/xo52GWYpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 217/263] spmi: pmic-arb: Pass the correct of_node to irq_domain_add_tree
Date: Mon, 12 Aug 2024 18:03:38 +0200
Message-ID: <20240812160154.850402141@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

commit f38ba5459ced3441852f37f20fcfb7bd39d20f62 upstream.

Currently, irqchips for all of the subnodes (which represent a given
bus master) point to the parent wrapper node. This is no bueno, as
no interrupts arrive, ever (because nothing references that node).

Fix that by passing a reference to the respective master's of_node.

Worth noting, this is a NOP for devices with only a single master
described.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240522-topic-spmi_multi_master_irqfix-v2-1-7ec92a862b9f@linaro.org
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Tested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: 02922ccbb330 ("spmi: pmic-arb: Register controller for bus instead of arbiter")
Cc: stable@vger.kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20240725164636.3362690-3-sboyd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spmi/spmi-pmic-arb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/spmi/spmi-pmic-arb.c b/drivers/spmi/spmi-pmic-arb.c
index f240fcc5a4e1..b6880c13163c 100644
--- a/drivers/spmi/spmi-pmic-arb.c
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -1737,8 +1737,7 @@ static int spmi_pmic_arb_bus_init(struct platform_device *pdev,
 
 	dev_dbg(&pdev->dev, "adding irq domain for bus %d\n", bus_index);
 
-	bus->domain = irq_domain_add_tree(dev->of_node,
-					  &pmic_arb_irq_domain_ops, bus);
+	bus->domain = irq_domain_add_tree(node, &pmic_arb_irq_domain_ops, bus);
 	if (!bus->domain) {
 		dev_err(&pdev->dev, "unable to create irq_domain\n");
 		return -ENOMEM;
-- 
2.46.0



