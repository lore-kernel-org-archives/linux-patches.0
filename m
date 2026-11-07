Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062460;
	b=1wp7zDj3IHZ91g46imeCedOaweSpRLpQnF4drUHvMX1umw/AH6kxEftEw4aVYer0zC5r
	 j8EHrRGjmoEkGGS8bijAiebu56WDrvaKRaKoX3QITgVxY3JWQO4Etzzp4UTyzbiRlwNqu
	 NBYiVTfLyXiWRnIKfL92wVThItg2T/hKrNGchDmvOOEMsvqeUAGhVQ24gr90QeHuojzTH
	 M+AX3rXw/5kPBhf+qIXHrWtu7FsR9TZyPEnFuiD/5iGCnFSAEUKvz0ykhZcA8TYYV+uhW
	 UowsrpqpYICtwR9Jyrzaod4jddfImvpeGKTGXoNe53m0V/xgtpEaaX5Yt4CTaD3EwwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062460;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EtYzySafA6aYNGueThD/Sc5k+DrFMsMA46iDgxtL2Sw=;
	b=Rgd0Js1Ra/YNr3kq6Iirnc2nH18XxlVKxv1pQcLo8tTOBYx6+KQeTh05+ZCabEXtrM9b
	 FwFivnrrlz31pn1XGEGVpQ3UMbQ+0bkHjfgQi2s77mVGQlr9k1DkH0dR6OAnZWYQDtwvK
	 B0tELmroBiTnGGS84WtNMh4LsAL0rzbOSI9Zc0FZ88FIiRUL75ZZBDtbdTnblLt18MiEC
	 /hbYyOHdu/2/09QRrwOBS3pEVZMk9pHxPIJEuTQ6CY2EVKgciLTuBagqFI5z4SHxmmVhA
	 cM3rY1KeORyRbw+EQl2II6RteObpTF6f2frK/gNwui4Yo9GQ7IYv60DgrtEeqWqsRIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gbi3lp9G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B892606A642;
	Sat,  7 Nov 2026 14:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gbi3lp9G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5AB1F0089F;
	Sat,  7 Nov 2026 14:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062460;
	bh=EtYzySafA6aYNGueThD/Sc5k+DrFMsMA46iDgxtL2Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gbi3lp9Gz7Pgla7sRHQKOq1JzyVR+KhHHwb5rDrKNSf0Tk/yBF7cOfjktv3AGSk1k
	 YGXAG7dimDWdnT6V8EcpyZdIxCsYA2oWN36Fwa0xAuky4OtrP1JqZkqEl8HRB+tfHW
	 uiPUbBJwYrrJxfg0sjlrQPNaymS/G12f+Dv3kfY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1318/1536] mfd: tps65217: Check return value when masking interrupt sources
Date: Sat,  7 Nov 2026 08:55:34 -0500
Message-ID: <20261107135034.826053568@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index a88dd69a2febc..d4f09e5bf24cd 100644
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
 
 	tps->irq_domain = irq_domain_add_linear(tps->dev->of_node,
 		TPS65217_NUM_IRQ, &tps65217_irq_domain_ops, tps);
-- 
2.53.0



