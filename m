Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045224;
	b=QYa+LPkTq1StHMOZVvfjWKRHJiIytilAP0L2YdFe3KQj+1qJST7U8Q70rxSAiFCJJID2
	 SFJ7jQXrgcIGVTqCvw07/7qwunC30CMbbK6THTjwje/E7H0vWESj8X+RiaykTUnHerdFC
	 n4U3wJbHi1vOwhe4OSlJo2LBz5iPfUQQRulCmVn9rg1NCtIeIc36iX33ykH5T+evJS6AA
	 zWfrWAEvYPhQlXajq+UBDcdF+Scb+fsynzOGdJIJovf0hcklE6u1LW59VKkGXxNWcw+hb
	 3xJvGb3AbFnDrUdc/OA9NZxRb2CJeLOG2nXR8sFXrCGiAnEaT82KYLPlKW+CLsnIVDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jh5HHQHMncjsA9n8gF1ieaFuAbnDeh29VWfm7MhY//o=;
	b=JARewrGQykEpWZJsLozXVe5DFqzMqXsps3t/FduTnqD8X+6tYldL/81r0R0ikSOoCNIj
	 83DOyutFqoO/mWkME4Yp5R37kfRD4R60kkxfJFKb5nQ//a71yi+yw/07SQ0NtRKMnr0Vh
	 yX22B/wKLzyamOVfPWUyoBN6Q4MuTEgla2jRF+WXSzblTBu0KSncXpCES2zxk7tuiGHo1
	 kK4BG0bRtUofwHmUhcUw7N3oggS/Ouq5bjc23agayzhGJPQIXJiXfs3zkqHXsxSpGuhp3
	 GNG4NbC1Ok7G5A28DGAC3xhS4xnaFNENa1WBebw1IR90OnXoKW+o2NhhBrMDERychZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OhtIYh5q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99507606A33B;
	Wed, 18 Nov 2026 23:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OhtIYh5q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9791F000C4;
	Wed, 18 Nov 2026 23:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045224;
	bh=jh5HHQHMncjsA9n8gF1ieaFuAbnDeh29VWfm7MhY//o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OhtIYh5q3IJNLzx7kj/j1ibcOMkpWVRJECEf1wl3Vmsbk03S4HtLx8Pn9rjf7BL3H
	 09ajKkkpbv2LDj6I0cd03+4fMqXwUZEF5LX73xxn6mz7gp97LcPGtBgmJOUfhsEscX
	 iv6LgGCtaMpJeedCvw4FpafSNq9ff9n1Z9WI6CuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0848/2857] media: rtl28xxu: fix SDR platform device leak
Date: Wed, 18 Nov 2026 15:31:22 +0100
Message-ID: <20261118150232.106500039@linuxfoundation.org>
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



