Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023157;
	b=MnIlKAcYkdYGhgpkHtgXua+NvZ3fm6haa0djk3PKmunQWvSEwLnrarytXnM8pX6JueNm
	 1k+MMNyqmgfHF1ao+7NpoH0J0KlxP/7Opnd468Leuel4YYVvoK6jI0xSG0/qzLdRNEl7o
	 ub42XztlQw+GdHVOsP8hffp5fU/G4AYhzXlD3nD6AqnfFCisv2eZ7Jl+p9GfcGaYO1+Ya
	 mEzGsl2M6jYQYfFyS6JYJ/vO7LKljL+VdgS/QbsyNSl/6tF0tZRpHznYg7YfAFHP3WsHd
	 24l3XJqL/pqF53o1Zp+ZuTqQSfvI0ND4ueprQlDWndjaQ73u6cO37k03t7wEhMaXHQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I49HwKR5rUMREqmbU1DyIYBV6Sru1uTiyJ9xXkXQAT4=;
	b=GBxtl/lRBte2zLBOBhTkU2ayVfiJZpL/btz9nX+zyss47vC2n0Wecs5pjl04fNMbGjyC
	 y0Obu4mUfBMpYmq3jd+1peV4NOKwHEOMFHmLXH2CKprwQPlTGK9vHiZsesBJnU7atHDWv
	 JwrL48YqTbtirlBTre9RCCSSdlC3Tn9PCxlIiBzUxtHoMmoathlErxsg7P10nVRn2sFsE
	 9+schRHv1gt7BhcICkFjgoY8KB4EvqtB4N9Y4qauUT1FOfiTCSSLld56ioWfU9cXEOWyA
	 rSPtrOOGMN/rP53fhtaDrCKJ8eHLsMlx+L3HkoNeWdCWKI7zAUKK1zrf42BmP8fF30A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=syZa4noV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2460D606A32F;
	Wed, 18 Nov 2026 17:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=syZa4noV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD451F000C9;
	Wed, 18 Nov 2026 17:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023156;
	bh=I49HwKR5rUMREqmbU1DyIYBV6Sru1uTiyJ9xXkXQAT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=syZa4noV5Gq5ubJF43OJr6HmvkjCDwXdDhDuiH331dj1RyAxVS6NJ8EwGdt6hcJj5
	 yq0iAJi04fmdEpujwOPhRO7zOwDJCxGb427NqP4ngYzcHznNYX7b1NVveiwdlnwdLE
	 uTG/U0cs6z68pqwm6hANMvjJ0tJZdOMwVWsDWj5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunny Luo <sunny.luo@amlogic.com>,
	Xianwei Zhao <xianwei.zhao@amlogic.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0242/2151] spi: amlogic: spisg: Fix the incorrect keep_ss of the last descriptor
Date: Wed, 18 Nov 2026 15:32:57 +0100
Message-ID: <20261118150130.595440802@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Sunny Luo <sunny.luo@amlogic.com>

[ Upstream commit 253dfb1839c6bc357aebe8aac4f1b4dcc20ee322 ]

The driver currently unconditionally clears CFG_KEEP_SS on the last
descriptor, causing the last transfer's cs_change setting to be ignored.

Record the cs_change value of the last SPI transfer and use it to
program CFG_KEEP_SS on the final descriptor. When a null descriptor is
inserted to implement the cs-hold delay, keep CFG_KEEP_SS set on the
preceding transfer descriptor and apply the recorded value to the final
descriptor instead.

This ensures the controller handles chip select correctly for the last
transfer regardless of whether a cs-hold delay is required.

Fixes: cef9991e04ae ("spi: Add Amlogic SPISG driver")
Signed-off-by: Sunny Luo <sunny.luo@amlogic.com>
Signed-off-by: Xianwei Zhao <xianwei.zhao@amlogic.com>
Link: https://patch.msgid.link/20260731-a9-spisg-v3-3-a15da3f70029@amlogic.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-amlogic-spisg.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-amlogic-spisg.c b/drivers/spi/spi-amlogic-spisg.c
index 9e98fcf3d0c12..adeeaa3d058f1 100644
--- a/drivers/spi/spi-amlogic-spisg.c
+++ b/drivers/spi/spi-amlogic-spisg.c
@@ -490,6 +490,7 @@ static int aml_spisg_transfer_one_message(struct spi_controller *ctlr,
 	struct spisg_descriptor_extra *exdescs, *exdesc;
 	dma_addr_t descs_paddr;
 	int desc_num = 1, descs_len;
+	bool last_xfer_keep_ss = false;
 	u32 cs_hold_in_sclk = 0;
 	int ret = -EIO;
 
@@ -530,9 +531,11 @@ static int aml_spisg_transfer_one_message(struct spi_controller *ctlr,
 				spi_delay_to_sclk(xfer->effective_speed_hz, &msg->spi->cs_setup));
 
 		/* calculate cs-hold delay with the last xfer speed */
-		if (list_is_last(&xfer->transfer_list, &msg->transfers))
+		if (list_is_last(&xfer->transfer_list, &msg->transfers)) {
 			cs_hold_in_sclk =
 				spi_delay_to_sclk(xfer->effective_speed_hz, &msg->spi->cs_hold);
+			last_xfer_keep_ss = xfer->cs_change;
+		}
 
 		desc++;
 		exdesc++;
@@ -540,13 +543,17 @@ static int aml_spisg_transfer_one_message(struct spi_controller *ctlr,
 				       xfer->effective_speed_hz);
 	}
 
-	if (cs_hold_in_sclk)
+	if (cs_hold_in_sclk) {
 		/* additional null-descriptor to achieve the cs-hold delay */
 		aml_spisg_setup_null_desc(spisg, desc, cs_hold_in_sclk);
-	else
 		desc--;
+		desc->cfg_bus |= FIELD_PREP(CFG_KEEP_SS, 1);
+		desc++;
+	} else {
+		desc--;
+	}
 
-	desc->cfg_bus |= FIELD_PREP(CFG_KEEP_SS, 0);
+	FIELD_MODIFY(CFG_KEEP_SS, &desc->cfg_bus, last_xfer_keep_ss);
 	desc->cfg_start |= FIELD_PREP(CFG_EOC, 1);
 
 	/* some tolerances */
-- 
2.53.0



