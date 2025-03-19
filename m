Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FC620551C;
	Wed, 19 Mar 2025 14:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395213; cv=none; b=FcTCpzN5defqQVnMLALfpKtVr6opy36ujbH34COs+HORHd3X7jhrxpNLQ1mfp/xBeEEoB5aSFS58TuZhBaF08OFfcC3F6IERsa/qJ2hdZpRhXSAL41fYvgSFk9cyE7ge3+jQoYPC66M0/09FpTNW5GppOptRHcbAlAlIE6FqEYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395213; c=relaxed/simple;
	bh=LwRMma4ZXe+D79z72hixW3cKZn5c+aurrsW8oEI/M3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWow9a71qeOzfNukqeUC+mnUEeLEF5xX2JDxiwZiD+7K7AzOlxAcm9vOtvGOOTZV/czXoWLPdVNqnhVW0AEBG5rhMVigqcJzJ2Ogh8eG9rzM8tiG51NU7+Wi2TWFnfS2PyTsHBRuauf2ibtCu3/FDQ1+26BfOJO0/RHzRFY2ZPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wa3pZehW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wa3pZehW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20ECAC4CEE4;
	Wed, 19 Mar 2025 14:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395213;
	bh=LwRMma4ZXe+D79z72hixW3cKZn5c+aurrsW8oEI/M3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wa3pZehWYriK/ACH2oGqNof4DpvIxiG5L9cpojk0SECKk2AGja/ZvDB2RxwvVl/dI
	 0e547X+iAYznC1DOYDVrXKAcm+S4ajurKVhPXYqDrIWS2qORcwyVuFYqKHmKUBYSHq
	 ftdIFaAu97yHMns7SJg0xgQ6nGADyILCscKCYKfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/166] ASoC: tas2770: Fix volume scale
Date: Wed, 19 Mar 2025 07:30:54 -0700
Message-ID: <20250319143022.268414920@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hector Martin <marcan@marcan.st>

[ Upstream commit 579cd64b9df8a60284ec3422be919c362de40e41 ]

The scale starts at -100dB, not -128dB.

Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20250208-asoc-tas2770-v1-1-cf50ff1d59a3@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2770.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tas2770.c b/sound/soc/codecs/tas2770.c
index 99bf402eb5667..5c6b825c757b3 100644
--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -508,7 +508,7 @@ static int tas2770_codec_probe(struct snd_soc_component *component)
 }
 
 static DECLARE_TLV_DB_SCALE(tas2770_digital_tlv, 1100, 50, 0);
-static DECLARE_TLV_DB_SCALE(tas2770_playback_volume, -12750, 50, 0);
+static DECLARE_TLV_DB_SCALE(tas2770_playback_volume, -10050, 50, 0);
 
 static const struct snd_kcontrol_new tas2770_snd_controls[] = {
 	SOC_SINGLE_TLV("Speaker Playback Volume", TAS2770_PLAY_CFG_REG2,
-- 
2.39.5



