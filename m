Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EC438BCE
	for <patches@lists.linux.dev>; Fri, 27 Oct 2023 16:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=9elements.com header.i=@9elements.com header.b="bYEdi27I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0CCC433C8
	for <patches@lists.linux.dev>; Fri, 27 Oct 2023 16:27:51 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=9elements.com header.i=@9elements.com header.b="bYEdi27I"
Resent-From: Mark Brown <broonie@finisterre.sirena.org.uk>
Resent-Date: Fri, 27 Oct 2023 17:27:49 +0100
Resent-Message-ID: <ZTvlBVfp++5GYiIg@finisterre.sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Fri, 27 Oct 2023 16:29:36 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=9QRE=GJ=9elements.com=naresh.solanki@kernel.org>)
	id 1qwOmD-00FfHc-QT
	for broonie@sirena.co.uk; Fri, 27 Oct 2023 16:29:36 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 5980F626DD
	for <broonie@sirena.co.uk>; Fri, 27 Oct 2023 15:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id D4002C433B9; Fri, 27 Oct 2023 15:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 52303C433CA
	for <broonie@kernel.org>; Fri, 27 Oct 2023 15:29:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 52303C433CA
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=9elements.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=9elements.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-40850b244beso17229455e9.2
        for <broonie@kernel.org>; Fri, 27 Oct 2023 08:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=9elements.com; s=google; t=1698420539; x=1699025339; darn=kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xzqx8XYbA4QiCfYm/TIcDbjCVUGr9u+/h0s0o1TtnVY=;
        b=bYEdi27I7GaBRyG5DBe90Ir8bKq6nOuVHKX8NF+5W8HVEOcUezPtcJ6psBZA+9F6D3
         rQ4qvfKUjqQxi2fHQz/Ta6mKVZQMc9plYMRfSM/H9CdojV3B4pPFRImBkvXo4WCB5oZk
         etmUVOH03OkZC2iusHZQ9SNJ+onr/UdoitUt0fq0BnokS2X+9lodzC6sm05+MmT7jx1s
         QSTiqvp/xJC8D3n/AXmkiFPiZhkqQ/K4+Wc6VPU3Dxw+9wtE4lJHpFVOHQkZV2nkz2qS
         h/CsVsJRnB/5ImLUwh6f2xwLneeSq8sJ3ObzBB/dUCABOpcoHwUPLNYGwnuWrS55vtmF
         aa/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698420539; x=1699025339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xzqx8XYbA4QiCfYm/TIcDbjCVUGr9u+/h0s0o1TtnVY=;
        b=Ot9IBTAotJhBEuYpJTDtQMPrrvIbjjVoGby1A51dzx/Bc4ISK/IT8IpLO7cTaYasMd
         0C+cozW8CS4Qd/lCWhM4njUB64hB2RpFyoajlXW4MsSJWvV3Tblbp476wY3Wmj0cjAC6
         NuTh5Y1LoqhPyn3MtYdrBwN97oC9xwL2/gT531LTOJ1xvUwCIeFts/d+wzhpTcIsYtU/
         Q8/TRJbnxhzW04sRzVC7f8uLJAbP51NA70nEsuLRj2aai6te6MBYIX7WvJUOHg2W7K4A
         BI4PlkfMTVIMXWG/fuUhsYEnIav/JaXm+Q46Pzj/hDlTMY10yX5YaVEMkUtaJ522iD8V
         crTQ==
X-Gm-Message-State: AOJu0YygYc7v5ULO8yK/T0kbeBWCApcLsHOBwf+x1xZJl22nXqHq0rva
	3xfVhN0DMX7wQ4gK4ujCsSWWBg==
X-Google-Smtp-Source: AGHT+IEYouaMAJvx5EfhLjs+tGxoRNrvzkB6VYRzCHNV+7D0TvsukVBo82R8vCHoEnoj/HOzboSw1g==
X-Received: by 2002:a05:600c:450f:b0:408:3918:1bc1 with SMTP id t15-20020a05600c450f00b0040839181bc1mr2744992wmo.8.1698420539479;
        Fri, 27 Oct 2023 08:28:59 -0700 (PDT)
Received: from stroh80.sec.9e.network (ip-078-094-000-051.um19.pools.vodafone-ip.de. [78.94.0.51])
        by smtp.gmail.com with ESMTPSA id q17-20020a05600c46d100b0040836519dd9sm1902688wmo.25.2023.10.27.08.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Oct 2023 08:28:59 -0700 (PDT)
From: Naresh Solanki <naresh.solanki@9elements.com>
To: Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>
Cc: Naresh Solanki <naresh.solanki@9elements.com>,
	linux-kernel@vger.kernel.org
Date: Fri, 27 Oct 2023 15:28:29 +0000
Message-ID: <20231027152830.1269895-2-naresh.solanki@9elements.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231027152830.1269895-1-naresh.solanki@9elements.com>
References: <20231027152830.1269895-1-naresh.solanki@9elements.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=9QRE=GJ=9elements.com=naresh.solanki@kernel.org
Subject: [PATCH v6 2/2] regulator (max5970): Remove duplicate line
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: 347+svZzPEr0

Remove redundant/duplicate line.

Signed-off-by: Naresh Solanki <naresh.solanki@9elements.com>
---
 drivers/regulator/max5970-regulator.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/regulator/max5970-regulator.c b/drivers/regulator/max5970-regulator.c
index 56cc56ae63b7..bc88a40a88d4 100644
--- a/drivers/regulator/max5970-regulator.c
+++ b/drivers/regulator/max5970-regulator.c
@@ -584,7 +584,6 @@ static int max597x_regulator_probe(struct platform_device *pdev)
 	else
 		return -ENODEV;
 
-	i2c_set_clientdata(i2c, max597x);
 	num_switches = max597x->num_switches;
 
 	for (i = 0; i < num_switches; i++) {
-- 
2.41.0

