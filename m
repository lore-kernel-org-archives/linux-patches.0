Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AB61DE2A5;
	Tue,  8 Oct 2024 12:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390100; cv=none; b=QDulnakrwSbjmx3Dxb/5tABYvOUA7e1s+VkE89GbVCfd5hCetS8Oqkai80YvC6zoWSFrYL/brAlwFtLUWLWPPYvJkVNYhfOnZnRnveFjghoW7tpcP9j+Q96X/sDwbzLMXrPzsOIgAAB0Co/ozhYajQRvF0GjnEWHw8jVyxQ//NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390100; c=relaxed/simple;
	bh=/p7pP+e6HP8E4D72IwnEbO4s7lmE7MXX5Veolg9RxMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tsb/M0DmiQFdxf/0hwfPMjxEqlUPzBgfF2Cfih2VqHwRbrDNxa3JXZgA2jxgLZEQJzk2kN1prSNfd7jNMoBnxUVGhhlNP4Dd3vOY85RL/nnWJNF0FKkLTl1XkOKFTTA5u7ocWTzWV+KwtHcHATsJudDtU2GwcwPACU1VFkHiDuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywMd6nvY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywMd6nvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3079FC4CEC7;
	Tue,  8 Oct 2024 12:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390099;
	bh=/p7pP+e6HP8E4D72IwnEbO4s7lmE7MXX5Veolg9RxMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ywMd6nvYpQlYlrKII9ZhlloXcmlg6fL5jXJvkbio1e/d1xy9m66DMgfjxjugjI+At
	 VVHHfIbqekkxXklnwWC9uC5ejjGj9c6jP8wO1CASDcCQ7N+MC3kqnWSEavrKc7n0y5
	 QE35gLe+KYMjDmOs8eO6zFEgjxGwYJeaXMomqlO4=
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
Subject: [PATCH 6.10 159/482] ASoC: Intel: boards: always check the result of acpi_dev_get_first_match_dev()
Date: Tue,  8 Oct 2024 14:03:42 +0200
Message-ID: <20241008115654.563638438@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index c1fcc156a5752..809532238c44f 100644
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
index 4cb0d463bf404..9c5b3f8f09f36 100644
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



