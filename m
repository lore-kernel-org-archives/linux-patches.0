Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9DC1D2A7
	for <patches@lists.linux.dev>; Wed, 21 Jun 2023 16:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CCDEC433C0
	for <patches@lists.linux.dev>; Wed, 21 Jun 2023 16:33:43 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=raspberrypi.com header.i=@raspberrypi.com header.b="tTCyr94D"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Wed, 21 Jun 2023 17:33:41 +0100
Resent-Message-ID: <ZJMmZQbYF/FdPWYB@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 21 Jun 2023 16:32:47 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=RNbJ=CJ=raspberrypi.com=phil@kernel.org>)
	id 1qBzp6-002oeX-63
	for broonie@sirena.co.uk; Wed, 21 Jun 2023 16:32:47 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 0430961574
	for <broonie@sirena.co.uk>; Wed, 21 Jun 2023 15:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 810E0C433C0; Wed, 21 Jun 2023 15:32:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D03D2C433C8
	for <broonie@kernel.org>; Wed, 21 Jun 2023 15:32:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org D03D2C433C8
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raspberrypi.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=raspberrypi.com
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2b4745834f3so56161351fa.2
        for <broonie@kernel.org>; Wed, 21 Jun 2023 08:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raspberrypi.com; s=google; t=1687361558; x=1689953558;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=spa+TIgtDuu8ACg4CCEFRTP0dOKYg8BwVUkZi8Ku8bU=;
        b=tTCyr94D5bpEU3ybBoOU1/l+Zfkz3Ww2oB7cMacpwrQxVz4mrgIqW14HUA1WuoKmN+
         hDpmh70sbsWXtuzcr0WxVuO0/Tk/ZveaT6WcGowmu1rGWIDxdB9BfeKzpKuAmxZq5WCY
         ZN4qkhYm/wwrEhfHGcjfScYbClctjhee1Q1z9TvqMxey2N34RcAbLoe7N8LdwA9BMjMt
         mAW/iCwoIDYKeDZePVkYYXT9s0I9/I9X0J93wxg4S21fSe7cx2PyXr2V7dNryiqyUTnF
         pQlkP4sJ82bMXmA1P64ivk/HkMpUw/4Bqf+DO3PfTrvMVE1kmLiI6sDfmQvs97sf3c6k
         5A/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687361558; x=1689953558;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=spa+TIgtDuu8ACg4CCEFRTP0dOKYg8BwVUkZi8Ku8bU=;
        b=aSw7LOp/t8oTWfW8psbIgoXBFk/GpEDcp8UqHxLrxRi0hNH7Z6MmMgAVfv/HBeHssr
         vIOSX8ONAYfpim+MjPqcHIrDfFNeiKThGMQRdVI509qT6isSLmlKHGEd6MK1OQWr3+XR
         ZSHgSj1f9gdva7K1LGOxC+JL/5f1IkA8ASNIFp4HBwtD24/iLrT9EhBhNuVzzZYLS1AW
         qAsA6U+OTsayppE7OZifUmOdxIbeTfzD9yv/tF67ZHsNQyx1ngKtxNxkQIhdO8OV8fPE
         4b0wLjmZRM3VdU9P+Pnx5KQm4L/Rgd51JklP3rlbWc1QFU+8AHQ6CMjf36iheXZUcKJ9
         XPKQ==
X-Gm-Message-State: AC+VfDzS92+gbWgmakmEF6H7aoCE+IjEy2dBXELdCVe8X2PPAfZY34wg
	supz2x2u+hHMktZHE+HkzSqMcg==
X-Google-Smtp-Source: ACHHUZ40FSTVTiioZjIqlF6uU5JeptVNUFlskvzCERkWWkE6DYq8R5QACZPrex2eHB7uVpIByDl7yQ==
X-Received: by 2002:a19:5018:0:b0:4f8:b349:7737 with SMTP id e24-20020a195018000000b004f8b3497737mr4394912lfb.36.1687361558430;
        Wed, 21 Jun 2023 08:32:38 -0700 (PDT)
