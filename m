Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C479218D630;
	Thu, 15 Aug 2024 13:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730152; cv=none; b=PE2jMEjR2SxOfvz6zLoL+i3QUvy3qSOIiQExdlLmE6CH1WrrvBSGK3EXrzjMG20cMzBPnIJpZDXvirmNKVVsjo/fG19OkD0ZS8C3hIqfOEMHeo3s6Wj90beAkH2rxv1NfkxsNV3mgE20s+hvW1tUie3MGG4X4RQsSj7mWROhhA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730152; c=relaxed/simple;
	bh=3dHmc5s3UwOIgyP2L9Zb/nCN2SIxMHgpHHgXjQiIIVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXaaQDjRZinms0tM5iLOmMn4joVJMGXXl3pK1pHCwGgwQlkN253j1oowPNQb4LkT3vnhGxOMgdmTjo8vMd3FEi+AZd4OKNOS1aOCskRNUIfRRdi1EnuX4rfBzSBHENTYxTxJf0y6LgqFMjOc0/nexw+cfiIULGcuJio1Iqqt2Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDRf1Sfw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDRf1Sfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2FBC32786;
	Thu, 15 Aug 2024 13:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730152;
	bh=3dHmc5s3UwOIgyP2L9Zb/nCN2SIxMHgpHHgXjQiIIVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDRf1Sfwe7oi+ByCyt8rIgaNcjbNDx8e01Y0e+ZW0gHsqVGba4SpyVLL33vErrX2E
	 tRCE7utdzfijI+OdDXdGjSz3yyKPAvpieypI65ra8BLjCTYFG5lZc6rftOtzfleXTK
	 foBrRAO4IEZ5l+L6zqYHpp8FcN7r7uX0p6kOijR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 319/484] irqchip/imx-irqsteer: Constify irq_chip struct
Date: Thu, 15 Aug 2024 15:22:57 +0200
Message-ID: <20240815131953.727292420@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit e9a50f12e579a48e124ac5adb93dafc35f0a46b8 ]

The imx_irqsteer_irq_chip struct is constant data.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220406163701.1277930-1-l.stach@pengutronix.de
Stable-dep-of: 33b1c47d1fc0 ("irqchip/imx-irqsteer: Handle runtime power management correctly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-imx-irqsteer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-imx-irqsteer.c b/drivers/irqchip/irq-imx-irqsteer.c
index 8d91a02593fc2..e286e7c5ccbfb 100644
--- a/drivers/irqchip/irq-imx-irqsteer.c
+++ b/drivers/irqchip/irq-imx-irqsteer.c
@@ -70,7 +70,7 @@ static void imx_irqsteer_irq_mask(struct irq_data *d)
 	raw_spin_unlock_irqrestore(&data->lock, flags);
 }
 
-static struct irq_chip imx_irqsteer_irq_chip = {
+static const struct irq_chip imx_irqsteer_irq_chip = {
 	.name		= "irqsteer",
 	.irq_mask	= imx_irqsteer_irq_mask,
 	.irq_unmask	= imx_irqsteer_irq_unmask,
-- 
2.43.0



