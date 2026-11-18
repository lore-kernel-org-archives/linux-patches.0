Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052419;
	b=5Mr/Iop74kZWSja209+biER4UvS0lthbvzBWp67ov/fWgmdmRE0SucvMp9YMJJ41PQ2Y
	 6m6ilDlr8O7ZFfXlQjRFPEhtPFNZIAcWRTfVSM1znSnhnV1TkuGmzav/SwhhujWhkq2kF
	 QQpn1Bl1c33jpYrPtpb9UslX6YX1uke1th5ivSOra+TuFJDfyiOe8ZForG9PZSlWopVn0
	 T/9cry2ql5OtJkkzbdhyX0g6W+YUN4ELFSsyRs9G2zcIsf0oPhKFtYylETeR3KG9KePMs
	 7m3W1ptJIMOJ3K5S/UAVpUelWEemKCOa8G8HYKtYLsk4U77EoIoc7rflXZfbJmijlew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052419;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vbj6P5O5IWH0B4F/OedoesNnRN6PSvBMtzhHQFAaGd4=;
	b=JtBqoV654caNTye9ILbVAlDP5b5oAalMGcWI6LHjYBjoDpK6JhJ1/hutJHYc7RPUsJ2m
	 If8Oy2Ya2sdJqqdDGV+8SITzAqAz92qwAmXcNr4ETc/d7/+WMDWrrDqOWOiWan5nrrpT/
	 11YMugmwM5jBGDjPRynKZQ0TQueGo5+kgcbM+jm7mIlxsMvGCFasBdYjd4UMI1HaRgUVO
	 ui5+KpNaO4uYTbpRsIWc13qOzY+25BFxd7gsfd+jvSqwIlXPskyhwysgivzgILEEnZ1JP
	 YNeMWxpxpTatmYxJ3iUmOkJmjXAODg1DJFDuECTLEixrDcSP5uQw7/8g/6FfmKR2F+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e5IbruDV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F99B606A325;
	Thu, 19 Nov 2026 01:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e5IbruDV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61451F000C4;
	Thu, 19 Nov 2026 01:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052419;
	bh=vbj6P5O5IWH0B4F/OedoesNnRN6PSvBMtzhHQFAaGd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e5IbruDVhGoKWZ1Zgg/piz1EVCjCU42POo2SBA21xQyn4jmyQU3dpM6y7IlvM3SRm
	 NRAaWQ39CEIeIpjpjhAmBU8BN5SgKHmGKU9GH+hXly6Qp63PoTDP3qmfuVXnsikJdf
	 KlI2snte6VXmbEwFMwYnq5floR0sio3Z1PPRXfUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0556/2214] media: rtl28xxu: fix SDR platform device leak
Date: Wed, 18 Nov 2026 15:37:12 +0100
Message-ID: <20261118150033.257339161@linuxfoundation.org>
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



