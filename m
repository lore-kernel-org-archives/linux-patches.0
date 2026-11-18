Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026313;
	b=EZZVrl3e0cgAyXSyDcRJmCQNp3hTQryIuhYnZVDEwRw7Xtz0hgbShZNJmyoLXtbRSg58
	 h9dW1sq4J3ZcI9LcqEaVlLbGriNzZa5Nx1+P7WTS4eRwGfOAv2qV/7Aj3CCbvGjSAGDP4
	 Uss1zZDm1V8EHOrYzaO20iJxymYoHOuh6uz+DVN3j8UaXWFFQQi1h0E/+ruG2Zlb4t4XM
	 qmG6Tmcy24FDTTA3PgJAReYLrlEYSH0JkkV9+0jq2WDYbc6av4rIqEZkkfmYTX4xnCW+9
	 ILXJCDmm6UqmZ77At1UiBNMlqao0/SHUsn14sYmxCuYEFE/CWmi7sBCb3GVTcDPitFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026313;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Iv2ShBW/5r3YIEM26zRvRW1I7Gfxu4bY6w69+F6w1R0=;
	b=HIQprYUp6MyeubAHEwJG2prujwg36H+1F0BjB8IM9dFR4vBZbYddoXkbm/d+3EJDOAV2
	 JIO562i2O3YA+J8MV5totTDyG3bmvqXeclfDFG4SDldXARDiDaXDTMu58QfdxjNfnCcYM
	 r1YaD4MpWwzwYN6ZV7U1/KjClp/UXXr5ElNhCebsxTjZS8ENOAWDgOoEwQBU4rCLQAOme
	 Ht0hSWmheeekXIXq6H/DWDBwQco8krCoXTSDx4VB6m+Hvlwe/69o+YJmo3yxmnbwRny2l
	 Pw1l8A2OrWT7AjusIW3HXRzYx9zsy9ipCqV4nEMkxrcQY/1/6afh0rDSigRWD2JdMCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XatU99Fh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BF5606A325;
	Wed, 18 Nov 2026 18:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XatU99Fh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EA51F000C7;
	Wed, 18 Nov 2026 18:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026313;
	bh=Iv2ShBW/5r3YIEM26zRvRW1I7Gfxu4bY6w69+F6w1R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XatU99Fh7UcuAIy8gbPvRYeLZQNiyVx1pC88nX8iQkfjFMX0ZiQRWjB3hu2eyl98n
	 BFHyjST8Dm+Fe/EWhQ2fxQUdWpn2N+1YN3XyMG0EPMxusBqp2TJEQ3SCTZ+ARuEYPw
	 Xioq5hcgmnoHlqU+gju9hXlV0CXbg9dTump3n72k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Leonardo Scorcia <l.scorcia@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1392/2151] clocksource/drivers/timer-mediatek: Fix random crash at boot
Date: Wed, 18 Nov 2026 15:52:07 +0100
Message-ID: <20261118150212.709498927@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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



