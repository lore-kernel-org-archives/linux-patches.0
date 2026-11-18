Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029427;
	b=IPzH6iKFG+kBb20w8HI8AEtcGR7B+JKir3M2/z9HiPikbqIYkrROLbDommKXETjepmeH
	 09IJ6IH1bfY5WqAjoK8o+zo9oyL+rHg0/6rdQREkXAogdXTfNeZ7AN3idDbQj7gh3UFBN
	 iwGLQ2B0XLSPs5yZExPXrZdajVmXomeFyex3o4gB1IZOkEFLeZ3sdHmGNI4/3OTCIp2Zo
	 pwJ/cIGX1QfXpFn7REwqSFGSw3D10mkAP3egElJvyxsXMWZKFpNfgawYdGdqKI0Rs4miV
	 qiyJ91ZondssFRPUP7/CnUPQ2fgN26y7JBSvJM2KyTVS1H/21QOxcJpZHStaMZnYtjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029427;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iUHlz/Sp2LCnoY0f/1ivNeinynRSLBGF3INvXiDyJuY=;
	b=E1CQY9nnA5rRN3LENK2nQQ+JxuMjkb3FBy7AA2CyI2WWZvoqcH4q7NDkygqlJ/Tpw99+
	 POa9QatkeKf243A161PCS7j/vk4zaBIlZ+cgGgEM3I3pFHn2GLMKuoVW2DvGTQ9OOksKW
	 XOXESX0cfa++Tn2ycUUllh2Yba/7bqGrmHHiFhXepJcElNQanc1tyOn/M/iy1zAVfwYg9
	 faRgcEvokDUOWxMwz4F3aNUoIVka/lUCAbfkF0kecm048KFOk4jn4oOW4vF5uhFcX4Nou
	 fxSEWXta1oloTlJNZBrRAKplQwF40ANy0+NboWccqXkBdEShNugV3pQnk5RItWa084Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AHv3y5wP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96857606A31C;
	Wed, 18 Nov 2026 19:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AHv3y5wP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2321F000C4;
	Wed, 18 Nov 2026 19:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029427;
	bh=iUHlz/Sp2LCnoY0f/1ivNeinynRSLBGF3INvXiDyJuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AHv3y5wPABe8CAhmYjYuFC1bcab3QQRNGcKyIasWMfwDCHVmR/aATzPLfAEfAOaMh
	 QM5z9oAex/mOcdoOVQCZelppH6QPD5W7s5IihHWYInAAMFQkXYsVV3A9v42NZVcPmc
	 vzRXkZ61BHL8J8J4bKF+vmzIU9QwNcuWzLH6iuSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0346/1756] regulator: ab8500: Handle AB8505 VINTCORE selector 7
Date: Wed, 18 Nov 2026 15:41:13 +0100
Message-ID: <20261118150022.155463597@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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



