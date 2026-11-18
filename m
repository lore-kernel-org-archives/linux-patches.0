Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029568;
	b=4nRtyAwLe0jAHcK96Jhqjc3QTcdfjRy0B4SxK/zLCu4VbVVh+fTGu25Vmk4xQ0lnwRGT
	 3kQ5cT5cpfYSnvU5UuzI6gFkvvvuUuvNaZrnWlOgm3h5raibgdcu0bEIMd+deKdO/rWjk
	 2HUnguSNvfgU9pxshcMYyQ1/K50wGFuwqXCyRAr74pdiGpxVkf0wrm66ue5Ehxp0S340v
	 wBzDQVY/RMsnFOk4E4BE87eJbaac2oN+Y4XG+JH426RXiupSo+pWYeiwtRd/v4eyxq+yi
	 EBSYEo7QQFgRGpfW2dHh55uXsICJB2UTnPa0PNenbLT1/y1NTlycuy9eykubrQDKv7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2w0ddlQGE0mDESmDCFIQ4UuoDSh4s1wf6mUk6ewflHw=;
	b=VzU/82XEam094M4yKdeXcMevjaFq2ocymH6QosBX+KrPKbdXWaPQDCitBMZniI6sZ1iw
	 ld672HM6K6FhAfix6R7eAOospN5oRGBg7E2FVY3PflS0iyuipS4SUcReNYOIpWsgNIFHK
	 jhI0cXP+LDl+cXL32KN/UTV+4RLuT5YTaZPW9AENztEwHRTq9DNgITBAu5p430WeWf6HN
	 Tu1rzRztQN/SKuF0rL6o93nySKpEkOfHmuU7RWBDNkU+zh3UZKi6OrbLyYhltp0wIxzAZ
	 0BfCy072fLpWQX8MaWzBQoSDMlKexLML4b+oLrY2KIzqQnLR0Okr4ESplYSdxIoHYeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="bMg/Ib4+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688BC606A31C;
	Wed, 18 Nov 2026 19:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bMg/Ib4+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680201F000C4;
	Wed, 18 Nov 2026 19:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029567;
	bh=2w0ddlQGE0mDESmDCFIQ4UuoDSh4s1wf6mUk6ewflHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bMg/Ib4+P7XbyXMXjhD/eswr0ItqVl4Hz94Bwa+So7i7Hi1Xch/3mxneSdWGdKPcw
	 ivQ1JEJ3RTNeLQVLcyPkI7O5/TPLomgtuBUyynzHr6N/htZvMbbwOmCbWyv9q2mLaW
	 Tfm3giSNHX+urEPPC/4K9+yjP9cvQAi2PvuNzxaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0396/1756] pinctrl: amd: Add PM debugging message for turning on/off wakes
Date: Wed, 18 Nov 2026 15:42:03 +0100
Message-ID: <20261118150024.526951432@linuxfoundation.org>
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
index 669a063a31688..d48b9ec6ad7c9 100644
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



