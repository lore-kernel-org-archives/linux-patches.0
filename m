Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052092;
	b=VmnCOr+Yi5PeXX96eD7pKxKPB9vcTnxXn921SQrbde+/4z9I9yDfMb+pkMgfxWsqw6Pi
	 7ic0qnkn4KVJvvO9qQqQqOOdIKjykJnEkOuo3m/gT+BQCbY0odM9LRTr6mosNIeDQoBG4
	 EgVW1AM9SxnBK4jqCVFvJ4rbS1Xj2YRhkivSHklVrVH5PSpQfzyKISTC+zYeRAPHYGTUE
	 hBMSz63dYiSbZjrpi7OF3FEB3Y8+nE6aaSW1xLK2PVi5PR9U/UYM+TxvypsIuNaZh2Bmd
	 NzP7S01Bq6vvPD88cruxdkqvtqW4Qpg4SzvmzVHcwtgp97FetOvTv34ayqIZBQzdH7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+hKS+JO6Pk05FwizRZE5EPAkTayl+ArB3m7p5zQoHxU=;
	b=JFNzoS/O4NgSMDWW3S78bLIvlUnkl86WiIWy6F35Z4kopjO335rpNDzWjbtkL6Ql1xjM
	 G5jTjV7GfZhyRZPjopf876ViXA8uV2YDnZ9oYhSy09LusJLyFNCgmMrLd9hApdrj9m4Hj
	 qqxM7Dv0numpgHWMlvepnz1UKgsnoVI1Iwtb0+vMo+gYNgZU0Oxx6Ihx6isU33u9m6m1b
	 N0HVKQJw/lixBrX6mZP78KSSiaqSa9HQrfRWz1OkHuQY7z1XkGtVEi0PDj46zZhxXGojP
	 ay63TQAMXL1Ghy/6dGG/6fBHZZKedfUI4+agGIPRdYPmMW8sxnbrpq0LwpaJFu1ra5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dqe3db7n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8727C606A31C;
	Thu, 19 Nov 2026 01:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dqe3db7n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B741F000C4;
	Thu, 19 Nov 2026 01:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052092;
	bh=+hKS+JO6Pk05FwizRZE5EPAkTayl+ArB3m7p5zQoHxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dqe3db7n5g40n0tNjMghwg1pbCqr4js8txbOZDFxXiym5nG1h43DUuoCt5K8XtPDF
	 aGj2GBTeMPcalH6HvpTA0+XFufThrrB1OscPZpuPAV/RqeKuqjB+ctOz07jdA78Mqc
	 6/lZZveG5vfMFSwmdccLFMvXHhEk4nUpzVCs0A6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0441/2214] media: ir-hix5hd2: Ensure rdev is setup before interrupts are enabled
Date: Wed, 18 Nov 2026 15:35:17 +0100
Message-ID: <20261118150028.731204419@linuxfoundation.org>
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
index 4609fb4519e9b..6721460453dac 100644
--- a/drivers/media/rc/ir-hix5hd2.c
+++ b/drivers/media/rc/ir-hix5hd2.c
@@ -318,6 +318,9 @@ static int hix5hd2_ir_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto clkerr;
 
+	priv->rdev = rdev;
+	priv->dev = dev;
+
 	if (devm_request_irq(dev, priv->irq, hix5hd2_ir_rx_interrupt,
 			     0, pdev->name, priv) < 0) {
 		dev_err(dev, "IRQ %d register failed\n", priv->irq);
@@ -325,8 +328,6 @@ static int hix5hd2_ir_probe(struct platform_device *pdev)
 		goto regerr;
 	}
 
-	priv->rdev = rdev;
-	priv->dev = dev;
 	platform_set_drvdata(pdev, priv);
 
 	return ret;
-- 
2.53.0



