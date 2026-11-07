Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060870;
	b=HM0/1CsY/wR3GFDiS1qeJ5JtetgwrjhWdREaKtUbcFT8dR4MkHyAsIr1wgs/pwlbPIGj
	 A/jDcNApslgoXw7Gdt4hM9fA5xwfUQfeaNAxbyNnXR0NUODyTnaOaRJdstuT1Sz+Z+LI5
	 OFmqM2n7wvOTMUSE7ZEcL/JtB5W17si1k46+/m2IfnAYKYHuzcReE37Jf5T7Ju7udyGnb
	 ST8aYV/nsZMlz1ovKsy+6xWNoamZF5zgxjkBtzq3j/QrZZebpJYp0cSt+30tIZWu00xe5
	 Sxlk9xyf6RzPvWX4VMQJzhdg0HVaMNclOAcMmEHwvKEpZQxC3QR+u7J3uqUqnb5rclA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060870;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SmG7088srPENRUnzClSRVcL7LupunVnXkH1isOfLKhQ=;
	b=dzsuIqirguwI7VFM2gxtkS2sZ0nh/3JR76cNvmrC+Zxbkqchvk0dw170fPfSqJdWwvJR
	 WCyCVmaMpF4ynMl1Ikzd6ZYt/509R8R3R77TGv58xB3tzM8Y1zRAuqb1LoCZqzj+/TgJZ
	 Xdi4p1D87eMfNC9QMOs9c3Ie7RoaqrNojTqNtInbJP+OcqTGSR2nrq72LR0TC1mbAvQC+
	 DKKHTMe1n4qQvtLvvtBfJqJ+u9NWVVZgcKc9e28Y8jMs3RUvhFisr7TO5MX+Xb0XhLqxx
	 UreARYYEHPje5xrHma/wUlnS6h14cgIDEIMutwvfwVjafEtnKmHzFGJ9Bi6Bsfn3FBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jNWm4fA4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53BE606A33C;
	Sat,  7 Nov 2026 14:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jNWm4fA4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8DF1F0089F;
	Sat,  7 Nov 2026 14:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060869;
	bh=SmG7088srPENRUnzClSRVcL7LupunVnXkH1isOfLKhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jNWm4fA45cU8dGpbLXzvxtnnTXo8N+L2NGOmKbdg8uKZlAAy6zxobioykH/w5/okO
	 mq0Zc96uabuXpvv1DTa285ownJM0ZwVQ+6nsb1LhMUBr4kTF7tFriCa9ZB/v54KfuG
	 WdB9b7TP+q4DnqF+ZWfZGxYBXFc/y9mZiSy+fv10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomer Maimon <tmaimon77@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0211/1536] pinctrl: npcm8xx: clear pending GPIO events during init
Date: Sat,  7 Nov 2026 08:37:07 -0500
Message-ID: <20261107135003.581204233@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomer Maimon <tmaimon77@gmail.com>

[ Upstream commit cd39cce4cfd499f555eb8b8252636609c3468f57 ]

A bank may retain pending event status across resets of the GPIO block.
If probe leaves the old state in place, the chained IRQ handler can see
spurious events as soon as the irqchip is registered.

Disable event generation and clear EVST before wiring each GPIO bank
into gpiolib so the driver starts from a known state.

Signed-off-by: Tomer Maimon <tmaimon77@gmail.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c b/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
index 430cabf3dc07b..3c030a1b44b57 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
@@ -2427,6 +2427,9 @@ static int npcm8xx_gpio_fw(struct npcm8xx_pinctrl *pctrl)
 		if (ret < 0)
 			return dev_err_probe(dev, ret, "Failed to retrieve IRQ for bank %u\n", id);
 
+		iowrite32(0, pctrl->gpio_bank[id].base + NPCM8XX_GP_N_EVEN);
+		iowrite32(0xffffffff, pctrl->gpio_bank[id].base + NPCM8XX_GP_N_EVST);
+
 		pctrl->gpio_bank[id].irq = ret;
 		pctrl->gpio_bank[id].irq_chip = npcmgpio_irqchip;
 		pctrl->gpio_bank[id].irqbase = id * NPCM8XX_GPIO_PER_BANK;
-- 
2.53.0



