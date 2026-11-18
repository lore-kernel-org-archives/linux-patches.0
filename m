Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048140;
	b=EeC2M219eELsAbMd19jYtvp9CzwEsymaznUgv1JmS40kL55JKweLsYuODWkBFe+lklhv
	 E3yUzv7N6eVl2AZoS7Hgosz+rLvEDdqAUBwQbX8SSLXRi5iNAOfzT9cDCd0iozccTdcVo
	 3QslUlYNiZE5SQwNx3OerrvBFfUb8beAFBC2Pdi7V81p1tdIRt7rm8uqk3e83JcJWv1SS
	 uMnt86g2eTnpUWLDP71glfatvRK81a9B2Z1QgnTRZVesdygOTXdSEDXOhpUT57RSLgH9s
	 ipZnMc5kXRy64vExw+OjB8xstukCG8K2zyEFRxaxkSZ/flRzih1SonAPO9kGYPAblMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048140;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1ZypVGZ9gkr7rwE3HWBSt9/MGzF4lBDG1qWq6rFmfYA=;
	b=12PQnm2F3KgMuulRBvq/ASogSQTLATMJKXD2P5AwSH8y75rujYS+/8fVUHTMDxvNA9St
	 8pEzLkZeJt3/yuoC2/ycSszdTHBxpoJFmrpzOPsDdHuZlZs96ruNpmO4LbBJnT2ECyiAi
	 kvj6zARVQYoojw+6wl7s8V8od9rM3piDlyA3nVI8htVswIiNkDzgVnQnu7CFrhXwQTmO0
	 4Hm7BR104GJlEN4SBNBfkf+oHYfPv7QgSy7Dh70V22geD8iOfX/FeSHom4E+gyUVBNJg9
	 4dZW+cDCiXEcAsi3P0vCkItdN6miwuzBU8H4QEUNhZP7YPWrWfILl6F3gkoHFiXe9Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vh9Egu7i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1776606A31C;
	Thu, 19 Nov 2026 00:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vh9Egu7i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3106B1F000C4;
	Thu, 19 Nov 2026 00:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048140;
	bh=1ZypVGZ9gkr7rwE3HWBSt9/MGzF4lBDG1qWq6rFmfYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vh9Egu7i+SOFdYirIjV6mx2ynZIQAntO78L64lcqOBgJUMalGK5hPd1fUJtTyD71w
	 zNXh9Jcb51H7hu7REx3MlO7/k57WH6YwPlN6dTkWiPehmXJRu8DRa9B1Ab/waHKjMO
	 zC5EkUfSPetfq9VTpWUBTnevNlppYqX7aQ0KBU04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1888/2857] regulator: ab8500: Handle AB8505 VINTCORE selector 7
Date: Wed, 18 Nov 2026 15:48:42 +0100
Message-ID: <20261118150309.211726687@linuxfoundation.org>
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



