Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064902;
	b=t8EojOit7QC9kbcS/HqWDxmzuPqx6oq7M9/LmuxmFYslXfgMMGQwv51GPIhq34KeK99D
	 tWfdu3kjHkLrn6D8q3D+lU2BC9Jj0Djym/pJI8QQgQmbiPdBsMqBPWBsPR0RAt/NEzyeu
	 Hc79dXB0RJ9WJossvreF8pY1kE6f52xBuDTWdF787ZhqY+QMCpAdXfLdStRyZJFacZ1aK
	 hztPN4MAFQGlZXCQdqk65ugL+l1Kb8TfKU/p3yugWjwhPRYDWZGcTnGeNz9RoxJOuw6SG
	 MbbrCNvmbEI2wrLDF6HOVARvoEqJfc6tj00hMhiYzLkNHjwMk0h4+QYLYr+70gknMDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LUGahXTd2/I4ZNKre6lxJO6BBociBnZIybDkzRuDdPQ=;
	b=bXwDVTyhMuKALGS/y/Z6+vZLASa2RRH1cBKvkelL+Inwny7OIr/8tJgrq0HQTUvt5Mbb
	 ptZhdcP6v3afHnq7uAfXtvPKtyckXWCef1hSMsDcpPpKr7qB81DUeI+XFOiZI0eXl9Etp
	 1RgHwa7U69LncTNwE24kVMGyXuIs2sGTeajXd72yOi+Yh8WfBWrPrzX9kWjXGrcikosGY
	 Qcp3vGm/UScdQsIjGTT8qX7aOtL1Ffx8JrMwrw1qbjI9Z5dTM3j9y+7MxwwMpRmCcmczW
	 NIyqX5Euw74khG6gZ19cfk7iNqQOgpn17GV1Mv2WCUpyvh3M5g2J3odkc7HWMde40Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=19WbhbKD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533E7606A9D4;
	Sat,  7 Nov 2026 15:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=19WbhbKD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA13D1F0089F;
	Sat,  7 Nov 2026 15:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064902;
	bh=LUGahXTd2/I4ZNKre6lxJO6BBociBnZIybDkzRuDdPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=19WbhbKDww+8siEFnOnjfpOoZnvdrf3IkrWu3FR5ZwSHSi1uJ8nb4qjAV1WOep6b8
	 xZNqEbDruDdlQsX27nK+OdQ5/Hbmj97JYxGqPSp1oeBJ7HelE3M6JHFQsjbv+ELIA8
	 T2K9QWJvrygRs+c8Dqg0VQDcAejyH0Q0pX5UDLFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0806/1257] mfd: tps65217: Check return value when masking interrupt sources
Date: Sat,  7 Nov 2026 08:51:42 -0500
Message-ID: <20261107135001.596598222@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>

[ Upstream commit 66ed12c1e5a986bee1dc63f9bd9c7f068138a69a ]

tps65217_irq_init() ignores the error returned by
tps65217_set_bits() when masking all interrupt sources. A failed
register write leaves the driver's software mask out of sync with the
hardware and may result in spurious interrupts.

Check the return value and propagate the error to the caller.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 6556bdacf646fcaa ("mfd: tps65217: Add support for IRQs")
Cc: stable@vger.kernel.org
Signed-off-by: Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>
Link: https://patch.msgid.link/20261002113624.178588-3-r.zhambakiev@prosoftsystems.ru
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/tps65217.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
index 2d04d9e0ae29c..ee640e3fcf7b4 100644
--- a/drivers/mfd/tps65217.c
+++ b/drivers/mfd/tps65217.c
@@ -155,8 +155,12 @@ static int tps65217_irq_init(struct tps65217 *tps, int irq)
 
 	/* Mask all interrupt sources */
 	tps->irq_mask = TPS65217_INT_MASK;
-	tps65217_set_bits(tps, TPS65217_REG_INT, TPS65217_INT_MASK,
-			  TPS65217_INT_MASK, TPS65217_PROTECT_NONE);
+	ret = tps65217_set_bits(tps, TPS65217_REG_INT, TPS65217_INT_MASK,
+				TPS65217_INT_MASK, TPS65217_PROTECT_NONE);
+	if (ret) {
+		dev_err(tps->dev, "Failed to mask interrupt sources: %d\n", ret);
+		return ret;
+	}
 
 	tps->irq_domain = irq_domain_create_linear(dev_fwnode(tps->dev), TPS65217_NUM_IRQ,
 						   &tps65217_irq_domain_ops, tps);
-- 
2.53.0



