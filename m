Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052483;
	b=a+MjggdLrPvnX1Ys+FWfFRwl3bRAwrn2Xhs2EF4/krZ+3PMAN2o22AqCKynuUWrVwVSZ
	 VTRTh9g4iR7F87jA+nF7dArPYAQNQnFoyaMQLyrOY721aNo7mHutNW84kFJAX/v4es2F2
	 uUlI/MgYti8Thoboz2UOrFR2aBcozAAP/M7Zu3pwtaUQhszpVO9cKx0rYrsj+8OQyEcZB
	 E5yA7KB4vhJp8huYM36zcZAL2qXnj657n6ZZ3FrPvyT4TGfazq2YO4qtlb6Ic+Llu0FA6
	 C2oue6ymDnRgwXSxrX4nUZ001tABJdcO6wz+HtS5UB1FV15WUh4yUo8QjeoLK9klReQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xxbt7hDk97ChFQM+F6iVvjLdELvLhAtXrwqowqAhxqU=;
	b=doInZ2K+I2iUT6KZnCI63UCUjUXSd453tCtssbhCHtJuo52mFD1OXSjXyKCMbyMw61DI
	 xlo2K8aQh2fgVxXMByNZLREcvOiRtPPZvnzaWCUP+t4UICfRMgA38DKGK9Urk3uM7ryXF
	 OSVyHTKC7E51pomSObNsuL1uyZfGyzgYSz/Izkb1pXBDL4Tx2ol0UYLYoU8N22TgbHlq6
	 NlVTGvXDJVnCByXT5WKNLzaQ58Y/KEBMMhFS581kpW0DimMLHyr52GYziEAxeuiYPW0sc
	 BBCzNCOZddXLzuKrFbA+8arzyc9fDHXsc8Himqj0PzD6Y9k/O5jDmHwJ360k8OCYKrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="K4Egk/TJ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48CB606A31C;
	Thu, 19 Nov 2026 01:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K4Egk/TJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E7E1F000C4;
	Thu, 19 Nov 2026 01:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052483;
	bh=xxbt7hDk97ChFQM+F6iVvjLdELvLhAtXrwqowqAhxqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K4Egk/TJpIOYPzIc7WMPVkVKolDdoGOkcaoCe9A446sPC6JCpM9gqDOAiaMnzx12+
	 SybjqCUH6tiTRKM8Lp0PUT0jk144/024CeNevmHK9TZAbE6PJrQpa9zl2sD35pYzFR
	 lAMBCari3MIflo6OS/4p37iln6O976UNYSa7Kaek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0530/2214] mfd: wcd934x: Fix NULL pointer dereference on IRQ probe deferral
Date: Wed, 18 Nov 2026 15:36:46 +0100
Message-ID: <20261118150032.264941367@linuxfoundation.org>
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
index aa19a6a4fdbfb..91584d408c7a1 100644
--- a/drivers/mfd/wcd934x.c
+++ b/drivers/mfd/wcd934x.c
@@ -218,7 +218,7 @@ static int wcd934x_slim_probe(struct slim_device *sdev)
 
 	ddata->irq = of_irq_get(np, 0);
 	if (ddata->irq < 0)
-		return dev_err_probe(ddata->dev, ddata->irq,
+		return dev_err_probe(dev, ddata->irq,
 				     "Failed to get IRQ\n");
 
 	reset_gpio = of_get_named_gpio(np, "reset-gpios", 0);
-- 
2.53.0



