Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BED4F393E;
	Thu, 17 Sep 2026 17:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664724; cv=none; b=OaepF5Y97cXA2cong/JkJx+DZBWdxSeuE31oTkTGGvkZEf+MpZzkNzy5RBmwdXpYSzycti+PaKRLdRgU2vGCDPS6Vt/DhIIQt0pcaQkx46JEyc5v3G0NGuitvsH05YtOaMKWEB4TlTu/dnlas5cfKPrq2fvYAOgKgzwCRCYUZJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664724; c=relaxed/simple;
	bh=btAIEFOUdzWR0XaxAs5YmeHe82t4jAi6TdGXy6cJdIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=syuBHm8NqGOu2DX5D0w0zixq4Igi1Eyd4iYzB0eQk3AwhuDRh4OB+/wxwWilvUkXuc3snPIWoBcGdH+PJPbhbQxYHCvAu0cHqlPzn2vUBLy67UcOrMId1TS9aZJCvJf6o/Is4Fk1Uy72vAZCnZhi5IP+zJTLqaT62Yf1cdKgBeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IgL7i4bY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IgL7i4bY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD021F000FF;
	Thu, 17 Sep 2026 17:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664723;
	bh=7uhPZCKjsfPl/5CuRTJ/Z+umzydZDnthVmLVIghAAts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IgL7i4bYwMDiZS14YStF4MV7LMsAjTKHqaSi1Lp1eL+b5NcMsi/r12iIv0Fnnkcbp
	 lQyOyMfNLeo9Pu8WMCmMfu3dGzmS/ontHnM4bZcLckKodk8qADEopi37sye9g3Q+c8
	 aL7naFVDkJ0VIf0VLj6ytlJ9u9Ue1nU3crMrkrRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0466/1250] regulator: da9121: Use subvariant ids in the I2C table
Date: Thu, 17 Sep 2026 16:04:21 +0100
Message-ID: <20260917151604.608092261@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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



