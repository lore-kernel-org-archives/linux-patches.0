Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829639;
	b=UZcZYMIJw0w6J2K9h4olSPFj3a07dyClZ8tpjM3guAnS/dO4p5Coh7HEyGQLj8q3uU4N
	 9FvBLdsTEFeqgbvRvPxhuFLpL/9Iue7ebBXGObCrK9DKd5WO6JsVPHifKwWJKYnKlZ+i4
	 G4yUqrDLFBLyImhtXvShSpJ0oprM8GCK4ZfCZZs1mvJbIAqmJi99scQ4ZDyOeBdP1cd/l
	 OtwHFGTkxtxCC7PZ9PHsCrM++BxatuKChGncUcQwn8v0YvSGmJwDSK1tR/Ou05+ncDEGM
	 YqZYvVFsKfh1raC6UV312ANXWggrqs3mZc6tLGrwwv7VRQCIZk5lCv41cAG5P2uahrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829639;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kxQHsCfkKHFQ32dwPfjVBSE8N8DWPx+bjT07HZYkEuM=;
	b=y+L/kiIAauIbZ7OceHJMrj02ftLah2q7HZS2ojK+ks8+38LgWDpy0I7ukhsNNi8dEUkB
	 0zb/ZBozNzZhRvde9jPiylAcYiibytGaMKTEr4JxQUd3mRCjzcmQH8BLZuQjfNR0P3nEI
	 kIdhDYhq/p+UlrY9fXnmholKWROuQ/U+dR0ZR0vsG+5kSmvttVUBfO3B9UbzAKRCcz60h
	 EXlT1xllseHeis6j4U9MZou72eNMPR+D8LM7rgrBNDYdFXYMFC80C6mvViY85RAXvQ2kD
	 nfSet0WUrtW+U/rOmqh5zS1DBnNUx3vnHM7c8393vczulS8iuSXATwo0Rr+APoPP8Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iI90mVZJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666AD606AC22;
	Wed,  4 Nov 2026 22:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iI90mVZJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A3691F00A02;
	Wed,  4 Nov 2026 22:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829639;
	bh=kxQHsCfkKHFQ32dwPfjVBSE8N8DWPx+bjT07HZYkEuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iI90mVZJS0l6hMOafls/PqY9Wv/SiuaP2DqHsbCxkz5rqApSOJ/HEN1Pix/7xFFIh
	 75MYLHdvIHVGLl8PAnR+14y9yTbTLfyvvI0Tmn5k8U4DOM1omm+FES3vF4kwDWxpgI
	 I4nc9AqGbmvY3IOkCpnGMtkIaly13VMwtkaL39Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomer Maimon <tmaimon77@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0249/1005] pinctrl: npcm8xx: clear pending GPIO events during init
Date: Wed,  4 Nov 2026 15:59:42 -0500
Message-ID: <20261104211050.834248138@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c94441b2acdae..22cc87d43ea69 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
@@ -2412,6 +2412,9 @@ static int npcm8xx_gpio_fw(struct npcm8xx_pinctrl *pctrl)
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



