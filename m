Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060871;
	b=bdqvWqylnt8jZsraTzlvSMwWg9/EQm0vhVZy3v4CyYY/BnRMKnM6TlLsfFaokGz15SeC
	 Q+4C4PuwzQUHA04WOyk87nsdtVKED7bou9GDQJLM4n9fJQ4+YtbgJg3EYSm8MC9IGzfJ4
	 0DQbJAbrY/qxjZdWccFe3NiV/NoIlRLim+cZW6kZtbopbyi3Mak9K2YcTCyBuMcx4MOyK
	 p0huLPIeeQLImqSyxnAIcWtqkuO+OgPEis51TMTo//gFS8AkHDmcO+b+ma2pUZAgeCbPX
	 BXdM1Pop7lKVTFet3SOFuVX85XWnxWNAcX+8rKSSLupe/W2DjtPaJ51vzMDax4cE9YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q211pM+T/Wp7yiUXex//YzomiXBqT98yYlUgjVplJqk=;
	b=qYnS0p47NrCLMDZSJh8XZgisDMY01uCzhqtqHphQdxyNgCZpQJvAbDGqi3yEzkuWK+WS
	 x3iS5DDznxeovQ4Mp2J7Gz9+mJ8ZtYb2/GG1c5aWMlKGcG6P7wPbWtd5Ks5eTIsU0Vb4f
	 WeUnmUbEfT+d262+bK0O5jM7nec6R/JRSo7oq9MSiL7xpsvpF0D+5u7VfeTX8wcKsNalN
	 dpGVXXTHxFeoaV4QN96q4FJJlGdF2l1iC10oYuQVhRIAC2/hNilNTkNHC6DoavWultts8
	 U0vYtGPgTwcpgJcvRHP7TLPUvKA5iAZtkByxapyuK8LXqV8f3SisvQM9BkkMAbXzjzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P62aj1iM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB91E606A33C;
	Sat,  7 Nov 2026 14:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P62aj1iM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6AC1F008A1;
	Sat,  7 Nov 2026 14:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060870;
	bh=q211pM+T/Wp7yiUXex//YzomiXBqT98yYlUgjVplJqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P62aj1iMdrZ2Bj73YNA858Ib45LIldSG6P6fpdA23yJFRWnME395tzXzDu7n0zTUS
	 3+T1AVTklZJKan1UOK5GDYvUy3ev5PGja7Yn2ZiAA7vR938u8a9zKYJpiH5+boFOWd
	 2dr99lQ7O7+D7wMQRzs8EG+HBFK6aZv4gLlCSrXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomer Maimon <tmaimon77@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0212/1536] pinctrl: npcm8xx: fix debounce register selection
Date: Sat,  7 Nov 2026 08:37:08 -0500
Message-ID: <20261107135003.610944543@linuxfoundation.org>
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

[ Upstream commit 602ee6c9447e4382c7e145b26a1c940813f2a144 ]

Each DBNCS register programs debounce source selection for 16 GPIOs.
The current offset calculation advances the register address every four
GPIOs, so offsets 4-15 and 20-31 end up touching the wrong selector
register.

Advance the DBNCS offset per 16 GPIOs so each line uses the debounce
selector bank that matches the hardware layout.

Signed-off-by: Tomer Maimon <tmaimon77@gmail.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c b/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
index 3c030a1b44b57..3eb9e32f46726 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
@@ -2155,7 +2155,8 @@ static const struct pinmux_ops npcm8xx_pinmux_ops = {
 static int debounce_timing_setting(struct npcm8xx_gpio *bank, u32 gpio,
 				   u32 nanosecs)
 {
-	void __iomem *DBNCS_offset = bank->base + NPCM8XX_GP_N_DBNCS0 + (gpio / 4);
+	void __iomem *DBNCS_offset = bank->base + NPCM8XX_GP_N_DBNCS0 +
+				     (gpio / 16) * 4;
 	int gpio_debounce = (gpio % 16) * 2, debounce_select, i;
 	u32 dbncp_val, dbncp_val_mod;
 
-- 
2.53.0



