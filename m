Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033951;
	b=Dh565lNpI603gzaYW0BD9J08WJN/N1ZYisu08zNQyZbLV+tQV5IJPWXCcQK5yPDrIHWL
	 iZHdo+oa3EI/LwgWc/zjDK2zC4pii3IdHnhau2UMHoTfRw/yHYFfJmHfzJmuqPsocve7U
	 cq30vZ86odgmIHm7VnBQFhNqIRDZKCtTmmF30v37PQdHXnPkcdtJ+LwRpGjIMpK4HAHFz
	 q0+lklUXGsecIgIlDzD61DlJThmPnSnnf1RivZeWr55jV7StfLu0nwP7JxrTC9/pn2Qy+
	 6dQKEn1U+N2ArEtV4G5g925G8DFhc+90Fgq0H5DoFRSVYzNr6ohZTpi8bhth9zm4/IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033951;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SYexDvEvckm5Myw2TYIhKY1KzENG9rqsQS4AT4R76zk=;
	b=Jp/JO4ueCnySUIpmcJVaQOVAqcgXk7gzU02a05qrI/2i8aoxB2YBkyHyte9iLitNx4Hx
	 xrlkMo81bjvWX78DUp92rhgTK1Zsgkli0WRQwF3UoY+CDlgVqEcnX+6wJdhsDKDJNjl8r
	 aZjX/lB0uqfiZWZlhhZ4WtwCE2Z9M35MNPAdoaVAwTZx/Yw0t6UUmS3nBKHLlN7dmbaAk
	 lRE0g62gXTXJTIXFo+XL2sxkrhC1vvyMizM55V3DIpsvhBWUhnhByYjwEyMjEZk7HBB/a
	 Pzz70uQDw+TWUZzooySFFSRuzTDxVts/KRWNgm4Zh1EHXvnFB2pfvQ9PC8fPzY0xWYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SaJdibC2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5B9606A325;
	Wed, 18 Nov 2026 20:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SaJdibC2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77FC1F000C4;
	Wed, 18 Nov 2026 20:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033951;
	bh=SYexDvEvckm5Myw2TYIhKY1KzENG9rqsQS4AT4R76zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SaJdibC2K8pQVnwBVQ8rQ/XO7Hp8TzPRsxHYLOgn3nwa0SEYuGsmZXfdu4u+CRQba
	 gVkG31nxXgXNZg/gDll9kFyTYMQhNzo93NZ78Xzi9jf7fORNtqgG2Ud9pF6S8rszHL
	 P9+Mivq0FLhQyryyF1YHWBmiCzpoEOwtqLhQF1HQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Proshkin <oleg.pro171@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0196/3318] mfd: axp20x: Preserve other control bits when powering off
Date: Wed, 18 Nov 2026 15:13:38 +0100
Message-ID: <20261118150320.711125912@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Proshkin <oleg.pro171@gmail.com>

[ Upstream commit 3756bf05c963563f1325af105356541882dd5899 ]

axp20x_power_off() triggers shutdown by writing AXP20X_OFF (BIT(7)) to
the power-off control register with regmap_write(), which rewrites the
whole register and clears other control bits in it.

On the AXP221/AXP223 (and the register-compatible AXP228) - that
register also holds the CHGLED auto-control bit.
Clearing it during an orderly shutdown disables the hardware charge
indicator, so the charge LED stays dark while the board is powered off
and charging. Other variants keep unrelated configuration in the same
register too.

Set only the power-off bit with regmap_set_bits() and leave the rest of
the register untouched. The shutdown register is readable on every
variant, so the read-modify-write should be safe.

Tested on a ClockworkPi uConsole (Raspberry Pi Compute Module 4, AXP228,
which enumerates as AXP221): register AXP20X_OFF_CTRL reads 0x08 at
runtime, so the old code left it 0x80 whereas setting only BIT(7)
leaves 0x88. Writing 0x88 at power-off enables the charge LED
while still powering off the PMIC.

Signed-off-by: Oleg Proshkin <oleg.pro171@gmail.com>
Reviewed-by: Chen-Yu Tsai <wens@kernel.org>
Link: https://patch.msgid.link/20260611154629.76607-1-oleg.pro171@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/axp20x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
index 2b85da0fcf27e..1f4c4a0ee2c01 100644
--- a/drivers/mfd/axp20x.c
+++ b/drivers/mfd/axp20x.c
@@ -1121,7 +1121,7 @@ static int axp20x_power_off(struct sys_off_data *data)
 		break;
 	}
 
-	regmap_write(axp20x->regmap, shutdown_reg, AXP20X_OFF);
+	regmap_set_bits(axp20x->regmap, shutdown_reg, AXP20X_OFF);
 
 	/* Give capacitors etc. time to drain to avoid kernel panic msg. */
 	mdelay(500);
-- 
2.53.0



