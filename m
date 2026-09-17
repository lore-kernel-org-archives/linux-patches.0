Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04553D9DA8;
	Thu, 17 Sep 2026 18:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668251; cv=none; b=iZnykNaP/QJPxlyuwdibth5qdY834ZhYJhrZdk65nJmoYmX1dSpXAqyMZTBjjzB0AK9LQNV2I/Q7lrFIOPOdmdBE4elWhXH9twxICHKEKqAApTLZmUdvHGaFnggcYQKntTmKhC8JilN5NwPoboDpLq3W8sL33E5MzIeV4iY3QAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668251; c=relaxed/simple;
	bh=coT9Hn2pdqcn48/lspa1SwXKgZJA5ZnCIhtpuUbgOrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPkWgUIiLnLdbhXmxa0gAggSdW/IOlC2qprGTBDPfty3N60g69WrriIn4EWU4QSS19M1mflmfXSEAI4fkDijArEmOnnpxB0hU4/8ynXpzGUI9N69xZ+Z5N0Y4dCW02kP1t/dAFViunjBhzhnz1+1RsM4TlthSsr6+wZ4kerWPOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VO+l/X3R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VO+l/X3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528E71F000FF;
	Thu, 17 Sep 2026 18:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668249;
	bh=qCPFVdnPJcwMRvhKiFkNUKl+ferobx1+ClK9MZEyTj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VO+l/X3R7HxUGGy/kjTAH1eCSttp9xOcDJD7deDeLBabctor584EDgiVIpPLTeCZ3
	 18jriRa9g89BH/T2YYfnTCyXfGzHP7DHgHWHDqrBjjx3c+SiBwATCw80qL3Ceg2xFD
	 YvVIhTEhJVIoVcOY0W4P5NPnsLr4FFtR9ztg/ijU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0362/1102] regulator: da9121: Use subvariant ids in the I2C table
Date: Thu, 17 Sep 2026 16:05:05 +0100
Message-ID: <20260917151548.737131518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 17527a3f53b43..6c4462388cf8d 100644
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



