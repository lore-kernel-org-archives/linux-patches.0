Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026244;
	b=IHVznTRZp8rKzgiPJYmxKAqGzeLlGcodtQUMSLqOopU/vP5UGemx4uoqezlGHtIAiA48
	 SYKEGNgdXgrDoEAl8ogZVe10G5WKV6sMKV1sOL0tkb4cAhwpCiSMq4qhUC+xBbQHoqDhX
	 7YVxPJA9uJV/1Xa3RML11TejBRKff4wq1R4DzCapXwEFSkw3BNnotVwrQ9Az0GLUPfw2X
	 TUxphX/wPZ2XR6cGOr6PHxeojGXUKlDNp97eUngHh0QmGXnVwbjgrl1HpZNKAkyBq+Mei
	 zn9AvMWyVAp9e34j2u9+CkWhzvrifv1CzHJ/2f8HZk3Z9LTFYdTSNxC5ClghacaiAxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026244;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AYhU+yQKQzBWvoeZOBOLyFeSC0glnkbjDr1VpAFwJI8=;
	b=cvFjIWbjTTOGUA6vzjnqol6jlkYGxh2ff2nqJwzAlzXMp14bDD1k7oxYIz4g/cYUm16E
	 FB082/ly9kRH+gJ9xR09VfogkeNh4bv3fIe3an7z93jSkxwqWQAVFN2fPyRLicyICa2eE
	 PEZP4P9PqxrrBeWFKmb9rImRJVwS1l4BJ66UV/ZGc8jfjvlTkhclxJK5fjIo7bXvIpkWm
	 hnts1OCTGwB1NXCtc6tf9tgHu4ODceNopCd2n0QwnSfrPTgDsG8u0DbCzy6WOWYlPok7r
	 nzhyNGotFfyvCeTKkfg8xkUYT9h/LGipFM+rWhMUq0xD/Y9aPemsN0g8xSa4ife73Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i8c3qDdM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6305606A320;
	Wed, 18 Nov 2026 18:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i8c3qDdM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9481F000C5;
	Wed, 18 Nov 2026 18:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026243;
	bh=AYhU+yQKQzBWvoeZOBOLyFeSC0glnkbjDr1VpAFwJI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i8c3qDdMs6G3eRm5gABnvW/D51+0puma1/Rj9xB9Pj142lByrXb1asD9RANv+rCuB
	 0jZ0v/0MaiIOhW0wegjHEtuUKjneuW63iUtuZu7ADkhGtSpURqSR3KuKuteVH2Eb9+
	 GZ/SqO2lLggTuhu4NdL26vCSw5Oz4KjL+AdyxYRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1365/2151] power: supply: generic-adc-battery: Propagate charged GPIO errors
Date: Wed, 18 Nov 2026 15:51:40 +0100
Message-ID: <20261118150211.746213775@linuxfoundation.org>
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
index df5f91bc1d0f6..b1a29b04a6f0c 100644
--- a/drivers/power/supply/generic-adc-battery.c
+++ b/drivers/power/supply/generic-adc-battery.c
@@ -243,6 +243,9 @@ static int gab_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, ret, "Failed to register delayed work\n");
 
 	adc_bat->charge_finished = devm_gpiod_get_optional(&pdev->dev, "charged", GPIOD_IN);
+	if (IS_ERR(adc_bat->charge_finished))
+		return dev_err_probe(&pdev->dev, PTR_ERR(adc_bat->charge_finished),
+				     "failed to get charged GPIO\n");
 	if (adc_bat->charge_finished) {
 		int irq;
 
-- 
2.53.0



