Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829326;
	b=qUGRkSLsoEy1zLvsZsVwHQzkurY0tB7TPnFyP2tNfGkYyRT1XfpCY8z0U9v86q6gerDd
	 U/Dy7gYVszt1QqP8yMwpTVwP1OlIV2W6WjCVKtIxOrtIdaZlNSlT7O2p/7/V9AytG3ur8
	 PsE7mu0J8uyAnfCPNbHlaHCHQUnouLLn6cTJx2MDfa6Ihg2vvv3rRlOZ9z0ykZm9Wfg9M
	 9KQzATDDd8nB/1c2BSPwvLixRKsII/tN7eWgTepQ0urLPpZ5XchZ+9RaPsMHo9QnH702u
	 oyxqHPo9Dod/TEU1hFqYYgRPZfXzLMc/zKCv/MVIfaVSMgGkNRUfyTYaJOq9x8JNO2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Np5lKUDohD+k1I9+DLMmSSdz0/VFQJ4RV+D6Im8Fb+8=;
	b=b0/q+iEtlqeXZyJhvBasfHJ/c6jMlyCAL+f9CInhZv22aPEHuIFfmr+Sc9RA5QWj/HOx
	 RjwQ2xKR2As3fUTi49pcK2pzPNtaSe04qVQTud1XeQg89KvCkdkzugE8J+1uDSiBvjqrY
	 mLcFQdZXTd2RGjtdqhDCdzpioYQe0A6Q/+XqvLnG59JQ7KqQsiZAj8TzKcJtsBR0yFNI+
	 NYsAM/CVXP+bKKc/MPqBAPZpMxdiJu4/J0LWb0cZrdYCm58MBuRqf/tI6U6s6t311oOGj
	 4MGWJpuO2Gs937xxT4lKLQRvhyseC/g9MAQDyjKoumtlb1OeGig2Y0lb/2/uwEu74yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Uy2OH/tj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3D36070AAB;
	Wed,  4 Nov 2026 21:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uy2OH/tj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F5F1F00A15;
	Wed,  4 Nov 2026 21:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829326;
	bh=Np5lKUDohD+k1I9+DLMmSSdz0/VFQJ4RV+D6Im8Fb+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uy2OH/tj0KEuEFrfadI+2Sza5HP4uB0q0+yOxoLPC+HyQfBdMn7oSddvHC+2UqsRr
	 QylCVV3WYFwoZydLCeq4SjIbbfGNVJlbdNMDXYkpWhz+sal3uaLC8FbZ7TWnCyQ7nS
	 dw0m0lI4BloITRGcd3t9v5FAbvOgSH8hJX4oZGno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0025/1005] gpio: pca9570: Use I2C match data
Date: Wed,  4 Nov 2026 15:55:58 -0500
Message-ID: <20261104211044.261242266@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index c5a1287079a06..f7cc3fbf45336 100644
--- a/drivers/gpio/gpio-pca9570.c
+++ b/drivers/gpio/gpio-pca9570.c
@@ -128,7 +128,7 @@ static int pca9570_probe(struct i2c_client *client)
 	gpio->chip.get = pca9570_get;
 	gpio->chip.set = pca9570_set;
 	gpio->chip.base = -1;
-	gpio->chip_data = device_get_match_data(&client->dev);
+	gpio->chip_data = i2c_get_match_data(client);
 	gpio->chip.ngpio = gpio->chip_data->ngpio;
 	gpio->chip.can_sleep = true;
 
-- 
2.53.0



