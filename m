Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829481;
	b=lpARWt4FIBg0DudtolNA76HMDKSreXOp9g19cLTsIPGe3rUBG0zZNMo9q1AvQ94EVBNv
	 EZqXaHmzSaX88wnnPeS93XumjD1vxrZfjOaE5CcC1gVGZhKeK8VhypumsDz9j4fmFz/L8
	 ZpF/PAt3voFehm/OnVoYd23DpIkqJoCWSELW4QgBnaxm6QwNhljcD3sbtw+PF+5T0Ex0q
	 izymPPm4QdHKFI3q5za7Bw3a6ZtPKy/DppoKu9224yZbxbNEy3JeofC3Kw7vWGdMIzakQ
	 QLQc3gijLQ3rdzHuOb2Aa3L9HUv8CAo8YgL6yLi7Itq5rcYqSP1qkRebikzoVun26fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829481;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CH7Abe1upqGphxtSP7O/4UlY7Pd3krMVDD3eQ4oqYNw=;
	b=Wl/3WuneCnoYDPU5lBVEKtKCBgms8CSNcjQ+L39ujWnw7jyiErcMJwMrQutwMjfOhFt6
	 7QX9s/XToHigc9Emilf0UF38QeuAq0z7mYg8XvurjGdIek6VEeSlH+U7BpVk8rY4em/G9
	 DZBZUatNP/Z23fHmMxw3XMG9Qv89RpC7Qv+24pMv2VM/RF9jfFtY/iMt9Ub/q+V6hBez5
	 8YhT3AqF2xKyiucXHLlpRnWeLzdGBhiSaIcjSMmJmju0AIKeKRrZwdqL+OXX8koyra+AI
	 KREYwoB0+FxZJSaikhEgvTeeMFDclRm3957EMVCSnNRKbTCUxfZSY5Ig+PdpLeOZnhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RO6EOkpD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114F86082BFF;
	Wed,  4 Nov 2026 21:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RO6EOkpD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AB71F000C1;
	Wed,  4 Nov 2026 21:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829480;
	bh=CH7Abe1upqGphxtSP7O/4UlY7Pd3krMVDD3eQ4oqYNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RO6EOkpDRuGG1emIeHoNXelaDzfllLQQEW9N5oHk+SplLSoN1Lzj3c0WhhrXL63So
	 623a3InSlLJFu8SvbIR240X02T9SEvgiD4XoHsebkR+GL6pa74gHuVAxbXt8HLKj6M
	 Hl1J4BDJrYfezV/5/bpUQ9ly30jqJELkxEZatbiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0135/1005] gpio: vf610: add missing MODULE_DEVICE_TABLE()
Date: Wed,  4 Nov 2026 15:57:48 -0500
Message-ID: <20261104211047.480416149@linuxfoundation.org>
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

[ Upstream commit 975a1d61260cf74d467f34898fade63165c80735 ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260704122123.73004-1-pengpeng@iscas.ac.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-vf610.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-vf610.c b/drivers/gpio/gpio-vf610.c
index aa8586d8a787f..adfa2c2d5873d 100644
--- a/drivers/gpio/gpio-vf610.c
+++ b/drivers/gpio/gpio-vf610.c
@@ -83,6 +83,7 @@ static const struct of_device_id vf610_gpio_dt_ids[] = {
 	{ .compatible = "fsl,imx8ulp-gpio",	.data = &imx8ulp_data, },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, vf610_gpio_dt_ids);
 
 static inline void vf610_gpio_writel(u32 val, void __iomem *reg)
 {
-- 
2.53.0



