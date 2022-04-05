Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62B415C5
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 12:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECE8C385A0
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 12:37:54 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f90euc1z"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 5 Apr 2022 13:37:51 +0100
Resent-Message-ID: <Ykw4H/3gTME/O+il@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 05 Apr 2022 13:10:55 +0100
Received: from ams.source.kernel.org ([2604:1380:4601:e00::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=byRm=UP=gmail.com=zheyuma97@kernel.org>)
	id 1nbi1N-007RFY-JX
	for broonie@sirena.co.uk; Tue, 05 Apr 2022 13:10:55 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id 16C00B81C6E
	for <broonie@sirena.co.uk>; Tue,  5 Apr 2022 12:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id E2033C385A3; Tue,  5 Apr 2022 12:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EBE84C385A1
	for <broonie@kernel.org>; Tue,  5 Apr 2022 12:10:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org EBE84C385A1
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id c15-20020a17090a8d0f00b001c9c81d9648so2434280pjo.2
        for <broonie@kernel.org>; Tue, 05 Apr 2022 05:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FbiE+hfmclVFPMzSs7FFPFZTMtCm2FkL6jROPMDnRco=;
        b=f90euc1zGDb5iI2Drt4AgWz4VSglJB6yfAjqBN2f2PEHYRVTGUMuR2aWLT+B9bQLYZ
         5mdNK58woXp0Y4e9aOv3d8OX/VqNTyQtckVs5+qiav9/te+260XIfZTexMNJ1laI1MOS
         UPtB203QxYia416r6lnWw63WrEB3TjBwSdLl2sTYYDa5Dgjfxv/80o+ItR/X4Fci8vsc
         bDwtnerqMSS5Tg51zD50a1oBl0zZM6gHRDpyLX+uQxW4P4PyIiMXRCZF7LYrOp504pSZ
         5By7/QzVinQqc/m+fx/fy/oyq/uJtMRlCqlfknv48FM1UjI/IphqHLC/x1Unw5gvUOJs
         T4tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FbiE+hfmclVFPMzSs7FFPFZTMtCm2FkL6jROPMDnRco=;
        b=5jK8SVJitzLodJF4RRUtKFmpvYMtTnj9AEtVnjVkQG8yuwCfGIVyaD6kn1ddWHyUNY
         wubxaTER2hw6VrcS+AZRMPRhAJp6aafKKXflzPeVjrnoKGeNJUBnhEMgVWqIb3jSUemn
         NHGoe1LxO8VLBHXsr44+IDXfrxTDxJqH6Si4d11JJOwzVy2py1sZtAkIA3IHSFQ9SNEa
         jrYP63TQAbTVyEHISXK0becgtKbFBUxfJJvAKU7DqY81S/Tssi9qdB2Sq19Mvo0MSb/9
         VGv+2nmhgim424nq8svY6M3sqgYSUATIdu2/mx59K5gyv1uP00INO8gTilx0kDK1PpVP
         ncdg==
X-Gm-Message-State: AOAM530AoIbzjAmukUkXb4CP406E/mNc1M/8zR++c2wsBKVeNCC9gA3k
	Px1o96Yvx1ZkT6qD6+8sZ3FipclSAqfaIi0=
X-Google-Smtp-Source: ABdhPJysxtv6ffWslGA0KEeiw5vxSuzfXJxSlxUJAcxN0jasthK2NULv5We+duXJGrrCrP1B3w4OZw==
X-Received: by 2002:a17:902:e748:b0:153:b484:bdf4 with SMTP id p8-20020a170902e74800b00153b484bdf4mr3198892plf.66.1649160650444;
        Tue, 05 Apr 2022 05:10:50 -0700 (PDT)
Received: from localhost.localdomain ([144.202.91.207])
        by smtp.gmail.com with ESMTPSA id n52-20020a056a000d7400b004fad9132d73sm14980117pfv.129.2022.04.05.05.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 05:10:49 -0700 (PDT)
From: Zheyu Ma <zheyuma97@gmail.com>
To: lgirdwood@gmail.com,
	broonie@kernel.org,
	perex@perex.cz,
	tiwai@suse.com
Cc: patches@opensource.cirrus.com,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org,
	Zheyu Ma <zheyuma97@gmail.com>
Date: Tue,  5 Apr 2022 20:10:38 +0800
Message-Id: <20220405121038.4094051-1-zheyuma97@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2604:1380:4601:e00::1
X-SA-Exim-Mail-From: SRS0=byRm=UP=gmail.com=zheyuma97@kernel.org
Subject: [PATCH] ASoC: wm8731: Disable the regulator when probing fails
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: tY16maMr4NCM

When the driver fails during probing, the driver should disable the
regulator, not just handle it in wm8731_hw_init().

The following log reveals it:

[   17.812483] WARNING: CPU: 1 PID: 364 at drivers/regulator/core.c:2257 _regulator_put+0x3ec/0x4e0
[   17.815958] RIP: 0010:_regulator_put+0x3ec/0x4e0
[   17.824467] Call Trace:
[   17.824774]  <TASK>
[   17.825040]  regulator_bulk_free+0x82/0xe0
[   17.825514]  devres_release_group+0x319/0x3d0
[   17.825882]  i2c_device_probe+0x766/0x940
[   17.829198]  i2c_register_driver+0xb5/0x130

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
---
 sound/soc/codecs/wm8731.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/wm8731.c b/sound/soc/codecs/wm8731.c
index 5d4949c2ec9b..b14c6d104e6d 100644
--- a/sound/soc/codecs/wm8731.c
+++ b/sound/soc/codecs/wm8731.c
@@ -602,7 +602,7 @@ static int wm8731_hw_init(struct device *dev, struct wm8731_priv *wm8731)
 	ret = wm8731_reset(wm8731->regmap);
 	if (ret < 0) {
 		dev_err(dev, "Failed to issue reset: %d\n", ret);
-		goto err_regulator_enable;
+		goto err;
 	}
 
 	/* Clear POWEROFF, keep everything else disabled */
@@ -619,10 +619,7 @@ static int wm8731_hw_init(struct device *dev, struct wm8731_priv *wm8731)
 
 	regcache_mark_dirty(wm8731->regmap);
 
-err_regulator_enable:
-	/* Regulators will be enabled by bias management */
-	regulator_bulk_disable(ARRAY_SIZE(wm8731->supplies), wm8731->supplies);
-
+err:
 	return ret;
 }
 
@@ -760,21 +757,27 @@ static int wm8731_i2c_probe(struct i2c_client *i2c,
 		ret = PTR_ERR(wm8731->regmap);
 		dev_err(&i2c->dev, "Failed to allocate register map: %d\n",
 			ret);
-		return ret;
+		goto err_regulator_enable;
 	}
 
 	ret = wm8731_hw_init(&i2c->dev, wm8731);
 	if (ret != 0)
-		return ret;
+		goto err_regulator_enable;
 
 	ret = devm_snd_soc_register_component(&i2c->dev,
 			&soc_component_dev_wm8731, &wm8731_dai, 1);
 	if (ret != 0) {
 		dev_err(&i2c->dev, "Failed to register CODEC: %d\n", ret);
-		return ret;
+		goto err_regulator_enable;
 	}
 
 	return 0;
+
+err_regulator_enable:
+	/* Regulators will be enabled by bias management */
+	regulator_bulk_disable(ARRAY_SIZE(wm8731->supplies), wm8731->supplies);
+
+	return ret;
 }
 
 static const struct i2c_device_id wm8731_i2c_id[] = {
-- 
2.25.1

