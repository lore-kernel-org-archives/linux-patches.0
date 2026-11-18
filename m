Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039815;
	b=jvBUJrMO+3m0c5AIcR8PgJY2OdSqX1x/gNByEJ9d9QQCUPCGz8zJG0RM23SY3aBM5RDZ
	 g7wiW9cV3ajZWFRzSV9f1RR3hL5v772FzqBrSG4YaKERIboaVKuIiG0RTYPJF4PtUccfN
	 o5nUCyriAQ2ASFWMn/FH53+2XyVD1vfym+YihClvcynKH4QlhvtOaUPWcmeZPm39DMyQg
	 xSfMxYhzbXdAQYR6b878aLG+HXmGrAdhTv8w7b23mfIP94RJY4bBTgO87WjUcCHnoCmEC
	 xtHog4JN9S89Yn2TnYbTWPSlyroW+K+efbs5vZiTfEAKEu2dYScHwSn7XatzisbhxJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039815;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qiQr79TQQPrt+IgH73Cmp+ZALho881eris5NoetJeyM=;
	b=K3T6CO+pyLF98J33mwYBGbE76JwK8YuBR+XWXLVTtM2c0Y5sv1U7vD9/CuSlqcjflF3H
	 /YceDjqpsGIt8zntE0HqJetx/ap65Tj5Y/48LZGIfutxytj+1DIvNpiGlgmKhozUMVLsu
	 1TozCQWArvzlnzdsZmPZ5FL9jAdUy9UfXGxxKZJZXzqk4C9YbEX9X8q8vfK7Z2OeopeJv
	 PdeU6daQWN/fmTRIax+R+bigPcrK3eVbrWT3Hk8Lr76NtGCzehuALZgUvDBKYWdNI5bxh
	 xsfj4vDAi0cWqLElEAqTr4VdK1n3LB3Fz1yJfhblbQmalfND4Irus2PKWjSJ+rL6HMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tzecYPn4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3653E606A31C;
	Wed, 18 Nov 2026 22:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tzecYPn4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFAA1F000C4;
	Wed, 18 Nov 2026 22:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039815;
	bh=qiQr79TQQPrt+IgH73Cmp+ZALho881eris5NoetJeyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tzecYPn4H5ROotNiPxS5Aw+4+EG3Iky2l/K4eBDcAuRzV9Lhj+r73q5lgbX4//VfJ
	 vvVLIJ72rSKYDwdnlXH7LMopK9Ug0Hh31lOzX+EPgiZUXielQS3xsM/F2tdfaIPOO3
	 4rQvh1I5Xt9AdP+y/uTRCP/SixFnHivIT3f8FwQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2236/3318] pinctrl: stm32: Declare stm32_pmx_get_mode() as static
Date: Wed, 18 Nov 2026 15:47:38 +0100
Message-ID: <20261118150428.943163114@linuxfoundation.org>
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

From: Antonio Borneo <antonio.borneo@foss.st.com>

[ Upstream commit 9b71efc450fdd2f70d59917025da34f8b0e81135 ]

The commit acaa037970f6 ("pinctrl: stm32: Implement .get_direction
gpio_chip callback") exported the function stm32_pmx_get_mode()
and the struct stm32_gpio_bank, but these were never used outside
the file that defines them.

Declare the function as static, drop it from the include file and
drop also the struct, not anymore visible outside the file.

Signed-off-by: Antonio Borneo <antonio.borneo@foss.st.com>
Link: https://lore.kernel.org/20250610143042.295376-2-antonio.borneo@foss.st.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: 01f20711d044 ("pinctrl: stm32: Drop the nonexistent CONFIG_MACH_STM32MP25 from the STM32MP257 default")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 5 +++--
 drivers/pinctrl/stm32/pinctrl-stm32.h | 4 ----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index eace8153c4ab0..df7003ff10123 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -121,6 +121,8 @@ struct stm32_pinctrl {
 	spinlock_t irqmux_lock;
 };
 
+static void stm32_pmx_get_mode(struct stm32_gpio_bank *bank, int pin, u32 *mode, u32 *alt);
+
 static inline int stm32_gpio_pin(int gpio)
 {
 	return gpio % STM32_GPIO_PINS_PER_BANK;
@@ -808,8 +810,7 @@ static int stm32_pmx_set_mode(struct stm32_gpio_bank *bank,
 	return err;
 }
 
-void stm32_pmx_get_mode(struct stm32_gpio_bank *bank, int pin, u32 *mode,
-			u32 *alt)
+static void stm32_pmx_get_mode(struct stm32_gpio_bank *bank, int pin, u32 *mode, u32 *alt)
 {
 	u32 val;
 	int alt_shift = (pin % 8) * 4;
diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.h b/drivers/pinctrl/stm32/pinctrl-stm32.h
index 5e5de92ddd58c..8790fef2d58a2 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.h
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.h
@@ -65,11 +65,7 @@ struct stm32_pinctrl_match_data {
 	bool secure_control;
 };
 
-struct stm32_gpio_bank;
-
 int stm32_pctl_probe(struct platform_device *pdev);
-void stm32_pmx_get_mode(struct stm32_gpio_bank *bank,
-			int pin, u32 *mode, u32 *alt);
 int stm32_pinctrl_suspend(struct device *dev);
 int stm32_pinctrl_resume(struct device *dev);
 
-- 
2.53.0



