Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07ED8DDBC
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 10:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C639CC433D2
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 10:24:03 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="rvIN5wZ9"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 13 Jun 2023 11:24:00 +0100
Resent-Message-ID: <ZIhDwOsroHbwVyKE@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 13 Jun 2023 10:55:06 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=fwpY=CB=canonical.com=juerg.haefliger@kernel.org>)
	id 1q90jw-001xNu-42
	for broonie@sirena.co.uk; Tue, 13 Jun 2023 10:55:06 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 6078862D4C
	for <broonie@sirena.co.uk>; Tue, 13 Jun 2023 09:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id DA431C4339B; Tue, 13 Jun 2023 09:55:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DFC65C433D2
	for <broonie@kernel.org>; Tue, 13 Jun 2023 09:55:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org DFC65C433D2
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 7D1073F268
	for <broonie@kernel.org>; Tue, 13 Jun 2023 09:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1686650098;
	bh=YXC72gBJcEvm5pdwUJv2zRUSBOXAsWJCWtUFi9onxC8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
	b=rvIN5wZ9wGiEW1uLuFxf/iNxMcFXShQshXP8plFgQakIsA7XzrHOuPFWcKSP+OEPO
	 366+Oongjxu8QdxclpV0bDlJjUCVYzhBTUtEzolMw5T1E/wlbGO+RwofbXzVprAGLQ
	 2MEyU+lw508XJZlS/JCvJgCcRTdzzh4Gs+KKJVofVVvXpf6nduq6EZsLcGgj2+5yzS
	 bhf+L3sKcBrSr1vH7zAm24+IcRk91rtN1Q7Qc7CBt+qxnUtJw8wSwDtaMJcIVSQx91
	 Nw/M8DCCna+9m4TXRuemBK2JAM9mlUsprQHlaJizOFwhLA8SM0Bzp/GEqjIZRlbQ32
	 fwfArngtGtNLg==
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-30af222c5feso3108585f8f.1
        for <broonie@kernel.org>; Tue, 13 Jun 2023 02:54:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686650098; x=1689242098;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YXC72gBJcEvm5pdwUJv2zRUSBOXAsWJCWtUFi9onxC8=;
        b=WyKALeAjLPdp/LYSVArPZXpul3jd5Xh/0X94xgnYOMuIthrDc0hc1ygfDRHAYxKLrC
         V277l01IYS5JoIOR9XMFjjJwGbegqftvO1NsjX2fTYFG86MRbMD/6AQhf/bxv680ALlP
         7jrgIald6snmxUAHyrXPOkXY1qMsqUthf8ZXgxQZc6WHxpIrduGFnhpP7TD7OsLIlMY2
         9MJfv8h7VjphFezEzDT9CjqRNKDONC1zbOGMEw7pCAiFlq19Rjy3XFu+rwLrOuUpZkg7
         2XBY5usg+vWo0h8D8eltdTeGcZ3jWXwK5AopUE6adNE4/AVWkL4otHI9MGFjt0YpAnGw
         7Z/g==
X-Gm-Message-State: AC+VfDyobznsvHD9DkhKeWvHRepHPZ+RX7CEczMslIJFOCSON26+7bKR
	KAzs4N5FoG9Uw1JT9CT20btDJtTjUUXHfTD4UKD3VskrkS0zSoSXM2VMdIkN3kH0EdGEy10nvd0
	82uV8ef1RnNwSBRpFQzk+EJJ6drUF
X-Received: by 2002:a5d:5946:0:b0:307:92e8:ec60 with SMTP id e6-20020a5d5946000000b0030792e8ec60mr6454679wri.39.1686650098260;
        Tue, 13 Jun 2023 02:54:58 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4rCBnlbE9e7jvs5YeCmTdM4fzgruz3biT42Lo2FqmAOnTYs8PAQHCBK9mkUeYVpoyRFl0cxg==
X-Received: by 2002:a5d:5946:0:b0:307:92e8:ec60 with SMTP id e6-20020a5d5946000000b0030792e8ec60mr6454660wri.39.1686650097949;
        Tue, 13 Jun 2023 02:54:57 -0700 (PDT)
Received: from localhost ([194.191.244.86])
        by smtp.gmail.com with ESMTPSA id b14-20020adfe30e000000b00307a86a4bcesm14921660wrj.35.2023.06.13.02.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 02:54:57 -0700 (PDT)
From: Juerg Haefliger <juerg.haefliger@canonical.com>
To: lgirdwood@gmail.com,
	broonie@kernel.org,
	perex@perex.cz,
	tiwai@suse.com,
	alsa-devel@alsa-project.org
Cc: inux-kernel@vger.kernel.org,
	u.kleine-koenig@pengutronix.de,
	nicolas.ferre@microchip.com,
	juerg.haefliger@canonical.com
Date: Tue, 13 Jun 2023 11:54:54 +0200
Message-Id: <20230613095454.38696-1-juerg.haefliger@canonical.com>
X-Mailer: git-send-email 2.37.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=fwpY=CB=canonical.com=juerg.haefliger@kernel.org
Subject: [PATCH] ASoC: siu: Add MODULE_FIRMWARE macro
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: 3kDrYrvCy11h

The module loads firmware so add a MODULE_FIRMWARE macro to provide that
information via modinfo.

Signed-off-by: Juerg Haefliger <juerg.haefliger@canonical.com>
---
 sound/soc/sh/siu_dai.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sh/siu_dai.c b/sound/soc/sh/siu_dai.c
index 84e1b14e68e4..d0b5c543fd2f 100644
--- a/sound/soc/sh/siu_dai.c
+++ b/sound/soc/sh/siu_dai.c
@@ -796,3 +796,5 @@ module_platform_driver(siu_driver);
 MODULE_AUTHOR("Carlos Munoz <carlos@kenati.com>");
 MODULE_DESCRIPTION("ALSA SoC SH7722 SIU driver");
 MODULE_LICENSE("GPL");
+
+MODULE_FIRMWARE("siu_spb.bin");
-- 
2.37.2

