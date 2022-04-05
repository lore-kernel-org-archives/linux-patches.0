Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C86F2F5E
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 17:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C09EC385A4
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 17:23:49 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 5 Apr 2022 18:23:46 +0100
Resent-Message-ID: <Ykx7Iu9dPrrnjyoS@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 05 Apr 2022 17:59:27 +0100
Received: from ams.source.kernel.org ([2604:1380:4601:e00::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=B7gE=UP=sk2.org=steve@kernel.org>)
	id 1nbmWb-007VCJ-0p
	for broonie@sirena.co.uk; Tue, 05 Apr 2022 17:59:27 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id 7B313B81EA8
	for <broonie@sirena.co.uk>; Tue,  5 Apr 2022 16:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 53A27C385A1; Tue,  5 Apr 2022 16:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C8D25C385A5
	for <broonie@kernel.org>; Tue,  5 Apr 2022 16:59:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org C8D25C385A5
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=sk2.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=sk2.org
Received: from player771.ha.ovh.net (unknown [10.110.171.212])
	by mo575.mail-out.ovh.net (Postfix) with ESMTP id E4D7522B57
	for <broonie@kernel.org>; Tue,  5 Apr 2022 16:59:10 +0000 (UTC)
Received: from sk2.org (82-65-25-201.subs.proxad.net [82.65.25.201])
	(Authenticated sender: steve@sk2.org)
	by player771.ha.ovh.net (Postfix) with ESMTPSA id 79485293E35B3;
	Tue,  5 Apr 2022 16:59:06 +0000 (UTC)
Authentication-Results:garm.ovh; auth=pass (GARM-106R0065628e882-527f-4d1e-a890-3f76ab6a3621,
                    8AF55017BACD44284FC599BC4826E0280D36FCC4) smtp.auth=steve@sk2.org
X-OVh-ClientIp:82.65.25.201
From: Stephen Kitt <steve@sk2.org>
To: Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>
Cc: Wolfram Sang <wsa@kernel.org>,
	linux-kernel@vger.kernel.org,
	Stephen Kitt <steve@sk2.org>
Date: Tue,  5 Apr 2022 18:58:22 +0200
Message-Id: <20220405165836.2165310-1-steve@sk2.org>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 8457197150388913798
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrudejgedguddtgecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepufhtvghphhgvnhcumfhithhtuceoshhtvghvvgesshhkvddrohhrgheqnecuggftrfgrthhtvghrnhepteegudfgleekieekteeggeetveefueefteeugfduieeitdfhhedtfeefkedvfeefnecukfhppedtrddtrddtrddtpdekvddrieehrddvhedrvddtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepphhlrgihvghrjeejuddrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehsthgvvhgvsehskhdvrdhorhhgpdhnsggprhgtphhtthhopedupdhrtghpthhtohepsghrohhonhhivgeskhgvrhhnvghlrdhorhhg
X-SA-Exim-Connect-IP: 2604:1380:4601:e00::1
X-SA-Exim-Mail-From: SRS0=B7gE=UP=sk2.org=steve@kernel.org
Subject: [PATCH 00/14] ASoC: remaining simple i2c probe changes
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: Dmdn9viwRYwp

This series covers all the remaining changes to migrate
sound/soc/codecs i2c probes to probe_new, where the const struct
i2c_client * argument is unused; there are a few remaining files which
use the argument and will need i2c_match_id migration.

These are all files without a more specific maintainer than Liam and
Mark as SoC supporters (unlike all my previous patches).

Stephen Kitt (14):
  ASoC: ak4*: use simple i2c probe function
  ASoC: cx2072x: use simple i2c probe function
  ASoC: es83*: use simple i2c probe function
  ASoC: lm4857: use simple i2c probe function
  ASoC: max9*: use simple i2c probe function
  ASoC: ml26124: use simple i2c probe function
  ASoC: nau8*: use simple i2c probe function
  ASoC: pcm*: use simple i2c probe function
  ASoC: sta*: use simple i2c probe function
  ASoC: tas*: use simple i2c probe function
  ASoC: tda7419: use simple i2c probe function
  ASoC: tlv320*: use simple i2c probe function
  ASoC: ts3a227e: use simple i2c probe function
  ASoC: uda1380: use simple i2c probe function

 sound/soc/codecs/ak4118.c          | 5 ++---
 sound/soc/codecs/ak4535.c          | 5 ++---
 sound/soc/codecs/ak4641.c          | 5 ++---
 sound/soc/codecs/ak4671.c          | 5 ++---
 sound/soc/codecs/cx2072x.c         | 5 ++---
 sound/soc/codecs/es8316.c          | 5 ++---
 sound/soc/codecs/es8328-i2c.c      | 5 ++---
 sound/soc/codecs/lm4857.c          | 5 ++---
 sound/soc/codecs/max9768.c         | 5 ++---
 sound/soc/codecs/max98371.c        | 5 ++---
 sound/soc/codecs/max98373-i2c.c    | 5 ++---
 sound/soc/codecs/max98390.c        | 5 ++---
 sound/soc/codecs/max9850.c         | 5 ++---
 sound/soc/codecs/max98504.c        | 5 ++---
 sound/soc/codecs/max98520.c        | 4 ++--
 sound/soc/codecs/max9867.c         | 5 ++---
 sound/soc/codecs/max9877.c         | 5 ++---
 sound/soc/codecs/max98925.c        | 5 ++---
 sound/soc/codecs/max98926.c        | 5 ++---
 sound/soc/codecs/max98927.c        | 5 ++---
 sound/soc/codecs/ml26124.c         | 5 ++---
 sound/soc/codecs/nau8540.c         | 5 ++---
 sound/soc/codecs/nau8810.c         | 5 ++---
 sound/soc/codecs/nau8821.c         | 5 ++---
 sound/soc/codecs/nau8822.c         | 5 ++---
 sound/soc/codecs/nau8824.c         | 5 ++---
 sound/soc/codecs/nau8825.c         | 5 ++---
 sound/soc/codecs/pcm1681.c         | 5 ++---
 sound/soc/codecs/pcm1789-i2c.c     | 5 ++---
 sound/soc/codecs/pcm179x-i2c.c     | 5 ++---
 sound/soc/codecs/pcm3168a-i2c.c    | 5 ++---
 sound/soc/codecs/pcm512x-i2c.c     | 5 ++---
 sound/soc/codecs/sta32x.c          | 5 ++---
 sound/soc/codecs/sta350.c          | 5 ++---
 sound/soc/codecs/sta529.c          | 5 ++---
 sound/soc/codecs/tas2552.c         | 5 ++---
 sound/soc/codecs/tas2764.c         | 5 ++---
 sound/soc/codecs/tas2770.c         | 5 ++---
 sound/soc/codecs/tas5086.c         | 5 ++---
 sound/soc/codecs/tas6424.c         | 5 ++---
 sound/soc/codecs/tda7419.c         | 5 ++---
 sound/soc/codecs/tlv320adcx140.c   | 5 ++---
 sound/soc/codecs/tlv320aic23-i2c.c | 5 ++---
 sound/soc/codecs/tlv320dac33.c     | 5 ++---
 sound/soc/codecs/ts3a227e.c        | 5 ++---
 sound/soc/codecs/uda1380.c         | 5 ++---
 46 files changed, 92 insertions(+), 137 deletions(-)

-- 
2.27.0

