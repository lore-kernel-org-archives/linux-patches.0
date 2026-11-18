Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052680;
	b=I0wlVSoSKRCmDOtp5GUgZt1AVuSbQ6luNbRN2i4jULwHOS+6JOPk8+qDe61pehohTzyW
	 ignykx35FgPlIepqgQy8uOpQtcD1maU4WE7HlD/xDsIdc0w36k8eO1mB9mEiFL8uRPWvy
	 R1EKeRgXhtU2LQl0UyaVZndlxxWXMeHv3Iwk/N7Wu2w36S3vYpX/3GQ31JlT3vEouTbs8
	 H+VJ3ps0pYtdKE6cp+SC3vtaLDSuJPeTKwoM5ALRVASRN5aOdSo0Q9s/khmvfrzzWSwTq
	 XWn9i+YjrpYQuj/zXTMM2DSEnPQhR+vCMMG4xr17W3a0QPNlMp+zDuaIQmMpWblka2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YOO/7XVvAVXo/hfpPssUbnvJOJkwRcc127FpX8QG9Xw=;
	b=XGcq7uGWKiZ78ye5/xQyhm8vA84GPdcwzf4CZar9yafNzL1YAvp2BCDKIP8VcPW80MKO
	 0NvCM6RBBHoklVChMFFZ2uIS+4Ueg1c170JLszZluKU5r9aWmHp7SUJqXpWwiLxLkCeyb
	 aqnZ6ET17mqBsJQGtLPwKv+BOFXqHlrnbo5hTcDRqfSRmihUZeqEJ0i53TIPYANmptNjq
	 fBWSWGXU3vSUktrHTYV56mAZoLmUJv5YYNyh5xcHbsj8ikcXqCPr8vcR8NS6eJHq9rUDR
	 WF42kIyFFuSKSeM7A+KcHEjk/OifTDCuiqzATdpeAS/SF4WUURbe2RtHl0whRZlnzjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aZqXIzgi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E24606A33A;
	Thu, 19 Nov 2026 01:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aZqXIzgi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878581F000C7;
	Thu, 19 Nov 2026 01:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052680;
	bh=YOO/7XVvAVXo/hfpPssUbnvJOJkwRcc127FpX8QG9Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aZqXIzgi8LY2U16rfpdl4GRO11AwUqTYaFpgRAnIPN6cf9k1IIlVtU5moFiR7C31P
	 xdvwASxSHL3V+7PfjZUVHra5p2l28OE+kDVaq30djVC+p2bI8tI0MoVm836gjVdKNJ
	 Gq6BCHOLzdXeDsIbPrDAMR5LjS3DLRYWXnACBi9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>,
	Andreas Kemnade <andreas@kemnade.info>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0650/2214] mfd: tps65217: Fix NULL pointer dereference on IRQ init failure
Date: Wed, 18 Nov 2026 15:38:46 +0100
Message-ID: <20261118150037.422648826@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8027b0a9e14f5..74b1f20806da8 100644
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



