Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829641;
	b=NLzOwtw98ENOeB0Ghg77k6Y+qMjSlAQHckOyAu0fL52qMpKHKJ46hObluTwWnrExjDZF
	 0CADAwdNU8ZKZPTKW9yQ1oOMu9GjXTk35iddOvImxr9imK6rc8rwkpBnxfMCOQokhCS9/
	 NIuOeGPkkmM16+hZHyK5ek397v/eJ5Rw+fkVjqOsjWMQ0THFhNwmptTHNGE+vGDQ8QtGG
	 H0R4kRZ5PpfUGOzmygK+AeYInQUQjLUEYn4p7Z5O9ekQdxO4wesIHLjsmlnl3v8UVs8qk
	 fapG8cWTE3U3bTfOuCM9XqD3XB8NTsTQHyc0LNBQXlw5ju6Xz5jx6v8sDwUD6na9GAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829641;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OUvQ247wn3aLs8aN0Am95+kTxCBPrgpDz5b7OUuU/5o=;
	b=0MpUNz7dFPLZekugzX9hIWU989CIlmf0Ob3DjXXhpMKQf/aUk48nqycNS9lR4B/NSLX8
	 dEPVXE6lbZhe4RoBeN9R5WhO6DhBXAcAOaW9CxtkuiClJI5zBpQ3HY+Lx5c4SQ4qzti8g
	 +terCgLHBXzD5QeJ6lgnJ8hDhAt067aB9MI+zPM2J3srKOfTsitHljwRULiK8itbXZ7Nd
	 bqRKBoGWO681VsSesl2/osuXFYewhsyxIsJxAqKeJlBQaJcNQ8Yr+W+EuAIwuVOusI3fY
	 dc2T2bVeLDk9X/9FnhG+gf+Dr/YX81D0RnAu0PY2gSG6iaxO2QPdMClFKffcJQAg+nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j4aYudax;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C217C606AC27;
	Wed,  4 Nov 2026 22:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j4aYudax
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2531F00A02;
	Wed,  4 Nov 2026 22:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829640;
	bh=OUvQ247wn3aLs8aN0Am95+kTxCBPrgpDz5b7OUuU/5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j4aYudaxY4z9D01qwo6SthUF+w1BjY2oc+zjwqiDk5egdBTEj/eYRqB3zVtBcJ/I/
	 MLoulUQGM9UwAhDsymA/2BL+VtWM6J7whi+M6RzOUNkR6Y2GSK2J1cPETRE9VAG9z5
	 qUKPpOkm6qJ862LawwjGmSKXv/akhM42xgVlL1Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomer Maimon <tmaimon77@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0250/1005] pinctrl: npcm8xx: fix debounce register selection
Date: Wed,  4 Nov 2026 15:59:43 -0500
Message-ID: <20261104211050.861517086@linuxfoundation.org>
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
index 22cc87d43ea69..28464463ff833 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
@@ -2135,7 +2135,8 @@ static const struct pinmux_ops npcm8xx_pinmux_ops = {
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



