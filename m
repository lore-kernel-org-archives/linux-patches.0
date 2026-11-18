Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048099;
	b=uLSM/KNIObqG//egE6DejsDf0wmeQnkKXbdR332j3BsquAT0giP27EUaUyiIvRecHfBA
	 EK+KK/52gEdGPdmu7tjvuvJcKAmZguHL5KPc3ELShZVnN5E3TYgRsU73Ulaiwkg07z27J
	 fK4LcWfeI386LZw+g8m9AqMICFwUxcl/N++pDF+oj7sp4VsuBPhoAULm6863vX2IAkssQ
	 rGx+e6eNuTmejoV4PaPVPo5tSWXiQNAqBLYfp5DtIr6LibZSxiroJStHtsFgt5TvOrdaQ
	 SpRlO9Vfy3GO0FjD74kQD9JKJDO1QG6y2lLMD5NFNZNpuCGi5q768h+OhhQvoY2PNrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/aT776YxQJ0UMCADpJdsF+//hBNy5t0icjamk3rgKl8=;
	b=ecLIkqansRAmPiwipp+lfoVfqUhhLdPHOHs7tth8+DTYfrHJlM/Z/bCmy93/HPAsTBjR
	 2hJOc3QiRl5wYpbbI63DC26D8fvb53b25LRgln2qJ9tR+MLmgxvCkQP8sokr8U8AWOL8P
	 814y444dNU3MAO0j4RLmn5Cgm+WDRNpkTquhtuLcKtH4yzZTWsYuxagUoizK0541YsRup
	 GVP2iVnRoaOiSeYIIBQfBzeTcf7+aIfvlP7yrhtQiAPsvWhdZ5Ahku/WnnH2fHZi5VMSj
	 xQDpeoFT5lFgQqxSmOuuuWMcBbK65UDFgrj0FTBpefNKh1ry9nPyBMR3FrtOtnkaxxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L3o0qxB6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFC5606A330;
	Thu, 19 Nov 2026 00:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L3o0qxB6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845661F000CA;
	Thu, 19 Nov 2026 00:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048099;
	bh=/aT776YxQJ0UMCADpJdsF+//hBNy5t0icjamk3rgKl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L3o0qxB6TnG9Cgx8b/zdhBTzs3VwTaCDD0KAgyvUcMCK62Wt7GymLionrGTMblmc6
	 z7oJvzUj1p00B+gG7z/iEcNnCTzhWijuFxy2tk8gPYZ9G8inxhqhInRuJn8RUh25pI
	 2XXRsi3DS6mWvCsOYrJy1uAHvbmCeXCOJTs/s7Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1875/2857] usb: musb: da8xx: depopulate OF children on remove
Date: Wed, 18 Nov 2026 15:48:29 +0100
Message-ID: <20261118150308.744073381@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 4b30c89fb36924983be652bb24fc49e20390bf27 ]

da8xx_probe() creates CPPI platform devices with of_platform_populate(),
but da8xx_remove() unregisters only the separately created MUSB device and
the generic PHY. The OF children therefore remain registered after the
glue driver is unbound.

Pair the successful population with of_platform_depopulate() during remove.
Unregister the MUSB device first because it reuses the parent DT node but
was not created by of_platform_populate().

Fixes: d6299b6efbf6 ("usb: musb: Add support of CPPI 4.1 DMA controller to DA8xx")
Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260813153353.42817-1-pengpeng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/musb/da8xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/musb/da8xx.c b/drivers/usb/musb/da8xx.c
index 1aae581434647..2628e056d319e 100644
--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -583,6 +583,7 @@ static int da8xx_remove(struct platform_device *pdev)
 	struct da8xx_glue		*glue = platform_get_drvdata(pdev);
 
 	platform_device_unregister(glue->musb);
+	of_platform_depopulate(&pdev->dev);
 	usb_phy_generic_unregister(glue->usb_phy);
 
 	return 0;
-- 
2.53.0



