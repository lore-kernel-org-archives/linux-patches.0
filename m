Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216934;
	b=U/KfIFbl7Tpfkz2eE1VQVF681WISTFSCqviTOEtJhBO6sIkQGmo09fHQgYmCvDa7L/1q
	 RKRCwTpbO5p5cUVO/7A5Kw1UvNJAauFKzAqZuHgnLPo0p9OJ1/YY2rM4rfVGkJMuoaGDj
	 +vuSQOqlh7oy7ruKl+5vTQdws4F/scOiHucgxQ6247GBjO5pD/TdPuqe/pIpD9E60aCJK
	 0Q1AeQZxHZKzKOW2uccOzMhFMJ7jZuIsrn/W0G2/WhVyajYkEkxIe5pKx9WxFRrz85FTT
	 LTUBD4RQRf1fNpGxiwHpXAAr7jRAII+aZVtSZ+FBhY+lYOilSHNc0ANDn0eSUcpu5AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n7/gHptluMMkthe7xxkh5hRerQvLZcjX4+abuK7xpiQ=;
	b=EJZ4mjsuQzKg9m3w6zzj7a4xWdNnnNjWiPL3LUMngSLZ4qvTv1QWRy1LkAIUbVaTOOE2
	 GKryVjeRPAfxf+FCEl+smrrBsCzpjBN5zJbqbyNBMuvJKiUFTEYW4YSL4xVRbuob+howq
	 C5CxX2nRWs+8P/Y1fJ+VVP2DywBigzSUD+AoWwCn8mpRv2JUiFEraZ3vC/yzaW5k7rjRP
	 nqhSZmsLlOn3Zzp46JOpGmvBiIuo3qodUMHk5OgzreUUSbVsXouc250L7sBfhQGkvxSNJ
	 8vCnnAN7EcfdmLTMUh9879auObeSjZ2lhgPwX1lMGGh/plKDemlwUJkd9+SJSmovukQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a3lPd0vq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F361B606A31C;
	Wed, 28 Oct 2026 19:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a3lPd0vq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F43C1F01825;
	Wed, 28 Oct 2026 19:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216933;
	bh=n7/gHptluMMkthe7xxkh5hRerQvLZcjX4+abuK7xpiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a3lPd0vq+DqxX9MjiY3hfisCSHALlOy+pbbuSo3lpSydZYsr2hWwQBnPFx6E2o8Sz
	 hWxkYAMETovfCScxaZ205UOynIVZMRbW0oSMMl0p5gl75vyptp3vug14waeRtmg4t3
	 0f5FE83OuK+q0JLeqjJCQ/rjra6kGgTKof6ur5NM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1729/1887] gpio: mxc: use BIT() macro
Date: Wed, 28 Oct 2026 18:03:45 +0100
Message-ID: <20261028170538.802062710@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 403aee6174034..c6e8c0d35723e 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -329,13 +329,13 @@ static int gpio_set_wake_irq(struct irq_data *d, u32 enable)
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



