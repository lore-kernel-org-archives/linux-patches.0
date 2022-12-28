Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9444256F
	for <patches@lists.linux.dev>; Thu, 29 Dec 2022 13:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A922BC433D2
	for <patches@lists.linux.dev>; Thu, 29 Dec 2022 13:16:08 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=huaqin-corp-partner-google-com.20210112.gappssmtp.com header.i=@huaqin-corp-partner-google-com.20210112.gappssmtp.com header.b="uZ6daoSV"
Resent-From: Mark Brown <broonie@sirena.org.uk>
Resent-Date: Thu, 29 Dec 2022 13:16:45 +0000
Resent-Message-ID: <Y62TPTB6XuUF62df@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 28 Dec 2022 10:38:31 +0000
Received: from ams.source.kernel.org ([145.40.68.75])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=2OLy=42=huaqin.corp-partner.google.com=chenxiangrui@kernel.org>)
	id 1pATpN-00Dmf4-F8
	for broonie@sirena.co.uk; Wed, 28 Dec 2022 10:38:31 +0000
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id 3F3BDB81256
	for <broonie@sirena.co.uk>; Wed, 28 Dec 2022 10:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 25E52C433EF; Wed, 28 Dec 2022 10:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E9319C433D2
	for <broonie@kernel.org>; Wed, 28 Dec 2022 10:38:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org E9319C433D2
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=huaqin.corp-partner.google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=huaqin.corp-partner.google.com
Received: by mail-pj1-f50.google.com with SMTP id m7-20020a17090a730700b00225ebb9cd01so7808244pjk.3
        for <broonie@kernel.org>; Wed, 28 Dec 2022 02:38:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=huaqin-corp-partner-google-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LeeFu3LLxbpBcbEc7JuHn9lHUqC9fXoWjQkDiIJhYWI=;
        b=uZ6daoSVKkkElzBkYilztfgvhYyClCXr9mKaaHihsr3LkMNS1BIQktupUMxdFOTML/
         91pZyG4rRI5O2qUoEp43VGsyw09dACZo+shKb/AqBBDo44zK5ljKwAzUOyT7jOGHIStj
         fdBGdcmkRNjQeN48CGsYDds4QaChtiGVGcP3lg/wpQArH1ptvqnCAiirJc1uDwVIksB5
         H+gJ559Rwin3580EpWQM/L3hJGsIGlBtBbZelgtkmPpcfPTv7ITA/xlhclVqe9oZNDGo
         /factO+d1UYw3cxWpaRsJL7rKn7m9NIPYZX2UK9c5g7D8d+jC9nQzcJUkd940BvksIf9
         bzmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LeeFu3LLxbpBcbEc7JuHn9lHUqC9fXoWjQkDiIJhYWI=;
        b=6Hi/mcGCJGThIlH/tKueyNSJT0evkSvM+jP/+pVySo5LvUBSV227B4Baaviw79ILsl
         BvZdxKaJQNVCNV9R93Ue6FrAL0K4+lPbMjr6kAx+OtiprD8n6FImWF5+51F2cUtAD603
         Fy3OYI2oYU5sniTSoTL6uwjdEL4FsSAcFaO97vC2x6kHulCT5retuMlLwb4OI8H0ZCiY
         KPpxnFyq57c1WfYf+XDtTJQ2QJYIU7rAmdWNSHTAyfuMgo733Qao3O3wgOcKhPUzf388
         Kcy2NLjO/aFfSa1edjuD7nJNgClcUDIBXlpo0Q7MqMbXufxM9bE8c7rjqRbvncKFeJdW
         nHyg==
X-Gm-Message-State: AFqh2kpNY5KGbD0P5apXUkUeFcYYv3uRG/yoDyp+B/DErAeFWGvCb+0v
	gKb0Nkf0lMUdf/mcai9IcnGpsQ==
X-Google-Smtp-Source: AMrXdXumjaK8LmmPBl/2o8Cw06mziQm2Lf81KrfK1jK2/s5sPkEMMsblmLAZj2Urm9ssPu4O4yY+UA==
X-Received: by 2002:a17:903:442:b0:191:2c85:1371 with SMTP id iw2-20020a170903044200b001912c851371mr21796849plb.18.1672223906355;
        Wed, 28 Dec 2022 02:38:26 -0800 (PST)
Received: from localhost.localdomain (203-75-29-53.hinet-ip.hinet.net. [203.75.29.53])
        by smtp.gmail.com with ESMTPSA id f12-20020a170902f38c00b0019145e3f77dsm10705203ple.111.2022.12.28.02.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 02:38:25 -0800 (PST)
From: Mars Chen <chenxiangrui@huaqin.corp-partner.google.com>
To: lgirdwood@gmail.com
Cc: broonie@kernel.org,
	tiwai@suse.com,
	jiaxin.yu@mediatek.com,
	tzungbi@kernel.org,
	trevor.wu@mediatek.com,
	chenxiangrui@huaqin.corp-partner.google.com,
	renzhijie2@huawei.com,
	julianbraha@gmail.com
Date: Wed, 28 Dec 2022 18:38:12 +0800
Message-Id: <20221228103812.450956-1-chenxiangrui@huaqin.corp-partner.google.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 145.40.68.75
X-SA-Exim-Mail-From: SRS0=2OLy=42=huaqin.corp-partner.google.com=chenxiangrui@kernel.org
Subject: [PATCH] ASoC:  support machine driver with max98360
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: PY00hjcIFlSH

Signed-off-by: Mars Chen <chenxiangrui@huaqin.corp-partner.google.com>
---
 sound/soc/mediatek/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/mediatek/Kconfig b/sound/soc/mediatek/Kconfig
index 363fa4d47680..16dc121bd6dd 100644
--- a/sound/soc/mediatek/Kconfig
+++ b/sound/soc/mediatek/Kconfig
@@ -186,6 +186,7 @@ config SND_SOC_MT8186_MT6366_RT1019_RT5682S
 	depends on I2C && GPIOLIB
 	depends on SND_SOC_MT8186 && MTK_PMIC_WRAP
 	select SND_SOC_MT6358
+	select SND_SOC_MAX98357A
 	select SND_SOC_RT1015P
 	select SND_SOC_RT5682S
 	select SND_SOC_BT_SCO
-- 
2.25.1

