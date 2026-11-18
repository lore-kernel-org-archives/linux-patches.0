Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036323;
	b=z4fRJfd/d6D8S4qLwiKdR5ne/vgzAqGDpJu1Q41URWVQTi7P8Yzzv5RbwpTeVMqvwoQr
	 m6NBFw40Ab/KdsxchAb91Lm7kob/LiI6p590I9jM7YgVK972M6tp4CVat4Y+GQ0u7/qQl
	 yuabskNv3PPyM9Fc/McptVSoCZCjMIkyoEHs/GG5XUJtyz96eCIuW5u/UZG4OEkSSZOg1
	 8fAspGRh0ZBCc0O0KlIEDoM37+84Zdt5Eu/QzCcWOjwzTvfIJ5PYjxD6bMNJnFKya8YRP
	 rWFHUTYG2oGnNhQJG8T4DojWOIJuEyyMT5n+VVbsEgyE/ITXSkibdFU4xnZv2iOm8Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036323;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=49hw33gMhdmPTjljeoZHh17d05P6Ks7VnZdHaNwpQKs=;
	b=ByyRZQdoPdfU5/7iucH1kVgGPFv/a67TMcz5rhLF/uKXwtIb//2ycWAdj3/GivpJHo3O
	 gbFyO6yvXey0UdkO3KazMJDFcMz7FsmhVmhYhsztLn9toRFjrSN9v3wn0dmvzKBGTu9ql
	 i7YATNxuCSSW4xvQxtD1xb/vqUHSB6oQ7xp9OSArJenYkLQDc2zmnhi1H1eHW0+XrVBSO
	 PoMKmTl1weE1GmvAfIzgQDOQZ61oMsAHORcxEouZeKROrcPuezPz1OT+2W6UufRnA9rg/
	 VSKVHyRueQRxbg8vbxtfFqnvHYA5mm2AB8aM0wYbNe8bn5A1H4P4i9lBdVkb9iFw0kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="QRj/5P5l";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035A9606A320;
	Wed, 18 Nov 2026 21:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QRj/5P5l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855471F000C4;
	Wed, 18 Nov 2026 21:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036322;
	bh=49hw33gMhdmPTjljeoZHh17d05P6Ks7VnZdHaNwpQKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QRj/5P5lc/irH208LOGR342nivBroYu0sm5a1cb6UhjruUpCTXpuOYzbvoHXMBRdP
	 1JUG1ElOUJpmNmujrJqb6cfFEuuRNlyWHzzpWyFApcS1pVmF+e/bhnzs94cl7fhCI0
	 Mcc8vH2O28mEXFJyXBr9YpPIKKiSiio33U3A3SH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0975/3318] media: rtl28xxu: fix SDR platform device leak
Date: Wed, 18 Nov 2026 15:26:37 +0100
Message-ID: <20261118150348.970685104@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 083a92996598a5080965f1baa84175082e14a45b ]

rtl2832u_tuner_attach() registers an rtl2832_sdr platform device, but
does not unregister it if no driver is bound. It also does not take a
reference on the bound driver module.

Unregister the platform device when no driver is bound or the module
reference cannot be acquired. Drop the module reference in
rtl28xxu_tuner_detach() before unregistering the device.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: a2f7f220df5e ("[media] rtl28xxu: switch SDR module to platform driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index f7884bb56fccf..5a1e2a38d8154 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1391,8 +1391,16 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 						     "rtl2832_sdr",
 						     PLATFORM_DEVID_AUTO,
 						     &pdata, sizeof(pdata));
-		if (IS_ERR(pdev) || pdev->dev.driver == NULL)
+		if (IS_ERR(pdev))
 			break;
+		if (!pdev->dev.driver) {
+			platform_device_unregister(pdev);
+			break;
+		}
+		if (!try_module_get(pdev->dev.driver->owner)) {
+			platform_device_unregister(pdev);
+			break;
+		}
 		dev->platform_device_sdr = pdev;
 		break;
 	default:
@@ -1426,8 +1434,10 @@ static int rtl28xxu_tuner_detach(struct dvb_usb_adapter *adap)
 
 	/* remove platform SDR */
 	pdev = dev->platform_device_sdr;
-	if (pdev)
+	if (pdev) {
+		module_put(pdev->dev.driver->owner);
 		platform_device_unregister(pdev);
+	}
 
 	/* remove I2C tuner */
 	client = dev->i2c_client_tuner;
-- 
2.53.0



