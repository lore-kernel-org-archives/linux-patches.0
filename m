Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058125;
	b=uIBeJQbILRLC3S1lKPStRftf21s+rOQ+29wo4ZNwPW4X1jjuZnLZfU8VgXkZwk4P3kje
	 BaU5t2MTN8BYuN6a+NOrDGL00z/caKti8Yg87rL85L2GgpMcc2r/HmTXe/T07/1XF0JX1
	 0f5kdWenVcCuz80dU0UK4nkJLuzkgg7lp4mrYe37+cb6YGuxE+Ni4ax6J1UcsvW0oDciZ
	 jEeIyhpwLPEWVJdW+TXOuhzqUX5RSkloDOuSMHMKT4yOMq9WALYLYjmkTyMsh+aKz+Mrv
	 U4xhd27E4SjlpnLxj0Gfg9jsCl+4k0Kamj2SAE16bPhbKP0NwwmzLRCpFB2KPKozfiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iJvyXh2BTtMvF5gMlU0mCb99vBKuTTD02mibVsMCSzc=;
	b=S++NnYYfH4yZyAyZoO4W5FD7ZzoebMXAWDX7XoCpKbhnz7olICW1JXb5hDhD9p6G+4aP
	 Gbutl2ayS/Cgb3fdZczHQovavZHj4y0ygYKfkdJSUBmdV9vZd5VrLb4Fl9XWpOq4QHY7p
	 nftmGnBAU08wT/Q9zMOWGQDvv9rpmCoa9+4yxxovV9TJi/ZA/sI0zEDfJOnitygxPFTfW
	 ym5bYy2N2EbnsjmqlFv73dMqnnNeDD/4kFT9dPO7BPHCJncj042ZrOpbBfWWL4XDeyGZl
	 Apv5FU2g4k11PZ2IjBsadnfdCOCe+tKstd2ziWYUa0SUoIeGn0lWsl+DeqqRPGGoYWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a2oCXd2h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241E9606A32A;
	Thu, 19 Nov 2026 03:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a2oCXd2h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C611F000C4;
	Thu, 19 Nov 2026 03:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058125;
	bh=iJvyXh2BTtMvF5gMlU0mCb99vBKuTTD02mibVsMCSzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a2oCXd2hDbzwGk5Qa/jx1kceBb+lPlcVMA2+mPCArzb4BtCOs9gXvmtKxTGYJOZcx
	 B+CtxDVS2y65rO1dfGFOPd/RZP37pERnGt/IQ8n8Y4CQVrP5nwyH0xkpUWY5nbydL5
	 HYkc8B6wG5vTit9bVAyTufus11SogjbY3GsseG4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Braha <julianbraha@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0374/1848] media: marvell-cam: fix unmet dependency for VIDEO_MMP_CAMERA
Date: Wed, 18 Nov 2026 15:40:12 +0100
Message-ID: <20261118145929.122538418@linuxfoundation.org>
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



