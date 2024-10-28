Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA85E8837;
	Mon, 28 Oct 2024 06:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097971; cv=none; b=hSv1YnAbXg5IOXMMNZoZE82hE/p5yIgavHyiafGJGe1eORn3EnJi2vUW8jzEb4IutVaB3nrsOsPxFyTsH/e0D3DmoUmOfXc6+t00bFVK+jRRIQVXHfrPOryvpmXhJqDuGLXDNKNaAkEswwO1258rhz3IseuOgvUq4uG4Cp1FcuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097971; c=relaxed/simple;
	bh=/3A+5LJ7VH4OI6q8AdAVwOPYNCd0W4m2Ya0C6acj50k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eh065io5j7YNE/oxMDYeTfzRvLhEkYNfELwANnaGk1G2PVrAy7FUUiUFzH4NtmNl7BMtrVhUSVjRO29w1a7t32BWsoBzg4BthA+jGtGf8T2504lKN+PO7Iv8Oep3A7T6CiBDml3jWZND3mSf86Cn0yJIngPk2+vWCHsVSeV1zVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+plQqlY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+plQqlY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5213DC4CEC3;
	Mon, 28 Oct 2024 06:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097971;
	bh=/3A+5LJ7VH4OI6q8AdAVwOPYNCd0W4m2Ya0C6acj50k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+plQqlYUcb5F8gpl3ijIvHkm6nPhb/5I1PVynUpejpGg/NAyeGv7NN6l6vyQLCDX
	 Cu5NYdhkqRHurxnxltfRXPWAvEMzo5NfUhInJRs9k/2pfSObg1nwm/MEDpAQIhrijz
	 9rAHsbJ7Gln+2dAssb1EqihCklyMP4nx7tMN9aaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <ajones@ventanamicro.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 006/261] irqchip/riscv-imsic: Fix output text of base address
Date: Mon, 28 Oct 2024 07:22:28 +0100
Message-ID: <20241028062312.171797315@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Jones <ajones@ventanamicro.com>

[ Upstream commit 4a1361e9a5c5dbb5c9f647762ae0cb1a605101fa ]

The "per-CPU IDs ... at base ..." info log is outputting a physical
address, not a PPN.

Fixes: 027e125acdba ("irqchip/riscv-imsic: Add device MSI domain support for platform devices")
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/all/20240909085610.46625-2-ajones@ventanamicro.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-riscv-imsic-platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-riscv-imsic-platform.c b/drivers/irqchip/irq-riscv-imsic-platform.c
index 11723a763c102..c5ec66e0bfd33 100644
--- a/drivers/irqchip/irq-riscv-imsic-platform.c
+++ b/drivers/irqchip/irq-riscv-imsic-platform.c
@@ -340,7 +340,7 @@ int imsic_irqdomain_init(void)
 		imsic->fwnode, global->hart_index_bits, global->guest_index_bits);
 	pr_info("%pfwP: group-index-bits: %d, group-index-shift: %d\n",
 		imsic->fwnode, global->group_index_bits, global->group_index_shift);
-	pr_info("%pfwP: per-CPU IDs %d at base PPN %pa\n",
+	pr_info("%pfwP: per-CPU IDs %d at base address %pa\n",
 		imsic->fwnode, global->nr_ids, &global->base_addr);
 	pr_info("%pfwP: total %d interrupts available\n",
 		imsic->fwnode, num_possible_cpus() * (global->nr_ids - 1));
-- 
2.43.0



