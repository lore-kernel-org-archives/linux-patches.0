Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4CD569F20;
	Wed,  9 Sep 2026 13:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962316; cv=none; b=TDqqc8XFGSxCHisTHJoSXcI+/cf9xP/y6FWvr3u0BhzPDEI3Xp3t3frceHYJZ2OlWlrIvHZvUw1O50oKZUkjvVnZquuouf1H3wznOyaphiWWMD75KdohqYt2FTUkIUr8LZZdxRn1TcGlcZFyEGZJCMQZOmbStF1RHf2pC4/W76c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962316; c=relaxed/simple;
	bh=fLO+nnk+SV+zrKg+LTHPENyCtbK8NwnnrCYd5BPH3/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKhmQhanXO/hqhGM94OpOT+dmhrtHuziQkIzSDM7LIsD/xGnUe8Nli4sD1tTIrmNif4OyMQEa4qOPR72EXmx7plNyi1ebjePP8VLd6a+vNLlxsSrXMZmdF5W0VnTAQ2noGV/JdxhQ7kik7oegqfFcBy27bDY2ZzwsfSx7kR5OkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l1RQSNuY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l1RQSNuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728C51F00A3A;
	Wed,  9 Sep 2026 13:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962315;
	bh=uQcM5BR9zxZ6UQz9QPiwYtx8vkCzDfhyzcM9XOI0dHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l1RQSNuYIpPetT1p3Z0t6RSFVzTeWqErLiSgcPRSBdF8TpgA2i8cGtAF4wjZbP+n6
	 cWBOrBf2ybNBBow10QW20AuSOY0VfeZXJuGJq5CUHeiQI7dqtFxmzfqAkfCEpDEhgm
	 abtDO1/yRcX/RJil0ZeX51sf82kH58E502c0Vgjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 247/556] ASoC: rt715-sdca: drop duplicate reg_default entries
Date: Wed,  9 Sep 2026 15:38:47 +0200
Message-ID: <20260909134239.170787843@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit c9875bba469c19ad7f771b91b1e4c6f1c0f0a07d upstream.

The last two entries of rt715_reg_defaults_sdca[] repeat the ADC7_27 volume
mute controls for CH_01 and CH_02, which are already listed a few lines
above with the same value.

Drop the duplicates.  No functional change, regcache_lookup_reg() only ever
finds one of the two copies.

Fixes: 20d17057f0a8 ("ASoC: rt715-sdca: Add RT715 sdca vendor-specific driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805090240.16991-12-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt715-sdca-sdw.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/sound/soc/codecs/rt715-sdca-sdw.h
+++ b/sound/soc/codecs/rt715-sdca-sdw.h
@@ -102,10 +102,6 @@ static const struct reg_default rt715_re
 		RT715_SDCA_SMPU_TRIG_EN_CTRL, CH_00), 0x02 },
 	{ SDW_SDCA_CTL(FUN_MIC_ARRAY, RT715_SDCA_SMPU_TRIG_ST_EN,
 		RT715_SDCA_SMPU_TRIG_ST_CTRL, CH_00), 0x00 },
-	{ SDW_SDCA_CTL(FUN_MIC_ARRAY, RT715_SDCA_FU_ADC7_27_VOL,
-		RT715_SDCA_FU_MUTE_CTRL, CH_01), 0x01 },
-	{ SDW_SDCA_CTL(FUN_MIC_ARRAY, RT715_SDCA_FU_ADC7_27_VOL,
-		RT715_SDCA_FU_MUTE_CTRL, CH_02), 0x01 },
 };
 
 static const struct reg_default rt715_mbq_reg_defaults_sdca[] = {


