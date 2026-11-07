Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063425;
	b=R8JVIGJLIrmJOZwgXxgmP0FUhZ0WmPHHED/8cF56Ik0Rmvp9Eeu08xwr7SuSndkEXUih
	 awr0vaZn5FxVsnxX963E3C5e9B8doXiTskCaoOBPP3bc8aIx9h/AN5vBfdE7/gcqwa0Ze
	 7htfA0+wWlhSvHrmP1fpIdLSX9IKrsOKt9ImOMnQhDicRsv2gcz2ekvN/ob7OVaUoU6c5
	 UCokRgTwB9A0N30u2GsmTfaGP6WjB/h+H1GGsV1GWVhG/QukYKWHMWKCR3K0iwvQigGhC
	 WSVZzx7dpTY6pkAZ7nz8YXvvwLb8/t8GpTam35e9atL/GPWYd/4tSHCEgxcVvcahW+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q+fGBtEryFXugyCh6Rzurg9rlkG/ZEDHHKD7PUjK5lw=;
	b=BKMldSVO38eg/cDXB+uqlYPvutzZlhEu933Ky3MuOflmJztM7Au7bBCyernb/3rLRsr6
	 +gXt/DOupfmFCeHsNb82V+qXdOxBL1qB3hhlpg7wjNWYLzyDpPIBUr+cPbBSziXVNiuLO
	 9q6qwVCwDKmhGFxtBNyKRmzF3znYO9ZYVM/R7BkXL/1B8zn8YnmWkiq3NirwAPpBWq5KR
	 776VgivaNymXiccQCKh7NA00yDDKGZbHtlTjJ1ez//FP2rXj2Nlw54fUwgpP/OLYnfC7o
	 CnMjzcUm1otd/Yyc7x4QPf5DncOqsNQDeqbhSSDXdCRCMrQrwM6YWFwMAg5mhxzzlHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SN+GOEC9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DA9606D83D;
	Sat,  7 Nov 2026 14:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SN+GOEC9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254EB1F0089F;
	Sat,  7 Nov 2026 14:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063425;
	bh=Q+fGBtEryFXugyCh6Rzurg9rlkG/ZEDHHKD7PUjK5lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SN+GOEC9mttK79Zvg00NLBmwVm3Fu9C7XhHb1gsTa2X1YFkeXmSVtEMpqtTWDUUop
	 CWn8W5VFjSf4IXNP7PEj8NxkRkGO/Xpp7Fq/oEvWTqeIR4WsTudO19eOQqxJilXe1I
	 xsoRXZZ6uwg4+MCU1pQhhFG/5wKJfEMuPLpRXN04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 590/869] mfd: tps65217: Check return value when masking interrupt sources
Date: Sat,  7 Nov 2026 08:54:32 -0500
Message-ID: <20261107134913.128363254@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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



