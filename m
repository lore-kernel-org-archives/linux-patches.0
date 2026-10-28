Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209994;
	b=KRZZlo3xiy2V1fTmH5yA6HQSOxeFiqoj256UgeRhZCiHopNekv84UWgOnOW8HC9CLaSM
	 N+LGhrjKC8E24ygtQ3ntt2dEX5RJDu0VLkqHLzfU0JLxWdIVLAeZohcYEnJv2cMWyWXfE
	 0e3qiTcPPWhANIOTzx/T44uu4VXredCSqgzqRsb7i+kJX8A8iUwbVG9MslqjD47iCm4au
	 weoJ5STCT8B1zeYszENbTa5Eo8t6Mw69fEYeI/Mh/q8SRq7BhMVOlZhuOP4JM6QrdAvh1
	 pFvMrLOxyFOQx5sSUJ1Mh1PyqbVNq24xBZQ8swL9DOItHjJZkt7oK7StZ34Du6ZNeuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pTYou7syPj/QJvonOHXJIk8kIvlIVA5qtZOWnJYGQ2Y=;
	b=tsjGEH34cA+xWxZZv33k42oS+GegJ77hAwLcXnnI/LS5M11+agIqyPPqr3sQqLWcHY3L
	 oqoglz1A9Sd7hQePSRwEjbef8tBn+h8Rv7zwdJwEebnB3qN1obi5VZy73uAAP4Y53BuoP
	 c4jh9WwcY9SSXx3SW0Qs2ygqxPWRz6Zu+kQbT+pASCOkUIQns5/mhXyZPvW98gUoC86G8
	 gs2tXxAJiXkjF0a5L8/IaZBgrhGo3vDjUKKHZrQFnfAnBPp+hLhhMWsRJGLjMOvkDaJY1
	 TcdlQ/7ydu2e4fLLNuixrt7akp9/nS2tKFAXzOprkd42PB2VxzTLDkZngerobaKJ96A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JECxEC42;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504B3606A31A;
	Wed, 28 Oct 2026 17:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JECxEC42
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC291F01825;
	Wed, 28 Oct 2026 17:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209993;
	bh=pTYou7syPj/QJvonOHXJIk8kIvlIVA5qtZOWnJYGQ2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JECxEC42d0JIeGcCc96tMvssT+D8pR4fAMVh22zzj8ENhKDuOumKuTcPzBmytu+ub
	 yjDoI7waJei/B9rMNrWK4T4qlAb3B5DNddZwxkSeeUj8HsZxRbwBHUgVqD/26SqiYt
	 QOBo5WvBZXs57ka9y055lF+xEpx5HNn7hha7H8Wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/168] gpio: mxc: use BIT() macro
Date: Wed, 28 Oct 2026 17:59:34 +0100
Message-ID: <20261028165943.994442246@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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
index 79b4e62fd3ba9..382645c3a92f4 100644
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



