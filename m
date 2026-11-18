Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039740;
	b=nVSUK6rpUybzD3pT7pVw9DCLc0wtJpsIguHhhRa9K6WgSma/xXV3/MiRXMYqVUE8hztT
	 RNK/zmNlAk3g0EwfRCcSWLNm5yBSqdP805hh27ZvoNovLv7CGg85k+sgQDnBO2G8CQKK/
	 W+fXXXWf4Ze6Ozqlf/Cm9aGVSzxS0ujcV926KcUbZQmg+kMMH8JFJjmpiL/fYpvL2m8L5
	 kuAQey7AScElCYemt4xAdbaXbYS8bp3ups9I8MrMrsstOZxRNk2zyAB6D2vs7rQkvme3v
	 3y5KigVQfmkTjyu3cTmAA/Loq94CNsRJrMIOCkpgyzDfzmF2MsMHYtcLuLo4p64x8WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039740;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LBZdQDxE/q0QyjA6EEUo329SeEebspJjqKI3edJtpLE=;
	b=d1KS6scoTInpfugdQt6vIdfTwVIg6W3zov69fXKgWwUmClzGt2MvCe+Hp8FsDH9XLE/4
	 LKx395ed+rNQ7Mjyq5/+XKqIIFQ+9nDlMHIEzy2lx07SvMblycQ6+loyWXyIyOQdjTkgI
	 JX4FAOURh4PByH9zB7RI7LDSjHVlOWXIST+/xsQE7nJL0Wv5UFjiMK1K3XbRS+KiUGLg2
	 4D42KNtbUpKfsG1f8DF/YKhXjzNbslsHSGYbpQIG4exWTtzYl2zaCbaqcI29+MXsB8qjY
	 a/+/uoZOPKx1jQeuZrt4hxkE5PiigAOErel7A7smCCoMZzYQFzX6mW12PEG4SE20i5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AJNWg80J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31415606A31C;
	Wed, 18 Nov 2026 22:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AJNWg80J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874FD1F000C4;
	Wed, 18 Nov 2026 22:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039740;
	bh=LBZdQDxE/q0QyjA6EEUo329SeEebspJjqKI3edJtpLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJNWg80JbBDSIXpnwEXSHhFzm3O10qFCGGjv5D+BLTkeZTvVkuYAsWPkK/7FeOKwU
	 N1I1TNIbgwUJCizD+R7ZG0NUa9lSl0X4aYu7/p0BSX4sAlLlRkbPacCy/CY30LUXIx
	 6P3/lFy2AiVV4u4lN7hgFCGHEG4jQaItvgzfzdVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2208/3318] pinctrl: amd: Add PM debugging message for turning on/off wakes
Date: Wed, 18 Nov 2026 15:47:10 +0100
Message-ID: <20261118150428.159957491@linuxfoundation.org>
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

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit 54b962fa14dc82a625436fcbcee7b3f2067a4f6d ]

The GPIOs for devices not in _AEI/_EVT such as touchpad or touchscreen
won't have wakeup turned on until the suspend sequence starts.

Due to code in amd_gpio_suspend_hibernate_common() masking the interrupt
can make this difficult to follow what's going on.  Add an explicit
debugging message to tell when that was turned on/off.

Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://lore.kernel.org/20250814183430.3887973-2-superm1@kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: 44c232e80adc ("pinctrl: amd: add timeout to irq-enable readback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-amd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index 64dc6b1a1c7e4..3d0ea327c3e60 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -440,6 +440,9 @@ static int amd_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
 	u32 wake_mask = BIT(WAKE_CNTRL_OFF_S0I3) | BIT(WAKE_CNTRL_OFF_S3);
 	int err;
 
+	pm_pr_dbg("Setting wake for GPIO %lu to %s\n",
+		   d->hwirq, str_enable_disable(on));
+
 	raw_spin_lock_irqsave(&gpio_dev->lock, flags);
 	pin_reg = readl(gpio_dev->base + (d->hwirq)*4);
 
-- 
2.53.0



