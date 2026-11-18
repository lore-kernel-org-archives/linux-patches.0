Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056054;
	b=N2dGoLVP4md9lXMr6XiBo0QopNLOfalSXoIhQWP/5AsPD9FThkp0TwytrXNeZDHbi9PB
	 aQZAjBbycSe3Bmr5wsIU2t3qu7bIykuRN7bSpmjcwH4pdqqXC5tHjpOAuk5p+fHRRoC0j
	 9bizK8pCCG92NmuxIiLDipSevYIqb0lwXSjo/epv04+Bte40jpJBBmolhfxNlK3tuplSa
	 zWq0T/VL3jLsQky0nKypnLdScLdX881oWp3Kq5jBXfKOh1/EWhJOTQS39Ve/6KR/dMDlk
	 RPagBAvxXFyiwVyjDtM9g8c8nh4/hgcvHDVpIi2ZpsqMQNCO3CDsiGQOgrn41VwHdpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056054;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yvSWWPpfyIRrW9ESE9soisCWryNy24/r9nf/pEeZ6Yw=;
	b=TXJOOInjnD38iUevZLlxjpR0CCeNB4EYrEYpCDFd4wvsc8oXEFoCE3eCBZSQJ2bTflIb
	 4djZ/DCPtHWRgRWeix4rpNFQ9MWZK5uxGN8aRiaIuiWvYZut6Yl7dFrzN+hrIXZkUDwYl
	 QakbfEP1JkZCc0qzcVDXOo7GcXRkti6jmcp+bi3g5YdHYwKhPe8lPLlr2oEMmWfR9KVuJ
	 OxjbKjndBUAPYqjfCH2DopfgjG/jQn1ra3VMM2Zcg6yPecIexgkEBzNygNAHCy17AIe/B
	 Gz1OWvOqrPa0OmzI/8/eM8xvLudfhOpIJfk+OowUkz5fZscBoy2b8CKG7FDIGxe6LeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nuQsVD4y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60BC606A320;
	Thu, 19 Nov 2026 02:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nuQsVD4y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B1A1F000C4;
	Thu, 19 Nov 2026 02:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056054;
	bh=yvSWWPpfyIRrW9ESE9soisCWryNy24/r9nf/pEeZ6Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nuQsVD4yk5+6jI+4oOCtD8R68HAqsVoxm84fvJ82Yyn20bJK/oNGEaNN3tbaoaXcm
	 sZ99EE+dMhUP1qI8WddeNvc2wkViUObkdNYBM2RlqK0/fSDAR0GeF7jWahvlKl0Hpe
	 86OxY+Y4lm6kiG0skXu2h77k0YqL6pPP65F4XBJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1850/2214] power: supply: generic-adc-battery: Propagate charged GPIO errors
Date: Wed, 18 Nov 2026 15:58:46 +0100
Message-ID: <20261118150125.391670075@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 36b0abe904ac9cbdce6161d9c7c0bcac963bb3fe ]

devm_gpiod_get_optional() may return an error pointer such as
-EPROBE_DEFER, but gab_probe() only checks for NULL. The error
pointer is then passed to gpiod_to_irq() and the original error,
including -EPROBE_DEFER, is lost.

Check the return value and propagate errors from the charged GPIO lookup.

Fixes: b0327ffb133f ("power: supply: generic-adc-battery: Use GPIO descriptors")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20261009112429.33318-1-phucduc.bui@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/generic-adc-battery.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/power/supply/generic-adc-battery.c b/drivers/power/supply/generic-adc-battery.c
index 6cb697e24db0f..5dc3211731578 100644
--- a/drivers/power/supply/generic-adc-battery.c
+++ b/drivers/power/supply/generic-adc-battery.c
@@ -327,6 +327,9 @@ static int gab_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, ret, "Failed to register delayed work\n");
 
 	adc_bat->charge_finished = devm_gpiod_get_optional(&pdev->dev, "charged", GPIOD_IN);
+	if (IS_ERR(adc_bat->charge_finished))
+		return dev_err_probe(&pdev->dev, PTR_ERR(adc_bat->charge_finished),
+				     "failed to get charged GPIO\n");
 	if (adc_bat->charge_finished) {
 		int irq;
 
-- 
2.53.0



