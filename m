Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C671DE2A5;
	Tue,  8 Oct 2024 12:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391666; cv=none; b=cffPf/CMqN1TUdAobUel+3OnD8nDmWZGFiTWXiN0JAlCi/OHslQPIsj1+Tshuwert7cz8E3RCL7R2CqiVr2rjTFCYV10z0WUmJFswrVl5Z5bMf2j18U/9HYF+QxSt+79T1NTnbmiXA1rdy9VtXUEJD9fKn/wEQ4ob2IuTjWlgC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391666; c=relaxed/simple;
	bh=l6CBghAtuBUpZTWvIQsBZzazWGmfNIhgjhFsHzvP5EA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K8W0KwDOKDdoqhTGO83kvMuyasO8CwnaYXTyN9UlsMAGetYk9r74+4saq+WcRXRaboIjHn2SAUbtE63t1t+Rmg7XRPKy0NDK6Ij1y47drAkHzPJ4794CXqKZCZzZQqODx71qF+WMr3FfuRUcPaM+fTgFfhJ5N0GVhZWunklfoaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jubCWtps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jubCWtps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D9BC4CECC;
	Tue,  8 Oct 2024 12:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391666;
	bh=l6CBghAtuBUpZTWvIQsBZzazWGmfNIhgjhFsHzvP5EA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jubCWtpstl2IsQnkDi52pZlSaUCBzI23ESmIbeybvQpmECX7J/3SrgX3SwA9KjQt8
	 RcAlcei4BKe+0h7V/97MZ2Lp6BBl5ViRrG3NVpshw0thOptGku7e2oP/v8HP64mFo2
	 BRqtXtL4ypnZYzk5qQSDirdT2CtF+sC48GRDh5Xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 187/558] ASoC: Intel: boards: always check the result of acpi_dev_get_first_match_dev()
Date: Tue,  8 Oct 2024 14:03:37 +0200
Message-ID: <20241008115709.710476832@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 14e91ddd5c02d8c3e5a682ebfa0546352b459911 ]

The code seems mostly copy-pasted, with some machine drivers
forgetting to test if the 'adev' result is NULL.

Add this check when missing, and use -ENOENT consistently as an error
code.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/alsa-devel/918944d2-3d00-465e-a9d1-5d57fc966113@stanley.mountain/T/#u
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20240827123215.258859-4-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcht_cx2072x.c | 4 ++++
 sound/soc/intel/boards/bytcht_da7213.c  | 4 ++++
 sound/soc/intel/boards/bytcht_es8316.c  | 2 +-
 sound/soc/intel/boards/bytcr_rt5640.c   | 2 +-
 sound/soc/intel/boards/bytcr_rt5651.c   | 2 +-
 sound/soc/intel/boards/cht_bsw_rt5645.c | 4 ++++
 sound/soc/intel/boards/cht_bsw_rt5672.c | 4 ++++
 sound/soc/intel/boards/sof_es8336.c     | 2 +-
 sound/soc/intel/boards/sof_wm8804.c     | 4 ++++
 9 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/sound/soc/intel/boards/bytcht_cx2072x.c b/sound/soc/intel/boards/bytcht_cx2072x.c
index df3c2a7b64d23..8c2b4ab764bba 100644
--- a/sound/soc/intel/boards/bytcht_cx2072x.c
+++ b/sound/soc/intel/boards/bytcht_cx2072x.c
@@ -255,7 +255,11 @@ static int snd_byt_cht_cx2072x_probe(struct platform_device *pdev)
 		snprintf(codec_name, sizeof(codec_name), "i2c-%s",
 			 acpi_dev_name(adev));
 		byt_cht_cx2072x_dais[dai_index].codecs->name = codec_name;
+	} else {
+		dev_err(&pdev->dev, "Error cannot find '%s' dev\n", mach->id);
+		return -ENOENT;
 	}
+
 	acpi_dev_put(adev);
 
 	/* override platform name, if required */
diff --git a/sound/soc/intel/boards/bytcht_da7213.c b/sound/soc/intel/boards/bytcht_da7213.c
index 08c598b7e1eee..9178bbe8d9950 100644
--- a/sound/soc/intel/boards/bytcht_da7213.c
+++ b/sound/soc/intel/boards/bytcht_da7213.c
@@ -258,7 +258,11 @@ static int bytcht_da7213_probe(struct platform_device *pdev)
 		snprintf(codec_name, sizeof(codec_name),
 			 "i2c-%s", acpi_dev_name(adev));
 		dailink[dai_index].codecs->name = codec_name;
+	} else {
+		dev_err(&pdev->dev, "Error cannot find '%s' dev\n", mach->id);
+		return -ENOENT;
 	}
+
 	acpi_dev_put(adev);
 
 	/* override platform name, if required */
diff --git a/sound/soc/intel/boards/bytcht_es8316.c b/sound/soc/intel/boards/bytcht_es8316.c
index 77b91ea4dc32c..3539c9ff0fd2c 100644
--- a/sound/soc/intel/boards/bytcht_es8316.c
+++ b/sound/soc/intel/boards/bytcht_es8316.c
@@ -562,7 +562,7 @@ static int snd_byt_cht_es8316_mc_probe(struct platform_device *pdev)
 		byt_cht_es8316_dais[dai_index].codecs->name = codec_name;
 	} else {
 		dev_err(dev, "Error cannot find '%s' dev\n", mach->id);
-		return -ENXIO;
+		return -ENOENT;
 	}
 
 	codec_dev = acpi_get_first_physical_node(adev);
diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index db4a33680d948..4479825c08b5e 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -1693,7 +1693,7 @@ static int snd_byt_rt5640_mc_probe(struct platform_device *pdev)
 		byt_rt5640_dais[dai_index].codecs->name = byt_rt5640_codec_name;
 	} else {
 		dev_err(dev, "Error cannot find '%s' dev\n", mach->id);
-		return -ENXIO;
+		return -ENOENT;
 	}
 
 	codec_dev = acpi_get_first_physical_node(adev);
diff --git a/sound/soc/intel/boards/bytcr_rt5651.c b/sound/soc/intel/boards/bytcr_rt5651.c
index 8514b79f389bb..1f54da98aacf4 100644
--- a/sound/soc/intel/boards/bytcr_rt5651.c
+++ b/sound/soc/intel/boards/bytcr_rt5651.c
@@ -926,7 +926,7 @@ static int snd_byt_rt5651_mc_probe(struct platform_device *pdev)
 		byt_rt5651_dais[dai_index].codecs->name = byt_rt5651_codec_name;
 	} else {
 		dev_err(dev, "Error cannot find '%s' dev\n", mach->id);
-		return -ENXIO;
+		return -ENOENT;
 	}
 
 	codec_dev = acpi_get_first_physical_node(adev);
diff --git a/sound/soc/intel/boards/cht_bsw_rt5645.c b/sound/soc/intel/boards/cht_bsw_rt5645.c
index 1da9ceee4d593..ac23a8b7cafca 100644
--- a/sound/soc/intel/boards/cht_bsw_rt5645.c
+++ b/sound/soc/intel/boards/cht_bsw_rt5645.c
@@ -582,7 +582,11 @@ static int snd_cht_mc_probe(struct platform_device *pdev)
 		snprintf(cht_rt5645_codec_name, sizeof(cht_rt5645_codec_name),
 			 "i2c-%s", acpi_dev_name(adev));
 		cht_dailink[dai_index].codecs->name = cht_rt5645_codec_name;
+	} else {
+		dev_err(&pdev->dev, "Error cannot find '%s' dev\n", mach->id);
+		return -ENOENT;
 	}
+
 	/* acpi_get_first_physical_node() returns a borrowed ref, no need to deref */
 	codec_dev = acpi_get_first_physical_node(adev);
 	acpi_dev_put(adev);
diff --git a/sound/soc/intel/boards/cht_bsw_rt5672.c b/sound/soc/intel/boards/cht_bsw_rt5672.c
index d68e5bc755dee..c6c469d51243e 100644
--- a/sound/soc/intel/boards/cht_bsw_rt5672.c
+++ b/sound/soc/intel/boards/cht_bsw_rt5672.c
@@ -479,7 +479,11 @@ static int snd_cht_mc_probe(struct platform_device *pdev)
 		snprintf(drv->codec_name, sizeof(drv->codec_name),
 			 "i2c-%s", acpi_dev_name(adev));
 		cht_dailink[dai_index].codecs->name = drv->codec_name;
+	}  else {
+		dev_err(&pdev->dev, "Error cannot find '%s' dev\n", mach->id);
+		return -ENOENT;
 	}
+
 	acpi_dev_put(adev);
 
 	/* Use SSP0 on Bay Trail CR devices */
diff --git a/sound/soc/intel/boards/sof_es8336.c b/sound/soc/intel/boards/sof_es8336.c
index 2a88efaa6d26b..b45d0501f1090 100644
--- a/sound/soc/intel/boards/sof_es8336.c
+++ b/sound/soc/intel/boards/sof_es8336.c
@@ -681,7 +681,7 @@ static int sof_es8336_probe(struct platform_device *pdev)
 			dai_links[0].codecs->dai_name = "ES8326 HiFi";
 	} else {
 		dev_err(dev, "Error cannot find '%s' dev\n", mach->id);
-		return -ENXIO;
+		return -ENOENT;
 	}
 
 	codec_dev = acpi_get_first_physical_node(adev);
diff --git a/sound/soc/intel/boards/sof_wm8804.c b/sound/soc/intel/boards/sof_wm8804.c
index b2d02cc92a6a8..0a5ce34d7f7bb 100644
--- a/sound/soc/intel/boards/sof_wm8804.c
+++ b/sound/soc/intel/boards/sof_wm8804.c
@@ -270,7 +270,11 @@ static int sof_wm8804_probe(struct platform_device *pdev)
 		snprintf(codec_name, sizeof(codec_name),
 			 "%s%s", "i2c-", acpi_dev_name(adev));
 		dailink[dai_index].codecs->name = codec_name;
+	} else {
+		dev_err(&pdev->dev, "Error cannot find '%s' dev\n", mach->id);
+		return -ENOENT;
 	}
+
 	acpi_dev_put(adev);
 
 	snd_soc_card_set_drvdata(card, ctx);
-- 
2.43.0



