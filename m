Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058344;
	b=dY9nYbifZ+AiQqcUmR7medVjYdV1MbrcR57aqxnRqp7LDuMbXb3x3YyVFzOA/1qpMewa
	 ieO0NumFSADb9B6HYFcTOjg35O3O60bz/PYd5Han4P2ciJceq7yrVOF0AqTrVRdKTtmsp
	 TTwLDUYqKhl1ArUHeFqpz3QVIAXYcCxoCl/q6LJhiBjwRTRyEJgEbVA0gd67ShPOq9WhX
	 sV7oWAtCIHC/ZOC/81M1DxL+8rF8wwz/iAC8yVpK3L5hK0/CeifJWZ+VyXuzHYUoOFgyO
	 I+99PCJ3Pfvx9PU9heNE+CUyZGyvMMSAcpwGmk1exkOKNtIKtpMss3Vvas69gthEEBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0VxeY4DYaW51fXCUvcKqfVV4dpV8MM/r8mK+DL/artI=;
	b=4fanmjtprtPnYlLe4WibI+Mj3KCamPHYa+oayCraSPeyNdjaGzM1r8RNhp3nvfNqJx9d
	 41nNyTPSu35NkARWtiyn44SytdYB/S3UGMQm+2QRe0n0L6T2KVGRbOhY+xMx20qKKa0jG
	 WuHLCOrlZSQmAKxTZZDBWiShdmK1QMbzYrYEQK0wcIB+uk4bJBdxIdDz8ff9M3s8fZM+S
	 D9o/yj3oiRNrXjd32bmwDl/JWMcL3epzgOfJUZM4ZV/cDTUWTwsMrZwd4+Dk0ThBm3TIm
	 RAW7K/CX1cwrjBwky4RjiwG50+3qM71FWDN/nEXmaI3bNrdWEc+wAjbdPQedmhc0ztQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eJQX1Bys;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052D6606A31C;
	Thu, 19 Nov 2026 03:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eJQX1Bys
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD791F000C4;
	Thu, 19 Nov 2026 03:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058343;
	bh=0VxeY4DYaW51fXCUvcKqfVV4dpV8MM/r8mK+DL/artI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eJQX1BysbpW1VYFgh+ogJSBomV6EC/plGlPzcLMqhAVoq66ruR+vuGV/YsSBw3HZT
	 CxYOBdDoyKX8LB2VCrRUf4pfG55sTvHJotIX9eASxhtzWyBAk3/+39udRruMI6Yz9B
	 XIc9FzMjzrRfMKjsz+Pycn0CuJLixaJ8S+wQUmjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0453/1848] media: rtl28xxu: fix SDR platform device leak
Date: Wed, 18 Nov 2026 15:41:31 +0100
Message-ID: <20261118145933.463254478@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 70a2f04942164..25f279c02d99e 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1400,8 +1400,16 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
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
@@ -1435,8 +1443,10 @@ static int rtl28xxu_tuner_detach(struct dvb_usb_adapter *adap)
 
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



