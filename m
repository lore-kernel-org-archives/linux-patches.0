Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774393;
	b=V0YBNMifZ98oYiL0whUVql4TeBir7daw28RbPJoIhzGqw5SnyiCjgM45mw+wRFGIj/NB
	 pMSPIiMU3+yFVF6/DEebpnoe/QBeuEzK/hk3CkhGNRFN4XH3L+pLXk1kRc7edT66EuRWq
	 kX3Vd9IqOlVSRSq0zqx8MJTxd1Lnl4JO445xIClc0ug27l9DRq4DbD/IIQXMR8EtlxwPe
	 F/QqrE8vedlQ5pYWUqGgepcqlvqNuucazv2ClycXg43rPABdgDYI/tUuR3Ir8ZMLhTdD2
	 8wwX+4+K/yqrHmoJQzAOkbFllq4qchEP5EcFjqKWTMLx+XyBzSUlBz1yYm6rUWSzg/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774393;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tAhczci+xZ3DrZtrooc4j+QxRHSWXp8F8T069xsZaaU=;
	b=fX8SznbTuL9dIuA3xWLdk+tx3LCCJWBmN5u3y9HBI6gezeYhswylVRBB4GXHEHJku0xd
	 bsrTb1ejTjkdNe5WwG3nbt+5TnlTVth6iggL4TPCCvPKdioFL4/j6X+xLA1VHGsR7zndC
	 DQm0bEshxKEz69S4GyIOOvdqxSz4kOyvzSTFY9PFC+7M5vSGSDMzd9OnkyM4w+hxwfHxG
	 0iiN3rtDyqDTT5byk/YVaiheX6G1TmSkTEqZUuMw2a2lyQx3XolckVhDdivnuycwrRPr2
	 Zqj72Qft/gvcvHoK+vzCZjzyYvWt2ReHs1Rf6YDgqiEsFKrp+uqb/W6oehOhEdO5EzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=av5SyBQx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91F2606A31F;
	Fri, 23 Oct 2026 16:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=av5SyBQx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7B81F01825;
	Fri, 23 Oct 2026 16:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774392;
	bh=tAhczci+xZ3DrZtrooc4j+QxRHSWXp8F8T069xsZaaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=av5SyBQxARGmcgASOxEdF6Z9viHdHD7j9beMF4oxfXnyiz2+KUBgQArJDU1GuJtQR
	 I71qDUeNa+EXjSzbyXHKtuKElSrKh20+I0DRWa/ERgR7yMmDajwjsipS4ZOQ4mKHEK
	 uNzLcH98P311M4OufHyPbmvaBAJcpatFmv9PCutY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Mazzini <pmazzini@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 025/242] pinctrl: sunxi: dt: do not accumulate npins across probe attempts
Date: Fri, 23 Oct 2026 18:37:47 +0200
Message-ID: <20261023163714.378225811@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Mazzini <pmazzini@gmail.com>

[ Upstream commit c5895eadf287116434b7b01d67b92e8146f7ff61 ]

init_pins_table() adds to npins in the driver's static descriptor, so
after a probe deferral the count doubles and the next probe fails with
"pin 0 already registered". Reset it first.

Signed-off-by: Pablo Mazzini <pmazzini@gmail.com>
Fixes: f5e2cd34b12f ("pinctrl: sunxi: allow reading mux values from DT")
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sunxi/pinctrl-sunxi-dt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi-dt.c b/drivers/pinctrl/sunxi/pinctrl-sunxi-dt.c
index 50a16f3bd1316..8bcd566593ae8 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi-dt.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi-dt.c
@@ -84,6 +84,7 @@ static struct sunxi_desc_pin *init_pins_table(struct device *dev,
 	 * Find the total number of pins.
 	 * Also work out how much memory we need to store all the pin names.
 	 */
+	desc->npins = 0;
 	for (i = 0; i < SUNXI_PINCTRL_MAX_BANKS; i++) {
 		desc->npins += pins_per_bank[i];
 		if (pins_per_bank[i] < 10) {
-- 
2.53.0



