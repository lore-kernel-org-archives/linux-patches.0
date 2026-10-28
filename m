Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209398;
	b=nT0tpxnAUcHDkdcqyUD1CPAHIB5zOAF0jHToaVFncR0vOYdM/ogqJnjm0u+bjvq7OIyV
	 3EmxfRrY9YsdBtexSeYdomdrYmlrhn9hR24tqoPAJZwZVSl5cM/4rVN8R5SzSi3n/R+GM
	 b19HrvzX8FlyPBR7bhyq//8jEMO8Sww4uYl9VXm62Ih27HByNryRj1WlbwPgzxOWQmcd4
	 LHi7dMLjXnL4m9U0YeFnK0Jgqu2+5Jc3MQc5Q4ZX0wNHOU01XjFgOyltXr/uZKzqFeThV
	 dTPDSF7Rakw8pOwBCRijexJlPHSkMqaF3LSe2VLg8FUaYKxs71m8bNp9JU8MScxnh6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209398;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wNCLyWauPFT4vNRB7ONrpfGUSZfE/7x2yNx4uYhbnr4=;
	b=WtoTRrbtAJpOJqZ8AQDfVF0XSZh8BoK5cnd5nGrIpwLuy/Tz3hWjH8YRyp84t3U1vFkG
	 WYU4BBBu4kDCNsal2lFuAFUgxxdlqzZQb9tHpDwkWGO/danhBeV0iDkmpjZqkkgoBMaHa
	 YjDzz/vZU5aDx7WF4MMmKXc7LPmyPSv4KQKV7ws4MsJ8MBz1/arDa93kxJaSUo1NGUHFs
	 NRVU1jzR/DHmB0y/I4Odmrw6l3GOypo2r0YcUaHu19qwGp7ujYYvwArKf3TB16+pOJaER
	 cwYGRekkVrLCysCYQmSds/O9fzhKQoIdDKTXeXVi4sO3R+wK2REDDb5iPyw0xGxRobQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UrEoIfOd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AF5606A31A;
	Wed, 28 Oct 2026 17:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UrEoIfOd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812D31F01825;
	Wed, 28 Oct 2026 17:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209398;
	bh=wNCLyWauPFT4vNRB7ONrpfGUSZfE/7x2yNx4uYhbnr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UrEoIfOdnJMX2o/y6ZUgSNw1jrJujeQtkcaRfFPGm63093TbhhFFn59YAaRueKz7z
	 65OPGGFWAYACVyLLB5+rZ2TlMGHNckr0Kjfq+vTruXSvv+hWgDyQdPKDoG3WmbBm8U
	 Ccwr8T6msxCVU9EQa6/OizcoBL/1XNLNIS+jTejk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.10 456/516] i2c: qcom-cci: Fix HALT_ACK reset request being dropped
Date: Wed, 28 Oct 2026 18:00:08 +0100
Message-ID: <20261028170014.281813471@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Loic Poulain <loic.poulain@oss.qualcomm.com>

commit 195f3d74b5de98969dc4fad956393bb00787efd1 upstream.

A HALT_ACK interrupt indicates that the corresponding I2C master has
entered the halted state and must be reset before further operation.

The M0 and M1 HALT_ACK status bits may be asserted simultaneously in a
single interrupt. However, the interrupt handler currently overwrites
the reset mask when processing each HALT_ACK condition, causing the
first reset request to be lost if both events are reported together.

Accumulate reset requests instead of overwriting them so that both
masters are properly reset when M0 and M1 HALT_ACK events occur in the
same interrupt.

Fixes: e517526195de4 ("i2c: Add Qualcomm CCI I2C driver")
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: <stable@vger.kernel.org> # v5.8+
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20261012-cci-fixes-v1-1-8cd4eb1fc5f9@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-qcom-cci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -168,12 +168,12 @@ static irqreturn_t cci_isr(int irq, void
 	}
 
 	if (unlikely(val & CCI_IRQ_STATUS_0_I2C_M0_Q0Q1_HALT_ACK)) {
-		reset = CCI_RESET_CMD_M0_MASK;
+		reset |= CCI_RESET_CMD_M0_MASK;
 		ret = IRQ_HANDLED;
 	}
 
 	if (unlikely(val & CCI_IRQ_STATUS_0_I2C_M1_Q0Q1_HALT_ACK)) {
-		reset = CCI_RESET_CMD_M1_MASK;
+		reset |= CCI_RESET_CMD_M1_MASK;
 		ret = IRQ_HANDLED;
 	}
 


