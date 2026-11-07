Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062078;
	b=MnIRo0rpL5I6+1nOguKW3PK0cRKZptV+gLviRlEPUkuOwWatxDuNDBbyWMvto97crmHj
	 AvKkhtqY2z9c1OoNfvQf+ieqvA38MW1UdWege7fuYVlsxahgynJZjcjpdzVSFr+DNKYwu
	 Kzx2BVdZwQ9LPAXnGZaP70o/Mk4wB0dGoDnpW6FZCiCae7SzdEDEMmNH0amgc8kwgJmBu
	 64RIuArDjSvMjuPqQfH485wbh7/Q3f+wFzSQcP2FF/dsgBSDTkg45ZRaZmh7xdWgjFI8t
	 rByAkgCizq6bbqCswu7Zr3OlAThza1jvVEva/FcdNoNYvwo9N3KgsdPnbxdPyzoXZ3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062078;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uWs8SMV+N2H3n8GHZ836wAIIMpx5WdVwI58BQBIhHh0=;
	b=o9zo1TrzzWDy+RNTx0qnscfumwwJC8Tsns1H7JHQRt1Wa1nkRE2OV+yoQtZy2lGjkSFh
	 GKiQc3QTYibbBHZ/Liv65dB7R7CaW5pJ4DCzjd8u1wcIe+YuCgcwIKKei608u49Ew0Wxf
	 9szvcb9wHSTzJukHyiOSRH4zYG0tj/sbFQOUtoj1ZwTo1/gFFUIXum6rYKVJ4noeB+z0X
	 zEnbEXWNB56aFRGuH2j3lUN7vJwETdFrf9Qsdo97N2MpG2jvLUHcUdUXn55VwBOlyhvR+
	 bofo1vwAFDVcOY5/8qv+9TM8mXfPWgqHCgWLz8OHbUkVOgYv30bS6YsQei76Z0p++RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VAXyMav1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930D2606EE9A;
	Sat,  7 Nov 2026 14:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VAXyMav1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0D11F008A1;
	Sat,  7 Nov 2026 14:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062078;
	bh=uWs8SMV+N2H3n8GHZ836wAIIMpx5WdVwI58BQBIhHh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VAXyMav1WhC0mBe7ZBqcRHXF3biHP6nNn2tW4qamLznU9eUESKTD5AlJ1PeBniYZy
	 COES3LzSaEwkss7dUEJnbXyTBhnOG5drwEZoflp/iucQr34P6x9ZpZPl52DKbZ5Xzz
	 FRhv/afmEkR88IwRpaoic6o98YJKpylTrt73UUIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1055/1536] mfd: wcd934x: Fix NULL pointer dereference on IRQ probe deferral
Date: Sat,  7 Nov 2026 08:51:11 -0500
Message-ID: <20261107135027.313240732@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6f9e8e5fb20b8..c539030215b7f 100644
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



