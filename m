Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0024779A3;
	Mon, 31 Aug 2026 13:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183343; cv=none; b=I5aOE14zBMEMVwRseLCoqpO3cAiUYjhRPIB3oDqzjBO6+5tlaWvo40LWgS4JLyf236lqJoyeP1HrUehgW0dgmFZsOTMdoSst1o9AdI6lG6l+4pZ3FxcZw5D8RV35nEsWzN7E+ILH6102l68DzKa60A4Mix8/5KX80AggED4ih0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183343; c=relaxed/simple;
	bh=2hczCaN4BS9qZmYqtOxfmzj+NM/p/umi8/KTEZaj26I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jhGo/jCEayHcupWrjBfPfhKJqifX8Uefwe3Qmp7EmXJfUCKj1MRLP5zFJlCXkSKfiQjMPonc6Iniy3wGY826q8/tB1LrqpRmpdwceeiNjsVui/+ZFVkLlIOzv/+IsOSHkkcrCCIVraqFVDz4dx6QeDdyDWW/MGS03/6iXPoLZOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hPB/raoR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hPB/raoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D2E1F00ACF;
	Mon, 31 Aug 2026 13:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183342;
	bh=CZkY50PbBShoeixWAtX9TKIB83wqv2MCcTKQLrO0qa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hPB/raoRY6aL089yf6WEePP/212Od7ISDx9R/r6h7dI0ZykOj/xXyg7S7Fa7EebDd
	 npYfEKOGnNBJCp6hncDYOlpT1DQCbzMnNVOgpHeHIRm6iAksN7RHSG3GffSAuByn3r
	 79ORR05Dt0GaGDF3Xmla63BD6AfyVFUkW5nt2cgjPuWV2UoyIVOCibrTlRUx23Rbq3
	 TtHn5NDb/z5UqIN3I6VKRtB/fHOV6PFYrMJLdVa28/0quhxec52w9U8lTXRfkFNvMg
	 1gAwQsFPQ9+B2fp1makqxKWyQ0j7rtHOI3aZn62LVsWn/4kyinrsvPUQuYdizorjMZ
	 sSFj7OkPuzLVw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	support.opensource@diasemi.com,
	lgirdwood@gmail.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] regulator: da9121: Use subvariant ids in the I2C table
Date: Mon, 31 Aug 2026 09:21:59 -0400
Message-ID: <20260831133314.4125787-91-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 7ddbf1cde4a03e36e17d06fbc711870eb0b256d7 ]

da9121_i2c_probe() stores i2c_get_match_data() in chip->subvariant_id
and da9121_assign_chip_model() switches on DA9121_SUBTYPE_* values.  The
OF table provides those subvariant values, but the I2C id table
currently provides DA9121_TYPE_* values.

Make the I2C id table use the same subvariant namespace as the OF table
so non-DT I2C matches feed the expected data type into the model
assignment code.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260624060024.61300-1-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background search finished: the commit isn’t in this tree yet (`git
log --grep="Use subvariant ids"` returned nothing), which matches
treating it as a backport candidate rather than something already
merged.

**Verdict for Linux 6.18.44: YES**

The I2C `id_table` still passes `DA9121_TYPE_*` values into
`chip->subvariant_id`, but probe and model assignment expect
`DA9121_SUBTYPE_*`. That breaks 8 of 9 non-DT I2C bindings (probe
failure or wrong regulator setup). The OF path is fine; the fix is a
small 9-line table correction with low risk.

 drivers/regulator/da9121-regulator.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/da9121-regulator.c b/drivers/regulator/da9121-regulator.c
index ef161eb0ca277..e4c429000b670 100644
--- a/drivers/regulator/da9121-regulator.c
+++ b/drivers/regulator/da9121-regulator.c
@@ -1166,15 +1166,15 @@ static void da9121_i2c_remove(struct i2c_client *i2c)
 }
 
 static const struct i2c_device_id da9121_i2c_id[] = {
-	{"da9121", DA9121_TYPE_DA9121_DA9130},
-	{"da9130", DA9121_TYPE_DA9121_DA9130},
-	{"da9217", DA9121_TYPE_DA9217},
-	{"da9122", DA9121_TYPE_DA9122_DA9131},
-	{"da9131", DA9121_TYPE_DA9122_DA9131},
-	{"da9220", DA9121_TYPE_DA9220_DA9132},
-	{"da9132", DA9121_TYPE_DA9220_DA9132},
-	{"da9141", DA9121_TYPE_DA9141},
-	{"da9142", DA9121_TYPE_DA9142},
+	{"da9121", DA9121_SUBTYPE_DA9121},
+	{"da9130", DA9121_SUBTYPE_DA9130},
+	{"da9217", DA9121_SUBTYPE_DA9217},
+	{"da9122", DA9121_SUBTYPE_DA9122},
+	{"da9131", DA9121_SUBTYPE_DA9131},
+	{"da9220", DA9121_SUBTYPE_DA9220},
+	{"da9132", DA9121_SUBTYPE_DA9132},
+	{"da9141", DA9121_SUBTYPE_DA9141},
+	{"da9142", DA9121_SUBTYPE_DA9142},
 	{},
 };
 MODULE_DEVICE_TABLE(i2c, da9121_i2c_id);
-- 
2.53.0

