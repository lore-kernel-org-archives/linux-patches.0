Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAFA7DA6A;
	Wed,  5 Feb 2025 14:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766174; cv=none; b=drMeyN3RpvRSCthsz5NT8z2C5n2Evk4iEPIq2vH6TjpAn061AGO+pm9mLnFkpkGR7rPntoBFdHREwEppch9ywIMyyWthtxBLmgGRHrAF17SjXcWEb6hksgIegcqil2gVbHKgitX69mdKKqxxKkf2LUWN4gS1BetAxEdYwGJobdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766174; c=relaxed/simple;
	bh=ZaJ/aBPLBALfpgwGcq2AuA5q1tri1y3Bh+tVHGFGGPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1k9j9nW4eQObNuoUrdXoLNjztfbwZHq2M9g/B3anM6tgOpkUIlvzlYOqob82uGBRgdWhi21kiSa1rkXtYHHLZnSwBQwf/NXMIrKTaHiwEjpJ/HxZqtEky5fjAmLttH4Fdc3xqgvnBKOnr1g/M6//FWtrq9fx9WeKO2mcN3b2b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idANHfpO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idANHfpO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50570C4CED1;
	Wed,  5 Feb 2025 14:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766174;
	bh=ZaJ/aBPLBALfpgwGcq2AuA5q1tri1y3Bh+tVHGFGGPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idANHfpO0umBlR1H0XlIkRmQyExkPVTn8C000QzOvhk0lH96UNYfVc8aJ0H/QF3Zl
	 hGasnQy6FK5mz3rGGQU7XCjQYp6Yui08H4y3lBYxXy+mscPI/LSSFlc7PL2aENgbm1
	 ZvvOapfy7Af6BKIMRZEB/MqJZYU1Vk2TZRBTXDj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 249/623] ASoC: cs40l50: Use *-y for Makefile
Date: Wed,  5 Feb 2025 14:39:51 +0100
Message-ID: <20250205134505.750692767@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 3f0b8d367db5b0c0a0096b1c2ff02ec7c5c893b6 ]

We should use *-y instead of *-objs in Makefile for the module
objects.  *-objs is used rather for host programs.

Fixes: c486def5b3ba ("ASoC: cs40l50: Support I2S streaming to CS40L50")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20241203141823.22393-2-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index f37e82ddb7a10..57d3aab27d2fe 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -80,7 +80,7 @@ snd-soc-cs35l56-shared-y := cs35l56-shared.o
 snd-soc-cs35l56-i2c-y := cs35l56-i2c.o
 snd-soc-cs35l56-spi-y := cs35l56-spi.o
 snd-soc-cs35l56-sdw-y := cs35l56-sdw.o
-snd-soc-cs40l50-objs := cs40l50-codec.o
+snd-soc-cs40l50-y := cs40l50-codec.o
 snd-soc-cs42l42-y := cs42l42.o
 snd-soc-cs42l42-i2c-y := cs42l42-i2c.o
 snd-soc-cs42l42-sdw-y := cs42l42-sdw.o
-- 
2.39.5



