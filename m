Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4E928E4
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 19:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D10C004DD
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 19:11:30 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Fri, 25 Mar 2022 19:11:27 +0000
Resent-Message-ID: <Yj4T36GgevFSPZYI@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Fri, 25 Mar 2022 16:25:41 +0000
Received: from ams.source.kernel.org ([145.40.68.75])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=PUxr=UE=sk2.org=steve@kernel.org>)
	id 1nXmkt-005vG2-8d
	for broonie@sirena.co.uk; Fri, 25 Mar 2022 16:25:41 +0000
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id B24A9B82982
	for <broonie@sirena.co.uk>; Fri, 25 Mar 2022 16:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 95C8AC340F3; Fri, 25 Mar 2022 16:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B0537C340E9
	for <broonie@kernel.org>; Fri, 25 Mar 2022 16:25:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org B0537C340E9
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=sk2.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=sk2.org
Received: from player693.ha.ovh.net (unknown [10.109.156.62])
	by mo584.mail-out.ovh.net (Postfix) with ESMTP id DF7162503D
	for <broonie@kernel.org>; Fri, 25 Mar 2022 16:25:24 +0000 (UTC)
Received: from sk2.org (82-65-25-201.subs.proxad.net [82.65.25.201])
	(Authenticated sender: steve@sk2.org)
	by player693.ha.ovh.net (Postfix) with ESMTPSA id 4EAC428C06071;
	Fri, 25 Mar 2022 16:25:19 +0000 (UTC)
Authentication-Results:garm.ovh; auth=pass (GARM-107S001dc4f81cd-8fd0-4ac5-9c7a-b78267933b18,
                    1702D5D0C6B5DF16716081994498F990499A02DA) smtp.auth=steve@sk2.org
X-OVh-ClientIp:82.65.25.201
From: Stephen Kitt <steve@sk2.org>
To: Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>
Cc: patches@opensource.cirrus.com,
	Wolfram Sang <wsa@kernel.org>,
	linux-kernel@vger.kernel.org,
	Stephen Kitt <steve@sk2.org>
Date: Fri, 25 Mar 2022 17:25:15 +0100
Message-Id: <20220325162515.1204107-1-steve@sk2.org>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 17074272088474289798
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrudehuddgkeekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefuthgvphhhvghnucfmihhtthcuoehsthgvvhgvsehskhdvrdhorhhgqeenucggtffrrghtthgvrhhnpeetgedugfelkeeikeetgeegteevfeeufeetuefgudeiiedthfehtdeffeekvdeffeenucfkpheptddrtddrtddrtddpkedvrdeihedrvdehrddvtddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpohhuthdphhgvlhhopehplhgrhigvrheileefrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepshhtvghvvgesshhkvddrohhrghdpnhgspghrtghpthhtohepuddprhgtphhtthhopegsrhhoohhnihgvsehkvghrnhgvlhdrohhrgh
X-SA-Exim-Connect-IP: 145.40.68.75
X-SA-Exim-Mail-From: SRS0=PUxr=UE=sk2.org=steve@kernel.org
Subject: [PATCH] ASoC: wm*: use i2c_match_id and simple i2c probe
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: 0tho38ux85Ay

As part of the ongoing i2c transition to the simple probe
("probe_new"), this patch uses i2c_match_id to retrieve the
driver_data for the probed device. The id parameter is thus no longer
necessary and the simple probe can be used instead.

Signed-off-by: Stephen Kitt <steve@sk2.org>
---
 sound/soc/codecs/wm8904.c | 9 ++++++---
 sound/soc/codecs/wm8985.c | 8 +++++---
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/wm8904.c b/sound/soc/codecs/wm8904.c
index a02a77fef360..04bb8e392497 100644
--- a/sound/soc/codecs/wm8904.c
+++ b/sound/soc/codecs/wm8904.c
@@ -2162,8 +2162,9 @@ static const struct of_device_id wm8904_of_match[] = {
 MODULE_DEVICE_TABLE(of, wm8904_of_match);
 #endif
 
-static int wm8904_i2c_probe(struct i2c_client *i2c,
-			    const struct i2c_device_id *id)
+static const struct i2c_device_id wm8904_i2c_id[];
+
+static int wm8904_i2c_probe(struct i2c_client *i2c)
 {
 	struct wm8904_priv *wm8904;
 	unsigned int val;
@@ -2197,6 +2198,8 @@ static int wm8904_i2c_probe(struct i2c_client *i2c,
 			return -EINVAL;
 		wm8904->devtype = (enum wm8904_type)match->data;
 	} else {
+		const struct i2c_device_id *id =
+			i2c_match_id(wm8904_i2c_id, i2c);
 		wm8904->devtype = id->driver_data;
 	}
 
@@ -2328,7 +2331,7 @@ static struct i2c_driver wm8904_i2c_driver = {
 		.name = "wm8904",
 		.of_match_table = of_match_ptr(wm8904_of_match),
 	},
-	.probe =    wm8904_i2c_probe,
+	.probe_new = wm8904_i2c_probe,
 	.id_table = wm8904_i2c_id,
 };
 
diff --git a/sound/soc/codecs/wm8985.c b/sound/soc/codecs/wm8985.c
index a7e01106fbc0..cf2c32eac773 100644
--- a/sound/soc/codecs/wm8985.c
+++ b/sound/soc/codecs/wm8985.c
@@ -1167,10 +1167,12 @@ static struct spi_driver wm8985_spi_driver = {
 #endif
 
 #if IS_ENABLED(CONFIG_I2C)
-static int wm8985_i2c_probe(struct i2c_client *i2c,
-			    const struct i2c_device_id *id)
+static const struct i2c_device_id wm8985_i2c_id[];
+
+static int wm8985_i2c_probe(struct i2c_client *i2c)
 {
 	struct wm8985_priv *wm8985;
+	const struct i2c_device_id *id = i2c_match_id(wm8985_i2c_id, i2c);
 	int ret;
 
 	wm8985 = devm_kzalloc(&i2c->dev, sizeof *wm8985, GFP_KERNEL);
@@ -1205,7 +1207,7 @@ static struct i2c_driver wm8985_i2c_driver = {
 	.driver = {
 		.name = "wm8985",
 	},
-	.probe = wm8985_i2c_probe,
+	.probe_new = wm8985_i2c_probe,
 	.id_table = wm8985_i2c_id
 };
 #endif
-- 
2.27.0

