Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB0D2FAC19;
	Tue,  2 Sep 2025 13:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820722; cv=none; b=e6tuTnY79zTXTg1ko/BgU9b4TstnhBFUenquCvOB9hfRn0rfEkJYOFmjbwxxqZEL1MuuYq6LJ1S1WJi/1+JLOb4vwLs7ESgQPKcqaWijEbdBsH0VgKOTo5HGtbBV2vwT/8DEqpfOhtYatlE/Hitdwgt3o47BvdtfvgboYf0b6bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820722; c=relaxed/simple;
	bh=396cnp8d3FQu1zEA8VwWklf+G0/wDbt/PqlGX/tRDuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rcATk1AoRSo/6n46bC99WFca1SikpwDBHdSHxMOk8yyDQVduc0nmMuMZZOSb2c2ETLzYE+ZahCxo6FAgyyqb9J7EQ0TZQHJP15LBfb92iG4pipzVY6DyEJTv2gd20IQbF8wp4JDGgQaHPVv2fIm5mWjGNLjDyaDxWockyT8PbT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=owsG2wyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="owsG2wyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220DEC4CEED;
	Tue,  2 Sep 2025 13:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820722;
	bh=396cnp8d3FQu1zEA8VwWklf+G0/wDbt/PqlGX/tRDuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=owsG2wyZ8FPnhw9sBVACM+G7wd0EjFbnMPRUqsSGQeZHWGCZ693kQxReM7dXr9hWd
	 YmWkvjUwNm+X9/lifkwYSYSNRgPVBSv/S7ZMyTULjFeHdIEof11FrSEPX+vmLBQbh0
	 9g4ZNZc4Pt3UBMWv2nW2FrLraBOfh8upEI700bhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brent Lu <brent.lu@intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	=?UTF-8?q?Micha=C5=82=20G=C3=B3rny?= <mgorny@gentoo.org>
Subject: [PATCH 5.10 33/34] ASoC: Intel: sof_da7219_mx98360a: fail to initialize soundcard
Date: Tue,  2 Sep 2025 15:21:59 +0200
Message-ID: <20250902131927.927344847@linuxfoundation.org>
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

From: Brent Lu <brent.lu@intel.com>

commit 0f32d9eb38c13c32895b5bf695eac639cee02d6c upstream.

The default codec for speaker amp's DAI Link is max98373 and will be
overwritten in probe function if the board id is sof_da7219_mx98360a.
However, the probe function does not do it because the board id is
changed in earlier commit.

Fixes: 1cc04d195dc2 ("ASoC: Intel: sof_da7219_max98373: shrink platform_id below 20 characters")
Signed-off-by: Brent Lu <brent.lu@intel.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210726094525.5748-1-brent.lu@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Michał Górny <mgorny@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/boards/sof_da7219_max98373.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/intel/boards/sof_da7219_max98373.c
+++ b/sound/soc/intel/boards/sof_da7219_max98373.c
@@ -404,7 +404,7 @@ static int audio_probe(struct platform_d
 		return -ENOMEM;
 
 	/* By default dais[0] is configured for max98373 */
-	if (!strcmp(pdev->name, "sof_da7219_max98360a")) {
+	if (!strcmp(pdev->name, "sof_da7219_mx98360a")) {
 		dais[0] = (struct snd_soc_dai_link) {
 			.name = "SSP1-Codec",
 			.id = 0,


