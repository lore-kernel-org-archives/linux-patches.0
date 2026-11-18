Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058282;
	b=PtD6ALBI1U/EEL/TdnQzXhYth0p7ckQRHuROWCCsLz3CdjOADPGM/qqXT6esr/T1Mnlg
	 4HNnUgMW1q2n1/Qv3krmHMqYbuJMXqFBkSfL+Ss++MZ9vEUqSe8AdbRbCSaxeQNoebFxj
	 /3fjtpXOgURMNvMIrcJXhxv76OpkmVPr66yD28CMfKIKJgMUHYCP0slXtfAZvUBf9tWH6
	 xJ25Adds6fGbr+2ISHZxyAanyli1G4PHd7xM+uYGArXpUEjgVwKRN+ugm6g2p5zy81IfF
	 /gn0w/fYA3XLQAhDp7njBKagqls3Vc8J4WP6ux9W4MOzgjbxlON/i0yEeZ1LjEc/1sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058282;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Sa3BVn7o07gTBIyYmvmgdurlcTALcjt6HQ6EZEHSXSY=;
	b=nh30w6gxFBvxOkPWU2TsPIHg5uHuGLjpBFh0xmPLwfg8dZSKXI3c/d/dfJm3lJqwAbaa
	 2dMVcWQYGxBA+8Htkvh5B33StPDTQlpvJHpIIHbiI6/cfE3zWXRccZffxmt0RYMfB1W+X
	 ThOrEOkOk0U47v4ZFxH/ib1HQi8Tck4ylZSLVEaumKlB4b4YnkeabNObR1h74jE+ABEQf
	 dxOr4/UUAkAnCvgXbeCb81bcDZbc9DGcWsyj3rspXVF7RG9YzIdE/z/hq2hHPx0JhKY0A
	 ySCz6d6ZDbn8C0EttPMg+Lk477MiQQKiHJsLTdukWeNKSSL5UT8mPj/Ks84DPMJIjNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gdgEtwkG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18922606A31C;
	Thu, 19 Nov 2026 03:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gdgEtwkG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661FA1F000C4;
	Thu, 19 Nov 2026 03:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058282;
	bh=Sa3BVn7o07gTBIyYmvmgdurlcTALcjt6HQ6EZEHSXSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gdgEtwkGPO3ZHWBnyBWzJNekn0cuHZQQJElvG+L2SdkL/oRHwGo3rrjgO0196Dtl0
	 AsS5v3jEVGaGkqxKcMZKBesVSc5iP9GMmtMv33whUQ8iP4Ork/7YRVsHOFb2g+X5VX
	 fJfQaApJ5CadrvJ6uCRMg5jTdmtPn/AA5256rDfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0429/1848] mfd: wcd934x: Fix NULL pointer dereference on IRQ probe deferral
Date: Wed, 18 Nov 2026 15:41:07 +0100
Message-ID: <20261118145932.143831449@linuxfoundation.org>
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
index c274d733b6566..bb889a1cd9423 100644
--- a/drivers/mfd/wcd934x.c
+++ b/drivers/mfd/wcd934x.c
@@ -220,7 +220,7 @@ static int wcd934x_slim_probe(struct slim_device *sdev)
 
 	ddata->irq = of_irq_get(np, 0);
 	if (ddata->irq < 0)
-		return dev_err_probe(ddata->dev, ddata->irq,
+		return dev_err_probe(dev, ddata->irq,
 				     "Failed to get IRQ\n");
 
 	reset_gpio = of_get_named_gpio(np, "reset-gpios", 0);
-- 
2.53.0



