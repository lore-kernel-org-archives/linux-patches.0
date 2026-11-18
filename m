Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038038;
	b=Mpth8yCsTFA2RK4nWdm+yQjuRaK2FUJfOLws3IE0PgTr/QJ+xVtC/Nrh9JtL1qbpxODs
	 OUiU6wz/V6QcT6nRW/m4vqReArD4TeMqztlAXvDSTkx8N0py5Fc6qv0MyPahP5LUnCRUp
	 5wUik7ziSUFXm6SILnIEB6BGPLA73mHBq3gnr74Dkfl4IMY5ZE9mN4wdko6y3cuH0Z8eh
	 6FGykLo0rKe8++jxRmk+/acepD3lxT2K54VsKKxDNkUHIioJE1otGA1dAnRORVQaSVZMK
	 YJ8TqkblB3SFE//KSwxHpMjwaTra/6x8Up6p9uF1CJmXsl9tDnlA/Owcrekc8v/Yd8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=nW5nJUMHFhqihrcHn60/lB3SxVfESO2JoFfZukGSehc=;
	b=pqNNNtryqIstp5VyFdtLKtA3JpK31O4eGN9SZihYygDtAtH8Yd3upy3zpo8NjdPDDcwQ
	 qX5B6DpekTAifZ/6A82AeADKF38fRJWZvISGTMffhtPYf+plTDeCAmBFB9cHFES+L4JNI
	 +PjttuwOxYFDLXKtv9zHc+QgV+qFYA7AaJREuy0MKsBidDOEEn7AWcmM745YZgLdKSpcu
	 8rLpcRtqQhKDrkmqSIXqDSvAKnEl12Q2y/Q6GZroAn/J08McOGtqeK09pPodUaIzxec6H
	 aRNs0LZw9FK2DUaomnx90dkS7tv7MVSogHrSNC3+qcQ9uoByDAcehtokJg5ESF4wgmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LSAdOCRX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6082B606A32C;
	Wed, 18 Nov 2026 21:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LSAdOCRX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79AA91F000D0;
	Wed, 18 Nov 2026 21:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038038;
	bh=nW5nJUMHFhqihrcHn60/lB3SxVfESO2JoFfZukGSehc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LSAdOCRXVqoTyYvBldFEP2MvpYU+bNNX5akzME4UzyWB2LVcwkHALxrQHxq5NhRsF
	 WtDVA2Hggj7ffCX7D5ks8eXx7rguh0QCWtl8NPsr4riIQI/+ffRSkKqPmw/7zbZRIo
	 lhAYfUx4u63SebT9c/9szPbGwsO6xrz25gY1lsGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1602/3318] media: meson-ir-tx: Convert to use devm_rc_register_device()
Date: Wed, 18 Nov 2026 15:37:04 +0100
Message-ID: <20261118150409.235851270@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 12be815fbfd4c31aae4b23491b6dcf88a1e69299 ]

With that the remove callback can go away and also setting driver data
becomes superfluous.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: 32999b8a9d5c ("media: meson-ir-tx: Ensure rc_free_device() is called on unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/meson-ir-tx.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/media/rc/meson-ir-tx.c b/drivers/media/rc/meson-ir-tx.c
index 437d2f119262b..be353d22bbd7f 100644
--- a/drivers/media/rc/meson-ir-tx.c
+++ b/drivers/media/rc/meson-ir-tx.c
@@ -364,25 +364,16 @@ static int __init meson_irtx_probe(struct platform_device *pdev)
 	rc->s_tx_carrier = meson_irtx_set_carrier;
 	rc->s_tx_duty_cycle = meson_irtx_set_duty_cycle;
 
-	ret = rc_register_device(rc);
+	ret = devm_rc_register_device(dev, rc);
 	if (ret < 0) {
 		dev_err(dev, "rc_dev registration failed\n");
 		rc_free_device(rc);
 		return ret;
 	}
 
-	platform_set_drvdata(pdev, rc);
-
 	return 0;
 }
 
-static void meson_irtx_remove(struct platform_device *pdev)
-{
-	struct rc_dev *rc = platform_get_drvdata(pdev);
-
-	rc_unregister_device(rc);
-}
-
 static const struct of_device_id meson_irtx_dt_match[] = {
 	{
 		.compatible = "amlogic,meson-g12a-ir-tx",
@@ -392,7 +383,6 @@ static const struct of_device_id meson_irtx_dt_match[] = {
 MODULE_DEVICE_TABLE(of, meson_irtx_dt_match);
 
 static struct platform_driver meson_irtx_pd = {
-	.remove_new = meson_irtx_remove,
 	.driver = {
 		.name = DRIVER_NAME,
 		.of_match_table = meson_irtx_dt_match,
-- 
2.53.0



