Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58907C
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 16:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D52FC385A1
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 16:43:41 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 5 Apr 2022 17:43:38 +0100
Resent-Message-ID: <YkxxuvnjXS2A0T8S@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 05 Apr 2022 17:38:13 +0100
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=B7gE=UP=sk2.org=steve@kernel.org>)
	id 1nbmC3-007V56-9t
	for broonie@sirena.co.uk; Tue, 05 Apr 2022 17:38:13 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 0DD6561867
	for <broonie@sirena.co.uk>; Tue,  5 Apr 2022 16:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 7FBAFC385A4; Tue,  5 Apr 2022 16:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7D3F0C385A0
	for <broonie@kernel.org>; Tue,  5 Apr 2022 16:38:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 7D3F0C385A0
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=sk2.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=sk2.org
Received: from player728.ha.ovh.net (unknown [10.111.208.44])
	by mo582.mail-out.ovh.net (Postfix) with ESMTP id 8183623F88
	for <broonie@kernel.org>; Tue,  5 Apr 2022 16:37:58 +0000 (UTC)
Received: from sk2.org (82-65-25-201.subs.proxad.net [82.65.25.201])
	(Authenticated sender: steve@sk2.org)
	by player728.ha.ovh.net (Postfix) with ESMTPSA id 12A9D2918D61E;
	Tue,  5 Apr 2022 16:37:53 +0000 (UTC)
Authentication-Results:garm.ovh; auth=pass (GARM-102R004cd3fc30c-2cb9-44a9-b250-9c495a8aa197,
                    8AF55017BACD44284FC599BC4826E0280D36FCC4) smtp.auth=steve@sk2.org
X-OVh-ClientIp:82.65.25.201
From: Stephen Kitt <steve@sk2.org>
To: Matthias Brugger <matthias.bgg@gmail.com>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>
Cc: Wolfram Sang <wsa@kernel.org>,
	linux-kernel@vger.kernel.org,
	Stephen Kitt <steve@sk2.org>
Date: Tue,  5 Apr 2022 18:37:50 +0200
Message-Id: <20220405163750.2158916-1-steve@sk2.org>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 8099160983115957894
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrudejgedgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefuthgvphhhvghnucfmihhtthcuoehsthgvvhgvsehskhdvrdhorhhgqeenucggtffrrghtthgvrhhnpeetgedugfelkeeikeetgeegteevfeeufeetuefgudeiiedthfehtdeffeekvdeffeenucfkpheptddrtddrtddrtddpkedvrdeihedrvdehrddvtddunecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmohguvgepshhmthhpohhuthdphhgvlhhopehplhgrhigvrhejvdekrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepshhtvghvvgesshhkvddrohhrghdpnhgspghrtghpthhtohepuddprhgtphhtthhopegsrhhoohhnihgvsehkvghrnhgvlhdrohhrgh
X-SA-Exim-Connect-IP: 2604:1380:4641:c500::1
X-SA-Exim-Mail-From: SRS0=B7gE=UP=sk2.org=steve@kernel.org
Subject: [PATCH] ASoC: mt6660: use simple i2c probe function
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: cjVpHdbViAUc

The i2c probe functions here don't use the id information provided in
their second argument, so the single-parameter i2c probe function
("probe_new") can be used instead.

This avoids scanning the identifier tables during probes.

Signed-off-by: Stephen Kitt <steve@sk2.org>
---
 sound/soc/codecs/mt6660.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/mt6660.c b/sound/soc/codecs/mt6660.c
index 3a881523c30f..c84a0b850f89 100644
--- a/sound/soc/codecs/mt6660.c
+++ b/sound/soc/codecs/mt6660.c
@@ -456,8 +456,7 @@ static int _mt6660_read_chip_revision(struct mt6660_chip *chip)
 	return 0;
 }
 
-static int mt6660_i2c_probe(struct i2c_client *client,
-			    const struct i2c_device_id *id)
+static int mt6660_i2c_probe(struct i2c_client *client)
 {
 	struct mt6660_chip *chip = NULL;
 	int ret;
@@ -567,7 +566,7 @@ static struct i2c_driver mt6660_i2c_driver = {
 		.of_match_table = of_match_ptr(mt6660_of_id),
 		.pm = &mt6660_dev_pm_ops,
 	},
-	.probe = mt6660_i2c_probe,
+	.probe_new = mt6660_i2c_probe,
 	.remove = mt6660_i2c_remove,
 	.id_table = mt6660_i2c_id,
 };
-- 
2.27.0

