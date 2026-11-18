Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016022;
	b=ax8eCtcOo7e4klZ46V3VJt5PCV3Xg4Kcw948SRxQYmLMTNSpJstWo34mpl0iohJvkZkY
	 IqPiwsVnrd5nWi2A9F/APjpp+756X5Ch6+bshW/8UMfRx1lq+QOOvL6sV/nRf8nDznRFC
	 APbf5qsOYa1uI6pPzDp0NJpCIgwbx328XbdqgHUJj4rp0lkp6FNuDtNAgNZvQ/UDnVvkc
	 0OmkpoD9jwOpKBYPQiH7G0DB4B13aAYkQrZTSzU9G8LvX7LqMYxiKskGs/mXRw+2XV2t+
	 aNKqIsoyOO6Zk2CRflmRClDRpJaduoPFyystNrLMseydUuZD2tXm8tK3n27+V5Qg+aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gCtKhVjLwEidGR0BOTKH1CWHWDh4qlUWuwXenm4K2aE=;
	b=2NYCr4KDkLMvdSBL9xkOIIdwA1Xu/1FnZZoRHNCfU74Ks+bojsfDWhdJ4h/zOu7FY5yp
	 VAZ+og91AFyJHPLbxPvXS9sPlwWaLEE8MWalXHN6vGR9pzYLWe+Pfw52ZHEC6Kiu+gl7y
	 9wWybW3cUlvN/5YGRv345qXBPY1ER5W2Cy1zvInA1xLCncsE9Nb/IsjgIsmHDVvemMpyx
	 Eq/Qi/Cgw4D2GpstPQtr+NeUD31j2nVESPs1RsDq/sLJm9DOhly8KI6itOAJwCYvEsR8H
	 RJjmyxfHCsF+Gkqv0vCx6K4mOCdI9BhOqUVxlMPFG4B+dcL7iwmnSk4jN0n0R89H2yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dRFZtbRg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2457606A31C;
	Wed, 18 Nov 2026 15:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dRFZtbRg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD62C1F000C5;
	Wed, 18 Nov 2026 15:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016022;
	bh=gCtKhVjLwEidGR0BOTKH1CWHWDh4qlUWuwXenm4K2aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dRFZtbRgzsLZW/URG2+4U5ABKRfkopcvHBW7KUCMmVmO3vfjijqmd41222pZgZuh/
	 P7f/HAvh4WMar4v2XxuqNirQUlaf8L9MMRRHuvNuPn1qi2SkyFeTM2q1Fxem3jrPLD
	 i8tf0CiXzc4SvzO/dwLVidg6BUKM7HDE7pHJK6cE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0379/2651] regulator: ab8500: Handle AB8505 VINTCORE selector 7
Date: Wed, 18 Nov 2026 15:26:59 +0100
Message-ID: <20261118150301.478761315@linuxfoundation.org>
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