Received: from buildbot.pitowers.org ([2a00:1098:3142:14:ae1f:6bff:fedd:de54])
        by smtp.gmail.com with ESMTPSA id m9-20020a5d56c9000000b0030fb4b55c13sm4712156wrw.96.2023.06.21.08.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jun 2023 08:32:37 -0700 (PDT)
From: Phil Elwell <phil@raspberrypi.com>
To: James Schulman <james.schulman@cirrus.com>,
	David Rhodes <david.rhodes@cirrus.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	patches@opensource.cirrus.com
Cc: Phil Elwell <phil@raspberrypi.com>
Date: Wed, 21 Jun 2023 16:32:29 +0100
Message-Id: <20230621153229.1944132-1-phil@raspberrypi.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=RNbJ=CJ=raspberrypi.com=phil@kernel.org
Subject: [PATCH] ASoC: cs43130: Fix numerator/denominator mixup
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: hshS2e/RrhXR

In converting to using the standard u16_fract type, commit [1] made the
obvious mistake and failed to take account of the difference in
numerator and denominator ordering, breaking all uses of the cs43130
codec.

Fix it.

[1] commit e14bd35ef446 ("ASoC: cs43130: Re-use generic struct u16_fract")

Fixes: e14bd35ef446 ("ASoC: cs43130: Re-use generic struct u16_fract")
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
---
 sound/soc/codecs/cs43130.h | 138 ++++++++++++++++++-------------------
 1 file changed, 69 insertions(+), 69 deletions(-)

