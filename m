Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5C01EF39E;
	Tue, 26 Aug 2025 13:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214373; cv=none; b=UZyJB2Gd84fR0hDMvepoxrWhQwu6tD/0n5qx88QdMXYd4LN6AIo8BU77ai8drLdZ9e6S1+fsOMZfSxv8u7A3gRLCIP+OgKQ0rwcfTEvyKdKM4+CwK+jkVmA2nZ64qUDKgaENdpJsMfzY31e1v9Etpd/DMy/y6CwfrMIKyuutd98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214373; c=relaxed/simple;
	bh=ZToNr4ufEQO4YuI2zW0G0Icwtj2qCxodKuII3K3wReY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qiq3nZKQY4TXoPBQVzbon3OmJtMzMosoigNQwuILqRwIqNgBeU+2TI/1vbTJxIChjyvfPHtd86oE6EnLG8aTMCJAk2CzGfLc9ql+B7/xJ3Rs6+edMUXPgxi23HySZMcRAgrnGXR675IMMzYAUbCe5yHR5YUFGcp5NA0UR6+nrho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rm8SsejF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rm8SsejF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892FBC4CEF1;
	Tue, 26 Aug 2025 13:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214373;
	bh=ZToNr4ufEQO4YuI2zW0G0Icwtj2qCxodKuII3K3wReY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rm8SsejFvl6+JDjB+k3bDiLD5aI/QMUfe0Ll/YoPx9FhesMES5NOf+uO/EfvVhuT/
	 Et3Pqx8vxt8tn4QTRd0DkHGKaiW3iCHpU6XGuEf6d2MQ2iR50Xu07fMD0y19xzgzt6
	 996GF4tvYyKBqUFoJrQT8XBydcUk+Csbxix2Fc9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Xinxin Wan <xinxin.wan@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 112/482] ASoC: codecs: rt5640: Retry DEVICE_ID verification
Date: Tue, 26 Aug 2025 13:06:05 +0200
Message-ID: <20250826110933.595989456@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 37ea4d854cb5..3185bf13dc42 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -3026,6 +3026,11 @@ static int rt5640_i2c_probe(struct i2c_client *i2c)
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



