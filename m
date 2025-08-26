Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19927352062;
	Tue, 26 Aug 2025 13:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216245; cv=none; b=lCV5g4IdgMJujJmYhTMPQd518/tC9UgNKPtp+LthS24f//9DjTys0Tp/ZQOGcegFUHXiO9fevRrUmifwILnVHvtNNVj4o5Vead/FUMS6Sr4MAoyzgmphn95ZUvy4TZDQzbNAFbCkrWVIP8kodHGm+YQVLOh3PllcApd/0By+FWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216245; c=relaxed/simple;
	bh=y0MhgSIMfh5o0To8W9ZvDhAW2s/fgO8hkzAtWTz2k8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DvnV3oEjopBhW0++cpt/VB7NeoZmr1N+PaYmervPYkwIF4z6KAVmHQI68w1Gwg5Ga+1hzN9B4cy+rnYGChg299CgRt2bM6zwFpQK0ajDC4w1+NX69D8Frf29ZMFv7C+VVTQHGWJMgklLWJgwwbB8VOY/nmjNI3M7rRbuYr2PlgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHMTUeCX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHMTUeCX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C01AC4CEF1;
	Tue, 26 Aug 2025 13:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216245;
	bh=y0MhgSIMfh5o0To8W9ZvDhAW2s/fgO8hkzAtWTz2k8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aHMTUeCXThZGKvFvxqZQeEk2Im3LJhM8q9rSyh0XNUy8UIryXG1LqvvxoA8mztgyv
	 InedwC6Nn1O4C0XRt3+MzkR1TqRdyv0YFqTfPQWdU70RgS3OKRpXSVvDZgOXD+pY5J
	 VMgIUPGe7a379pJ9w9DyG1KRQLtxQ/gOtc/gGSw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Xinxin Wan <xinxin.wan@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 336/644] ASoC: codecs: rt5640: Retry DEVICE_ID verification
Date: Tue, 26 Aug 2025 13:07:07 +0200
Message-ID: <20250826110954.713777011@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xinxin Wan <xinxin.wan@intel.com>

[ Upstream commit 19f971057b2d7b99c80530ec1052b45de236a8da ]

To be more resilient to codec-detection failures when the hardware
powers on slowly, add retry mechanism to the device verification check.
Similar pattern is found throughout a number of Realtek codecs. Our
tests show that 60ms delay is sufficient to address readiness issues on
rt5640 chip.

Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Xinxin Wan <xinxin.wan@intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250530142120.2944095-3-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5640.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/codecs/rt5640.c b/sound/soc/codecs/rt5640.c
index cd1db5caabad..9998bdb954ba 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -2837,6 +2837,11 @@ static int rt5640_i2c_probe(struct i2c_client *i2c,
 	}
 
 	regmap_read(rt5640->regmap, RT5640_VENDOR_ID2, &val);
+	if (val != RT5640_DEVICE_ID) {
+		usleep_range(60000, 100000);
+		regmap_read(rt5640->regmap, RT5640_VENDOR_ID2, &val);
+	}
+
 	if (val != RT5640_DEVICE_ID) {
 		dev_err(&i2c->dev,
 			"Device with ID register %#x is not rt5640/39\n", val);
-- 
2.39.5



