Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031646;
	b=tHlnyema2vgdZyhgino9DRkQUxUVJy+NchDEK0RqZwmb6iNGxHlagrZjHO1YhmnSfJZ6
	 Sq/7BFJcsv6dJETvWWw+7dj+QaOHEz+ibBhpzdFaKT+rnFyQQczFYS6onxapIipY43XRP
	 5xFEkqzlswRL9C+sa+RGexwgPO+sDKkDrGyrTmuOJaeIc/WKNr+MXlwh9F3W/zbmwOpP3
	 D4DDTJNHhJ2VHK/s9yDXaR4Kyqc8v+hUcHn1CRlAd/kca1O9l0IQ3wcNdC06/m1fESOP8
	 dQBKsuCklEW57ENx3U+67Mxmy0snecRRl/zFZn2fKhl7eXBbCkalou3Ze2IioSUonBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=liw60Vkk+kYloNXnoLyRN9j9Hgtq7tKQc7ePZ/TEs4A=;
	b=jwTYtaXtKlTx8oYeJ0lYeSsM4dL2E7NdDy8IdqvWMlZGjuW010w/0CgLqskbiR8+fcPZ
	 oHQ72tUr5pKya8AxjBYh2gj9TM45SjdkK05OfejMVKJd2+9Gry1kecQLiGj4SdlIu1Icu
	 /r9PMZxPsxeD2vErGlFxt/VnTj1dw3qFOq/PZcYSgsF6vMTHj5NxTOhPh4G6g2j5dozYM
	 X7TVfZFhnLewVeuVQ6egJnOi4iBvQOUU8PCxyt3/pyQ4JLutyZrJ/XrbJx5/++2dYoDB3
	 uAS+2n1NL6tStnKY5KsL7HKppev1LOfygW3+bySjPMMUCq5TDq5rBTklVQN7DtlRNrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nhfIGDLl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE805606A320;
	Wed, 18 Nov 2026 19:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nhfIGDLl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CA21F000C4;
	Wed, 18 Nov 2026 19:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031646;
	bh=liw60Vkk+kYloNXnoLyRN9j9Hgtq7tKQc7ePZ/TEs4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nhfIGDLlr6ZHhogO58egGRBHXFp+vSd08q6ZhF29lVUFzLeoC/2VoNuE2DoUjMYhc
	 fWuBZGGq0UD1H0pqZcxBrUvdjRprYkTLV2/mzrAizyQMp7TxCN/OWSzJ9hQShq0rQA
	 jGzpRzk9MBU/nWWUEjb+NIDf/jz0EDgtgjlxjDKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Leonardo Scorcia <l.scorcia@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1104/1756] clocksource/drivers/timer-mediatek: Fix random crash at boot
Date: Wed, 18 Nov 2026 15:53:51 +0100
Message-ID: <20261118150054.129318668@linuxfoundation.org>
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



