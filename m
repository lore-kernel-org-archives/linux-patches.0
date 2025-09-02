Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665C321255E;
	Tue,  2 Sep 2025 13:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820719; cv=none; b=XddJp+X1lSoFUJkIH8bUkqOIXSSSlbqFibehvSFDtKkJt13XYieUX8KfEwPCxUz/hD1jpPFauP7MUuY5iwYGuVNFp9LIhIgz2922SRZyojYB1gUVOvzIopwf7XjwQbp/8PWiO9KKiYJqlORBP+N8HnOHTZonP6r2UoH3Zcm3m2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820719; c=relaxed/simple;
	bh=MoLuwKynvoOCB8yAEGb3RHzdheb6YRgqmUaaGmN40LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cqqfofoeSHfvv+ffsfFns3pNRo99adxdSf7IOhnv8QV4CLUpcOLcVU1zSyT3PHRjPcZA1BhzXtXM/MJuUDIoJX18RtLRT+OgHpDHOFxFhP7ZJE9Y7pzRQFTDXCgpzstacCWGj/FfuvZctV2erjXRdm7uQvv3iqphZXEX/rvyPBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tOl/CItR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOl/CItR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA709C4CEED;
	Tue,  2 Sep 2025 13:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820719;
	bh=MoLuwKynvoOCB8yAEGb3RHzdheb6YRgqmUaaGmN40LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tOl/CItRls6iaAmHwIgtwE5SXnh8j2oCUjWYu8yY3IpIDehurvjS3/EgZA1+it4vz
	 SHhFiAwLDSJNRUFz2OlNUcuKCuNQOVazJjpfkOt71OS6DLJV9ySZw85qyDAWgYzM7g
	 Z7s/eOTQWuZ3j9LawR5VRpgqq6xpO6srPV5Zr8T4=
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
Subject: [PATCH 5.10 32/34] ASoC: Intel: glk_rt5682_max98357a: shrink platform_id below 20 characters
Date: Tue,  2 Sep 2025 15:21:58 +0200
Message-ID: <20250902131927.889659266@linuxfoundation.org>
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

commit bc47256afef38175a0ad6bcfd4dbab9d2c65b377 upstream.

Sparse throws the following warning:

sound/soc/intel/boards/glk_rt5682_max98357a.c:622:25: error: too long
initializer-string for array of char(no space for nul char)

Fix by using the 'mx' acronym for Maxim

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Paul Olaru <paul.olaru@oss.nxp.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Link: https://lore.kernel.org/r/20210621194057.21711-5-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Michał Górny <mgorny@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/boards/glk_rt5682_max98357a.c     |    4 ++--
 sound/soc/intel/common/soc-acpi-intel-glk-match.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/sound/soc/intel/boards/glk_rt5682_max98357a.c
+++ b/sound/soc/intel/boards/glk_rt5682_max98357a.c
@@ -621,7 +621,7 @@ static int geminilake_audio_probe(struct
 
 static const struct platform_device_id glk_board_ids[] = {
 	{
-		.name = "glk_rt5682_max98357a",
+		.name = "glk_rt5682_mx98357a",
 		.driver_data =
 			(kernel_ulong_t)&glk_audio_card_rt5682_m98357a,
 	},
@@ -643,4 +643,4 @@ MODULE_DESCRIPTION("Geminilake Audio Mac
 MODULE_AUTHOR("Naveen Manohar <naveen.m@intel.com>");
 MODULE_AUTHOR("Harsha Priya <harshapriya.n@intel.com>");
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("platform:glk_rt5682_max98357a");
+MODULE_ALIAS("platform:glk_rt5682_mx98357a");
--- a/sound/soc/intel/common/soc-acpi-intel-glk-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-glk-match.c
@@ -33,7 +33,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_in
 	},
 	{
 		.id = "10EC5682",
-		.drv_name = "glk_rt5682_max98357a",
+		.drv_name = "glk_rt5682_mx98357a",
 		.fw_filename = "intel/dsp_fw_glk.bin",
 		.machine_quirk = snd_soc_acpi_codec_list,
 		.quirk_data = &glk_codecs,


