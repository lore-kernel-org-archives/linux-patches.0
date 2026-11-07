Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060695;
	b=2IkJ9Et5Wsgy+C54jSpqGYxK6y3FVXfBJWyaLhrEIk6Toppi3Bn32jAMlIKwbfAKFANw
	 /fZD6F/LIEm1K7twc6aKNCHsqxGdR3wjMHHPD+5UjbPdrIqlFVEfs69jrKanBnDgkHrN2
	 uM8HEsl4thBBcu2ZEvEzvUdsm0zlFldqLvt4t3hTffx8wCH1BW0fDFqmAzm3kTNqRIGNp
	 TGe70SDMI3XKsSUlTyER5Ws52ySE+4/k4OV5EExVnyd234RCqKtY/dVdYPQZsvt90SuJO
	 py8tFxG5aopnCkYsnUOUNt+QUSgSf5Yler5qHlJMDw6aOrnyZviRvbgSwalcv5VPzAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060695;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O3iy1GL9uNBDN6dqsDtgAw6TZbOS4Hz7f+ygope63zo=;
	b=NC/nJa8NHdVFyrS6uJYSegBaczaAXs7nAO9d8KRQkTn34/E+ILEHrGuOkVvho5cU8ALL
	 F1+dXrERw8TxJiTWrxpIFUVL2xE/PIBr50pwTYd1qqEoxhidYlMjxIpna3N+DbURxksgv
	 wTrBsVu0vs6ftQ3rE0Z0Ld4NKgDcJwc95gXsPOOAQYazrrFiF80XQ33XuyMSL4cPG/h4W
	 7FEuYVEMix8S+cY9KuvvG13nFdNBu7b5e7jIjRH98oRh4V67nQbUCC+DFwto0F3hAIoEG
	 tAtNMx4AK3CPOH1nRrWiMjMZRG+X1GkQuFsh7AlcVjnGGw3Q/MiNkYsuU8Mpy3/Or1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ol8zwyGL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45E8606A330;
	Sat,  7 Nov 2026 14:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ol8zwyGL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA151F0089F;
	Sat,  7 Nov 2026 14:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060694;
	bh=O3iy1GL9uNBDN6dqsDtgAw6TZbOS4Hz7f+ygope63zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ol8zwyGLdYbtxOuiG9WrhhJ2GwlIW0lVVHM4cI7LuQ5gKay96q9Fy55cCHA9yWlrm
	 21j4qsvIxHYun57fy+loJms1Z9FlrhJ0G2kJyqFnujgMEvl+vCNEvRKB/Y68fmQUr9
	 qLIaZLH/eNnYlb1Any7THf1O54pyeNd1urnkZM1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0084/1536] gpio: sifive: add missing MODULE_DEVICE_TABLE()
Date: Sat,  7 Nov 2026 08:35:00 -0500
Message-ID: <20261107135000.032857548@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 067c8edb62e20..eb24a927f888f 100644
--- a/drivers/gpio/gpio-sifive.c
+++ b/drivers/gpio/gpio-sifive.c
@@ -258,6 +258,7 @@ static const struct of_device_id sifive_gpio_match[] = {
 	{ .compatible = "sifive,fu540-c000-gpio" },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, sifive_gpio_match);
 
 static struct platform_driver sifive_gpio_driver = {
 	.probe		= sifive_gpio_probe,
-- 
2.53.0



