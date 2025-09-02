Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028412DFA39;
	Tue,  2 Sep 2025 13:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820713; cv=none; b=Ra45TPLtIZtfE36tjPSehkfTOWB9huRE580sBJc1YJjq1pW/P2LHnhD+fQIrXlki6tvzz0PniZQ8v37fMxP2DkSM+n3sdMGXhM+fa/9mBRiUsiWiv0w3H9dRQkbsB4jWaLAgYp2id4mBfGwAanKbe6SH+ach7s43/mmRtbhcYKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820713; c=relaxed/simple;
	bh=KXVzDdYviA2Y8tVxc9RQkNIL8+L9yidOnhmHTdyqj+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iTIoSjVaPeu5C10COYC4sU6NFcKITRc6jTG4jfHbg2Wsibb/haJ49Orq+R6dFF/nnXO8VNJJZ9x1oVTQu21CD33JU6WPsrbtrGEFmrPXgRUtIU3ixz8+leGgkepl1Jat0gXy0TGBwxaSc7+cvBQuKl0WFE5TqcEi30vgwkk6E40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=swf70X3d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="swf70X3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB44C4CEF4;
	Tue,  2 Sep 2025 13:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820712;
	bh=KXVzDdYviA2Y8tVxc9RQkNIL8+L9yidOnhmHTdyqj+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=swf70X3dlUI6c7gwrLXiGsHT7htHak8Gwso8BXth20yNtRCKBO0geAwDYa0gJ+vzZ
	 0sZSxWU+9vSXYYH7jaHxpqHid2zUhC3AKcqCBCWemnRBk7Es9+Je8l5H1fRUELsczO
	 T6g1906NwNKjsYar549DpOWMVs3+Q1LB0L7Q+JOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Paul Olaru <paul.olaru@oss.nxp.com>,
	Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Mark Brown <broonie@kernel.org>,
	=?UTF-8?q?Micha=C5=82=20G=C3=B3rny?= <mgorny@gentoo.org>
Subject: [PATCH 5.10 30/34] ASoC: Intel: bxt_da7219_max98357a: shrink platform_id below 20 characters
Date: Tue,  2 Sep 2025 15:21:56 +0200
Message-ID: <20250902131927.813850406@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131926.607219059@linuxfoundation.org>
References: <20250902131926.607219059@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

commit 24e46fb811e991f56d5694b10ae7ceb8d2b8c846 upstream.

Sparse throwns the following warnings:

sound/soc/intel/boards/bxt_da7219_max98357a.c:843:19: error: too long
initializer-string for array of char(no space for nul char)

sound/soc/intel/boards/bxt_da7219_max98357a.c:844:19: error: too long
initializer-string for array of char(no space for nul char)

sound/soc/intel/boards/bxt_da7219_max98357a.c:845:19: error: too long
initializer-string for array of char(no space for nul char)

Fix by using the 'mx' acronyn for Maxim

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Paul Olaru <paul.olaru@oss.nxp.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Link: https://lore.kernel.org/r/20210511213707.32958-5-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Michał Górny <mgorny@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/boards/bxt_da7219_max98357a.c     |   12 ++++++------
 sound/soc/intel/common/soc-acpi-intel-bxt-match.c |    2 +-
 sound/soc/intel/common/soc-acpi-intel-cml-match.c |    2 +-
 sound/soc/intel/common/soc-acpi-intel-glk-match.c |    2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

--- a/sound/soc/intel/boards/bxt_da7219_max98357a.c
+++ b/sound/soc/intel/boards/bxt_da7219_max98357a.c
@@ -840,9 +840,9 @@ static int broxton_audio_probe(struct pl
 }
 
 static const struct platform_device_id bxt_board_ids[] = {
-	{ .name = "bxt_da7219_max98357a" },
-	{ .name = "glk_da7219_max98357a" },
-	{ .name = "cml_da7219_max98357a" },
+	{ .name = "bxt_da7219_mx98357a" },
+	{ .name = "glk_da7219_mx98357a" },
+	{ .name = "cml_da7219_mx98357a" },
 	{ }
 };
 
@@ -866,6 +866,6 @@ MODULE_AUTHOR("Naveen Manohar <naveen.m@
 MODULE_AUTHOR("Mac Chiang <mac.chiang@intel.com>");
 MODULE_AUTHOR("Brent Lu <brent.lu@intel.com>");
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("platform:bxt_da7219_max98357a");
-MODULE_ALIAS("platform:glk_da7219_max98357a");
-MODULE_ALIAS("platform:cml_da7219_max98357a");
+MODULE_ALIAS("platform:bxt_da7219_mx98357a");
+MODULE_ALIAS("platform:glk_da7219_mx98357a");
+MODULE_ALIAS("platform:cml_da7219_mx98357a");
--- a/sound/soc/intel/common/soc-acpi-intel-bxt-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-bxt-match.c
@@ -56,7 +56,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_in
 	},
 	{
 		.id = "DLGS7219",
-		.drv_name = "bxt_da7219_max98357a",
+		.drv_name = "bxt_da7219_mx98357a",
 		.fw_filename = "intel/dsp_fw_bxtn.bin",
 		.machine_quirk = snd_soc_acpi_codec_list,
 		.quirk_data = &bxt_codecs,
--- a/sound/soc/intel/common/soc-acpi-intel-cml-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-cml-match.c
@@ -54,7 +54,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_in
 	},
 	{
 		.id = "DLGS7219",
-		.drv_name = "cml_da7219_max98357a",
+		.drv_name = "cml_da7219_mx98357a",
 		.machine_quirk = snd_soc_acpi_codec_list,
 		.quirk_data = &max98357a_spk_codecs,
 		.sof_fw_filename = "sof-cml.ri",
--- a/sound/soc/intel/common/soc-acpi-intel-glk-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-glk-match.c
@@ -24,7 +24,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_in
 	},
 	{
 		.id = "DLGS7219",
-		.drv_name = "glk_da7219_max98357a",
+		.drv_name = "glk_da7219_mx98357a",
 		.fw_filename = "intel/dsp_fw_glk.bin",
 		.machine_quirk = snd_soc_acpi_codec_list,
 		.quirk_data = &glk_codecs,


