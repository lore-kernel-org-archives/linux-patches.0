Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045136;
	b=S2/NwyXRoRMbMNO4aOoEX9HcQzRENrX+q0wqQRW5mxFGH5jSvIEiJhpZXCGxHvZyU5eX
	 S2yO3AE0TdSpPsURSjeauxWq4XELoGlRNmXS37lL/ZjQ7Of8xUWdt/yge73luUuRlrJHa
	 rlFz4B18B9/NC98357RJU25JFMmQgmERG7kUwgpKaA5k9BEcyoSvYmJWRgNRO6bQb7rSu
	 iBZHD1GXZvLDJwyymnRncXGtpqax+ToKvhgqvp87JqAqacI+w5VSoh736rPxqjo/U/J1Y
	 gy/6DfjH3hWr5FmKIfwfmVJbaiuDd58CBMqSV7CaXpcuDxMmJbKgs+V0Yn8f6d86nog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045136;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zDpRbQsK9aB9gXQcDiHMMuKqn2pV2DUHgwXayT8XA6c=;
	b=hec5Kp3G4JdkduQ1nnaiogEeQxUQJrmZ7S5BtnFkq1+JeNl8qAOXwFR+z+e/TutTvwJ6
	 MK4WPoCsLqxgFl2/K008Po3qt0SpRR7Syxnn9QXKBsKuejYbLfxwWjHCrLOrLCNXlmX5R
	 xvpgtFcpJiKBFoYEBTeJHn+zap+Gy+xxquoFcIdE0a9K47w6Y9eT8RzK9CpqO0vohP1dK
	 EGGvmnF6NKcI8yu0Kt+WQ1Jy5WTEf2XHLhIs/VomuGO4zs3FKK/kGqz8D5Li2cdQNhAWy
	 OxG6N8dHSzE0aPvJ2t1URWVoWQsysgPW8rMCzKxn0GgFgFfCRlfKm+tLUGMi1mXgAxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GyvWpHo5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C46F606A31C;
	Wed, 18 Nov 2026 23:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GyvWpHo5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77EC21F000C4;
	Wed, 18 Nov 2026 23:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045136;
	bh=zDpRbQsK9aB9gXQcDiHMMuKqn2pV2DUHgwXayT8XA6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GyvWpHo5Oi4bpHEPoP17ug4Cpi0DSpxQaaj4nuU26q5+rWMpvVnr7lhRirdgmI3Jg
	 LwfVMv/NWbXDrbR6wMOJMgQVECUXr//+jsNtVqiOOgpaomorV+bgWG2PV6/EtowGcQ
	 04NaETbVn3meMxOZh+KM8w1CdmLpjrGx0fRbaNOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0815/2857] mfd: wcd934x: Fix NULL pointer dereference on IRQ probe deferral
Date: Wed, 18 Nov 2026 15:30:49 +0100
Message-ID: <20261118150230.922218190@linuxfoundation.org>
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
index 6f4b1f1c4a787..990a5c2780392 100644
--- a/drivers/mfd/wcd934x.c
+++ b/drivers/mfd/wcd934x.c
@@ -224,7 +224,7 @@ static int wcd934x_slim_probe(struct slim_device *sdev)
 
 	ddata->irq = of_irq_get(np, 0);
 	if (ddata->irq < 0)
-		return dev_err_probe(ddata->dev, ddata->irq,
+		return dev_err_probe(dev, ddata->irq,
 				     "Failed to get IRQ\n");
 
 	ddata->extclk = devm_clk_get(dev, "extclk");
-- 
2.53.0



