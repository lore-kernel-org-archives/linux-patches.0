Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019859;
	b=T4qW7/goxsSytfP/QL9Miz3JWW29c/yA68VK/Z9V+eYqjffnBMi2Cc6TeeuNGgoK6e9G
	 83mfB/LKQ0I4xV3rBFonQEFyhipH0+jzOkGvKzAknvVuQbbQp2tACqyx2ZelEITSreuPd
	 v08IasZW5wWiNebCEcTYviMd+GLSc6A0Hm9DqkamDh6dWhHvzjFPfi8kipW3ebTqYeAx/
	 TU5q3gBe05/Af6QlmZ0Nib9ND5AFyg3mJkwScj+XT7AWOM9K4kRlwFjk2Vjw2Fh9dhFEp
	 7RqD45Ju7RikoA1Vbw7xh6JeXuyDl5z6gmMRXb/b2MlihdRBiYujpa48AWu3FXwcLYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019859;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AwiLR/UpSOQNVAhO0C+hgSFu7vVgyGcVN4h/IIaDRvU=;
	b=L7XzHtl1byDS1ZHPE+RZLK9DjvPKDj6f44AZyxG+/yIWvqmAvjvBfnfor9BNKS0PxGi5
	 N8jHYm8tjh1k0KMrbvUgvGTYyr13PMrmfU1TApdUqwiS0KX6Abua9g5uy6J0nG2fTZQfk
	 IWh8yjjcAAhGTjSY9QPKM/MseRDmlXR0yDkUFsw2EgezZSP0HEBMnaXvMNfaQs8wPNwSa
	 k4ZtZ29aXSs7r/JlOtNXRqRNH+af64gao1iNmwpqHr54yRNTYj8UXZ7vW6I9FYTlROZte
	 PhtSykSH3g8z9FOE0d4pWR4Kx7w2vASYc1SJ2LpzQ1Un3+yDbDgdIyduS80cT2JnsiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cm9Ov8WN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C885E606A32A;
	Wed, 18 Nov 2026 16:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cm9Ov8WN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4FA1F000CB;
	Wed, 18 Nov 2026 16:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019859;
	bh=AwiLR/UpSOQNVAhO0C+hgSFu7vVgyGcVN4h/IIaDRvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cm9Ov8WNl06EaIXES+csLwLrRNPXOh/xoIogYGb6dtZ8vzk6qFYmQUYe4OY728s34
	 e2Ef38bHoXG3zS3MoFMlg9ToC3rpGwsx8W2II8O1I+xxLSR1kTh/erxIc6CylicMJm
	 HdAYJQV2tpAyg2M8XsBD2fmUwllEaIDma+wB4VTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Leonardo Scorcia <l.scorcia@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1705/2651] clocksource/drivers/timer-mediatek: Fix random crash at boot
Date: Wed, 18 Nov 2026 15:49:05 +0100
Message-ID: <20261118150349.026948564@linuxfoundation.org>
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
index 7bcb4a3f26fb0..e20075b09fab0 100644
--- a/drivers/clocksource/timer-mediatek.c
+++ b/drivers/clocksource/timer-mediatek.c
@@ -277,7 +277,7 @@ static struct timer_of to = {
 	},
 
 	.of_irq = {
-		.flags = IRQF_TIMER | IRQF_IRQPOLL,
+		.flags = IRQF_TIMER | IRQF_IRQPOLL | IRQF_NO_AUTOEN,
 	},
 };
 
@@ -298,6 +298,7 @@ static int __init mtk_syst_init(struct device_node *node)
 
 	clockevents_config_and_register(&to.clkevt, timer_of_rate(&to),
 					TIMER_SYNC_TICKS, 0xffffffff);
+	enable_irq(timer_of_irq(&to));
 
 	return 0;
 }
@@ -334,6 +335,7 @@ static int __init mtk_gpt_init(struct device_node *node)
 					TIMER_SYNC_TICKS, 0xffffffff);
 
 	mtk_gpt_enable_irq(&to, TIMER_CLK_EVT);
+	enable_irq(timer_of_irq(&to));
 
 	return 0;
 }
-- 
2.53.0



