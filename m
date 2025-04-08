Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16346266B4B;
	Tue,  8 Apr 2025 10:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109755; cv=none; b=S36crt3DjSzZ5dEBD1n5RgMMZRsA4ujWemKYEB7onsp4cGZO/2j9SwuOgWHeuIWGQUuDkrg5qL1YQiDbPihvLR9NVqsAak4EVCkGS2nXiD16kxojLfN99xuIRBtaXlhm47QUZ4RrBSYUGAa4vcE+aDQ6avAI9ta8pbLK2tGyx14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109755; c=relaxed/simple;
	bh=VDROGf3s4+wg4+4AMGVtU3ScVAGU6wJQtUgPm5uqFLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPCBygIzC+HLHYutZcGVMH7eAIFKATbWoojyE8CIXF8ZFICyZfT7weblG2YgOH9Zv6dHtg+GH9H/nSgxlWxaU+1m1STGxH0N4e0FDc1OIP3CDZw756eLOdM2igLVAEXG1+RCa3W+0jYFjdtgqes4Akf77l2gBU2LnK3pF5ROHbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9LHVB9N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9LHVB9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DAD4C4CEE5;
	Tue,  8 Apr 2025 10:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109754;
	bh=VDROGf3s4+wg4+4AMGVtU3ScVAGU6wJQtUgPm5uqFLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k9LHVB9NidGmcecdMBV4nI8wNFAzUHOtgxwGW8tznzA8v+LchTcbf0IB/kYB4csGj
	 dTKG6rLP/UqDBmyLVPwS4oYFJkJsVmk+u2Q1ZmMp2Gar0rMdCB3BdWuqFcuZ4YbK1s
	 nf4BTGG0lTxsZRecJQjW96XaO4I3uHIpkQrzhHh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/227] ASoC: tas2770: Fix volume scale
Date: Tue,  8 Apr 2025 12:46:57 +0200
Message-ID: <20250408104821.580631256@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c213c8096142b..1928c1616a52d 100644
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



