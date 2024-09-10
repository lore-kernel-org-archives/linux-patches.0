Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA13C46444;
	Tue, 10 Sep 2024 09:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961028; cv=none; b=iUEMeFhqDibxK3VEYdpwfGVU3o0HKrLqyzmRqwGhoHB0reRXiL/CJ70YBlcUEDVfwkA9FwX/7+6vecs5r4vvg30g6VCtUibzIxg9iqoO/95OSvMLFcmGCIzj0pI/dzd9EkmmLFCWupVvd9I9xzcwQiOF+exjFqDY2W/GjQ7br54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961028; c=relaxed/simple;
	bh=7a9fyK9EcE1I98iR4H4tKRfED4FIv/vRd044KLVJWzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tYJIWdDqMwW/ndcA56W4QH0GXxIsuZ/nLko2CzX9qppzsNBpDxC1Q221ubYdm7xF+8JRGhyrjs+syquUKxXVhPBAsczWs5MbvmrqqOwNavAAe1DbXpVyGJq4gDX/CnixqDwwvo27MZBoZ8tlEDnuJ6aiKZhR8g/JKnN/VcMAaDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SoA9HeZS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SoA9HeZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71ECFC4CEC3;
	Tue, 10 Sep 2024 09:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961027;
	bh=7a9fyK9EcE1I98iR4H4tKRfED4FIv/vRd044KLVJWzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SoA9HeZSKjaEa6pnjr71NoJ3FLyrmTHV4ExgzzXSRiowKlDbORgn1dPSj6lMPAk6Q
	 w1hjzcK3c1XUh3Mo03ciROnlqT79isSoK8YDDEwKnMN+JknP3AmbKT/eKLsuviFigU
	 Qi0xBCjxiZnrU1eAx7jyonMa1XW+3zmsg8ALI37k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 28/96] irqchip/armada-370-xp: Do not allow mapping IRQ 0 and 1
Date: Tue, 10 Sep 2024 11:31:30 +0200
Message-ID: <20240910092542.720162599@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 3cef738208e5c3cb7084e208caf9bbf684f24feb ]

IRQs 0 (IPI) and 1 (MSI) are handled internally by this driver,
generic_handle_domain_irq() is never called for these IRQs.

Disallow mapping these IRQs.

[ Marek: changed commit message ]

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-armada-370-xp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index 0fd428db3aa4..73c386aba368 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -346,6 +346,10 @@ static struct irq_chip armada_370_xp_irq_chip = {
 static int armada_370_xp_mpic_irq_map(struct irq_domain *h,
 				      unsigned int virq, irq_hw_number_t hw)
 {
+	/* IRQs 0 and 1 cannot be mapped, they are handled internally */
+	if (hw <= 1)
+		return -EINVAL;
+
 	armada_370_xp_irq_mask(irq_get_irq_data(virq));
 	if (!is_percpu_irq(hw))
 		writel(hw, per_cpu_int_base +
-- 
2.43.0



