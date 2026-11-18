Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048442;
	b=xWUfWG7TzO43Dt96P/9cqrRFA3PUcxeYrVTctEAfj65k2FOMFkxWCNHP7+nFvBZiF1Yc
	 4E+fXOcT8p0FYa8G5VUCXkWXnmXz1anJaTfYPpJRtuANS9+1b4cJk98odE8fGe6MYKMeb
	 Rn9L06ZNQII+OkcLXcAyR0/b8IUiBF2FYWaDiP40oYQdaFvAatMdMXVj/LeC3DvgBtRyb
	 sNTSA+FxuZaHLj7sZBrJU4wL3nLV53iZr2i0TnvQ+zHWmuA51hfH1Dd/1MyiQxwqnod3S
	 lQSD6hdBStwEBdme1mqyGTb42+P/EjqhwydXzKmXRnSEnX1lor///t9z5M4xHD1oxNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LBwPGkZPiOu/usOtW3wFDSvg0VGDkaMNvfrsnlbPmQ4=;
	b=IHlhLpmlxsYoAmK8awS6/ap43mW6c2irPsYJBzBDqHpSmLk8qzeVcvuo7H9YqoHgZTyD
	 kmVEDuxmFA/L+TO90vMsaHUMpZIXJX9Rao/Ns9DyLI/L8n30oEcWsVWC5Gi4e/zHU/04a
	 hXgUnct9H1fru4RoSEtovZ/kQtYbVhBNSK9VDhIy7qBn/zpZ/a/EDaNAa0Q46PpAHMaQP
	 qVo4xgaej72mikuonFQ3aN637dBqW8ZiOhIm3iPUSNdlZq0PLZi3VwdU2632VKSNCGbyb
	 ADQlhD07w/AYm7jwF2gg1whTkB09YeyeQaYXbxXN/CKTrfhKqWZbOpnlFuy5to2CqpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DS+YUmkA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFF060A2625;
	Thu, 19 Nov 2026 00:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DS+YUmkA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF021F000C5;
	Thu, 19 Nov 2026 00:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048442;
	bh=LBwPGkZPiOu/usOtW3wFDSvg0VGDkaMNvfrsnlbPmQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DS+YUmkAnKy29Qm1OaG9fri31usV0QCMWvexB5Shp6DrkgkZqG7HJC5jqka+15/Oz
	 ErOiPsKCov/AMKEHjafB/+UNibtl6/pLh57odPcqN7CGLJC+FsH+HWEQiATQzI+opJ
	 5b2MnSOsZAEoeyZOhiQJYHTjXKmolDiiPB3L/RuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1997/2857] regulator: mp886x: fix pontential division by zero
Date: Wed, 18 Nov 2026 15:50:31 +0100
Message-ID: <20261118150313.274255734@linuxfoundation.org>
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

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit d16ef5debccc4289c1f25309a2cccfbbe879601a ]

If the "mps,fb-voltage-divider" 2nd var is 0, there will be division
by zero bug.

Fixes: 97be82880b61 ("regulator: add support for MP8869 regulator")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260901043123.5401-1-jszhang@kernel.org?part=1
Link: https://patch.msgid.link/20260909143957.9284-3-jszhang@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mp886x.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/regulator/mp886x.c b/drivers/regulator/mp886x.c
index f42572d0f94e5..ae45a8dbdb27b 100644
--- a/drivers/regulator/mp886x.c
+++ b/drivers/regulator/mp886x.c
@@ -317,6 +317,9 @@ static int mp886x_i2c_probe(struct i2c_client *client)
 	if (ret)
 		return ret;
 
+	if (di->r[1] == 0)
+		return -EINVAL;
+
 	di->en_gpio = devm_gpiod_get(dev, "enable", GPIOD_OUT_HIGH);
 	if (IS_ERR(di->en_gpio))
 		return PTR_ERR(di->en_gpio);
-- 
2.53.0



