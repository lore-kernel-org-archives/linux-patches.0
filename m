Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064325;
	b=txF/nMhQdpkSWBJEBuKrva2rLDa5C1wNjEArgqSJdfkMZMgw3x0r8FsYBPPefZFshWsc
	 FMnQldnvp/fGw3fxxyCo9BZPcdFbvUBBj4jcODCkSMf8JUXm1jf2bHGSoV4tzX6MTAp7V
	 FlDgwKE8JLtsR4f8eWybBKr3WCxAv96oQBWXqWPOdrZVTifmt80l4PsDH6sGLYePJO6wC
	 RThAQ9M5S6dRfGnnfBcPGhU+V9SxF8XHkMMokdjcajnLzTQRYVVoulJDifi2GZPnATzce
	 xI3fWotJZDwseSdwpctIYmCyZ+xTISVAuai9F5ZPPfXNyoRsaRTXYQo2L7C6G2SBQNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yruELJ+lbGBPRXv5Y3PlT/nd7PXPxdAEZSkVw/THFwQ=;
	b=kFrf3GMYVXQcwGslDUlFdnJhRhKB6iFYew15H9wa5S2wcPtE8Eot8oE2wpdi3pxPXNeQ
	 SksvaE5os8kzUxR6u0ZQznYrD+CYacnMR64SiN3ygnSSeDM+gNe61Cfc/HrJfSRvjrqNO
	 hFBl8vZ0qLQgg0mhwJoXAu9boFysh7L7Yx6nutQ5NMMcmhu6aHno/+cQtYKyO7BveBHwU
	 vpHOfez0vJt/1Z5g9/Cf/2MyyXHz90oryl8ng1FaF554+747UdMwtbOYomVw6yJID3Jzi
	 G8az/LuLQPqdQhu2yiOqGpDRntcy380agdD9qIqBc4N+z37i+j3GU8JhX3Zx+ssHNmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rQkfNdzT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698F6606CE4D;
	Sat,  7 Nov 2026 15:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rQkfNdzT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163CF1F0089F;
	Sat,  7 Nov 2026 15:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064325;
	bh=yruELJ+lbGBPRXv5Y3PlT/nd7PXPxdAEZSkVw/THFwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rQkfNdzThGDs+4RMU0HD1QHuc59MzLQKBAb8ExnjZqpYK/h3+asG2LGbfc49a9IU2
	 QjF3Cpv+H1H7EKDFC4C/xAlLa8YvxAYqbAlFBH/aPUNV9WgsTHmqSKno92bPmJapio
	 p0p4aHghLJXtuMT3Hiq4DI0hCMYI7KOkrBYju2Xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0412/1257] media: rtl28xxu: fix SDR platform device leak
Date: Sat,  7 Nov 2026 08:45:08 -0500
Message-ID: <20261107134950.895093482@linuxfoundation.org>
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
index 487c6ab784abd..d2957e4bf0173 100644
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



