Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061509;
	b=WZhVWKNopqGpCtNVtV05uKLDwMZbUpNcZ7OmF6EQ2KLbn7XM9WlxxezwWpoDGz1lMBvM
	 HYdHbcWuEVoYxu1VvzNEsgg/3QaUlcDWPTdhmmh/3Z8UgnY3KCbj6Jz8MdF0vXdN0y5rZ
	 IiLjAnTVdT1quFnFK1HM4c/BIG22dlTCn1iY5eyRGW3lJ/Mg1L8OCWbsMny3d2TmIjwKM
	 j2KD7u3cPGk7XNrzjkEmkIWHstrGM9ffdvjXaHgukcmwQewy6Bo1Coq86VbrrKBx0YZvI
	 z8bMdxIIRBqjy+mIfMVduRBt3Ft12iMgnN9bydnNpPszVDoXm9b9roR5EA6EZ6cCsOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061509;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sI2EAby65ReDZV11AiO9EOv8b8oB7QcULDprcJi54pU=;
	b=AFhD2in1KJ1B5+G0oNIluYkEUQho7JcL+DEAiYV6uYotniLqCBdufPQ5dOoVVICcTf8O
	 iEKGgPBdLUADwz+oDrZvMql71+h2OOhy3CEup2vEthDYtKmVZo/k2zUKRyUhWNhQbQ5rs
	 vGeSllxsX0tv9e73G/RC1GMV6d+4CPzcTxo1PWYSIadZpm3X9Fboio9oCmcm/blnQj7AL
	 krqQ+35XecHj4GesRj9Fo3YrVP9eyUPPOpT1+YSEezl/ljUtn98RB1gqCpA8572e9BIi/
	 zrxK+KIw02y7fFnV63mZ3Hk8v5QWKC3T4Ey2HS7P36SZQr8mlMvfJGse/72YZgHSQzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I14nx2vL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F69660A2602;
	Thu, 19 Nov 2026 04:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I14nx2vL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CEC1F000C4;
	Thu, 19 Nov 2026 04:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061509;
	bh=sI2EAby65ReDZV11AiO9EOv8b8oB7QcULDprcJi54pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I14nx2vL/0a2u7QMKqVk6Upmn3Z0Af6JvUM0DlfpKG2ZaIvG339do4Go+zXQywSYj
	 kNrgTMMklKR3Nh6d+eeXAxOs7H2/119k7oT8au/Ol7vnOHj/NA0ltjqzz3ZNLo3Nua
	 OmiEH0oPRkcqfmuWHZUZq8WXimOST6/F1d6dZQu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Leonardo Scorcia <l.scorcia@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1578/1848] clocksource/drivers/timer-mediatek: Fix random crash at boot
Date: Wed, 18 Nov 2026 16:00:16 +0100
Message-ID: <20261118150025.645312213@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Leonardo Scorcia <l.scorcia@gmail.com>

[ Upstream commit 8496a1d234e8cf9cb15c4282cb3a11c6550bd242 ]

MediaTek bootloaders generally enable APXGPT timers at boot. This means
that a timer IRQ can sometimes happen between the IRQ line request and the
configuration of the clock event handler. This leads to a hard crash with
an instruction abort, branch to pc 0x0 in mtk_gpt_interrupt handler as
clkevt is null.

To avoid this issue request the IRQ with IRQF_NO_AUTOEN and enable it
explicitly after the clock event is configured.

Issue was reported and fix tested on the Lenovo Tab E7 (TB-7104F, mt8167).

Fixes: a0858f937960 ("clocksource/drivers/timer-mediatek: Convert the driver to timer-of")
Signed-off-by: Luca Leonardo Scorcia <l.scorcia@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20261002072115.169250-2-l.scorcia@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-mediatek.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-mediatek.c b/drivers/clocksource/timer-mediatek.c
index 9318edcd89635..f05c26a64b72b 100644
--- a/drivers/clocksource/timer-mediatek.c
+++ b/drivers/clocksource/timer-mediatek.c
@@ -251,7 +251,7 @@ static struct timer_of to = {
 	},
 
 	.of_irq = {
-		.flags = IRQF_TIMER | IRQF_IRQPOLL,
+		.flags = IRQF_TIMER | IRQF_IRQPOLL | IRQF_NO_AUTOEN,
 	},
 };
 
@@ -272,6 +272,7 @@ static int __init mtk_syst_init(struct device_node *node)
 
 	clockevents_config_and_register(&to.clkevt, timer_of_rate(&to),
 					TIMER_SYNC_TICKS, 0xffffffff);
+	enable_irq(timer_of_irq(&to));
 
 	return 0;
 }
@@ -306,6 +307,7 @@ static int __init mtk_gpt_init(struct device_node *node)
 					TIMER_SYNC_TICKS, 0xffffffff);
 
 	mtk_gpt_enable_irq(&to, TIMER_CLK_EVT);
+	enable_irq(timer_of_irq(&to));
 
 	return 0;
 }
-- 
2.53.0



