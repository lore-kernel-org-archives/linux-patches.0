Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015582;
	b=C+/44s0ZauDA14ClI+b+/97yC5L0YiYxuArM5YGpQPtCpyfRYahPwPlUWmSGS0kGBOzW
	 cxYb11e7RcbcCsx5RZkqW5YBMQohf8IFL7t750vTGZQw/RhyokfgSP9d/2DqK1nuL3q3/
	 OBk+rpArdfWyhYL7WhMtcJqI4Xi2U7HkjMGuRYF8QZwsUyjdFyR8Ytmo/dzbfWgE7czIW
	 dN1RIiHVCBFUKfzT1qIgsPf56Eb4CUBXUnEhRVyUm+ALiKlr2nsqdOauyOhB8zGsHQbNQ
	 TYf4ryOJVRC//UhTNjwWAvT/EujhZxz8kHMpYhoiIJL5MDsfW4f41MkaOvAPm8OfoCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015582;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y2dxdMhVS4X5gYcJQiIf+OuB9ar7VI7IzIOGe/fq3Os=;
	b=ep12xm6PQ77pJo4HCYSLmZPKIU7t7IPzsadPS8OmWwdDZSbi/BnGtK6WmrgWIC5Ll2LH
	 67/O8dNuwzP74cTVOiFEDkXgh5w3OW/8n9AYu4YvUrvAqoEof27yzoO5kEqYcsi+LNSoa
	 d3cnK/dDmEXNsfizGBcugDC4mIzx1uspFQSDEXhQyyKbMciHdZfjnt9/kW5/AEN8jCe+y
	 IUk/os7DX8dgmSS+TS6A2SEurTMnYtQqT8JpcZVkykShoFkUhTnrp5dIAhq8GOwvcOBUN
	 9EkwpISPB+jr+UNuHnVPAI2lXc1Z7pjWoXWu+JyalJuJQC0d3WlhIndJoKCl6CP5pJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uWuX7pIM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F596606A31C;
	Wed, 18 Nov 2026 15:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uWuX7pIM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50681F000C4;
	Wed, 18 Nov 2026 15:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015582;
	bh=Y2dxdMhVS4X5gYcJQiIf+OuB9ar7VI7IzIOGe/fq3Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uWuX7pIMdgGTLiBTL7BNkfYz1COyD/Qkvu9COsKR1mhiqnuxBKyeKU629utvge9Gt
	 BijoH4xFXvovQ0RdmyIUkoebsc3wluhFU3HbwKCVAcxC/6trwlU8A65BaLAq9SJ+PD
	 1IXoA4I3IIAIun0j+4U3HG6aitNKzp0yF+P164hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunny Luo <sunny.luo@amlogic.com>,
	Xianwei Zhao <xianwei.zhao@amlogic.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0225/2651] spi: amlogic: spisg: Fix the incorrect keep_ss of the last descriptor
Date: Wed, 18 Nov 2026 15:24:25 +0100
Message-ID: <20261118150255.967840274@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 58dc6fedd8bc3..6bca2379e4ee3 100644
--- a/drivers/spi/spi-amlogic-spisg.c
+++ b/drivers/spi/spi-amlogic-spisg.c
@@ -489,6 +489,7 @@ static int aml_spisg_transfer_one_message(struct spi_controller *ctlr,
 	struct spisg_descriptor_extra *exdescs, *exdesc;
 	dma_addr_t descs_paddr;
 	int desc_num = 1, descs_len;
+	bool last_xfer_keep_ss = false;
 	u32 cs_hold_in_sclk = 0;
 	int ret = -EIO;
 
@@ -529,9 +530,11 @@ static int aml_spisg_transfer_one_message(struct spi_controller *ctlr,
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
@@ -539,13 +542,17 @@ static int aml_spisg_transfer_one_message(struct spi_controller *ctlr,
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



