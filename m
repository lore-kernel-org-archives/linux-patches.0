Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035719;
	b=VvZI+knNi4eRhxbsd8K4kHb6qWlvZa85BfsA6rQL9302G3k1wy5MnjvgVlcrUFvxSY7B
	 jpsjPFeyuVkHM1HPVDVXYz8E0h7YpTqPmvwN990jGWt/Mc70MBoXISUXWIZtfVeOFFSrE
	 t0YsOm3WJjlR2bRRCDWf7hDqzJhBp/9X8yITjf6HYplj+SaUbmcCkFdHoLuAxPodwdzum
	 T0BcG++AXgaiiC+AfzWuKCC9vaSHvdjJHimosYFRJ65lGif2Z7vY7gc/Gn6SVU37L8FKy
	 vmLNceAKX6QRYR6FFBfTod/CrJ/cSt2MznBHz6vEa80Jh9tZuib4ac0Kd13Zi3UqSAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bwP/gaKLtcxwkI1nS81PXd5FW62tgm+R+2Si8yHGC4k=;
	b=nVPPMk3jRNH1Rmi8Ou6WQ6x2VmkNL+WL40w1Dw5ocMRdIJqDgZpLP5NKwwPZHmeugxG0
	 HUZqyE1ni58Utgc5hcfH+VFZT3scgu3Bkdjhhd9ypbXs1rEC3f5whXFFtDPH9BRhmXnI+
	 lYJRPZqLmFLf1eAVquk1NgPi5iUrcRSuqVHr7kK0cmpHVDRwutD2kqEO01iVDxJUWF5pA
	 Fu7jxvEdvMIFxMOmm8iQpXk+tOXintmxOHiPQPDOfxN2h9Fsg7Qg8pe3rhnBkvf82Xjon
	 28UEDYAb4A0eC2NwMdqAL0w7ITMo26tI+TtXMxg+KgIYj9y/KhZx1aPvQ+0ZQD/rBTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2WE0o4lw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CD0606A32F;
	Wed, 18 Nov 2026 21:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2WE0o4lw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0860D1F000C4;
	Wed, 18 Nov 2026 21:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035719;
	bh=bwP/gaKLtcxwkI1nS81PXd5FW62tgm+R+2Si8yHGC4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2WE0o4lw1fe9Jg2gtlSfNtoo/rdg1s1/XQVJ/6VNmt8y9mqkvchbjmXVaXisWNLrw
	 mv3xjNsKLxnjqxxJHc1La93w9m/fJ8uvevL6Vu/EWBw8ntAWTslPAYUaZgEWuxah4I
	 YkGGyjdA8AYp7jG4RRBnE4YyXb8H7BVIUBTfxpz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0804/3318] media: ir-hix5hd2: Ensure rdev is setup before interrupts are enabled
Date: Wed, 18 Nov 2026 15:23:46 +0100
Message-ID: <20261118150343.078216209@linuxfoundation.org>
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
index df347d2fb0ead..0be6470bc9cbf 100644
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



