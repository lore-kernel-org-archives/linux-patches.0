Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043013;
	b=BPCNUHD5IBtrRf6WrDfXb7+46X03Tb2iC7P61WxOGJPPevIQ2e2gLLtY1Cw1p1mJrCwh
	 YqNIDeOgLJX9Ariwjlp9XGXa/anr2rLxiIICOKMOlIkjHFrYoD6b47pdqpHKg0gjF+8KA
	 YtgUTCwfjsX3q2y55CBsbdDXujfUyuuBqNGH64VMlwJjLy9pmte+10TcVcJR4Bn+6SE9j
	 zAUa+ZkttFHeDFvwWoArAJGJilXrmSEsj0ce77ySa6cacZNTGGklDObyXatmuk+gPX/fO
	 4mmEI+W3Rfq6FD1ZM3EGIszCiHbPjNTRBoyGCmukzAhTY/4U7xF/PbfO6wLJqTX54Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fH4OQ3JzzH1JM/qC3fq5wmaQe73OXh/dHF/qjP0Q6s4=;
	b=v1RlhTETYQagVJLSeYM7Q0Al97+2TXyjtGh7umDzvQQ7HqoRxsaI8k5/dFTIaSO1iSTp
	 FFV1GHvAL9WdTNiff95cGsMirBOZrzQxdTZBeRd1g9slGoDV3qFS0aDSLnAf9wOYyutIV
	 vHHKAWUiUw08wE4S8HF+DasyvXdbEzVoQLlrlheqh2bjDlbEpnE0mtTn0REnuxOfjJTT9
	 fbUg06cesParPL+f7TtcdxexVxRnIbOouftBcvQ+2Y5y7L/MjMmbxgM9C/aax81PcdUPK
	 j7vp0TObC7znFaCSUxepmr0cxyVRSP3Kg5BuIoZL9A1foisXCmVOtrXbOrsDzCNKteg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=caMDBpFt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F73606A32A;
	Wed, 18 Nov 2026 23:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=caMDBpFt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D853D1F000C4;
	Wed, 18 Nov 2026 23:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043013;
	bh=fH4OQ3JzzH1JM/qC3fq5wmaQe73OXh/dHF/qjP0Q6s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=caMDBpFtxpraxpqBrKmseJsw0JyKYhdxnhDaiztzA3cyjqOVTbt/tMfv1ImzkHoNh
	 12fO6snYy4GCicaq53DK781sZgkpxC5hynbgxkfzqhoKeXvi++bn96zF++tAfCUWsy
	 FRkKjrALtInb+v371qClvElTagbWGyddo/nljA2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0057/2857] gpio: sifive: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:18:11 +0100
Message-ID: <20261118150203.358844206@linuxfoundation.org>
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

[ Upstream commit 8fe6fa0f223f44b8b869319d1b9c383749aa147b ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704122230.75964-1-pengpeng@iscas.ac.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-sifive.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-sifive.c b/drivers/gpio/gpio-sifive.c
index 0f1e1226ebbe8..7e0d72250cfab 100644
--- a/drivers/gpio/gpio-sifive.c
+++ b/drivers/gpio/gpio-sifive.c
@@ -269,6 +269,7 @@ static const struct of_device_id sifive_gpio_match[] = {
 	{ .compatible = "sifive,fu540-c000-gpio" },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, sifive_gpio_match);
 
 static struct platform_driver sifive_gpio_driver = {
 	.probe		= sifive_gpio_probe,
-- 
2.53.0



