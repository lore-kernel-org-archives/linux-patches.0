Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023454;
	b=ImlIq5dp4BFOENzGLLk/yswnF3zKXQ2rcGXRpDHeK9S4Jaq1LIO0YOcdcYAepTCT2pjy
	 xHQ1zmKzgN9UPfG9kPs/iKCFvNgnPa2gH/dTyba88zlE/X8a03zdppKLd3saTifIOhz3e
	 J1p3Hfakt81Fl/OSTkAvTVCDkppNDyoixmTddC5UIN/XsupL2zL9tmqyZipPGw4LJGdOc
	 3adayk7RGHFWF3QwyrxDzTjN52BBCoGuMMj+DlBLxI33GjPurocnQQfhZlQ/ZJkCXyaUT
	 LGVCr47F7AlEew9obdluxk6lyh5h/VEFUreidLHefEZJFoixE9d20InlIHpYBWLyivQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023454;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IG00sOYUfu9+iHp+uT1nDjgv/IO23gfdMI4oeX+bWe0=;
	b=Kz3ayacDS45aPaHtxaOtamWXT28JvV7gf0o1XGL0zeonQcuVGqAEawocEmZFy+f/U/+C
	 TOGmU7vHe+boPn6k1HXGdGaugI8W1m2wO4Y0U7853Mz9WINCLLueIik91g5gufLZWhJRv
	 9M5Ks+P1E0kbaeMuuppx/ltkCrTfnInGBAzvolRsjweAsKxwx6RXo1Vb6UYAKIEysA9zd
	 AGolZLBK7fCwKeqhgXKlo6Teu/HfFkwQ0+YfO/kQfA7sdrhxzCUERslkv9AK5MfTc6P/P
	 ItqUYENvcfkwB4HGzm+PNaTmEbQ1dSwyXIP668ApWWucvNhuonLfTHihoIwJgNerBsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FZhfkDAz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D531606A32C;
	Wed, 18 Nov 2026 17:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FZhfkDAz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6065E1F000C4;
	Wed, 18 Nov 2026 17:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023453;
	bh=IG00sOYUfu9+iHp+uT1nDjgv/IO23gfdMI4oeX+bWe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FZhfkDAzA/0iSAyMFSiFRydIExQ7vYoKDVVMhHxfLbx8Kx6FL8lxIsgczUtFOe9hp
	 E24/6BTkx7dN8iUTGLFYhSNaIZY8xfe+b/aK5WiclcuhO1TlYYjFedbCzS2RSSgP8P
	 6pcqO5fWvxvutXmxKkVxDeQi1Iakzv5g9Mi1btjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0374/2151] regulator: ab8500: Handle AB8505 VINTCORE selector 7
Date: Wed, 18 Nov 2026 15:35:09 +0100
Message-ID: <20261118150135.717664890@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 4ec4df7e54182edb6955caace37684e535e462dc ]

The AB8505 VINTCORE table exposes only selectors 0 through 6. The
hardware also accepts selector 7 and maps it to 1.35 V, just like
selector 6. Omitting it can make an OTP-programmed selector 7 appear
invalid to the regulator core.

Give AB8505 its own eight-entry selector table while leaving the
AB8500 table unchanged.

Reference: AB8505 User Manual, DM00046744 Rev 3, p. 223

Fixes: 547f384f33db ("regulator: ab8500: add support for ab8505")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260901-ux500-dts-snowball-regulator-v2-3-fe88b01829bf@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/ab8500.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 07d96f8ff944f..5e24e6cdc7732 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -266,6 +266,17 @@ static const unsigned int ldo_vintcore_voltages[] = {
 	1350000,
 };
 
+static const unsigned int ldo_vintcore_ab8505_voltages[] = {
+	1200000,
+	1225000,
+	1250000,
+	1275000,
+	1300000,
+	1325000,
+	1350000,
+	1350000,
+};
+
 static const unsigned int fixed_1200000_voltage[] = {
 	1200000,
 };
@@ -1095,8 +1106,8 @@ static struct ab8500_regulator_info
 			.type		= REGULATOR_VOLTAGE,
 			.id		= AB8505_LDO_INTCORE,
 			.owner		= THIS_MODULE,
-			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
-			.volt_table	= ldo_vintcore_voltages,
+			.n_voltages	= ARRAY_SIZE(ldo_vintcore_ab8505_voltages),
+			.volt_table	= ldo_vintcore_ab8505_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x03,
-- 
2.53.0



