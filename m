Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057696;
	b=QVG+H/eaY+rAagpdHKmcE2sKpXs1nbV5/62LFB7MDhoBBYM0EeKF87mTn1AIy5XJsEUa
	 /CLIqABDU+znSIxD72wzIytu8er/CI11FHmcUFFFJBKCsGmLgScoMsZFrNxP7huNj5rrN
	 tX/IOwHAdsYPUTgnEyxcqhqDmo/tAYlOEju+D2mtH5LzUhf4zEDWfaC+0tWAz/Qrv7xXb
	 F/5KzAWXETTWcbpkO3NpN7B8UH32bROvPZd9WAJBe09VesdTvKHw6QVgUtIvfTi8T+cOa
	 pRcJf/Ogyd8s2vxJz9HXSZmCOHPMch19iSTC7M13wmX1pWbdoo9xlDXHel8hHD63p0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057696;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wKw3EUYC+Xnim9ASNC961IWbnNHldG7NIaXUcjcD90A=;
	b=XPuqBXfZr/8imrhUhqZP6fyeFz6PtreIA+mKTDR2z3ippKWOxBuauKxn60iWkN9Iyp5H
	 xB/fV8etsyDdxKM7yjM1PRoHferI2uBUDPOdc/ldnIzw6SgRY7WCpSxM12dTkMVofK3Dk
	 kcIDwarBEgIOeIT/A22gqAoPJGIcEVVBZom6V7i+1fKMH3AXEFgug0hcFwbh1hxoA7HjC
	 JMq/1h4c0dgsDyI+cM0Ao3nfUZhPq0bQ1u5UY8jnkMUhoNdlMFkDBnb10H9pvW97sS4K8
	 SoVZoj5He9p47vPMIpBQJfDsCqZcIH+IUyXUBEup72mQFvBYuOoMVT10BMWTb8FVxgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0XuTUYLz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C08606A32C;
	Thu, 19 Nov 2026 03:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0XuTUYLz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317B01F000C4;
	Thu, 19 Nov 2026 03:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057696;
	bh=wKw3EUYC+Xnim9ASNC961IWbnNHldG7NIaXUcjcD90A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0XuTUYLzYCqWi7NgT/OIDzLpahDWzuAKugq9aPYlhw1yFYzhjv1c5ONz0gn0HuXtz
	 tbwXFo0aTk6jOnfVNz8LDTJGW5ULHdMTPj5Ic1ZtDWok6e5dikrWdrMnfwNZaLtRAO
	 5KGoU4i3t/HfhGZm3epiYQDa2tmOwUq+o0PRCr+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0182/1848] rtc: brcmstb-waketimer: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:37:00 +0100
Message-ID: <20261118145919.202816978@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 402c89d28fecd28652a4bfe997f08f6544836381 ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704121734.54941-1-pengpeng@iscas.ac.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-brcmstb-waketimer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-brcmstb-waketimer.c b/drivers/rtc/rtc-brcmstb-waketimer.c
index 4fee57c512802..574b37edf2b98 100644
--- a/drivers/rtc/rtc-brcmstb-waketimer.c
+++ b/drivers/rtc/rtc-brcmstb-waketimer.c
@@ -311,6 +311,7 @@ static const struct of_device_id brcmstb_waketmr_of_match[] = {
 	{ .compatible = "brcm,brcmstb-waketimer" },
 	{ /* sentinel */ },
 };
+MODULE_DEVICE_TABLE(of, brcmstb_waketmr_of_match);
 
 static struct platform_driver brcmstb_waketmr_driver = {
 	.probe			= brcmstb_waketmr_probe,
-- 
2.53.0



