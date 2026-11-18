Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024985;
	b=kWrKoX3wNsONaQkiCqBAf6MFLvA75KAa8ZQNAKYu/c78MmuuRPYWi4laYBuXk486HezW
	 Nv2cs+4wzIeJxlOwWpOttdfYc0nhcMYal6GrTBcv6AtJNMoKEuP2CcZQRj3LgKL+NykLf
	 ZFY06DmnOBcRhLC8nNBh5m+hG/CRQUmEAPMrnVOhBvEZAgJSEeI6OSUM+gaxCMmCPS1UN
	 Eu4i6kUGh941P9y77N7qGNPq/t0fkO3fke8TqtpJ2MoWgbo5LHGhdsPVdlA0nz0UABBSP
	 U083o+sJnUcWRcpkbC7ojOj9N6556a4rcgXAAyuWTCxutQgKzrFZYA0xcV7Jio2GpbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EcHR64txHU9P2+ysK39PbVLqDwfDVqwJztSmdszABns=;
	b=odniXxP0YcbJUUwNAlTTM90WD8TmbZqiDwInQb2KQGuWoddh6NeUiXGrUm6rikTuuBWD
	 rXpFfgjHOwVkSLg1PMFr00VOFGkyzZTrulzXZK7+qxeHiFaD2aXHLkPcSVBed3uMSNiw9
	 xoWLnA+iF4gyKpP1+aVNce+Zc+ZxqUmbjUy/MdkZdMTEfoU5jas7iRzSBRXFfCf/WmX9d
	 JQNGRmRPs7Vr1YabKcrGpV5ZSeGPHlRpxA1G2tMmSX5Tj230ed4P9jy3Qguj6OuICNP9f
	 pRdGWSC8YXV891hTlkXyre7Tk0NUnvt87NoDaSAvcsvRl/9XFtVilL3F/lUbR3k7W8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nFp6F7dl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1B0606A31C;
	Wed, 18 Nov 2026 18:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nFp6F7dl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EC81F000C4;
	Wed, 18 Nov 2026 18:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024985;
	bh=EcHR64txHU9P2+ysK39PbVLqDwfDVqwJztSmdszABns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nFp6F7dldYx4vQZ8b4RXrXU9zo8vmjgNSTFq+8qQhomOOO0nT4OICa/Frzq9Mao5y
	 azC5i7mu5O03xCfRt3BuDa7CMUy8jJbAcHHL4wDhkmaUqWgoDMQaFzSmEmcuEtr9s6
	 9RHHjTPEsYL1EFQ8tE063OBI1IcGCjLUzUCsNfxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Dalin <liudalin@kylinsec.com.cn>,
	Linus Walleij <linusw@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0920/2151] rtc: ftrtc010: fix clock resource leak on probe failure
Date: Wed, 18 Nov 2026 15:44:15 +0100
Message-ID: <20261118150155.972390994@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Dalin <liudalin@kylinsec.com.cn>

[ Upstream commit c60478875a445dee1206aad6285c18cd8c91f7f2 ]

When devm_rtc_register_device() fails, ftrtc010_rtc_probe() returns
the error directly without releasing clocks obtained via
clk_prepare_enable(). This leaks both extclk and pclk resources,
which may prevent subsequent probe attempts or module removal.

Capture the return value and jump to the error handling path to
properly release clocks via clk_disable_unprepare().

Fixes smatch warnings:
- drivers/rtc/rtc-ftrtc010.c:189 ftrtc010_rtc_probe() warn:
  'rtc->extclk' from clk_prepare_enable() not released on lines: 183.
- drivers/rtc/rtc-ftrtc010.c:189 ftrtc010_rtc_probe() warn:
  'rtc->pclk' from clk_prepare_enable() not released on lines: 183.

Fixes: fdcfd854333b ("rtc: rework rtc_register_device() resource management")
Assisted-by: smatch:2.0 [static analysis]
Signed-off-by: Liu Dalin <liudalin@kylinsec.com.cn>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Tested-by: Liu Dalin <liudalin@kylinsec.com.cn>
Link: https://patch.msgid.link/AC51B5F2C5FFEBB0+20260827080320.3351155-2-liudalin@kylinsec.com.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ftrtc010.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-ftrtc010.c b/drivers/rtc/rtc-ftrtc010.c
index 02608d3784958..f398d6dc85ae4 100644
--- a/drivers/rtc/rtc-ftrtc010.c
+++ b/drivers/rtc/rtc-ftrtc010.c
@@ -181,7 +181,11 @@ static int ftrtc010_rtc_probe(struct platform_device *pdev)
 	if (unlikely(ret))
 		goto err_disable_extclk;
 
-	return devm_rtc_register_device(rtc_dev);
+	ret = devm_rtc_register_device(rtc_dev);
+	if (ret)
+		goto err_disable_extclk;
+
+	return 0;
 
 err_disable_extclk:
 	clk_disable_unprepare(rtc->extclk);
-- 
2.53.0



