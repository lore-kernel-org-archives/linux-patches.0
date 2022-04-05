Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AA528E5
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 12:38:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4895C385A0
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 12:38:17 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 5 Apr 2022 13:38:14 +0100
Resent-Message-ID: <Ykw4NvAnold/Nilk@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 05 Apr 2022 13:33:14 +0100
Received: from ams.source.kernel.org ([145.40.68.75])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=B7gE=UP=sk2.org=steve@kernel.org>)
	id 1nbiMy-007RiR-8p
	for broonie@sirena.co.uk; Tue, 05 Apr 2022 13:33:14 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id B6BB4B81CFA
	for <broonie@sirena.co.uk>; Tue,  5 Apr 2022 12:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 7C3BFC385A0; Tue,  5 Apr 2022 12:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B70CEC385A1
	for <broonie@kernel.org>; Tue,  5 Apr 2022 12:33:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org B70CEC385A1
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=sk2.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=sk2.org
Received: from player688.ha.ovh.net (unknown [10.109.146.132])
	by mo561.mail-out.ovh.net (Postfix) with ESMTP id EFA7724028
	for <broonie@kernel.org>; Tue,  5 Apr 2022 12:32:57 +0000 (UTC)
Received: from sk2.org (82-65-25-201.subs.proxad.net [82.65.25.201])
	(Authenticated sender: steve@sk2.org)
	by player688.ha.ovh.net (Postfix) with ESMTPSA id 7DBA2291068A7;
	Tue,  5 Apr 2022 12:32:52 +0000 (UTC)
Authentication-Results:garm.ovh; auth=pass (GARM-103G00552102515-f355-46c0-857e-560b28840b63,
                    8AF55017BACD44284FC599BC4826E0280D36FCC4) smtp.auth=steve@sk2.org
X-OVh-ClientIp:82.65.25.201
From: Stephen Kitt <steve@sk2.org>
To: Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>
Cc: patches@opensource.cirrus.com,
	Wolfram Sang <wsa@kernel.org>,
	linux-kernel@vger.kernel.org,
	Stephen Kitt <steve@sk2.org>
Date: Tue,  5 Apr 2022 14:32:36 +0200
Message-Id: <20220405123236.2099063-1-steve@sk2.org>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 3961197347742844550
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrudejgedggeelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefuthgvphhhvghnucfmihhtthcuoehsthgvvhgvsehskhdvrdhorhhgqeenucggtffrrghtthgvrhhnpeetgedugfelkeeikeetgeegteevfeeufeetuefgudeiiedthfehtdeffeekvdeffeenucfkpheptddrtddrtddrtddpkedvrdeihedrvdehrddvtddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpohhuthdphhgvlhhopehplhgrhigvrheikeekrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepshhtvghvvgesshhkvddrohhrghdpnhgspghrtghpthhtohepuddprhgtphhtthhopegsrhhoohhnihgvsehkvghrnhgvlhdrohhrgh
X-SA-Exim-Connect-IP: 145.40.68.75
X-SA-Exim-Mail-From: SRS0=B7gE=UP=sk2.org=steve@kernel.org
Subject: [PATCH] ASoC: wm8731: use simple i2c probe function
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: rsl3SC7TZNlg

The i2c probe functions here don't use the id information provided in
their second argument, so the single-parameter i2c probe function
("probe_new") can be used instead.

This avoids scanning the identifier tables during probes.

Signed-off-by: Stephen Kitt <steve@sk2.org>
---
 sound/soc/codecs/wm8731.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm8731.c b/sound/soc/codecs/wm8731.c
index 5d4949c2ec9b..c430f169eb24 100644
--- a/sound/soc/codecs/wm8731.c
+++ b/sound/soc/codecs/wm8731.c
@@ -723,8 +723,7 @@ static struct spi_driver wm8731_spi_driver = {
 #endif /* CONFIG_SPI_MASTER */
 
 #if IS_ENABLED(CONFIG_I2C)
-static int wm8731_i2c_probe(struct i2c_client *i2c,
-			    const struct i2c_device_id *id)
+static int wm8731_i2c_probe(struct i2c_client *i2c)
 {
 	struct wm8731_priv *wm8731;
 	int ret;
@@ -788,7 +787,7 @@ static struct i2c_driver wm8731_i2c_driver = {
 		.name = "wm8731",
 		.of_match_table = wm8731_of_match,
 	},
-	.probe =    wm8731_i2c_probe,
+	.probe_new = wm8731_i2c_probe,
 	.id_table = wm8731_i2c_id,
 };
 #endif
-- 
2.27.0

