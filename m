Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC691AC8AE;
	Thu, 15 Aug 2024 14:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731662; cv=none; b=OpWDVsU8gWZI2sbJk6m+SS84q+JMgwpExFEqGY7oLoq2SAEKPApLimNIdUtMZuzDPFRgk6nHUxghU1KWsZODZFS6QAiPIPuHD97jNSpucqUrs/mG13FdVWUKLa8q+sltzwX+UwlCZQWsDCu3c1p4VJfdIss/TAtPeBi/1gZ+7Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731662; c=relaxed/simple;
	bh=4Llp3lqRu+8td1SJYAz+sxKBtHVF7Y9e3k+2W9Bxek8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+i9gIrae/uKTGfTgQgO3iaZRtqrc2/Xzqcj5SaKbFyvhHcrfUcoIT6HY6kBjvY3DuYup5m0izBTm2+adfpJ9c1GgegiS9LC6OL3QYmLkm7baPcMT+tq+RkHEHDQGAbxPhnqU6sMovVPJiO4GFC+Um1S06D4KHzifCWVtGWzUkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OG/e4gHd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OG/e4gHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97855C32786;
	Thu, 15 Aug 2024 14:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731662;
	bh=4Llp3lqRu+8td1SJYAz+sxKBtHVF7Y9e3k+2W9Bxek8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OG/e4gHdDbLi9vO9IzyIarR1S1eoYPNbz96BCKLaNSWQMaPO6PBLgt9x8p8S3Pqx5
	 U8WDKQ+qBFQCcxlAj6vkW3MdluplG/C+8HPQHjg2WqhcvTI01b2FXy5KxE35EpGmQC
	 aeDjxAgaNbmjWNVWrVDMbwrE8Mmw59oJimeg3TlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 167/259] irqchip/imx-irqsteer: Constify irq_chip struct
Date: Thu, 15 Aug 2024 15:25:00 +0200
Message-ID: <20240815131909.230915108@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 290531ec3d61e..1b01e655b9923 100644
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



