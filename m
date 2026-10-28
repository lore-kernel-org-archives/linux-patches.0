Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208272;
	b=0eQbn5Ji5ciSTiUtaDcjnKpm5nL4syV/rY/dV9qB3WoMaV7q61bFtwuQSnqFRJsBo0L8
	 2FGQ1fX78jDaTCw67NUR3errv8vDB/M0tHoTpUrFxSrJK87TYHT6nBGHdDf7jeg9srXkt
	 1zSFE0VqIOEqeiSPMQiCmoEzSENx+RcUDkQhiJ8tSkU0k0tCFMQvhkehKLUA0kjEWzYw5
	 +ht3MRNjY/KyLwFtxl8lI66fLyMBEGGexala7/sW5PyD7e1BOM4gAD1fdlLndsB8uQkrx
	 SkbVl25HHQyjWjfoeRuI/3klxeR4Qq9TWiYRGVAjsZ/6q8szkd575ro8/BZkX7Ce6AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208272;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=HKBLssj6YKYOsZyXLGMtHuS58T65cAqJZeQUR5kdicE=;
	b=VHECJHBO+jjuQ2ykeQHc06BX/erGTTuFraNHu64aitWV7FKvtkyF4jnYQiKOdR62sPWQ
	 UIiFJJqKfgswLp2iddu3VR739laHWmdsYu6YjHjw27/NtniJwnP62HbZ+VqDnlPsOTvzR
	 GWj97YYr+mkff/eIGHNMpMPLNsSsW1/SOvWW6Dym/ZlQHFB/TGRe9ijlYWaG6VMmI4mKn
	 Q6xfjBe4QxP4pKgLMg+Uh+XyEg4H2rXdjAjWFXCz6ieQ/sXKRYYsnYOLDtWXIck9eT0Tg
	 FIS9yHOVxfqqVPp3k20NnQ/4Sr/BD9lHVBg2GshKmgtFHPDmj/WUWvN3vygZPt04Iow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PKhRpagv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA6C606A31E;
	Wed, 28 Oct 2026 17:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PKhRpagv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C28F1F01825;
	Wed, 28 Oct 2026 17:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208271;
	bh=HKBLssj6YKYOsZyXLGMtHuS58T65cAqJZeQUR5kdicE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PKhRpagvWaNA2Py7AiuBB9xiqWrcmDKJYBOU3ERMgGmDGhncM1UF9u2CVCGSyWOV5
	 mhPWfLYjUIpSRs/PmQP5o/cK4oqjVS/d/Z3+26jfSgj4VY1CPFTwDSiI9hE/Y8PVaq
	 v0mgsKBE8LRUmnA9Pg8o4SLzc1eSdS3qETMacEEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/516] power: supply: rt9455: Convert to i2cs .probe_new()
Date: Wed, 28 Oct 2026 17:53:34 +0100
Message-ID: <20261028170004.997085818@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 2adfc4370ebb745380a44c3e5418486a32a9ba67 ]

The probe function doesn't make use of the i2c_device_id * parameter so it
can be trivially converted.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 3e7a1ebc32fa ("power: supply: rt9455: quiesce delayed work before teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/rt9455_charger.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/power/supply/rt9455_charger.c b/drivers/power/supply/rt9455_charger.c
index 89b414fac6c3a..6f6adc7446a6d 100644
--- a/drivers/power/supply/rt9455_charger.c
+++ b/drivers/power/supply/rt9455_charger.c
@@ -1583,8 +1583,7 @@ static const struct regmap_config rt9455_regmap_config = {
 	.cache_type	= REGCACHE_RBTREE,
 };
 
-static int rt9455_probe(struct i2c_client *client,
-			const struct i2c_device_id *id)
+static int rt9455_probe(struct i2c_client *client)
 {
 	struct i2c_adapter *adapter = client->adapter;
 	struct device *dev = &client->dev;
@@ -1743,7 +1742,7 @@ MODULE_DEVICE_TABLE(acpi, rt9455_i2c_acpi_match);
 #endif
 
 static struct i2c_driver rt9455_driver = {
-	.probe		= rt9455_probe,
+	.probe_new	= rt9455_probe,
 	.remove		= rt9455_remove,
 	.id_table	= rt9455_i2c_id_table,
 	.driver = {
-- 
2.53.0