diff --git a/sound/soc/codecs/cs43130.h b/sound/soc/codecs/cs43130.h
index 1dd8936743132..90e8895275e77 100644
--- a/sound/soc/codecs/cs43130.h
+++ b/sound/soc/codecs/cs43130.h
@@ -381,88 +381,88 @@ struct cs43130_clk_gen {
 
 /* frm_size = 16 */
 static const struct cs43130_clk_gen cs43130_16_clk_gen[] = {
-	{ 22579200,	32000,		.v = { 441,	10, }, },
-	{ 22579200,	44100,		.v = { 32,	1, }, },
-	{ 22579200,	48000,		.v = { 147,	5, }, },
-	{ 22579200,	88200,		.v = { 16,	1, }, },
-	{ 22579200,	96000,		.v = { 147,	10, }, },
-	{ 22579200,	176400,		.v = { 8,	1, }, },
-	{ 22579200,	192000,		.v = { 147,	20, }, },
-	{ 22579200,	352800,		.v = { 4,	1, }, },
-	{ 22579200,	384000,		.v = { 147,	40, }, },
-	{ 24576000,	32000,		.v = { 48,	1, }, },
-	{ 24576000,	44100,		.v = { 5120,	147, }, },
-	{ 24576000,	48000,		.v = { 32,	1, }, },
-	{ 24576000,	88200,		.v = { 2560,	147, }, },
-	{ 24576000,	96000,		.v = { 16,	1, }, },
-	{ 24576000,	176400,		.v = { 1280,	147, }, },
-	{ 24576000,	192000,		.v = { 8,	1, }, },
-	{ 24576000,	352800,		.v = { 640,	147, }, },
-	{ 24576000,	384000,		.v = { 4,	1, }, },
+	{ 22579200,	32000,		.v = { 10,	441, }, },
+	{ 22579200,	44100,		.v = { 1,	32, }, },
+	{ 22579200,	48000,		.v = { 5,	147, }, },
+	{ 22579200,	88200,		.v = { 1,	16, }, },
+	{ 22579200,	96000,		.v = { 10,	147, }, },
+	{ 22579200,	176400,		.v = { 1,	8, }, },
+	{ 22579200,	192000,		.v = { 20,	147, }, },
+	{ 22579200,	352800,		.v = { 1,	4, }, },
+	{ 22579200,	384000,		.v = { 40,	147, }, },
+	{ 24576000,	32000,		.v = { 1,	48, }, },
+	{ 24576000,	44100,		.v = { 147,	5120, }, },
+	{ 24576000,	48000,		.v = { 1,	32, }, },
+	{ 24576000,	88200,		.v = { 147,	2560, }, },
+	{ 24576000,	96000,		.v = { 1,	16, }, },
+	{ 24576000,	176400,		.v = { 147,	1280, }, },
+	{ 24576000,	192000,		.v = { 1,	8, }, },
+	{ 24576000,	352800,		.v = { 147,	640, }, },
+	{ 24576000,	384000,		.v = { 1,	4, }, },
 };
 
 /* frm_size = 32 */
 static const struct cs43130_clk_gen cs43130_32_clk_gen[] = {
-	{ 22579200,	32000,		.v = { 441,	20, }, },
-	{ 22579200,	44100,		.v = { 16,	1, }, },
-	{ 22579200,	48000,		.v = { 147,	10, }, },
-	{ 22579200,	88200,		.v = { 8,	1, }, },
-	{ 22579200,	96000,		.v = { 147,	20, }, },
-	{ 22579200,	176400,		.v = { 4,	1, }, },
-	{ 22579200,	192000,		.v = { 147,	40, }, },
-	{ 22579200,	352800,		.v = { 2,	1, }, },
-	{ 22579200,	384000,		.v = { 147,	80, }, },
-	{ 24576000,	32000,		.v = { 24,	1, }, },
-	{ 24576000,	44100,		.v = { 2560,	147, }, },
-	{ 24576000,	48000,		.v = { 16,	1, }, },
-	{ 24576000,	88200,		.v = { 1280,	147, }, },
-	{ 24576000,	96000,		.v = { 8,	1, }, },
-	{ 24576000,	176400,		.v = { 640,	147, }, },
-	{ 24576000,	192000,		.v = { 4,	1, }, },
-	{ 24576000,	352800,		.v = { 320,	147, }, },
-	{ 24576000,	384000,		.v = { 2,	1, }, },
+	{ 22579200,	32000,		.v = { 20,	441, }, },
+	{ 22579200,	44100,		.v = { 1,	16, }, },
+	{ 22579200,	48000,		.v = { 10,	147, }, },
+	{ 22579200,	88200,		.v = { 1,	8, }, },
+	{ 22579200,	96000,		.v = { 20,	147, }, },
+	{ 22579200,	176400,		.v = { 1,	4, }, },
+	{ 22579200,	192000,		.v = { 40,	147, }, },
+	{ 22579200,	352800,		.v = { 1,	2, }, },
+	{ 22579200,	384000,		.v = { 80,	147, }, },
+	{ 24576000,	32000,		.v = { 1,	24, }, },
+	{ 24576000,	44100,		.v = { 147,	2560, }, },
+	{ 24576000,	48000,		.v = { 1,	16, }, },
+	{ 24576000,	88200,		.v = { 147,	1280, }, },
+	{ 24576000,	96000,		.v = { 1,	8, }, },
+	{ 24576000,	176400,		.v = { 147,	640, }, },
+	{ 24576000,	192000,		.v = { 1,	4, }, },
+	{ 24576000,	352800,		.v = { 147,	320, }, },
+	{ 24576000,	384000,		.v = { 1,	2, }, },
 };
 
 /* frm_size = 48 */
 static const struct cs43130_clk_gen cs43130_48_clk_gen[] = {
-	{ 22579200,	32000,		.v = { 147,	100, }, },
-	{ 22579200,	44100,		.v = { 32,	3, }, },
-	{ 22579200,	48000,		.v = { 49,	5, }, },
-	{ 22579200,	88200,		.v = { 16,	3, }, },
-	{ 22579200,	96000,		.v = { 49,	10, }, },
-	{ 22579200,	176400,		.v = { 8,	3, }, },
-	{ 22579200,	192000,		.v = { 49,	20, }, },
-	{ 22579200,	352800,		.v = { 4,	3, }, },
-	{ 22579200,	384000,		.v = { 49,	40, }, },
-	{ 24576000,	32000,		.v = { 16,	1, }, },
-	{ 24576000,	44100,		.v = { 5120,	441, }, },
-	{ 24576000,	48000,		.v = { 32,	3, }, },
-	{ 24576000,	88200,		.v = { 2560,	441, }, },
-	{ 24576000,	96000,		.v = { 16,	3, }, },
-	{ 24576000,	176400,		.v = { 1280,	441, }, },
-	{ 24576000,	192000,		.v = { 8,	3, }, },
-	{ 24576000,	352800,		.v = { 640,	441, }, },
-	{ 24576000,	384000,		.v = { 4,	3, }, },
+	{ 22579200,	32000,		.v = { 100,	147, }, },
+	{ 22579200,	44100,		.v = { 3,	32, }, },
+	{ 22579200,	48000,		.v = { 5,	49, }, },
+	{ 22579200,	88200,		.v = { 3,	16, }, },
+	{ 22579200,	96000,		.v = { 10,	49, }, },
+	{ 22579200,	176400,		.v = { 3,	8, }, },
+	{ 22579200,	192000,		.v = { 20,	49, }, },
+	{ 22579200,	352800,		.v = { 3,	4, }, },
+	{ 22579200,	384000,		.v = { 40,	49, }, },
+	{ 24576000,	32000,		.v = { 1,	16, }, },
+	{ 24576000,	44100,		.v = { 441,	5120, }, },
+	{ 24576000,	48000,		.v = { 3,	32, }, },
+	{ 24576000,	88200,		.v = { 441,	2560, }, },
+	{ 24576000,	96000,		.v = { 3,	16, }, },
+	{ 24576000,	176400,		.v = { 441,	1280, }, },
+	{ 24576000,	192000,		.v = { 3,	8, }, },
+	{ 24576000,	352800,		.v = { 441,	640, }, },
+	{ 24576000,	384000,		.v = { 3,	4, }, },
 };
 
 /* frm_size = 64 */
 static const struct cs43130_clk_gen cs43130_64_clk_gen[] = {
-	{ 22579200,	32000,		.v = { 441,	40, }, },
-	{ 22579200,	44100,		.v = { 8,	1, }, },
-	{ 22579200,	48000,		.v = { 147,	20, }, },
-	{ 22579200,	88200,		.v = { 4,	1, }, },
-	{ 22579200,	96000,		.v = { 147,	40, }, },
-	{ 22579200,	176400,		.v = { 2,	1, }, },
-	{ 22579200,	192000,		.v = { 147,	80, }, },
+	{ 22579200,	32000,		.v = { 40,	441, }, },
+	{ 22579200,	44100,		.v = { 1,	8, }, },
+	{ 22579200,	48000,		.v = { 20,	147, }, },
+	{ 22579200,	88200,		.v = { 1,	4, }, },
+	{ 22579200,	96000,		.v = { 40,	147, }, },
+	{ 22579200,	176400,		.v = { 1,	2, }, },
+	{ 22579200,	192000,		.v = { 80,	147, }, },
 	{ 22579200,	352800,		.v = { 1,	1, }, },
-	{ 24576000,	32000,		.v = { 12,	1, }, },
-	{ 24576000,	44100,		.v = { 1280,	147, }, },
-	{ 24576000,	48000,		.v = { 8,	1, }, },
-	{ 24576000,	88200,		.v = { 640,	147, }, },
-	{ 24576000,	96000,		.v = { 4,	1, }, },
-	{ 24576000,	176400,		.v = { 320,	147, }, },
-	{ 24576000,	192000,		.v = { 2,	1, }, },
-	{ 24576000,	352800,		.v = { 160,	147, }, },
+	{ 24576000,	32000,		.v = { 1,	12, }, },
+	{ 24576000,	44100,		.v = { 147,	1280, }, },
+	{ 24576000,	48000,		.v = { 1,	8, }, },
+	{ 24576000,	88200,		.v = { 147,	640, }, },
+	{ 24576000,	96000,		.v = { 1,	4, }, },
+	{ 24576000,	176400,		.v = { 147,	320, }, },
+	{ 24576000,	192000,		.v = { 1,	2, }, },
+	{ 24576000,	352800,		.v = { 147,	160, }, },
 	{ 24576000,	384000,		.v = { 1,	1, }, },
 };
 
-- 
2.25.1

