Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036193;
	b=K+GH8dyR6ZJ5umEb9u7zqjacQuspnIMj/QSfmmMM9maooCThXnpre9qToLdhTJ5psPxl
	 yYuFlSi9BiRRtHNXLfJ3MZwd9nGzD1T/GRr9Q7u1Qu8pM4h1b0mONbYoYP+dqzySjLQI1
	 5sJbAw7W2LDQ3ii/Vg5KhbhhxFaYaLVBXuhZqHQ4EPFSoUV6MdO+hbsd6oU+3w/e3WP3b
	 vlUE5t5ssQDXX4r2m7l5SsIDevWR+e3/M80cd6r1cofKAm+WvXRekVrdotAFOd0Pqc4x7
	 7mIq13jehvqRlTt0URguSbeZXKKg3gjXNi9+JOzgkQDCdpiKyjWa9u62AnW7J5FFV9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gXxUEidI1YqC1yblzoGC+44AEEp2W6Wa6FVQvIXKWDU=;
	b=SBMK6cM9uKpk/1THbRdy5cs3KCUsxtC7x6nHkDbq+V4wZ6htFPZlRrYLPN2U8wD09nRe
	 w6Q70O2mch/y+d21nRHHmO7bJOuLz08PPcddQANZVl/KiS3rFwqexMR6hk+INr6bHg3Bq
	 E1BL9l8nd0cQc258szaBmUtXFIlc08/kQlZpNT5F10pspJ54vVDBRQ1/Fvmpscyjj0kiw
	 pfLler8hLYRjAPpdv3mnCuy6r5tdojp47cKm7IvB/ScIGIQcm6PltQHpsQj8u0F3eXq7I
	 ipWKBAfOMCnQziinaYCGvPdPP4k348C8g5Hcaop28/+hkmFjoGLJr/KL+Ai/IGDuXBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hxF7Vtfr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5782760A260F;
	Wed, 18 Nov 2026 21:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hxF7Vtfr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F271F000C4;
	Wed, 18 Nov 2026 21:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036193;
	bh=gXxUEidI1YqC1yblzoGC+44AEEp2W6Wa6FVQvIXKWDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hxF7VtfrgYBHjSG/r1RXp929eBFDWKEVU8fQDS8RTLjP1WxonPZ9eWMoqHZm0hLMA
	 W6seA7J+vBbEswRkSwVxKfnQsj6o1uRBr4iVHBA847GiamAIfKh/sveTvYM7YQSFxF
	 3H/ZlXlIXd+zr9XGIzVvJm03yjPf3Xjfwec2Oyqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0929/3318] mfd: wcd934x: Fix NULL pointer dereference on IRQ probe deferral
Date: Wed, 18 Nov 2026 15:25:51 +0100
Message-ID: <20261118150347.414652583@linuxfoundation.org>
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

From: David Heidelberg <david@ixit.cz>

[ Upstream commit dcf0e640b553d33512fbcaedb909c32ba9636a64 ]

ddata->dev is only assigned at the end of wcd934x_slim_probe(), but the
of_irq_get() error path has passed it to the error print since the
driver was added, while it is still NULL.

This used to be harmless with dev_err(), which copes with a NULL device
and was skipped on -EPROBE_DEFER. Since the switch to dev_err_probe(), a
deferred IRQ reaches device_set_deferred_probe_reason() ->
dev_driver_string(), which dereferences the NULL pointer and crashes
during probe. Use dev, which is already valid at this point.

Cc: stable@vger.kernel.org
Fixes: 0f1b1b899521 ("mfd: wcd934x: Simplify with dev_err_probe()")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/mfd/20260903145651.AC1311F00ACA@smtp.kernel.org/
Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://patch.msgid.link/20260903-wcd-dma-v3-1-d3920c6563c4@ixit.cz
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/wcd934x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/wcd934x.c b/drivers/mfd/wcd934x.c
index 2ea70d163ac10..f1da94174a25c 100644
--- a/drivers/mfd/wcd934x.c
+++ b/drivers/mfd/wcd934x.c
@@ -229,7 +229,7 @@ static int wcd934x_slim_probe(struct slim_device *sdev)
 
 	ddata->irq = of_irq_get(np, 0);
 	if (ddata->irq < 0)
-		return dev_err_probe(ddata->dev, ddata->irq,
+		return dev_err_probe(dev, ddata->irq,
 				     "Failed to get IRQ\n");
 
 	ddata->extclk = devm_clk_get(dev, "extclk");
-- 
2.53.0



