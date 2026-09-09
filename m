Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FBF569F3B;
	Wed,  9 Sep 2026 14:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963744; cv=none; b=H1MKV6opQJ0y7C/IuBALdXgC2xxHt4SR9NzsLmUiO8e4lkcUMgW3ux6rq9ksyf0rOUyfFCpxX6wBX6JuWmcPC/K/RNyX+LLhQXbYzCvh9m2Vj206aq5rXy/aPjwnUskfokAj3JWayNAekRmwpFs7x2w0oKmBTaCL/o0kTdxI4o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963744; c=relaxed/simple;
	bh=nktzoFc/+xuEU5b9evn5locQ6kreGfRW55JT9btnETA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bV9aU+DImiC6ghLKhrnIzq+J7mg9wByJQVEKq9VW2VoLQqtCouJD2BYzLFGIMxjtQ7a1B9+SQaxNyNSDijNX10qaSYAcBd/naRaSLccr73vjIVVAUPNGmSjMaandl9wA4o2UtS7Ft2bjzBeX/WI8m/V1hQA8LMsMVAl1JdLtOi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9hG5c1Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9hG5c1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446EE1F00A3D;
	Wed,  9 Sep 2026 14:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963742;
	bh=gkROX5zkhyNo/YxYwIWrgYAfpGFmtUM1SQqaK3+ltrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m9hG5c1QTupZ59AKmD5L2l8FIvdA6zf52xS3zJzCRBHhEINM7zu1tVcp4ED0PTjE2
	 vGXZYQ9z2a3IoDQ55Sl6F6m48G0qUuSTEId1WAZAQqsaSEcua11cJxGx7i3Tc9MINU
	 ufpT1tLiZJPvqTeHWNIMz1H7MhL+UCU7DvvlXXwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 185/583] ASoC: rt715-sdca: drop duplicate reg_default entries
Date: Wed,  9 Sep 2026 15:37:50 +0200
Message-ID: <20260909134244.586158285@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


