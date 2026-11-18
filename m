Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056205;
	b=Pry40lcBalH++DL/N9MDy9f61+QVHXJK07CXETbSb6X1Au6Pj2qmOFR8KfbAEpP1cJG1
	 P4SKy6LSZAfZ2Uf2cspk7DNxc0gBYcMVtog50RnaFYI9vOA4QGcMKNavLElLXbe5T5JZJ
	 vY4U7c/ZmtKZDKKL4DUtCITwVX33XxlcDHQf9gawtjWnFGcE8GUffcjJ1wOOHH2kepqKG
	 sVZjh4Ps73wPTK1sKT4ir7xLWhWjPUPfXfUTS1+ugacdJyi3rygg05I9yeRAJVMWAuUPt
	 DYCxUzbeU/2KCTIjKWpl5QtLe76SBeJ4ngEy/7IONnltplg/TZ1eljtTgSZ2L82przw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ASkcAYyJZ4JD+iUhURs02KFPKT3r/rp2dmcPkxef4Gg=;
	b=yIhIIGpGopaVq17L/C40mjO3lg1yRhTfFGiM0BZS4wqwOOOXZWDs+4jfJzerTr/mYZ5y
	 l2gi0piAJwID83dV+cYAVM0JWeJIrSB2K4c8iwotpmXh35MUzE00KxPDWo1d3jzKRxSbL
	 RcrxzLE+69sAX2Zi17kJxx8r8heltfN5SYGcaZebzrHmY97l7HKAi76e4S0ym2KhcsUw4
	 uBKengq4HaLUgpjkk9t6ync9pgmEzib8y6fOWIDmqeDej8b30xZ15TOq/k8Rnusv0k+gK
	 gDm9d2QfCAt5c/2ulQ5yXbeuzbqtFb3hFr6w7jLlXbgNkcEG8ZH9AvZRoECZd9ZYj3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZPVM1rZy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A77606A31C;
	Thu, 19 Nov 2026 02:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZPVM1rZy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324391F000C4;
	Thu, 19 Nov 2026 02:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056204;
	bh=ASkcAYyJZ4JD+iUhURs02KFPKT3r/rp2dmcPkxef4Gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZPVM1rZyyW6B1jv7nBgUDyrunxh7A1OPenBVT1ztSTebKSm9diDctS9lzPzlKpq45
	 5OX2PkjXrBBrLn+UYY/fZl47NcR347hJ/sJamB77jlsKcAC3g1tCwL/lt04YjqHYW9
	 H8ipf9FyQMRz5TwMf0QJBRVxa0nff6MIMrK2cVhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Leonardo Scorcia <l.scorcia@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1864/2214] clocksource/drivers/timer-mediatek: Fix random crash at boot
Date: Wed, 18 Nov 2026 15:59:00 +0100
Message-ID: <20261118150125.887642924@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



