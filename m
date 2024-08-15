Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D953214;
	Thu, 15 Aug 2024 14:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732591; cv=none; b=R/z198A3ixmGLxfU+FhU6WPD5GfQYakjMnPswPU1T9utdwRqf2/fRgqjlP4uVCvN/3QdvgV28hRpTu1jtn2uG9Aaq90S7/rrwjos7vfY6ctv+SJWZYcoWRMu86fCMyLTEK7S/pSNIF42nDmKsS+2bH208C7lzUmy9rndvztBEDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732591; c=relaxed/simple;
	bh=8Y+OB8/P3cRVchNPvq3T/hOH427Hwm+DDAInE4mQ7XE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWaD5e1b4pS+gxZBB3Ot6YxnP0burBqk16eQvu5QhLPVfFU8Cvb8uHkLgR9Z9Yp03mofgKUdgaYv1WnOVqi7oTS/groo8MvoMAq7KpHcHq327RYprzzODAWOHtf27uv6Nm00JlED7mcpVrKI5f/6BVgSEXm/8hBkv3/spybcjs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oTtfol18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oTtfol18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79987C32786;
	Thu, 15 Aug 2024 14:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732591;
	bh=8Y+OB8/P3cRVchNPvq3T/hOH427Hwm+DDAInE4mQ7XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTtfol18nOQRDRopvGH7Hvv+X3nJV1h7aVq79eBuSo9plvll4aC4LJFOVwWE3qlxY
	 HOGtc5IY+JUaxwEyjw1/jumQ0lIhBurwN3j+sKF+A0ACXJJIrhxT/YvdddM8Q0otCV
	 GOax7vxAuM0tWKiZb6MXX5/jfX1ZrB4bCjponOmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 227/352] irqchip/imx-irqsteer: Constify irq_chip struct
Date: Thu, 15 Aug 2024 15:24:53 +0200
Message-ID: <20240815131928.205726591@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1edf7692a790b..c9998b46414cc 100644
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



