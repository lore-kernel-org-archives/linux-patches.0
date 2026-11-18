Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055093;
	b=Jcl5/BDavnOjiTNajBlmRCcC5tesarpwEu4PC5mHkZu0125JdHDJRvpQh5NmiADwW52Q
	 aBjq4heO7xrgPInAre2kUFjFiiaKalOkBEw/AgdnZstFCmD4IrzjLbr/OGLXBo/KsRkTe
	 BEMtwXQZZeSeNUhVdGYV66wrFAuULgZ8+oqAqpvEs5OxF7ls6tsIyrlxk9j4uaZS7P8Qq
	 bNu84k4wrxCekedjz1lV9ZRve8kTOF4wK4mlUAfRuuvlozhQtjKMdtiT3IaPnp4ejsQjy
	 j84O+f0kW7hxGkT8dnbvZzC9fy1WZP/rT5EBKGDBwU8bpxH8vMj5q3gxDU59RryLudw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=keDOlHn799GHUa3m2RvJQPXT8TSUv8PsCGQaeUv3zdU=;
	b=FD0DCpdLX3Q+4JpjFWipuBr+NwNA0zrfTqmwprBDvmsQeS544UIQ8iCLZwzMbo9TY9Tc
	 iKc5JqQiIGygY8ndBumSpUJlvqsvqg/rjBWgZMbU3TdNOY/1nDsLL9swjgsryTm6Ba1A2
	 r88YIg4lfr/vTWZFqQGiCZNLjtFoVukjd0mE8rzhOdXX5haQ54HblTkiiblpqWqut0Jvh
	 ySKAVA1uGVI9y1XX/6TESF1zUIGF3QOhZd0dsQvmOonu78qzIqHiXb+1bb1uQdUDzO0WZ
	 zKqHyA648ytBhxzH6Lcf8dbNthBASp1FPOhe5XYE0Y4hcPGMQOk2vxQ03JZVJ6T/7vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DS+sX1sV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C6A606A31C;
	Thu, 19 Nov 2026 02:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DS+sX1sV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00CD71F000C4;
	Thu, 19 Nov 2026 02:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055093;
	bh=keDOlHn799GHUa3m2RvJQPXT8TSUv8PsCGQaeUv3zdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DS+sX1sV/1oqxKTkpYIo/G3TddXUJTIpN2zaYPJN2RYCkHoP4m/6+mM3LR+k19Kcm
	 GzzoCfKJozgBiXYzDJ4NYzKhsvg/Ubua6tYS4FMFo0FL3UzhreoFwm0HNRVVdCxjUf
	 tXyxVpnSE2fNVfVzHQLjE34wl6edB9rstqF1n1A0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1467/2214] regulator: ab8500: Handle AB8505 VINTCORE selector 7
Date: Wed, 18 Nov 2026 15:52:23 +0100
Message-ID: <20261118150109.880909866@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 51a4ccb710b1a..662434cccd217 100644
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



