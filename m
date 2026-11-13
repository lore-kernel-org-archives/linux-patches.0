Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591463;
	b=tGG+/F/CKgnVtdnsGjfKhryGezVs3n5JgDjp4BfItkSQRXqAH2JrLvv5X1Kxi2XyyKXl
	 AdTVTomAWKDurmPcNXteIPKxAqUz+lO8+YZFdgbBzIYhpjvFzF75snP2Jvy7BtneY/apx
	 YmpHk+7MO76mKBPUHHXK2cTOtzMi1EHGZJX/119MCdaI6TO1HESdTIz66RXh0o/rAtZRk
	 0vrUltlusCeamaYy0t6fJ8NbcdW8gCsVLq66Cg59Ly07hmv3CKdfVPyDBbnsmfmly4lza
	 TouxyDTCnBAX0rbOduVu7HDPSER4j2GahRrpLWFYVi2DvVeOH05MnqzLfPm9/Jz1X7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591463;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aBtnky/1UYCtObbuGOgPVEsm0uzDY74CrUS+2CRPCZw=;
	b=ZkRmREpG1EoUxg60IgaT4JuLJRl62soD8aY4C4EexizR5Gegs7LoGSyh3+0a9eOXqAd9
	 4oqBSPkhKRYKXz4nHRwUxvPZ9G/NaMspxx1CwV2uNAIDOBY/JJNpsMoNbpo2FY1xkCBno
	 NMenXpq8Y2sqPyUAWEyBC1e87JVIv2VAVMkcLJHT4xqbofLwALEGTVp0xKv+jvAZx7WBF
	 J3jhoakq9tUJuiO2AtEDBMwLOsLyCI/phZUszmnqBWT9wzgwzp4b2t6zGE0HUMpxwlKHa
	 IFs6cSeYpDIdiN0bv+kixl5BJyo01UNLjr+3Wf1XnvPtQm6cB+rUZlPND7kBdV7o/vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lmz6Jnfo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B76606E20B;
	Fri, 13 Nov 2026 17:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lmz6Jnfo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D9D1F000C4;
	Fri, 13 Nov 2026 17:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591463;
	bh=aBtnky/1UYCtObbuGOgPVEsm0uzDY74CrUS+2CRPCZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lmz6JnfokOfagu42ITopFN5mDtEh0YPY7x2iIxzdQI9YEca8GGyFVHOP9BhN6ct3c
	 2fymUM8r46VU4+cIbTd5yUoSiOy9E0wdQDaQ32eda5lj+rBZswSqK/4h93+K5UdqtA
	 oRBOeIIMcxmJfDYdNOFqmmmSmrOFYujF/XLPXiF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 548/670] serial: sc16is7xx: declare MCR and IER as volatile registers
Date: Fri, 13 Nov 2026 10:51:52 -0500
Message-ID: <20261113153830.459756578@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 1c41d09dcd07ee9648e20aa8238e404c2e6a12fb ]

MCR register has the same address as XON1 register.
IER register has the same address as DLH register.

Which register is accessed depends on bits configuration in some
other registers.

To prevent potential access errors, declare MCR and IER as volatile
registers.

Fixes: dfeae619d781 ("serial: sc16is7xx")
Cc: stable@kernel.org
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://patch.msgid.link/20261006192540.234402-1-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 92869e56ce5d2..5c6339f6f1bcb 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -536,7 +536,9 @@ static bool sc16is7xx_regmap_volatile(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
 	case SC16IS7XX_RHR_REG: /* Shared address space with THR & DLL */
+	case SC16IS7XX_IER_REG: /* Shared address space with DLH */
 	case SC16IS7XX_IIR_REG: /* Shared address space with FCR & EFR */
+	case SC16IS7XX_MCR_REG: /* Shared address space with XON1 */
 	case SC16IS7XX_LSR_REG: /* Shared address space with XON2 */
 	case SC16IS7XX_MSR_REG: /* Shared address space with TCR & XOFF1 */
 	case SC16IS7XX_SPR_REG: /* Shared address space with TLR & XOFF2 */
-- 
2.53.0



