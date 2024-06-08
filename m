Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3867CF3A
	for <patches@lists.linux.dev>; Mon, 10 Jun 2024 11:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718019851; cv=none; b=kwdaIWpG87Vx4De1YSNMVX1XEcpI/VLHBiizX9fagU7Irn7yiSmTLg1jpi372xjlKdYKnk3xPwx7kSaDCdPIvy//mLZ9q5yxYL+mrfwGfcqFLjIXn40p+IaubzgQKwhRpp6xFOjV5yA4JBKUvEgPva9+0EPo5zRSxbF0MSXGfAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718019851; c=relaxed/simple;
	bh=iasMPsjTIIl0wiJ+B4NZRS3IvetptYUFOt5XGcQ3kxA=;
	h=From:To:Cc:Date:Message-ID:MIME-Version:Subject; b=jllaNbGVChXuKBReH3BHitl5d4S74sQgw14F2hWekaW28jAuBBgRA+2PKCAc2lzkNhcJwCqis2chpeBBN0pZYKjSfgXAeXk8pWJg7lUiIZ/aXGUHUIkUO0SgdEZ8b9sl5azRSFmvGO8nNmECUndShd4XyiCZnXxCJ8WkwFtsDO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PhmI2Pxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PhmI2Pxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D012C2BBFC
	for <patches@lists.linux.dev>; Mon, 10 Jun 2024 11:44:10 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PhmI2Pxd"
Resent-From: Mark Brown <broonie@finisterre.sirena.org.uk>
Resent-Date: Mon, 10 Jun 2024 12:44:06 +0100
Resent-Message-ID: <ZmbnBnIJw7qRE6vh@finisterre.sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Sat, 08 Jun 2024 18:04:13 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=9IoG=NK=gmail.com=tomlohave@kernel.org>)
	id 1sFzUB-004zlo-Dj
	for broonie@sirena.co.uk; Sat, 08 Jun 2024 18:04:13 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 1273D60AD1
	for <broonie@sirena.co.uk>; Sat,  8 Jun 2024 17:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id CEB1EC32781; Sat,  8 Jun 2024 17:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03BD9C2BD11
	for <broonie@kernel.org>; Sat,  8 Jun 2024 17:04:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 03BD9C2BD11
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-354f3f6c3b1so2500693f8f.2
        for <broonie@kernel.org>; Sat, 08 Jun 2024 10:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717866247; x=1718471047; darn=kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gmv50GhHZu58VKL76+T2pNmo6gyWm+ZTMKg/2mOfzBg=;
        b=PhmI2PxdgL/uqHtOd+Pks9key8gzCBCRX79x/7ND1CoFiCKrYDDY+SoTl3e2isfw4z
         s9sZNdECFg5y9vF+jpY5TfMm536qMbP7nCZTl3iUw96YUYbIx1tRg1a/BggmvvkDcZpP
         zy1tobAWHkC79oAWg/7PBHCADPdTz2htTNPRFGBXlFLwxTxykmbL8MFpq9ZbaZCUKSzU
         EOy4/of+8LB0gSAHSDpGbQnxUeVdk4Z12RjNuCrn9e5mMAgcQJRZ3fnWH79WLK6hJgCk
         fkLmZZzjIGNuX9cWyyoDYFgBQ4LZx6Xl2OxoXlYs3mBft55vBEqufR+8+ITTFNNjYSKu
         MyoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717866247; x=1718471047;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gmv50GhHZu58VKL76+T2pNmo6gyWm+ZTMKg/2mOfzBg=;
        b=An0rioQoHy+cEOPs38/D331/TnysaDaUp8+QsDplRYS7Vv2I8tnFiZF2odrWe1Kgdv
         onatghtK/sSCv/5Ltm6yQxQ09yx7jxHfOz0dtM+0WPCUYUFs4/bWSTzgd9P9u9aIVx1v
         J15sqIncjT3+5vnDbjFUwr6cog8j+QBN1uOoxEBv1g0bpAos7mQwsZTL5tWxmaC20bZG
         p6GIukaTvdfR++LEw2o9vEcjHhDChVi+6HOYE+BVbi97xU/gBG5di5dXSCIdHiaqLgL6
         dprGFh9kbMdt7/sZMAnX0pOzoLUgqHzMqoPahWyu4CWzw+HUbTVx0p2Ye4kC9I0q030I
         zrPA==
X-Forwarded-Encrypted: i=1; AJvYcCVeE3Wd/ijMd/HVIHxu78dRkISmzm0GK6iUKsCHi1NaqWn6M3dnUIgkCSucHIK78gz8gOntqxaI0q4+A+ReB7q5C5U=
X-Gm-Message-State: AOJu0Yxe0MXB0/YBZINcBdubwz+Z0W/9zHcyJXjcHiiNSZL4mLCeHOiK
	RtMUALROxGQahO6Fx3RFCmU/rQaHzx6BRQBZMrFGkLsjUJ0JM3wS
X-Google-Smtp-Source: AGHT+IE3hio7ZuF9rGmHS5+CsVeV64HoO1ZxJglfoxi+Kqtz9ITnnSTQ7rSr108dQpfOOQHcjnlviA==
X-Received: by 2002:adf:f2c4:0:b0:35f:15fc:6025 with SMTP id ffacd0b85a97d-35f15fc60cemr1268148f8f.24.1717866247072;
        Sat, 08 Jun 2024 10:04:07 -0700 (PDT)
Received: from fedora.. ([2a01:e0a:a9f:60f0:5d0b:d730:cb58:674c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35ef5e9b022sm6789446f8f.79.2024.06.08.10.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jun 2024 10:04:06 -0700 (PDT)
From: Thomas GENTY <tomlohave@gmail.com>
To: pierre-louis.bossart@linux.intel.com,
	broonie@kernel.org
Cc: cezary.rojewski@intel.com,
	liam.r.girdwood@linux.intel.com,
	peter.ujfalusi@linux.intel.com,
	yung-chuan.liao@linux.intel.com,
	alsa-devel@alsa-project.org,
	Thomas GENTY <tomlohave@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Date: Sat,  8 Jun 2024 19:02:51 +0200
Message-ID: <20240608170251.99936-1-tomlohave@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=9IoG=NK=gmail.com=tomlohave@kernel.org
Subject: [PATCH] bytcr_rt5640 : inverse jack detect for Archos 101 cesium
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: KuzKiFAHeq9h

When headphones are plugged in, they appear absent; when they are removed,
they appear present.
Add a specific entry in bytcr_rt5640 for this device

Signed-off-by: Thomas GENTY <tomlohave@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index b41a1147f1c3..a64d1989e28a 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -610,6 +610,17 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 					BYT_RT5640_SSP0_AIF1 |
 					BYT_RT5640_MCLK_EN),
 	},
+	{
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ARCHOS"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "ARCHOS 101 CESIUM"),
+		},
+		.driver_data = (void *)(BYTCR_INPUT_DEFAULTS |
+					BYT_RT5640_JD_NOT_INV |
+					BYT_RT5640_DIFF_MIC |
+					BYT_RT5640_SSP0_AIF1 |
+					BYT_RT5640_MCLK_EN),
+	},
 	{
 		.matches = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ARCHOS"),
-- 
2.45.2

