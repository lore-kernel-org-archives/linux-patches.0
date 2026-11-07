Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061889;
	b=DvFe9BnI7DimKrx8Wo8NzY2+2LKXt9tCQ1bR6kQgh7VqETD7+BRX4W7EVKKCW5tbAr0d
	 9N5MzIUNCvnjvmpN/928oTcmEmijQ6t7eDzGBykxQMgv6geJL5eZKmLsknWEO0OJVmj23
	 Ubix2kvTojRSUBzNCwbYTzeWVibwxnbQMxGdI4v9c3kaqpq4UEAOmABJ92WDZ32Rjlz/2
	 0anl0Ycep1Fv9/YcWrF+k0WobmnnnvXrARir4Uqt6ZECOwcD3mvTIxdqOOS/AzipYE1tP
	 umx4EXnUFlrVRJpqhCxSl5BffoxSwJ5YQ76qV8hhZ8xNWXc+AtapO4rMUktOTq8O4Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Waa3dhvKprIEvP2VJLe7LIZoUoiXpz3/So94yL0wqVg=;
	b=DH0eEl18zGu5/apXj2v/0g425dmcnJumIbeeoVFd9gBUpbXQh6BLhCWXJp+D+8B/zSJZ
	 D0Pt50LLW+Qwq0ztRMoimVfbNU65zTVV1hBpBlVNVgNq6OxHu1w41xpmUerf44xMij+Zp
	 Qo/8lzIPaq6bMcN7zNxFSst2LTxYSwM+disNjCxbUD/RGrUtNpA9z2YMGFEbr0F+AaTDM
	 F3tmrSkwOp6IYNm2V0WNqfGeKBesYFkLTrbROpH+5CtwPrCmGqWOd0GvHf9CG12VBxMml
	 ZUQYcG/Dlx1TrUp+c6SOqA50AeKKQ9uSlnfxNnVi3cNEFh4YuM8S6UnUm1FjwM+Mfaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JhKHliR4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EF7606A335;
	Sat,  7 Nov 2026 14:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JhKHliR4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524541F008A3;
	Sat,  7 Nov 2026 14:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061889;
	bh=Waa3dhvKprIEvP2VJLe7LIZoUoiXpz3/So94yL0wqVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JhKHliR49pM+l/FozH4CQsdygcSW+QmASVe9PzlhUrX11GI7X9EZBUEzVtw/XoJkr
	 epg4jVk1JsUvTo0F0iyss7ycy3Eca35FgOeBeSuIMkdMyMs5VXA/9quPOP73bKGEZy
	 WuvNJbmNAfFwPrMTbGtSN2jwt1sVtDF92jSM/YFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0900/1536] media: ir-hix5hd2: Ensure rdev is setup before interrupts are enabled
Date: Sat,  7 Nov 2026 08:48:36 -0500
Message-ID: <20261107135022.911332854@linuxfoundation.org>
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
index 1604679fa2c80..423fbc4c793e8 100644
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



