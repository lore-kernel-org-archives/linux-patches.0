Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063816;
	b=v2mvhZaYsVyeKn5MyK2Om8XQQeKJZz4lfsePd4rPGqFTxb1Hc4zkCU5sXeELDOlHHNVC
	 ZKdK6VKdloB4vN1HeDOzGpSApqJ8wMNqWLtVzCjmjEYFrV3JaweCVQnkS4weYEprIyb+E
	 nO/mrAEk6vUI8MTUe96FHd8x8jg0F6LDZnb2Cf9tKW5/9A6MQdhnvBZV4KKYJ9cZ73vjw
	 fWg2dbh0GuM6LSfZCqsxLNLKLCBDjgJdJfc+/qwVUZ/dbQvScukyvaNEaHCsNlVDOzklj
	 fbJV0bNT8nRWRK1UpZXazvJUUGEF2GNA7xgoNoCNKm7Htt0zUTzio2TKAnFvXTH+7Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063816;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9qr580TJ65R4/JgKwdBOhHaUgLrK6AJIfadGEc9fI0c=;
	b=oQjFOStQ5WK5Nkm3DoLwnjMl0xP6jsWXJ1qXatkU72b9hPXpVnvS90fftwrvU2cCuuK2
	 XcdBtmUIPTTR9cyqMsH90byZDX3BmtW+skVVi/jDR+J7q6enwtQmYMYxO+Aae0mRzaIU0
	 +QsqRbhZn4F+aHEMp/1hB9CrY4k6p1M9itUh2IO0flFU61MvRVcBoxMVaTYed/xO6aRcE
	 Z++4Y2/JBWJhtXG9ACgrVNEIH/O2qw1/Y0KymW8055Gl2gBQEGu+XuHBLvhfkldR5jBXG
	 0PwrLUshTJ4+4Yn6brj/6sMDWapofkH2mEuYxG0qkJwQCFsde1h3xEt2nkAs3u3AQ7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CWRdbxO5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF16606EEA3;
	Sat,  7 Nov 2026 15:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CWRdbxO5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA4D1F008A4;
	Sat,  7 Nov 2026 15:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063816;
	bh=9qr580TJ65R4/JgKwdBOhHaUgLrK6AJIfadGEc9fI0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CWRdbxO5FbYtUbdIklp+oOSbTcn/x2QzVYO7XqjnpsaoJ/kdcm0jiopYgUDO0x7Yz
	 sG9HOTARDN8U+iBwj2DwRdcm3C3vQUmzB/JvaB0TxcRLuZrXaCYOgHEugummT/W1QV
	 r4AIaM03XaqjhvRaOvtcPZJKalfU67M9q5W+ksNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0033/1257] media: ir-hix5hd2: Ensure rdev is setup before interrupts are enabled
Date: Sat,  7 Nov 2026 08:38:49 -0500
Message-ID: <20261107134940.321063677@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 1b061e4a3dcfa..aa3de4d57a585 100644
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



