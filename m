Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210896;
	b=kRWmEi0Z53o9KyfFMNWx1piVXcE53pt+Xypwkr2gUfxebNBeH/bkBoGW4CCT3yaEPET5
	 otWZq1cVGUQXgVIGEV3BTw+siQesHi0drVfrjmZIOPC26zK2zs18H/aYsf7o72EBvj6cf
	 tbILDzY2G9cOLsJ5QPBJ36ksh2vZOLjU2m/8Oc2VtYf04WKwHWX34mh4zWaR/2XRGPC9F
	 1908rYfl0A8ck3OZ0iye/UGhf67BaDN/sbJhAl2oK2xEAGYapoVtJ2c63S2pxdURaxZ/0
	 fSe41elXF03p7umX/gizbYR7TaBiiHG77W132g8IT6/iCXdJiq4zZPYZfRXMVlwj4Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210896;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y/eOZEeMf7AMj39rlOPgdd12hzMzDZoV2mUhTXvwPhc=;
	b=tzu533oadc4NTprDkTiKV8ORjTw22krXPVZcxZy/qAK4qYXu6pjVgRrSP9URghv1T1JT
	 N1mGZ36GHZIU4RNV/46Rd/nN8+q3r60HZYijpJypvYH9KyfHyYJRsJFO4hDIj7Z1hQBka
	 HHyNbixG+4y5kRP3TjpJajv5siZmnXnzIfyODBHADYS6tDCuz/b7vLIHWwljq3p7YrxIN
	 xwJ8y0laAwWNtZCkIkcYQ6aA/9CAbQPLKq6Sw1Nhvf524FDbxaTOS1GDy0nxIAEJYjuTx
	 VfzgwEes26OtAO8+DpWVA4PcaO105+H2D8fw82JycHS0UBInGwqgKn20AQwL7hWRvZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="U/+y1iJH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA53606A31A;
	Wed, 28 Oct 2026 18:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U/+y1iJH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BAB1F01825;
	Wed, 28 Oct 2026 18:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210896;
	bh=y/eOZEeMf7AMj39rlOPgdd12hzMzDZoV2mUhTXvwPhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U/+y1iJHISn0iSAGfmvCx9z5EiDaNZuZq6uPgZgIxbjxFqL4g4KVTK4cu7IbtWG59
	 5YF7RMoH+2hqQ9v5LXRlB+mEPX0JR6KehjKRrlgO81OxYt+ziZ+O6yONqEdJdxIbHA
	 Nq5gzEhqZFUqaxswE0HO8f5wqhCQDC0Mn0zsFMWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongjian Dai <daihongjian@kylinsec.com.cn>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 188/571] i2c: at91: release DMA channels when probe defers
Date: Wed, 28 Oct 2026 17:55:35 +0100
Message-ID: <20261028170012.471685945@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Hongjian Dai <daihongjian@kylinsec.com.cn>

[ Upstream commit c98bf3b86609a18ab16d067280257326e557c636 ]

at91_twi_probe_master() can return -EPROBE_DEFER from
at91_init_twi_recovery_info() after at91_twi_configure_dma() has already
claimed the tx/rx DMA channels. at91_twi_probe() then returns without
releasing them, and since dma_request_chan() is not devres-managed the
channels leak on every deferred probe attempt.

Release the channels before deferring the probe.

Fixes: f7eeb1af8537 ("i2c: at91: release DMA channels on remove and probe error")
Assisted-by: LLM
Signed-off-by: Hongjian Dai <daihongjian@kylinsec.com.cn>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/7D85C6CB6BF0A82E+20260929164340.41628-1-daihongjian@kylinsec.com.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-at91-master.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-at91-master.c b/drivers/i2c/busses/i2c-at91-master.c
index 28ed1bde3d68a..593881902a0d9 100644
--- a/drivers/i2c/busses/i2c-at91-master.c
+++ b/drivers/i2c/busses/i2c-at91-master.c
@@ -919,8 +919,14 @@ int at91_twi_probe_master(struct platform_device *pdev,
 	at91_calc_twi_clock(dev);
 
 	rc = at91_init_twi_recovery_info(pdev, dev);
-	if (rc == -EPROBE_DEFER)
+	if (rc == -EPROBE_DEFER) {
+		/*
+		 * The DMA channels were already set up above, release them
+		 * before deferring the probe so they are not leaked.
+		 */
+		at91_twi_dma_release(dev);
 		return rc;
+	}
 
 	dev->adapter.algo = &at91_twi_algorithm;
 	dev->adapter.quirks = &at91_twi_quirks;
-- 
2.53.0



