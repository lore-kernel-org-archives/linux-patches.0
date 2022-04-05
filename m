Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6D77C
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 16:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F13C385A0
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 16:43:18 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 5 Apr 2022 17:43:14 +0100
Resent-Message-ID: <YkxxotgZ6yRdPysp@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 05 Apr 2022 17:34:32 +0100
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=B7gE=UP=sk2.org=steve@kernel.org>)
	id 1nbm8T-007V3x-On
	for broonie@sirena.co.uk; Tue, 05 Apr 2022 17:34:32 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 7F7D06152A
	for <broonie@sirena.co.uk>; Tue,  5 Apr 2022 16:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 07A0CC385A7; Tue,  5 Apr 2022 16:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5AC8C385A0
	for <broonie@kernel.org>; Tue,  5 Apr 2022 16:34:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org C5AC8C385A0
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=sk2.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=sk2.org
Received: from player728.ha.ovh.net (unknown [10.110.208.62])
	by mo561.mail-out.ovh.net (Postfix) with ESMTP id 357E722AD7
	for <broonie@kernel.org>; Tue,  5 Apr 2022 16:34:15 +0000 (UTC)
Received: from sk2.org (82-65-25-201.subs.proxad.net [82.65.25.201])
	(Authenticated sender: steve@sk2.org)
	by player728.ha.ovh.net (Postfix) with ESMTPSA id 53C7D2918CC09;
	Tue,  5 Apr 2022 16:34:04 +0000 (UTC)
Authentication-Results:garm.ovh; auth=pass (GARM-98R00216734794-6a76-4f86-9128-4ef53b3b435f,
                    8BB3F008109FF1ACF458F8D30695C50246D29715) smtp.auth=steve@sk2.org
X-OVh-ClientIp:82.65.25.201
From: Stephen Kitt <steve@sk2.org>
To: Steven Eckhoff <steven.eckhoff.opensource@gmail.com>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>
Cc: Wolfram Sang <wsa@kernel.org>,
	linux-kernel@vger.kernel.org,
	Stephen Kitt <steve@sk2.org>
Date: Tue,  5 Apr 2022 18:34:00 +0200
Message-Id: <20220405163400.2156631-1-steve@sk2.org>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 8036392060513846918
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrudejgedgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefuthgvphhhvghnucfmihhtthcuoehsthgvvhgvsehskhdvrdhorhhgqeenucggtffrrghtthgvrhhnpeetgedugfelkeeikeetgeegteevfeeufeetuefgudeiiedthfehtdeffeekvdeffeenucfkpheptddrtddrtddrtddpkedvrdeihedrvdehrddvtddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpohhuthdphhgvlhhopehplhgrhigvrhejvdekrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepshhtvghvvgesshhkvddrohhrghdpnhgspghrtghpthhtohepuddprhgtphhtthhopegsrhhoohhnihgvsehkvghrnhgvlhdrohhrgh
X-SA-Exim-Connect-IP: 2604:1380:4641:c500::1
X-SA-Exim-Mail-From: SRS0=B7gE=UP=sk2.org=steve@kernel.org
Subject: [PATCH] ASoC: tscs*: use simple i2c probe function
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: CpvvdwE6Bmo4

The i2c probe functions here don't use the id information provided in
their second argument, so the single-parameter i2c probe function
("probe_new") can be used instead.

This avoids scanning the identifier tables during probes.

Signed-off-by: Stephen Kitt <steve@sk2.org>
---
 sound/soc/codecs/tscs42xx.c | 5 ++---
 sound/soc/codecs/tscs454.c  | 5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/tscs42xx.c b/sound/soc/codecs/tscs42xx.c
index 5b63e017a43b..4fb0bb01bcdc 100644
--- a/sound/soc/codecs/tscs42xx.c
+++ b/sound/soc/codecs/tscs42xx.c
@@ -1409,8 +1409,7 @@ static const struct reg_sequence tscs42xx_patch[] = {
 static char const * const src_names[TSCS42XX_PLL_SRC_CNT] = {
 	"xtal", "mclk1", "mclk2"};
 
-static int tscs42xx_i2c_probe(struct i2c_client *i2c,
-		const struct i2c_device_id *id)
+static int tscs42xx_i2c_probe(struct i2c_client *i2c)
 {
 	struct tscs42xx *tscs42xx;
 	int src;
@@ -1505,7 +1504,7 @@ static struct i2c_driver tscs42xx_i2c_driver = {
 		.name = "tscs42xx",
 		.of_match_table = tscs42xx_of_match,
 	},
-	.probe =    tscs42xx_i2c_probe,
+	.probe_new = tscs42xx_i2c_probe,
 	.id_table = tscs42xx_i2c_id,
 };
 
diff --git a/sound/soc/codecs/tscs454.c b/sound/soc/codecs/tscs454.c
index 7e1826d6f06f..b34a8b516484 100644
--- a/sound/soc/codecs/tscs454.c
+++ b/sound/soc/codecs/tscs454.c
@@ -3400,8 +3400,7 @@ static struct snd_soc_dai_driver tscs454_dais[] = {
 static char const * const src_names[] = {
 	"xtal", "mclk1", "mclk2", "bclk"};
 
-static int tscs454_i2c_probe(struct i2c_client *i2c,
-		const struct i2c_device_id *id)
+static int tscs454_i2c_probe(struct i2c_client *i2c)
 {
 	struct tscs454 *tscs454;
 	int src;
@@ -3474,7 +3473,7 @@ static struct i2c_driver tscs454_i2c_driver = {
 		.name = "tscs454",
 		.of_match_table = tscs454_of_match,
 	},
-	.probe =    tscs454_i2c_probe,
+	.probe_new = tscs454_i2c_probe,
 	.id_table = tscs454_i2c_id,
 };
 
-- 
2.27.0

