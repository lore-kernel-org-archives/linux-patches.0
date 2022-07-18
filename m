Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339F3259B
	for <patches@lists.linux.dev>; Mon, 18 Jul 2022 14:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB72C341CB
	for <patches@lists.linux.dev>; Mon, 18 Jul 2022 14:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1658154569;
	bh=HyChJOPRuk/0qbeKqOLmxqV6Llt7Wlk7uu/scDDWoVM=;
	h=Resent-From:Resent-Date:Resent-To:From:To:Cc:Date:Subject:From;
	b=k1ZiVSr+r1d642PSNU8hlI4yhvqLzp+bDT17hmq6rH6yyHLRsWccbvJP/6kyG1ebo
	 vCLRVQp4Yn1R3SECzZ3gS8h/dtrdwoB1xNGjEywFiNCatTyOAQE5LjcN9mPBLKPF4w
	 8lbbs5VAsD7a6dVNiKIL7TmjV836NhlagLFQbeLsc1yUrykEL9U2LxnfJKOfvtp4bC
	 t1SF0HUm09Ab3Kz67CL42aNXixPx1S3jB2zmUxSbh02JFQRETKOklib83T58UWQBON
	 NGXXWs/Q1vhrEWlEniJ1NM+wBu2I3829DLDW/e93iLv8XGg6bF/KHUCQZhBx4eFmxT
	 t0ygqCD5R20zg==
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Mon, 18 Jul 2022 15:29:25 +0100
Resent-Message-ID: <YtVuRX19MyFv7AXS@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Mon, 18 Jul 2022 15:10:05 +0100
Received: from ams.source.kernel.org ([2604:1380:4601:e00::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <broonie@kernel.org>)
	id 1oDRRj-005H9N-Ff
	for broonie@sirena.co.uk; Mon, 18 Jul 2022 15:10:05 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id 1FBA6B81612
	for <broonie@sirena.co.uk>; Mon, 18 Jul 2022 14:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id D9987C341CB; Mon, 18 Jul 2022 14:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826D8C341C0;
	Mon, 18 Jul 2022 14:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1658153401;
	bh=HyChJOPRuk/0qbeKqOLmxqV6Llt7Wlk7uu/scDDWoVM=;
	h=From:To:Cc:Subject:Date:From;
	b=Cxx3ggvvPUygzkDCQEO0HSWBSh+q8YcbLwD/VDb0J2ApXBQCIeyQiLV38TLKgPSwI
	 oukDF6U+MCK9FmUhEsStqPoQQ+s+9RYZM5B23V++fghjJw9qR3zSn2zd1nxLWO7i5V
	 uWj6a8SNxQHF52LW+G8xiU544VZ0xbVtAFalzMK9RG1gvF6ua+j/Dn1iGsnhipJRNN
	 6czSekaUIRhofNSl4l3aE+wcLKXp84qUQFKnzEPjY5DkFbjFiGY2D06Le7PNQ8OOxF
	 5EXQCLHRjjtg7hwejZja61mbAjE8PGwTghXFTGV+W2IIYR2J4ZPrA6BQRk8V58llUY
	 ZmIQ1b8oxnBag==
From: Mark Brown <broonie@kernel.org>
To: Zheyu Ma <zheyuma97@gmail.com>,
	Liam Girdwood <lgirdwood@gmail.com>
Cc: alsa-deve@alsa-project.org,
	wtli@nuvoton.com,
	Mark Brown <broonie@kernel.org>
Date: Mon, 18 Jul 2022 15:04:05 +0100
Message-Id: <20220718140405.57233-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1398; h=from:subject; bh=HyChJOPRuk/0qbeKqOLmxqV6Llt7Wlk7uu/scDDWoVM=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBi1WedfrbfTXLWVa7/hNwrZIBjz6/GEhen9j1acW/B mX0U1LuJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYtVnnQAKCRAk1otyXVSH0KM6B/ 9vtEg4FHNo+m3IDZM33UeDko58WHk4lEY4daRRZ01j5/vCkuzDoePPp20N9ffB++NEPDj0FNYgn+// t+GORpD6SSVUAVZOooSI07vzjammxMOXvY1KSCgM000jZY+fhlTTxta3ssuBMZjJDR7oip3d+oKbBz gYVvLKpEBmuq6awtcBpqcCYQzwYzL1Kin+jU83A24ZEAvVykJcWxY1lHuu3AFqLxiZEikzlwyLDVeL otsEdrX5J1kVYwITw0byFQeC65G1MtArPPGbPLqWIDolMaJ72WNHK1S77hwcmQPPP/wVes6ean4NbC nOtkV2HZa2VhJJggwFwmO2NHcCbXDQ
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2604:1380:4601:e00::1
X-SA-Exim-Mail-From: broonie@kernel.org
Subject: [PATCH] ASoC: nau8821: Don't unconditionally free interrupt
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: MK3gvon7Q+C1

The remove() operation unconditionally frees the interrupt for the device
but we may not actually have an interrupt so there might be nothing to
free. Since the interrupt is requested after all other resources we don't
need the explicit free anyway, unwinding is guaranteed to be safe, so just
delete the remove() function and let devm take care of things.

Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 sound/soc/codecs/nau8821.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/sound/soc/codecs/nau8821.c b/sound/soc/codecs/nau8821.c
index 2600be250a3c..3ce23c20eca9 100644
--- a/sound/soc/codecs/nau8821.c
+++ b/sound/soc/codecs/nau8821.c
@@ -1699,15 +1699,6 @@ static int nau8821_i2c_probe(struct i2c_client *i2c)
 	return ret;
 }
 
-static int nau8821_i2c_remove(struct i2c_client *i2c_client)
-{
-	struct nau8821 *nau8821 = i2c_get_clientdata(i2c_client);
-
-	devm_free_irq(nau8821->dev, nau8821->irq, nau8821);
-
-	return 0;
-}
-
 static const struct i2c_device_id nau8821_i2c_ids[] = {
 	{ "nau8821", 0 },
 	{ }
@@ -1737,7 +1728,6 @@ static struct i2c_driver nau8821_driver = {
 		.acpi_match_table = ACPI_PTR(nau8821_acpi_match),
 	},
 	.probe_new = nau8821_i2c_probe,
-	.remove = nau8821_i2c_remove,
 	.id_table = nau8821_i2c_ids,
 };
 module_i2c_driver(nau8821_driver);
-- 
2.30.2

