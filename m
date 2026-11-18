Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033488;
	b=DFU8dI3JLUk2mJ8a2v/mrJqeUl4+7G8nPtOcWLtKRSAvC/KkUUcEf654iyNR/zkKwccf
	 S5ZXmMcmayPRHcs/icD2/nUTbJRbEAPwHrIcqrny5VNhHpiw5jMqcewxbZvTP5MKLcQ/J
	 28cePF28AkXOv/GJxwTc23uxwH9GH31tsGK03yoOaa+Y55MveX1TSeR3dnhSwNFGFbOPH
	 9wvFwUDc3jvSDcUHjFWKhP+m/du/nV6QiyL3m594mH/K9qivLvYLCCWSg88UGJ7i/P+ZH
	 xbP6UQSj4JuEpIX2CfkzUWFLdQMH5ryYROJSacD9pmaaT5uGnDgBcIxQDqhsnB3HHrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033488;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DFvTwdoVdl4gdGLOZWT3q6aHOBcdMWPRYIRJApY12Lo=;
	b=J5N81ZD0mqB66UCFfCkq2ueFfqYpPIBxzmuJLMkP6Lxwg8ex9TcyCTJr4ntD9f/xhjtX
	 ty3IMpReXxE9AYd8BN2XR7hX/JyUjyrkIPxqn/bZYg3ySK4wSkcGXJ5ENY1tL9WcxBaQF
	 kcFVnJBcsxrIT+A+JHmXUQyayZ2/xiIv7L2lRJ5R1Dw1XmeoQOX8xTY79xJNNKsoL2T57
	 DRUcoNg77MXEc9NAc1ZquHK/L7EVPpj6sdW8ZWffxWRGQVPPjpTMkWfhSQ6SB5NDnrxvl
	 ncl2YV+zwPxO/gjPtbHgNsFpshKSd3jWp5kf8Ea7+9t5GlumHj+HRfoTFSiNm6Pe5kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mwazlEHw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40D9606A336;
	Wed, 18 Nov 2026 20:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mwazlEHw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BEA61F000C4;
	Wed, 18 Nov 2026 20:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033487;
	bh=DFvTwdoVdl4gdGLOZWT3q6aHOBcdMWPRYIRJApY12Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mwazlEHwaZ8kAO/9GzM7bgIMdH7glGdHdRDa8kGj3dmGlSw1COVoRFM7b9Z4O10Jl
	 23+qrMLxEU+aMAqSjU2VsKkCCfQeBjNPlPPcVCJbh/UW44nLBMQ6GR1674+v731Ubq
	 X6k2Ju/jyVKel0D/2l5pW7LqVA2rSwTB5au/bNUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0025/3318] gpio: pca9570: Use I2C match data
Date: Wed, 18 Nov 2026 15:10:47 +0100
Message-ID: <20261118150314.509192702@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 415c63896b76fd98883e190bc7518383cb01779c ]

The driver stores chip metadata in both the OF match table and the I2C
id table, but probe currently reads it with device_get_match_data().
That helper only returns firmware-node match data, so an I2C-id/modalias
match can leave chip_data NULL before the driver dereferences it to read
ngpio.

Use i2c_get_match_data() so the I2C id table driver_data is consumed
when firmware match data is not present.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260624053744.72612-1-pengpeng@iscas.ac.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca9570.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pca9570.c b/drivers/gpio/gpio-pca9570.c
index d37ba40493683..29fd67ca41268 100644
--- a/drivers/gpio/gpio-pca9570.c
+++ b/drivers/gpio/gpio-pca9570.c
@@ -127,7 +127,7 @@ static int pca9570_probe(struct i2c_client *client)
 	gpio->chip.get = pca9570_get;
 	gpio->chip.set = pca9570_set;
 	gpio->chip.base = -1;
-	gpio->chip_data = device_get_match_data(&client->dev);
+	gpio->chip_data = i2c_get_match_data(client);
 	gpio->chip.ngpio = gpio->chip_data->ngpio;
 	gpio->chip.can_sleep = true;
 
-- 
2.53.0



