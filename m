Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036635;
	b=SRQBzsiy6uxdplyGqjZAXjLmMXpXa3gWTMuTEIHM7PzLmENDU5RMmhshyijdWil6qxqf
	 Bp0bm6msN7+U8o7PXlqvPHSZ0OiatfwmAq3soVw+Is42Sxat78ZJZAcaToArVhAILOaq2
	 011Eh+NLc+n44E30pmCBvJynxKj6rZ1v3Gqu8qMPwpXD7v7Nnk9zeoJC8aApEkA/oaCHR
	 IZIKaZVMM+RTnmQiUw8Ir4F0CSMkodzwDtLwahoCWwA6lAjq6pBPC4tVgHV5nyfZl7Gat
	 1ET1G6oq9BK7l6lUMHm5BLozLyxKkZs5nKq6IfrQkmRx7ZAh2G1Cr93I7XJDG7qIn0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036635;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tq4KVTg5rhw6byiLLys/R9Hmotsp2ddWa/62XcUharo=;
	b=dXuLy0NWNLEQ0XCKMfD7RpwgdRJ+/J6tMQ20x8WfazHwOFgx/K1XnrgV7/RMHT6kWF4b
	 dnxjS2Kk3WFwJBwWIIxGny0J2+fxt0JLE0jj7AkYxrTI6E/16vS+Iw+XSBwHOtSxHw9l3
	 HWJmldpUCnm/F8Ljtppa1QMAGsHUr3Xg+5oDE4IUeQKM29pGePKLm2WJS090gEWwrrKpV
	 HrwJYSJz8YGblPIoSg2ggHBYvi3URW5lEvMyaTaNo6NBlG8ihua3aBCYtspv4pOpNMAPS
	 WwvXV8FObwG8oEM+lDlmHe4u21nt2JzcnZt8RQazMPCzlk5YDKoXgoJwVqMywAUbHFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wtSsCE4V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D0C606A32A;
	Wed, 18 Nov 2026 21:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wtSsCE4V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66441F000C4;
	Wed, 18 Nov 2026 21:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036635;
	bh=tq4KVTg5rhw6byiLLys/R9Hmotsp2ddWa/62XcUharo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wtSsCE4V0nI4aZuBVKwBizs9pragJHCtIyLLRMB2PpsZYhQx0SBNGfNyPbX/c5N9p
	 pX+DuoGWAHr5aqIKirMzKU/ox9+X1qtX4PQsgy47OCTMG4S/VTMNiUTWHIUcWB1PpR
	 dH/Ld36g8O1FF59AZlw46C3Cf68NMwup2Xkvlm+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1130/3318] mfd: tps65217: Check return value when masking interrupt sources
Date: Wed, 18 Nov 2026 15:29:12 +0100
Message-ID: <20261118150353.943567926@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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



