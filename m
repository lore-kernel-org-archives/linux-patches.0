Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033613;
	b=0RDKkuwhMY4qFpLeGzjviPL2MmTOlSTqD7tm7xu5lYPY48EAqQCPcQQtP11TN29pD4kj
	 g5a9cSV8v0CPJmsaBaHhzmVallW5Ggjh+nEuYYf47Dl9TyfrAu1JaZI7obF2uy0cZ9TNc
	 NRzkrIJ+WNf6G16yj0mCQmjrCrjp1udbWV/c/H1dcjYGWN99vYCSFL7Hs40va9tS/VP1R
	 HLFpIAhn49vPlHhGntSs9GvQW9djAEk5/PwwBGzV96m8AK4RHT/lLCaFJ9EjfVLASVAE3
	 TbLyyzCs8+zrjJZGStxQsHcIISi4S1hd8p2IvU6aDR1mj4VRuDKlG+AjAijOZcMAB4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033613;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GkzJR1zRzysqCtVgnSvLbUz9IMao32MdSrgOHOrUY3Y=;
	b=TUDOAOWD0dMnrsRsGxolxWiyxjGrPdM2axEP8acbWlh5vFrDcc75FvLQS1ulfBSpL//S
	 kJP6r8Ylf8ZRfZ00Ej94/SZq14oTTpyCprb167q8F43mpO5Q9Q8bYuoegAPn/QHpwUOl0
	 yknDR0ngDbrlqtq/LYHsDS8bqCnAq85E69VlThsYs3UCZ/s4/sY9NJb6Rzcyyp14ontXz
	 t8ckJLhNS/1g7ibSJBufldmAB4MiSs/YZtS+v1o353M6hxpKmsWuyLVe94COIdEYFdEA/
	 EyNcQNZ6LmPoEh16iFlyGEGXa1saU687UE41YJZ934emyaMQ1VUO9jiW0O0gDvFk8lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SiyMim37;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA877606A31C;
	Wed, 18 Nov 2026 20:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SiyMim37
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072381F000C4;
	Wed, 18 Nov 2026 20:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033613;
	bh=GkzJR1zRzysqCtVgnSvLbUz9IMao32MdSrgOHOrUY3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SiyMim37WEUTApLWW5MGGlzqsKUC6l9WkBoCPPP+VSDgmdxRnTIQhJOUTHx6xfS+Q
	 2PKHhvSihTqRCo/gORUc4tuU7i6dd0cFh57vyg0skA340R4d22DumdvtD8OOlvZfco
	 9MHDDP/IF7frDxdahADkkG1eIZnwLgMqMfdDJFls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0070/3318] gpio: sifive: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:11:32 +0100
Message-ID: <20261118150316.130310818@linuxfoundation.org>
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
index 8decd9b5d2298..4858353427183 100644
--- a/drivers/gpio/gpio-sifive.c
+++ b/drivers/gpio/gpio-sifive.c
@@ -259,6 +259,7 @@ static const struct of_device_id sifive_gpio_match[] = {
 	{ .compatible = "sifive,fu540-c000-gpio" },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, sifive_gpio_match);
 
 static struct platform_driver sifive_gpio_driver = {
 	.probe		= sifive_gpio_probe,
-- 
2.53.0



