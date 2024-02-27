Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7527013B7AB;
	Tue, 27 Feb 2024 14:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044089; cv=none; b=ATr8/4lDP0aqPxt4SQq6nh99fXbRhf7VB4YuX9TKRKE9lN+zGGCPdn8t5A0us5cP6kMzicoB2hA9FdACBwKHfRvZUmscvxxTsd8ojBRkK4PwkSlm/MiiNZpu2d/ALpIAE5T12PvqGiyTiPGVR8dB1h5PvwlFVA0y+RsiywoD33Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044089; c=relaxed/simple;
	bh=PGRXWPYbVVmsb4+FGa4kTog/PtB/vf96SeB0nZMQqL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7o5i50d54LtAXGAKrN+H0p/wi3A+vHufXq01X7K5+JUh8Jkq+ckpF7Sjy9fF3hscz/zV28STo4pdlD8CnfcNrzkTFQYkEi+FAUPGxVYZw4tI3+++4FhUwGZvMaeqcomHQBQXCW6r726Nsdd/nGSvTxe2S5gHc7KuLU3AQkeVy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rScmn814; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rScmn814"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05896C433F1;
	Tue, 27 Feb 2024 14:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044089;
	bh=PGRXWPYbVVmsb4+FGa4kTog/PtB/vf96SeB0nZMQqL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rScmn8144oJwwwOrOkVQl/0oAMGu2NC9xo8uS8GmHOjsCy9v9daKX1lEjEni5zd5J
	 IC9YXsmT/Drq6ImQ6Xey6e/8cI9Ro7gJlfDwQ/Wm6kOYBTljlhaW0hxjjpocZa2Cz9
	 pRpqkQbIjlOOEo2R4lWiIgyDRkstDwZziix84Aw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/122] ASoC: Intel: boards: get codec device with ACPI instead of bus search
Date: Tue, 27 Feb 2024 14:26:59 +0100
Message-ID: <20240227131600.604705683@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit d3409eb20d3ed7d9e021cd13243e9e63255a315f ]

We have an existing 'adev' handle from which we can find the codec
device, no need for an I2C bus search.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210813151116.23931-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 721858823d7c ("ASoC: Intel: bytcr_rt5651: Drop reference count of ACPI device after use")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcht_es8316.c | 4 ++--
 sound/soc/intel/boards/bytcr_rt5640.c  | 5 ++---
 sound/soc/intel/boards/bytcr_rt5651.c  | 6 ++----
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/sound/soc/intel/boards/bytcht_es8316.c b/sound/soc/intel/boards/bytcht_es8316.c
index 91351b8536aa1..03b9cdbd3170f 100644
--- a/sound/soc/intel/boards/bytcht_es8316.c
+++ b/sound/soc/intel/boards/bytcht_es8316.c
@@ -550,9 +550,10 @@ static int snd_byt_cht_es8316_mc_probe(struct platform_device *pdev)
 	}
 
 	/* get speaker enable GPIO */
-	codec_dev = bus_find_device_by_name(&i2c_bus_type, NULL, codec_name);
+	codec_dev = acpi_get_first_physical_node(adev);
 	if (!codec_dev)
 		return -EPROBE_DEFER;
+	priv->codec_dev = get_device(codec_dev);
 
 	if (quirk & BYT_CHT_ES8316_JD_INVERTED)
 		props[cnt++] = PROPERTY_ENTRY_BOOL("everest,jack-detect-inverted");
@@ -570,7 +571,6 @@ static int snd_byt_cht_es8316_mc_probe(struct platform_device *pdev)
 		gpiod_get_index(codec_dev, "speaker-enable", 0,
 				/* see comment in byt_cht_es8316_resume */
 				GPIOD_OUT_LOW | GPIOD_FLAGS_BIT_NONEXCLUSIVE);
-	priv->codec_dev = codec_dev;
 
 	if (IS_ERR(priv->speaker_en_gpio)) {
 		ret = PTR_ERR(priv->speaker_en_gpio);
diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index b531c348fb697..f5b1b3b876980 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -1425,11 +1425,10 @@ static int snd_byt_rt5640_mc_probe(struct platform_device *pdev)
 		byt_rt5640_quirk = quirk_override;
 	}
 
-	codec_dev = bus_find_device_by_name(&i2c_bus_type, NULL, byt_rt5640_codec_name);
+	codec_dev = acpi_get_first_physical_node(adev);
 	if (!codec_dev)
 		return -EPROBE_DEFER;
-
-	priv->codec_dev = codec_dev;
+	priv->codec_dev = get_device(codec_dev);
 
 	/* Must be called before register_card, also see declaration comment. */
 	ret_val = byt_rt5640_add_codec_device_props(codec_dev, priv);
diff --git a/sound/soc/intel/boards/bytcr_rt5651.c b/sound/soc/intel/boards/bytcr_rt5651.c
index acea83e814acb..472f6e3327960 100644
--- a/sound/soc/intel/boards/bytcr_rt5651.c
+++ b/sound/soc/intel/boards/bytcr_rt5651.c
@@ -926,10 +926,10 @@ static int snd_byt_rt5651_mc_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	codec_dev = bus_find_device_by_name(&i2c_bus_type, NULL,
-					    byt_rt5651_codec_name);
+	codec_dev = acpi_get_first_physical_node(adev);
 	if (!codec_dev)
 		return -EPROBE_DEFER;
+	priv->codec_dev = get_device(codec_dev);
 
 	/*
 	 * swap SSP0 if bytcr is detected
@@ -996,8 +996,6 @@ static int snd_byt_rt5651_mc_probe(struct platform_device *pdev)
 		byt_rt5651_quirk = quirk_override;
 	}
 
-	priv->codec_dev = codec_dev;
-
 	/* Must be called before register_card, also see declaration comment. */
 	ret_val = byt_rt5651_add_codec_device_props(codec_dev);
 	if (ret_val)
-- 
2.43.0



