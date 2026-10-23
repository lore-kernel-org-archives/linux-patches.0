Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773934;
	b=Wj7iO8IdYwpAkEFrzQTj6MPTGDlJ69d5NoI1bFMOe4oYTg772ipWBKoIxvJ/cpJ2yYMR
	 0xAerc1C3qe85FGEGtwEQ90UwKJc3JHtEeG5oJEmpQLwbYVZFNudwooHPFWwMNn/56i6K
	 FNmO7ifAvga8kQtTJZXTnx3SVzFT2hSllkmz5kcTgyPv1pef0m3L++mW5O1n+2ohRFb56
	 SNYh7DHu4elK+Vgm0kcGdAxyFHOV0bIrRPchhxAarAsyY2IAc0ZvPIGSjkKBhhgr2q0VB
	 RFOO2eCd5dYgCYImw0ddv6sqXX4ObJmncj69WBxUlABuFZzxLFiLeXR2Fj2lF67OgNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jKoKvMdULdHrmFrMxYntDYwx6CW5w9VvQA0PJ3nu4Pk=;
	b=ukj87JCTxzvc06dzfHiyeRaBq0epsV2ExaEH2xH01W61ly76eMQvhE44o051LlAHl+dy
	 PMzqpJ05NiPzzQWkrP7TeggVrOQK6RTdI80pyUAKe5m6ja3vNiRPHdJXuZN83x+9vu3SQ
	 P86fqhK0Yl+dGuBJWNWlE6sR+NQ2/galKi6cMGkEMEMpzWH9ScwJKtO/YUaYGhHeK7L/G
	 7OHC7+GTifhOFFGnpuxfR4iFGGxzU3WcEjvXCUUeLJLX5Y/K0vIzg6WiU1j4PdaEZVEJ/
	 OtXPg0mP84Ivu16V7GjMgRQ/VJc28bJ5MJBUMEcc1cYk2q2AX2ZSx7pjMvM5AGtHaew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z8UWJe3g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F051D606A31A;
	Fri, 23 Oct 2026 16:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z8UWJe3g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C16E1F01825;
	Fri, 23 Oct 2026 16:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773933;
	bh=jKoKvMdULdHrmFrMxYntDYwx6CW5w9VvQA0PJ3nu4Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z8UWJe3gypI05FkJKZnnrkECO/KKCa6e03X1GwaIqXDD2a27AKdROicHC3O+7W8FF
	 D+85Z2MVRTTD9bQJBo6EHeYwNZn/l1uSwdeVa3nbl4hmcY1gf5zAdrLk6VRuxLFh0X
	 QTEbTr04Y5Ril50OTR/J+z7tDxvJHkVJK+wZhD00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Andy Shevchenko <andy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 066/193] gpio: mxc: fix wakeup_pads bit operations
Date: Fri, 23 Oct 2026 18:35:43 +0200
Message-ID: <20261023163715.765338121@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 170aeff46fb54f41545c85a72aec525aebc79d44 ]

gpio_set_wake_irq() can be called concurrently for different pins on
the same port. The writer-vs-writer race is the concern: two concurrent
gpio_set_wake_irq() calls for different pins on the same port both do
a non-atomic read-modify-write on the same wakeup_pads word. The old
|= and &= compile to separate load/modify/store instructions that can
interleave, losing one CPU's update.

assign_bit() uses an atomic RMW instruction, so concurrent writers to
different bits in the same word are safe.

The reader side (for_each_set_bit in noirq_suspend, wakeup_pads > 0)
runs in noirq context where no concurrent writer can execute, so
reader atomicity is not needed.

wakeup_pads is a u32, while assign_bit() operates on unsigned long
pointers. On 64-bit platforms, this causes an 8-byte read-modify-write
on a 4-byte field, corrupting the adjacent is_pad_wakeup. So change
wakeup_pads to unsigned long and reorder to avoid wasting words.

And fix the enable/disable path unconditionally sets/clears the
wakeup_pads bit even when enable_irq_wake()/disable_irq_wake() fails.
Only update the bit on success.

Fixes: f60c9eac54af ("gpio: mxc: enable pad wakeup on i.MX8x platforms")
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://patch.msgid.link/20261013-gpio-mxc-cleanup-v7-3-c4d769587d3e@nxp.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mxc.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index 7e17d7668980d..e3a80f17d0412 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -72,8 +72,8 @@ struct mxc_gpio_port {
 	unsigned long both_edges;
 	struct mxc_gpio_reg_saved gpio_saved_reg;
 	bool power_off;
-	u32 wakeup_pads;
 	bool is_pad_wakeup;
+	unsigned long wakeup_pads;
 	u32 pad_type[32];
 	const struct mxc_gpio_hwdata *hwdata;
 };
@@ -331,16 +331,18 @@ static int gpio_set_wake_irq(struct irq_data *d, u32 enable)
 			ret = enable_irq_wake(port->irq_high);
 		else
 			ret = enable_irq_wake(port->irq);
-		port->wakeup_pads |= BIT(gpio_idx);
 	} else {
 		if (port->irq_high && (gpio_idx >= 16))
 			ret = disable_irq_wake(port->irq_high);
 		else
 			ret = disable_irq_wake(port->irq);
-		port->wakeup_pads &= ~BIT(gpio_idx);
 	}
+	if (ret)
+		return ret;
 
-	return ret;
+	assign_bit(gpio_idx, &port->wakeup_pads, enable);
+
+	return 0;
 }
 
 static int mxc_gpio_init_gc(struct mxc_gpio_port *port, int irq_base)
-- 
2.53.0



