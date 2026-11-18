Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058557;
	b=mczI9n37yKia7jDpzoiKRJJ9PoqVAMuAQxoQXBIj2D9E+ue7+mUoi/8mw8BexVOdmKzm
	 dS3+IJSDT2PThipqSwuns9RQOYQLdpF10+dCfilDhN70BHlJT4AZV2X8s2STh68XYugVa
	 RiL7Hk17/yLw2gad3EgAIVG/2AjHs4Yj4ssuVcn6vxED7QWhHB4Ls9LMczjLOOzuhYwX1
	 57vuU6stJ2HxtKDxR/OmPWz4NhJ7O2sDbTQ3s6IZENywBMGdbsrz1cn76ZAj/V94VHcKf
	 AMT5JEe1Ius7AFxBXrDaZ/ChqcnaBGfJJ/c/tmz1nI3hTrhrZXZgVMGdJLCizqiJPAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058557;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H8USIq8VmETXDsPE4+W6Yj+PKV8TQf3gfihJvOu2lI4=;
	b=Fs2AnNGX1NvzdiSiM7n8ewnN7rQCu9stAbkG8aq+h6FpUDGpW4BQx0I+bgTM+a14hsTo
	 vaJ7KOKwJ+l9e46nwHjr89QPycDbCCutFTLeuv+j2bVWKTRQgEOgA582Oc0qoLFheL4ad
	 u0QOiFDfdxTNuRLxtVJERW7VVekoepDmeXiVPaC0Z9XJD4qJ8kPhtZU+TJonfMPt3bkVe
	 6HoQNRO8PLi8RCzR49251Pc22n9XZ4BXMn8tMm+crLonQ4L0dZ9zLH1tknVs929Zir0do
	 a9O4QS+AbNN8F099AQJBs19j4OCHEbbtTMOwVaG//mKQwCuipN/r1irylML3V+Aijdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xlf2BSpQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121B4606A31C;
	Thu, 19 Nov 2026 03:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xlf2BSpQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630931F000C5;
	Thu, 19 Nov 2026 03:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058556;
	bh=H8USIq8VmETXDsPE4+W6Yj+PKV8TQf3gfihJvOu2lI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xlf2BSpQ+sMgxwi4vyPNuTihb/upF1bhh5kWtMSgFIvuj/nWOXLkVlNx1uVtwKNWr
	 OtiNBzFwB0waHyPCM/fTrXOW4DFShKRfMBS7gx9x2dLBSp2dC3uHW7ineb6tvCLonB
	 Jahn0PPlXJ5tcCmTZHIbJKUM/2Iz1nGltw1B7krY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>,
	Andreas Kemnade <andreas@kemnade.info>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0526/1848] mfd: tps65217: Fix NULL pointer dereference on IRQ init failure
Date: Wed, 18 Nov 2026 15:42:44 +0100
Message-ID: <20261118145936.886196479@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>

[ Upstream commit 0473a5b0663663b75573bf284beb77459e07c461 ]

tps65217_probe() ignores the return value of tps65217_irq_init(), so
when the irq domain creation fails the probe still completes and the
driver ends up bound with a NULL tps->irq_domain. Unloading the
module then makes tps65217_remove() call irq_domain_remove() on the
NULL pointer and oops the kernel. On top of that, irq_find_mapping()
may fall back to the default irq domain and dispose of mappings that
belong to other interrupt controllers.

Check the return value and abort the probe on failure so the error
is reported and no inconsistent state is left for removal.

Fixes: 6556bdacf646fcaa ("mfd: tps65217: Add support for IRQs")
Cc: stable@vger.kernel.org
Signed-off-by: Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>
Reviewed-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://patch.msgid.link/20261002113624.178588-2-r.zhambakiev@prosoftsystems.ru
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/tps65217.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
index 2d9c282ec9175..40265478639ae 100644
--- a/drivers/mfd/tps65217.c
+++ b/drivers/mfd/tps65217.c
@@ -342,7 +342,9 @@ static int tps65217_probe(struct i2c_client *client)
 	}
 
 	if (client->irq) {
-		tps65217_irq_init(tps, client->irq);
+		ret = tps65217_irq_init(tps, client->irq);
+		if (ret)
+			return ret;
 	} else {
 		int i;
 
-- 
2.53.0



