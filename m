Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A657F
	for <patches@lists.linux.dev>; Tue,  3 May 2022 00:41:58 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id g8so11147954pfh.5
        for <patches@lists.linux.dev>; Mon, 02 May 2022 17:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=khN4bSzgSmeJrIrtbbdzuHfsBE5dtKb/D17YqTGzfL8=;
        b=XCO8kH0F5C04LPnTIDtteEB5GrIymqMB+WvOR2GPxPFQ9xKWdXuAju9Fd8Lteah3LV
         f4YfbhntC1qJBBlU9kdX42V0YIP5/HGfJ2LUXkT71UWH2KPOJ+367UujuCuMBbsjcgtv
         +nDQnnE36Rcv9LCYU9FRCyil9/jnvSBcMW9jY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=khN4bSzgSmeJrIrtbbdzuHfsBE5dtKb/D17YqTGzfL8=;
        b=JaQi3KoPmSv5HU1UhWyTwr7NmWie1dXmoeO06Fig1liQDmPbsuouuYi6fNkiO3mRkr
         8n4WapbLgrFXDNO/rvDLJpwKWAntNzvwjCNpn+KdXe74bwL0cXliB8rPN2+ithEX2PKQ
         TodnMsA02/Xq58GIl5Idxjb4em6qESjYrFsXzC+AjaOUAmpDwE8FJtVOW+nOJiZi+Qdd
         986gtKJPWXBtQZdAyZ2j0OVJUxDHiQqfRLhV4XQBmoZpdqu8pUC9p85n+urxvEBzE+Gg
         t5Z8s+haZH+ia60hGfPdYOkDtu+ELlrSekpa6p/HE/jB2mNi6iwz7DetONGNdEUfsnDV
         Rj0A==
X-Gm-Message-State: AOAM532LoDp6GLssLjwhAYG+eHPIjh345ysgljBgt1WiHp4UNgYPxa+T
	fGBSLt21I7vmO9aV1cJ78+ZqGA==
X-Google-Smtp-Source: ABdhPJzAgd+FaWOrobdXhjw9IxyYdko+Q1do11+CtCUhF7Ks1+/BdcIulft8Pi2z2X4LZbdJBn53uw==
X-Received: by 2002:a65:6aa3:0:b0:3ab:23fb:adae with SMTP id x3-20020a656aa3000000b003ab23fbadaemr11772254pgu.278.1651538518337;
        Mon, 02 May 2022 17:41:58 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:15e:c760:9a04:7fbe])
        by smtp.gmail.com with ESMTPSA id i10-20020aa78b4a000000b0050dc7628177sm5258794pfd.81.2022.05.02.17.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 17:41:57 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	devicetree@vger.kernel.org,
	linux-iio@vger.kernel.org,
	Gwendal Grignou <gwendal@chromium.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>
Subject: [PATCH 0/2] iio: sx9324: Support CS idle mode
Date: Mon,  2 May 2022 17:41:54 -0700
Message-Id: <20220503004156.3559940-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I need one more property to set another regsiter field for 
how to configure the CS pins during idle and sleep modes. This is based
on the latest patch series from Gwendal[1]

Stephen Boyd (2):
  dt-bindings: iio: sx9324: Add CS idle/sleep mode
  iio: sx9324: Add setting for CS idle mode

 .../bindings/iio/proximity/semtech,sx9324.yaml   |  8 ++++++++
 drivers/iio/proximity/sx9324.c                   | 16 ++++++++++++++++
 2 files changed, 24 insertions(+)

[1] https://lore.kernel.org/all/20220429220144.1476049-1-gwendal@chromium.org/

base-commit: d79478a79cfa393cde46bccb05d52fc7d875d2e2
prerequisite-patch-id: 05986765e921df4c9725d10a3f51e68b0b5cc211
prerequisite-patch-id: 5e47b28af046dce1eb7d7ca492c466df0f30e07c
prerequisite-patch-id: adb59d1a14b74ddfe02c442da8bcca04765e7d15
prerequisite-patch-id: ec6069ee00463db27826962537ff880e69522f70
prerequisite-patch-id: e40f2a3048da2ff28bb426b85e41d277f29f18ef
prerequisite-patch-id: 82077662b97c09014c5b291fe5a42938a29ddbcd
prerequisite-patch-id: d02f0ec3be1fa9cdbf02a22c700982008d0550bd
prerequisite-patch-id: a02a8faefc5b7b68b99c0cc326973948c9356b60
prerequisite-patch-id: 522c808e4b8bf99b8404c01d495526a685e5b97a
-- 
https://chromeos.dev

