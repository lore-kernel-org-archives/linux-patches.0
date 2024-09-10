Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED2E17A924;
	Tue, 10 Sep 2024 10:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964987; cv=none; b=ao+LsSVSbX5zbrlbZ8eqf0CXF2yMjKD1b3/luMkt8P5PJWkkTLKpXnT896aC06tN+3XfNjIewabJIJe9v7TtI8+g9mwoX5r+/DOVmiQKXuFFyscYznKOjRLt6xJZQraTdCoGdHlHJngXELOs+aNt7IftqUifX365yVUPcSKHx4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964987; c=relaxed/simple;
	bh=rUM5gl37fPw5b/2mfR6qYgoAwBqkoEUe2opCySo3xXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BRhbzfAyUlN6pUL/O52i1bGO7SHjok/Gro5YSmHTITbawILC0LGEAa0bGmPQdMJFUN4+nDYkut2/zCssHGxtNqaB/VOUq0ulPHO+G/o9lHolgfHf6PVlPxjh8hzV7kyi9WwtnxsRMk7WP45YC7CIavZUDDWOopBTz7OeDvcp50k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wi374CnF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wi374CnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684A3C4CEC6;
	Tue, 10 Sep 2024 10:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964986;
	bh=rUM5gl37fPw5b/2mfR6qYgoAwBqkoEUe2opCySo3xXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wi374CnFPtndqOdEIIgJLoJxv3jmavUQuXqo6UPMVXxR4TOIjNnBQQkhF9n6x0TcV
	 X1wJaWTS+qN91ifhd+s6oFT3JwMpcBKl2TGfGaWTX3LENXEYgPvhejxU8HH7WrPbCV
	 nn4SOVMuPfqFhoQo5QZaPLLT2XVenX6J0civ57Wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/186] irqchip/armada-370-xp: Do not allow mapping IRQ 0 and 1
Date: Tue, 10 Sep 2024 11:33:14 +0200
Message-ID: <20240910092558.606482840@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c76fb70c70bb..e865a43428b8 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -546,6 +546,10 @@ static struct irq_chip armada_370_xp_irq_chip = {
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



