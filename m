Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052191;
	b=GqWuhqqKqv8VZyJrtA3tTiy3WiBXutoV3b+MJDLotB7O9IqR3MUIEAo5AWFlpGLvwK/K
	 Xv5PWWNI6Fjkz5RgPEmnzfcC1abDMFvf8i/AaHCjqScJV9bfZ3PZ1zXr9HdYOpg5uRNJZ
	 hfKhBem+6oRQvBQz2eaXhpBInC5EGI9Th0Mvurlk2vhB+Dzz6/ot4VVYxoG1Xyb2kWYg6
	 Iq487GC2kIfBHembc4yeqGaeYXb7Cf+NsRk1UcvnnQfR2/wDc0a1ts2/efWcZPQUVWQ1w
	 rIoMHjuM8Ulx2e8v5z7ayQmYhtf3ykiyDWQUlch57g/SDr5cSywhs8QqiQx+s2tiLHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rPZm5l5XE6YXaKATuScNveyDqn+wWj8Ec3S3Y5ddbUM=;
	b=b8YtcV7n8AmD92mYU8yFjmqBNb4GA4LybT8B+FQrK2mNbbcnLE/iwbon0XeJ0LyWHuP5
	 Cmrv/p42IOIsE0+uZHhgBoakVyka7zc33/lpiIssMzgTdxRv5VArCJQNONeVGXoeJ0UZ9
	 D6fCyIORG7OcnI3/Tio8OiIGTysducnliqAxn0f3KP0VKPB8Nv3wsqvxg2bNlJPo7nLxD
	 WKpKgQIczfS3Ql3w1bXXMrcMV5g6ZafTIb9duI6wmDXH+vm96FcO0z4z6xoTLEoKli/rH
	 jc3WIogjvth+LbzlxtlqJxdZOLl0yQpr0afCGP0FpxvkmTeGyI1napT6Ne53qU3XBGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vs6XYmNB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF7B606A320;
	Thu, 19 Nov 2026 01:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vs6XYmNB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB641F000C4;
	Thu, 19 Nov 2026 01:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052191;
	bh=rPZm5l5XE6YXaKATuScNveyDqn+wWj8Ec3S3Y5ddbUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vs6XYmNBB9PaqU5OdpEMTz0avmm100JFKDPGXGE+hhhqOm6EvefNfd3WdvL702nyK
	 jJZWrUoxFiLD4WSCh4qU6tW2xKGDJWgoraxUCikXHAavZnQBtwygRfyBDY3jD/yf7v
	 QIN8joPrJF82NDt5dhaMUHEvLz1CyMRnWcgIQz6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Braha <julianbraha@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0469/2214] media: marvell-cam: fix unmet dependency for VIDEO_MMP_CAMERA
Date: Wed, 18 Nov 2026 15:35:45 +0100
Message-ID: <20261118150029.961770940@linuxfoundation.org>
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

From: Julian Braha <julianbraha@gmail.com>

[ Upstream commit 1179929b3abd4adb6ca7fae91d649c64a7293aca ]

VIDEO_MMP_CAMERA selects I2C_GPIO without ensuring
'GPIOLIB || COMPILE_TEST' is enabled, despite I2C_GPIO depending on it.

Let's add the same dependency to VIDEO_MMP_CAMERA.

This unmet dependency bug was found by kconfirm, a static analysis tool for
Kconfig.

Fixes: 67a8dbbc4e04 ("[media] marvell-cam: Basic working MMP camera driver")
Cc: stable@vger.kernel.org
Signed-off-by: Julian Braha <julianbraha@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/marvell-ccic/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/marvell-ccic/Kconfig b/drivers/media/platform/marvell-ccic/Kconfig
index 3e3f862647624..c342779607373 100644
--- a/drivers/media/platform/marvell-ccic/Kconfig
+++ b/drivers/media/platform/marvell-ccic/Kconfig
@@ -16,6 +16,7 @@ config VIDEO_MMP_CAMERA
 	tristate "Marvell Armada 610 integrated camera controller support"
 	depends on I2C && VIDEO_V4L2
 	depends on ARCH_MMP || COMPILE_TEST
+	depends on GPIOLIB || COMPILE_TEST
 	depends on COMMON_CLK
 	select VIDEO_OV7670
 	select I2C_GPIO
-- 
2.53.0



