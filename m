Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32532C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08EABC433EF;
	Tue,  7 Feb 2023 13:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775352;
	bh=NLnR/V9Y30Xfga6MRPtnaLANKfVCxmwjwUPK0q84qLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O9ZOMuO3OWgaRF0SQTCMwBnVuwMo/JniQ1PFpusYebY0kBE2IfG1Fdct+l2fo9W8o
	 zggKjfTcDXLO2Dh85iMfXjKAgUOynCX68kj1zDqhtb6jQN0jqajye/hXbyx7by3V2j
	 IxdeWcNeb83Rqxcke/sVgL10NAJT6lpaVVaelfVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/120] ASoC: Intel: bytcht_es8316: move comment to the right place
Date: Tue,  7 Feb 2023 13:56:15 +0100
Message-Id: <20230207125618.923225198@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit fe0596a006081bc963874d4f3d38cd0b1b5e46d4 ]

Additional code was added and the comment on the speaker GPIO needs to
be moved before we actually try to get the GPIO.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20220308192610.392950-21-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 6b1c0bd6fdef ("ASoC: Intel: bytcht_es8316: Drop reference count of ACPI device after use")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcht_es8316.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/bytcht_es8316.c b/sound/soc/intel/boards/bytcht_es8316.c
index 78b7e24b0c79..95058398b1be 100644
--- a/sound/soc/intel/boards/bytcht_es8316.c
+++ b/sound/soc/intel/boards/bytcht_es8316.c
@@ -542,7 +542,6 @@ static int snd_byt_cht_es8316_mc_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->mclk))
 		return dev_err_probe(dev, PTR_ERR(priv->mclk), "clk_get pmc_plt_clk_3 failed\n");
 
-	/* get speaker enable GPIO */
 	codec_dev = acpi_get_first_physical_node(adev);
 	if (!codec_dev)
 		return -EPROBE_DEFER;
@@ -568,6 +567,7 @@ static int snd_byt_cht_es8316_mc_probe(struct platform_device *pdev)
 		}
 	}
 
+	/* get speaker enable GPIO */
 	devm_acpi_dev_add_driver_gpios(codec_dev, byt_cht_es8316_gpios);
 	priv->speaker_en_gpio =
 		gpiod_get_optional(codec_dev, "speaker-enable",
-- 
2.39.0



