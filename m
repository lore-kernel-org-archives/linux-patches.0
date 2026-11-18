Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049510;
	b=q7V0FWy5n/gklnCYVggDnNNwbmlTxX6P8acMBtp0UObJ4xJ2xqbXR+bLpBmBRDmiAIw+
	 fJvnzmGsyXPw9/AfsoLqp47rQLQ+ykZ7aO/EgqE7bIrgHv0tD/nBqpzVWv66rgXIh+7OG
	 to/jxjuYwPQQ02YSaIhcdTdULsknI4mHStOx9BwF0T1K0EZHpsGmbB2ffC/OG0JL/m7cZ
	 uCzflGmfFUp4ZHvX7deogv7Uve4E+6+GPSKLwno1DhkqA6/UXGVhcMODCIdvlo+yKXr9p
	 gWgJSk4MELB9nXIvg3nLLlptJ1A+mHDhsIttLoLNxFx5INbJ8nxf+3wCsWLwcTqRCsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cuzlfTvhjPwp4E9YbjUNC7GBKcglEZFxMTO+iagd1ao=;
	b=bQ3krIJudi/CsYVhK0k6jo3GY9Emj6AnLAvvMU8gBCcGx4wSvHs59UIkb1azrOi9qnZx
	 rFZ1ZaxBRdcQaMSz93/OWgKVGIf3ExXrHfLct+yaw9xMiIbEDSFStrDZzDiE5vznyQB0x
	 utXgpI9t3WnXxdvWV1/SKAToQnmEirIwZozCG+j8eUhZx0/u4gSXVYi5OyH0m5+9aMsJD
	 IVFmHAmMmr9PwELbcDO8UAEmLInCWAYWJ8oNFdftEuy9u6b3hzGxISydQKJLU33XHi6jW
	 7eExANsvkPnFSOmA9uHiuyAPWEa7suzVolqp1iIJNigO7vFf3L3cyKr2J+iVYr78ZrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hsOu7R8k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E89606A320;
	Thu, 19 Nov 2026 00:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hsOu7R8k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D50C1F000C4;
	Thu, 19 Nov 2026 00:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049510;
	bh=cuzlfTvhjPwp4E9YbjUNC7GBKcglEZFxMTO+iagd1ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hsOu7R8k51qICUvpN6NiVZNeVDSDprjpdTKn3PBN8D8GY7XXfcJcyQ1Xx1jg+6aoR
	 7h8XQ3XAuOEFP4NRhEtYYVth5rvJH81DDyVpTl5fnyVoFEVCbVOAT/H95ZOEZs3M4F
	 8gITlcRWJ2i5jSkRWLuF42pcLljRI/cj/4ZwGCsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2378/2857] power: supply: generic-adc-battery: Propagate charged GPIO errors
Date: Wed, 18 Nov 2026 15:56:52 +0100
Message-ID: <20261118150327.149906950@linuxfoundation.org>
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



