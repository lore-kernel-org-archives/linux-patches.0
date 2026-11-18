Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029776;
	b=B4Gnfj9MMzVtq+cP3e7Dwq0nATveMmAtrdQ6wSMFTX+CcuzzS5Nyh4Kl220pO+E1KvQq
	 JjX7UlAGMAdVjpygcD8cOu8KtpL7F4HRYusCPQPPMka3ed5SaV+4A4fCHMBvz67Ce4uTr
	 9+dx74eEzBTJawWdpEOtCo5kMVE2Oz3r+dzORZyBWY+7OhIwvx5TgTH3bjp9tVqRPiQjG
	 i4C8CACPtPdHWFelcMEUr/3VXYNRAbVMpBoSFN9A5MOGE4Ix9bjipWMlPvJ7gcEJ7wWLW
	 uwxXaez/rz0JUp3q4+ppA1RwpJrI16zvCgxU064Pu2jpU3qCprMwCqfDKB7g6resHbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fURSXuVnutP7LaG0HMszVxOKuYxk4Q93DieIYrJ/AQ4=;
	b=whuqXlr+QFwXPu21KTM3by8tKl/0reT7SuCN+qcyraLRFlqvEoboN77M1htuP8j0sUeF
	 AFAmpm0qaMjbPz2XqSIDXxYOt8wyBP7LAzZDxq0G3AQYD3WN7xKcBykhFh4FzbWTAG3JY
	 9zIvpL1zAYb5/Jty9Rw7yvtVE4CTglMRoKyEkBE+or4iinndngAxwiNaCWEgSrm94x8Zt
	 VkFnhtKUxHbzMenpIP1hajY7GNk3d+ZEnoxiJGVWhwi9IMvRHyjHGbeW6AOPEFKtE2Yul
	 H2dBtQ5H++mpCddmhMv0XT0lL6oOo9Gqk8vUQ407D7Aj2cu7L6aV315tima213yH7Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QKIHAdqT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83008606A31C;
	Wed, 18 Nov 2026 19:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QKIHAdqT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7781F000C4;
	Wed, 18 Nov 2026 19:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029776;
	bh=fURSXuVnutP7LaG0HMszVxOKuYxk4Q93DieIYrJ/AQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QKIHAdqTBS8E4o7zzVeCy7deWHF07r7ScH7RfLqMSDdQa8g4MEr82yNq66HokVifB
	 axA5DXMNhUpXPmEzPdj3QGaNuW+W97qC9SpKe1xqokx1xsaHp/dq1haG5OIOrDCjeA
	 5sIxbPZmccAEkuGOJNsmZFZgDSpLX7o4u4BNKM7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0428/1756] pinctrl: stm32: Declare stm32_pmx_get_mode() as static
Date: Wed, 18 Nov 2026 15:42:35 +0100
Message-ID: <20261118150025.797558347@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 79aff59b54f72..05df641874a92 100644
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
@@ -795,8 +797,7 @@ static int stm32_pmx_set_mode(struct stm32_gpio_bank *bank,
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



