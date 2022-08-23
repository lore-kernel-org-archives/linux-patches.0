Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A5E2F29
	for <patches@lists.linux.dev>; Tue, 23 Aug 2022 16:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B1BC433C1
	for <patches@lists.linux.dev>; Tue, 23 Aug 2022 16:12:26 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Cf6pRmo0"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 23 Aug 2022 17:12:23 +0100
Resent-Message-ID: <YwT8Z2n1vWjXVHtL@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 23 Aug 2022 14:59:10 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=Hm3x=Y3=linaro.org=linus.walleij@kernel.org>)
	id 1oQUQu-00A2ji-1K
	for broonie@sirena.co.uk; Tue, 23 Aug 2022 14:59:10 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 080736156F
	for <broonie@sirena.co.uk>; Tue, 23 Aug 2022 13:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 81907C433C1; Tue, 23 Aug 2022 13:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7FD99C433D6
	for <broonie@kernel.org>; Tue, 23 Aug 2022 13:59:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 7FD99C433D6
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f182.google.com with SMTP id l21so13596865ljj.2
        for <broonie@kernel.org>; Tue, 23 Aug 2022 06:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=TB4fzvGynChj0diYVwW7vNz++lUcmWmnfkYK/WfFPbk=;
        b=Cf6pRmo0VLu+xGrGdE3eKXNCOmScTpkXwE3m7wQGqjxFI7edzhe/H+yjbTa8yC0wEw
         m78eS/B6RgeDpGmTzdpKeq3LmDe48/5TZF5s92emu+rAMVUtdZX9ITHLlO5zf2nZ84Jj
         72Empqd51gXn9jL3AOsisHhBci8YU+Dp/Rdo1gtSUroIgrwP59CRkHiFp8CR+nwnRTJm
         KC8suujCUIMgLfoMTAwxwFD4KkzU72BITSgQoyLRz4OscYlJrZ+Qd+7fGr+Wup2TJb0z
         44xiKnw4cZMbQ4bXhtjYRpOP+cNGqonbJA8dzixAJImREkwp365UzC5bz5orcPbdYXf2
         UbXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=TB4fzvGynChj0diYVwW7vNz++lUcmWmnfkYK/WfFPbk=;
        b=YmGWYCRXSX8ncTLzjmBM5YYhL4Ft4vradCK2D27ydA3DOAROnkg8OTuZeJf3yzbvaH
         Es+Cu8/BjNYm8PnO6HtoZy6s8K4cLL13BFK7A5JWC2yzSvFMrq1x0N2bqw5nQnkSBU2S
         qoyzlR0Ofv2go9te/InSpMhhCSr0yUARybT7b4ag6IDCoDJht4lf4oBCU3tTyB59iO9h
         U17J2eClME2Ksl1tp7uuHrSiEQ5d7/WrJJ7wgafPxPTwiS63RIqPL/n8xRJ1rnZLJye1
         K7oeUILrd3JegGUOxBzgkJw7d+IRX4uBcVw3wi3zabwQGplcCYPC97aLtQplgFSVSsro
         OsPA==
X-Gm-Message-State: ACgBeo26ozMRMNQq32VmA9OIkOg+0PVuy1urXPrm8iEs7x2vOGRNFcfL
	kF31BQ+opwXjiyhlB2FW7r9quJxcWjhCgJr1
X-Google-Smtp-Source: AA6agR7piNo6Tlz4yxnxMV5YyJ+UklXpryJy0GBOL0UxfiPvDNg+AsMFhPwB86aXgrPtpLrElRNQWQ==
X-Received: by 2002:a2e:9d91:0:b0:25e:dd34:f5d6 with SMTP id c17-20020a2e9d91000000b0025edd34f5d6mr6900236ljj.501.1661263142982;
        Tue, 23 Aug 2022 06:59:02 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id r5-20020a2ea385000000b0025a65b784b6sm2375939lje.33.2022.08.23.06.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 06:59:02 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Linus Walleij <linus.walleij@linaro.org>,
	Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 23 Aug 2022 15:57:00 +0200
Message-Id: <20220823135700.265019-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.37.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=Hm3x=Y3=linaro.org=linus.walleij@kernel.org
Subject: [PATCH] regmap: check right noinc bounds in debug print
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: VJDTj72eGnYm

We were using the wrong bound in the debug prints: this
needs to be the number of elements, not the number of bytes,
since we're indexing into an element-size typed array.

Fixes: c20cc099b30a ("regmap: Support accelerated noinc operations")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/base/regmap/regmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 41ff9f18b6a3..f8815a8fedcb 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -2193,7 +2193,7 @@ static int regmap_noinc_readwrite(struct regmap *map, unsigned int reg,
 
 	if (!ret && regmap_should_log(map)) {
 		dev_info(map->dev, "%x %s [", reg, write ? "<=" : "=>");
-		for (i = 0; i < val_len; i++) {
+		for (i = 0; i < val_count; i++) {
 			switch (val_bytes) {
 			case 1:
 				pr_cont("%x", u8p[i]);
@@ -2212,7 +2212,7 @@ static int regmap_noinc_readwrite(struct regmap *map, unsigned int reg,
 			default:
 				break;
 			}
-			if (i == (val_len - 1))
+			if (i == (val_count - 1))
 				pr_cont("]\n");
 			else
 				pr_cont(",");
-- 
2.37.2

