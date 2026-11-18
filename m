Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044854;
	b=ks76+pAuPUfp5c0uSroLfEKFvdGJoNK/ywr0r2hFO5ucxIa+OxqtnSoOhO+r9udodQnU
	 hqX617BihLxhEdLnb7lX+ouFHthtiSW7yaG0L+UwjFsHiEsjxYT2AkklvDMB0sEj/nXpH
	 tIwoFRW/pNPPVOYUsfGxNFd5r3n7mM2GFBUlal1ekHmWa0dVI9PcI+WdQuJ/Xxpr4uF2z
	 g4L1nUnZvbzJcSczYXzXpX5Va/8ckxK2l4nlxhXXhzCpgau0aeP3AH5pXIBxKgUgyjM0J
	 GwaLTLuW6c85oDtSeh4AafHZ9QjdasgkYlCWPyQW75visAgtlJjNbkRdLJoza+DzZZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044854;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6IQYqCCN1AYoCSUhRQhirQJuPswQT3Qab7y1Y99Lidk=;
	b=HfPL82ugj1YnmMKLbNLunlOJTmz1Z/pN8XnGVAlrzC78h1BMNB0sWFBdLVjBbOLulGFC
	 kwQb5uJGXTYKUzOrvdO6Fn1fv9Dwp8/cyIOhOgzIGIFljVvmcfzmPGKABfBU4xB4AWRf6
	 yvrt92TGN9nKmocAFW35qeDaLWq81ugGj7q4yWpDknHdDw9LPSPx3EE5MuwwiQBszUmC/
	 6LENG/oBVB44mmoCU5JS5FZaRn+QnYzl+E4huiH83EQhhq8sPl4vFYy2/FrplkmlzJWlJ
	 KUSSpnGHgp6ExlZvuWo5nEigtpdztPCZIR2ohvuRz3x7Jc9g10fpcBsOnYowN0YSLjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XBCJAx3R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D29606A9D8;
	Wed, 18 Nov 2026 23:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XBCJAx3R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6361F000C5;
	Wed, 18 Nov 2026 23:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044854;
	bh=6IQYqCCN1AYoCSUhRQhirQJuPswQT3Qab7y1Y99Lidk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XBCJAx3R6w669Ft03rTxnDFzkgxZVhmrpC61I0lsMJs7Oi68ovyqXYvR9A9x9B/2H
	 4K3LnbyWmcgQ4eAJHVXUOEjXxDy0eUku6UTHKmpJ6wFwJ/OEQzUXnWDmAqps+wLSdN
	 7I5vJhghliQvoOje9Y5jQeGoRH9nwWhL1xNq9C4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0714/2857] media: ir-hix5hd2: Ensure rdev is setup before interrupts are enabled
Date: Wed, 18 Nov 2026 15:29:08 +0100
Message-ID: <20261118150227.254570049@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit f7509d2567cf92eeccc31c363a2e2ae43188930c ]

Once the interrupt handler is enabled, priv->rdev can be used. Ensure
it is setup correctly so there is no race condition.

Fixes: a84fcdaa9058 ("[media] rc: Introduce hix5hd2 IR transmitter driver")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/ir-hix5hd2.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/ir-hix5hd2.c b/drivers/media/rc/ir-hix5hd2.c
index 4ff954b11dc77..26c3909aaeed0 100644
--- a/drivers/media/rc/ir-hix5hd2.c
+++ b/drivers/media/rc/ir-hix5hd2.c
@@ -316,6 +316,9 @@ static int hix5hd2_ir_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto clkerr;
 
+	priv->rdev = rdev;
+	priv->dev = dev;
+
 	if (devm_request_irq(dev, priv->irq, hix5hd2_ir_rx_interrupt,
 			     0, pdev->name, priv) < 0) {
 		dev_err(dev, "IRQ %d register failed\n", priv->irq);
@@ -323,8 +326,6 @@ static int hix5hd2_ir_probe(struct platform_device *pdev)
 		goto regerr;
 	}
 
-	priv->rdev = rdev;
-	priv->dev = dev;
 	platform_set_drvdata(pdev, priv);
 
 	return ret;
-- 
2.53.0



