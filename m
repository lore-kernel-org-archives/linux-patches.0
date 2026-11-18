Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015596;
	b=ykOJv30Gj5pwEWfabiZMTsYADjyYGIDfATsqg73I3UPwDYzDegs057nDzRGfC+wqXVy4
	 bvwOYqJE3mpDEpF0Rc4kQK57yqzPO1ivtOMAzO0W2KTtnV0tS6xJpKhUWRcMYw3pZDY21
	 pw9sjxm8F38SNTitYEDfALCiY7NgqutVZDccBSkWJyjLI9lVpriJsHhqBt8pXQ+ZccbKL
	 IWVWPqh/EYumr6DhUeTx91QArEc+jw8I9EGV30JTsIxo434Qy6GhFgBkwijSRsSZC9ElH
	 /XeGHlYGzHNzOrS8TZ5HI0i+ncLaU0pVw1gi4MbWOdjJ0puNUdqb1dic/6c8HYaaHXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015596;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Uf3d5vSfb3SVedB9XAz43LhWY2QZqwMHV11CLEApD3g=;
	b=tL7DuAK9d2Qqyirj6noawQYfX71xNBUW0JUDHAEjOdhKqJVivACvJnbaBf1H397eb+s0
	 53hW4CusnmTgZu8imOUtepYnwiVj0Y8q4hPNHbitq1UsSIXvFrPyhV6+RuT3wywCi2pQb
	 TgBEdbp231J584GDPGHdp3u+hKHllKBVXcrCH51eq5ZJZ6n0INnU3WH6y57+FkqiKO1Ux
	 PK/SZDt/FSNpso/zdV0+UuTMRQVeaV5AOXpCwAeOh1pEPTwE6cgqoGsQ5bsKqGYXsZyDS
	 2CLQDj3NTe7Pb10Yl7uenBpID8VhXVLQjVyi45HXDrHOkaZgLI7DLqtZ+HWWcMF2//g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wc9VLPpT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8439606A31C;
	Wed, 18 Nov 2026 15:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wc9VLPpT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CC21F000C4;
	Wed, 18 Nov 2026 15:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015595;
	bh=Uf3d5vSfb3SVedB9XAz43LhWY2QZqwMHV11CLEApD3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wc9VLPpTC0BsCiSbDjpLF4D/4w3nIokSP/cURtBvpQEfnB3J3zXlA2NBSDM3r+KC2
	 nwLOknQkfvN2h9i/6dS+aXNEkgrhufHoTxRYPKUvqizcRU6i7jdzMq2WYA+UNruSej
	 H5mStX5vomtvxYTbcCvaNZ3LCsqUnzBCuPYwRozg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0229/2651] regulator: mp886x: fix vsel_mask
Date: Wed, 18 Nov 2026 15:24:29 +0100
Message-ID: <20261118150256.108202251@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 24fa0eadc2e3c7e9397924197dca7777ec08b8d7 ]

The MP886X vsel is 7bits, fix the vsel_mask.

Fixes: 97be82880b61 ("regulator: add support for MP8869 regulator")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://patch.msgid.link/20260901043123.5401-2-jszhang@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mp886x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/mp886x.c b/drivers/regulator/mp886x.c
index e0b62bc02a1e1..a10f3a20d413f 100644
--- a/drivers/regulator/mp886x.c
+++ b/drivers/regulator/mp886x.c
@@ -267,7 +267,7 @@ static int mp886x_regulator_register(struct mp886x_device_info *di,
 	rdesc->min_uV = 600000;
 	rdesc->uV_step = 10000;
 	rdesc->vsel_reg = MP886X_VSEL;
-	rdesc->vsel_mask = 0x3f;
+	rdesc->vsel_mask = 0x7f;
 	rdesc->ramp_reg = MP886X_SYSCNTLREG1;
 	rdesc->ramp_mask = MP886X_SLEW_MASK;
 	rdesc->ramp_delay_table = di->ci->slew_rates;
-- 
2.53.0



