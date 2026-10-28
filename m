Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207554;
	b=RGmdRpEwXA8cNiljjTfYIZqAo7AihghAfok85QZbJxfMVjLIOuZshqcmELER3zUq/O7X
	 1JszIozLPN+87/u9/TWqn/7/C87fM/19KSM2NviMJZm+oAaM90399OhrpT2gQUAIMSS0D
	 GCXz8h7JNdbrFu6QYlWIQGCZWielofUtdOqx2Tye5Evmwe+gUSuoQ0q4yPTqw3CeYkL+q
	 CFvHbwPHBH1diMxEWRN6eessbn031vX3gaC0/yUsAUYGo1N8McwiNRVdFtivpSgjekvei
	 u+ukjf79yujq3UROn6cYkpcjhFBnO8Cr0Iw8MnSPEoOkmN9RztYms49gADIYqU1h01g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207554;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X/E36Zniob34SrtUFF+ngg2cFfwG0hB8pFxHY/u+Z9Q=;
	b=Ge1sBZWOFDZj5RYphed+KkI7Kw0UrdhGgKQcoJFkge0n6Y8HsWGprQpV8eRxY5Ke1e2H
	 FrRPFaaZ3cv8iGtzBOXXBDoizOYy/R/KOnn06Fy24K0HkrlR6VS6iXo5h4H1r4mcpIFpT
	 ed74MPy9rfh0psBnqkLPAcRUM/8zm9TJuKFPkrQONx/wnzDD/JikhncOXIwWuuLtgDqw7
	 CCay1sOzH3kUPT2wcBoed+4ikWSszdTiaMpk4qKWL2B9mC4I4Q7H3ZFDT6zBZO/pruomG
	 yjegy/5uDCQLWEwap6FQkw8sFJs6sLtjDKG2lXtLaWSRJ5kIqsSizV92qc7hAUwTmwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uPxSbtWA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1E0606A31C;
	Wed, 28 Oct 2026 17:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uPxSbtWA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351301F01825;
	Wed, 28 Oct 2026 17:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207553;
	bh=X/E36Zniob34SrtUFF+ngg2cFfwG0hB8pFxHY/u+Z9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uPxSbtWAwkxCg70Xbv23UOJYJGIe5xC9EFLua20DIAXBcm5py+ABVhb9M7Ap91OLL
	 i6lhA0oLN7uJizIV3aDanuNuAUnyTydymZSUnIlwQo5Xz8ZH1MWQAL//SO8mdJQSUj
	 a7jgBSFk9B20bbg5RA2fTFo9zBQp1UWtp9ZjCFQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/247] gpio: mxc: use BIT() macro
Date: Wed, 28 Oct 2026 17:57:40 +0100
Message-ID: <20261028165948.731733711@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 9de94681ee48770ec7e2062451a572b557bf9298 ]

Replace the open-code with the BIT() macro.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260526063504.25916-2-alexander.stein@ew.tq-group.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Stable-dep-of: 170aeff46fb5 ("gpio: mxc: fix wakeup_pads bit operations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mxc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index e9120bb67db3e..1131934e7880e 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -330,13 +330,13 @@ static int gpio_set_wake_irq(struct irq_data *d, u32 enable)
 			ret = enable_irq_wake(port->irq_high);
 		else
 			ret = enable_irq_wake(port->irq);
-		port->wakeup_pads |= (1 << gpio_idx);
+		port->wakeup_pads |= BIT(gpio_idx);
 	} else {
 		if (port->irq_high && (gpio_idx >= 16))
 			ret = disable_irq_wake(port->irq_high);
 		else
 			ret = disable_irq_wake(port->irq);
-		port->wakeup_pads &= ~(1 << gpio_idx);
+		port->wakeup_pads &= ~BIT(gpio_idx);
 	}
 
 	return ret;
-- 
2.53.0



