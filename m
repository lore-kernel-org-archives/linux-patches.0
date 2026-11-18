Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045558;
	b=5qmIqVD6BrnOvWXtdUNeo/a28BQl+IskEhoJqN6SOC0lmJCRGcYsfI7MocK4ZrUSzAWW
	 EsehWD3G+U39yusBrKfZLOZ8PEL4a7n9EvJ8LpIKNmLpXmgWY2KqxTHDOPVLInI2N342d
	 i7urCEAeVpZQM/HUC1bB4HmZq2KLQNtOVmrSiYaheaWtpheRqhEehfiN+i8UOSBXnOpvU
	 Lm/cy5E25KklymfBYaDK3glisFrUld8RZ0nz2SJ2TWpkWuhhoiwwb8n8zmCzCNgjltNpN
	 iQTddUXc+p3e+6YihNO9RaI2leLFOF76S1MkZrJwfDWaKuKbIq1qw7HvRsZlVpi0Tfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045558;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NmeqfRYce8NPyPYWSFpxRfaQJW8d3T1g8Z3wAuPh/ss=;
	b=2+xOU2dEyTosjDJ3GPBoLAr7Dy3FIZszjF2hCBEiHn1pBfx4n1KjlT/W4V49o5xqCDc6
	 SlMSmfnN7lW7loRjW2gZUeqSDmSd2yiYghR47BFzge9yykfwQY+CuFn3/FM14XJHNIor0
	 6YYfmF1jVH2RtMNWy543ul8Hm6jqooaVCAbisAlRUqkt5AVcDNcKIcIVPHB4sByIlMAw+
	 wLi4thEteGB/2cch+2xueg+/jkCsmpuco3IFi2MC2joVvzuD7LNnrf6sc7rsn3DLHpLYy
	 9l9qigHpoNp2MlfDHjsNHlBBpRVSri1VhgW0Qyzhx603vw7pzr0o3oumAENihSNeK8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eV7qwjg7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7EC606A337;
	Wed, 18 Nov 2026 23:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eV7qwjg7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B502B1F000C5;
	Wed, 18 Nov 2026 23:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045558;
	bh=NmeqfRYce8NPyPYWSFpxRfaQJW8d3T1g8Z3wAuPh/ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eV7qwjg7XBWp7And7KIL3S6thL6E6WMI+F36KDsyNB+HB5dMjRuDd+vFoctgxegDc
	 Lx7v2rlO4qhGh84hZWPNSUnrF8JOV6sIpsG4ruyrzp7PYexjXHihazAmWe5GvUQtjN
	 1axG2xs5NJWo57dtdfJ5wUYipDBZ6AJswIqatPZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0966/2857] mfd: tps65217: Check return value when masking interrupt sources
Date: Wed, 18 Nov 2026 15:33:20 +0100
Message-ID: <20261118150236.387554922@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 35fb732358dcb..0d050693d296e 100644
--- a/drivers/mfd/tps65217.c
+++ b/drivers/mfd/tps65217.c
@@ -156,8 +156,12 @@ static int tps65217_irq_init(struct tps65217 *tps, int irq)
 
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



