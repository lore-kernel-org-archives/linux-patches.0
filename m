Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059847;
	b=1j2jNo/AcAP3rhMn+Hz/s6YRHwlAdw47/AkSLJs10qFDMo3tMu90hed+12S5+Fv2P9BR
	 aCeGJUMMPyGpmPXqTwUmj8UEhHrBSUz16bxroK7PXokkFhBCgwhXv73aVPXQJQNUL9uWE
	 MafOTU8KafG4AcpzImAHd8dd1ZJIlELaxmWkYazdLubGZouUCBt05eQN+0jf+iTlCZQJ/
	 iEHcUFKIFk+8uRn82XusxAFhUKd0Eo7kKfHpFleaBGlIx5+Bf4VkVGIqA6xQHexjJ3Pkr
	 UXayLv3M31734KQbIuCPY19mX+wms3LNddYeOlf8hpEVhbdjwfF/6i8jYI7yKz9gfxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TQJ0RZtV/pxHhzDDINBoIU8UIyjYf1LTQ9RhvgiRzFA=;
	b=BWzIolAdLpM/for6Se7GqdL6UB8fmwMEKPqG7jTPM9csZC8g1/6yaVuC19hCkh3Soouj
	 Cb5I6e/9vwC0e4xwNYY8ICzh5MfHh5FE9UJeyP6htmSX4luGp6F77j8jemIN0mW+Hd1IE
	 c+v8w37cFV3Iv96WZReaHbpLTrBCNO2jiaxMM7OA6CvDIdeamVe4xfnypSfesfKkb+LLi
	 HWZoHu7+V39y3FgSiFaHJZrVQPg2uARE65SEIye8Yi4vAPRAmGmVS6+3RrPHgc3y1WdoR
	 KTzl4Kfw2XHoLe1LC1t2PlC8wgXz3354UgrwVelIliAe5Cr600tFe7wynIWcFKUjcdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ptXrUWLH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC7E606A32C;
	Thu, 19 Nov 2026 03:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ptXrUWLH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD06A1F000C4;
	Thu, 19 Nov 2026 03:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059847;
	bh=TQJ0RZtV/pxHhzDDINBoIU8UIyjYf1LTQ9RhvgiRzFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ptXrUWLHLdSZgrs7LjiBXMrFc+/0F1RMOHM/KdcSprwxoXrvxN9QCGLtiI0GprIzV
	 L1RNb5+YGxqRbt4aeKrEPnqbfG48vN6CWOt3zRD2h98jMpgsqY/9NsfqxXiObcWSG6
	 hGOKTO+f7kdBS2dah4CbCfaCOT0WweSwSNKcYsEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0989/1848] power: supply: ltc2941: Fix of_node reference leak in ltc294x_i2c_probe()
Date: Wed, 18 Nov 2026 15:50:27 +0100
Message-ID: <20261118145958.289503481@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 09a29213bf15630e85a375478832b074b2cfc5c8 ]

ltc294x_i2c_probe() takes a reference on the device node with
of_node_get(), but never drops it, so the reference leaks on every
return path, including the success path.

The node is only used to read the battery properties and to set
info->supply_desc.name, so release it after its last use and also on
the lltc,resistor-sense error path.

Fixes: 085bc24d1553 ("Add LTC2941/LTC2943 Battery Gauge Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917142127.2156568-1-vulab@iscas.ac.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
[ sashal: adjusted error-path context for dev_err() with a separate return instead of dev_err_probe() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ltc2941-battery-gauge.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/power/supply/ltc2941-battery-gauge.c b/drivers/power/supply/ltc2941-battery-gauge.c
index 10cd617516ec2..7a0028c1480a1 100644
--- a/drivers/power/supply/ltc2941-battery-gauge.c
+++ b/drivers/power/supply/ltc2941-battery-gauge.c
@@ -481,6 +481,7 @@ static int ltc294x_i2c_probe(struct i2c_client *client,
 	 * instead of the sense-. This results in reversed measurements. */
 	ret = of_property_read_u32(np, "lltc,resistor-sense", &r_sense);
 	if (ret < 0) {
+		of_node_put(np);
 		dev_err(&client->dev,
 			"Could not find lltc,resistor-sense in devicetree\n");
 		return ret;
@@ -495,6 +496,8 @@ static int ltc294x_i2c_probe(struct i2c_client *client,
 		prescaler_exp = LTC2941_MAX_PRESCALER_EXP;
 	}
 
+	of_node_put(np);
+
 	if (info->id == LTC2943_ID) {
 		if (prescaler_exp > LTC2943_MAX_PRESCALER_EXP)
 			prescaler_exp = LTC2943_MAX_PRESCALER_EXP;
-- 
2.53.0



