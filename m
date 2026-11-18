Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060504;
	b=sypGzmIm3fcJ0L+8qFesz4g8GJn7zH+Bibgjy1IMtjvuliMHfNpr5nhNVWcCw70x3vub
	 ngxYzvoULLWus2xH3jzwF4Vy3Wr5qsCRPaHGwYt7wIPAFvUT4OwRmeO5SJxxQrsodKBXf
	 1q7vHJwHLlIhjGZVTx2Hlw24IO3J6RGL3LOrBY0KGrcPmUvlZzYx2SRjU1tRViyGL5Fps
	 2YiS3KzzOnGzOda3rDiNMMQokoe/PdddThBCQzkuqec8LtQ4AjIM8Fn9j8h+AQQXyUzV2
	 7vcl5qsqDn/yk0p16z8IUkBZaXqWMMtcCLw7ZRtWP7ec0w108pzqW+jXZ/HzgBaR7kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060504;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/K5sPlzG9pvScRJYn0Hg5R/B6spHN3gsBX0yNtepwos=;
	b=Pxmq9eWH32BZ5wJhxxMZVphK1HvttGCTVDULAkD5KKbmEagpz4HTZQHMiLua/2V5+huF
	 RXcHX1etJEEDjyZio5GGta+MeGwvYP2zPDAMs16gXqdCNwoz4EFRsDCYHY4Fli1bwn6uK
	 FUQuv7cb4NeKw/++yJGno6VyPg1mSN5E0926PXT4zmmylb8YBP87nDO/pphlYniiyTobj
	 /lnnEplBmkZEVFdZmddT4AA2zu1mlHHOf6GdjMv89ktYOvLTmx+arEPeJe1rEbs2h9SqB
	 0ItyaoaGKHN7Q2BK4YkUkXuISjael8Sg5i5QH5RYP9Dx+gxqY+7RJN/BROzIQlTKpyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AQr+6Iv2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A2B606A320;
	Thu, 19 Nov 2026 03:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AQr+6Iv2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B064A1F000C4;
	Thu, 19 Nov 2026 03:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060504;
	bh=/K5sPlzG9pvScRJYn0Hg5R/B6spHN3gsBX0yNtepwos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AQr+6Iv2SvZZvql4JcMu4i2mpvq4s0bA+DOSBENFgrTzAVh9LirbjNJiJhSmolZaV
	 kkKdSPzeeHMJrICcGkVMbUFenZxbfN8mW6eAjgp5jIhhHtsH6onmk6CBU4gk3SNVU7
	 skCjg0JoxqIiGGTzSrkWtii2frlhB53K6zLAPNyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1222/1848] regulator: ab8500: Handle AB8505 VINTCORE selector 7
Date: Wed, 18 Nov 2026 15:54:20 +0100
Message-ID: <20261118150011.100315647@linuxfoundation.org>
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
index ae33f05347d67..147456e526fed 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -152,6 +152,17 @@ static const unsigned int ldo_vintcore_voltages[] = {
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
@@ -981,8 +992,8 @@ static struct ab8500_regulator_info
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



