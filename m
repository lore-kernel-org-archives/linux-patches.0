Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7694431CA55;
	Mon, 18 Aug 2025 12:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521910; cv=none; b=OIixas4Hwx+iFgzp3ZC/+qjdixB2Aghq6K9iGRVE9JF4WlEDOOTBcdY7kEp1kSTtdOnonOr+L4SYRIP8ZS4KNR7a4tmQ9wRZCMr/idipMWDghpjzOJVkVeZdBy4Rb9fDQYRPfP44UTgub1pI75cuyFj4R1fbwlGBDvAAbi6vw88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521910; c=relaxed/simple;
	bh=3zjicOOn+OPQ0759qYOzlPx3BH73adc2QlQIRXFmEfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ibiWs7MsxGgwJpETa01/GYKfS0pHrM0ZQNfSjxU5b5szOd1vLGGe8nQXxON1/WwQh2CIbyhnzaVBHQzSFRHtuedw/VuHEIe7GIro5B2RWDg/scmCli1HDVXLDSuAZ3myuhDwnf/g+UDjGjOVX/52mAE4bwvra8CIS8/ITtjK4hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0CzLzqZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0CzLzqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35706C4CEEB;
	Mon, 18 Aug 2025 12:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521909;
	bh=3zjicOOn+OPQ0759qYOzlPx3BH73adc2QlQIRXFmEfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j0CzLzqZAE6DXkgXnLtYik9IhefIwm9arhXfCgBfh2iKZRUuVkCikv9Yrl2QNcvcf
	 LVt7PfkkAtji/FbrsI7LvCTMwtbYbgdueQqDwMZlbEgrASHzMENOLZAuYo6ufz/vZF
	 IWU7wt+SbJJV/r2s3cVOULxh3lrwcl9E5oTY92RU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Xinxin Wan <xinxin.wan@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 159/444] ASoC: codecs: rt5640: Retry DEVICE_ID verification
Date: Mon, 18 Aug 2025 14:43:05 +0200
Message-ID: <20250818124454.858117474@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 855139348edb..c366ae2275e8 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -3013,6 +3013,11 @@ static int rt5640_i2c_probe(struct i2c_client *i2c)
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



